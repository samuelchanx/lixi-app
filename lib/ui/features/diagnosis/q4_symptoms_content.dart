import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/widgets/continue_row.dart';
import 'package:lixi/ui/widgets/rounded_button_option.dart';
import 'package:lixi/ui/widgets/rounded_check.dart';
import 'package:lixi/utils/iterable_utils.dart';

const _otherOptions = [
  '發熱',
  '頭痛',
  '吐血或流鼻血',
  '大便洩瀉',
  '乳房作脹',
  '煩躁易怒，或感到抑鬱',
  '沒有',
];

class Q4SymptomsContent extends HookConsumerWidget {
  const Q4SymptomsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notApplicable = useState(false);
    final improveIndexes = useState([]);
    final otherDiscomforts = useState<List<int>>([]);
    bool isValidated() {
      return otherDiscomforts.value.isNotEmpty;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Gap(16),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            '這些情況對痛經有影響嗎？',
            style: TextStyle(
              fontSize: 24,
              color: normalColor,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: lightBackgroundPink,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Ming',
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(flex: 4, child: SizedBox()),
                        Expanded(flex: 2, child: Center(child: Text('紓緩'))),
                        Expanded(flex: 2, child: Center(child: Text('加劇'))),
                      ],
                    ),
                    const Gap(16),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: lightWhite,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Center(child: Text('按壓')),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: RoundedCheck(
                                  selected: improveIndexes.value.contains(1),
                                  onChanged: (value) {
                                    improveIndexes.value =
                                        improveIndexes.value.toggle(1).toList();
                                    notApplicable.value = false;
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: RoundedCheck(
                                  selected: improveIndexes.value.contains(2),
                                  onChanged: (value) {
                                    improveIndexes.value =
                                        improveIndexes.value.toggle(2).toList();
                                    notApplicable.value = false;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: lightWhite,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Center(child: Text('敷肚')),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: RoundedCheck(
                                  selected: improveIndexes.value.contains(0),
                                  onChanged: (value) {
                                    improveIndexes.value =
                                        improveIndexes.value.toggle(0).toList();
                                    notApplicable.value = false;
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Center(child: Text('-')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: lightWhite,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Expanded(
                              flex: 4,
                              child: Center(child: Text('血塊排出')),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: RoundedCheck(
                                  selected: improveIndexes.value.contains(3),
                                  onChanged: (value) {
                                    improveIndexes.value =
                                        improveIndexes.value.toggle(3).toList();
                                    notApplicable.value = false;
                                  },
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Center(child: Text('-')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(16),
                    InkWell(
                      onTap: () {
                        notApplicable.value = !notApplicable.value;
                        if (notApplicable.value) {
                          improveIndexes.value = [];
                        }
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color:
                              notApplicable.value ? mainPinkColor : lightWhite,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(child: Text('不適用')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(24),
        const Row(
          children: [
            Text('其他不適', style: TextStyle(fontSize: 24)),
            Gap(16),
            Text('(可選多項)', style: TextStyle(fontSize: 18)),
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 16,
                children: _otherOptions.mapIndexed((index, e) {
                  return RoundedButtonOption(
                    text: e,
                    showShadow: false,
                    onPressed: () {
                      if (index == _otherOptions.lastIndex) {
                        otherDiscomforts.value = [_otherOptions.lastIndex];
                        return;
                      }
                      otherDiscomforts.value = otherDiscomforts.value
                          .toggle(index)
                          .where((e) => e != _otherOptions.lastIndex)
                          .toList();
                    },
                    selected: otherDiscomforts.value.contains(index),
                  );
                }).toList(),
              ),
            ),
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
            final nextStep = controller.saveAndGetNextQuestion(3, {
              8: UserAnswer(selectedOptionIndex: otherDiscomforts.value),
            });
            context.go('/diagnosis?step=$nextStep');
          },
        ),
      ],
    );
  }
}
