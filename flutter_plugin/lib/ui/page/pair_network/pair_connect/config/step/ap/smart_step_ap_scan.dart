import 'dart:async';

import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_wifi_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../smart_step_event.dart';
import 'smart_step_ap_connect.dart';

class SmartStepApScan extends SmartStepConfig with IotWiFiScannerMixin {
  @override
  StepId get stepId => StepId.STEP_WIFI_SCAN;

  /// 蓝牙扫描
  StreamSubscription<List<WiFiAccessPoint>>? _apScanResultsSubscription;
  int scanCount = 0;

  @override
  void handleMessage(msg) {}

  @override
  Future<void> stepCreate() async {
    _subscribeScanResult();
    scanCount = 1;
    postEvent(
        SmartStepEvent(StepName.STEP_CONNECT, status: SmartStepStatus.start));
    startScanWifi();
  }

  @override
  void onWifiStopCallback() {
    if (scanCount <= 1) {
      scanCount++;
      startScanWifi();
    } else {
      postEvent(SmartStepEvent(StepName.STEP_CONNECT,
          status: SmartStepStatus.failed));
    }
  }

  void _subscribeScanResult() {
    /// 监听蓝牙扫描结果
    _apScanResultsSubscription =
        WiFiScan.instance.onScannedResultsAvailable.listen((results) {
      onscanResult(results);
    }, onError: (e) {
      LogUtils.e('scanResults Error: $this ', e);
    });
  }

  @override
  void onWifiGetScannedResults(List<WiFiAccessPoint> results) {
    onscanResult(results);
  }

  void onscanResult(List<WiFiAccessPoint> results) {
    LogUtils.d('-----WIFI------ scanResults -----------$this :${results}');
    var iotDeviceList = results
        .map((e) => IotDevice.from(null, e, null))
        .where((element) => element.isIotDevice())
        .where((element) => element.wifiSsid != null)
        .where((element) {
      var product2 = IotPairNetworkInfo().selectIotDevice?.product ??
          IotPairNetworkInfo().product;
      return product2?.model == element.wifiSsid ||
          product2?.quickConnects.values.contains(element.wifiSsid) == true;
    });
    final e = iotDeviceList.firstOrNull;
    if (e != null) {
      IotPairNetworkInfo().selectIotDevice?.bleDevice = e.bleDevice;
      postEvent(
          SmartStepEvent(StepName.STEP_CONNECT, status: SmartStepStatus.start));
      nextStep(SmartStepApConnect());
    }
  }

  @override
  Future<void> stepDestroy() async {
    stopScanWifi();
    await _apScanResultsSubscription?.cancel();
  }
}
