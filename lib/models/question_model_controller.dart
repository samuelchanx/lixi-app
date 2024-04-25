import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/database.dart';
import 'package:lixi/models/question_model_v2.dart';
import 'package:lixi/provider/shared_pref_provider.dart';
import 'package:lixi/testing_db.dart';
import 'package:lixi/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionControllerV2 {
  QuestionControllerV2({
    required this.questions,
    required this.ref,
  });

  final Ref ref;

  /// Formula for Result page (prediction of period)
  /// (i) 月經期 = [(1st day of last menstruation date + Q3 (月經週期))
  /// to (1st day of last menstruation date + Q3 (月經週期)
  /// + (last day of last menstruation date -first day of last menstruation date)]
  /// (ii) 經後期 =  [ (1st day of last menstruation date + Q3 (月經週期) +
  ///  (last day of last menstruation date -first day of last menstruation date) + 1
  /// to (1st day of last menstruation date + Q3 (月經週期) +
  /// (last day of last menstruation date -first day of last menstruation date) + 5 ]
  /// (iii) 排卵期 = [ + 6 + 12]
  /// (iv) 經前期 =  + 13 to + 21]
  (List<DateTime>, List<DateTime>, List<DateTime>, List<DateTime>)
      getPeriodPrediction() {
    final firstDayOfLastMenstruation = userAnswers[0]!.dateRange!.first;
    log.info('First day of last menstruation: ${userAnswers[0]}');
    final lastDayOfLastMenstruation = userAnswers[0]!.dateRange?.lastOrNull ??
        firstDayOfLastMenstruation.add(
          Duration(days: userAnswers[0]!.text!.toInt()),
        );
    final lastPeiodDuration =
        lastDayOfLastMenstruation.difference(firstDayOfLastMenstruation);
    final periodCycleLength = int.parse(userAnswers[2]!.text!);
    final periodLastDay =
        firstDayOfLastMenstruation + periodCycleLength.days + lastPeiodDuration;
    final period = [
      firstDayOfLastMenstruation + periodCycleLength.days,
      periodLastDay,
    ];
    final postPeriod = [
      periodLastDay + 1.days,
      periodLastDay + 5.days,
    ];
    final ovulutionPeriod = [
      periodLastDay + 6.days,
      periodLastDay + 12.days,
    ];
    final prePeriod = [
      periodLastDay + 13.days,
      periodLastDay + 21.days,
    ];
    return (period, postPeriod, ovulutionPeriod, prePeriod);
  }

  DiagnosedIssue get diagnosedIssue => ref.read(diagnosedIssuesProvider);
  List<QuestionModelV2> questions;
  Map<int, UserAnswer> get userAnswers => ref.read(userAnswersProvider);
  set userAnswers(Map<int, UserAnswer> ans) {
    ref.read(userAnswersProvider.notifier).update((state) => ans);
  }

  set diagnosedIssue(DiagnosedIssue issue) {
    ref.read(diagnosedIssuesProvider.notifier).update((state) => issue);
  }

  // Map<int, UserAnswer> userAnswers = {
  //   /// Group 0, only for predicting menstruation cycle
  //   0: UserAnswer(
  //     dateRange: [
  //       DateTime(2024, 3, 19),
  //       DateTime(2024, 3, 23),
  //     ],
  //   ),
  //   // 你平常的月經規律嗎？
  //   1: const UserAnswer(selectedOptionIndex: [0]),
  //   // 一般來說，你的月經週期是多少天？
  //   2: const UserAnswer(text: '28'),

  //   /// Group 1
  //   // 經量：月經期最多的一天日用衛生巾（23cm）的使用量, too much
  //   3: const UserAnswer(text: '3'),
  //   // color
  //   4: const UserAnswer(selectedOptionIndex: [2]),
  //   // '黏稠', '有血塊'
  //   5: const UserAnswer(selectedOptionIndex: [2, 3]),

  //   /// Group 2
  //   // 請在橫線上標示你的經痛程度
  //   6: const UserAnswer(text: '2'),
  //   // 經痛通常在什麼時候發生？(可選多項)
  //   7: const UserAnswer(selectedOptionIndex: [0]),
  //   // 怎樣的痛法？(可選多項）(based on (2))
  //   8: const UserAnswer(selectedOptionIndex: [0]),

  //   /// Group 3
  //   // 經痛會加重或改善？ 用溫暖的東西敷肚會改善 (optional)
  //   9: const UserAnswer(selectedOptionIndex: []),
  //   // 經期間不適
  //   10: const UserAnswer(selectedOptionIndex: []),
  // };

  List<DiagnosedBodyType> get currentBodyTypes =>
      diagnosedIssue.bodyTypes ?? [];

  bool get onlyOneBodyTypeOrDiagnosed =>
      diagnosedIssue.bodyTypes?.length == 1 ||
      diagnosedIssue.diagnosedStep != null;

  SharedPreferences get prefs => ref.read(sharedPreferencesProvider);
  int get q6MenstruationPainLevel => int.parse(userAnswers[6]!.text!);
  List<PeriodTexture> get textures => diagnosedIssue.periodTexture ?? [];

  bool diagnose() {
    log.info('Diagnosing... user answers: $userAnswers');
    // Clear the previous diagnosis
    diagnosedIssue = diagnosedIssue.copyWith(
      bodyTypes: [],
    );
    _diagnoseForStep1Signs();

    final canDiagnose = _diagnoseForStep2();
    log.info(
      'Diagnosed... ${diagnosedIssue.bodyTypes} $canDiagnose ${canDiagnose ? diagnosedIssue.diagnosedStep : ''}',
    );
    return canDiagnose;
  }

  void diagnoseForOtherSymptoms() {
    final userSymptomOptions = getOtherQuestions(questions[11].options);
    final selectedIndexes = userAnswers[11]?.selectedOptionIndex;
    final selectedOptions = selectedIndexes
            ?.map((e) => userSymptomOptions[e])
            .whereNotNull()
            .toList() ??
        [];
    log.info('Selected indexes: $selectedIndexes, $selectedOptions');
    final finalBodyTypes = otherSymptomsData
        .where((element) => selectedOptions.any((so) => element[so] == 'T'))
        .map((e) => DiagnosedBodyType.fromString(e['BodyType']!))
        .where((element) => diagnosedIssue.bodyTypes!.contains(element))
        .toList();
    log.info('Diagnosing for other symptoms...$finalBodyTypes');
    diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: finalBodyTypes);
  }

  List<DiagnosedBodyType> filterBodyTypesByData(
    List<Map<String, String>> data,
    bool Function(int, Map<String, String>) filter,
    List<DiagnosedBodyType> currentBodyTypes,
  ) {
    final filteredTypes = data
        .mapIndexed(
          (index, map) {
            if (filter(index, map)) {
              return index;
            }
          },
        )
        .whereNotNull()
        .map((e) => DiagnosedBodyType.values[e])
        .toList();
    if (filteredTypes.isEmpty) {
      log.info('No body types found for filtering, reverting to fallback');
      return currentBodyTypes;
    }
    return filteredTypes;
  }

  int getNextUnansweredForDebugging() {
    final lastAnswered = userAnswers.keys.last;
    if (lastAnswered == questions.length - 1) {
      return -1;
    }
    return lastAnswered + 1;
  }

  List<String> getOtherQuestions(List<String> allSymptoms) {
    final userBodyTypes = diagnosedIssue.bodyTypes ??
        [
          DiagnosedBodyType.kidneyQiDeficiency,
          DiagnosedBodyType.kidneyYinDeficiency,
        ];
    final otherQuestionUserSymptoms = otherSymptomsData.where((element) {
      final bodyType = DiagnosedBodyType.fromString(element['BodyType']!);
      return userBodyTypes.contains(bodyType);
    }).toList();
    allSymptoms = allSymptoms
        .where(
          (sym) => otherQuestionUserSymptoms
              .any((userBodyTypeSyms) => userBodyTypeSyms[sym] == 'T'),
        )
        .toList();

    return allSymptoms;
  }

  void loadTestingSet(int index) {
    final data = testingData[index];
    userAnswers = _prepareQuestions(data);
  }

  int saveAndGetNextQuestion(
    int currentStep,
    Map<int, UserAnswer> latestAnswers,
  ) {
    userAnswers = {
      ...userAnswers,
      ...latestAnswers,
    };
    log.info('userAnswerssaving, $userAnswers');
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
      final canDiagnose = diagnose();
      if (!canDiagnose) {
        return 4;
      }
      return -1;
    }
    if (currentStep == 4) {
      // TODO: Diagnose for final other questions
      diagnoseForOtherSymptoms();
      return -1;
    }
    return currentStep + 1;
  }

  void startTest() {
    final testingIndexes = [2];
    // final testingIndexes = List.generate(15, (index) => index);
    final testingResults = <(Map<int, UserAnswer>, DiagnosedIssue, int)>[];
    for (var element in testingIndexes) {
      log.info('Testing for index $element');
      final data = testingData[element];
      diagnosedIssue = const DiagnosedIssue();

      userAnswers = _prepareQuestions(data);
      diagnose();
      testingResults.add(
        (userAnswers, diagnosedIssue, element),
      );
    }
    testingResults.forEachIndexed((element, index) {
      log.info(
        'Testing result for index ${element.$3 + 1}: ${element.$2.bodyTypes!.map((e) => e.title)}',
      );
    });
  }

  List<DiagnosedBodyType> _diagnoseForPainImprovement() {
    final painImprovement = userAnswers[9]?.selectedOptionIndex;
    if (painImprovement == null || painImprovement.isEmpty) {
      return [];
    }
    final selectedOptions = painImprovement
        .map((e) => questions[9].options.elementAtOrNull(e))
        .whereNotNull()
        .toList();
    log.info('Selected options for pain improvement: $selectedOptions');
    final signs = painImprovementData
        .mapIndexed(
          (index, map) {
            final hasSign = selectedOptions
                .where(
                  (option) =>
                      map[option] != null && (map[option]?.isNotEmpty ?? false),
                )
                .isNotEmpty;
            return hasSign ? index : null;
          },
        )
        .whereNotNull()
        .map((e) => DiagnosedBodyType.values[e])
        .where((element) => diagnosedIssue.bodyTypes!.contains(element))
        .toList();
    log.info('Diagnosing for pain improvement...$signs');
    return signs;
  }

  bool _diagnoseForStep1Signs() {
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
              .firstWhere((data) => data['color'] == e.name);
          return matchData.values.elementAt(matchIndex).split('\n');
        })
        .flatten()
        .whereNot((element) => element == 'TBC' || element.trim().isEmpty)
        .map((e) => DiagnosedBodyType.fromString(e))
        .toList();
    if (issuesFromMatch.isEmpty) {
      issuesFromMatch.addAll(DiagnosedBodyType.values);
    }
    diagnosedIssue = diagnosedIssue.copyWith(
      bodyTypes: issuesFromMatch,
    );
    log.info(
      'Diagnosing for step 2...$periodAmountIssue, $colors, cannotDiagnose: $cannotDiagnose $issuesFromMatch',
    );
    return issuesFromMatch.length == 1 && !cannotDiagnose;
  }

  /// Can ignore this table just follow the orders:
  /// 1. Textures,
  /// 2. have m pain?
  /// 3. when have pain
  /// 4. how is the pain
  /// 5. improve?
  /// Only for 經痛有 (option b) need both
  bool _diagnoseForStep2() {
    if (diagnosedIssue.bodyTypes?.length == 1) {
      // Done with diagnosis
      diagnosedIssue = diagnosedIssue.copyWith(diagnosedStep: 0);
      log.info('Diagnosed at step 1, ${diagnosedIssue.bodyTypes}');
      return true;
    }

    final userTextures = _setTexturesData();

    final currentBodyTypesIndexes =
        currentBodyTypes.map((e) => e.index).toList();

    log.info('Diagnosing at step 2, $currentBodyTypes');

    void confirmDiagnosisIfApplicable(int step) {
      if (diagnosedIssue.bodyTypes?.length == 1) {
        diagnosedIssue = diagnosedIssue.copyWith(diagnosedStep: step);
      }
    }

    void performDiagnosisTextureS1() {
      if (onlyOneBodyTypeOrDiagnosed) return;
      final bodyTypes = filterBodyTypesByData(
        texturesData,
        (index, map) {
          if (!currentBodyTypesIndexes.contains(index)) {
            // Must be contained in existing body types
            return false;
          }
          return userTextures.any((e) => map[e.title] == 'T');
        },
        currentBodyTypes,
      );
      log.info('Diagnosing for textures s1...$bodyTypes');
      diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: bodyTypes);
      confirmDiagnosisIfApplicable(1);
    }

    void performDiagnosisWhenPainS2() {
      if (onlyOneBodyTypeOrDiagnosed) return;

      final hasMPain = q6MenstruationPainLevel > 0;
      // 有 - BOTH 氣虛+血虛
      if (diagnosedIssue.periodAmount == PeriodAmountIssue.tooMuch &&
          diagnosedIssue.periodColor!.contains(PeriodColor.lightRed) &&
          hasMPain) {
        diagnosedIssue = diagnosedIssue.copyWith(
          diagnosedStep: 2,
          bodyTypes: [
            DiagnosedBodyType.qiDeficiency,
            DiagnosedBodyType.bloodDeficiency,
          ],
        );
      } else {
        const options = ['經前', '經期間', '經後'];
        var mPainPeriodIndexes = userAnswers[7]?.selectedOptionIndex ?? [];
        if (textures.length == 1 &&
            textures.contains(PeriodTexture.sticky) &&
            mPainPeriodIndexes.contains(2)) {
          log.info('黏稠跟經後發生經痛是不會一次出現，在此以黏稠+正常繼續診斷');
          mPainPeriodIndexes =
              mPainPeriodIndexes.whereNot((i) => i == 2).toList();
        }
        final bodyTypes = filterBodyTypesByData(
          mPainData,
          (index, map) {
            if (!currentBodyTypesIndexes.contains(index)) return false;
            if (!hasMPain) return map['無'] == 'T';
            return mPainPeriodIndexes
                .any((period) => map[options[period]] == 'T');
          },
          currentBodyTypes,
        );
        diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: bodyTypes);
      }

      confirmDiagnosisIfApplicable(2);
      log.info('Diagnosing for when pain s2...${diagnosedIssue.bodyTypes}');
    }

    void performDiagnosisPainSymptomsS3() {
      if (onlyOneBodyTypeOrDiagnosed) return;

      final newBodyTypes = diagnoseForStep3PainTypes(
        userAnswers,
        questions,
        diagnosedIssue,
        filterByCurrentTypes: true,
      );
      if (newBodyTypes.$1.isNotEmpty) {
        diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: newBodyTypes.$1);
      }
      confirmDiagnosisIfApplicable(3);
      log.info('Diagnosing for pain symptoms s3...$newBodyTypes');
    }

    void performDiagnosisPainChangesS4() {
      if (onlyOneBodyTypeOrDiagnosed) return;
      final types = _diagnoseForPainImprovement();
      if (types.isNotEmpty) {
        diagnosedIssue = diagnosedIssue.copyWith(bodyTypes: types);
      }
      confirmDiagnosisIfApplicable(4);
      log.info('Diagnosing for pain changes s4...$types');
    }

    performDiagnosisTextureS1();
    performDiagnosisWhenPainS2();
    performDiagnosisPainSymptomsS3();
    performDiagnosisPainChangesS4();
    return diagnosedIssue.diagnosedStep != null;
  }

  Map<int, UserAnswer> _prepareQuestions(Map<String, Object> data) {
    Map<int, UserAnswer> userAnswers = {};
    for (var e in data.entries) {
      final key = e.key;
      final valueObj = e.value;
      if (key == 'Questions') continue;
      if (key == '診斷') continue;
      if (key == 'Remarks') continue;
      final value = valueObj.toString();
      if (key == '1') {
        userAnswers[0] = UserAnswer(
          dateRange: [
            DateTime.parse(value.split('-').first),
            if (value.contains('-')) DateTime.parse(value.split('-').last),
          ],
        );
      }
      // if (key == '2') {
      //   userAnswers[1] = UserAnswer(text: value);
      // }
      if (key == '3') {
        userAnswers[1] = UserAnswer(selectedOptionIndex: [int.parse(value)]);
      }
      if (key == '4') {
        userAnswers[2] = UserAnswer(text: value);
      }
      if (key == '5') {
        userAnswers[3] = UserAnswer(text: value);
      }
      if (key == '6') {
        userAnswers[4] = UserAnswer(
          selectedOptionIndex: value.isNotEmpty
              ? value.split(',').map((e) => e.toInt()).toList()
              : [],
        );
      }
      if (key == '7') {
        userAnswers[5] = UserAnswer(
          selectedOptionIndex: value.isNotEmpty
              ? value.split(',').map((e) => e.toInt()).toList()
              : [],
        );
      }
      if (key == '8') {
        userAnswers[6] = UserAnswer(text: value);
      }
      if (key == '9') {
        userAnswers[7] = UserAnswer(
          selectedOptionIndex: value.isNotEmpty
              ? value.split(',').map((e) => e.toInt()).toList()
              : [],
        );
      }
      if (key == '10') {
        // final optionsText = [
        //   '月經不暢順',
        //   '絞痛',
        //   '長期隱隱痛',
        //   '感覺冰凍',
        //   '灼熱疼痛',
        //   '有固定痛點',
        //   '脹痛',
        //   '有下墜感',
        //   '腹部有包塊，但可推散',
        //   '腰部疼痛',
        // ];
        // final filteredOptions = questions[8]
        //     .optionsByLastAnsIndex(userAnswers[7]!.selectedOptionIndex);
        userAnswers[8] = UserAnswer(
          selectedOptionIndex: value.isNotEmpty
              ? value.split(',').map((e) => e.toInt()).toList()
              : [],
        );
        // if (userAnswers[8]!
        //     .selectedOptionIndex
        //     .any((element) => element == -1)) {
        //   log.warning('Invalid options for question 8: $value');
        //   continue;
        // }
      }
      if (key == '11') {
        userAnswers[9] = UserAnswer(
          selectedOptionIndex: value.isEmpty
              ? []
              : value.split(',').map((e) => e.toInt()).toList(),
        );
      }
    }
    return userAnswers;
  }

  List<PeriodTexture> _setTexturesData() {
    final textures = userAnswers[5]
            ?.selectedOptionIndex
            .map(
              (e) => PeriodTexture.values
                  .firstOrNullWhere((tt) => tt.answerIndex == e),
            )
            .whereNotNull()
            .toList() ??
        [];
    // FIXME: Should not happen in future in the questionnaire
    if (textures.contains(PeriodTexture.withBloodClots)) {
      textures.remove(PeriodTexture.dilute);
    }
    diagnosedIssue = diagnosedIssue.copyWith(
      periodTexture: textures,
    );
    return textures;
  }
}

