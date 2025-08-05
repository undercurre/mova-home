import 'package:easy_localization/easy_localization.dart';

class HoldCommonFeatureData {
  /// 根据设备特性获取按钮文本列表
  /// [feature] 设备特性字符串
  static List<String> getBtnListStrByFeature(String? feature) {
    Map<String, List<String>> mapFeature = {
      'hold_selfClean_dry' : ['wash_text_self_cleaning_start', 'wash_text_drying'],
      'hold_selfClean_selfCleanDeep' : ['wash_text_self_cleaning_start', 'wash_text_hot_deep_cleaning']
    };

    if (feature != null && feature.isNotEmpty && mapFeature.containsKey(feature)) {
      return [mapFeature[feature]![0].tr(), mapFeature[feature]![1].tr()];
    }
    return ['wash_text_hot_deep_cleaning'.tr(), 'wash_text_smart_cleaning'.tr()];
  }

  /// 根据设备特性获取提示信息字符串
  /// [feature] 设备特性字符串
  static String getToastStrByFeature(String? feature, String position) {
    Map<String, List<String>> mapFeature = {
      'hold_selfClean_dry' : ['home_tip_hold_slef_clean_fail', 'home_tip_hold_dry_fail'],
      'hold_selfClean_selfCleanDeep' : ['home_tip_hold_slef_clean_fail', 'home_tip_hold_slef_clean_fail']
    };
    if (feature == null || feature.isEmpty || !mapFeature.containsKey(feature)) {
      return 'home_tip_hold_slef_clean_fail'.tr();
    }
    if (position == 'left') {
      return mapFeature[feature]![0].tr();
    } else if (position == 'right') {
      return mapFeature[feature]![1].tr();
    }
    return 'home_tip_hold_slef_clean_fail'.tr();
  }
}