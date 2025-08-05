import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/home/device_status/key_define_provider.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_page.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/mine/mine_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_setting_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_settings_page.dart';
import 'package:flutter_plugin/ui/page/theme/app_theme_set_page.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

extension CommonSettingsPageStateController on CommonSettingsPageState {
  void loadData() {}

  void clearCache() {
    showAlert(
      text: 'clear_cache_confirm'.tr(),
      confirmString: 'dialog_determine'.tr(),
      confirmCallBack: clear,
    );
  }

  Future<void> clear() async {
    SmartDialog.showLoading();

    /// 清理缓存的广告
    var envType = await InfoModule().envType();
    if (envType != EnvType.release) {
      await ref.watch(mainRepositoryProvider).saveAdInfo(null);
    }

    ///
    await ref.read(mineStateNotifierProvider.notifier).clearCache();
    await ref.read(pluginProvider.notifier).unzipLocalMall();
    //清除数据库数据并重新导入asset下数据
    await ref.read(keyDefineProvider.notifier).clearKeyDefine();
    await ref.read(keyDefineProvider.notifier).init();
    SmartDialog.dismiss(status: SmartStatus.loading);
    ToastEvent alert = ToastEvent(text: 'clear_cache_success'.tr());
    ref.read(commonSettingStateNotifierProvider.notifier).refreshData();
    responseFor(alert);
  }

  void pushToLanguage() {
    GoRouter.of(context).push(LanguagePickerPage.routePath);
  }

  void pushToAccountSetting() {
    GoRouter.of(context).push(AccountSettingPage.routePath);
  }

  void pushToThemeMode() {
    GoRouter.of(context).push(AppThemeSetPage.routePath);
  }

  Future<void> pushToChangeRegion() async {
    RegionItem item = await LocalModule().getCurrentCountry();
    PushEvent event = PushEvent(
      path: RegionPickerPage.routePath,
      extra: RegionPickerPage.createExtra(item, showChangeDialog: true),
      pushCallback: changeRegion,
      func: RouterFunc.push,
    );
    responseFor(event);
  }

  Future<void> changeRegion(Object? value) async {
    if (value == null) return;
    if (value is RegionItem == false) return;
    RegionItem currentItem = value as RegionItem;
    await RegionStore().updateRegion(currentItem);
    MqttConnector().disconnect();
    MessageChannel().changeCountry(currentItem.countryCode);
    responseFor(ToastEvent(text: 'setting_success'.tr()));
  }

  void showAlert(
      {required String text,
      String? cancelString,
      String? confirmString,
      Function()? confirmCallBack}) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: cancelString ?? 'cancel'.tr(),
      confirmContent: confirmString ?? 'confirm'.tr(),
      confirmCallback: confirmCallBack,
    );
    responseFor(alert);
  }
}
