import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/custom_guide/custome_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/extension/quoted_ssid_extension.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_wifi_info_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_network_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_code/pair_qr_code_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_tips/pair_qr_tips_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_uistate.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wifi_iot/wifi_iot.dart';

part 'router_password_state_notifier.g.dart';

@riverpod
class RouterPasswordStateNotifier extends _$RouterPasswordStateNotifier
    with PairNetWifiInfoMixin {
  RouterPasswordUiState build() {
    return const RouterPasswordUiState();
  }

  void inputRouterWifiName(String value) {
    IotPairNetworkInfo().routerWifiName = value;
    state = state.copyWith(routerWifiName: value);
    enableBtn();
  }

  void inputRouterPwd(String value) {
    IotPairNetworkInfo().routerWifiPwd = value;
    state = state.copyWith(routerWifipwd: value);
    enableBtn();
  }

  void toggleClearLog() {
    state = state.copyWith(isClearLog: !state.isClearLog);
    IotPairNetworkInfo().isAfterSale = state.isClearLog;
  }

  void enableBtn() {
    final routerWifiName = state.routerWifiName;
    final routerWifipwd = state.routerWifipwd;
    if (routerWifiName?.isNotEmpty == true && routerWifipwd.isEmpty) {
      state = state.copyWith(enableBtn: true);
    } else if (routerWifiName?.isNotEmpty == true && routerWifipwd.isNotEmpty) {
      state = state.copyWith(
          enableBtn: (routerWifipwd.length >= 8 && routerWifipwd.length <= 63));
    } else {
      state = state.copyWith(enableBtn: false);
    }
  }

  /// 获取当前连接的Wi-Fi名称，可能还要确定Wi-Fi打开并且有权限
  Future<void> getRouterWifiName() async {
    final routerWifiName = await WiFiForIoTPlugin.getSSID()
        .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
    if (state.routerWifiName != routerWifiName) {
      IotPairNetworkInfo().routerWifiName = routerWifiName;
      final frequency = await WiFiForIoTPlugin.getFrequency() ?? 0;
      try {
        final wifiMap = await loadWifiListFrmSp();
        LogUtils.d('wifiMap: $wifiMap');

        /// 填充默认的密码
        final pwd = wifiMap[routerWifiName] ?? '';
        IotPairNetworkInfo().routerWifiPwd = pwd;
        state = state.copyWith(
            routerWifiName: routerWifiName,
            routerWifipwd: pwd,
            frequency: frequency);
      } catch (e) {
        LogUtils.e('loadWifiListFrmSp error: $e');
      }
      state =
          state.copyWith(routerWifiName: routerWifiName, frequency: frequency);
      enableBtn();
    } else {
      // Wi-Fi名没变更, Wi-Fi名和密码不变
    }
  }

  void nextStep() {}

  /// 去设置选择Wi-Fi
  void gotoSettingSelectWifi() {
    if (Platform.isIOS) {
      OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
      settings.wifi();
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.wifi);
    }
  }

  /// 去设置热点
  void gotoSettingSelectHotspot() {
    if (Platform.isIOS) {
      OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
      settings.wifi();
    } else {
      AppSettings.openAppSettings(type: AppSettingsType.hotspot);
    }
  }

  void sendEvent(CommonUIEvent event) {
    state = state.copyWith(event: event);
  }

  Future<bool> getMqttDomainV2() async {
    try {
      final region = await LocalModule().serverSite();
      final domainRes = await ref
          .watch(pairNetworkRepositoryProvider)
          .getMqttDomainV2(region, false);
      IotPairNetworkInfo().regionUrl = domainRes.regionUrl ?? '';
      state = state.copyWith(
          domain: domainRes.regionUrl ?? '',
          pairQRKey: domainRes.pairQRKey ?? '');
      return true;
    } catch (e) {
      LogUtils.e('getMqttDomainV2 error: $e');
    }
    return false;
  }

  Future<void> updatePageState() async {
    await getRouterWifiName();
    final isEnabled = await WiFiForIoTPlugin.isEnabled();
    state = state.copyWith(isWifiOpen: isEnabled);
  }

  void updatePwdAutoFocus(bool isAutoFocus) {
    state = state.copyWith(autoFocus: isAutoFocus);
  }

  Future<void> initData(List<PairGuideModel> pairGuides) async {
    state = state.copyWith(
        pairGuides: pairGuides,
        currentStep: IotPairNetworkInfo().currentStep,
        totalStep: IotPairNetworkInfo().totalStep);
    await getRouterWifiName();

    /// 售后人员
    final authBean = await AccountModule().getAuthBean();
    if (authBean.role_name != null && authBean.role_name?.isNotEmpty == true) {
      final a_sale = authBean.role_name
          ?.split(',')
          .firstWhereOrNull((element) => element == 'a_sale');
      state = state.copyWith(isAfterSale: a_sale != null);
    }
  }

  Future<void> getWifiFrequency() async {
    if (Platform.isAndroid) {
      final frequency = await WiFiForIoTPlugin.getFrequency();
      state = state.copyWith(frequency: frequency ?? 0);
    }
  }

  Future<void> gotoNextPage() async {
    if (IotPairNetworkInfo().pairEntrance == IotPairEntrance.nearby) {
      await AppRoutes().push(PairConnectPage.routePath);
      return;
    }
    if (state.pairGuides?.isNotEmpty == true) {
      await AppRoutes().push(CustomGuidePage.routePath,
          extra: Pair(
              state.pairGuides!.first.guideSortIndex, state.pairGuides ?? []));
    } else {
      if (IotPairNetworkInfo().pairEntrance == IotPairEntrance.qr &&
          IotPairNetworkInfo().deviceSsid?.isNotEmpty == true) {
        ///一机一码
        await AppRoutes().push(PairQrTipsPage.routePath);
      } else if (IotPairNetworkInfo()
              .product
              ?.extendScType
              .contains(IotDeviceExtendScType.QR_CODE_V2.extendSctype) ==
          true) {
        await AppRoutes().push(PairQrCodePage.routePath);
      } else if (IotPairNetworkInfo().product?.scType ==
              IotScanType.BLE.scanType ||
          IotPairNetworkInfo().product?.scType ==
              IotScanType.WIFI_BLE.scanType) {
        await AppRoutes().push(NearbyConnectPage.routePath);
      } else if (IotPairNetworkInfo().product?.scType ==
          IotScanType.WIFI.scanType) {
        if (Platform.isIOS) {
          await AppRoutes().push(PairConnectPage.routePath);
        } else {
          await AppRoutes().push(NearbyConnectPage.routePath);
        }
      } else {
        /// 其他未知 不管
        await AppRoutes().push(PairConnectPage.routePath);
      }
    }
  }
}
