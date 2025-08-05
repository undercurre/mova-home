import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'smscode.freezed.dart';

part 'smscode.g.dart';

/// 发送验证码
// @freezed
// class SmsCodeReq with _$SmsCodeReq {
//   const factory SmsCodeReq({
//     required String phone,
//     required String phoneCode,
//     required String lang,
//     required String token,
//     required String sessionId,
//     required String sig,
//   }) = _SmsCodeReq;

//   factory SmsCodeReq.fromJson(Map<String, dynamic> json) =>
//       _$SmsCodeReqFromJson(json);
// }

/// 三方登录发送验证码
@freezed
class SmsCodeSocialReq with _$SmsCodeSocialReq {
  const factory SmsCodeSocialReq({
    required String phone,
    required String phoneCode,
    required String lang,
    required String token,
    required String sessionId,
    required String sig,
    required String socialUUid,
    required String source,
  }) = _SmsCodeSocialReq;

  factory SmsCodeSocialReq.fromJson(Map<String, dynamic> json) =>
      _$SmsCodeSocialReqFromJson(json);
}

@freezed
abstract class SmsCodeRes with _$SmsCodeRes {
  const factory SmsCodeRes(
      {String? codeKey,
      int? maxSends,
      int? resetIn,
      int? interval,
      int? expireIn,
      int? remains,
      bool? unregistered}) = _SmsCodeRes;

  factory SmsCodeRes.fromJson(Map<String, dynamic> json) =>
      _$SmsCodeResFromJson(json);
}

/// 修改手机号获取验证码接口response
@freezed
abstract class SmsGetCodeRes with _$SmsGetCodeRes {
  const factory SmsGetCodeRes({
    String? codeKey,
    int? expireIn,
    int? interval,
    int? maximum,
    int? remains,
    int? resetIn,
  }) = _SmsGetCodeRes;

  factory SmsGetCodeRes.fromJson(Map<String, dynamic> json) =>
      _$SmsGetCodeResFromJson(json);
}

@freezed
abstract class SmsTrCodeRes with _$SmsTrCodeRes {
  const SmsTrCodeRes._();
  const factory SmsTrCodeRes(
      {String? codeKey,
      String? maxSends,
      String? resetIn,
      String? interval,
      String? expireIn,
      String? remains,
      bool? unregistered}) = _SmsTrCodeRes;

  factory SmsTrCodeRes.fromJson(Map<String, dynamic> json) =>
      _$SmsTrCodeResFromJson(json);

  SmsCodeRes toResult() {
    int? fixmaxSend = maxSends != null ? int.tryParse(maxSends!) : null;
    int? fixresetIn = resetIn != null ? int.tryParse(resetIn!) : null;
    int? fixinterval = interval != null ? int.tryParse(interval!) : null;
    int? fixexpireIn = expireIn != null ? int.tryParse(expireIn!) : null;
    int? fixremains = remains != null ? int.tryParse(remains!) : null;
    SmsCodeRes res = SmsCodeRes(
        codeKey: codeKey,
        maxSends: fixmaxSend,
        resetIn: fixresetIn,
        interval: fixinterval,
        expireIn: fixexpireIn,
        remains: fixremains,
        unregistered: unregistered);
    return res;
  }
}

/// 邮箱发送验证码
// @freezed
// class EmailCodeReq with _$EmailCodeReq {
// const factory EmailCodeReq({
//   required String email,
//   required String lang,
//   String? token,
//   String? sessionId,
//   String? sig,
// }) = _EmailCodeReq;

//   factory EmailCodeReq.fromJson(Map<String, dynamic> json) =>
//       _$EmailCodeReqFromJson(json);
// }

class BaseCodeReq {
  BaseCodeReq({
    this.token,
    this.sessionId,
    this.sig,
  });
  String? token;
  String? sessionId;
  String? sig;
}

class EmailCodeReq extends BaseCodeReq {
  EmailCodeReq({
    required this.email,
    required this.lang,
    this.skipEmailBoundVerify,
    this.checkRegisterFlag,
    super.token,
    super.sessionId,
    super.sig,
  });
  String email;
  String lang;
  bool? skipEmailBoundVerify;
  bool? checkRegisterFlag;
  EmailCodeReq fromJson(Map<String, dynamic> json) {
    EmailCodeReq req = EmailCodeReq(
      email: json['email'],
      lang: json['lang'],
      token: json['token'],
      sessionId: json['sessionId'],
      sig: json['sig'],
      skipEmailBoundVerify: json['skipEmailBoundVerify'],
      checkRegisterFlag: json['checkRegisterFlag'],
    );
    return req;
  }

