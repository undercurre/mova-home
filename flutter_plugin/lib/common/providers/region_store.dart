import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/region_item.dart';

class RegionStore {
  RegionStore._internal();
  factory RegionStore() => _instance;
  static final RegionStore _instance = RegionStore._internal();

  late RegionItem currentRegion;

  Future<void> register() async {
    currentRegion = await LocalModule().getCurrentCountry();
  }

  Future<void> updateRegion(RegionItem region) async {
    await LocalModule().setCurrentCountry(region);
    currentRegion = region;
  }

  /// 是否是中国服务器
  bool isChinaServer() {
    return currentRegion.isChinaServer;
  }

  /// 获取当前国家代码
  String getCountryCode() {
    return currentRegion.countryCode;
  }

}
