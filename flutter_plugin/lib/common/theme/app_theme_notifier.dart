import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/feature_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme_notifier.g.dart';

@Riverpod(keepAlive: true)
class AppThemeStateNotifier extends _$AppThemeStateNotifier {
  ThemeMode? realThemeMode = ThemeMode.light;

  @override
  ThemeMode build() {
    loadTheme();
    return ThemeMode.light;
  }

  String currentSettingThemeName() {
    switch (realThemeMode) {
      case ThemeMode.light:
        return 'app_theme_normal'.tr(); // Light 模式
      case ThemeMode.dark:
        return 'app_theme_dark'.tr(); // Dark 模式
      case ThemeMode.system:
        return 'app_theme_system'.tr(); // System 模式
      default:
        return 'app_theme_normal'.tr(); // 默认值
    }
  }

  /// 获取保存的主题，如果是跟随系统，则 获取真实的主题
  Future<ThemeMode> loadTheme() async {
    try {
      ThemeMode settingThemeMode = await readSettingThemeMode();
      LogUtils.i('[theme_mode] loadTheme themeMode: ${settingThemeMode.name}');
      state = await _getEffectiveThemeMode(settingThemeMode);
      return state;
    } catch (e) {
      // 处理读取主题设置时的错误
      LogUtils.e('[theme_mode] _loadTheme Error loading theme: $e');
      state = ThemeMode.light;
      return state;
    }
  }

  /// 读取设置的主题，将真实的主题设置给riverpod
  Future<ThemeMode> readSettingThemeMode() async {
    final themeName = await LocalStorage()
        .getString('app_theme_mode', fileName: 'app_theme_config');
    LogUtils.i('[theme_mode] readSettingThemeMode theme: $themeName');
    ThemeMode settingThemeMode = parseThemeMode(themeName);
    realThemeMode = settingThemeMode;
    state = await _getEffectiveThemeMode(settingThemeMode);
    return settingThemeMode;
  }

  static ThemeMode parseThemeMode(String? themeName) {
    switch (themeName) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light; // 默认值
    }
  }

  bool isDarkTheme() {
    return state == ThemeMode.dark;
  }

  // 获取有效的主题模式
  Future<ThemeMode> _getEffectiveThemeMode(ThemeMode themeMode) async {
    LogUtils.i(
        '[theme_mode] _getEffectiveThemeMode themeMode: ${themeMode.name}');
    if (themeMode == ThemeMode.system) {
      // iOS 13 以上版本支持系统深色模式
      // 通过 PlatformDispatcher 获取系统亮度在iOS系统上获取不准
      String? themeName = await FeatureModule().getThemeMode();
      return themeName == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
    return themeMode;
  }

  /// 原生系统回调的真实的主题
  /// 只会有 light dark
  Future<void> changeAppTheme(String realThemeMode) async {
    try {
      ThemeMode themeMode = await readSettingThemeMode();
      if (themeMode == ThemeMode.system) {
        ThemeMode realTheme = parseThemeMode(realThemeMode);
        state = realTheme;
      }
    } catch (e) {}
  }

  /// 在主题设置页，切换的选中的主题
  /// 会有 light dark system
  Future<void> onAppThemeChange(ThemeMode themeMode) async {
    try {
      // 本地存储
      await LocalStorage().putString('app_theme_mode', themeMode.name,
          fileName: 'app_theme_config');
      // 传递给原生
      await LocalModule().setCurrentTheme(themeMode.name);
      // 更新状态
      realThemeMode = themeMode;
      state = await _getEffectiveThemeMode(themeMode);
      LogUtils.i(
          '[theme_mode] onAppThemeChange themeMode: ${themeMode.name} end');
    } catch (e) {
      // 处理存储主题设置时的错误
      LogUtils.e('[theme_mode] onAppThemeChange Error saving theme: $e');
    }
  }
}
