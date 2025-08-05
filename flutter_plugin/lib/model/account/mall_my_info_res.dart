import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mall_my_info_res.freezed.dart';

part 'mall_my_info_res.g.dart';

@Freezed(genericArgumentFactories: true)
class BaseMallResponse<T> with _$BaseMallResponse<T> {
  const factory BaseMallResponse(
      {T? data,
      String? msg,
      int? code,
      bool? success,
      int? iRet,
      String? sMsg}) = _BaseMallResponse;

  factory BaseMallResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$BaseMallResponseFromJson(json, fromJsonT);
}

class MallMyInfoReq extends MallBaseReq {
  final String? user_id;

  MallMyInfoReq({
    this.user_id,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> paramMap = <String, dynamic>{};
    paramMap['user_id'] = user_id;
    return toReqJson(paramMap);
  }
}

@JsonSerializable()
class MallMyInfoRes {
  String? user_id;
  String? nick;
  String? nick_name;
  String? avatar;
  String? uid;
  String? level;
  int? point;
  int? coupon;
  int? wait_pay;
  int? wait_send;
  int? wait_receive;
  int? finished;
  int? refunding;
  int? reg_popup_count;
  int? coupon_popup_count;
  int? point_popup_count;
  int? reg_reward_point;
  int? order_reward_point;
  int? isAppRegister;

  MallMyInfoRes(
      {this.user_id,
      this.nick,
      this.nick_name,
      this.avatar,
      this.uid,
      this.level,
      this.point,
      this.coupon,
      this.wait_pay,
      this.wait_send,
      this.wait_receive,
      this.finished,
      this.refunding,
      this.reg_popup_count,
      this.coupon_popup_count,
      this.point_popup_count,
      this.reg_reward_point,
      this.order_reward_point,
      this.isAppRegister});

  factory MallMyInfoRes.fromJson(Map<String, dynamic> json) =>
      _$MallMyInfoResFromJson(json);

  Map<String, dynamic> toJson() => _$MallMyInfoResToJson(this);
}

class MallBannerReq extends MallBaseReq {
  final int drop_position;
  final int banner_version;

  MallBannerReq({this.drop_position = 5, this.banner_version = 2});

  Map<String, dynamic> toJson() {
    return toReqJson(
        {'banner_version': banner_version, 'drop_position': drop_position});
  }
}

@JsonSerializable()
class MallBannerRes {
  String? id;
  String? title;
  String? image;
  String? new_image;
  String? video;
  String? jump_type;
  String? jump_url;
  String? appid;

  MallBannerRes(this.id, this.title, this.image, this.new_image, this.video,
      this.jump_type, this.jump_url, this.appid);

  Map<String, dynamic> toJson() => _$MallBannerResToJson(this);

  MallBannerRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    new_image = json['new_image'];
    video = json['video'];
    jump_type = json['jump_type'];
    jump_url = json['jump_url'];
    appid = json['appid'];
  }
}
