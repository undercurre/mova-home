import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_step_list.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// 扫描设备权限请求
mixin IotScanPermissionRequestMixin<T extends StatefulWidget> on State<T> {
  late CommonStepChain _chain;

  Future<StepResult>? _checkPermissionFuture = null;

  @override
  void initState() {
    super.initState();
    _chain = initStepChain();
  }

  /// 默认初始化扫描步骤链
  /// 产品列表页扫描步骤链
  CommonStepChain initStepChain() {
    return IotScanStepList.initProdutListScanStepChain();
  }

  @override
  void dispose() {
    super.dispose();
    _chain.clearSteps();
    _checkPermissionFuture = null;
  }

  Future<void> stepChainCheckPermission() async {
    if (_checkPermissionFuture != null) {
      return;
    }
    _checkPermissionFuture = _chain.proceed(StepEvent.from(), next: false);
    var ret = await _checkPermissionFuture!;
    LogUtils.i('stepChainCheckPermission $ret');
    _checkPermissionFuture = null;
    if (ret.success) {
      // 开启扫描
      LogUtils.i('stepChainCheckPermission success $this');
      onPermissionSuccess(ret.event);
    } else if (ret.isFinish) {
      if (ret.stepId != StepId.STEP_NONE) {
        LogUtils.i('stepChainCheckPermission fail  $this $ret');
        onPermissionFail(ret.stepId);
      } else {
        // do nothing
      }
    } else {
      LogUtils.i('stepChainCheckPermission waiting $this $ret');
    }
  }

  void onPermissionSuccess(StepEvent event) {}

  void onPermissionFail(StepId stepId) {}

  Future<bool> isBtPermissionGrand() async {
    if (Platform.isIOS) {
      Set<BluetoothAdapterState> inProgress = {
        BluetoothAdapterState.unknown,
        BluetoothAdapterState.turningOn
      };
      var asyncAdapterState = FlutterBluePlus.adapterState
          .where((v) => !inProgress.contains(v))
          .first;
      return await asyncAdapterState
          .timeout(const Duration(seconds: 3))
          .then((value) =>
              value == BluetoothAdapterState.turningOn ||
              BluetoothAdapterState.on == value)
          .onError((error, stackTrace) => false);
    } else if (Platform.isAndroid) {
      final isBtOpenState = await FlutterBluePlus.adapterState.first;
      LogUtils.d(
          '-----IotScanDeviceMixin startScanDevice ----isBtOpenState:$isBtOpenState ');
      if (isBtOpenState != BluetoothAdapterState.on) {
        return false;
      }
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt >= 31) {
        var bluetoothConnect = await Permission.bluetoothConnect.isGranted;
        var bluetoothScan = await Permission.bluetoothScan.isGranted;
        if (bluetoothConnect && bluetoothScan) {
          return true;
        }
      } else {
        var bluetooth = await Permission.bluetooth.isGranted;
        var locationWhenInUse = await Permission.locationWhenInUse.isGranted;
        if (bluetooth && locationWhenInUse) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> isWifiPermissionGrand() async {
    if (Platform.isIOS) {
      return false;
    }
    return await WiFiScan.instance.canStartScan(askPermissions: false) ==
        CanStartScan.yes;
  }
}
