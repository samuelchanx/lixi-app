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
import 'package:lixi/utils/iterable_utils.dart';
import 'package:lixi/utils/logger.dart';

class Q5OtherSymptoms extends HookConsumerWidget {
  const Q5OtherSymptoms({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(questionControllerProvider);
    final questions = controller.questions;
    final options = controller.getOtherQuestions(questions[11].options);
    final otherDiscomforts = useState<List<int>>([]);
    logger.d('Q5OtherSymptoms: $options, ${controller.diagnosedIssue}');
    return Column(
      children: [
        const Gap(16),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            '請選擇其他徵狀（可選多項）',
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
                children: options.mapIndexed((index, e) {
                  return RoundedButtonOption(
                    text: e,
                    showShadow: false,
                    onPressed: () {
                      otherDiscomforts.value =
                          otherDiscomforts.value.toggle(index).toList();
                    },
                    selected: otherDiscomforts.value.contains(index),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const Gap(16),
        ContinueRow(
          onPressed: () {
            controller.saveAndGetNextQuestion(4, {
              11: UserAnswer(
                selectedOptionIndex: otherDiscomforts.value,
              ),
            });
            context.go('/registration');
          },
        ),
      ],
    );
  }
}
