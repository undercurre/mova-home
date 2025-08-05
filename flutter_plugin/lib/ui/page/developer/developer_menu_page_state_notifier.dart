// ignore_for_file: constant_identifier_names

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_ui_state.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'developer_menu_page_state_notifier.g.dart';

@riverpod
class DeveloperMenuPageStateNotifier extends _$DeveloperMenuPageStateNotifier {
  static const String AFTERSALE = 'afterSale';
  static const String COMMON_PAIR_NET_ENABLE = 'commonPairNetEnable';
  static const String SDK_TEST_PLUGIN_ENABLE = 'sdkTestPluginEnable';
  static const String CONVENTION_CENTER_ENABLE = 'conventionCenterEnable';

  @override
  DeveloperMenuPageUIState build() {
    return DeveloperMenuPageUIState();
  }

  Future<bool> getAfterSaleEnable() async {
    bool afterSaleEnable = await LocalStorage().getBool(AFTERSALE) ?? false;
    state = state.copyWith(afterSaleEnable: afterSaleEnable);
    return afterSaleEnable;
  }

  Future<void> toggleAfterSaleEnable() async {
    bool afterSaleEnable = !state.afterSaleEnable;
    await LocalStorage().putBool(AFTERSALE, afterSaleEnable);
    state = state.copyWith(afterSaleEnable: afterSaleEnable);
  }

  Future<bool> getCommonPairNetEnable() async {
    bool commonPairNetEnable =
        await LocalStorage().getBool(COMMON_PAIR_NET_ENABLE) ?? false;
    state = state.copyWith(commonPairNetEnable: commonPairNetEnable);
    return commonPairNetEnable;
  }

  Future<void> toggleCommonPairNetEnable() async {
    bool commonPairNetEnable = !state.commonPairNetEnable;
    await LocalStorage().putBool(COMMON_PAIR_NET_ENABLE, commonPairNetEnable);
    state = state.copyWith(commonPairNetEnable: commonPairNetEnable);
  }

  Future<void> clearLocalMallVersion() async {
    String key = '$COMMONPLUGIN${CommonPluginType.mall.value}';
    await LocalStorage().remove(key);
    await ref.read(pluginProvider.notifier).unzipLocalMall();
    PluginLocalModel pluginLocalModel = await ref
        .watch(pluginLocalRepositoryProvider.notifier)
        .getLocalInfo(key);
    state = state.copyWith(
        event: ToastEvent(
            text:
            '清理后, 使用的版本号: ${pluginLocalModel.version}, 路径: ${pluginLocalModel.partition}'));
    await ref
        .read(pluginProvider.notifier)
        .checkMallUpdateIfNeeded(forceCheck: true);
  }

  Future<bool> getSDKTestPluginEnable() async {
    bool sdkTestPluginEnable =
        await LocalStorage().getBool(SDK_TEST_PLUGIN_ENABLE) ?? false;
    state = state.copyWith(sdkTestPluginEnable: sdkTestPluginEnable);
    return sdkTestPluginEnable;
  }

  Future<void> toggleSDKTestPluginEnable() async {
    bool sdkTestPluginEnable = !state.sdkTestPluginEnable;
    await LocalStorage().putBool(SDK_TEST_PLUGIN_ENABLE, sdkTestPluginEnable);
    state = state.copyWith(sdkTestPluginEnable: sdkTestPluginEnable);
  }

  Future<bool> getConventionCenterEnable() async {
    bool enableConventionCenter =
        await LocalStorage().getBool(CONVENTION_CENTER_ENABLE) ?? false;
    state = state.copyWith(enableConventionCenter: enableConventionCenter);
    return enableConventionCenter;
  }

  Future<void> toggleConventionCenterEnable() async {
    bool enableConventionCenter = !state.enableConventionCenter;
    await LocalStorage()
        .putBool(CONVENTION_CENTER_ENABLE, enableConventionCenter);
    state = state.copyWith(enableConventionCenter: enableConventionCenter);
  }

}
