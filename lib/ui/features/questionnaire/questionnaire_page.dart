import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/provider/question_provider.dart';
import 'package:lixi/ui/theme/colors.dart';
import 'package:lixi/ui/theme/styles.dart';
import 'package:lixi/ui/theme/theme_data.dart';
import 'package:lixi/ui/widgets/lixi_logo.dart';
import 'package:lixi/ui/widgets/lixi_slogan.dart';
import 'package:lixi/utils/date_formatter.dart';
import 'package:lixi/utils/iterable_utils.dart';

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
    final currentQuestionIndex = useState(0);
    final isDebugMode = useState(kDebugMode);

    // question index: answer index (1 for yes, 0 for no for yes/no question options)
    final answers = useState<Map<int, UserAnswer>>({});
    final selectedOptionIndexNotifier = useState<List<int>>([]);

    final dateTextController = useTextEditingController();
    final controller = useMemoized(
      () => QuestionControllerV2(questions: questions, ref: ref),
    );

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

    final currentQuesIndex = currentQuestionIndex.value;
    final question = questions[currentQuesIndex];
    final options = question.options;

    bool isValidated() {
      switch (question.expectedAnsFormat) {
        case AnswerFormat.bool:
          return true;
        case AnswerFormat.date:
          return dateTextController.text.isNotEmpty;
        case AnswerFormat.options:
          return selectedOptionIndexNotifier.value.isNotEmpty ||
              question.canSkipChoice;
      }
    }

    void resetPage() {
      currentPage.value++;
      dateTextController.text = '';
      selectedOptionIndexNotifier.value = [];
    }

    void nextQuestion(List<int> answerIndex, [int? forceNextQuestionIndex]) {
      if (!isValidated() && forceNextQuestionIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer the question'),
          ),
        );
        return;
      }
      answers.value[currentQuestionIndex.value] = UserAnswer(
        selectedOptionIndex: answerIndex,
        date: dateTextController.text.isNotEmpty
            ? dateTextController.text.toDateTime()
            : null,
      );
      if (forceNextQuestionIndex != null) {
        if (forceNextQuestionIndex == -1) {
          goToResult(context);
        } else {
          currentQuestionIndex.value = forceNextQuestionIndex;
          resetPage();
        }
        return;
      }
      final nextQuestionIndex = controller.saveAndGetNextQuestion(
        currentQuestionIndex.value,
        answers.value,
      );
      if (nextQuestionIndex == -1) {
        goToResult(context);
        return;
      }
      currentQuestionIndex.value = nextQuestionIndex;
      resetPage();
    }

    final questionNumberInList = questions.indexOf(question);

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
                'Q${currentPage.value + 1}',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: highlightColor.withOpacity(0.8),
                ),
              ),
            ),
            const Gap(16),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                question.questionText,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                  color: highlightColor,
                ),
              ),
            ),
            const Gap(24),
            if (question.expectedAnsFormat == AnswerFormat.date) ...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: '選擇日期',
                  labelStyle: TextStyle(
                    color: highlightColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: highlightColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: highlightColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: dateTextController,
                readOnly: true,
                onTap: () async {
                  final now = DateTime.now();
                  final results = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now.subtract(const Duration(days: 365 * 20)),
                    lastDate: DateTime.now(),
                  );
                  if (results == null) return;
                  dateTextController.text = results.yearMonthDay;
                },
              ),
              const Gap(24),
            ],
            if (question.expectedAnsFormat == AnswerFormat.options)
              HookBuilder(
                builder: (context) {
                  final selectedIndex =
                      useValueListenable(selectedOptionIndexNotifier);
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: options.mapIndexed(
                      (index, option) {
                        final selected = selectedIndex.contains(index);
                        Color? color;
                        String? transformedText;
                        if (question.optionAdditionalStep ==
                            OptionAdditionalStep.colorParser) {
                          color = colorfromDex(
                            'FF${option.split('(').last.split(')').first.replaceAll('#', '')}',
                          );
                          transformedText = option.split('(').first;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (question.isMultipleChoice) {
                                selectedOptionIndexNotifier.value =
                                    selectedOptionIndexNotifier.value
                                        .toggle(index);
                              } else {
                                selectedOptionIndexNotifier.value = [
                                  index,
                                ];
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selected
                                  ? highlightColor
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8,
                              ),
                              shadowColor: Colors.transparent,
                              side: BorderSide(
                                color: highlightColor,
                                width: 1,
                              ),
                              shape: const StadiumBorder(),
                              surfaceTintColor: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    transformedText ?? option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selected
                                          ? Colors.white
                                          : highlightColor,
                                    ),
                                  ),
                                  if (color != null) ...[
                                    const Gap(16),
                                    Container(
                                      color: color,
                                      width: 24,
                                      height: 12,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            const Gap(24),
            HookBuilder(
              builder: (context) {
                return ElevatedButton.icon(
                  onPressed: () {
                    nextQuestion(selectedOptionIndexNotifier.value);
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
              Text(
                '// ${question.reference} ($questionNumberInList)',
              ),
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
                          nextQuestion([], index);
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: () {
                  nextQuestion([], controller.getNextUnansweredForDebugging());
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
