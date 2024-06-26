import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/widgets/rounded_button_option.dart';

class Q1PeriodContent extends HookConsumerWidget {
  const Q1PeriodContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inPeriod = useState(false);
    final dateRange = useState(<DateTime>[]);
    final regularPeriod = useState(true);
    final periodIntervalDurationInDays = useState<int?>(null);
    final usualPeriodDays = useState<int?>(null);
    bool isValidated() {
      if (inPeriod.value && usualPeriodDays.value == null) return false;
      return (dateRange.value.length == 2 ||
              (inPeriod.value && dateRange.value.length == 1)) &&
          (periodIntervalDurationInDays.value != null || !regularPeriod.value);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Gap(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '月經週期'.characters.toIterable().join('\n'),
                style: TextStyle(
                  fontSize: 24,
                  color: normalColor,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: inPeriod.value
                        ? CalendarDatePicker2Type.single
                        : CalendarDatePicker2Type.range,
                    lastDate: DateTime.now(),
                  ),
                  value: inPeriod.value
                      ? dateRange.value.take(1).toList()
                      : dateRange.value,
                  onValueChanged: (dates) {
                    dateRange.value = dates.whereNotNull().toList();
                  },
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: RoundedButtonOption(
                text: '正值經期',
                selected: inPeriod.value,
                onPressed: () {
                  inPeriod.value = !inPeriod.value;
                },
              ),
            ),
            const Gap(16),
            const Expanded(flex: 6, child: Text('請選取第一天到最後一天')),
          ],
        ),
        if (inPeriod.value)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              onChanged: (text) {
                usualPeriodDays.value = int.tryParse(text);
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
          ),
        const Gap(24),
        const Text('妳的月經規律嗎？', style: TextStyle(fontSize: 24)),
        const Gap(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedButtonOption(
              text: '規律',
              selected: regularPeriod.value,
              onPressed: () {
                regularPeriod.value = !regularPeriod.value;
              },
            ),
            RoundedButtonOption(
              text: '不規律',
              selected: !regularPeriod.value,
              onPressed: () {
                regularPeriod.value = !regularPeriod.value;
              },
            ),
          ],
        ),
        const Gap(24),
        if (regularPeriod.value)
          const Text('妳相隔多少天來一次月經？', style: TextStyle(fontSize: 24)),
        if (regularPeriod.value)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 48,
            child: TextFormField(
              onChanged: (value) {
                periodIntervalDurationInDays.value = int.tryParse(value);
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                hintText: '請輸入數字',
                hintStyle: TextStyle(fontSize: 18),
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        // QuestionnaireContent(questions: questions),
        const Gap(24),
        ElevatedButton(
          onPressed: () {
            if (!isValidated()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('請回答完所有問題再繼續'),
                ),
              );
              return;
            }

            final controller = ref.read(questionControllerProvider);
            controller.saveAndGetNextQuestion(0, {
              0: UserAnswer(
                dateRange: dateRange.value,
                text: usualPeriodDays.value?.toString(),
              ),
              1: UserAnswer(selectedOptionIndex: [inPeriod.value ? 0 : 1]),
              2: UserAnswer(
                text: periodIntervalDurationInDays.value?.toString(),
              ),
            });
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
            child: Text('繼續'),
          ),
        ),
      ],
    );
  }
}
