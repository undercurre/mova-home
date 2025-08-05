// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mall_my_info_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MallMyInfoRes _$MallMyInfoResFromJson(Map<String, dynamic> json) =>
    MallMyInfoRes(
      user_id: json['user_id'] as String?,
      nick: json['nick'] as String?,
      nick_name: json['nick_name'] as String?,
      avatar: json['avatar'] as String?,
      uid: json['uid'] as String?,
      level: json['level'] as String?,
      point: (json['point'] as num?)?.toInt(),
      coupon: (json['coupon'] as num?)?.toInt(),
      wait_pay: (json['wait_pay'] as num?)?.toInt(),
      wait_send: (json['wait_send'] as num?)?.toInt(),
      wait_receive: (json['wait_receive'] as num?)?.toInt(),
      finished: (json['finished'] as num?)?.toInt(),
      refunding: (json['refunding'] as num?)?.toInt(),
      reg_popup_count: (json['reg_popup_count'] as num?)?.toInt(),
      coupon_popup_count: (json['coupon_popup_count'] as num?)?.toInt(),
      point_popup_count: (json['point_popup_count'] as num?)?.toInt(),
      reg_reward_point: (json['reg_reward_point'] as num?)?.toInt(),
      order_reward_point: (json['order_reward_point'] as num?)?.toInt(),
      isAppRegister: (json['isAppRegister'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MallMyInfoResToJson(MallMyInfoRes instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'nick': instance.nick,
      'nick_name': instance.nick_name,
      'avatar': instance.avatar,
      'uid': instance.uid,
      'level': instance.level,
      'point': instance.point,
      'coupon': instance.coupon,
      'wait_pay': instance.wait_pay,
      'wait_send': instance.wait_send,
      'wait_receive': instance.wait_receive,
      'finished': instance.finished,
      'refunding': instance.refunding,
      'reg_popup_count': instance.reg_popup_count,
      'coupon_popup_count': instance.coupon_popup_count,
      'point_popup_count': instance.point_popup_count,
      'reg_reward_point': instance.reg_reward_point,
      'order_reward_point': instance.order_reward_point,
      'isAppRegister': instance.isAppRegister,
    };

MallBannerRes _$MallBannerResFromJson(Map<String, dynamic> json) =>
    MallBannerRes(
      json['id'] as String?,
      json['title'] as String?,
      json['image'] as String?,
      json['new_image'] as String?,
      json['video'] as String?,
      json['jump_type'] as String?,
      json['jump_url'] as String?,
      json['appid'] as String?,
    );

Map<String, dynamic> _$MallBannerResToJson(MallBannerRes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'new_image': instance.new_image,
      'video': instance.video,
      'jump_type': instance.jump_type,
      'jump_url': instance.jump_url,
      'appid': instance.appid,
    };

_$_BaseMallResponse<T> _$$_BaseMallResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$_BaseMallResponse<T>(
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      msg: json['msg'] as String?,
      code: (json['code'] as num?)?.toInt(),
      success: json['success'] as bool?,
      iRet: (json['iRet'] as num?)?.toInt(),
      sMsg: json['sMsg'] as String?,
    );

Map<String, dynamic> _$$_BaseMallResponseToJson<T>(
  _$_BaseMallResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'msg': instance.msg,
      'code': instance.code,
      'success': instance.success,
      'iRet': instance.iRet,
      'sMsg': instance.sMsg,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
