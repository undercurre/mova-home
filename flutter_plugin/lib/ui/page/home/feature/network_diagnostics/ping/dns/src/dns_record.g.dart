// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dns_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DnsRecordImpl _$$DnsRecordImplFromJson(Map<String, dynamic> json) =>
    _$DnsRecordImpl(
      (json['Status'] as num).toInt(),
      json['TC'] as bool,
      json['RD'] as bool,
      json['RA'] as bool,
      json['AD'] as bool,
      json['CD'] as bool,
      json['edns_client_subnet'] as String?,
      (json['Answer'] as List<dynamic>?)
          ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['Comment'] as String?,
    );

Map<String, dynamic> _$$DnsRecordImplToJson(_$DnsRecordImpl instance) =>
    <String, dynamic>{
      'Status': instance.status,
      'TC': instance.TC,
      'RD': instance.RD,
      'RA': instance.RA,
      'AD': instance.AD,
      'CD': instance.CD,
      'edns_client_subnet': instance.ednsClientSubnet,
      'Answer': instance.answer,
      'Comment': instance.comment,
    };

_$QuestionImpl _$$QuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuestionImpl(
      json['name'] as String,
      (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$$QuestionImplToJson(_$QuestionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
    };

_$AnswerImpl _$$AnswerImplFromJson(Map<String, dynamic> json) => _$AnswerImpl(
      json['name'] as String,
      (json['type'] as num).toInt(),
      (json['TTL'] as num).toInt(),
      json['data'] as String,
    );

Map<String, dynamic> _$$AnswerImplToJson(_$AnswerImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'TTL': instance.TTL,
      'data': instance.data,
    };
