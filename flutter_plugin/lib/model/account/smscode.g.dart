// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smscode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SmsCodeSocialReqImpl _$$SmsCodeSocialReqImplFromJson(
        Map<String, dynamic> json) =>
    _$SmsCodeSocialReqImpl(
      phone: json['phone'] as String,
      phoneCode: json['phoneCode'] as String,
      lang: json['lang'] as String,
      token: json['token'] as String,
      sessionId: json['sessionId'] as String,
      sig: json['sig'] as String,
      socialUUid: json['socialUUid'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$$SmsCodeSocialReqImplToJson(
        _$SmsCodeSocialReqImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'phoneCode': instance.phoneCode,
      'lang': instance.lang,
      'token': instance.token,
      'sessionId': instance.sessionId,
      'sig': instance.sig,
      'socialUUid': instance.socialUUid,
      'source': instance.source,
    };

_$SmsCodeResImpl _$$SmsCodeResImplFromJson(Map<String, dynamic> json) =>
    _$SmsCodeResImpl(
      codeKey: json['codeKey'] as String?,
      maxSends: (json['maxSends'] as num?)?.toInt(),
      resetIn: (json['resetIn'] as num?)?.toInt(),
      interval: (json['interval'] as num?)?.toInt(),
      expireIn: (json['expireIn'] as num?)?.toInt(),
      remains: (json['remains'] as num?)?.toInt(),
      unregistered: json['unregistered'] as bool?,
    );

Map<String, dynamic> _$$SmsCodeResImplToJson(_$SmsCodeResImpl instance) =>
    <String, dynamic>{
      'codeKey': instance.codeKey,
      'maxSends': instance.maxSends,
      'resetIn': instance.resetIn,
      'interval': instance.interval,
      'expireIn': instance.expireIn,
      'remains': instance.remains,
      'unregistered': instance.unregistered,
    };

_$SmsGetCodeResImpl _$$SmsGetCodeResImplFromJson(Map<String, dynamic> json) =>
    _$SmsGetCodeResImpl(
      codeKey: json['codeKey'] as String?,
      expireIn: (json['expireIn'] as num?)?.toInt(),
      interval: (json['interval'] as num?)?.toInt(),
      maximum: (json['maximum'] as num?)?.toInt(),
      remains: (json['remains'] as num?)?.toInt(),
      resetIn: (json['resetIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SmsGetCodeResImplToJson(_$SmsGetCodeResImpl instance) =>
    <String, dynamic>{
      'codeKey': instance.codeKey,
      'expireIn': instance.expireIn,
      'interval': instance.interval,
      'maximum': instance.maximum,
      'remains': instance.remains,
      'resetIn': instance.resetIn,
    };

_$SmsTrCodeResImpl _$$SmsTrCodeResImplFromJson(Map<String, dynamic> json) =>
    _$SmsTrCodeResImpl(
      codeKey: json['codeKey'] as String?,
      maxSends: json['maxSends'] as String?,
      resetIn: json['resetIn'] as String?,
      interval: json['interval'] as String?,
      expireIn: json['expireIn'] as String?,
      remains: json['remains'] as String?,
      unregistered: json['unregistered'] as bool?,
    );

Map<String, dynamic> _$$SmsTrCodeResImplToJson(_$SmsTrCodeResImpl instance) =>
    <String, dynamic>{
      'codeKey': instance.codeKey,
      'maxSends': instance.maxSends,
      'resetIn': instance.resetIn,
      'interval': instance.interval,
      'expireIn': instance.expireIn,
      'remains': instance.remains,
      'unregistered': instance.unregistered,
    };

_$EmailGetCodeCheckReqImpl _$$EmailGetCodeCheckReqImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailGetCodeCheckReqImpl(
      email: json['email'] as String,
      lang: json['lang'] as String,
      sessionId: json['sessionId'] as String,
      token: json['token'] as String,
      sig: json['sig'] as String,
      skipEmailBoundVerify: json['skipEmailBoundVerify'] as bool,
    );

Map<String, dynamic> _$$EmailGetCodeCheckReqImplToJson(
        _$EmailGetCodeCheckReqImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'lang': instance.lang,
      'sessionId': instance.sessionId,
      'token': instance.token,
      'sig': instance.sig,
      'skipEmailBoundVerify': instance.skipEmailBoundVerify,
    };

_$EmailCheckCodeReqImpl _$$EmailCheckCodeReqImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailCheckCodeReqImpl(
      email: json['email'] as String,
      codeKey: json['codeKey'] as String,
      codeValue: json['codeValue'] as String,
      lang: json['lang'] as String? ?? '',
    );

Map<String, dynamic> _$$EmailCheckCodeReqImplToJson(
        _$EmailCheckCodeReqImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'codeKey': instance.codeKey,
      'codeValue': instance.codeValue,
      'lang': instance.lang,
    };

_$SmsCodeCheckResImpl _$$SmsCodeCheckResImplFromJson(
        Map<String, dynamic> json) =>
    _$SmsCodeCheckResImpl();

Map<String, dynamic> _$$SmsCodeCheckResImplToJson(
        _$SmsCodeCheckResImpl instance) =>
    <String, dynamic>{};

_$ResetPswByMailReqImpl _$$ResetPswByMailReqImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPswByMailReqImpl(
      codeKey: json['codeKey'] as String,
      confirmedPassword: json['confirmedPassword'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$ResetPswByMailReqImplToJson(
        _$ResetPswByMailReqImpl instance) =>
    <String, dynamic>{
      'codeKey': instance.codeKey,
      'confirmedPassword': instance.confirmedPassword,
      'password': instance.password,
      'email': instance.email,
    };

_$ResetPswByPhoneReqImpl _$$ResetPswByPhoneReqImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPswByPhoneReqImpl(
      codeKey: json['codeKey'] as String,
      confirmedPassword: json['confirmedPassword'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      phoneCode: json['phoneCode'] as String,
    );

Map<String, dynamic> _$$ResetPswByPhoneReqImplToJson(
        _$ResetPswByPhoneReqImpl instance) =>
    <String, dynamic>{
      'codeKey': instance.codeKey,
      'confirmedPassword': instance.confirmedPassword,
      'password': instance.password,
      'phone': instance.phone,
      'phoneCode': instance.phoneCode,
    };

_$MobileCheckCodeReqImpl _$$MobileCheckCodeReqImplFromJson(
        Map<String, dynamic> json) =>
    _$MobileCheckCodeReqImpl(
      phone: json['phone'] as String,
      phoneCode: json['phoneCode'] as String,
      codeKey: json['codeKey'] as String,
      codeValue: json['codeValue'] as String,
    );

Map<String, dynamic> _$$MobileCheckCodeReqImplToJson(
        _$MobileCheckCodeReqImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'phoneCode': instance.phoneCode,
      'codeKey': instance.codeKey,
      'codeValue': instance.codeValue,
    };

_$MobileUnbindReqImpl _$$MobileUnbindReqImplFromJson(
        Map<String, dynamic> json) =>
    _$MobileUnbindReqImpl(
      codeKey: json['codeKey'] as String,
    );

Map<String, dynamic> _$$MobileUnbindReqImplToJson(
        _$MobileUnbindReqImpl instance) =>
    <String, dynamic>{
      'codeKey': instance.codeKey,
    };

_$ChangePwdCheckReqImpl _$$ChangePwdCheckReqImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangePwdCheckReqImpl(
      confirmedPassword: json['confirmedPassword'] as String,
      newPassword: json['newPassword'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$ChangePwdCheckReqImplToJson(
        _$ChangePwdCheckReqImpl instance) =>
    <String, dynamic>{
      'confirmedPassword': instance.confirmedPassword,
      'newPassword': instance.newPassword,
      'password': instance.password,
    };

_$SettingPwdCheckReqImpl _$$SettingPwdCheckReqImplFromJson(
        Map<String, dynamic> json) =>
    _$SettingPwdCheckReqImpl(
      confirmedPassword: json['confirmedPassword'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$$SettingPwdCheckReqImplToJson(
        _$SettingPwdCheckReqImpl instance) =>
    <String, dynamic>{
      'confirmedPassword': instance.confirmedPassword,
      'newPassword': instance.newPassword,
    };

_$UnbindEmailReqImpl _$$UnbindEmailReqImplFromJson(Map<String, dynamic> json) =>
    _$UnbindEmailReqImpl(
      password: json['password'] as String,
    );

Map<String, dynamic> _$$UnbindEmailReqImplToJson(
        _$UnbindEmailReqImpl instance) =>
    <String, dynamic>{
      'password': instance.password,
    };
