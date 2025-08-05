import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_net_pincode_ui_state.freezed.dart';

@freezed
class PairNetPinCodeUIState with _$PairNetPinCodeUIState {
  factory PairNetPinCodeUIState({
    @Default(false) bool enableBtn,
    @Default('') String pincode,
    @Default(0) int remainingTime,
    @Default('') String showTime,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _PairNetPinCodeUIState;
}
