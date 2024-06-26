import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/ui/widgets/form/number_input_field.dart';

class Q2BloodContent extends HookConsumerWidget {
  const Q2BloodContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inPeriod = useState(false);
    final dateRange = useState(<DateTime>[]);
    final regularPeriod = useState(true);
    final periodIntervalDurationInDays = useState<int?>(null);
    final usualPeriodDays = useState<int?>(null);
    final width = MediaQuery.of(context).size.width;
    bool isValidated() {
      if (inPeriod.value && usualPeriodDays.value == null) return false;
      return (dateRange.value.length == 2 ||
              (inPeriod.value && dateRange.value.length == 1)) &&
          (periodIntervalDurationInDays.value != null || !regularPeriod.value);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Gap(32),
        Text(
          '關於妳的經血',
          style: TextStyle(
            fontSize: 28,
            color: normalColor,
          ),
        ),
        const Gap(16),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              const Gap(16),
              Row(
                children: [
                  const Gap(24),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Assets.images.mGunNew.image(width: width * 0.28),
                        const Gap(8),
                        const Text(
                          '日用 23cm',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        const Text(
                          '流量',
                          style: TextStyle(fontSize: 25),
                        ),
                        const Gap(16),
                        const Text(
                          '月經最多的一天\n使用多少塊衛生巾？',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(16),
                        SizedBox(
                          height: 48,
                          width: width / 3,
                          child: NumberInputField(
                            onChanged: (text) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                ],
              ),
              const Gap(16),
              const Divider(
                color: borderColor,
                thickness: 2,
                height: 0,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Gap(16),
                          const Text('顏色', style: TextStyle(fontSize: 25)),
                          const Text('(可選多項)', style: TextStyle(fontSize: 18)),
                          const Gap(8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8.0,
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: borderColor,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  'D0A19D',
                                  'D0BEBE',
                                  'CF424B',
                                  'E73024',
                                  '820100',
                                  '790033',
                                  '3F010B',
                                ].mapIndexed((index, e) {
                                  final color = colorfromDex('FF$e');
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                index == 0 ? 30 : 0,
                                              ),
                                              topRight: Radius.circular(
                                                index == 0 ? 30 : 0,
                                              ),
                                              bottomLeft: Radius.circular(
                                                index == 6 ? 30 : 0,
                                              ),
                                              bottomRight: Radius.circular(
                                                index == 6 ? 30 : 0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (index != 6) const Divider(height: 1),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const Gap(16),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      color: borderColor,
                      width: 2,
                      thickness: 2,
                    ),
                    const Expanded(
                      child: Column(
                        children: [
                          Gap(16),
                          Text('質地', style: TextStyle(fontSize: 25)),
                          Text('(可選多項)', style: TextStyle(fontSize: 18)),
                          Gap(8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
