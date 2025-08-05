import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_ui_state.freezed.dart';
part 'qr_scan_ui_state.g.dart';

@unfreezed
class QrScanUiState with _$QrScanUiState {
  factory QrScanUiState({
    @Default(false) bool loading,
    @Default(false) bool isTorchOn,
    @Default(false) bool isOverSea,
    @Default([]) List<IotDevice> scannedDevice,
    @Default([]) List<dynamic> dreameBarcode,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _QrScanUiState;
}

@freezed
class QrCodeContent with _$QrCodeContent {
  factory QrCodeContent({
    @Default('') String model,
    @Default('') String ap,
  }) = _QrCodeContent;

  factory QrCodeContent.fromJson(Map<String, dynamic> json) =>
      _$QrCodeContentFromJson(json);
}
