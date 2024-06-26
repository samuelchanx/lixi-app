import 'package:dartx/dartx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/utils/dart_helper.dart';

part 'question_model_v2.freezed.dart';
part 'question_model_v2.g.dart';

List<QuestionModelV2> parseDatabaseV2(List<Map<String, dynamic>> data) {
  return data.mapIndexed(
    (index, e) {
      return QuestionModelV2(
        question: e['question']!,
        index: index,
        displayIndex: e['displayIndex'],
        textReplaceData: e['textReplaceData'] ?? '',
        rawOptions: e['options']?.split(',') ?? [],
        group: e['group'] ?? -1,
        title: e['title'],
        horizontalOption: e['horizontalOption'],
        showByDiagnosis: e['showByDiagnosis'],
        imagesToShow: e['imagesToShow'],
        showOtherInputOption: e['showOtherInputOption'] == true,
        image: e['image'],
        showIf: (e['showIf'] as Map<String, dynamic>?)?.let((e) {
          return e.map(
            (key, value) {
              return MapEntry(
                key,
                QuestionShowIfNotCondition.fromJson(value),
              );
            },
          );
        }),
        optionSeparator: e['optionSeparator'],
        optionAdditionalStep: e['optionAdditionalStep'] == 'colorParser'
            ? OptionAdditionalStep.colorParser
            : e['optionAdditionalStep'] == 'filteringByLastAnsIndex'
                ? OptionAdditionalStep.filteringByLastAnsIndex
                : null,
        isMultipleChoice: e['isMultipleChoice'] == 'TRUE',
        expectedAnsFormat: AnswerFormat.values.byName(e['expectedAnsFormat']),
        canSkipChoice: e['canSkipChoice'] == 'TRUE',
        logicReference: e['logicReference'],
        skipChoiceKeyword: e['skipChoiceKeyword'],
        reference: e['reference']!,
      );
    },
  ).toList();
}

@unfreezed
class QuestionModelV2 with _$QuestionModelV2 {
  QuestionModelV2._();
  factory QuestionModelV2({
    required String question,
    required String textReplaceData,
    required int index,
    required int? displayIndex,
    String? transformedQuestionText,
    String? title,
    String? image,
    int? imagesToShow,
    bool? horizontalOption,
    bool? showByDiagnosis,
    required List<String> rawOptions,
    required int group,
    List<String>? transformedOptions,
    required String? optionSeparator,
    required OptionAdditionalStep? optionAdditionalStep,
    required bool isMultipleChoice,

    /// Question index in string to condition
    Map<String, QuestionShowIfNotCondition>? showIf,
    required AnswerFormat expectedAnsFormat,
    required bool canSkipChoice,
    required bool showOtherInputOption,
    required String? logicReference,
    required String? skipChoiceKeyword,
    required String reference,
  }) = _QuestionModelV2;

  bool shouldNotShow(
    Map<int, UserAnswer>? answers,
    List<QuestionModelV2> questions,
  ) {
    if (showIf == null) return false;
    if (showByDiagnosis == true) {
      final canDetermineAlready = diagnoseForStep3PainTypes(
        answers!,
        questions,
        const DiagnosedIssue(),
      );
      if (canDetermineAlready.$2) {
        return true;
      }
    }
    return showIf!.entries.any(
      (entry) {
        final condition = entry.value;
        final questionIndex = int.parse(entry.key);
        return condition.shouldNotShow(answers?[questionIndex]);
      },
    );
  }

  List<String> get options => transformedOptions ?? rawOptions;

  List<String> optionsByLastAnsIndex(List<int> lastAnsIndex) {
    if (optionAdditionalStep != OptionAdditionalStep.filteringByLastAnsIndex) {
      return options;
    }
    return rawOptions
        .whereIndexed(
          (element, index) => lastAnsIndex.contains(index),
        )
        .map((e) => e.split(optionSeparator!))
        .flatten()
        .distinct()
        .toList();
  }

  String get questionText => transformedQuestionText ?? question;

  factory QuestionModelV2.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelV2FromJson(json);
}

@freezed
class UserAnswer with _$UserAnswer {
  const UserAnswer._();
  const factory UserAnswer({
    @Default([]) List<int> selectedOptionIndex,
    DateTime? date,
    List<DateTime>? dateRange,
    String? text,
  }) = _UserAnswer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerFromJson(json);
}

@freezed
class DiagnosedIssue with _$DiagnosedIssue {
  const DiagnosedIssue._();
  const factory DiagnosedIssue({
    // Step 1
    PeriodIssue? period,
    // Step 2
    PeriodLengthIssue? periodLength,
    PeriodAmountIssue? periodAmount,
    List<PeriodColor>? periodColor,
    List<PeriodTexture>? periodTexture,
    int? diagnosedStep,
    // Step 3
    List<DiagnosedBodyType>? bodyTypes,
  }) = _DiagnosedIssue;

  factory DiagnosedIssue.fromJson(Map<String, dynamic> json) =>
      _$DiagnosedIssueFromJson(json);
}

