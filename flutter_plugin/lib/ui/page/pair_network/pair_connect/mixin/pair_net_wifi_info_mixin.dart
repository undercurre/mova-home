import 'dart:convert';

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';

mixin PairNetWifiInfoMixin {
  static const _SP_WIFI_LIST = 'sp_wifi_list';
  static const _FILE_NAME = 'android.dreame.module_preferences';

  Future<void> saveWifiInfo() async {
    try {
      final wifiListStr =
          await LocalStorage().getString(_SP_WIFI_LIST, fileName: _FILE_NAME) ??
              '{}';
      final map = jsonDecode(wifiListStr);
      final wifiCacheMap = Map<String, dynamic>.from(map);

      final wifiName = IotPairNetworkInfo().routerWifiName ?? '';
      final wifiPassword = IotPairNetworkInfo().routerWifiPwd ?? '';

      if (wifiName.isNotEmpty) {
        wifiCacheMap[wifiName] = wifiPassword;
      }
      if (wifiCacheMap.length > 10) {
        final next = wifiCacheMap.keys.iterator.current;
        wifiCacheMap.remove(next);
      }
      final newWifiListStr = jsonEncode(wifiCacheMap);
      final save = await LocalStorage()
          .putString(_SP_WIFI_LIST, newWifiListStr, fileName: _FILE_NAME);
    } catch (e) {
      print('saveWifiInfo error: $e');
    }
  }

  Future<Map<String, dynamic>> loadWifiListFrmSp() async {
    final spWifiNMapJson =
        await LocalStorage().getString(_SP_WIFI_LIST, fileName: _FILE_NAME) ??
            '{}';
    if (spWifiNMapJson.isEmpty) {
      return {};
    }
    final wifiMap = json.decode(spWifiNMapJson);
    return wifiMap;
  }
}
