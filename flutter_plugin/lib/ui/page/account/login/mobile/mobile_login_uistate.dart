import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_login_uistate.freezed.dart';

@freezed
class MobileLoginUiState with _$MobileLoginUiState {
  const factory MobileLoginUiState({
    @Default(false) bool isButtonEnable,
    required String regionName,
    required RegionItem currentPhone,
    required RegionItem currentRegion,
    String? initAccount,
    String? phoneNumber,
    @Default(false) bool prepared,
    String? codeKey,
    @Default(false) bool isPrivacyChecked,
    String? lastSignInMobile,
  }) = _MobileLoginUiState;
}
