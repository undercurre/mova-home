import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_signup_uistate.freezed.dart';

@freezed
class EmailSignUpUiState with _$EmailSignUpUiState {
  const factory EmailSignUpUiState({
    @Default(false) bool isButtonEnable,
    required RegionItem currentRegion,
    required String regionName,
    String? account,
    String? password,
    String? confirmedPassword,
    @Default(false) bool isPrivacyChecked,
    @Default(true) bool hidePassword,
    @Default(false) bool isCn,
    @Default(true) bool isEmail,
  }) = _EmailSignUpUiState;
}
