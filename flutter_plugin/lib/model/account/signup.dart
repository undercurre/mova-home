import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup.g.dart';

@JsonSerializable()
class RegisterByPhonePasswordReq {
  final String phone;
  final String phoneCode;
  final String password;
  final String country;
  final String lang;
  final String codeKey;
  final String codeValue;
  RegisterByPhonePasswordReq({
    required this.phone,
    required this.phoneCode,
    required this.password,
    required this.country,
    required this.lang,
    required this.codeKey,
    required this.codeValue,
  });
  factory RegisterByPhonePasswordReq.fromJson(Map<String, dynamic> json) =>
      _$RegisterByPhonePasswordReqFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterByPhonePasswordReqToJson(this);
}

class RegisterByPasswordReq {
  void updatePassword(String newPassword) {}
}

@JsonSerializable()
class RegisterByPhoneReq extends RegisterByPasswordReq {
  final String phone;
  final String phoneCode;
  late String password;
  late String confirmedPassword;
  final String country;
  final String lang;
  final String codeKey;
  RegisterByPhoneReq({
    required this.phone,
    required this.phoneCode,
    required this.password,
    required this.confirmedPassword,
    required this.country,
    required this.lang,
    required this.codeKey,
  });
  factory RegisterByPhoneReq.fromJson(Map<String, dynamic> json) =>
      _$RegisterByPhoneReqFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterByPhoneReqToJson(this);
  @override
  void updatePassword(String newPassword) {
    password = newPassword;
    confirmedPassword = newPassword;
  }
}

@JsonSerializable()
class RegisterByEmailReq extends RegisterByPasswordReq {
  final String email;
  late String password;
  late String confirmedPassword;
  final String country;
  final String lang;
  final String codeKey;
  RegisterByEmailReq({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.country,
    required this.lang,
    required this.codeKey,
  });
  factory RegisterByEmailReq.fromJson(Map<String, dynamic> json) =>
      _$RegisterByEmailReqFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterByEmailReqToJson(this);
  @override
  void updatePassword(String newPassword) {
    password = newPassword;
    confirmedPassword = newPassword;
  }
}

@JsonSerializable()
class EmailRegisterReq {
  final String email;
  final String password;
  final String confirmedPassword;
  final String country;
  final String lang;
  EmailRegisterReq({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.country,
    required this.lang,
  });
  factory EmailRegisterReq.fromJson(Map<String, dynamic> json) =>
      _$EmailRegisterReqFromJson(json);

  Map<String, dynamic> toJson() => _$EmailRegisterReqToJson(this);
}

@JsonSerializable()
class EmailSocialRegisterReq {
  final String email;
  final String password;
  final String confirmedPassword;
  final String country;
  final String lang;
  final String socialUUid;
  final String source;
  EmailSocialRegisterReq({
    required this.email,
    required this.password,
    required this.confirmedPassword,
    required this.country,
    required this.lang,
    required this.socialUUid,
    required this.source,
  });
  factory EmailSocialRegisterReq.fromJson(Map<String, dynamic> json) =>
      _$EmailSocialRegisterReqFromJson(json);

  Map<String, dynamic> toJson() => _$EmailSocialRegisterReqToJson(this);
}
