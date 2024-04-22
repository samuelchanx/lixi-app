import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
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

    AnimationController? animationController = useMemoized(() => null);
    final scrollController = useScrollController();
    // useEffect(() {
    //   // controller.diagnose();
    //   const nextPage = 2;
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     if (nextPage != -1) {
    //       currentStep.value = nextPage;
    //     } else {
    //       goToResult(context);
    //     }
    //   });
    //   return null;
    // });

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
          currentStep.value = forceNextQuestionIndex;
          resetPage();
        }
        return;
      }
      final nextStep = controller.saveAndGetNextQuestion(
        forceCurrentStep ?? currentStep.value,
        answers.value,
      );
      if (nextStep == -1) {
        await showModalBottomSheet(
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
        if (ref.read(authProvider).currentUser != null && context.mounted) {
          goToResult(context);
        }
        return;
      }
      log.info('Next step: $nextStep');
      scrollController.jumpTo(0);
      currentStep.value = nextStep;
      animationController?.forward(from: 0);
      resetPage();
    }

    log.info('Current step: $currentStepValue');

    return SingleChildScrollView(
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
