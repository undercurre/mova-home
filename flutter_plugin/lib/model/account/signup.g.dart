// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterByPhonePasswordReq _$RegisterByPhonePasswordReqFromJson(
        Map<String, dynamic> json) =>
    RegisterByPhonePasswordReq(
      phone: json['phone'] as String,
      phoneCode: json['phoneCode'] as String,
      password: json['password'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      codeKey: json['codeKey'] as String,
      codeValue: json['codeValue'] as String,
    );

Map<String, dynamic> _$RegisterByPhonePasswordReqToJson(
        RegisterByPhonePasswordReq instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'phoneCode': instance.phoneCode,
      'password': instance.password,
      'country': instance.country,
      'lang': instance.lang,
      'codeKey': instance.codeKey,
      'codeValue': instance.codeValue,
    };

RegisterByPhoneReq _$RegisterByPhoneReqFromJson(Map<String, dynamic> json) =>
    RegisterByPhoneReq(
      phone: json['phone'] as String,
      phoneCode: json['phoneCode'] as String,
      password: json['password'] as String,
      confirmedPassword: json['confirmedPassword'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      codeKey: json['codeKey'] as String,
    );

Map<String, dynamic> _$RegisterByPhoneReqToJson(RegisterByPhoneReq instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'phoneCode': instance.phoneCode,
      'password': instance.password,
      'confirmedPassword': instance.confirmedPassword,
      'country': instance.country,
      'lang': instance.lang,
      'codeKey': instance.codeKey,
    };

RegisterByEmailReq _$RegisterByEmailReqFromJson(Map<String, dynamic> json) =>
    RegisterByEmailReq(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmedPassword: json['confirmedPassword'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      codeKey: json['codeKey'] as String,
    );

Map<String, dynamic> _$RegisterByEmailReqToJson(RegisterByEmailReq instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmedPassword': instance.confirmedPassword,
      'country': instance.country,
      'lang': instance.lang,
      'codeKey': instance.codeKey,
    };

EmailRegisterReq _$EmailRegisterReqFromJson(Map<String, dynamic> json) =>
    EmailRegisterReq(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmedPassword: json['confirmedPassword'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
    );

Map<String, dynamic> _$EmailRegisterReqToJson(EmailRegisterReq instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmedPassword': instance.confirmedPassword,
      'country': instance.country,
      'lang': instance.lang,
    };

EmailSocialRegisterReq _$EmailSocialRegisterReqFromJson(
        Map<String, dynamic> json) =>
    EmailSocialRegisterReq(
      email: json['email'] as String,
      password: json['password'] as String,
      confirmedPassword: json['confirmedPassword'] as String,
      country: json['country'] as String,
      lang: json['lang'] as String,
      socialUUid: json['socialUUid'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$EmailSocialRegisterReqToJson(
        EmailSocialRegisterReq instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'confirmedPassword': instance.confirmedPassword,
      'country': instance.country,
      'lang': instance.lang,
      'socialUUid': instance.socialUUid,
      'source': instance.source,
    };
