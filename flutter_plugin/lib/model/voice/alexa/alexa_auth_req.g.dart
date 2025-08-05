// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alexa_auth_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlexaBindAuthReq _$AlexaBindAuthReqFromJson(Map<String, dynamic> json) =>
    AlexaBindAuthReq(
      client_id: json['client_id'] as String?,
      redirect_uri: json['redirect_uri'] as String?,
      scope: json['scope'] as String?,
      response_type: json['response_type'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$AlexaBindAuthReqToJson(AlexaBindAuthReq instance) =>
    <String, dynamic>{
      'client_id': instance.client_id,
      'redirect_uri': instance.redirect_uri,
      'scope': instance.scope,
      'response_type': instance.response_type,
      'state': instance.state,
    };

AlexaBindAuthRes _$AlexaBindAuthResFromJson(Map<String, dynamic> json) =>
    AlexaBindAuthRes(
      code: json['code'] as String?,
    );

Map<String, dynamic> _$AlexaBindAuthResToJson(AlexaBindAuthRes instance) =>
    <String, dynamic>{
      'code': instance.code,
    };
