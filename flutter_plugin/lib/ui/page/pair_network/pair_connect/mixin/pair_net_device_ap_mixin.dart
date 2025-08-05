import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/extension/quoted_ssid_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// 校验当前连接的Wi-Fi 是机器的AP热点
mixin PairNetDeviceApMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>?
      _onConnectivityChangedSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeWifiOpenState();
  }

  Future<void> _subscribeWifiOpenState() async {
    _onConnectivityChangedSubscription =
        Connectivity().onConnectivityChanged.listen((event) async {
      LogUtils.i('onConnectivityChanged: $event');
      if (event.last == ConnectivityResult.wifi) {
        /// 获取连接的Wi-Fi名
        /// 获取当前Wi-Fi
        onWifiConnect();
      }
    });
  }

  void onWifiConnect() {
    checkWifi(isCheckGatewayIp: false).then((value) async {
      if (value) {
        /// 发送通知

        final ssid = await NetworkInfo()
            .getWifiName()
            .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
        onDeviceApConnect(ssid);
      }
    });
  }

  void onDeviceApConnect(String ap) {}

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChangedSubscription?.cancel();
    _onConnectivityChangedSubscription = null;
  }

  /// 测试一下dhcpInfo: ipaddr 192.168.5.100 gateway 192.168.5.1 netmask 0.0.0.0 dns1 192.168.5.1 dns2 0.0.0.0
  /// DHCP server 192.168.5.1 lease 3600 seconds
  /// TODO:跳转设置 判断是否连上了机器Wi-Fi
  Future<bool> checkWifi({
    bool isCheckGatewayIp = true,
  }) async {
    final ssid = await NetworkInfo()
        .getWifiName()
        .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
    final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
    final wifiIp = await NetworkInfo().getWifiIP() ?? '';
    LogUtils.e('checkWifi ssid:$ssid, gatewayIp:$gatewayIp wifiIp:$wifiIp');
    final isAp = isIotDeviceAp(ssid, isManual: true);
    final isGatewayIp = gatewayIp == '192.168.5.1';
    LogUtils.i('checkWifi: isAp:$isAp isGatewayIp:$isGatewayIp');
    if (isAp/*&& isGatewayIp*/) {
      /// 发送检测Wi-Fi结果
      return true;
    } else if (isCheckGatewayIp) {
      return false;
    }
    return isAp;
  }

  /// wifiName是否是设备热点
//      * @param wifiName Wi-Fi名
//      * @param isManual 手动模式，不校验 model 、mac ,确定 dreame_ 开头就行
//      * @param isSkipCheck 跳过校验模式，不校验 model 、mac ,确定 dreame_ 开头就行
  bool isIotDeviceAp(String? wifiName,
      {bool isManual = false, bool isSkipCheck = false}) {
    if (wifiName == null || wifiName.isEmpty) {
      return false;
    }
    if (isManual || isSkipCheck) {
      return (wifiName.startsWith('dreame-') ||
              wifiName.startsWith('mova-') ||
              wifiName.startsWith('trouver-')) &&
          wifiName.contains('_miap');
    }
    return (wifiName.startsWith('dreame-') ||
            wifiName.startsWith('mova-') ||
            wifiName.startsWith('trouver-')) &&
        wifiName.contains('_miap');
  }
}
