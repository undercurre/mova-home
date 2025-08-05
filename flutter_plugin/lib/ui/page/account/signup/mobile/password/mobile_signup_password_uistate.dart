import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_signup_password_uistate.freezed.dart';

@freezed
class MobileSignUpPasswordUiState with _$MobileSignUpPasswordUiState {
  const factory MobileSignUpPasswordUiState({
    @Default(false) bool isLoading,
    @Default(false) bool isButtonEnable,
    RegionItem? currentRegion,
    RegionItem? currentPhone,
    RegisterByPasswordReq? registerByPasswordReq,
    String? phoneNumber,
    String? dynamicCode,
    String? password,
    String? codeKey,
    @Default(true) bool hidePassword,
  }) = _MobileSignUpPasswordUiState;
}
