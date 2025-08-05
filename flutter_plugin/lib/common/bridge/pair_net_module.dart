import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_plugin/ui/page/pair_network/generate_session_id.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';

class PairNetModule {
  PairNetModule._internal();

  factory PairNetModule() => _instance;
  static final PairNetModule _instance = PairNetModule._internal();
  final _plugin = const MethodChannel('com.dreame.flutter/module_pair_net');

  Future<void> startPairing(IotPairNetworkInfo info) {
    var iotDeviceWrapper = {
      'product': info.product,
      'deviceSsid': info.deviceSsid,
      'entrance': info.pairEntrance.code,
      'selectIotDevice': info.selectIotDevice,
      'sessionId': GenerateSessionID().currentSessionID()
    };
    return _plugin
        .invokeMethod('startPairing', {'info': jsonEncode(iotDeviceWrapper)});
  }

  /// 读取配网wifi信息
  Future<Map<String, dynamic>> readPairNetWifiInfo() async {
    try {
      final mapStr = await _plugin.invokeMethod('readPairNetWifiInfo');
      return json.decode(mapStr);
    } catch (e) {
      return <String, String>{};
    }
  }

  /// 获取蓝牙状态
  Future<bool> readBluetoothHalfState() async {
    if (Platform.isAndroid) {
      try {
        final isHalfOpen = await _plugin.invokeMethod('readBluetoothHalfState');
        return isHalfOpen;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  /// 在子引擎中配网成功，通过原生绕道刷新产品列表
  Future<void> pairNetSuccessGotoMainEngine() async {
    if (Platform.isAndroid) {
      try {
        await _plugin.invokeMethod('pairNetSuccessGotoMainEngine');
      } catch (e) {
        LogUtils.e('pairNetSuccessSubEngine error: $e');
      }
    }
  }

  /// TODO: next version feature
  Future<bool> isMainFlutterEngine() async {
    if (Platform.isAndroid) {
      try {
        return await _plugin.invokeMethod('isMainFlutterEngine');
      } catch (e) {
        LogUtils.e('pairNetSuccessSubEngine error: $e');
      }
    }
    return true;
  }
}
