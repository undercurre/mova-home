import 'dart:convert';
import 'dart:io';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/ui/common/js_action/js_map_navigation.dart';
import 'package:flutter_plugin/ui/page/home/plugin/rn_plugin_update_model.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/map_naviagte_minxin.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:url_launcher/url_launcher.dart';

/// 页面跳转、UI展示
class UIModule {
  UIModule._internal();
  factory UIModule() => _instance;
  static final UIModule _instance = UIModule._internal();
  final _plugin = const MethodChannel('com.dreame.flutter/module_ui');

  /// 打开指定App页面
  Future<void> openPage(String routhPath) {
    return _plugin.invokeMethod('openPage', {'path': routhPath});
  }

  Future<Map<String, dynamic>?> pushQRScanInfo() async {
    var result = await _plugin.invokeMethod('pushToQRScanInfo');
    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>?> pushToQRScanRN() async {
    var result = await _plugin.invokeMethod('pushToQRScanRN');
    return Map<String, dynamic>.from(result);
  }

  // 打开微信分享
  Future<void> shareContent(String shareContent) {
    return _plugin.invokeMethod('openShare', shareContent);
  }

  // 打开第三方分享
  Future<void> thirdShareContent(Map<String, dynamic> shareContent) {
    return _plugin.invokeMethod('openThirdShard', shareContent);
  }

  //打开地图导航
  Future<void> mapNavigation(NavigateMapType type, JSMapNavigation nav) {
    String typeString = '';

    switch (type) {
      case NavigateMapType.amap:
        typeString = 'amap';
      case NavigateMapType.baidu:
        typeString = 'baidu';
      default:
        typeString = 'apple';
    }
    Map<String, dynamic> data = {
      'type': typeString,
      'nav': nav.toJson(),
    };
    return _plugin.invokeMapMethod('goToNavigate', data);
  }

  //获取定位
  Future<Map<String, dynamic>> getLocation() async {
    var result = await _plugin.invokeMethod('getLocation');
    return Map<String, dynamic>.from(result);
  }

  /// 打开插件
  Future<bool?> openPlugin(String entranceType, BaseDeviceModel device,
      RNPluginUpdateModel pluginInfo,
      {bool isVideo = false,
        bool showWarn = false,
        String warnCode = '',
        String source = '',
        String extraData = ''}) async {
    return _plugin.invokeMethod('openPlugin', {
      'entranceType': entranceType,
      'isVideo': isVideo,
      'showWarn': showWarn,
      'warnCode': warnCode,
      'source': source,
      'extraData': extraData,
      'device': json.encode(device),
      'pluginInfo': {
        'isDebug': pluginInfo.isDebug,
        'ip': pluginInfo.ip ?? '',
        'debugUrl': pluginInfo.debugUrl ?? '',
        'sdkPath': await pluginInfo.sdkModel?.getPath() ?? '',
        'sdkVersion': pluginInfo.sdkModel?.version ?? '0',
        'realSdkVersion': Constant.appVersion,
        'sdkMd5': pluginInfo.sdkModel?.md5 ?? '',
        'pluginPath': await pluginInfo.pluginModel?.getPath() ?? '',
        'pluginVersion': pluginInfo.pluginModel?.version ?? '0',
        'pluginMd5': pluginInfo.pluginModel?.md5 ?? '',
        'pluginResPath': await pluginInfo.resModel?.getPath() ?? '',
        'pluginResVersion': pluginInfo.resModel?.version ?? '0',
        'commonPluginVer': pluginInfo.resModel?.sourceCommonPluginVer ?? '0'
      },
    });
  }

  Future<bool> clearCache() async {
    var result = await _plugin.invokeMethod('clearCache');
    return result;
  }

  /// 当前是否是在flutter页面
  Future<bool> inFlutterPage() async {
    return await _plugin.invokeMethod('inFlutterPage');
  }

  Future<void> openAppStore() {
    if (Platform.isIOS) {
      return launchUrl(
          Uri.parse('itms-apps://itunes.apple.com/app/id6499421624'));
    }
    return _plugin.invokeMethod('openAppStore');
  }

  /// 打开小程序
  Future<int> openMiniProgram(String appletId, {String path = ''}) async {
    if (path.isEmpty || appletId.isEmpty) {
      return 102;
    }
    if (path.startsWith('/') == false) {
      path = '/$path';
    }
    return await _plugin
        .invokeMethod('openMiniProgram', {'appletId': appletId, 'path': path});
  }

  /// 打开智齿客服
  Future<void> openZhiChiCustomerService() {
    return _plugin.invokeMethod('openZhiChiCustomerService');
  }

  /// 打开zendesk客服
  Future<void> openZendeskCustomerService(Map<String, dynamic> params) {
    return _plugin.invokeMethod('openZendeskCustomerService', params);
  }

  Future<void> switchAppEnv() {
    return _plugin.invokeMethod('switchAppEnv');
  }

  //退出当前引擎
  Future<void> exitEnginer() {
    return _plugin.invokeMethod('exitEnginer');
  }

  /// Android 应该内评价
  Future<bool?> inAppRating() {
    if (Platform.isAndroid) {
      return _plugin.invokeMethod('inAppRating');
    }
    return Future.value(false);
  }

  /// Adnroid 打开Ai音响App
  Future<void> openAiSoundApp(Map<String, dynamic> data) {
    if (Platform.isAndroid) {
      return _plugin.invokeMethod('openAiSoundApp', data);
    }
    return Future.value();
  }

  /// Adnroid 打开Ai音响App
  Future<void> openAppByUrl(String url) {
    return _plugin.invokeMethod('openAppByUrl', url);
  }

  Future<void> lockOrientation(bool isLock) {
    if (Platform.isIOS) {
      return _plugin.invokeMethod('lockOrientation', isLock);
    }
    return Future.value();
  }

  Future<void> pushToArManual(String model) {
    if (Platform.isIOS) {
      return _plugin.invokeMethod('pushToArManual', model);
    }
    return Future.value();
  }

  Future<void> alifyTest() {
    if (Platform.isAndroid) {
      return _plugin.invokeMethod('alifyTest');
    }
    return Future.value();
  }

  Future<void> generatePairNetEngine(String routePath) {
    return _plugin.invokeMethod('generatePairNetEngine', routePath);
  }

  Future<void> exitPairNetEngine({bool isPairDone = false}) {
    return _plugin.invokeMethod('exitPairNetEngine', isPairDone);
  }
}
