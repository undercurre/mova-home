// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_userinfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialUserInfoModel _$SocialUserInfoModelFromJson(Map<String, dynamic> json) =>
    SocialUserInfoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$SocialUserInfoModelToJson(
        SocialUserInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
