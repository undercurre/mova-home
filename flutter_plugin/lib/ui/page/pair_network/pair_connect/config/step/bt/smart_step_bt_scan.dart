import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_ble_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_manual_connect.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'smart_step_bt_connect.dart';

class SmartStepBtScan extends SmartStepConfig with IotBleScannerMixin {
  final bool canWifi;

  SmartStepBtScan({this.canWifi = false}) : super();

  @override
  StepId get stepId => StepId.STEP_BLE_SCAN;

  /// 蓝牙扫描
  StreamSubscription<List<ScanResult>>? _bleScanResultsSubscription;
  int scanCount = 0;

  @override
  void handleMessage(msg) {}

  @override
  Future<void> stepCreate() async {
    _subscribeScanResult();
    scanCount = 1;
    postEvent(
        SmartStepEvent(StepName.STEP_CONNECT, status: SmartStepStatus.start));
    await startScanBt();
  }

  @override
  void onBtStopCallback() {
    if (scanCount <= 1 || !canWifi) {
      scanCount++;
      startScanBt();
    } else {
      if (canWifi) {
        nextStep(SmartStepApManualConnect());
      } else {
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.failed));
      }
    }
  }

  void _subscribeScanResult() {
    /// 监听蓝牙扫描结果
    _bleScanResultsSubscription =
        FlutterBluePlus.scanResults.listen((results) async {
      LogUtils.i(
          '-----BLE------ _subscribeScanResult scanResults.listen-----------$this :$results');
      var iotDeviceList = results
          .map((e) => IotDevice.from(e, null, null))
          .where((element) => element.isIotDevice())
          .where((element) => element.btScanPid != null)
          .where((element) {
        var product2 = IotPairNetworkInfo().selectIotDevice?.product ??
            IotPairNetworkInfo().product;
        return product2?.productId == element.btScanPid ||
            product2?.quickConnects.keys.contains(element.btScanPid) == true;
      });
      final e = iotDeviceList.firstOrNull;
      if (e != null) {
        IotPairNetworkInfo().selectIotDevice?.bleDevice = e.bleDevice;
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.start));
        nextStep(SmartStepBtConnect());
      }
    }, onError: (e) async {
      LogUtils.e('scanResults Error: $this ', e);
      if (canWifi) {
        nextStep(SmartStepApManualConnect());
      } else {
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.failed));
      }
    });
  }

  @override
  Future<void> stepDestroy() async {
    await _bleScanResultsSubscription?.cancel();
    _bleScanResultsSubscription = null;
    await stopScanBt();
  }
}
