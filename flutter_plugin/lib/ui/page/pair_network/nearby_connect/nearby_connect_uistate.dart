import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_connect_uistate.freezed.dart';

enum ScanState { Scaning, ScanStop }

@freezed
class NearbyConnectUiState with _$NearbyConnectUiState {
  const factory NearbyConnectUiState({
    @Default(false) bool enableBtn,
    IotPairNetworkInfo? iotPairNetworkInfo,
    @Default(ScanState.Scaning) ScanState scanState,
    @Default([]) List<IotDevice> scanList,
    @Default(0) double progress,
    IotDevice? selectedDevice,
    @Default(1) int currentStep,
    @Default(1) int totalStep,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _NearbyConnectUiState;
}
