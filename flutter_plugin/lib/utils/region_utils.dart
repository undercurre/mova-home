import 'package:flutter_plugin/common/bridge/local_module.dart';

class RegionUtils {
  static bool isCn(String code) {
    return code == 'CN' || code == 'cn' || code == '86';
  }

  static Future<bool> isRegionCn() async {
    var region = await LocalModule().getCountryCode();
    return region.toLowerCase() == 'cn';
  }
}
