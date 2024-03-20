// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get text => throw _privateConstructorUsedError;
  set text(String value) => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  set options(List<String> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
  @useResult
  $Res call({String text, List<String> options});
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, List<String> options});
}

/// @nodoc
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? options = null,
  }) {
    return _then(_$QuestionImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl extends _Question {
  _$QuestionImpl({required this.text, required this.options}) : super._();

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

  @override
  String text;
  @override
  List<String> options;

  @override
  String toString() {
    return 'Question(text: $text, options: $options)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question extends Question {
  factory _Question({required String text, required List<String> options}) =
      _$QuestionImpl;
  _Question._() : super._();

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get text;
  set text(String value);
  @override
  List<String> get options;
  set options(List<String> value);
  @override
  @JsonKey(ignore: true)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CureMethod _$CureMethodFromJson(Map<String, dynamic> json) {
  return _CureMethod.fromJson(json);
}

/// @nodoc
mixin _$CureMethod {
  String get method => throw _privateConstructorUsedError;
  set method(String value) => throw _privateConstructorUsedError;
  String get medicine => throw _privateConstructorUsedError;
  set medicine(String value) => throw _privateConstructorUsedError;
  List<SymtomOption> get symptoms => throw _privateConstructorUsedError;
  set symptoms(List<SymtomOption> value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CureMethodCopyWith<CureMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CureMethodCopyWith<$Res> {
  factory $CureMethodCopyWith(
          CureMethod value, $Res Function(CureMethod) then) =
      _$CureMethodCopyWithImpl<$Res, CureMethod>;
  @useResult
  $Res call({String method, String medicine, List<SymtomOption> symptoms});
}

/// @nodoc
class _$CureMethodCopyWithImpl<$Res, $Val extends CureMethod>
    implements $CureMethodCopyWith<$Res> {
  _$CureMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? medicine = null,
    Object? symptoms = null,
  }) {
    return _then(_value.copyWith(
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      medicine: null == medicine
          ? _value.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as String,
      symptoms: null == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<SymtomOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CureMethodImplCopyWith<$Res>
    implements $CureMethodCopyWith<$Res> {
  factory _$$CureMethodImplCopyWith(
          _$CureMethodImpl value, $Res Function(_$CureMethodImpl) then) =
      __$$CureMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String method, String medicine, List<SymtomOption> symptoms});
}

/// @nodoc
class __$$CureMethodImplCopyWithImpl<$Res>
    extends _$CureMethodCopyWithImpl<$Res, _$CureMethodImpl>
    implements _$$CureMethodImplCopyWith<$Res> {
  __$$CureMethodImplCopyWithImpl(
      _$CureMethodImpl _value, $Res Function(_$CureMethodImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? medicine = null,
    Object? symptoms = null,
  }) {
    return _then(_$CureMethodImpl(
      null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      null == medicine
          ? _value.medicine
          : medicine // ignore: cast_nullable_to_non_nullable
              as String,
      null == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<SymtomOption>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CureMethodImpl extends _CureMethod {
  _$CureMethodImpl(this.method, this.medicine, this.symptoms) : super._();

  factory _$CureMethodImpl.fromJson(Map<String, dynamic> json) =>
      _$$CureMethodImplFromJson(json);

  @override
  String method;
  @override
  String medicine;
  @override
  List<SymtomOption> symptoms;

  @override
  String toString() {
    return 'CureMethod(method: $method, medicine: $medicine, symptoms: $symptoms)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CureMethodImplCopyWith<_$CureMethodImpl> get copyWith =>
      __$$CureMethodImplCopyWithImpl<_$CureMethodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CureMethodImplToJson(
      this,
    );
  }
}

abstract class _CureMethod extends CureMethod {
  factory _CureMethod(
          String method, String medicine, List<SymtomOption> symptoms) =
      _$CureMethodImpl;
  _CureMethod._() : super._();

  factory _CureMethod.fromJson(Map<String, dynamic> json) =
      _$CureMethodImpl.fromJson;

  @override
  String get method;
  set method(String value);
  @override
  String get medicine;
  set medicine(String value);
  @override
  List<SymtomOption> get symptoms;
  set symptoms(List<SymtomOption> value);
  @override
  @JsonKey(ignore: true)
  _$$CureMethodImplCopyWith<_$CureMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SymtomOption _$SymtomOptionFromJson(Map<String, dynamic> json) {
  return _SymtomOption.fromJson(json);
}

/// @nodoc
mixin _$SymtomOption {
  String get symtom => throw _privateConstructorUsedError;
  String get option => throw _privateConstructorUsedError;
  int get symtomQuestionIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SymtomOptionCopyWith<SymtomOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SymtomOptionCopyWith<$Res> {
  factory $SymtomOptionCopyWith(
          SymtomOption value, $Res Function(SymtomOption) then) =
      _$SymtomOptionCopyWithImpl<$Res, SymtomOption>;
  @useResult
  $Res call({String symtom, String option, int symtomQuestionIndex});
}

/// @nodoc
class _$SymtomOptionCopyWithImpl<$Res, $Val extends SymtomOption>
    implements $SymtomOptionCopyWith<$Res> {
  _$SymtomOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symtom = null,
    Object? option = null,
    Object? symtomQuestionIndex = null,
  }) {
    return _then(_value.copyWith(
      symtom: null == symtom
          ? _value.symtom
          : symtom // ignore: cast_nullable_to_non_nullable
              as String,
      option: null == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as String,
      symtomQuestionIndex: null == symtomQuestionIndex
          ? _value.symtomQuestionIndex
          : symtomQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SymtomOptionImplCopyWith<$Res>
    implements $SymtomOptionCopyWith<$Res> {
  factory _$$SymtomOptionImplCopyWith(
          _$SymtomOptionImpl value, $Res Function(_$SymtomOptionImpl) then) =
      __$$SymtomOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String symtom, String option, int symtomQuestionIndex});
}

/// @nodoc
class __$$SymtomOptionImplCopyWithImpl<$Res>
    extends _$SymtomOptionCopyWithImpl<$Res, _$SymtomOptionImpl>
    implements _$$SymtomOptionImplCopyWith<$Res> {
  __$$SymtomOptionImplCopyWithImpl(
      _$SymtomOptionImpl _value, $Res Function(_$SymtomOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symtom = null,
    Object? option = null,
    Object? symtomQuestionIndex = null,
  }) {
    return _then(_$SymtomOptionImpl(
      null == symtom
          ? _value.symtom
          : symtom // ignore: cast_nullable_to_non_nullable
              as String,
      null == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as String,
      null == symtomQuestionIndex
          ? _value.symtomQuestionIndex
          : symtomQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SymtomOptionImpl extends _SymtomOption {
  const _$SymtomOptionImpl(this.symtom, this.option, this.symtomQuestionIndex)
      : super._();

  factory _$SymtomOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SymtomOptionImplFromJson(json);

  @override
  final String symtom;
  @override
  final String option;
  @override
  final int symtomQuestionIndex;

  @override
  String toString() {
    return 'SymtomOption(symtom: $symtom, option: $option, symtomQuestionIndex: $symtomQuestionIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymtomOptionImpl &&
            (identical(other.symtom, symtom) || other.symtom == symtom) &&
            (identical(other.option, option) || other.option == option) &&
            (identical(other.symtomQuestionIndex, symtomQuestionIndex) ||
                other.symtomQuestionIndex == symtomQuestionIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, symtom, option, symtomQuestionIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SymtomOptionImplCopyWith<_$SymtomOptionImpl> get copyWith =>
      __$$SymtomOptionImplCopyWithImpl<_$SymtomOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SymtomOptionImplToJson(
      this,
    );
  }
}

abstract class _SymtomOption extends SymtomOption {
  const factory _SymtomOption(final String symtom, final String option,
      final int symtomQuestionIndex) = _$SymtomOptionImpl;
  const _SymtomOption._() : super._();

  factory _SymtomOption.fromJson(Map<String, dynamic> json) =
      _$SymtomOptionImpl.fromJson;

  @override
  String get symtom;
  @override
  String get option;
  @override
  int get symtomQuestionIndex;
  @override
  @JsonKey(ignore: true)
  _$$SymtomOptionImplCopyWith<_$SymtomOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
