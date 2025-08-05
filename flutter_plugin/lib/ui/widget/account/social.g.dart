// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialInfo _$SocialInfoFromJson(Map<String, dynamic> json) => SocialInfo(
      id: json['id'] as String?,
      source: json['source'] as String?,
      tenantId: json['tenantId'] as String?,
      uid: json['uid'] as String?,
      userIld: json['userIld'] as String?,
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$SocialInfoToJson(SocialInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'tenantId': instance.tenantId,
      'uid': instance.uid,
      'userIld': instance.userIld,
      'uuid': instance.uuid,
    };

SocialBindReq _$SocialBindReqFromJson(Map<String, dynamic> json) =>
    SocialBindReq(
      source: json['source'] as String,
      code: json['code'] as String?,
      coverType: json['coverType'] as String?,
      extraMap: json['extraMap'] == null
          ? null
          : SocialBindextraMapReq.fromJson(
              json['extraMap'] as Map<String, dynamic>),
    )..platform = json['platform'] as String;

Map<String, dynamic> _$SocialBindReqToJson(SocialBindReq instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('coverType', instance.coverType);
  val['platform'] = instance.platform;
  val['source'] = instance.source;
  writeNotNull('extraMap', instance.extraMap);
  return val;
}

SocialBindextraMapReq _$SocialBindextraMapReqFromJson(
        Map<String, dynamic> json) =>
    SocialBindextraMapReq(
      facebookUserId: json['facebookUserId'] as String?,
      facebookUserName: json['facebookUserName'] as String?,
      facebookUserAEmail: json['facebookUserAEmail'] as String?,
    );

Map<String, dynamic> _$SocialBindextraMapReqToJson(
    SocialBindextraMapReq instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('facebookUserId', instance.facebookUserId);
  writeNotNull('facebookUserName', instance.facebookUserName);
  writeNotNull('facebookUserAEmail', instance.facebookUserAEmail);
  return val;
}

SocialUnBindReq _$SocialUnBindReqFromJson(Map<String, dynamic> json) =>
    SocialUnBindReq(
      id: json['id'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$SocialUnBindReqToJson(SocialUnBindReq instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
    };
