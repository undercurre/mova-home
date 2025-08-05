import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

/// 手机号登录
@JsonSerializable(includeIfNull: false)
class MobileLoginReq {
  String? grant_type;
  String? scope;
  String phone;
  String phone_code;
  String country;
  String lang;

  // String codeKey;
  // String code;
  MobileLoginReq({
    required this.phone,
    required this.phone_code,
    required this.country,
    required this.lang,
    this.grant_type,
    this.scope,
  });

  factory MobileLoginReq.fromJson(Map<String, dynamic> json) =>
      _$MobileLoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$MobileLoginReqToJson(this);
}

/// 一键登录
@JsonSerializable(includeIfNull: false)
class OneKeyLoginReq {
  String grant_type;
  String platform;
  String phone_code;
  String country;
  String lang;
  String aliOneClickLoginToken;

  // String codeKey;
  // String code;
  OneKeyLoginReq({
    required this.grant_type,
    required this.platform,
    required this.phone_code,
    required this.country,
    required this.lang,
    required this.aliOneClickLoginToken,
  });

  static OneKeyLoginReq create(
      {required String token,
      required String lang,
      String phone_code = '86',
      String country = 'CN'}) {
    return OneKeyLoginReq(
        grant_type: 'phoneOneClick',
        platform: Platform.isAndroid ? 'ANDROID' : 'IOS',
        phone_code: phone_code,
        country: country,
        lang: lang,
        aliOneClickLoginToken: token);
  }

  factory OneKeyLoginReq.fromJson(Map<String, dynamic> json) =>
      _$OneKeyLoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$OneKeyLoginReqToJson(this);
}

// 账号密码登录
@JsonSerializable(includeIfNull: false)
class PasswordLoginReq {
  // ignore: non_constant_identifier_names
  String grant_type = 'password';
  String scope = 'all';
  String platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
  String type = 'account';
  String username;
  String password;
  String country;
  String lang;

  // String codeKey;
  // String code;
  PasswordLoginReq({
    required this.username,
    required this.password,
    required this.country,
    required this.lang,
    // ignore: non_constant_identifier_names
  });

  factory PasswordLoginReq.fromJson(Map<String, dynamic> json) =>
      _$PasswordLoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordLoginReqToJson(this);
}

/// 账号密码 手机号登录
@JsonSerializable(includeIfNull: false)
class MobilePasswordLoginReq {
  // ignore: non_constant_identifier_names
  String grant_type = 'password';
  String scope = 'all';
  String platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
  String type = 'account';
  String username;
  String password;
  String phoneCode;
  // String codeKey;
  // String code;
  MobilePasswordLoginReq({
    required this.username,
    required this.password,
    required this.phoneCode,
    // ignore: non_constant_identifier_names
  });

  factory MobilePasswordLoginReq.fromJson(Map<String, dynamic> json) =>
      _$MobilePasswordLoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$MobilePasswordLoginReqToJson(this);
}

@JsonSerializable(includeIfNull: false)
class SocialLoginReq {
  String grant_type;
  String source;
  String platform;
  String? code;
  int? emailCheck;
  String? registerEmail;
  bool? registerEmailSkip;
  String? facebookUserId;
  String? facebookUserName;
  String? facebookUserAEmail;

  // String codeKey;
  // String code;
  SocialLoginReq({
    required this.grant_type,
    required this.source,
    required this.platform,
    this.code,
    this.emailCheck,
    this.registerEmail,
    this.registerEmailSkip,
    this.facebookUserId,
    this.facebookUserName,
    this.facebookUserAEmail,
  });

  static SocialLoginReq create({
    required String authType,
    required String thirdPartCode,
    int? emailCheck,
    String? registerEmail,
    bool? registerEmailSkip,
  }) {
    return SocialLoginReq(
      source: authType,
      code: thirdPartCode,
      grant_type: 'social',
      platform: Platform.isAndroid ? 'ANDROID' : 'IOS',
      emailCheck: emailCheck,
      registerEmail: registerEmail,
      registerEmailSkip: registerEmailSkip,
    );
  }

