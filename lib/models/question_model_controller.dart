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
  });

  final WidgetRef ref;

  DiagnosedIssue diagnosedIssue = const DiagnosedIssue(
    period: PeriodIssue.late,
    periodLength: PeriodLengthIssue.tooLong,
  );

  List<QuestionModelV2> questions;
  Map<int, UserAnswer> userAnswers = {
    0: UserAnswer(date: DateTime(2024, 3, 19)),
    1: UserAnswer(date: DateTime(2024, 1, 19)),
    // often
    2: const UserAnswer(selectedOptionIndex: [0]),
    // 最近一次月經來幾天？（經期）, short
    3: const UserAnswer(selectedOptionIndex: [1]),
    // 經量：月經期最多的一天日用衛生巾（23cm）的使用量, too much
    4: const UserAnswer(selectedOptionIndex: [2]),
    // lightDark
    5: const UserAnswer(selectedOptionIndex: [2]),
    // '黏稠', '有血塊'
    6: const UserAnswer(selectedOptionIndex: [2, 3]),
    // 你有沒有經痛的問題？
    7: const UserAnswer(selectedOptionIndex: [0]),
    // 經痛通常在什麼時候發生？(可選多項)
    8: const UserAnswer(selectedOptionIndex: [0]),
    // 怎樣的痛法？
    9: const UserAnswer(selectedOptionIndex: []),
    // // 經痛會加重或改善？
    // 10: const UserAnswer(selectedOptionIndex: []),
    // // 經期間不適
    // 11: const UserAnswer(selectedOptionIndex: []),
  };

  SharedPreferences get prefs => ref.read(sharedPreferencesProvider);

  void diagnose() {
    log.info('Diagnosing...');
    final isNormal = _diagnoseIsNormalPeriodStep1();
    final step2HaveSigns = _diagnoseForStep2HaveSigns();
    final canTell = _diagnoseForStep3CanTell();
    final painImprovement = _diagnoseForPainImprovement();
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
    int currentIndex,
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
    log.info('Current index: $currentIndex, User answers: $latestAnswers');
    if (currentIndex == questions.length - 1) {
      log.info('Ending questionnaire');
      return -1;
    }
    final currentAnswer = userAnswers[currentIndex];
    final nextQuestion = questions[currentIndex + 1];
    if (nextQuestion.isOptional) {
      switch (currentIndex + 1) {
        case 2:
          if (_diagnoseIsNormalPeriodStep1()) {
            return 3;
          } else {
            return 2;
          }
        case 6:
          if (_diagnoseForStep2HaveSigns()) {
            return 7;
          } else {
            return 6;
          }
        case 8:
          if (currentAnswer!.selectedOptionIndex.first == 0) {
            // Continue pain problems
            return 8;
          } else {
            // Skip menstruation pain problems
            return 11;
          }
        case 10:
          if (_diagnoseForStep3CanTell()) {
            return 11;
          } else {
            return 10;
          }
        case 11:
          _diagnoseForPainImprovement();
          break;
      }
    }
    if (nextQuestion.optionAdditionalStep ==
        OptionAdditionalStep.filteringByLastAnsIndex) {
      // Process for additional answer
      _processLastAnsFilterOptions(currentAnswer!, currentIndex + 1);
      return currentIndex + 1;
    }

    return currentIndex + 1;
  }

  bool _diagnoseForStep2HaveSigns() {
    final periodAmount = userAnswers[4]!.selectedOptionIndex.first;
    final colorAnswerIndex = userAnswers[5]!.selectedOptionIndex.first;
    PeriodAmountIssue? periodAmountIssue;
    periodAmountIssue = periodAmount == 0
        ? PeriodAmountIssue.tooLittle
        : periodAmount == 1
            ? null
            : PeriodAmountIssue.tooMuch;
    PeriodColor color = PeriodColor.values[colorAnswerIndex];
    diagnosedIssue = diagnosedIssue.copyWith(
      periodAmount: periodAmountIssue,
      periodColor: color,
    );
    log.info('Diagnosing for step 2...$periodAmountIssue, $color');
    if (color == PeriodColor.normal || periodAmountIssue == null) {
      return false;
    }
    if (periodAmountIssue == PeriodAmountIssue.tooMuch &&
        color == PeriodColor.lightDark) {
      return false;
    }
    return true;
  }

  bool _diagnoseForStep3CanTell() {
    final painType = userAnswers[9]?.selectedOptionIndex;
    if (painType == null || painType.isEmpty) {
      return false;
    }
    final selectedOptions =
        painType.map((e) => questions[9].options[e]).toList();
    final signs = selectedOptions
        .map((e) => menstruationPainData[e]!.split('\n'))
        .flatten()
        .distinct()
        .toList();
    final bodyTypes =
        signs.map((e) => DiagnosedBodyType.fromString(e)).toList();
    diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: bodyTypes);
    log.info('Diagnosing for step 3...$bodyTypes');
    return bodyTypes.isNotEmpty;
  }

  bool _diagnoseIsNormalPeriodStep1() {
    final lastLastPeriod = userAnswers[1]!.date!;
    final lastPeriod = userAnswers[0]!.date!;
    final periodLength = lastPeriod.difference(lastLastPeriod).inDays;
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
}
