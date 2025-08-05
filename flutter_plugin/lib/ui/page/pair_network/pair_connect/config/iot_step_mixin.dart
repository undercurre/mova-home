import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:wifi_iot/wifi_iot.dart';

mixin IotStepMixin {
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
    if (IotPairNetworkInfo().selectIotDevice != null) {
      final isDreameProduct = (wifiName.startsWith('dreame-') ||
              wifiName.startsWith('mova-') ||
              wifiName.startsWith('trouver-')) &&
          wifiName.contains('_miap');
      if (isDreameProduct) {
        return wifiName == IotPairNetworkInfo().selectIotDevice?.wifiSsid;
      }
    }
    return (wifiName.startsWith('dreame-') ||
            wifiName.startsWith('mova-') ||
            wifiName.startsWith('trouver-')) &&
        wifiName.contains('_miap');
  }

  Future<void> forceDisconnectDeviceAP() async {
    await forceDisConnectDeviceBt(null);
    await WiFiForIoTPlugin.forceWifiUsage(false);
    final wifiName = await WiFiForIoTPlugin.getSSID();
    if (isIotDeviceAp(wifiName)) {
      await WiFiForIoTPlugin.disconnect();
    }
  }

  Future<void> forceDisConnectDeviceBt(BluetoothDevice? bleDevice) async {
    final deviceBt =
        bleDevice ?? IotPairNetworkInfo().selectIotDevice?.bleDevice;
    LogUtils.i('-----BLE------ forceDisConnectDeviceBt: $deviceBt');
    if (deviceBt?.isConnected == true) {
      if (Platform.isAndroid) {
        try {
          LogUtils.i('-----BLE------ forceDisConnectDeviceBt clearGattCache : $deviceBt');
          await deviceBt?.clearGattCache();
        } catch (e) {
          LogUtils.e('-----BLE------ clearGattCache error: ----------- :$e');
        }
      }
    }
    try {
      if (deviceBt?.isConnected == true) {
        LogUtils.i('-----BLE------ forceDisConnectDeviceBt disconnect : $deviceBt');
        await deviceBt?.disconnect();
      }
    } catch (e) {
      LogUtils.e('-- BLE -- disconnect失败');
    }
  }
}
