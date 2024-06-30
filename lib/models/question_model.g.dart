// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      text: json['text'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'options': instance.options,
    };

_$CureMethodImpl _$$CureMethodImplFromJson(Map<String, dynamic> json) =>
    _$CureMethodImpl(
      json['method'] as String,
      json['medicine'] as String,
      (json['symptoms'] as List<dynamic>)
          .map((e) => SymtomOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CureMethodImplToJson(_$CureMethodImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'medicine': instance.medicine,
      'symptoms': instance.symptoms,
    };

_$SymtomOptionImpl _$$SymtomOptionImplFromJson(Map<String, dynamic> json) =>
    _$SymtomOptionImpl(
      json['symtom'] as String,
      json['option'] as String,
      (json['symtomQuestionIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$SymtomOptionImplToJson(_$SymtomOptionImpl instance) =>
    <String, dynamic>{
      'symtom': instance.symtom,
      'option': instance.option,
      'symtomQuestionIndex': instance.symtomQuestionIndex,
    };
