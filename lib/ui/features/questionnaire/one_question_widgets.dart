import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/provider/question_provider.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/utils/date_formatter.dart';
import 'package:lixi/utils/iterable_utils.dart';

class OneQuestionWidgets extends HookConsumerWidget {
  const OneQuestionWidgets({
    super.key,
    required this.question,
    required this.dateRange,
    required this.textController,
    required this.selectedOptionIndexNotifier,
    required this.onChanged,
    required this.questionIndex,
    required this.currentAnswers,
  });
  final ValueNotifier<Map<int, UserAnswer>> currentAnswers;
  final int questionIndex;
  final ValueNotifier<List<DateTime?>> dateRange;
  final Function() onChanged;
  final QuestionModelV2 question;
  final ValueNotifier<Map<int, List<int>>> selectedOptionIndexNotifier;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = useMemoized(() => MediaQuery.of(context).size.width);
    final sliderValue = useState(5.0);
    final imageRowsToShow = useState(1);
    final currentImageCount = useState<int?>(null);
    final controller = ref.watch(questionControllerProvider);
    final inPeriodCheck = useState(false);
    return HookBuilder(
      builder: (context) {
        final answers = useValueListenable(currentAnswers);
        final shouldNotShow = question.shouldNotShow(
          answers,
          ref.read(questionsProvider),
        );
        if (shouldNotShow) {
          return const SizedBox.shrink();
        }
        Widget widget;
        switch (question.expectedAnsFormat) {
          case AnswerFormat.imageCount:
            final imagesToShow = question.imagesToShow!;
            widget = Column(
              children: [
                ...List.generate(imageRowsToShow.value, (column) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        question.imagesToShow!,
                        (index) {
                          final imageIndex = column * imagesToShow + index;
                          final isSelected = currentImageCount.value != null &&
                              currentImageCount.value! >= imageIndex;
                          return InkWell(
                            onTap: () {
                              textController.text = (imageIndex + 1).toString();
                              currentImageCount.value = imageIndex;
                              onChanged();
                            },
                            child: SvgPicture.asset(
                              question.image!,
                              color: isSelected ? Colors.red : null,
                              width: width / 6,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
                IconButton(
                  onPressed: () {
                    imageRowsToShow.value++;
                  },
                  iconSize: 32,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            );
            break;
          case AnswerFormat.bool:
            widget = const SizedBox();
            break;
          case AnswerFormat.date:
            widget = Column(
              children: [
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: inPeriodCheck.value
                        ? CalendarDatePicker2Type.single
                        : CalendarDatePicker2Type.range,
                    lastDate: DateTime.now(),
                  ),
                  value: inPeriodCheck.value
                      ? dateRange.value.take(1).toList()
                      : dateRange.value,
                  onValueChanged: (dates) {
                    dateRange.value = dates;
                    onChanged();
                  },
                ),
                if (dateRange.value.length == 2 && !inPeriodCheck.value)
                  Text(
                    '${dateRange.value.first!.yearMonthDay} - ${dateRange.value.last?.yearMonthDay}',
                  ),
                Row(
                  children: [
                    Checkbox(
                      value: inPeriodCheck.value,
                      onChanged: (val) {
                        inPeriodCheck.value = val!;
                        onChanged();
                      },
                    ),
                    const Expanded(
                      child: Text('正值經期（請在日曆中劃出本次月經的第一天）'),
                    ),
                  ],
                ),
                if (inPeriodCheck.value)
                  TextFormField(
                    controller: textController,
                    onChanged: (text) {
                      onChanged();
                    },
                    decoration: const InputDecoration(
                      labelText: '一般來說，你的月經期有多少天？',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[1-9][0-9]*'),
                      ),
                    ],
                    keyboardType: TextInputType.number,
                  ),
              ],
            );
            break;
          case AnswerFormat.numberText:
            widget = TextFormField(
              controller: textController,
              onChanged: (text) {
                onChanged();
              },
              decoration: const InputDecoration(
                labelText: '請輸入數字',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^[1-9][0-9]*'),
                ),
              ],
              keyboardType: TextInputType.number,
            );
            break;
          case AnswerFormat.options:
          case AnswerFormat.otherSymptoms:
            var options = question.options;
            if (question.optionAdditionalStep ==
                OptionAdditionalStep.filteringByLastAnsIndex) {
              options = question.optionsByLastAnsIndex(
                answers[questionIndex - 1]?.selectedOptionIndex ?? [],
              );
            }
            if (question.expectedAnsFormat == AnswerFormat.otherSymptoms) {
              options = controller.getOtherQuestions(question.options);
            }
            final skipChoiceKeyword = question.skipChoiceKeyword;

            widget = HookBuilder(
              builder: (context) {
                final optionsAnsMap =
                    useValueListenable(selectedOptionIndexNotifier);
                final isHorizontal = question.horizontalOption == true;
                if (isHorizontal) {
                  return Row(
                    children: options.mapIndexed((index, e) {
                      final selected =
                          optionsAnsMap[questionIndex]?.contains(index) ??
                              false;
                      return Expanded(
                        child: Row(
                          children: [
                            Checkbox(
                              value: selected,
                              onChanged: (val) {
                                selectedOptionIndexNotifier.value = {
                                  ...optionsAnsMap,
                                  questionIndex: <int>[
                                    if (question.isMultipleChoice)
                                      ...optionsAnsMap[questionIndex] ?? [],
                                  ].toggle(index),
                                };
                                onChanged();
                              },
                            ),
                            Text(e),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: options
                      .append(
                    skipChoiceKeyword == null ? [] : [skipChoiceKeyword],
                  )
                      .mapIndexed<Widget>(
                    (index, option) {
                      final selected =
                          optionsAnsMap[questionIndex]?.contains(index) ??
                              false;
                      Color? color;
                      String? transformedText;
                      if (question.optionAdditionalStep ==
                          OptionAdditionalStep.colorParser) {
                        color = colorfromDex(
                          'FF${option.split('(').last.split(')').first.replaceAll('#', '')}',
                        );
                        transformedText = option.split('(').first;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (option == skipChoiceKeyword) {
                              selectedOptionIndexNotifier.value = {
                                ...optionsAnsMap,
                                questionIndex: [options.length],
                              };
                              onChanged();
                              return;
                            }
                            selectedOptionIndexNotifier.value = {
                              ...optionsAnsMap,
                              questionIndex: <int>[
                                if (question.isMultipleChoice)
                                  ...optionsAnsMap[questionIndex] ?? [],
                              ]
                                  .whereNot(
                                    (index) => index == options.length,
                                  )
                                  .toggle(index),
                            };
                            onChanged();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selected ? highlightColor : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8,
                            ),
                            shadowColor: Colors.transparent,
                            side: BorderSide(
                              color: highlightColor,
                              width: 1,
                            ),
                            shape: const StadiumBorder(),
                            surfaceTintColor: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  transformedText ?? option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selected
                                        ? Colors.white
                                        : highlightColor,
                                  ),
                                ),
                                if (color != null) ...[
                                  const Gap(16),
                                  Container(
                                    color: color,
                                    width: 24,
                                    height: 12,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).append(
                    [
                      if (question.showOtherInputOption)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          child: TextFormField(
                            controller: textController,
                            onChanged: (text) {
                              onChanged();
                            },
                            decoration: const InputDecoration(
                              labelText: '其他',
                            ),
                          ),
                        ),
                    ],
                  ).toList(),
                );
              },
            );
            break;
          case AnswerFormat.bloodColors:
            final colors = question.options.first
                .split('、')
                .map((e) => e.split('#').last.slice(0, -2))
                .toList();
            widget = HookBuilder(
              builder: (context) {
                final optionsAnsMap =
                    useValueListenable(selectedOptionIndexNotifier);
                final selectedOption = optionsAnsMap[questionIndex];
                return Row(
                  children: List.generate(7, (index) {
                    final selected = selectedOption?.contains(index) ?? false;
                    return Expanded(
                      child: InkWell(
                        onTap: () {
                          selectedOptionIndexNotifier.value = {
                            ...optionsAnsMap,
                            questionIndex: <int>[
                              if (question.isMultipleChoice)
                                ...optionsAnsMap[questionIndex] ?? [],
                            ].toggle(index),
                          };
                          onChanged();
                        },
                        child: Container(
                          height: 128,
                          decoration: BoxDecoration(
                            color: colorfromDex('FF${colors[index]}'),
                          ),
                          child: selected
                              ? Icon(
                                  Icons.check_circle,
                                  color: normalColor,
                                )
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
            break;
          case AnswerFormat.bloodTexture:
            final textures = question.options;
            widget = HookBuilder(
              builder: (context) {
                final optionsAnsMap =
                    useValueListenable(selectedOptionIndexNotifier);
                final selectedOption = optionsAnsMap[questionIndex];
                return Row(
                  children: textures.mapIndexed((index, element) {
                    final selected = selectedOption?.contains(index) ?? false;
                    final shouldGreyOut = index <= 2 &&
                        selectedOption?.any((element) => element <= 2) ==
                            true &&
                        selectedOption?.contains(index) == false;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            final currentSelectedOptions =
                                optionsAnsMap[questionIndex] ?? [];
                            selectedOptionIndexNotifier.value = {
                              ...optionsAnsMap,
                              questionIndex: <int>[
                                ...currentSelectedOptions.where(
                                  (element) => element > 2 || index > 2,
                                ),
                              ].toggle(index),
                            };
                            onChanged();
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: selected
                                    ? highlightColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/texture_${index + 1}.png',
                                    color: shouldGreyOut ? Colors.grey : null,
                                  ),
                                  const Gap(8),
                                  Text(
                                    textures[index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: highlightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
            break;
          case AnswerFormat.slider:
            final options = question.options;

            widget = HookBuilder(
              builder: (context) {
                return Row(
                  children: [
                    Text(options.first),
                    Expanded(
                      child: Slider(
                        value: sliderValue.value,
                        onChanged: (value) {
                          textController.text = value.round().toString();
                          sliderValue.value = value.roundToDouble();
                          onChanged();
                        },
                        min: 0,
                        max: 10,
                      ),
                    ),
                    Text(options.last),
                  ],
                );
              },
            );
            break;
        }

        return Column(
          children: [
            if (question.title != null && question.title!.isNotEmpty)
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${question.displayIndex}. ${question.title!}',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: normalColor,
                  ),
                ),
              ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                question.questionText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: normalColor,
                ),
              ),
            ),
            const Gap(8),
            widget,
            const Gap(24),
          ],
        );
      },
    );
  }
}
