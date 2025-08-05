import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/bt/bt_protocol_attributes.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// 蓝牙扫描类
mixin IotBleScannerMixin {
  bool _isBleScanning = false;
  Timer? _btScanTimer;

  /// 此配置扫描开始时间点 5-15 25-35 45-55，解释：延迟5s开始扫描，扫10s, 间隔10s,再次开启扫描
  static const SCAN_PERIOD_COUNT = 4;
  static const SCAN_PERIOD_DELAY = 10;
  static const SCAN_FIRST_DELAY = 5;

  /// 扫描一次时常
  static const SCAN_ONCE_TIME = 10;

  /// wifi循环扫描
  Future<void> startScanBt({bool needStopCurrent = false}) async {
    LogUtils.i(' sunzhibin IotBleScannerMixin startScanBt $this');
    if (needStopCurrent) {
      LogUtils.i(
          ' sunzhibin IotBleScannerMixin stopScanBt needStopCurrent == true $this');
      await stopScanBt();
    } else if (_btScanTimer?.isActive == true) {
      // 如果正在扫描中，则不开启
      return;
    }
    _startScanBt();
  }

  Future<void> stopScanBt() async {
    if (_btScanTimer?.isActive == true) {
      LogUtils.i(' sunzhibin IotBleScannerMixin stopScanWifi $this');
      _btScanTimer?.cancel();
      _btScanTimer = null;
    }
    _isBleScanning = false;
    if (FlutterBluePlus.isScanningNow) {
      await _realBleStopScan();
    }
  }

  bool isBtScanning() {
    return _isBleScanning;
  }

  void onBtStartCallback() {}

  void onBtStopCallback() {}

  void _startScanBt() {
    LogUtils.i(' sunzhibin _startScanBt $this');
    _isBleScanning = true;
    var _count = SCAN_PERIOD_COUNT;
    onBtStartCallback();

    var lastTick = 0;

    /// 1min内扫6次，第一次延迟10s
    _btScanTimer = Timer.periodic(const Duration(seconds: SCAN_FIRST_DELAY),
        (timer) async {
      /// 扫描Wi-Fi
      if (timer.isActive) {
        final tick = timer.tick;
        if (_count <= 0) {
          LogUtils.i(' sunzhibin stopScanBt _btStartScan tick is finish $this');
          _isBleScanning = false;
          onBtStopCallback();
          await stopScanBt();
        } else if (tick == 1) {
          // 第一次，可以不判断间隔直接进行扫描
          lastTick = tick;
          _count--;
          LogUtils.i(' sunzhibin stopScanBt _btStartScan tick:$tick $this');
          await _realStartScanBt();
        } else if ((tick - lastTick) * SCAN_FIRST_DELAY - SCAN_ONCE_TIME >
            SCAN_PERIOD_DELAY) {
          // 没次，判断上次结束的时间点 间隔周期，再次开始
          lastTick = tick;
          _count--;
          LogUtils.i(' sunzhibin stopScanBt _btStartScan tick:$tick $this');
          await _realStartScanBt();
        } else {
          // do nothing
        }
      }
    });
  }

  Future<void> _realStartScanBt() async {
    LogUtils.i(' sunzhibin IotBleScannerMixin _realStartScanBt $this');
    BluetoothAdapterState isBleOn = await FlutterBluePlus.adapterState.first;
    if (isBleOn == BluetoothAdapterState.on) {
      try {
        LogUtils.i(
            ' sunzhibin IotBleScannerMixin FlutterBluePlus.startScan $this');
        await FlutterBluePlus.startScan(
            withServices: [BtProtocolAttributes.bleServiceUuid],
            timeout: const Duration(seconds: SCAN_ONCE_TIME),
            androidLegacy: true,
            androidUsesFineLocation: false);
      } catch (e) {
        LogUtils.i(
            ' sunzhibin IotBleScannerMixin bt startScan Error:  $this  $e');
      }
    }
  }

  Future<void> _realBleStopScan() async {
    LogUtils.i(' sunzhibin IotBleScannerMixin _realbleStopScan $this');
    BluetoothAdapterState isBleOn = await FlutterBluePlus.adapterState.first;
    if (isBleOn == BluetoothAdapterState.on) {
      try {
        if (FlutterBluePlus.isScanningNow) {
          LogUtils.i(
              ' sunzhibin IotBleScannerMixin FlutterBluePlus.stopScan $this');
          await FlutterBluePlus.stopScan();
        }
      } catch (e) {
        LogUtils.e('stopScan bt Error: $this $e');
      }
    }
  }
}
