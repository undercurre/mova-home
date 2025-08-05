import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pincode_verification_ui_state.freezed.dart';

@freezed
class PincodeVerificationUIState with _$PincodeVerificationUIState {
  factory PincodeVerificationUIState({
    @Default(false) bool enableBtn,
    @Default('') String pincode,
    @Default(0) int remainingTime,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _PincodeVerificationUIState;
}
