import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/theme/index.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_theme_model.dart';
import 'app_theme_set_ui_state.dart';

part 'app_theme_set_state_notifier.g.dart';

@riverpod
class AppThemeSetStateNotifier extends _$AppThemeSetStateNotifier {
  @override
  AppThemeSetUiState build() {
    return AppThemeSetUiState();
  }

  Future<void> initData() async {
    ThemeMode themeMode = await ref.read(appThemeStateNotifierProvider.notifier).readSettingThemeMode();
    await updateThemeData(themeMode);
  }

  // 切换主题
  Future<void> updateThemeSelected(int index) async {
    try {
      final themeMode = parseThemeMode(index);
      await ref
          .read(appThemeStateNotifierProvider.notifier)
          .onAppThemeChange(themeMode);
      await updateThemeData(themeMode);
    } catch (e) {
      LogUtils.e('updateThemeSelected error: $e');
    }
  }

  ThemeMode parseThemeMode(int index) {
    ThemeMode themeMode;
    int int1 = 1;
    switch (index) {
      case 0:
        themeMode = ThemeMode.light;
        int1 = 1;
        break;
      case 1:
        themeMode = ThemeMode.dark;
        int1 = 2;
        break;
      case 2:
        themeMode = ThemeMode.system;
        int1 = 3;
        break;
      default:
        int1 = 1;
        themeMode = ThemeMode.light;
    }
    LogModule().eventReport(7, 49, int1: int1);
    return themeMode;
  }

  Future<void> updateThemeData(ThemeMode themeMode) async {
    List<AppThemeModel> data = [
      AppThemeModel(
        title: 'app_theme_normal'.tr(),
        selected: themeMode == ThemeMode.light,
        normalIcon: 'theme_mode_item_normal',
        selectedIcon: 'theme_mode_item_selected',
      ),
      AppThemeModel(
        title: 'app_theme_dark'.tr(),
        selected: themeMode == ThemeMode.dark,
        normalIcon: 'theme_mode_item_normal',
        selectedIcon: 'theme_mode_item_selected',
      ),
      AppThemeModel(
        title: 'app_theme_system'.tr(),
        selected: themeMode == ThemeMode.system,
        normalIcon: 'theme_mode_item_normal',
        selectedIcon: 'theme_mode_item_selected',
      ),
    ];
    // 更新状态
    state = state.copyWith(dataList: data);
  }
}
