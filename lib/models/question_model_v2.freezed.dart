// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionModelV2 _$QuestionModelV2FromJson(Map<String, dynamic> json) {
  return _QuestionModelV2.fromJson(json);
}

/// @nodoc
mixin _$QuestionModelV2 {
  String get question => throw _privateConstructorUsedError;
  set question(String value) => throw _privateConstructorUsedError;
  String get textReplaceData => throw _privateConstructorUsedError;
  set textReplaceData(String value) => throw _privateConstructorUsedError;
  String? get transformedQuestionText => throw _privateConstructorUsedError;
  set transformedQuestionText(String? value) =>
      throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  set title(String? value) => throw _privateConstructorUsedError;
  List<String> get rawOptions => throw _privateConstructorUsedError;
  set rawOptions(List<String> value) => throw _privateConstructorUsedError;
  int get group => throw _privateConstructorUsedError;
  set group(int value) => throw _privateConstructorUsedError;
  List<String>? get transformedOptions => throw _privateConstructorUsedError;
  set transformedOptions(List<String>? value) =>
      throw _privateConstructorUsedError;
  String? get optionSeparator => throw _privateConstructorUsedError;
  set optionSeparator(String? value) => throw _privateConstructorUsedError;
  OptionAdditionalStep? get optionAdditionalStep =>
      throw _privateConstructorUsedError;
  set optionAdditionalStep(OptionAdditionalStep? value) =>
      throw _privateConstructorUsedError;
  bool get isMultipleChoice => throw _privateConstructorUsedError;
  set isMultipleChoice(bool value) => throw _privateConstructorUsedError;
  AnswerFormat get expectedAnsFormat => throw _privateConstructorUsedError;
  set expectedAnsFormat(AnswerFormat value) =>
      throw _privateConstructorUsedError;
  bool get isOptional => throw _privateConstructorUsedError;
  set isOptional(bool value) => throw _privateConstructorUsedError;
  bool get canSkipChoice => throw _privateConstructorUsedError;
  set canSkipChoice(bool value) => throw _privateConstructorUsedError;
  String? get logicReference => throw _privateConstructorUsedError;
  set logicReference(String? value) => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  set reference(String value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionModelV2CopyWith<QuestionModelV2> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelV2CopyWith<$Res> {
  factory $QuestionModelV2CopyWith(
          QuestionModelV2 value, $Res Function(QuestionModelV2) then) =
      _$QuestionModelV2CopyWithImpl<$Res, QuestionModelV2>;
  @useResult
  $Res call(
      {String question,
      String textReplaceData,
      String? transformedQuestionText,
      String? title,
      List<String> rawOptions,
      int group,
      List<String>? transformedOptions,
      String? optionSeparator,
      OptionAdditionalStep? optionAdditionalStep,
      bool isMultipleChoice,
      AnswerFormat expectedAnsFormat,
      bool isOptional,
      bool canSkipChoice,
      String? logicReference,
      String reference});
}

/// @nodoc
class _$QuestionModelV2CopyWithImpl<$Res, $Val extends QuestionModelV2>
    implements $QuestionModelV2CopyWith<$Res> {
  _$QuestionModelV2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? textReplaceData = null,
    Object? transformedQuestionText = freezed,
    Object? title = freezed,
    Object? rawOptions = null,
    Object? group = null,
    Object? transformedOptions = freezed,
    Object? optionSeparator = freezed,
    Object? optionAdditionalStep = freezed,
    Object? isMultipleChoice = null,
    Object? expectedAnsFormat = null,
    Object? isOptional = null,
    Object? canSkipChoice = null,
    Object? logicReference = freezed,
    Object? reference = null,
  }) {
    return _then(_value.copyWith(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      textReplaceData: null == textReplaceData
          ? _value.textReplaceData
          : textReplaceData // ignore: cast_nullable_to_non_nullable
              as String,
      transformedQuestionText: freezed == transformedQuestionText
          ? _value.transformedQuestionText
          : transformedQuestionText // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      rawOptions: null == rawOptions
          ? _value.rawOptions
          : rawOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as int,
      transformedOptions: freezed == transformedOptions
          ? _value.transformedOptions
          : transformedOptions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      optionSeparator: freezed == optionSeparator
          ? _value.optionSeparator
          : optionSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      optionAdditionalStep: freezed == optionAdditionalStep
          ? _value.optionAdditionalStep
          : optionAdditionalStep // ignore: cast_nullable_to_non_nullable
              as OptionAdditionalStep?,
      isMultipleChoice: null == isMultipleChoice
          ? _value.isMultipleChoice
          : isMultipleChoice // ignore: cast_nullable_to_non_nullable
              as bool,
      expectedAnsFormat: null == expectedAnsFormat
          ? _value.expectedAnsFormat
          : expectedAnsFormat // ignore: cast_nullable_to_non_nullable
              as AnswerFormat,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      canSkipChoice: null == canSkipChoice
          ? _value.canSkipChoice
          : canSkipChoice // ignore: cast_nullable_to_non_nullable
              as bool,
      logicReference: freezed == logicReference
          ? _value.logicReference
          : logicReference // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionModelV2ImplCopyWith<$Res>
    implements $QuestionModelV2CopyWith<$Res> {
  factory _$$QuestionModelV2ImplCopyWith(_$QuestionModelV2Impl value,
          $Res Function(_$QuestionModelV2Impl) then) =
      __$$QuestionModelV2ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String question,
      String textReplaceData,
      String? transformedQuestionText,
      String? title,
      List<String> rawOptions,
      int group,
      List<String>? transformedOptions,
      String? optionSeparator,
      OptionAdditionalStep? optionAdditionalStep,
      bool isMultipleChoice,
      AnswerFormat expectedAnsFormat,
      bool isOptional,
      bool canSkipChoice,
      String? logicReference,
      String reference});
}

/// @nodoc
class __$$QuestionModelV2ImplCopyWithImpl<$Res>
    extends _$QuestionModelV2CopyWithImpl<$Res, _$QuestionModelV2Impl>
    implements _$$QuestionModelV2ImplCopyWith<$Res> {
  __$$QuestionModelV2ImplCopyWithImpl(
      _$QuestionModelV2Impl _value, $Res Function(_$QuestionModelV2Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? question = null,
    Object? textReplaceData = null,
    Object? transformedQuestionText = freezed,
    Object? title = freezed,
    Object? rawOptions = null,
    Object? group = null,
    Object? transformedOptions = freezed,
    Object? optionSeparator = freezed,
    Object? optionAdditionalStep = freezed,
    Object? isMultipleChoice = null,
    Object? expectedAnsFormat = null,
    Object? isOptional = null,
    Object? canSkipChoice = null,
    Object? logicReference = freezed,
    Object? reference = null,
  }) {
    return _then(_$QuestionModelV2Impl(
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      textReplaceData: null == textReplaceData
          ? _value.textReplaceData
          : textReplaceData // ignore: cast_nullable_to_non_nullable
              as String,
      transformedQuestionText: freezed == transformedQuestionText
          ? _value.transformedQuestionText
          : transformedQuestionText // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      rawOptions: null == rawOptions
          ? _value.rawOptions
          : rawOptions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      group: null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as int,
      transformedOptions: freezed == transformedOptions
          ? _value.transformedOptions
          : transformedOptions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      optionSeparator: freezed == optionSeparator
          ? _value.optionSeparator
          : optionSeparator // ignore: cast_nullable_to_non_nullable
              as String?,
      optionAdditionalStep: freezed == optionAdditionalStep
          ? _value.optionAdditionalStep
          : optionAdditionalStep // ignore: cast_nullable_to_non_nullable
              as OptionAdditionalStep?,
      isMultipleChoice: null == isMultipleChoice
          ? _value.isMultipleChoice
          : isMultipleChoice // ignore: cast_nullable_to_non_nullable
              as bool,
      expectedAnsFormat: null == expectedAnsFormat
          ? _value.expectedAnsFormat
          : expectedAnsFormat // ignore: cast_nullable_to_non_nullable
              as AnswerFormat,
      isOptional: null == isOptional
          ? _value.isOptional
          : isOptional // ignore: cast_nullable_to_non_nullable
              as bool,
      canSkipChoice: null == canSkipChoice
          ? _value.canSkipChoice
          : canSkipChoice // ignore: cast_nullable_to_non_nullable
              as bool,
      logicReference: freezed == logicReference
          ? _value.logicReference
          : logicReference // ignore: cast_nullable_to_non_nullable
              as String?,
      reference: null == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionModelV2Impl extends _QuestionModelV2 {
  _$QuestionModelV2Impl(
      {required this.question,
      required this.textReplaceData,
      this.transformedQuestionText,
      this.title,
      required this.rawOptions,
      required this.group,
      this.transformedOptions,
      required this.optionSeparator,
      required this.optionAdditionalStep,
      required this.isMultipleChoice,
      required this.expectedAnsFormat,
      required this.isOptional,
      required this.canSkipChoice,
      required this.logicReference,
      required this.reference})
      : super._();

  factory _$QuestionModelV2Impl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelV2ImplFromJson(json);

  @override
  String question;
  @override
  String textReplaceData;
  @override
  String? transformedQuestionText;
  @override
  String? title;
  @override
  List<String> rawOptions;
  @override
  int group;
  @override
  List<String>? transformedOptions;
  @override
  String? optionSeparator;
  @override
  OptionAdditionalStep? optionAdditionalStep;
  @override
  bool isMultipleChoice;
  @override
  AnswerFormat expectedAnsFormat;
  @override
  bool isOptional;
  @override
  bool canSkipChoice;
  @override
  String? logicReference;
  @override
  String reference;

  @override
  String toString() {
    return 'QuestionModelV2(question: $question, textReplaceData: $textReplaceData, transformedQuestionText: $transformedQuestionText, title: $title, rawOptions: $rawOptions, group: $group, transformedOptions: $transformedOptions, optionSeparator: $optionSeparator, optionAdditionalStep: $optionAdditionalStep, isMultipleChoice: $isMultipleChoice, expectedAnsFormat: $expectedAnsFormat, isOptional: $isOptional, canSkipChoice: $canSkipChoice, logicReference: $logicReference, reference: $reference)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelV2ImplCopyWith<_$QuestionModelV2Impl> get copyWith =>
      __$$QuestionModelV2ImplCopyWithImpl<_$QuestionModelV2Impl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelV2ImplToJson(
      this,
    );
  }
}

abstract class _QuestionModelV2 extends QuestionModelV2 {
  factory _QuestionModelV2(
      {required String question,
      required String textReplaceData,
      String? transformedQuestionText,
      String? title,
      required List<String> rawOptions,
      required int group,
      List<String>? transformedOptions,
      required String? optionSeparator,
      required OptionAdditionalStep? optionAdditionalStep,
      required bool isMultipleChoice,
      required AnswerFormat expectedAnsFormat,
      required bool isOptional,
      required bool canSkipChoice,
      required String? logicReference,
      required String reference}) = _$QuestionModelV2Impl;
  _QuestionModelV2._() : super._();

  factory _QuestionModelV2.fromJson(Map<String, dynamic> json) =
      _$QuestionModelV2Impl.fromJson;

  @override
  String get question;
  set question(String value);
  @override
  String get textReplaceData;
  set textReplaceData(String value);
  @override
  String? get transformedQuestionText;
  set transformedQuestionText(String? value);
  @override
  String? get title;
  set title(String? value);
  @override
  List<String> get rawOptions;
  set rawOptions(List<String> value);
  @override
  int get group;
  set group(int value);
  @override
  List<String>? get transformedOptions;
  set transformedOptions(List<String>? value);
  @override
  String? get optionSeparator;
  set optionSeparator(String? value);
  @override
  OptionAdditionalStep? get optionAdditionalStep;
  set optionAdditionalStep(OptionAdditionalStep? value);
  @override
  bool get isMultipleChoice;
  set isMultipleChoice(bool value);
  @override
  AnswerFormat get expectedAnsFormat;
  set expectedAnsFormat(AnswerFormat value);
  @override
  bool get isOptional;
  set isOptional(bool value);
  @override
  bool get canSkipChoice;
  set canSkipChoice(bool value);
  @override
  String? get logicReference;
  set logicReference(String? value);
  @override
  String get reference;
  set reference(String value);
  @override
  @JsonKey(ignore: true)
  _$$QuestionModelV2ImplCopyWith<_$QuestionModelV2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserAnswer _$UserAnswerFromJson(Map<String, dynamic> json) {
  return _UserAnswer.fromJson(json);
}

/// @nodoc
mixin _$UserAnswer {
  List<int> get selectedOptionIndex => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAnswerCopyWith<UserAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAnswerCopyWith<$Res> {
  factory $UserAnswerCopyWith(
          UserAnswer value, $Res Function(UserAnswer) then) =
      _$UserAnswerCopyWithImpl<$Res, UserAnswer>;
  @useResult
  $Res call({List<int> selectedOptionIndex, DateTime? date, String? text});
}

/// @nodoc
class _$UserAnswerCopyWithImpl<$Res, $Val extends UserAnswer>
    implements $UserAnswerCopyWith<$Res> {
  _$UserAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedOptionIndex = null,
    Object? date = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      selectedOptionIndex: null == selectedOptionIndex
          ? _value.selectedOptionIndex
          : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
              as List<int>,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAnswerImplCopyWith<$Res>
    implements $UserAnswerCopyWith<$Res> {
  factory _$$UserAnswerImplCopyWith(
          _$UserAnswerImpl value, $Res Function(_$UserAnswerImpl) then) =
      __$$UserAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<int> selectedOptionIndex, DateTime? date, String? text});
}

/// @nodoc
class __$$UserAnswerImplCopyWithImpl<$Res>
    extends _$UserAnswerCopyWithImpl<$Res, _$UserAnswerImpl>
    implements _$$UserAnswerImplCopyWith<$Res> {
  __$$UserAnswerImplCopyWithImpl(
      _$UserAnswerImpl _value, $Res Function(_$UserAnswerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedOptionIndex = null,
    Object? date = freezed,
    Object? text = freezed,
  }) {
    return _then(_$UserAnswerImpl(
      selectedOptionIndex: null == selectedOptionIndex
          ? _value._selectedOptionIndex
          : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
              as List<int>,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAnswerImpl extends _UserAnswer {
  const _$UserAnswerImpl(
      {final List<int> selectedOptionIndex = const [], this.date, this.text})
      : _selectedOptionIndex = selectedOptionIndex,
        super._();

  factory _$UserAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAnswerImplFromJson(json);

  final List<int> _selectedOptionIndex;
  @override
  @JsonKey()
  List<int> get selectedOptionIndex {
    if (_selectedOptionIndex is EqualUnmodifiableListView)
      return _selectedOptionIndex;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedOptionIndex);
  }

  @override
  final DateTime? date;
  @override
  final String? text;

  @override
  String toString() {
    return 'UserAnswer(selectedOptionIndex: $selectedOptionIndex, date: $date, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAnswerImpl &&
            const DeepCollectionEquality()
                .equals(other._selectedOptionIndex, _selectedOptionIndex) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_selectedOptionIndex), date, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAnswerImplCopyWith<_$UserAnswerImpl> get copyWith =>
      __$$UserAnswerImplCopyWithImpl<_$UserAnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAnswerImplToJson(
      this,
    );
  }
}

abstract class _UserAnswer extends UserAnswer {
  const factory _UserAnswer(
      {final List<int> selectedOptionIndex,
      final DateTime? date,
      final String? text}) = _$UserAnswerImpl;
  const _UserAnswer._() : super._();

  factory _UserAnswer.fromJson(Map<String, dynamic> json) =
      _$UserAnswerImpl.fromJson;

  @override
  List<int> get selectedOptionIndex;
  @override
  DateTime? get date;
  @override
  String? get text;
  @override
  @JsonKey(ignore: true)
  _$$UserAnswerImplCopyWith<_$UserAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiagnosedIssue _$DiagnosedIssueFromJson(Map<String, dynamic> json) {
  return _DiagnosedIssue.fromJson(json);
}

/// @nodoc
mixin _$DiagnosedIssue {
// Step 1
  PeriodIssue? get period => throw _privateConstructorUsedError; // Step 2
  PeriodLengthIssue? get periodLength => throw _privateConstructorUsedError;
  PeriodAmountIssue? get periodAmount => throw _privateConstructorUsedError;
  PeriodColor? get periodColor => throw _privateConstructorUsedError;
  List<PeriodTexture>? get periodTexture =>
      throw _privateConstructorUsedError; // Step 3
  List<DiagnosedBodyType>? get bodyTypes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiagnosedIssueCopyWith<DiagnosedIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosedIssueCopyWith<$Res> {
  factory $DiagnosedIssueCopyWith(
          DiagnosedIssue value, $Res Function(DiagnosedIssue) then) =
      _$DiagnosedIssueCopyWithImpl<$Res, DiagnosedIssue>;
  @useResult
  $Res call(
      {PeriodIssue? period,
      PeriodLengthIssue? periodLength,
      PeriodAmountIssue? periodAmount,
      PeriodColor? periodColor,
      List<PeriodTexture>? periodTexture,
      List<DiagnosedBodyType>? bodyTypes});
}

/// @nodoc
class _$DiagnosedIssueCopyWithImpl<$Res, $Val extends DiagnosedIssue>
    implements $DiagnosedIssueCopyWith<$Res> {
  _$DiagnosedIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = freezed,
    Object? periodLength = freezed,
    Object? periodAmount = freezed,
    Object? periodColor = freezed,
    Object? periodTexture = freezed,
    Object? bodyTypes = freezed,
  }) {
    return _then(_value.copyWith(
      period: freezed == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as PeriodIssue?,
      periodLength: freezed == periodLength
          ? _value.periodLength
          : periodLength // ignore: cast_nullable_to_non_nullable
              as PeriodLengthIssue?,
      periodAmount: freezed == periodAmount
          ? _value.periodAmount
          : periodAmount // ignore: cast_nullable_to_non_nullable
              as PeriodAmountIssue?,
      periodColor: freezed == periodColor
          ? _value.periodColor
          : periodColor // ignore: cast_nullable_to_non_nullable
              as PeriodColor?,
      periodTexture: freezed == periodTexture
          ? _value.periodTexture
          : periodTexture // ignore: cast_nullable_to_non_nullable
              as List<PeriodTexture>?,
      bodyTypes: freezed == bodyTypes
          ? _value.bodyTypes
          : bodyTypes // ignore: cast_nullable_to_non_nullable
              as List<DiagnosedBodyType>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiagnosedIssueImplCopyWith<$Res>
    implements $DiagnosedIssueCopyWith<$Res> {
  factory _$$DiagnosedIssueImplCopyWith(_$DiagnosedIssueImpl value,
          $Res Function(_$DiagnosedIssueImpl) then) =
      __$$DiagnosedIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PeriodIssue? period,
      PeriodLengthIssue? periodLength,
      PeriodAmountIssue? periodAmount,
      PeriodColor? periodColor,
      List<PeriodTexture>? periodTexture,
      List<DiagnosedBodyType>? bodyTypes});
}

/// @nodoc
class __$$DiagnosedIssueImplCopyWithImpl<$Res>
    extends _$DiagnosedIssueCopyWithImpl<$Res, _$DiagnosedIssueImpl>
    implements _$$DiagnosedIssueImplCopyWith<$Res> {
  __$$DiagnosedIssueImplCopyWithImpl(
      _$DiagnosedIssueImpl _value, $Res Function(_$DiagnosedIssueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = freezed,
    Object? periodLength = freezed,
    Object? periodAmount = freezed,
    Object? periodColor = freezed,
    Object? periodTexture = freezed,
    Object? bodyTypes = freezed,
  }) {
    return _then(_$DiagnosedIssueImpl(
      period: freezed == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as PeriodIssue?,
      periodLength: freezed == periodLength
          ? _value.periodLength
          : periodLength // ignore: cast_nullable_to_non_nullable
              as PeriodLengthIssue?,
      periodAmount: freezed == periodAmount
          ? _value.periodAmount
          : periodAmount // ignore: cast_nullable_to_non_nullable
              as PeriodAmountIssue?,
      periodColor: freezed == periodColor
          ? _value.periodColor
          : periodColor // ignore: cast_nullable_to_non_nullable
              as PeriodColor?,
      periodTexture: freezed == periodTexture
          ? _value._periodTexture
          : periodTexture // ignore: cast_nullable_to_non_nullable
              as List<PeriodTexture>?,
      bodyTypes: freezed == bodyTypes
          ? _value._bodyTypes
          : bodyTypes // ignore: cast_nullable_to_non_nullable
              as List<DiagnosedBodyType>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosedIssueImpl extends _DiagnosedIssue {
  const _$DiagnosedIssueImpl(
      {this.period,
      this.periodLength,
      this.periodAmount,
      this.periodColor,
      final List<PeriodTexture>? periodTexture,
      final List<DiagnosedBodyType>? bodyTypes})
      : _periodTexture = periodTexture,
        _bodyTypes = bodyTypes,
        super._();

  factory _$DiagnosedIssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosedIssueImplFromJson(json);

// Step 1
  @override
  final PeriodIssue? period;
// Step 2
  @override
  final PeriodLengthIssue? periodLength;
  @override
  final PeriodAmountIssue? periodAmount;
  @override
  final PeriodColor? periodColor;
  final List<PeriodTexture>? _periodTexture;
  @override
  List<PeriodTexture>? get periodTexture {
    final value = _periodTexture;
    if (value == null) return null;
    if (_periodTexture is EqualUnmodifiableListView) return _periodTexture;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Step 3
  final List<DiagnosedBodyType>? _bodyTypes;
// Step 3
  @override
  List<DiagnosedBodyType>? get bodyTypes {
    final value = _bodyTypes;
    if (value == null) return null;
    if (_bodyTypes is EqualUnmodifiableListView) return _bodyTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'DiagnosedIssue(period: $period, periodLength: $periodLength, periodAmount: $periodAmount, periodColor: $periodColor, periodTexture: $periodTexture, bodyTypes: $bodyTypes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosedIssueImpl &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.periodLength, periodLength) ||
                other.periodLength == periodLength) &&
            (identical(other.periodAmount, periodAmount) ||
                other.periodAmount == periodAmount) &&
            (identical(other.periodColor, periodColor) ||
                other.periodColor == periodColor) &&
            const DeepCollectionEquality()
                .equals(other._periodTexture, _periodTexture) &&
            const DeepCollectionEquality()
                .equals(other._bodyTypes, _bodyTypes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      period,
      periodLength,
      periodAmount,
      periodColor,
      const DeepCollectionEquality().hash(_periodTexture),
      const DeepCollectionEquality().hash(_bodyTypes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosedIssueImplCopyWith<_$DiagnosedIssueImpl> get copyWith =>
      __$$DiagnosedIssueImplCopyWithImpl<_$DiagnosedIssueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosedIssueImplToJson(
      this,
    );
  }
}

abstract class _DiagnosedIssue extends DiagnosedIssue {
  const factory _DiagnosedIssue(
      {final PeriodIssue? period,
      final PeriodLengthIssue? periodLength,
      final PeriodAmountIssue? periodAmount,
      final PeriodColor? periodColor,
      final List<PeriodTexture>? periodTexture,
      final List<DiagnosedBodyType>? bodyTypes}) = _$DiagnosedIssueImpl;
  const _DiagnosedIssue._() : super._();

  factory _DiagnosedIssue.fromJson(Map<String, dynamic> json) =
      _$DiagnosedIssueImpl.fromJson;

  @override // Step 1
  PeriodIssue? get period;
  @override // Step 2
  PeriodLengthIssue? get periodLength;
  @override
  PeriodAmountIssue? get periodAmount;
  @override
  PeriodColor? get periodColor;
  @override
  List<PeriodTexture>? get periodTexture;
  @override // Step 3
  List<DiagnosedBodyType>? get bodyTypes;
  @override
  @JsonKey(ignore: true)
  _$$DiagnosedIssueImplCopyWith<_$DiagnosedIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
