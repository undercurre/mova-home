import 'package:flutter/services.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// 部分方法调用
class FeatureModule {
  /// 账号
  FeatureModule._internal();
  factory FeatureModule() => _instance;
  static final FeatureModule _instance = FeatureModule._internal();

  final _plugin = const MethodChannel('com.dreame.flutter/module_feature');

  /// 同意隐私后，初始化 some sdk
  Future<bool?> initSomeSdkAfterAgreePrivacy() async {
    try {
      return await _plugin.invokeMethod('initSomeSdkAfterAgreePrivacy');
    } on MissingPluginException {
      LogUtils.e(
          'No implementation found for method $initSomeSdkAfterAgreePrivacy on channel ${_plugin.name}');
    } catch (e) {
      LogUtils.e(e);
    }

    return false;
  }

  Future<bool?> updateWorkStatusPath(String model, String filePath) {
    return _plugin.invokeMethod(
        'updateWorkStatusPath', {'model': model, 'filePath': filePath});
  }

  /// 初始化App进入首页后的一些配置信息
  Future<bool?> initHomeConfig() {
    try {
      return _plugin.invokeMethod('initHomeConfig');
    } catch (e) {
      LogUtils.e('module_feature initHomeConfig error: $e');
    }
    return Future.value(false);
  }

  Future<String?> getThemeMode() {
    try {
      return _plugin.invokeMethod('getThemeMode');
    } catch (e) {
      LogUtils.e('module_feature getThemeMode error: $e');
    }
    return Future.value(null);
  }
}