  static SocialLoginReq createFaceBookLimit({
    required String authType,
    required String facebookUserId,
    required String facebookUserName,
    required String thirdPartCode,
    String? facebookUserAEmail,
    int? emailCheck,
    String? registerEmail,
    bool? registerEmailSkip,
  }) {
    return SocialLoginReq(
      source: authType,
      facebookUserId: facebookUserId,
      facebookUserName: facebookUserName,
      facebookUserAEmail: facebookUserAEmail,
      code: thirdPartCode,
      grant_type: 'social',
      platform: Platform.isAndroid ? 'ANDROID' : 'IOS',
      emailCheck: emailCheck,
      registerEmail: registerEmail,
      registerEmailSkip: registerEmailSkip,
    );
  }

  factory SocialLoginReq.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginReqFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginReqToJson(this);
}

/// 跳过三方登录绑定账号req
@JsonSerializable(includeIfNull: false)
class SocialSkipBindReq {
  String grant_type;
  String source;
  String scope;
  String socialUUid;
  String lang;
  String country;

  SocialSkipBindReq({
    required this.grant_type,
    required this.source,
    required this.scope,
    required this.socialUUid,
    required this.lang,
    required this.country,
  });

  static SocialSkipBindReq create({
    required String source,
    required String socialUUid,
    required String lang,
    required String country,
  }) {
    return SocialSkipBindReq(
      source: source,
      socialUUid: socialUUid,
      lang: lang,
      country: country,
      scope: 'all',
      grant_type: 'socialskip',
    );
  }

  factory SocialSkipBindReq.fromJson(Map<String, dynamic> json) =>
      _$SocialSkipBindReqFromJson(json);

  Map<String, dynamic> toJson() => _$SocialSkipBindReqToJson(this);
}

@JsonSerializable(includeIfNull: false)
class SocialSignInBindReq {
  String source;
  String socialUUid;
  String regType;
  String country;
  String lang;
  String scope;
  String grant_type;

  String? skipType;

  String? phone;
  String? phone_code;

  String? type;
  String? username;
  String? palinTextPwd;
  String? password;

  SocialSignInBindReq({
    required this.source,
    required this.socialUUid,
    required this.regType,
    required this.country,
    required this.lang,
    required this.scope,
    required this.grant_type,
    required this.skipType,
    this.phone,
    this.phone_code,
    this.type,
    this.username,
    this.palinTextPwd,
    this.password,
  });

  static SocialSignInBindReq createBindMobile({
    required String phone,
    required String phone_code,
    required String source,
    required String socialUUid,
    required String country,
    required String lang,
    required bool cover,
  }) {
    return SocialSignInBindReq(
      phone: phone,
      phone_code: phone_code,
      source: source,
      socialUUid: socialUUid,
      country: country,
      lang: lang,
      scope: 'all',
      regType: 'socialAutoRegisterBind',
      grant_type: 'socialsms',
      skipType: cover ? 'cover' : null,
    );
  }

  static SocialSignInBindReq createBindAccount({
    required String username,
    required String palinTextPwd,
    required String password,
    required String source,
    required String socialUUid,
    required String country,
    required String lang,
    required bool cover,
  }) {
    return SocialSignInBindReq(
      username: username,
      palinTextPwd: palinTextPwd,
      password: password,
      source: source,
      socialUUid: socialUUid,
      country: country,
      lang: lang,
      type: 'account',
      scope: 'all',
      regType: 'socialAutoRegisterBind',
      grant_type: 'password',
      skipType: cover ? 'cover' : null,
    );
  }

  factory SocialSignInBindReq.fromJson(Map<String, dynamic> json) =>
      _$SocialSignInBindReqFromJson(json);

  Map<String, dynamic> toJson() => _$SocialSignInBindReqToJson(this);
}
