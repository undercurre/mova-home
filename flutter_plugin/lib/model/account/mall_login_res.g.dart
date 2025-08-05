// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mall_login_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MallOpenInstallReq _$MallOpenInstallReqFromJson(Map<String, dynamic> json) =>
    MallOpenInstallReq(
      userId: json['user_id'] as String,
      ext: json['ext'] as String,
    );

Map<String, dynamic> _$MallOpenInstallReqToJson(MallOpenInstallReq instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'ext': instance.ext,
    };

MallLoginRes _$MallLoginResFromJson(Map<String, dynamic> json) => MallLoginRes(
      user_id: const StringOrIntConverter().fromJson(json['user_id']),
      nick: const StringOrIntConverter().fromJson(json['nick']),
      real_name: const StringOrIntConverter().fromJson(json['real_name']),
      birthday: const StringOrIntConverter().fromJson(json['birthday']),
      status: const StringOrIntConverter().fromJson(json['status']),
      age: const StringOrIntConverter().fromJson(json['age']),
      avatar: const StringOrIntConverter().fromJson(json['avatar']),
      active_time: const IntOrStringConverter().fromJson(json['active_time']),
      sex: const StringOrIntConverter().fromJson(json['sex']),
      accessToken: const StringOrIntConverter().fromJson(json['accessToken']),
      isTodayFirst: const IntOrStringConverter().fromJson(json['isTodayFirst']),
      phone: const StringOrIntConverter().fromJson(json['phone']),
      bind_popup_count:
          const IntOrStringConverter().fromJson(json['bind_popup_count']),
      other_bind_popup:
          const IntOrStringConverter().fromJson(json['other_bind_popup']),
      bind_reward_price:
          const IntOrStringConverter().fromJson(json['bind_reward_price']),
      bind_reward_point:
          const IntOrStringConverter().fromJson(json['bind_reward_point']),
      is_new_gift: const StringOrIntConverter().fromJson(json['is_new_gift']),
      reg_reward_point:
          const StringOrIntConverter().fromJson(json['reg_reward_point']),
      reg_reward_count:
          const StringOrIntConverter().fromJson(json['reg_reward_count']),
      reg_popup_count:
          const StringOrIntConverter().fromJson(json['reg_popup_count']),
      coupon_reward_count:
          const StringOrIntConverter().fromJson(json['coupon_reward_count']),
      coupon_popup_count:
          const StringOrIntConverter().fromJson(json['coupon_popup_count']),
      point_reward_count:
          const StringOrIntConverter().fromJson(json['point_reward_count']),
      point_popup_count:
          const StringOrIntConverter().fromJson(json['point_popup_count']),
      isAppRegister:
          const IntOrStringConverter().fromJson(json['isAppRegister']),
      isRegister: const IntOrStringConverter().fromJson(json['isRegister']),
      sceneSource: const IntOrStringConverter().fromJson(json['sceneSource']),
    );

Map<String, dynamic> _$MallLoginResToJson(MallLoginRes instance) =>
    <String, dynamic>{
      'user_id': const StringOrIntConverter().toJson(instance.user_id),
      'nick': const StringOrIntConverter().toJson(instance.nick),
      'real_name': const StringOrIntConverter().toJson(instance.real_name),
      'birthday': const StringOrIntConverter().toJson(instance.birthday),
      'status': const StringOrIntConverter().toJson(instance.status),
      'age': const StringOrIntConverter().toJson(instance.age),
      'sex': const StringOrIntConverter().toJson(instance.sex),
      'avatar': const StringOrIntConverter().toJson(instance.avatar),
      'active_time': const IntOrStringConverter().toJson(instance.active_time),
      'is_new_gift': const StringOrIntConverter().toJson(instance.is_new_gift),
      'reg_reward_point':
          const StringOrIntConverter().toJson(instance.reg_reward_point),
      'reg_reward_count':
          const StringOrIntConverter().toJson(instance.reg_reward_count),
      'reg_popup_count':
          const StringOrIntConverter().toJson(instance.reg_popup_count),
      'coupon_reward_count':
          const StringOrIntConverter().toJson(instance.coupon_reward_count),
      'coupon_popup_count':
          const StringOrIntConverter().toJson(instance.coupon_popup_count),
      'point_reward_count':
          const StringOrIntConverter().toJson(instance.point_reward_count),
      'point_popup_count':
          const StringOrIntConverter().toJson(instance.point_popup_count),
      'isAppRegister':
          const IntOrStringConverter().toJson(instance.isAppRegister),
      'isRegister': const IntOrStringConverter().toJson(instance.isRegister),
      'sceneSource': const IntOrStringConverter().toJson(instance.sceneSource),
      'accessToken': const StringOrIntConverter().toJson(instance.accessToken),
      'isTodayFirst':
          const IntOrStringConverter().toJson(instance.isTodayFirst),
      'phone': const StringOrIntConverter().toJson(instance.phone),
      'bind_popup_count':
          const IntOrStringConverter().toJson(instance.bind_popup_count),
      'other_bind_popup':
          const IntOrStringConverter().toJson(instance.other_bind_popup),
      'bind_reward_price':
          const IntOrStringConverter().toJson(instance.bind_reward_price),
      'bind_reward_point':
          const IntOrStringConverter().toJson(instance.bind_reward_point),
    };
