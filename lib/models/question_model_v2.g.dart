// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelV2Impl _$$QuestionModelV2ImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionModelV2Impl(
      question: json['question'] as String,
      textReplaceData: json['textReplaceData'] as String,
      transformedQuestionText: json['transformedQuestionText'] as String?,
      title: json['title'] as String?,
      image: json['image'] as String?,
      imagesToShow: json['imagesToShow'] as int?,
      rawOptions: (json['rawOptions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      group: json['group'] as int,
      transformedOptions: (json['transformedOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      optionSeparator: json['optionSeparator'] as String?,
      optionAdditionalStep: $enumDecodeNullable(
          _$OptionAdditionalStepEnumMap, json['optionAdditionalStep']),
      isMultipleChoice: json['isMultipleChoice'] as bool,
      showIf: (json['showIf'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            k, QuestionShowIfNotCondition.fromJson(e as Map<String, dynamic>)),
      ),
      expectedAnsFormat:
          $enumDecode(_$AnswerFormatEnumMap, json['expectedAnsFormat']),
      isOptional: json['isOptional'] as bool,
      canSkipChoice: json['canSkipChoice'] as bool,
      logicReference: json['logicReference'] as String?,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$$QuestionModelV2ImplToJson(
    _$QuestionModelV2Impl instance) {
  final val = <String, dynamic>{
    'question': instance.question,
    'textReplaceData': instance.textReplaceData,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('transformedQuestionText', instance.transformedQuestionText);
  writeNotNull('title', instance.title);
  writeNotNull('image', instance.image);
  writeNotNull('imagesToShow', instance.imagesToShow);
  val['rawOptions'] = instance.rawOptions;
  val['group'] = instance.group;
  writeNotNull('transformedOptions', instance.transformedOptions);
  writeNotNull('optionSeparator', instance.optionSeparator);
  writeNotNull('optionAdditionalStep',
      _$OptionAdditionalStepEnumMap[instance.optionAdditionalStep]);
  val['isMultipleChoice'] = instance.isMultipleChoice;
  writeNotNull('showIf', instance.showIf);
  val['expectedAnsFormat'] = _$AnswerFormatEnumMap[instance.expectedAnsFormat]!;
  val['isOptional'] = instance.isOptional;
  val['canSkipChoice'] = instance.canSkipChoice;
  writeNotNull('logicReference', instance.logicReference);
  val['reference'] = instance.reference;
  return val;
}

const _$OptionAdditionalStepEnumMap = {
  OptionAdditionalStep.colorParser: 'colorParser',
  OptionAdditionalStep.filteringByLastAnsIndex: 'filteringByLastAnsIndex',
};

const _$AnswerFormatEnumMap = {
  AnswerFormat.bool: 'bool',
  AnswerFormat.date: 'date',
  AnswerFormat.numberText: 'numberText',
  AnswerFormat.imageCount: 'imageCount',
  AnswerFormat.bloodColors: 'bloodColors',
  AnswerFormat.options: 'options',
};

_$UserAnswerImpl _$$UserAnswerImplFromJson(Map<String, dynamic> json) =>
    _$UserAnswerImpl(
      selectedOptionIndex: (json['selectedOptionIndex'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      dateRange: (json['dateRange'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$UserAnswerImplToJson(_$UserAnswerImpl instance) {
  final val = <String, dynamic>{
    'selectedOptionIndex': instance.selectedOptionIndex,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('dateRange',
      instance.dateRange?.map((e) => e.toIso8601String()).toList());
  writeNotNull('text', instance.text);
  return val;
}

_$DiagnosedIssueImpl _$$DiagnosedIssueImplFromJson(Map<String, dynamic> json) =>
    _$DiagnosedIssueImpl(
      period: $enumDecodeNullable(_$PeriodIssueEnumMap, json['period']),
      periodLength:
          $enumDecodeNullable(_$PeriodLengthIssueEnumMap, json['periodLength']),
      periodAmount:
          $enumDecodeNullable(_$PeriodAmountIssueEnumMap, json['periodAmount']),
      periodColor:
          $enumDecodeNullable(_$PeriodColorEnumMap, json['periodColor']),
      periodTexture: (json['periodTexture'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PeriodTextureEnumMap, e))
          .toList(),
      bodyTypes: (json['bodyTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DiagnosedBodyTypeEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$DiagnosedIssueImplToJson(
    _$DiagnosedIssueImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('period', _$PeriodIssueEnumMap[instance.period]);
  writeNotNull(
      'periodLength', _$PeriodLengthIssueEnumMap[instance.periodLength]);
  writeNotNull(
      'periodAmount', _$PeriodAmountIssueEnumMap[instance.periodAmount]);
  writeNotNull('periodColor', _$PeriodColorEnumMap[instance.periodColor]);
  writeNotNull('periodTexture',
      instance.periodTexture?.map((e) => _$PeriodTextureEnumMap[e]!).toList());
  writeNotNull('bodyTypes',
      instance.bodyTypes?.map((e) => _$DiagnosedBodyTypeEnumMap[e]!).toList());
  return val;
}

const _$PeriodIssueEnumMap = {
  PeriodIssue.early: 'early',
  PeriodIssue.late: 'late',
  PeriodIssue.irregular: 'irregular',
  PeriodIssue.menopause: 'menopause',
};

const _$PeriodLengthIssueEnumMap = {
  PeriodLengthIssue.tooShort: 'tooShort',
  PeriodLengthIssue.tooLong: 'tooLong',
  PeriodLengthIssue.veryVeryLong: 'veryVeryLong',
};

const _$PeriodAmountIssueEnumMap = {
  PeriodAmountIssue.tooLittle: 'tooLittle',
  PeriodAmountIssue.tooMuch: 'tooMuch',
};

const _$PeriodColorEnumMap = {
  PeriodColor.lightRed: 'lightRed',
  PeriodColor.lightDark: 'lightDark',
  PeriodColor.brightRed: 'brightRed',
  PeriodColor.deepRed: 'deepRed',
  PeriodColor.purpleRed: 'purpleRed',
  PeriodColor.deepPurple: 'deepPurple',
  PeriodColor.normal: 'normal',
};

const _$PeriodTextureEnumMap = {
  PeriodTexture.dilute: 'dilute',
  PeriodTexture.sticky: 'sticky',
  PeriodTexture.withBloodClots: 'withBloodClots',
};

const _$DiagnosedBodyTypeEnumMap = {
  DiagnosedBodyType.kidneyQiDeficiency: 'kidneyQiDeficiency',
  DiagnosedBodyType.kidneyYinDeficiency: 'kidneyYinDeficiency',
  DiagnosedBodyType.liverQiStagnation: 'liverQiStagnation',
  DiagnosedBodyType.dampheat: 'dampheat',
  DiagnosedBodyType.weakTemper: 'weakTemper',
  DiagnosedBodyType.spleenYangIsNotCheerfulPhlegmWet:
      'spleenYangIsNotCheerfulPhlegmWet',
  DiagnosedBodyType.liverDeficiencyAndBloodHeartAndSpleenDeficiency:
      'liverDeficiencyAndBloodHeartAndSpleenDeficiency',
  DiagnosedBodyType.qiDeficiency: 'qiDeficiency',
  DiagnosedBodyType.liverStagnationFire: 'liverStagnationFire',
  DiagnosedBodyType.bloodDeficiency: 'bloodDeficiency',
  DiagnosedBodyType.bloodStasis: 'bloodStasis',
  DiagnosedBodyType.bloodyFeverVirtual: 'bloodyFeverVirtual',
  DiagnosedBodyType.bloodyFeverReal: 'bloodyFeverReal',
  DiagnosedBodyType.bloodyVirtual: 'bloodyVirtual',
  DiagnosedBodyType.bloodyReal: 'bloodyReal',
};

_$QuestionShowIfNotConditionImpl _$$QuestionShowIfNotConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionShowIfNotConditionImpl(
      json['option'] as int,
    );

Map<String, dynamic> _$$QuestionShowIfNotConditionImplToJson(
        _$QuestionShowIfNotConditionImpl instance) =>
    <String, dynamic>{
      'option': instance.option,
    };