  EmailCodeReq copyWith({
    String? email,
    String? lang,
    String? token,
    String? sessionId,
    String? sig,
    bool? skipEmailBoundVerify,
    bool? checkRegisterFlag,
  }) {
    return EmailCodeReq(
      email: email ?? this.email,
      lang: lang ?? this.lang,
      token: this.token,
      sessionId: this.sessionId,
      sig: this.sig,
      skipEmailBoundVerify: skipEmailBoundVerify ?? this.skipEmailBoundVerify,
      checkRegisterFlag: checkRegisterFlag ?? this.checkRegisterFlag,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['email'] = email;
    map['lang'] = lang;
    if (token != null) {
      map['token'] = token;
    }
    if (sessionId != null) {
      map['sessionId'] = sessionId;
    }
    if (sig != null) {
      map['sig'] = sig;
    }
    if (skipEmailBoundVerify != null) {
      map['skipEmailBoundVerify'] = skipEmailBoundVerify;
    }
    if (checkRegisterFlag != null) {
      map['checkRegisterFlag'] = checkRegisterFlag;
    }
    return map;
  }
}

/// 发送验证码
// @freezed
class SmsCodeReq extends BaseCodeReq {
  SmsCodeReq({
    required this.phone,
    required this.phoneCode,
    required this.lang,
    super.token,
    super.sessionId,
    super.sig,
    this.skipPhoneBoundVerify,
  });

  String phone;
  String phoneCode;
  String lang;
  bool? skipPhoneBoundVerify;

  SmsCodeReq fromJson(Map<String, dynamic> json) {
    SmsCodeReq req = SmsCodeReq(
      phone: json['phone'],
      phoneCode: json['phoneCode'],
      lang: json['lang'],
      token: json['token'],
      sessionId: json['sessionId'],
      sig: json['sig'],
      skipPhoneBoundVerify: json['skipPhoneBoundVerify'],
    );
    return req;
  }

  SmsCodeReq copyWith({
    String? phone,
    String? phoneCode,
    String? lang,
    String? token,
    String? sessionId,
    String? sig,
    bool? skipPhoneBoundVerify,
  }) {
    return SmsCodeReq(
      phone: phone ?? this.phone,
      phoneCode: phoneCode ?? this.phoneCode,
      lang: lang ?? this.lang,
      token: this.token,
      sessionId: this.sessionId,
      sig: this.sig,
      skipPhoneBoundVerify: this.skipPhoneBoundVerify,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['phone'] = phone;
    map['phoneCode'] = phoneCode;
    map['lang'] = lang;
    map['token'] = token;
    map['sessionId'] = sessionId;
    map['sig'] = sig;
    if (skipPhoneBoundVerify != null) {
      map['skipPhoneBoundVerify'] = skipPhoneBoundVerify;
    }

    return map;
  }
}

@freezed
class EmailGetCodeCheckReq with _$EmailGetCodeCheckReq {
  const factory EmailGetCodeCheckReq({
    required String email,
    required String lang,
    required String sessionId,
    required String token,
    required String sig,
    required bool skipEmailBoundVerify,
  }) = _EmailGetCodeCheckReq;

  factory EmailGetCodeCheckReq.fromJson(Map<String, dynamic> json) =>
      _$EmailGetCodeCheckReqFromJson(json);
}

/// 邮箱校验验证码
@freezed
class EmailCheckCodeReq with _$EmailCheckCodeReq {
  const factory EmailCheckCodeReq({
    required String email,
    required String codeKey,
    required String codeValue,
    @Default('') String? lang,
  }) = _EmailCheckCodeReq;

  factory EmailCheckCodeReq.fromJson(Map<String, dynamic> json) =>
      _$EmailCheckCodeReqFromJson(json);
}

@freezed
class SmsCodeCheckRes with _$SmsCodeCheckRes {
  const factory SmsCodeCheckRes() = _SmsCodeCheckRes;

