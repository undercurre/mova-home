import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
part 'social.g.dart';

/// 用户信息 bean
@JsonSerializable()
class SocialInfo {
  String? id;
  String? source;
  String? tenantId;
  String? uid;
  String? userIld;
  String? uuid;

  SocialInfo({
    this.id,
    this.source,
    this.tenantId,
    this.uid,
    this.userIld,
    this.uuid,
  });
  factory SocialInfo.fromJson(Map<String, dynamic> json) =>
      _$SocialInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SocialInfoToJson(this);
}

// 绑定第三方账号Request
@JsonSerializable(includeIfNull: false)
class SocialBindReq {
  String? code; //第三方token，idtoken
  String? coverType; //覆盖原有账号
  String platform = Platform.isAndroid ? 'ANDROID' : 'IOS'; //
  String source; //来源GOOGLE_APP,FACEBOOK_APP,APPLE,WECHAT_OPEN
  SocialBindextraMapReq? extraMap;

  SocialBindReq({
    required this.source,
    this.code,
    this.coverType,
    this.extraMap,
  });

  factory SocialBindReq.fromJson(Map<String, dynamic> json) =>
      _$SocialBindReqFromJson(json);
  Map<String, dynamic> toJson() => _$SocialBindReqToJson(this);
}

// 绑定第三方账号额外
@JsonSerializable(includeIfNull: false)
class SocialBindextraMapReq {
  String? facebookUserId;
  String? facebookUserName;
  String? facebookUserAEmail;

  SocialBindextraMapReq({
    this.facebookUserId,
    this.facebookUserName,
    this.facebookUserAEmail,
  });

  factory SocialBindextraMapReq.fromJson(Map<String, dynamic> json) =>
      _$SocialBindextraMapReqFromJson(json);
  Map<String, dynamic> toJson() => _$SocialBindextraMapReqToJson(this);
}

// 解绑第三方账号Request
@JsonSerializable(includeIfNull: false)
class SocialUnBindReq {
  String id;
  String source;

  SocialUnBindReq({
    required this.id,
    required this.source,
  });

  factory SocialUnBindReq.fromJson(Map<String, dynamic> json) =>
      _$SocialUnBindReqFromJson(json);
  Map<String, dynamic> toJson() => _$SocialUnBindReqToJson(this);
}

enum SocialPlatformType {
  none,
  wechat,
  apple,
  google,
  facebook,
}

extension SocialPlatformTypeNumber on SocialPlatformType {
  int get number {
    switch (this) {
      case SocialPlatformType.wechat:
        return 1;
      case SocialPlatformType.apple:
        return 1001;
      case SocialPlatformType.google:
        return 30;
      case SocialPlatformType.facebook:
        return 16;
      default:
        return 0;
    }
  }
}

extension SocialPlatformTypeValue on SocialPlatformType {
  String get value {
    switch (this) {
      case SocialPlatformType.wechat:
        return 'WECHAT_OPEN';
      case SocialPlatformType.apple:
        return 'APPLE';
      case SocialPlatformType.google:
        return 'GOOGLE_APP';
      case SocialPlatformType.facebook:
        return 'FACEBOOK_APP';
      default:
        return '';
    }
  }

  String get textValue {
    switch (this) {
      case SocialPlatformType.wechat:
        return 'share_weixin'.tr();
      case SocialPlatformType.apple:
        return 'Apple ID';
      case SocialPlatformType.google:
        return 'Google';
      case SocialPlatformType.facebook:
        return 'Facebook';
      default:
        return '';
    }
  }
}
