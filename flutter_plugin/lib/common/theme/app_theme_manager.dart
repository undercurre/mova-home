import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';

class AppThemeManager {
  AppThemeManager._internal();

  factory AppThemeManager() => _instance;
  static final AppThemeManager _instance = AppThemeManager._internal();

  /// 修改App 主题
  void updateAppThemeMode(ThemeMode? themeMode,
      {Color? systemNavigationBarColor}) {
    try {
      LogUtils.d(
          'sunzhibin updateAppSystemUiOverlayStyle themeMode:$themeMode');
      var isDarkTheme = themeMode == ThemeMode.dark;
      if (Platform.isAndroid) {
        // Android多了 导航栏的处理
        var systemNavigationBarColor2 = systemNavigationBarColor ??
            (isDarkTheme ? const Color(0xFF262626) : const Color(0xFFF4F4F4));
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness:
                isDarkTheme ? Brightness.light : Brightness.dark,
            statusBarIconBrightness:
                isDarkTheme ? Brightness.light : Brightness.dark,
            systemNavigationBarIconBrightness:
                isDarkTheme ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: systemNavigationBarColor2);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      } else {
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness:
                isDarkTheme ? Brightness.light : Brightness.dark,
            statusBarIconBrightness:
                isDarkTheme ? Brightness.light : Brightness.dark);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    } catch (e) {
      LogUtils.e('[AppThemeManager] updateAppThemeMode error:$e');
    }
  }
}
