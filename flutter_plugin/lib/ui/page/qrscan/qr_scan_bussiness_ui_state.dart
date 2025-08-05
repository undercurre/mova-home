import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_bussiness_ui_state.freezed.dart';

@freezed
class QrScanBussinessUiState with _$QrScanBussinessUiState {
  factory QrScanBussinessUiState({
    @Default(false) bool loading,
    @Default(false) bool isTorchOn,
    @Default([]) List<dynamic> dreameBarcode,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _QrScanBussinessUiState;
}
