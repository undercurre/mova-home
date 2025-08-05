import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_plugin/utils/json/int_string_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mall_login_res.g.dart';

class MallBaseReq {
  final String api = Platform.isAndroid ? 'a_1664246268' : 'i_1666147923';
  final int sign_time = DateTime.now().microsecondsSinceEpoch;
  final String security_key =
      Platform.isAndroid ? 'b_m3I6PiPgYX#' : 'b_m3h^jWfA9jp';
  final String? sign;

  MallBaseReq({this.sign});

  Map<String, dynamic> toReqJson(Map<String, dynamic> paramMap) {
    final reqMap = <String, dynamic>{
      'api': api,
      'sign_time': '${DateTime.now().microsecondsSinceEpoch}',
      'security_key': security_key
    };
    reqMap.addAll(paramMap);

    List<String> keys = reqMap.keys.toList();
    keys.sort();
    // keys.toList().sort();
    List<String> kvs = [];
    for (var key in keys) {
      // ignore: prefer_interpolation_to_compose_strings
      String kv = '$key=${reqMap[key]}';
      kvs.add(kv);
    }
    String params = kvs.join('&');
    var content = const Utf8Encoder().convert(params);
    var digest = md5.convert(content);
    reqMap['sign'] = digest.toString();
    return reqMap;
  }
}

@JsonSerializable()
class MallOpenInstallReq extends MallBaseReq {
  @JsonKey(name: 'user_id')
  final String userId;
  final String ext;
  
  MallOpenInstallReq({
    required this.userId,
    required this.ext,
  });

  Map<String, dynamic> toJson() => _$MallOpenInstallReqToJson(this);
}


class MallLoginReq extends MallBaseReq {
  final String jwtToken;

  MallLoginReq({
    required this.jwtToken,
  });

  Map<String, dynamic> toJson() {
    return toReqJson({'jwtToken': jwtToken});
  }
}

@JsonSerializable()
class MallLoginRes {

  @StringOrIntConverter()
  final String? user_id;

  @StringOrIntConverter()
  final String? nick;

  @StringOrIntConverter()
  final String? real_name;

  @StringOrIntConverter()
  final String? birthday;

  // final MallAreaModel? area;

  @StringOrIntConverter()
  final String? status;

  @StringOrIntConverter()
  final String? age;

  @StringOrIntConverter()
  final String? sex;

  @StringOrIntConverter()
  final String? avatar;

  @IntOrStringConverter()
  final int? active_time;

  @StringOrIntConverter()
  final String? is_new_gift;

  @StringOrIntConverter()
  final String? reg_reward_point;

  @StringOrIntConverter()
  final String? reg_reward_count;

  @StringOrIntConverter()
  final String? reg_popup_count;

  @StringOrIntConverter()
  final String? coupon_reward_count;

  @StringOrIntConverter()
  final String? coupon_popup_count;

  @StringOrIntConverter()
  final String? point_reward_count;

  @StringOrIntConverter()
  final String? point_popup_count;

  @IntOrStringConverter()
  final int? isAppRegister;

  @IntOrStringConverter()
  final int? isRegister;

  @IntOrStringConverter()
  final int? sceneSource;

  //商城使用

  @StringOrIntConverter()
  final String? accessToken;

  @IntOrStringConverter()
  final int? isTodayFirst;

  @StringOrIntConverter()
  final String? phone;

  @IntOrStringConverter()
  final int? bind_popup_count;

  @IntOrStringConverter()
  final int? other_bind_popup;

  @IntOrStringConverter()
  final int? bind_reward_price;

  @IntOrStringConverter()
  final int? bind_reward_point;

  MallLoginRes({
    this.user_id,
    this.nick,
    this.real_name,
    this.birthday,
    this.status,
    this.age,
    this.avatar,
    this.active_time,
    this.sex,
    this.accessToken,
    this.isTodayFirst,
    this.phone,
    this.bind_popup_count,
    this.other_bind_popup,
    this.bind_reward_price,
    this.bind_reward_point,
    this.is_new_gift,
    this.reg_reward_point,
    this.reg_reward_count,
    this.reg_popup_count,
    this.coupon_reward_count,
    this.coupon_popup_count,
    this.point_reward_count,
    this.point_popup_count,
    this.isAppRegister,
    this.isRegister,
    this.sceneSource,
  });

  factory MallLoginRes.fromJson(Map<String, dynamic> json) =>
      _$MallLoginResFromJson(json);

  Map<String, dynamic> toJson() => _$MallLoginResToJson(this);
}

class MallAreaModel {
  final String? province;
  final String? city;
  final String? district;

  MallAreaModel({
    this.province,
    this.city,
    this.district,
  });

  factory MallAreaModel.fromJson(Map<String, dynamic> json) {
    return MallAreaModel(
      province: json['province'],
      city: json['city'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['province'] = province;
    map['city'] = city;
    map['district'] = district;
    return map;
  }
}

class EmailCollectionRes {
  final int emailPush;

  EmailCollectionRes({
    required this.emailPush,
  });

  static EmailCollectionRes fromJson(Map<String, dynamic> json) {
    EmailCollectionRes req = EmailCollectionRes(
      emailPush: json['emailPush'],
    );
    return req;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['emailPush'] = emailPush;
    return map;
  }
}

class EmailCollectionSubscribeRep {
  final int status;

  EmailCollectionSubscribeRep({
    required this.status,
  });

  static EmailCollectionSubscribeRep fromJson(Map<String, dynamic> json) {
    EmailCollectionSubscribeRep req = EmailCollectionSubscribeRep(
      status: json['status'],
    );
    return req;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['status'] = status;
    return map;
  }
}
