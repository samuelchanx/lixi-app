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
    // 怎樣的痛法？(可選多項）(based on (2))
    8: const UserAnswer(selectedOptionIndex: [0]),

    /// Group 3
    // 經痛會加重或改善？ 用溫暖的東西敷肚會改善 (optional)
    9: const UserAnswer(selectedOptionIndex: []),
    // 經期間不適
    10: const UserAnswer(selectedOptionIndex: []),
  };

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
      'Diagnosed... ${diagnosedIssue.bodyTypes} ${diagnosedIssue.diagnosedStep}',
    );
    return canDiagnose;
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
    log.info('Other questions: $otherQuestionUserSymptoms');
    allSymptoms = allSymptoms
        .where(
          (sym) => otherQuestionUserSymptoms
              .any((userBodyTypeSyms) => userBodyTypeSyms[sym] == 'T'),
        )
        .toList();

    return allSymptoms;
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
      final canDiagnose = diagnose();
      if (!canDiagnose) {
        return 4;
      }
      return -1;
    }
    if (currentStep == 4) {
      // TODO: Diagnose for final other questions
      return -1;
    }
    return currentStep + 1;
  }

  bool get onlyOneBodyTypeOrDiagnosed =>
      diagnosedIssue.bodyTypes?.length == 1 ||
      diagnosedIssue.diagnosedStep != null;

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
    final periodColor = diagnosedIssue.periodColor ?? [];
    final currentBodyTypes = diagnosedIssue.bodyTypes ?? [];
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
        final mPainPeriodIndexes = userAnswers[7]?.selectedOptionIndex ?? [];
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
    // TODO: Diagnose with other questions
    return false;
    if (diagnosedIssue.periodAmount == PeriodAmountIssue.tooLittle) {
      if (periodColor.contains(PeriodColor.lightRed)) {
        _diagnoseForLightRedLittleBlood();
      }
      if (periodColor.contains(PeriodColor.brightRed)) {
        _diagnoseForBrightRedLittleBlood();
      }

      if (periodColor.contains(PeriodColor.purpleRed)) {
        _diagnoseForPurpleRedLittleBlood();
      }
    } else if (diagnosedIssue.periodAmount == PeriodAmountIssue.tooMuch) {
      if (periodColor.contains(PeriodColor.lightRed)) {
        _diagnoseForLightRedMuchBlood();
      }
      if (periodColor.contains(PeriodColor.brightRed)) {
        _diagnoseForBrightRedMuchBlood();
      }
      if (periodColor.contains(PeriodColor.purpleRed) &&
          userTextures.contains(PeriodTexture.sticky) &&
          userTextures.contains(PeriodTexture.withBloodClots)) {
        // (f) 月經過多+紫紅+粘膩+有血塊 options
        _diagnoseForPurpleRedLittleBlood();
      }
    }

    if (diagnosedIssue.bodyTypes?.length == 1) {
      diagnosedIssue = diagnosedIssue.copyWith(diagnosedStep: 2);
      return true;
    } else if (diagnosedIssue.bodyTypes!.length > 1) {
      return false;
    }

    throw Exception('Unexpected step!!');
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

  /// (c) 月經過少+鮮紅options
  void _diagnoseForBrightRedLittleBlood() {
    diagnosedIssue = diagnosedIssue.copyWith(
      bodyTypes: [
        DiagnosedBodyType.kidneyYinDeficiency,
        DiagnosedBodyType.bloodyFeverVirtual,
      ],
    );
  }

  /// (d) 月經過多+深紅 options
  void _diagnoseForBrightRedMuchBlood() {
    if (textures.contains(PeriodTexture.sticky)) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!
            .appendElement(DiagnosedBodyType.bloodyFeverReal)
            .toList(),
        diagnosedStep: textures.length == 1 ? 2 : null,
      );
    }
    if (textures.contains(PeriodTexture.withBloodClots)) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!.append([
          DiagnosedBodyType.bloodyFeverReal,
          DiagnosedBodyType.liverQiStagnation,
        ]).toList(),
      );
    }

    final painTypeOptions =
        questions[8].optionsByLastAnsIndex(userAnswers[7]!.selectedOptionIndex);
    final painTypes = userAnswers[8]!
        .selectedOptionIndex
        .map((e) => painTypeOptions[e])
        .toList();
    if (painTypes.contains('灼痛')) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: [DiagnosedBodyType.bloodyFeverReal],
      );
    }
    if (painTypes.contains('脹痛連及腹側')) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: (diagnosedIssue.bodyTypes ?? [])
            .appendElement(DiagnosedBodyType.liverQiStagnation)
            .toList(),
      );
    }
  }

  /// (a) 月經過少+淡紅 options
  void _diagnoseForLightRedLittleBlood() {
    if (textures.contains(PeriodTexture.sticky)) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!
            .append([DiagnosedBodyType.spleenYangNotGoodDamp]).toList(),
        diagnosedStep: 2,
      );
      return;
    }
    if (textures.contains(PeriodTexture.dilute)) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!.append([
          DiagnosedBodyType.liverDeficiencyAndLittleBlood,
          DiagnosedBodyType.bloodDeficiency,
          DiagnosedBodyType.bloodyColdVirtual,
        ]).toList(),
      );
    }

    // Menstruation pain
    if (q6MenstruationPainLevel > 0) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!.append([
          DiagnosedBodyType.bloodDeficiency,
        ]).toList(),
        diagnosedStep: 2,
      );
      return;
    } else {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!.append([
          DiagnosedBodyType.liverDeficiencyAndLittleBlood,
          DiagnosedBodyType.bloodyColdVirtual,
        ]).toList(),
      );
      // Further ask questions
    }
  }

  /// (b)月經過多+淡紅 options
  void _diagnoseForLightRedMuchBlood() {
    if (q6MenstruationPainLevel > 0) {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!.append([
          DiagnosedBodyType.qiDeficiency,
          DiagnosedBodyType.bloodDeficiency,
        ]).toList(),
        diagnosedStep: 2,
      );
      return;
    } else {
      diagnosedIssue = diagnosedIssue.copyWith(
        bodyTypes: diagnosedIssue.bodyTypes!.append([
          DiagnosedBodyType.weakSpleen,
        ]).toList(),
      );
    }
  }

  List<DiagnosedBodyType> _diagnoseForPainImprovement() {
    final painImprovement = userAnswers[10]?.selectedOptionIndex;
    if (painImprovement == null || painImprovement.isEmpty) {
      return [];
    }
    final selectedOptions =
        painImprovement.map((e) => questions[10].options[e]).toList();
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
        .toList();
    log.info('Diagnosing for pain improvement...$signs');
    return signs;
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

  /// (e) 月經過少+紫紅 options
  void _diagnoseForPurpleRedLittleBlood() {
    var (bodyTypes, _) = diagnoseForStep3PainTypes(
      userAnswers,
      questions,
      diagnosedIssue,
      filterByCurrentTypes: true,
    );
    if (bodyTypes.length > 1 || bodyTypes.isEmpty) {
      bodyTypes = _diagnoseForPainImprovement();
    }
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
    diagnosedIssue = diagnosedIssue.copyWith(
      bodyTypes: issuesFromMatch,
    );
    log.info(
      'Diagnosing for step 2...$periodAmountIssue, $colors, cannotDiagnose: $cannotDiagnose $issuesFromMatch',
    );
    return issuesFromMatch.length == 1 && !cannotDiagnose;
  }

  List<PeriodTexture> _setTexturesData() {
    final textures = userAnswers[5]
            ?.selectedOptionIndex
            .map(
              (e) =>
                  PeriodTexture.values.firstWhere((tt) => tt.answerIndex == e),
            )
            .toList() ??
        [];
    diagnosedIssue = diagnosedIssue.copyWith(periodTexture: textures);
    return textures;
  }

  void startTest() {
    final data = testingData[1];
    Map<int, UserAnswer> userAnswers = {};
    data.forEach((key, valueObj) {
      if (key == 'Questions') return;
      if (key == '診斷') return;
      final value = valueObj.toString();
      if (key == '1') {
        userAnswers[0] = UserAnswer(
          dateRange: [
            DateTime.parse(value.split('-').first),
            DateTime.parse(value.split('-').last),
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
          selectedOptionIndex: value.split(',').map((e) => e.toInt()).toList(),
        );
      }
      if (key == '7') {
        userAnswers[5] = UserAnswer(
          selectedOptionIndex: value.split(',').map((e) => e.toInt()).toList(),
        );
      }
      if (key == '8') {
        userAnswers[6] = UserAnswer(text: value);
      }
      if (key == '9') {
        userAnswers[7] = UserAnswer(
          selectedOptionIndex: value.split(',').map((e) => e.toInt()).toList(),
        );
      }
      if (key == '10') {
        userAnswers[8] = UserAnswer(
          selectedOptionIndex: value.split(',').map((e) => e.toInt()).toList(),
        );
      }
      if (key == '11') {
        userAnswers[9] = UserAnswer(
          selectedOptionIndex: value.isEmpty
              ? []
              : value.split(',').map((e) => e.toInt()).toList(),
        );
      }
    });
    this.userAnswers = userAnswers;
    diagnose();
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
  final selectedOptionsInText = painTypeIndexes
      .map((e) => questions[8].optionsByLastAnsIndex(lastAnsIndexes)[e])
      .toList();
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
  log.info('Diagnosing for step 3...$bodyTypes');
  return (bodyTypes, bodyTypes.isNotEmpty);
}
