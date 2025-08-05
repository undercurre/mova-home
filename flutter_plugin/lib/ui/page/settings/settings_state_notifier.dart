import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/ui/page/settings/settings_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';

part 'settings_state_notifier.g.dart';

@riverpod
class SettingsPageNotifier extends _$SettingsPageNotifier {
  @override
  SettingsPageUiState build() {
    return SettingsPageUiState();
  }

  Future<void> initData() async {
    await showDevOption();
  }

  Future<void> checkAppVersion() async {
    try {
      AppVersionModel appVersion =
          await ref.watch(settingsRepositoryProvider).checkAppVersion();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (Platform.isIOS) {
        String localVersionStr = packageInfo.version;
        localVersionStr = packageInfo.version.replaceAll('.', '');
        int localVersion = int.tryParse(localVersionStr) ?? 0;
        bool hasNewVersion = (appVersion.version ?? 0) > localVersion;
        int localBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
        int remoteVersion =
            int.tryParse(appVersion.versionName?.replaceAll('.', '') ?? '') ??
                0;
        hasNewVersion = remoteVersion > localVersion ||
            (remoteVersion == localVersion &&
                localBuildNumber < (appVersion.version ?? 0));
        state = state.copyWith(hasNewAppVersion: hasNewVersion);
      } else {
      int localVersion = int.tryParse(packageInfo.buildNumber) ?? 0;
      bool hasNewVersion = (appVersion.version ?? 0) > localVersion;
      state = state.copyWith(hasNewAppVersion: hasNewVersion);
      }
    
    } catch (error) {
      LogUtils.d(error);
    }
  }

  /// 是否显示白名单
  Future<void> showDevOption() async {
    final userInfo = await AccountModule().getUserInfo();
    state = state.copyWith(devOption: userInfo?.devOption == true);
  }
}
