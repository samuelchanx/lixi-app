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

class Q3PainContent extends HookConsumerWidget {
  const Q3PainContent({
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
        Column(
          children: [
            Text(
              '請選擇妳的經痛程度',
              style: TextStyle(
                fontSize: 24,
                color: normalColor,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('無\n痛'),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: double.infinity,
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 16,
                      inactiveTrackColor: Colors.transparent,
                      thumbColor: Colors.transparent,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 0.0,
                      ),
                    ),
                    child: Slider(
                      value: painLevel.value.toDouble(),
                      min: 0,
                      max: 10,
                      activeColor: mainPinkColor,
                      onChanged: (value) {
                        painLevel.value = value.toInt();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Text('劇\n痛'),
          ],
        ),
        const Gap(16),
        const Text(
          '妳何時會感到痛楚？',
          style: TextStyle(fontSize: 24),
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            '經前',
            '經期間',
            '經後',
          ].mapIndexed(
            (index, e) {
              return RoundedButtonOption(
                text: e,
                showShadow: false,
                onPressed: () {
                  whenPainIndex.value = whenPainIndex.value.toggle(index);
                },
                selected: whenPainIndex.value.contains(index),
              );
            },
          ).toList(),
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
