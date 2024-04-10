import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/database.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/provider/shared_pref_provider.dart';
import 'package:lixi/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionControllerV2 {
  QuestionControllerV2({
    required this.questions,
    required this.ref,
  }) {
    diagnosedIssue = ref.read(diagnosedIssuesProvider);
    userAnswers = ref.read(userAnswersProvider);
  }

  final Ref ref;

  DiagnosedIssue diagnosedIssue = const DiagnosedIssue();
  List<QuestionModelV2> questions;
  Map<int, UserAnswer> userAnswers = {
    /// Group 0, only for predicting menstruation cycle
    0: UserAnswer(
      dateRange: [
        DateTime(2024, 3, 19),
        DateTime(2024, 3, 23),
      ],
    ),
    // 你平常的月經規律嗎？
    1: const UserAnswer(selectedOptionIndex: [0]),
    // 一般來說，你的月經週期是多少天？
    2: const UserAnswer(text: '28'),

    /// Group 1
    // 經量：月經期最多的一天日用衛生巾（23cm）的使用量, too much
    3: const UserAnswer(text: '3'),
    // color
    4: const UserAnswer(selectedOptionIndex: [2]),
    // '黏稠', '有血塊'
    5: const UserAnswer(selectedOptionIndex: [2, 3]),

    /// Group 2
    // 請在橫線上標示你的經痛程度
    6: const UserAnswer(text: '2'),
    // 經痛通常在什麼時候發生？(可選多項)
    7: const UserAnswer(selectedOptionIndex: [0]),
    // 經痛有什麼表現？(可選多項)
    8: const UserAnswer(selectedOptionIndex: [0]),

    /// Group 3
    // 怎樣的痛法？nothing answered
    // 經痛會加重或改善？ 用溫暖的東西敷肚會改善 (optional)
    9: const UserAnswer(selectedOptionIndex: []),
    // 經期間不適
    10: const UserAnswer(selectedOptionIndex: []),
  };

  SharedPreferences get prefs => ref.read(sharedPreferencesProvider);

  void diagnose() {
    log.info('Diagnosing...');
    // Clear the previous diagnosis
    diagnosedIssue = diagnosedIssue.copyWith(
      bodyTypes: [],
    );
    // final isNormal = _diagnoseIsNormalPeriodStep1();
    final step2HaveSigns = _diagnoseForStep2Signs();
    _diagnoseWithBloodTexture();
    final canTell = diagnoseForStep3CanDetermine(
      userAnswers,
      questions,
      diagnosedIssue,
    );
    final painImprovement = _diagnoseForPainImprovement();
    // saveAndGetNextQuestion(userAnswers.keys.last, {});
    _diagnoseFinalResult();
    log.info(
      'Diagnosed: ${diagnosedIssue.toJson()}',
    );
  }

  int getNextUnansweredForDebugging() {
    final lastAnswered = userAnswers.keys.last;
    if (lastAnswered == questions.length - 1) {
      return -1;
    }
    return lastAnswered + 1;
  }

  int saveAndGetNextQuestion(
    int currentStep,
    Map<int, UserAnswer> latestAnswers,
  ) {
    userAnswers = {
      ...userAnswers,
      ...latestAnswers,
    };
    prefs.setString(
      userAnswerSaveKey,
      jsonEncode(
        userAnswers.map((key, value) => MapEntry(key.toString(), value)),
      ),
    );
    prefs.setString(
      diagnosedIssueSaveKey,
      jsonEncode(diagnosedIssue),
    );
    log.info('Current index: $currentStep, User answers: $latestAnswers');
    if (currentStep == 3) {
      log.info('Ending questionnaire, doing final diagnosis');
      diagnose();
      return -1;
    }
    return currentStep + 1;
  }

  void _diagnoseFinalResult() {
    // a
    if (diagnosedIssue.periodAmount == PeriodAmountIssue.tooLittle &&
        diagnosedIssue.periodColor == PeriodColor.lightRed &&
        (diagnosedIssue.periodTexture?.contains(PeriodTexture.sticky) ??
            false)) {
      diagnosedIssue = diagnosedIssue.copyWith(
        period: PeriodIssue.early,
        periodLength: PeriodLengthIssue.tooShort,
      );
    }
    diagnosedIssue;
  }

  void _diagnoseForPainImprovement() {
    final painImprovement = userAnswers[10]?.selectedOptionIndex;
    if (painImprovement == null || painImprovement.isEmpty) {
      return;
    }
    final selectedOptions =
        painImprovement.map((e) => questions[10].options[e]).toList();
    final signs = painImprovementData
        .mapIndexed(
          (index, map) {
            final hasSign = selectedOptions
                .where(
                  (option) => map[option] != null && map[option]!.isNotEmpty,
                )
                .isNotEmpty;
            return hasSign ? index : null;
          },
        )
        .whereNotNull()
        .map((e) => DiagnosedBodyType.values[e])
        .toList();
    diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: signs);
    log.info('Diagnosing for pain improvement...$signs');
  }

  bool _diagnoseForStep2Signs() {
    final periodAmount = int.parse(userAnswers[3]!.text!);

    PeriodAmountIssue? periodAmountIssue;
    if (periodAmount < 2) {
      periodAmountIssue = PeriodAmountIssue.tooLittle;
    } else if (periodAmount > 4) {
      periodAmountIssue = PeriodAmountIssue.tooMuch;
    }

    final colorAnswerIndexes = userAnswers[4]!.selectedOptionIndex;
    final textureAnswerIndexes = userAnswers[6]?.selectedOptionIndex;
    final colors =
        colorAnswerIndexes.map((e) => PeriodColor.values[e]).toList();
    diagnosedIssue = diagnosedIssue.copyWith(
      periodAmount: periodAmountIssue,
      periodColor: colors,
      periodTexture:
          textureAnswerIndexes?.map((e) => PeriodTexture.values[e]).toList(),
    );
    var cannotDiagnose = false;
    if ((colors.length == 1 && colors.contains(PeriodColor.normal)) ||
        periodAmountIssue == null) {
      cannotDiagnose = true;
    }
    if (periodAmountIssue == PeriodAmountIssue.tooMuch &&
        colors.contains(PeriodColor.lightDark) &&
        colors.length == 1) {
      cannotDiagnose = true;
    }
    final matchIndex = periodAmountIssue == PeriodAmountIssue.tooLittle
        ? 1
        : periodAmountIssue == PeriodAmountIssue.tooMuch
            ? 2
            : 3;
    final issuesFromMatch = colors
        .map((e) {
          final matchData = colorAmountMatchData
              .firstWhere((data) => data['color'] == e.title);
          return matchData.values.elementAt(matchIndex).split('\n');
        })
        .flatten()
        .whereNot((element) => element == 'TBC')
        .map((e) => DiagnosedBodyType.fromString(e))
        .toList();

    log.info(
      'Diagnosing for step 2...$periodAmountIssue, $colors, cannotDiagnose: $cannotDiagnose $issuesFromMatch',
    );
    return cannotDiagnose;
  }

  bool _diagnoseIsNormalPeriodStep1() {
    final lastPeriodEnd = userAnswers[0]!.dateRange!.last;
    final lastPeriodStart = userAnswers[0]!.dateRange!.first;
    final periodLength = lastPeriodEnd.difference(lastPeriodStart).inDays;
    final isNormal = periodLength >= 28 && periodLength <= 35;
    log.info('Period length: $periodLength, isNormal: $isNormal');
    if (!isNormal) {
      PeriodIssue issue;
      if (periodLength < 21) {
        issue = PeriodIssue.early;
      } else if (periodLength > 35) {
        issue = PeriodIssue.late;
      } else {
        issue = PeriodIssue.irregular;
      }
      final descriptions = questions[2].textReplaceData.split(',');
      questions[2] = questions[2].copyWith(
        transformedQuestionText: questions[2].question.replaceAll(
              '##1',
              descriptions[issue.index],
            ),
      );
      diagnosedIssue = diagnosedIssue.copyWith(period: issue);
    }
    return isNormal;
  }

  void _processLastAnsFilterOptions(UserAnswer userAnswer, int nextIndex) {
    final userAnswerIndex = userAnswer.selectedOptionIndex;
    final nextQuestion = questions[nextIndex];
    final rawOptionsForAns = nextQuestion.rawOptions
        .whereIndexed((element, index) => userAnswerIndex.contains(index))
        .map((e) => e.split(nextQuestion.optionSeparator!))
        .flatten()
        .distinct()
        .toList();
    questions[nextIndex] = nextQuestion.copyWith(
      transformedOptions: rawOptionsForAns,
    );
    log.info(
      'Processed last answer for filtering options: ${questions[nextIndex].options}',
    );
  }

  void _diagnoseWithBloodTexture() {
    // TODO: Update texture
    final textures = userAnswers[5]
            ?.selectedOptionIndex
            .map(
              (e) => PeriodTexture.values
                  .firstWhere((element) => element.answerIndex == e),
            )
            .toList() ??
        [];
    diagnosedIssue = diagnosedIssue.copyWith(periodTexture: textures);
    // TODO: Diagnose
    if (diagnosedIssue.periodAmount == PeriodAmountIssue.tooLittle) {
      // (a) 月經過少+淡紅 options
      if (diagnosedIssue.periodColor?.contains(PeriodColor.lightRed) ?? false) {
        if (textures.contains(PeriodTexture.sticky)) {
          diagnosedIssue = diagnosedIssue.copyWith(
            bodyTypes: [DiagnosedBodyType.spleenYangNotGoodDamp],
          );
        }
        if (textures.contains(PeriodTexture.dilute)) {
          diagnosedIssue = diagnosedIssue.copyWith(
            bodyTypes: [
              DiagnosedBodyType.liverDeficiencyAndLittleBlood,
              DiagnosedBodyType.bloodDeficiency,
              DiagnosedBodyType.bloodyColdVirtual,
            ],
          );
        }
      }
      
      return;
    }
  }
}

(DiagnosedIssue, bool) diagnoseForStep3CanDetermine(
  Map<int, UserAnswer> userAnswers,
  List<QuestionModelV2> questions,
  DiagnosedIssue diagnosedIssue,
) {
  if (userAnswers[6]?.text == '0') {
    // 無痛
    return (diagnosedIssue, false);
  }
  final painTypeIndexes = userAnswers[8]?.selectedOptionIndex;
  if (painTypeIndexes == null || painTypeIndexes.isEmpty) {
    // No options selected
    return (diagnosedIssue, false);
  }

  final lastAnsIndexes = userAnswers[7]!.selectedOptionIndex;
  final selectedOptionsInText = painTypeIndexes
      .map((e) => questions[8].optionsByLastAnsIndex(lastAnsIndexes)[e])
      .toList();
  final signs = selectedOptionsInText
      .map((e) => menstruationPainData[e]!.split('\n'))
      .flatten()
      .distinct()
      .toList();
  final bodyTypes = signs.map((e) => DiagnosedBodyType.fromString(e)).toList();
  diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: bodyTypes);
  log.info('Diagnosing for step 3...$bodyTypes');
  return (diagnosedIssue, bodyTypes.isNotEmpty);
}
