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
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/styles.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';
import 'package:lixi/utils/logger.dart';

class QuestionnairePage extends HookConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionnaireProvider = ref.watch(questionsProvider);
    return Scaffold(
      body: questionnaireProvider.when(
        data: (questions) => Questionnaire(
          questions: questions,
        ),
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}

class Questionnaire extends HookConsumerWidget {
  // final List<CureMethod> cureMethods;

  const Questionnaire({
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
    final currentPage = useState(0);
    final currentStep = useState(0);
    final isDebugMode = useState(kDebugMode);

    // question index: answer index (1 for yes, 0 for no for yes/no question options)
    final answers = useState<Map<int, UserAnswer>>({});
    final selectedOptionIndexNotifier = useState<Map<int, List<int>>>({});

    final textController = useTextEditingController();
    final controller = useMemoized(
      () => QuestionControllerV2(questions: questions, ref: ref),
    );

    final dateRange = useState<List<DateTime?>>([]);

    // useEffect(() {
    //   controller.diagnose();
    //   final nextPage = controller.getNextUnansweredForDebugging();
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     if (nextPage != -1) {
    //       currentQuestionIndex.value = nextPage;
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

    bool isValidated() {
      return currentQuestions.every((question) {
        final userAnswer = answers.value[questions.indexOf(question)];
        switch (question.expectedAnsFormat) {
          case AnswerFormat.bool:
            return true;
          case AnswerFormat.date:
            return userAnswer?.dateRange?.length == 2;
          case AnswerFormat.numberText:
            return textController.text.isNotEmpty &&
                int.tryParse(textController.text) != null;
          case AnswerFormat.options:
            return (userAnswer?.selectedOptionIndex.isNotEmpty ?? false) ||
                question.canSkipChoice;
        }
      });
    }

    void resetPage() {
      currentPage.value++;
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
      final nextQuestionIndex = controller.saveAndGetNextQuestion(
        currentStep.value,
        answers.value,
      );
      if (nextQuestionIndex == -1) {
        goToResult(context);
        return;
      }
      currentStep.value = nextQuestionIndex;
      resetPage();
    }

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
                'Step ${currentPage.value + 1}',
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
                    return [
                      if (question.title != null)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            question.title!,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              color: normalColor,
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          question.questionText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: normalColor,
                          ),
                        ),
                      ),
                      const Gap(8),
                      OneQuestionWidgets(
                        question: question,
                        dateRange: dateRange,
                        textController: textController,
                        questionIndex: questionIndexInList,
                        selectedOptionIndexNotifier:
                            selectedOptionIndexNotifier,
                        onChanged: () {
                          answers.value[questionIndexInList] = UserAnswer(
                            selectedOptionIndex: selectedOptionIndexNotifier
                                    .value[questionIndexInList] ??
                                [],
                            dateRange: dateRange.value.whereNotNull().toList(),
                            text: textController.text,
                          );
                          log.info(
                            'onChanged called: $questionIndexInList ${answers.value[questionIndexInList]?.toJson()}',
                          );
                        },
                      ),
                      const Gap(24),
                    ];
                  },
                ).flatten(),
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
                    '下一題',
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
              // Text(
              //   '// ${question.reference} ($questionNumberInList)',
              // ),
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
                  controller.diagnose();
                },
                child: const Text('Diagnose'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