(List<DiagnosedBodyType>, bool) diagnoseForStep3PainTypes(
  Map<int, UserAnswer> userAnswers,
  List<QuestionModelV2> questions,
  DiagnosedIssue diagnosedIssue, {
  bool filterByCurrentTypes = false,
}) {
  if (userAnswers[6]?.text == '0') {
    // 無痛
    return ([], false);
  }
  final painTypeIndexes = userAnswers[8]?.selectedOptionIndex;
  if (painTypeIndexes == null || painTypeIndexes.isEmpty) {
    // No options selected
    return ([], false);
  }

  final lastAnsIndexes = userAnswers[7]!.selectedOptionIndex;
  log.info(
    'Last answer indexes: $lastAnsIndexes, $painTypeIndexes',
  );
  final selectedOptionsInText = painTypeIndexes
      .map(
        (e) {
          // 沒有 / N/A case
          if (e >= lastAnsIndexes.length) {
            return '';
          }
          final options = questions[8].optionsByLastAnsIndex(lastAnsIndexes);
          return options[e];
        },
      )
      .whereNot((element) => element.isEmpty)
      .toList();
  log.info(
    'Selected options in text: $selectedOptionsInText, $painTypeIndexes',
  );
  final signsFromPainTypes = selectedOptionsInText
      .map((e) => menstruationPainData[e]!.split('\n'))
      .flatten()
      .distinct()
      .toList();
  final bodyTypes = signsFromPainTypes
      .map((e) => DiagnosedBodyType.fromString(e))
      .where(
        (element) => filterByCurrentTypes
            ? diagnosedIssue.bodyTypes!.contains(element)
            : true,
      )
      .toList();
  // log.info('Diagnosing for step 3 pain types...$bodyTypes');
  return (bodyTypes, bodyTypes.isNotEmpty);
}
