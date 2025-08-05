import 'dart:async';
import 'dart:io';

import 'package:flutter_plugin/utils/logutils.dart';
import 'package:wifi_scan/wifi_scan.dart';

/// Wi-Fi扫描类
mixin IotWiFiScannerMixin {
  /// wifi循环扫描
  Timer? _wifiScanTimer;

  ///此配置扫描开始时间点 5 15 25 35 45 55，解释：延迟5s开始扫描，扫10s, 间隔10s,再次开启扫描
  static const SCAN_PERIOD_COUNT = 6;
  static const SCAN_PERIOD_DELAY = 10;
  static const SCAN_FIRST_DELAY = 5;

  /// Wi-Fi扫描
  bool _isWifiScanning = false;

  /// wifi循环扫描
  void startScanWifi({bool needStopCurrent = false}) {
    LogUtils.i(
        ' sunzhibin IotWiFiScannerMixin startScanWifi needStopCurrent: $needStopCurrent, $this');
    if (needStopCurrent) {
      stopScanWifi();
    } else if (_wifiScanTimer?.isActive == true) {
      // 如果正在扫描中，则不开启
      return;
    }
    _startScanWifi();
  }

  void _startScanWifi() {
    LogUtils.i(' sunzhibin IotWiFiScannerMixin _startScanWifi $this');
    _isWifiScanning = true;
    var _count = SCAN_PERIOD_COUNT;
    onWifiStartCallback();

    /// 1min内扫6次，第一次延迟10s
    _wifiScanTimer =
        Timer.periodic(const Duration(seconds: SCAN_FIRST_DELAY), (timer) {
      /// 扫描Wi-Fi
      if (timer.isActive) {
        final tick = timer.tick;
        if (_count <= 0) {
          LogUtils.i(
              ' sunzhibin IotWiFiScannerMixin _wifiScanTimer tick is finish $this');
          onWifiStopCallback();
          stopScanWifi();
        } else if (tick == 1 ||
            tick % (SCAN_PERIOD_DELAY / SCAN_FIRST_DELAY) == 0) {
          _count--;
          LogUtils.i(
              ' sunzhibin IotWiFiScannerMixin _wifiScanTimer tick:$tick $this');
          _realStartScanWifi();
        }
      }
    });
  }

  void stopScanWifi() {
    if (_wifiScanTimer?.isActive == true) {
      LogUtils.i(' sunzhibin IotWiFiScannerMixin stopScanWifi $this');
      _wifiScanTimer?.cancel();
      _wifiScanTimer = null;
    }
    _isWifiScanning = false;
  }

  bool isWifiScanning() {
    return _isWifiScanning;
  }

  void onWifiStartCallback() {}

  void onWifiStopCallback() {}

  void onWifiGetScannedResults(List<WiFiAccessPoint> results) {}

  Future<void> _realStartScanWifi() async {
    LogUtils.i(' sunzhibin IotWiFiScannerMixin _realStartScanWifi $this');
    if (Platform.isAndroid) {
      var canStartScan =
          await WiFiScan.instance.canStartScan(askPermissions: false);
      if (canStartScan == CanStartScan.yes) {
        /// 循环扫描
        LogUtils.i(
            ' sunzhibin IotWiFiScannerMixin WiFiScan.instance.startScan $this');
        final startScan = await WiFiScan.instance.startScan();

        final canGetScannedResults =
            await WiFiScan.instance.canGetScannedResults(askPermissions: false);
        if (canGetScannedResults == CanGetScannedResults.yes) {
          final results = await WiFiScan.instance.getScannedResults();
          onWifiGetScannedResults(results);
        }
        if (!startScan) {
          LogUtils.e(' sunzhibin IotWiFiScannerMixin wifi scan failed $this');
        }
      }
    }
  }
}
