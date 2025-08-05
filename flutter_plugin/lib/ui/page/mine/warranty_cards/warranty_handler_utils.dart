import 'dart:convert';

import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/debug/warranty_debug_model.dart';

class WarrantyHandlerUtils {
  static String kWarrantyDebugModel = 'kWarrantyDebugModel';

  static Future<String> getWarrantyCardsServiceUrl() async {
    final envType = await InfoModule().envType();
    if (envType == EnvType.release) {
      return 'https://eu-store.dreame.tech/h5/warrantyCard';
    } else {
      return 'https://cn-uat-store.dreame.tech/h5/warrantyCard';
    }
  }

  static Future<String> getCountryCode() async {
    final debugCountryCodeString =
        await LocalStorage().getString(kWarrantyDebugModel);
    var countryCode = RegionStore().currentRegion.countryCode;
    if (debugCountryCodeString != null && debugCountryCodeString.isNotEmpty) {
      WarrantyDebugModel warrantyDebugModel =
          WarrantyDebugModel.fromJson(json.decode(debugCountryCodeString));
      if (warrantyDebugModel.countryCode.isNotEmpty) {
        countryCode = warrantyDebugModel.countryCode;
      }
    }
    return countryCode;
  }

  static Future<bool> useCNShopifyIfNeeded() async {
    final debugWarrantyString =
        await LocalStorage().getString(kWarrantyDebugModel);
    if (debugWarrantyString != null && debugWarrantyString.isNotEmpty) {
      WarrantyDebugModel warrantyDebugModel =
          WarrantyDebugModel.fromJson(json.decode(debugWarrantyString));
      final useCNShopifyLink = warrantyDebugModel.useCNShopifyLink == true;
      return useCNShopifyLink;
    } else {
      return false;
    }
  }

  static Future<bool> isOnlineServiceSupported() async {
    final countryCode = await getCountryCode();
    final supportedCountryList =
        ['DE', 'FR', 'IT', 'ES'].map((code) => code.toUpperCase()).toList();
    return supportedCountryList
        .contains(countryCode.toUpperCase()); // 检查国家代码是否在列表中
  }

  static Future<bool> isOverseaSupported() async {
    final debugCountryCodeString =
        await LocalStorage().getString(kWarrantyDebugModel);
    if (debugCountryCodeString != null && debugCountryCodeString.isNotEmpty) {
      WarrantyDebugModel warrantyDebugModel =
          WarrantyDebugModel.fromJson(json.decode(debugCountryCodeString));
      return warrantyDebugModel.showOverseaMall;
    }
    return false;
  }
}