enum OptionAdditionalStep {
  // 淡(#FDF5F6),淡紅(#FAE2E3),淡黯(#E2DADB),鮮紅(#F80322),深紅(#9A1D2D),深紫(#7C0313),紫紅(#E61C58),正常(#B2404F)
  // shows the color code in the options by parsing it inside the bracket
  colorParser,
  // Use last answered question index to filter options, then separate the options by the optionSeparator
  filteringByLastAnsIndex,
}

enum AnswerFormat {
  // Deprecated
  bool,
  date,
  numberText,
  imageCount,
  bloodColors,
  bloodTexture,
  slider,
  options,
  otherSymptoms,
}

enum PeriodIssue {
  early('月經先期'),
  late('月經後期'),
  irregular('月經先後不定期'),
  menopause('閉經');

  final String description;

  const PeriodIssue(this.description);
}

enum PeriodColor {
  lightRed,
  lightDark,
  normal,
  brightRed,
  deepRed,
  deepPurple,
  purpleRed;

  String get title {
    return [
      '淡紅',
      '淡黯',
      '正常',
      '鮮紅',
      '深紅',
      '紫紅',
      '深紫',
    ][index];
  }
}

enum PeriodLengthIssue {
  tooShort('月經過短'),
  tooLong('月經延長'),
  veryVeryLong('崩漏');

  final String description;

  const PeriodLengthIssue(this.description);
}

enum PeriodAmountIssue {
  tooLittle,
  tooMuch,
}

const bodyTypesBigCategory = [
  '腎氣虛',
  '腎陰虛',
  '肝氣鬱結',
  '濕熱蘊結',
  '脾氣虛弱',
  '脾陽不振(痰濕)',
  '肝虛血少(心脾兩虛)',
  '氣虛',
  '肝鬱化火',
  '血虛',
  '血瘀',
  '血熱(實)',
  '血熱(虛)',
  '血寒(實)',
  '血寒(虛)',
];

enum DiagnosedBodyType {
  // 腎氣虛
  // 腎陰虛
  // 肝氣鬱結
  // 濕熱蘊結
  // 脾氣虛弱
  // 脾陽不振(痰濕)
  // 肝虛血少(心脾兩虛)
  // 氣虛
  // 肝鬱化火
  // 血虛
  // 血瘀
  // 血熱 (實）
  // 血熱 (虛）
  // 血寒（實）
  // 血寒（虛）
  kidneyQiDeficiency,
  kidneyYinDeficiency,
  liverQiStagnation,
  dampheat,
  weakSpleen,
  spleenYangNotGoodDamp,
  liverDeficiencyAndLittleBlood,
  qiDeficiency,
  liverStagnationFire,
  bloodDeficiency,
  bloodStasis,
  bloodyFeverReal,
  bloodyFeverVirtual,
  bloodyColdReal,
  bloodyColdVirtual;

  String get biggerCategory {
    return bodyTypesBigCategory[index];
  }

  @override
  String toString() => title;

  static DiagnosedBodyType fromString(String type) {
    return DiagnosedBodyType.values.firstWhere(
      (e) => e.biggerCategory == type,
    );
  }

  String get title {
    return [
      '腎氣虛',
      '腎陰虛',
      '肝氣鬱結',
      '濕熱蘊結',
      '脾氣虛弱',
      '脾陽不振(痰濕)',
      '肝虛血少(心脾兩虛)',
      '氣虛',
      '肝鬱化火',
      '血虛',
      '血瘀',
      '血熱(實)',
      '血熱(虛)',
      '血寒(實)',
      '血寒(虛)',
    ][index];
  }
}

enum PeriodTexture {
  dilute,
  sticky,
  withBloodClots;

  int get answerIndex => [0, 2, 3][index];

  String get title {
    return ['稀', '黏稠', '有血塊'][index];
  }
}

@freezed
class QuestionShowIfNotCondition with _$QuestionShowIfNotCondition {
  const QuestionShowIfNotCondition._();
  const factory QuestionShowIfNotCondition(
    int? option,
    ComparisonCondition? text,
    bool? questionAnswered,
  ) = _QuestionShowIfNotCondition;

  bool shouldNotShow(UserAnswer? answer) {
    if (questionAnswered != null) {
      return answer == null;
    }
    if (option != null) {
      return answer?.selectedOptionIndex.contains(option) ?? false;
    } else if (text != null) {
      if (text?.neq != null) {
        return answer?.text == text!.neq!;
      }
    }

    return true;
  }

  factory QuestionShowIfNotCondition.fromJson(Map<String, dynamic> json) =>
      _$QuestionShowIfNotConditionFromJson(json);
}

@freezed
class ComparisonCondition with _$ComparisonCondition {
  const ComparisonCondition._();
  const factory ComparisonCondition(
    String? neq,
    String? eq,
  ) = _ComparisonCondition;

  factory ComparisonCondition.fromJson(Map<String, dynamic> json) =>
      _$ComparisonConditionFromJson(json);
}
