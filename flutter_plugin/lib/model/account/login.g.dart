// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MobileLoginReq _$MobileLoginReqFromJson(Map<String, dynamic> json) =>
    MobileLoginReq(
      phone: json['phone'] as String,
      phone_code: json['phone_code'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      grant_type: json['grant_type'] as String?,
      scope: json['scope'] as String?,
    );

Map<String, dynamic> _$MobileLoginReqToJson(MobileLoginReq instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('grant_type', instance.grant_type);
  writeNotNull('scope', instance.scope);
  val['phone'] = instance.phone;
  val['phone_code'] = instance.phone_code;
  val['country'] = instance.country;
  val['lang'] = instance.lang;
  return val;
}

OneKeyLoginReq _$OneKeyLoginReqFromJson(Map<String, dynamic> json) =>
    OneKeyLoginReq(
      grant_type: json['grant_type'] as String,
      platform: json['platform'] as String,
      phone_code: json['phone_code'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      aliOneClickLoginToken: json['aliOneClickLoginToken'] as String,
    );

Map<String, dynamic> _$OneKeyLoginReqToJson(OneKeyLoginReq instance) =>
    <String, dynamic>{
      'grant_type': instance.grant_type,
      'platform': instance.platform,
      'phone_code': instance.phone_code,
      'country': instance.country,
      'lang': instance.lang,
      'aliOneClickLoginToken': instance.aliOneClickLoginToken,
    };

PasswordLoginReq _$PasswordLoginReqFromJson(Map<String, dynamic> json) =>
    PasswordLoginReq(
      username: json['username'] as String,
      password: json['password'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
    )
      ..grant_type = json['grant_type'] as String
      ..scope = json['scope'] as String
      ..platform = json['platform'] as String
      ..type = json['type'] as String;

Map<String, dynamic> _$PasswordLoginReqToJson(PasswordLoginReq instance) =>
    <String, dynamic>{
      'grant_type': instance.grant_type,
      'scope': instance.scope,
      'platform': instance.platform,
      'type': instance.type,
      'username': instance.username,
      'password': instance.password,
      'country': instance.country,
      'lang': instance.lang,
    };

MobilePasswordLoginReq _$MobilePasswordLoginReqFromJson(
        Map<String, dynamic> json) =>
    MobilePasswordLoginReq(
      username: json['username'] as String,
      password: json['password'] as String,
      phoneCode: json['phoneCode'] as String,
    )
      ..grant_type = json['grant_type'] as String
      ..scope = json['scope'] as String
      ..platform = json['platform'] as String
      ..type = json['type'] as String;

Map<String, dynamic> _$MobilePasswordLoginReqToJson(
        MobilePasswordLoginReq instance) =>
    <String, dynamic>{
      'grant_type': instance.grant_type,
      'scope': instance.scope,
      'platform': instance.platform,
      'type': instance.type,
      'username': instance.username,
      'password': instance.password,
      'phoneCode': instance.phoneCode,
    };

SocialLoginReq _$SocialLoginReqFromJson(Map<String, dynamic> json) =>
    SocialLoginReq(
      grant_type: json['grant_type'] as String,
      source: json['source'] as String,
      platform: json['platform'] as String,
      code: json['code'] as String?,
      emailCheck: (json['emailCheck'] as num?)?.toInt(),
      registerEmail: json['registerEmail'] as String?,
      registerEmailSkip: json['registerEmailSkip'] as bool?,
      facebookUserId: json['facebookUserId'] as String?,
      facebookUserName: json['facebookUserName'] as String?,
      facebookUserAEmail: json['facebookUserAEmail'] as String?,
    );

Map<String, dynamic> _$SocialLoginReqToJson(SocialLoginReq instance) {
  final val = <String, dynamic>{
    'grant_type': instance.grant_type,
    'source': instance.source,
    'platform': instance.platform,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  writeNotNull('emailCheck', instance.emailCheck);
  writeNotNull('registerEmail', instance.registerEmail);
  writeNotNull('registerEmailSkip', instance.registerEmailSkip);
  writeNotNull('facebookUserId', instance.facebookUserId);
  writeNotNull('facebookUserName', instance.facebookUserName);
  writeNotNull('facebookUserAEmail', instance.facebookUserAEmail);
  return val;
}

SocialSkipBindReq _$SocialSkipBindReqFromJson(Map<String, dynamic> json) =>
    SocialSkipBindReq(
      grant_type: json['grant_type'] as String,
      source: json['source'] as String,
      scope: json['scope'] as String,
      socialUUid: json['socialUUid'] as String,
      lang: json['lang'] as String,
      country: json['country'] as String,
    );

Map<String, dynamic> _$SocialSkipBindReqToJson(SocialSkipBindReq instance) =>
    <String, dynamic>{
      'grant_type': instance.grant_type,
      'source': instance.source,
      'scope': instance.scope,
      'socialUUid': instance.socialUUid,
      'lang': instance.lang,
      'country': instance.country,
    };

SocialSignInBindReq _$SocialSignInBindReqFromJson(Map<String, dynamic> json) =>
    SocialSignInBindReq(
      source: json['source'] as String,
      socialUUid: json['socialUUid'] as String,
      regType: json['regType'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      scope: json['scope'] as String,
      grant_type: json['grant_type'] as String,
      skipType: json['skipType'] as String?,
      phone: json['phone'] as String?,
      phone_code: json['phone_code'] as String?,
      type: json['type'] as String?,
      username: json['username'] as String?,
      palinTextPwd: json['palinTextPwd'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$SocialSignInBindReqToJson(SocialSignInBindReq instance) {
  final val = <String, dynamic>{
    'source': instance.source,
    'socialUUid': instance.socialUUid,
    'regType': instance.regType,
    'country': instance.country,
    'lang': instance.lang,
    'scope': instance.scope,
    'grant_type': instance.grant_type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('skipType', instance.skipType);
  writeNotNull('phone', instance.phone);
  writeNotNull('phone_code', instance.phone_code);
  writeNotNull('type', instance.type);
  writeNotNull('username', instance.username);
  writeNotNull('palinTextPwd', instance.palinTextPwd);
  writeNotNull('password', instance.password);
  return val;
}
