import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_ble_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_bt_wifi_state_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_wifi_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'iot_scan_device_cache_mixin.dart';
import 'iot_scan_permission_request_mixin.dart';

/// 设备扫描类
mixin IotScanDeviceMixin<T extends ConsumerStatefulWidget>
    on
        BasePageState<T>,
        IotScanPermissionRequestMixin<T>,
        IotBtWifiStateMixin<T>,
        IotWiFiScannerMixin,
        IotScanDeviceCacheMixin<T>,
        IotBleScannerMixin {
  /// 蓝牙扫描
  StreamSubscription<List<ScanResult>>? _bleScanResultsSubscription;

  List<ScanResult> _bleScanResults = [];

  List<WiFiAccessPoint> _wifiScanResults = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? _wifiScanResultsSubscription;

  /// 权限检查

  @override
  void initState() {
    super.initState();
    _subscribeScanResult();
    stepChainCheckPermission();
  }

  @override
  void dispose() {
    super.dispose();
    LogUtils.i(' sunzhibin iotScanDeviceMixin dispose $this');
    stopScanDevice();
    _wifiScanResultsSubscription?.cancel();
    _bleScanResultsSubscription?.cancel();
    // _isBleScanningSubscription?.cancel();
  }

  @override
  void onAppResumeAndActive() {
    LogUtils.i(' sunzhibin iotScanDeviceMixin onAppResume $this');
    stepChainCheckPermission();
  }

  @override
  void btStateChanged(bool isOpen, BluetoothAdapterState state) {
    super.btStateChanged(isOpen, state);
  }

  @override
  void wifiStateChanged(bool isOpen, ConnectivityResult state) {
    super.wifiStateChanged(isOpen, state);
  }

  @override
  void onPermissionSuccess(StepEvent event) {
    /// 所有条件都完成了，可以扫描了
    LogUtils.i(
        '-----sunzhibin------ onPermissionSuccess -----------$this :${_bleScanResults}');
    startScanDevice();
  }

  Future<void> startScanDevice({bool isScanningSkip = true}) async {
    LogUtils.i(
        '-----sunzhibin------ startScanDevice ----------- $this :${_bleScanResults}');
    if (_bleScanResultsSubscription?.isPaused == true) {
      _bleScanResultsSubscription?.resume();
    }
    if (_wifiScanResultsSubscription?.isPaused == true) {
      _wifiScanResultsSubscription?.resume();
    }
    var canSkipApAgain = isScanningSkip && isWifiScanning();
    if (!canSkipApAgain) {
      LogUtils.d(
          '-----IotScanDeviceMixin startScanDevice ----canSkipApAgain:$canSkipApAgain ');
      final isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
      LogUtils.d(
          '-----IotScanDeviceMixin startScanDevice ----isWifiEnabled:$isWifiEnabled ');
      var grand = await isWifiPermissionGrand();
      LogUtils.d(
          '-----IotScanDeviceMixin startScanDevice ----isWifiGrand:$grand ');
      if (isWifiEnabled && grand) {
        startScanWifi();
      }
    }
    var canSkipBtAgain = isScanningSkip && isBtScanning();
    if (!canSkipBtAgain) {
      LogUtils.d(
          '-----IotScanDeviceMixin startScanDevice ----canSkipBtAgain:$canSkipBtAgain ');
      var grand = await isBtPermissionGrand();
      LogUtils.d(
          '-----IotScanDeviceMixin startScanDevice ----isBtGrand:$grand ');
      if (grand) {
        startScanBt();
      }
    }
  }

  Future<void> stopScanDevice() async {
    LogUtils.i(
        '-----sunzhibin------ stopScanDevice ----------- : $this ${_bleScanResults}');

    if (await isWifiPermissionGrand()) {
      stopScanWifi();
    }
    if (await isBtPermissionGrand()) {
      await stopScanBt();
    }
    if (_bleScanResultsSubscription != null &&
        _bleScanResultsSubscription?.isPaused != true) {
      _bleScanResultsSubscription?.pause();
    }
    if (_wifiScanResultsSubscription != null &&
        _wifiScanResultsSubscription?.isPaused != true) {
      _wifiScanResultsSubscription?.pause();
    }
  }

  @override
  void onWifiStartCallback() {
    if (Platform.isIOS) {}
    if (Platform.isAndroid) {
      onStartCallback();
    }
  }

  @override
  void onWifiStopCallback() {
    if (Platform.isIOS) {}
    if (Platform.isAndroid) {
      onStopCallback(StepId.STEP_WIFI_PERMISSION_REQUEST_DIALOG);
    }
  }

  @override
  void onBtStartCallback() {
    onStartCallback();
  }

  @override
  void onBtStopCallback() {
    onStartCallback();
  }

  @override
  void onPermissionFail(StepId stepId) {
    onStopCallback(stepId);
  }

  void onStartCallback() {}

  void onStopCallback(StepId stepId) {}

  @override
  Future<void> onWifiGetScannedResults(List<WiFiAccessPoint> results) async {
    await addQueryDeviceInfoByModels(results);
  }

  void _subscribeScanResult() {
    /// 监听蓝牙扫描结果
    _bleScanResultsSubscription =
        FlutterBluePlus.onScanResults.listen((results) async {
      LogUtils.i(
          '-----BLE------ scanResults -----------$this :${getStringWithResults(results)}');
      if (results.isNotEmpty) {
        await addQueryProductInfoByPids(results);
      }
    }, onError: (e) {
      LogUtils.i('scanResults Error: $this ', e);
    });

    /// 监听wifi扫描结果
    _wifiScanResultsSubscription =
        WiFiScan.instance.onScannedResultsAvailable.listen((results) async {
      _wifiScanResults = results;
      LogUtils.i(
          '-----WIFI------ scanResults -----------$this :${results.map((e) => e.ssid).where((element) => element.startsWith('_miap'))}');
      if (results.isNotEmpty) {
        await addQueryDeviceInfoByModels(results);
      }
    }, onError: (e) {
      LogUtils.i('onScannedResultsAvailable Error: $this ', e);
    });
  }

  List<Map<String, dynamic>> getStringWithResults(List<ScanResult> results) {
    List<Map<String, dynamic>> newResults = results.map((result) {
      return {
        'platformName': result.device.platformName,
        'connectable': result.advertisementData.connectable,
        'serviceData': result.advertisementData.serviceData.map((key, value) =>
            MapEntry(key.toString(), String.fromCharCodes(value))),
        'serviceUuids': result.advertisementData.serviceUuids
            .map((uuid) => uuid.toString())
            .toList(),
      };
    }).toList();
    return newResults;
  }
}
