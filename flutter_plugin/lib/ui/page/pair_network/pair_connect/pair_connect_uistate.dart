import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'uiconfig/base_uiconfig.dart';

part 'pair_connect_uistate.freezed.dart';

@freezed
class PairConnectUiState with _$PairConnectUiState {
  const factory PairConnectUiState({
    @Default(false) bool enableBtn,
    @Default('text_connect_device_hotspot') String navTitle,
    IotPairNetworkInfo? iotPairNetworkInfo,
    @Default(UIStep.STEP_STATUS_NONE) int step1Status,
    @Default(UIStep.STEP_STATUS_NONE) int step2Status,
    @Default(UIStep.STEP_STATUS_NONE) int step3Status,
    String? step1Text,
    String? step2Text,
    String? step3Text,
    @Default(false) bool isShowManual,
    @Default('') String wifiName,
    @Default('assets/light/icons/3.0x/anim_manual_connect_zh')
    String manualAnimPath,
    @Default(false) bool isShowConnectDialog,
    @Default(false) bool showPinCode,
    @Default(0) int pinCodeStatus,
    @Default(0) int remain,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _PairConnectUiState;
}
