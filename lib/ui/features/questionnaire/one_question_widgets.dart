import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/utils/date_formatter.dart';
import 'package:lixi/utils/iterable_utils.dart';

class OneQuestionWidgets extends HookWidget {
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
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
        final answers = useValueListenable(currentAnswers);
        if (question.shouldNotShow(answers)) {
          return const SizedBox.shrink();
        }
        Widget widget;
        switch (question.expectedAnsFormat) {
          case AnswerFormat.bool:
            widget = const SizedBox();
            break;
          case AnswerFormat.date:
            widget = Column(
              children: [
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.range,
                    lastDate: DateTime.now(),
                  ),
                  value: dateRange.value,
                  onValueChanged: (dates) {
                    dateRange.value = dates;
                    onChanged();
                  },
                ),
                if (dateRange.value.length == 2)
                  Text(
                    '${dateRange.value.first!.yearMonthDay} - ${dateRange.value.last?.yearMonthDay}',
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
            final options = question.options;
            widget = HookBuilder(
              builder: (context) {
                final optionsAnsMap =
                    useValueListenable(selectedOptionIndexNotifier);
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: options.mapIndexed(
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
                            selectedOptionIndexNotifier.value = {
                              ...optionsAnsMap,
                              questionIndex: <int>[
                                if (question.isMultipleChoice)
                                  ...optionsAnsMap[questionIndex] ?? [],
                              ].toggle(index),
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
                  ).toList(),
                );
              },
            );
            break;
        }

        return Column(
          children: [
            if (question.title != null)
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  question.title!,
                  style: TextStyle(
                    fontSize: 28.0,
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
