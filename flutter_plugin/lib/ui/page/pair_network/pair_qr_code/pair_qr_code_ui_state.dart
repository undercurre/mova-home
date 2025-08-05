import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_qr_code_ui_state.freezed.dart';

@freezed
class PairQrCodeUiState with _$PairQrCodeUiState {
  const factory PairQrCodeUiState({
    @Default(false) bool showLoading,
    @Default(false) bool enableBtn,
    @Default('') String pairQRValue,
    IotPairNetworkInfo? iotPairNetworkInfo,
    @Default(0) int currentStep,
    @Default(0) int totalSteps,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _PairQrCodeUiState;
}
