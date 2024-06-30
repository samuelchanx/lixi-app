import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/ui/widgets/app_outlined_elevated_button.dart';
import 'package:lixi/ui/widgets/continue_row.dart';
import 'package:lixi/ui/widgets/form/number_input_field.dart';
import 'package:lixi/utils/iterable_utils.dart';
import 'package:lixi/utils/logger.dart';

class Q2BloodContent extends HookConsumerWidget {
  const Q2BloodContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAnswers = ref.watch(questionControllerProvider).userAnswers;
    final useMCup = useState(userAnswers[3]?.remarks == 'mcup');
    final numberOfMGuns = useState<int?>(userAnswers[3]?.text?.toIntOrNull());
    final width = MediaQuery.of(context).size.width;
    final inputController =
        useTextEditingController(text: numberOfMGuns.value?.toString());
    final selectedColorIndex =
        useState<List<int>>(userAnswers[4]?.selectedOptionIndex ?? []);
    final textureSelection =
        useState<int?>(userAnswers[5]?.selectedOptionIndex.firstOrNull);
    final hasBloodClots = useState<bool>(
      userAnswers[5]?.selectedOptionIndex.contains(3) ?? false,
    );

    bool isValidated() {
      return numberOfMGuns.value != null &&
          selectedColorIndex.value.isNotEmpty &&
          textureSelection.value != null;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Gap(16),
        const Text(
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
                        SizedBox(
                          height: 140,
                          child: useMCup.value
                              ? Assets.images.mCup.svg()
                              : Assets.images.mGunNew.image(),
                        ),
                        const Gap(8),
                        Text(
                          useMCup.value ? '月經杯（ml）' : '日用 23cm',
                          style: const TextStyle(fontSize: 18),
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
                        Text(
                          useMCup.value
                              ? '月經最多的一天\n流量是多少？'
                              : '月經最多的一天\n使用多少塊衛生巾？',
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(12),
                        SizedBox(
                          height: 48,
                          width: width / 3,
                          child: NumberInputField(
                            controller: inputController,
                            onChanged: (text) {
                              numberOfMGuns.value = int.tryParse(text) ?? 0;
                            },
                          ),
                        ),
                        const Gap(8),
                        ActionChip(
                          onPressed: () {
                            useMCup.value = !useMCup.value;
                            numberOfMGuns.value = null;
                            inputController.clear();
                          },
                          backgroundColor: mainPinkColor,
                          side: const BorderSide(
                            width: 0,
                            color: Colors.transparent,
                          ),
                          elevation: 0,
                          label: Text(
                            useMCup.value ? '使用衞生巾' : '使用月經杯',
                            style: const TextStyle(
                              color: normalColor,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(),
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
                                        onTap: () {
                                          selectedColorIndex.value =
                                              selectedColorIndex.value
                                                  .toggle(index);
                                        },
                                        child: Container(
                                          height: 30,
                                          width: double.infinity,
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
                                          child: selectedColorIndex.value
                                                  .contains(index)
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                )
                                              : null,
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
                    Expanded(
                      child: Column(
                        children: [
                          const Gap(16),
                          const Text('質地', style: TextStyle(fontSize: 25)),
                          const Text('(可選多項)', style: TextStyle(fontSize: 18)),
                          const Gap(8),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                ...['稀', '正常', '黏稠'].mapIndexed((index, e) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: AppOutlinedElevatedButton(
                                      onPressed: () {
                                        textureSelection.value = index;
                                      },
                                      selected: textureSelection.value == index,
                                      fontSize: 16,
                                      child: Text(e),
                                    ),
                                  );
                                }),
                                const Divider(),
                                AppOutlinedElevatedButton(
                                  fontSize: 16,
                                  selected: hasBloodClots.value,
                                  onPressed: () {
                                    hasBloodClots.value = !hasBloodClots.value;
                                  },
                                  child: const Text('有血塊'),
                                ),
                              ],
                            ),
                          ),
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
        ContinueRow(
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
            final nextStep = controller.saveAndGetNextQuestion(1, {
              3: UserAnswer(
                text: numberOfMGuns.value?.toString(),
                remarks: useMCup.value ? 'mcup' : null,
              ),
              4: UserAnswer(selectedOptionIndex: selectedColorIndex.value),
              5: UserAnswer(
                selectedOptionIndex: [
                  textureSelection.value!,
                  if (hasBloodClots.value) 3,
                ],
              ),
            });
            logger.i(nextStep);
            context.go('/diagnosis?step=$nextStep');
          },
        ),
      ],
    );
  }
}
