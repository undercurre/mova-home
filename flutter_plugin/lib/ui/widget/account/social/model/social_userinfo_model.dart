import 'package:freezed_annotation/freezed_annotation.dart';
part 'social_userinfo_model.g.dart';

@JsonSerializable()
class SocialUserInfoModel {
  final String id;
  final String name;
  String? email;
  SocialUserInfoModel({
    required this.id,
    required this.name,
    this.email,
  });
  factory SocialUserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$SocialUserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialUserInfoModelToJson(this);
}

enum SocialType {
  facebook,
  google,
  apple,
  wechat,
}

class SocialTruck {
  final SocialType type;
  final SocialUserInfoModel? userInfo;
  final String? token;
  SocialTruck({
    required this.type,
    this.userInfo,
    this.token,
  });
}
