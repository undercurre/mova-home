import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'mobile_login_code_uistate.freezed.dart';

@freezed
class MobileLoginCodeUiState with _$MobileLoginCodeUiState {
  const factory MobileLoginCodeUiState({
    @Default(false) bool isLoading,
    @Default(false) bool isInputInvalid,
    @Default('') String account,
    @Default(60) int interval,
    String? codeKey,
    String? code,
    required RegionItem currentPhone,
    required RegionItem currentRegion,
  }) = _MobileLoginCodeUiState;
}
