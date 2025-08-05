import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_email_uistate.freezed.dart';

@freezed
class SignUpEmailUiState with _$SignUpEmailUiState {
  const factory SignUpEmailUiState({
    @Default(false) bool isLoading,
    @Default(false) bool isButtonEnable,
    required RegionItem currentRegion,
    required String currentName,
    required RegionItem currentPhone,
    String? email,
    String? dynamicCode,
    String? password,
    String? codeKey,
    @Default(true) bool hidePassword,
    @Default(false) bool isPrivacyChecked,
    @Default(false) bool isGetDynamic,
    @Default(false) bool enableGetDynamic,
  }) = _SignUpEmailUiState;
}
