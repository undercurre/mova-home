import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_signup_uistate.freezed.dart';

@freezed
class MobileSignUpUiState with _$MobileSignUpUiState {
  const factory MobileSignUpUiState({
    @Default(false) bool isLoading,
    @Default(false) bool isButtonEnable,
    required RegionItem currentRegion,
    required String currentName,
    required RegionItem currentPhone,
    String? account,
    String? dynamicCode,
    String? codeKey,
    @Default(true) bool hidePassword,
    @Default(false) bool isPrivacyChecked,
    @Default(false) bool isPersonalizedAdChecked,
    @Default(false) bool isGetDynamic,
    @Default(false) bool enableGetDynamic,
    @Default(-1) int showChangeType, // -1 不显示 0 显示跳转手机号 1 显示跳转邮箱
    @Default(SignUpType.email) SignUpType singupType, // 是否是邮箱注册
  }) = _MobileSignUpUiState;
}
