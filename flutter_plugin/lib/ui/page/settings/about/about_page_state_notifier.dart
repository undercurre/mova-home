import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/page/settings/about/about_page_ui_state.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state_notifier.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'about_page_state_notifier.g.dart';

@riverpod
class AboutPageStateNotifier extends _$AboutPageStateNotifier {
  @override
  AboutPageUiState build() {
    final hasNewVersion =
        ref.read(appUpgradeStateNotifierProvider).hasNewVersion;
    return AboutPageUiState(
        uiNewVersion: hasNewVersion,
        hasNewVersion: hasNewVersion,
        newVersionName: hasNewVersion
            ? 'newest_version'.tr(
                args: [ref.read(appUpgradeStateNotifierProvider).versionName])
            : 'about_last_version'.tr());
  }

  Future<void> initData() async {
    if (RegionStore().isChinaServer()) {
      const permissionUrl =
          'https://protocol.dreame.tech/r9407/zh/permission.html';
      const sdkUrl = 'https://protocol.dreame.tech/r9407/zh/sdk.html';
      state =
          state.copyWith(permissionUrl: permissionUrl, shareListUrl: sdkUrl);
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    final privacy = await _readLocalStorage();
    state = state.copyWith(
        appVersion: version,
        privacyUrl: privacy?.privacyUrl ?? '',
        agreementUrl: privacy?.agreementUrl ?? '');
    if (!state.hasNewVersion) {
      await checkUpdate();
    }
  }

  Future<String> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    final mallInfo = await ref
        .read(pluginLocalRepositoryProvider.notifier)
        .getLocalInfo('$COMMONPLUGIN${CommonPluginType.mall.value}');
    return '包类型:${(await InfoModule().envType()).name}\nSDK版本依赖:${Constant.appVersion}\n商城内置版本:${Constant.mallVersionLocal}\n商城版本:${mallInfo.version ?? ''}\n版本号:${packageInfo.buildNumber}\n版本名:$version\nAPP请求地址:${await InfoModule().getUriHost()}';
  }

  Future<void> checkUpdate(
      {bool showToast = false, bool forceShow = false}) async {
    state = state.copyWith(uiNewVersion: false);
    final updateState =
        await ref.read(appUpgradeStateNotifierProvider.notifier).checkUpdate();
    state = state.copyWith(
        hasNewVersion: updateState.hasNewVersion,
        uiNewVersion:
            forceShow ? updateState.hasNewVersion : updateState.isForce,
        newVersionName: updateState.hasNewVersion
            ? 'newest_version'.tr(args: [updateState.versionName])
            : 'about_last_version'.tr(),
        uiEvent: updateState.hasNewVersion || !showToast
            ? null
            : ToastEvent(text: 'about_last_version'.tr()));
  }

  Future<PrivacyInfoBean?> _readLocalStorage() async {
    var privacyInfo = await AccountModule().getPrivacyInfo();
    var lang = await LocalModule().getLangTag();
    var region = await LocalModule().serverSite();
    final tenantId = await AccountModule().getTenantId();

    privacyInfo?.agreementUrl =
        '${privacyInfo.agreementUrl}&curLang=$lang&curRegion=$region&tenantId=$tenantId';
    privacyInfo?.privacyUrl =
        '${privacyInfo.privacyUrl}&curLang=$lang&curRegion=$region&tenantId=$tenantId';
    return privacyInfo;
  }
}
