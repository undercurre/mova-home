import 'package:freezed_annotation/freezed_annotation.dart';

part 'alexa_auth_req.g.dart';

@JsonSerializable()
class AlexaBindAuthReq {
  final String? client_id;
  final String? redirect_uri;
  final String? scope;
  final String? response_type;
  final String? state;

  AlexaBindAuthReq({
    this.client_id,
    this.redirect_uri,
    this.scope,
    this.response_type,
    this.state,
  });

  factory AlexaBindAuthReq.fromJson(Map<String, dynamic> json) =>
      _$AlexaBindAuthReqFromJson(json);

  Map<String, dynamic> toJson() => _$AlexaBindAuthReqToJson(this);
}

@JsonSerializable()
class AlexaBindAuthRes {
  final String? code;

  AlexaBindAuthRes({
    this.code,
  });

  factory AlexaBindAuthRes.fromJson(Map<String, dynamic> json) =>
      _$AlexaBindAuthResFromJson(json);
}
