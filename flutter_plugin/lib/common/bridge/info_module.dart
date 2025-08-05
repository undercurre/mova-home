import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class InfoModule {
  InfoModule._internal();
  factory InfoModule() => _instance;
  static final InfoModule _instance = InfoModule._internal();

  final _infoPlugin = const MethodChannel('com.dreame.flutter/info');

  Future<Map<String, dynamic>> getHeaders() async {
    final map = await _infoPlugin.invokeMethod('getHeaders');
    final headers = Map<String, dynamic>.from(map);
    return Future.value(headers);
  }

  Future<String> signParams(String bodyStr, bool needSign) async {
    return await _infoPlugin
        .invokeMethod('signParams', {'bodyStr': bodyStr, 'contains': needSign});
  }

  Future<String> signPassword(String content) async {
    return await _infoPlugin.invokeMethod('signPassword', {'content': content});
  }

  /// 获取App打包版本
  Future<EnvType> envType() async {
    final type = await _infoPlugin.invokeMethod('envType');
    if (type == 'debug') {
      return EnvType.debug;
    } else if (type == 'uat') {
      return EnvType.uat;
    } else if (type == 'release') {
      return EnvType.release;
    }
    return EnvType.release;
  }

  /// 获取当前网络请求的Host,ep: https://cn.iot.dreame.tech:13267
  Future<String> getUriHost() async {
    final host = await _infoPlugin.invokeMethod('getCurrentHost');
    return host;
  }
  
  /// 获取H5的Host
  Future<String> getWebUriHost() async {
    final host = await _infoPlugin.invokeMethod('getWebHost');
    return host;
  }


  //appName wechat
  Future<bool> isAppInstalled(String appName) async {
    Future<dynamic>? result;
    try {
      result = _infoPlugin.invokeMethod('isAppInstalled', appName);
    } catch (e) {
      return Future.value(false);
    }
    var installed = await result;
    if (installed is bool) {
      return installed;
    }
    return false;
  }

  /// android only isGpVersion
  Future<bool> isGpVersion() async {
    if (Platform.isAndroid) {
      return await _infoPlugin.invokeMethod('isGpVersion');
    }
    return false;
  }

  /// 安装apk
  Future<bool> installApk(String apkPath) async {
    if (Platform.isAndroid) {
      return await _infoPlugin.invokeMethod('installApk', {'apkPath': apkPath});
    }
    return false;
  }

  Future<bool> isWifiConnected() async {
    return await _infoPlugin.invokeMethod('isWifiConnected');
  }

  /// root、越狱检测
  Future<bool> isRooted() async {
    return await _infoPlugin.invokeMethod('isRooted');
  }

  Future<bool> isNotchScreen() async {
    if (Platform.isIOS) {
      return await _infoPlugin.invokeMethod('isNotchScreen');
    }
    return false;
  }
}

enum EnvType { debug, uat, release }
