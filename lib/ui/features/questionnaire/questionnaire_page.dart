import 'package:animate_do/animate_do.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/l10n/translations.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/provider/auth_provider.dart';
import 'package:lixi/provider/question_provider.dart';
import 'package:lixi/ui/features/questionnaire/one_question_widgets.dart';
import 'package:lixi/ui/features/registration/profile_registration_page.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/styles.dart';
import 'package:lixi/utils/logger.dart';

final questionControllerProvider = StateProvider<QuestionControllerV2>(
  (ref) => throw UnimplementedError(),
);

class QuestionnairePage extends HookConsumerWidget {
  const QuestionnairePage({
    super.key,
    this.step,
  });

  final int? step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log.info('Step from route: $step');
    final questions = ref.watch(questionsProvider);
    return Scaffold(
      body: QuestionnaireContent(
        questions: questions,
        initialStep: step,
      ),
    );
  }
}

class QuestionnaireContent extends HookConsumerWidget {
  // final List<CureMethod> cureMethods;

  const QuestionnaireContent({
    super.key,
    required this.questions,
    this.initialStep,
    // required this.cureMethods,
  });

  final int? initialStep;
  final List<QuestionModelV2> questions;

  void goToResult(BuildContext context) {
    context.go('/result');
  }

  void navigateNextStep(BuildContext context, int nextStep) {
    context.go('/questionnaire?step=$nextStep');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = initialStep ?? 0;
    final isDebugMode = useState(kDebugMode);
    useEffect(
      () => () {
        log.info('currentStep: $currentStep');
        return;
      },
      [isDebugMode.value],
    );

    // question index: answer index (1 for yes, 0 for no for yes/no question options)
    final answers = useState<Map<int, UserAnswer>>({});
    final selectedOptionIndexNotifier = useState<Map<int, List<int>>>({});

    final controller = ref.watch(questionControllerProvider);

    final dateRange = useState<List<DateTime?>>([]);

    AnimationController? animationController = useMemoized(() => null);
    final scrollController = useScrollController();
    // useEffect(() {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     if (initialStep != null) {
    //       currentStep.value = initialStep!;
    //     }
    //   });
    //   return null;
    // });

    final currentStepValue = currentStep;
    final currentQuestions = questions
        .where((element) => element.group == currentStepValue)
        .toList();
    final textControllers = List.generate(
      5,
      (index) => useTextEditingController(),
    );

    // FIXME: text controller cannot be used for multiple questions
    bool isValidated() {
      final unfinishedQuestions =
          currentQuestions.whereNotIndexed((question, index) {
        final userAnswer = answers.value[questions.indexOf(question)];
        if (question.shouldNotShow(answers.value, questions)) return true;
        final textController = textControllers[index];
        switch (question.expectedAnsFormat) {
          case AnswerFormat.bool:
            return true;
          case AnswerFormat.imageCount:
            return textController.text.isNotEmpty;
          case AnswerFormat.date:
            return userAnswer?.dateRange?.length == 2 ||
                textController.text.isNotEmpty;
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
      for (var element in textControllers) {
        element.text = '';
      }
      dateRange.value = [];
    }

    Future<void> nextQuestion([
      int? forceNextQuestionIndex,
      int? forceCurrentStep,
    ]) async {
      if (!isValidated() &&
          forceNextQuestionIndex == null &&
          forceCurrentStep == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('請回答完所有問題再繼續'),
          ),
        );
        return;
      }
      if (forceNextQuestionIndex != null && forceCurrentStep == null) {
        if (forceNextQuestionIndex == -1) {
          goToResult(context);
        } else {
          navigateNextStep(context, forceNextQuestionIndex);
          resetPage();
        }
        return;
      }
      final nextStep = controller.saveAndGetNextQuestion(
        forceCurrentStep ?? currentStep,
        answers.value,
      );
      if (nextStep == -1) {
        final finished = await showModalBottomSheet<bool>(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          isScrollControlled: true,
          backgroundColor: backgroundColor,
          context: context,
          builder: (BuildContext context) {
            return const ProfileRegistrationPage();
          },
        );
        if (ref.read(authProvider).currentUser != null &&
            context.mounted &&
            finished == true) {
          goToResult(context);
        }
        return;
      }
      log.info('Next step: $nextStep');
      scrollController.jumpTo(0);
      resetPage();
      context.go('/questionnaire?step=$nextStep');
    }

    log.info('Current step: $currentStepValue');

    return SlideInRight(
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if ((currentQuestions.first.displayIndex ?? -1) == 1)
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '第${countsChinese[currentStepValue]}步',
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: highlightColor.withOpacity(0.8),
                    ),
                  ),
                ),
              Column(
                children: [
                  ...currentQuestions.mapIndexed(
                    (index, question) {
                      final questionIndexInList = questions.indexOf(question);
                      final textController = textControllers[index];
                      return OneQuestionWidgets(
                        question: question,
                        dateRange: dateRange,
                        currentAnswers: answers,
                        textController: textController,
                        questionIndex: questionIndexInList,
                        selectedOptionIndexNotifier:
                            selectedOptionIndexNotifier,
                        onChanged: () {
                          answers.value = {
                            ...answers.value,
                            questionIndexInList: UserAnswer(
                              selectedOptionIndex: selectedOptionIndexNotifier
                                      .value[questionIndexInList] ??
                                  [],
                              dateRange: question.expectedAnsFormat ==
                                      AnswerFormat.date
                                  ? dateRange.value.whereNotNull().toList()
                                  : null,
                              text: textController.text,
                            ),
                          };
                          log.info(
                            'onChanged called: $questionIndexInList ${answers.value}',
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
                const Gap(24),
                ElevatedButton(
                  onPressed: () {
                    animationController
                        // ?..reset()
                        ?.forward(from: 0);
                    // nextQuestion(controller.getNextUnansweredForDebugging());
                  },
                  child: const Text('Go to next'),
                ),
                ElevatedButton(
                  onPressed: () => goToResult(context),
                  child: const Text('Skip to result'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentStepValue == 4) {
                      controller.diagnoseForOtherSymptoms();
                      return;
                    }
                    controller.loadTestingSet(1);
                    nextQuestion(null, 3);
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
                  },
                  child: const Text('Profile'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
