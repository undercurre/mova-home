import 'dart:io';

import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_bt_open_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_bt_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_camera_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_location_service_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_open_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';

class IotScanStepList {
  /// 产品列表页扫描步骤链
  static CommonStepChain initProdutListScanStepChain() {
    return CommonStepChain()
      ..configureStepChain(Platform.isAndroid
          ? [
              StepWifiPermissionRequestDialog(),
              StepWifiLocationServiceDialog(),

              /// 蓝牙
              StepBtPermissionRequestDialog(),
              StepWifiOpenRequestDialog(),
              StepBtOpenRequestDialog(),
            ]
          : [
              StepBtOpenRequestDialog(),
              // StepBtPermissionRequestDialog(),
            ]);
  }

  /// 扫码页扫描步骤链
  static CommonStepChain initQrCodeScanStepChain() {
    return CommonStepChain()
      ..configureStepChain(Platform.isAndroid
          ? [
              StepCameraPermissionRequestDialog(),
              StepWifiPermissionRequestDialog(),
              StepWifiLocationServiceDialog(),

              /// 蓝牙
              StepBtPermissionRequestDialog(),
              StepWifiOpenRequestDialog(),
              StepBtOpenRequestDialog(),
            ]
          : [
              StepCameraPermissionRequestDialog(),
              // StepBtPermissionRequestDialog(),
              StepBtOpenRequestDialog(),
            ]);
  }
}