  factory SmsCodeCheckRes.fromJson(Map<String, dynamic> json) =>
      _$SmsCodeCheckResFromJson(json);
}

//邮箱重置验证码
@freezed
class ResetPswByMailReq with _$ResetPswByMailReq {
  const factory ResetPswByMailReq({
    required String codeKey,
    required String confirmedPassword,
    required String password,
    required String email,
  }) = _ResetPswByMailReq;

  factory ResetPswByMailReq.fromJson(Map<String, dynamic> json) =>
      _$ResetPswByMailReqFromJson(json);
}

//手机重置验证码
@freezed
class ResetPswByPhoneReq with _$ResetPswByPhoneReq {
  const factory ResetPswByPhoneReq({
    required String codeKey,
    required String confirmedPassword,
    required String password,
    required String phone,
    required String phoneCode,
  }) = _ResetPswByPhoneReq;

  factory ResetPswByPhoneReq.fromJson(Map<String, dynamic> json) =>
      _$ResetPswByPhoneReqFromJson(json);
}

/// 手机校验验证码
@freezed
class MobileCheckCodeReq with _$MobileCheckCodeReq {
  const factory MobileCheckCodeReq({
    required String phone,
    required String phoneCode,
    required String codeKey,
    required String codeValue,
  }) = _MobileCheckCodeReq;

  factory MobileCheckCodeReq.fromJson(Map<String, dynamic> json) =>
      _$MobileCheckCodeReqFromJson(json);
}

@freezed
class MobileUnbindReq with _$MobileUnbindReq {
  const factory MobileUnbindReq({
    required String codeKey,
  }) = _MobileUnbindReq;

  factory MobileUnbindReq.fromJson(Map<String, dynamic> json) =>
      _$MobileUnbindReqFromJson(json);
}

/// 修改个人安全信息
class FixSafeInfoCodeReq {
  FixSafeInfoCodeReq({
    this.phone,
    this.phoneCode,
    this.email,
    required this.codeKey,
    required this.coverOtherAccountPhone,
  });

  String? codeKey;
  String? email;
  String? phone;
  String? phoneCode;
  bool coverOtherAccountPhone = false;

  FixSafeInfoCodeReq fromJson(Map<String, dynamic> json) {
    FixSafeInfoCodeReq req = FixSafeInfoCodeReq(
      phone: json['phone'],
      phoneCode: json['phoneCode'],
      codeKey: json['codeKey'],
      email: json['email'],
      coverOtherAccountPhone: json['coverOtherAccountPhone'],
    );
    return req;
  }

  // SmsCodeReq copyWith({
  //   String? phone,
  //   String? phoneCode,
  //   String? lang,
  //   String? token,
  //   String? sessionId,
  //   String? sig,
  //   bool? skipPhoneBoundVerify,
  // }) {
  //   return SmsCodeReq(
  //     phone: phone ?? this.phone,
  //     phoneCode: phoneCode ?? this.phoneCode,
  //     lang: lang ?? this.lang,
  //     token: this.token,
  //     sessionId: this.sessionId,
  //     sig: this.sig,
  //     skipPhoneBoundVerify: this.skipPhoneBoundVerify,
  //   );
  // }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['phone'] = phone;
    map['phoneCode'] = phoneCode;
    map['codeKey'] = codeKey;
    map['email'] = email;
    map['coverOtherAccountPhone'] = coverOtherAccountPhone;
    return map;
  }
}

///  修改个人密码
@freezed
class ChangePwdCheckReq with _$ChangePwdCheckReq {
  const factory ChangePwdCheckReq({
    required String confirmedPassword,
    required String newPassword,
    required String password,
  }) = _ChangePwdCheckReq;

  factory ChangePwdCheckReq.fromJson(Map<String, dynamic> json) =>
      _$ChangePwdCheckReqFromJson(json);
}

///  设置个人密码
@freezed
class SettingPwdCheckReq with _$SettingPwdCheckReq {
  const factory SettingPwdCheckReq({
    required String confirmedPassword,
    required String newPassword,
  }) = _SettingPwdCheckReq;

  factory SettingPwdCheckReq.fromJson(Map<String, dynamic> json) =>
      _$SettingPwdCheckReqFromJson(json);
}

///  解绑定个人邮箱Request
@freezed
class UnbindEmailReq with _$UnbindEmailReq {
  const factory UnbindEmailReq({
    required String password,
  }) = _UnbindEmailReq;

  factory UnbindEmailReq.fromJson(Map<String, dynamic> json) =>
      _$UnbindEmailReqFromJson(json);
}
