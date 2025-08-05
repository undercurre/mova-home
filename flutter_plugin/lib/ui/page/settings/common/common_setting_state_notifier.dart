import 'dart:async';

import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_setting_ui_state.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'common_setting_state_notifier.g.dart';

@riverpod
class CommonSettingStateNotifier extends _$CommonSettingStateNotifier {
  @override
  CommonSettingPageUiState build() {
    return CommonSettingPageUiState();
  }

  Future<void> refreshCache() async {
    int size = await ref.read(pluginProvider.notifier).getCacheSize();
    int nativeSize = await AccountModule().getLocalCacheSize();
    final _cacheString = _getSizeString(nativeSize + size);
    state = state.copyWith(cacheSize: _cacheString);
  }

  void refreshData() {
    unawaited(refreshCache());
  }

  Future<void> getCurrentRegin() async {
    String displayLang = LanguageStore().getCurrentLanguage().displayLang;
    RegionItem regin = await LocalModule().getCurrentCountry();
    String langTag = await LocalModule().getLangTag();
    String reginDisplay = '';
    if (langTag == 'zh') {
      reginDisplay = regin.name;
    } else {
      reginDisplay = regin.en;
    }
    state =
        state.copyWith(displayLang: displayLang, reginDisplay: reginDisplay);
  }

  String _getSizeString(int size) {
    if (size <= 0) {
      return '0B';
    } else if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      double a = size / 1024.0;
      return '${a.toStringAsFixed(1)}KB';
    } else if (size < 1024 * 1024 * 1024) {
      double a = size / (1024 * 1024.0);
      return '${a.toStringAsFixed(1)}MB';
    } else {
      double a = size / (1024 * 1024 * 1024.0);
      return '${a.toStringAsFixed(1)}GB';
    }
  }
}
