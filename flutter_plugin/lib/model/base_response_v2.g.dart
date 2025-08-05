// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_v2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BaseResponseV2<T> _$$_BaseResponseV2FromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$_BaseResponseV2<T>(
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      msg: json['msg'] as String?,
      code: (json['code'] as num?)?.toInt(),
      success: json['success'],
    );

Map<String, dynamic> _$$_BaseResponseV2ToJson<T>(
  _$_BaseResponseV2<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'msg': instance.msg,
      'code': instance.code,
      'success': instance.success,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
