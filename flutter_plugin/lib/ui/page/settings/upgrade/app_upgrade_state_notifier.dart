import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_upgrade_state_notifier.g.dart';

@riverpod
class AppUpgradeStateNotifier extends _$AppUpgradeStateNotifier {
  CancelToken? _cancelToken;

  @override
  AppUpgradeState build() {
    return AppUpgradeState();
  }

  Future<void> checkNewVersion() async {
    try {
      AppVersionModel remoteAppVersion =
          await ref.watch(settingsRepositoryProvider).checkAppVersion();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      bool hasNewVersion = false;
      if (Platform.isIOS) {
        int localVersion =
            int.tryParse(packageInfo.version.replaceAll('.', '')) ?? 0;
        int localBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
        int remoteVersion =
            int.tryParse(
                remoteAppVersion.versionName?.replaceAll('.', '') ?? '') ??
                0;
        hasNewVersion = (remoteVersion > localVersion) ||
            (remoteVersion == localVersion &&
                localBuildNumber < (remoteAppVersion.version ?? 0));
       
      } else {
        int localVersion = int.tryParse(packageInfo.buildNumber) ?? 0;
        hasNewVersion = (remoteAppVersion.version ?? 0) > localVersion;
      }
      if (hasNewVersion) {
        final now = DateTime.now();
        String lastTime =
            await ref.watch(settingsRepositoryProvider).lastShowTime();

        state = state.copyWith(
            hasNewVersion: hasNewVersion,
            versionName: remoteAppVersion.versionName ?? '',
            versionDesc: remoteAppVersion.localizationDisplayNames?[
                    await LocalModule().getLangTag()] ??
                remoteAppVersion.localizationDisplayNames?['zh'] ??
                '',
            downloadUrl: remoteAppVersion.downloadUrl ?? '',
            isForce: remoteAppVersion.isForce == 1,
            downFirst: remoteAppVersion.downFirst ?? false);
        if ((remoteAppVersion.isForce == 1) ||
            (remoteAppVersion.isForce == 0 &&
                (lastTime != '${now.month}-${now.day}'))) {
         
          ref
              .read(dialogJobManagerProvider.notifier)
              .sendJobMessage(DialogJob(DialogType.upgrade));
        }
      }
    } catch (error) {
      LogUtils.e('checkAppVersion error: $error');
    }
  }

  Future<AppUpgradeState> checkUpdate() async {
    try {
      AppVersionModel appVersion =
          await ref.watch(settingsRepositoryProvider).checkAppVersion();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      bool hasNewVersion = false;
      int tmpVersion =
          int.tryParse(packageInfo.version.replaceAll('.', '')) ?? 0;
      if (Platform.isIOS && tmpVersion > 213) {
        int version =
            int.tryParse(packageInfo.version.replaceAll('.', '')) ?? 0;
        int buildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
        int remoteVersion =
            int.tryParse(appVersion.versionName?.replaceAll('.', '') ?? '') ??
                0;
        hasNewVersion = remoteVersion > version ||
            (remoteVersion == version &&
                buildNumber < (appVersion.version ?? 0));
      } else {
        int localVersion = int.tryParse(packageInfo.buildNumber) ?? 0;
        hasNewVersion = (appVersion.version ?? 0) > localVersion;
      }
      if (hasNewVersion) {
        state = state.copyWith(
            hasNewVersion: hasNewVersion,
            versionName: appVersion.versionName ?? '',
            versionDesc: appVersion.localizationDisplayNames?[
                    await LocalModule().getLangTag()] ??
                appVersion.localizationDisplayNames?['zh'] ??
                '',
            downloadUrl: appVersion.downloadUrl ?? '',
            isForce: appVersion.isForce == 1,
            downFirst: appVersion.downFirst ?? false);
      }
      return state;
    } catch (e) {
      LogUtils.e('checkAppVersion error: $e');
    }
    return AppUpgradeState();
  }

  Future<void> download() async {
    if (Platform.isAndroid) {
      var isGpVersion = await InfoModule().isGpVersion();
      if (state.downloadUrl.isNotEmpty && !isGpVersion && state.downFirst) {
        final connectWifi = await InfoModule().isWifiConnected();
        if (!connectWifi) {
          state = state = state.copyWith(
              uiEvent: AlertEvent(
                  content: 'update_wifi_tip'.tr(),
                  confirmContent: 'upgrade'.tr(),
                  cancelContent: 'cancel'.tr(),
                  confirmCallback: () async {
                    await _startDownload();
                  }));
        } else {
          await _startDownload();
        }
      } else {
        await UIModule().openAppStore();
      }
    } else {
      await UIModule().openAppStore();
    }
  }

  Future<void> cancelDownloadTask() async {
    if (_cancelToken != null) {
      _cancelToken!.cancel('cancel download apk');
      _cancelToken = null;
      state = state.copyWith(downloading: false, progress: 0);
    }
  }

  Future<void> _startDownload() async {
    Directory? appDocumentsDir = await getExternalStorageDirectory();
    String savePath = '${appDocumentsDir?.path}/MOVAhome.apk';
    state = state.copyWith(downloading: true);
    _cancelToken = CancelToken();
    await DMHttpManager().create(
        receiveTimeout: const Duration(minutes: 5),
        interceptorTypes: [InterceptorType.none]).download(
      cancelToken: _cancelToken,
      state.downloadUrl,
      savePath,
      onReceiveProgress: ((count, total) {
        state = state.copyWith(progress: (count / total * 100).floor());
      }),
    ).then((val) async {
      await InfoModule().installApk(savePath);
      state = state.copyWith(installApk: true);
    }).catchError((error) {
      state = state.copyWith(downloading: false);
      LogUtils.e('download error: $error');
    });
  }
}
