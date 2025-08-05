import 'dart:async';

import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_send_data.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/extension/quoted_ssid_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SmartStepApManualConnect extends SmartStepConfig {
  @override
  StepId get stepId => StepId.STEP_AP_MAUNAL_CONNECTION;
  final CODE_CHECK_WIFI = 1200;
  final CODE_CHECK_WIFI_RESULT = 1201;

  final CLICK_MANUAL_SETTING = 12001;

  StreamSubscription<List<ConnectivityResult>>? wifiConnectStreamSubscription;
  CancelableOperation? guaranteeJobOperation;

  @override
  void handleMessage(SmartStepEvent msg) {
    if (msg.what == CLICK_MANUAL_SETTING) {
      guaranteeJobOperation?.cancel();
    }
  }

  @override
  Future<void> stepCreate() async {
    final ssid = await NetworkInfo()
        .getWifiName()
        .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
    postEvent(SmartStepEvent(StepName.STEP_MAUNAL,
        status: SmartStepStatus.start, obj: ssid));
    await _subscribWifiChange();
  }

  Future<void> _subscribWifiChange() async {
    wifiConnectStreamSubscription = Connectivity()
        .onConnectivityChanged
        .where((event) => event.last == ConnectivityResult.wifi)
        .listen((event) async {
      /// 获取当前Wi-Fi
      final ssid = await NetworkInfo()
          .getWifiName()
          .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
      postEvent(SmartStepEvent(StepName.STEP_MAUNAL,
          what: CODE_CHECK_WIFI, obj: ssid));
    });
  }

  @override
  Future<void> stepResume() async {
    super.stepResume();
    // check wifi
    await Future.delayed(
        const Duration(
          milliseconds: 1000,
        ), () async {
      final ssid = await NetworkInfo()
          .getWifiName()
          .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
      LogUtils.d('--- stepResume checkWifi ssid:$ssid');
      await checkWifi();
      // postEvent(SmartStepEvent(StepName.STEP_MAUNAL,
      //     what: CODE_CHECK_WIFI, obj: ssid ?? ''));
    });

    if (guaranteeJobOperation != null) {
      await guaranteeJobOperation?.cancel();
    }
    // 增加补偿检测 尝试6s，Android手机获取ip可能要等一段时间经验约5s内，大多数可返回
    guaranteeJobOperation = CancelableOperation.fromFuture(guaranteeJob());
    await guaranteeJobOperation?.value;
  }

  Future<void> guaranteeJob() async {
    LogUtils.i('--- guaranteeJob checkWifi start');
    for (var index in List.generate(8, (index) => index)) {
      if (guaranteeJobOperation == null ||
          guaranteeJobOperation?.isCanceled == true) {
        return;
      }
      final isAp = await checkWifi();
      await Future.delayed(const Duration(milliseconds: 1000));
      LogUtils.i('--- stepResume checkWifi $index  $isAp');
      if (isAp) {
        break;
      }
    }
  }

  /// 测试一下dhcpInfo: ipaddr 192.168.5.100 gateway 192.168.5.1 netmask 0.0.0.0 dns1 192.168.5.1 dns2 0.0.0.0
  /// DHCP server 192.168.5.1 lease 3600 seconds
  /// 跳转设置 判断是否连上了机器Wi-Fi
  Future<bool> checkWifi() async {
    final ssid = await NetworkInfo()
        .getWifiName()
        .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
    final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
    final wifiIp = await NetworkInfo().getWifiIP() ?? '';
    LogUtils.e('checkWifi ssid:$ssid, gatewayIp:$gatewayIp wifiIp:$wifiIp');
    postEvent(
        SmartStepEvent(StepName.STEP_MAUNAL, what: CODE_CHECK_WIFI, obj: ssid));
    final isAp = isIotDeviceAp(ssid, isManual: true);
    final isGatewayIp = gatewayIp == '192.168.5.1';
    LogUtils.i('checkWifi: isAp:$isAp isGatewayIp:$isGatewayIp');
    if (isAp /*&& isGatewayIp*/) {
      /// 发送检测Wi-Fi结果
      postEvent(SmartStepEvent(StepName.STEP_MAUNAL,
          status: SmartStepStatus.success));
      nextStep(SmartStepApSendData());
    } else {
      postEvent(SmartStepEvent(StepName.STEP_MAUNAL,
          status: SmartStepStatus.failed, obj: ssid));
    }
    return isAp;
  }

  @override
  Future<void> stepDestroy() async {
    await guaranteeJobOperation?.cancel();
    guaranteeJobOperation = null;
    await wifiConnectStreamSubscription?.cancel();
  }
}
