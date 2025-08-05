import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:dreame_flutter_base_mqtt/dreame_flutter_base_mqtt.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/trace/module_code.dart';
import 'package:flutter_plugin/trace/pair_net_event_code.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/generate_session_id.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/hotspot/pair_set_hotspot_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/pair_net_check_mixin.dart';
import 'package:flutter_plugin/ui/page/webview/webview_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dialog/net_brand_error_dialog.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// 检查配网条件
mixin SetHotspotCheckMixin on BasePageState, CommonDialog {
  /// 校验条件
  /// [passwordSkip] 是否跳过密码、 [frequencySkip] 是否跳过频率
  Future<bool> checkNetworkCondition(
      {bool frequencySkip = false, bool passwordSkip = false}) async {
    /// show loading
    showLoading();
    // 1、 是否连接的设备热点
    var frequencyBand = checkNetworkConnectAP();
    //2. 是否连接的正确的频率
    if (frequencyBand && !frequencySkip) {
      frequencyBand = checkNetworkFrequencyBand();
    }
    if (frequencyBand && !passwordSkip) {
      //5、 是否无密码
      frequencyBand = confirmNoPassword();
    }
    if (frequencyBand) {
      //3、 是否可连接外网
      LogUtils.d('sunzhibin - checkNetworkConnectInternet start --------');
      frequencyBand = await checkNetworkConnectInternet();
      LogUtils.d('sunzhibin - checkNetworkConnectInternet end --------');
    }
    if (frequencyBand) {
      //4、 是否可连接ENQ
      LogUtils.d('sunzhibin - checkNetworkConnectEMQ start --------');

      /// 优先检查一下当前mqtt连接状态，未连接时，尝试自己连一下
      frequencyBand = MqttConnector().checkConnect();
      if (!frequencyBand) {
        // frequencyBand = await checkNetworkConnectEMQ();
        // 不再强制控制mqtt是否连接
        frequencyBand = true;
      } else {
        LogModule().eventReport(
          ModuleCode.PairNetNew.code,
          PairNetEventCode.UnReachableToEMQ.code,
          int1: 1,
          int2: 1,
          str1: GenerateSessionID().currentSessionID(),
        );
      }
      LogUtils.d('sunzhibin - checkNetworkConnectEMQ end --------');
    }
    if (frequencyBand) {
      // 5、保存Wi-Fi List
      // saveWifiList()
      //6、 success
      LogUtils.d('sunzhibin - checkNetworkCondition success --------');
      // 自定义引导页面
      await ref
          .read(pairSetHotspotStateNotifierProvider.notifier)
          .gotoNextPage();
      dismissLoading();
      return true;
    }
    dismissLoading();
    return false;
  }

  /// 检查是否连接的设备热点
  bool checkNetworkConnectAP() {
    final currentWifiName =
        ref.watch(pairSetHotspotStateNotifierProvider).routerWifiName ?? '';
    if (PairNetCheckMixin.isValidWifiName(currentWifiName)) {
      // show toast
      ref
          .watch(pairSetHotspotStateNotifierProvider.notifier)
          .sendEvent(ToastEvent(text: 'text_device_hotspot_tip'.tr()));
      return false;
    }
    if ((currentWifiName.startsWith('dreame_') ||
            currentWifiName.startsWith('mova_') ||
            currentWifiName.startsWith('trouver_')) &&
        currentWifiName.contains('_miap')) {
      ref
          .watch(pairSetHotspotStateNotifierProvider.notifier)
          .sendEvent(ToastEvent(text: 'text_device_hotspot_tip'.tr()));
      return false;
    }
    return true;
  }

  /// 是否连接的正确的频率
  bool checkNetworkFrequencyBand() {
    final frequency = ref.watch(pairSetHotspotStateNotifierProvider).frequency;
    LogUtils.d('---frequency: $frequency-');
    var is24G = false;
    if (Platform.isAndroid) {
      is24G = frequency > 2400 && frequency < 2500;
    } else {
      final currentWifiName =
          ref.watch(pairSetHotspotStateNotifierProvider).routerWifiName ?? '';
      if (currentWifiName.contains('5G') || currentWifiName.contains('5g')) {
        is24G = false;
      } else {
        is24G = true;
      }
    }
    if (is24G) {
      return true;
    } else {
      showNetBrandErrorDialog();
    }
    return false;
  }

  bool confirmNoPassword() {
    final routerWifipwd =
        ref.watch(pairSetHotspotStateNotifierProvider).routerWifipwd;
    if (routerWifipwd.isEmpty) {
      /// 无密码弹框
      showConfirmNoPassword();
      return false;
    }
    return true;
  }

  Future<bool> checkNetworkConnectInternet() async {
    final isConnectNetwork = await ref
        .watch(pairSetHotspotStateNotifierProvider.notifier)
        .getMqttDomainV2();
    if (!isConnectNetwork) {
      ref
          .watch(pairSetHotspotStateNotifierProvider.notifier)
          .sendEvent(ToastEvent(text: 'text_wifi_is_unreachable'.tr()));
    }
    return isConnectNetwork;
  }

  /// 创建一个MQTTclient,尝试连接一下EMQ服务
  Future<bool> checkNetworkConnectEMQ() async {
    Completer<bool> completer = Completer();
    await DMMqttClient(
      clientConfig: MqttClientConfig(
        serverConfig: () async {
          final serverUri = await MqttConnector().getServerUri();
          return ServerConfig(host: serverUri.first, port: serverUri.second);
        },
        authConfig: () async {
          final account = await AccountModule().getAuthBean();
          return AuthConfig(
              username: account.uid ?? '', password: account.accessToken ?? '');
        },
        autoReconnect: false,
        maxConnectionAttempts: 3,
        keepAlivePeriod: 15,
        connectTimeoutPeriod: 8 * 1000,
      ),
      onConnectedCallback: (client) {
        LogModule().eventReport(
          ModuleCode.PairNetNew.code,
          PairNetEventCode.UnReachableToEMQ.code,
          int1: 1,
          int2: 1,
          str1: GenerateSessionID().currentSessionID(),
        );
        client.disconnect();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      },
      onConnectErrorCallback: (exception) {
        LogUtils.i(
            'sunzhibin - checkNetworkConnectEMQ client exception - $exception');
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    ).connect();
    return completer.future;
  }

  /// 无密码弹框
  void showConfirmNoPassword() {
    showAlertDialog(
        content: 'text_no_need_pwd'.tr(),
        confirmContent: 'yes'.tr(),
        cancelContent: 'input_wifi_password'.tr(),
        cancelCallback: () async {
          // 下一页
          ref
              .read(pairSetHotspotStateNotifierProvider.notifier)
              .updatePwdAutoFocus(true);
        },
        confirmCallback: () async {
          await checkNetworkCondition(frequencySkip: true, passwordSkip: true);
        });
  }

  /// 网络频段错误弹窗
  Future<void> showNetBrandErrorDialog() async {
    final ssid = await NetworkInfo().getWifiName();
    await SmartDialog.show(
        tag: 'NetBrandErrorDialog',
        backDismiss: false,
        animationType: SmartAnimationType.fade,
        maskColor: Colors.black.withOpacity(0.5),
        clickMaskDismiss: false,
        builder: (_) {
          return NetBrandErrorDialog(
            smartDialogTag: 'NetBrandErrorDialog',
            ssid: ssid,
            guideCallback: () async {
              /// 跳转网页
              final lang = LanguageStore().getCurrentLanguage().langTag;
              String host = await InfoModule().getUriHost();
              final tenantId = await AccountModule().getTenantId();
              final index = host.lastIndexOf(':');
              if (index != -1 && index > 'https://'.length) {
                host = host.substring(0, index);
              }
              final url =
                  '$host:8080/connectNetwork/connectGuide.html?lang=$lang&tenantId=$tenantId';
              await AppRoutes().push(WebviewPage.routePath,
                  extra: WebviewPage.createParams(
                      url: url, title: 'text_connect_guide'.tr()));
            },
            confirmCallback: () {
              ref
                  .watch(pairSetHotspotStateNotifierProvider.notifier)
                  .gotoSettingSelectWifi();
            },
            cancelCallback: () async {
              // 跳转下一页
              await checkNetworkCondition(frequencySkip: true);
            },
          );
        });
  }
}
