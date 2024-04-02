import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/utils/iterable_utils.dart';

class OneQuestionWidgets extends StatelessWidget {
  const OneQuestionWidgets({
    super.key,
    required this.question,
    required this.dateRange,
    required this.textController,
    required this.selectedOptionIndexNotifier,
    required this.onChanged,
    required this.questionIndex,
  });

  final int questionIndex;
  final ValueNotifier<List<DateTime?>> dateRange;
  final Function() onChanged;
  final QuestionModelV2 question;
  final ValueNotifier<Map<int, List<int>>> selectedOptionIndexNotifier;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    if (question.expectedAnsFormat == AnswerFormat.date) {
      return CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.range,
        ),
        value: dateRange.value,
        onValueChanged: (dates) {
          dateRange.value = dates;
          onChanged();
        },
      );
    }
    if (question.expectedAnsFormat == AnswerFormat.numberText) {
      return TextFormField(
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
    }
    if (question.expectedAnsFormat == AnswerFormat.options) {
      final options = question.options;
      return HookBuilder(
        builder: (context) {
          final optionsAnsMap = useValueListenable(selectedOptionIndexNotifier);
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: options.mapIndexed(
              (index, option) {
                final selected =
                    optionsAnsMap[questionIndex]?.contains(index) ?? false;
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
                              color: selected ? Colors.white : highlightColor,
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
    }

    return const Text('Unknown format');
  }
}
