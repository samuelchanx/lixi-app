import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/ui/features/questionnaire/questionnaire_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/widgets/rounded_button_option.dart';
import 'package:lixi/ui/widgets/rounded_check.dart';
import 'package:lixi/utils/iterable_utils.dart';

const _painOptions = [
  '月經不暢順',
  '絞痛',
  '長期隱隱痛',
  '感覺冰凍',
  '灼熱疼痛',
  '有固定痛點',
  '脹痛',
  '有下墜感',
  '腹部有包塊，但可推散',
  '腰部疼痛',
];

class Q4SymptomsContent extends HookConsumerWidget {
  const Q4SymptomsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final painLevel = useState(5);
    final whenPainIndex = useState<List<int>>([]);
    final painSelections = useState<List<int>>([]);
    bool isValidated() {
      return whenPainIndex.value.isNotEmpty && painSelections.value.isNotEmpty;
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
                                  selected: true,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: RoundedCheck(
                                  selected: true,
                                  onChanged: (value) {},
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
                                  selected: true,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 2,
                              child: Center(child: Text('加劇')),
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
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 4,
                            child: Center(child: Text('血塊排出')),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Checkbox(
                                value: true,
                                onChanged: (bool? value) {},
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Center(child: Text('加劇')),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: lightWhite,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('不適用')),
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
            Text('試形容妳的經痛', style: TextStyle(fontSize: 24)),
            Gap(16),
            Text('(可選多項)', style: TextStyle(fontSize: 18)),
          ],
        ),
        const Gap(16),
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
                children: _painOptions.mapIndexed((index, e) {
                  return RoundedButtonOption(
                    text: e,
                    showShadow: false,
                    onPressed: () {
                      painSelections.value = painSelections.value.toggle(index);
                    },
                    selected: painSelections.value.contains(index),
                  );
                }).toList(),
              ),
            ),
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
            final nextStep = controller.saveAndGetNextQuestion(2, {
              6: UserAnswer(
                text: painLevel.value.toString(),
              ),
              7: UserAnswer(selectedOptionIndex: whenPainIndex.value),
              8: UserAnswer(selectedOptionIndex: painSelections.value),
            });
            context.go('/diagnosis?step=$nextStep');
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
