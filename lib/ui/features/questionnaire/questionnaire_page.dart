import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/provider/question_provider.dart';
import 'package:lixi/ui/features/questionnaire/one_question_widgets.dart';
import 'package:lixi/ui/features/registration/profile_registration_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/styles.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';
import 'package:lixi/utils/logger.dart';

final questionControllerProvider = Provider.autoDispose<QuestionControllerV2>(
  (ref) => QuestionControllerV2(
    questions: ref.watch(questionsProvider),
    ref: ref,
  ),
);

class QuestionnairePage extends HookConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    return ProviderScope(
      overrides: [
        questionControllerProvider.overrideWith(
          (ref) => QuestionControllerV2(
            questions: ref.watch(questionsProvider),
            ref: ref,
          ),
        ),
      ],
      child: Scaffold(
        body: QuestionnaireContent(
          questions: questions,
        ),
      ),
    );
  }
}

class QuestionnaireContent extends HookConsumerWidget {
  // final List<CureMethod> cureMethods;

  const QuestionnaireContent({
    super.key,
    required this.questions,
    // required this.cureMethods,
  });

  final List<QuestionModelV2> questions;

  void goToResult(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/result',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(0);
    final isDebugMode = useState(kDebugMode);

    // question index: answer index (1 for yes, 0 for no for yes/no question options)
    final answers = useState<Map<int, UserAnswer>>({});
    final selectedOptionIndexNotifier = useState<Map<int, List<int>>>({});

    final textController = useTextEditingController();
    final controller = ref.watch(questionControllerProvider);

    final dateRange = useState<List<DateTime?>>([]);

    useEffect(() {
      // controller.diagnose();
      const nextPage = 4;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (nextPage != -1) {
          currentStep.value = nextPage;
        } else {
          goToResult(context);
        }
      });
      return null;
    });

    final currentStepValue = currentStep.value;
    final currentQuestions = questions
        .where((element) => element.group == currentStepValue)
        .toList();
    // final question = currentQuestions.first;

    // FIXME: text controller cannot be used for multiple questions
    bool isValidated() {
      final unfinishedQuestions = currentQuestions.whereNot((question) {
        final userAnswer = answers.value[questions.indexOf(question)];
        if (question.shouldNotShow(answers.value, questions)) return true;
        switch (question.expectedAnsFormat) {
          case AnswerFormat.bool:
            return true;
          case AnswerFormat.imageCount:
            return textController.text.isNotEmpty;
          case AnswerFormat.date:
            return userAnswer?.dateRange?.length == 2;
          case AnswerFormat.numberText:
          case AnswerFormat.slider:
            return textController.text.isNotEmpty &&
                int.tryParse(textController.text) != null;
          case AnswerFormat.options:
          case AnswerFormat.bloodColors:
          case AnswerFormat.bloodTexture:
          case AnswerFormat.otherSymptoms:
            return (userAnswer?.selectedOptionIndex.isNotEmpty ?? false) ||
                question.canSkipChoice;
        }
      }).toList();
      log.info(
        'Unfinished questions: ${unfinishedQuestions.map((e) => questions.indexOf(e)).toList()}',
      );
      return unfinishedQuestions.isEmpty;
    }

    void resetPage() {
      textController.text = '';
      dateRange.value = [];
    }

    void nextQuestion([int? forceNextQuestionIndex]) {
      if (!isValidated() && forceNextQuestionIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('請回答完所有問題再繼續'),
          ),
        );
        return;
      }
      if (forceNextQuestionIndex != null) {
        if (forceNextQuestionIndex == -1) {
          goToResult(context);
        } else {
          currentStep.value = forceNextQuestionIndex;
          resetPage();
        }
        return;
      }
      final nextStep = controller.saveAndGetNextQuestion(
        currentStep.value,
        answers.value,
      );
      if (nextStep == -1) {
        goToResult(context);
        return;
      }
      log.info('Next step: $nextStep');
      currentStep.value = nextStep;
      resetPage();
    }

    log.info('Current step: $currentStepValue');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                isDebugMode.value = !isDebugMode.value;
              },
              child: const LixiLogo(),
            ),
            const Gap(8),
            const LixiSlogan(),
            const Gap(24),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Step ${min(currentStepValue + 1, 3)}',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: highlightColor.withOpacity(0.8),
                ),
              ),
            ),
            const Gap(16),
            Column(
              children: [
                ...currentQuestions.map(
                  (question) {
                    final questionIndexInList = questions.indexOf(question);
                    return OneQuestionWidgets(
                      question: question,
                      dateRange: dateRange,
                      currentAnswers: answers,
                      textController: textController,
                      questionIndex: questionIndexInList,
                      selectedOptionIndexNotifier: selectedOptionIndexNotifier,
                      onChanged: () {
                        answers.value = {
                          ...answers.value,
                          questionIndexInList: UserAnswer(
                            selectedOptionIndex: selectedOptionIndexNotifier
                                    .value[questionIndexInList] ??
                                [],
                            dateRange: dateRange.value.whereNotNull().toList(),
                            text: textController.text,
                          ),
                        };
                        log.info(
                          'onChanged called: $questionIndexInList ${answers.value[questionIndexInList]?.toJson()}',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const Gap(24),
            HookBuilder(
              builder: (context) {
                return ElevatedButton.icon(
                  onPressed: () {
                    nextQuestion();
                  },
                  style: elevatedButtonStyle,
                  label: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  icon: const Text(
                    '繼續',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            if (isDebugMode.value) ...[
              SizedBox(
                height: 36,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: questions.mapIndexed(
                    (index, e) {
                      return TextButton(
                        child: Text(index.toString()),
                        onPressed: () {
                          nextQuestion(index);
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: () {
                  nextQuestion(controller.getNextUnansweredForDebugging());
                },
                child: const Text('Go to next'),
              ),
              ElevatedButton(
                onPressed: () => goToResult(context),
                child: const Text('Skip to result'),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.loadTestingSet(1);
                  controller.saveAndGetNextQuestion(3, {});
                },
                child: const Text('Diagnose with test data'),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10.0)),
                    ),
                    isScrollControlled: true,
                    backgroundColor: backgroundColor,
                    context: context,
                    builder: (BuildContext context) {
                      return const ProfileRegistrationPage();
                    },
                  );

                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   '/result',
                  //   (route) => false,
                  //   arguments: controller.diagnosedIssue,
                  // );
                },
                child: const Text('Profile'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
