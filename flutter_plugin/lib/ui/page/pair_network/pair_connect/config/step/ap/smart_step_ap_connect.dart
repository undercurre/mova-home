import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_manual_connect.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_send_data.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/extension/quoted_ssid_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';

///此步骤只在Android上有用
class SmartStepApConnect extends SmartStepConfig {
  @override
  StepId get stepId => StepId.STEP_AP_AUTO_CONNECTION;
  bool isConnecting = false;
  CancelableOperation? _cancelableOperation;
  StreamSubscription<List<ConnectivityResult>>? _wifiConnectStreamSubscription;

  @override
  Future<void> stepCreate() async {
    await _subscribWifiChange();
    postEvent(
        SmartStepEvent(StepName.STEP_CONNECT, status: SmartStepStatus.start));
    isConnecting = true;
    final isConncected = await WiFiForIoTPlugin.connect(
      IotPairNetworkInfo().selectIotDevice?.wifiSsid ?? '',
      timeoutInSeconds: 60,
    );
    final ssid = await NetworkInfo()
        .getWifiName()
        .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
    final isAp = isIotDeviceAp(ssid, isManual: true);
    isConnecting = false;
    if (!isConncected) {
      if (isAp) {
        /// OPPO 手机成功和失败都是返回 false,所以此处判断一下
        await delayCheckCanSendUdp();
      } else {
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.failed));
        nextStep(SmartStepApManualConnect());
        return;
      }
    }
    final forceWifiUsage = await WiFiForIoTPlugin.forceWifiUsage(true);
    if (forceWifiUsage) {
      await delayCheckCanSendUdp();
      postEvent(SmartStepEvent(StepName.STEP_CONNECT,
          status: SmartStepStatus.success));
      nextStep(SmartStepApSendData());
    } else {
      postEvent(SmartStepEvent(StepName.STEP_CONNECT,
          status: SmartStepStatus.failed));
      nextStep(SmartStepApManualConnect());
    }
  }

  Future<void> delayCheckCanSendUdp({int delay = 3}) async {
    /// OPPO 手机比较特殊
    bool isOppo = false;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      isOppo = androidInfo.manufacturer.toUpperCase() == 'oppo'.toUpperCase() ||
          androidInfo.fingerprint.toUpperCase() == 'oppo'.toUpperCase();
    }
    int index = 0;
    int count = isOppo ? delay + 2 : delay;
    while (index < count) {
      bool canUDPConnect = await checkWifi();
      if (canUDPConnect) {
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.success));
        nextStep(SmartStepApSendData());
      }
      index++;
    }
  }

  @override
  void handleMessage(msg) {}

  @override
  void stepResume() {
    if (isConnecting && stepRunning) {
      _cancelableOperation = CancelableOperation.fromFuture(
          Future.delayed(const Duration(seconds: 20), () {
        if (_cancelableOperation == null ||
            _cancelableOperation?.isCanceled == true ||
            _cancelableOperation?.isCompleted == true) {
          return;
        }

        /// 还没连上，就去手动连接
        isConnecting = false;
        postEvent(SmartStepEvent(StepName.STEP_CONNECT,
            status: SmartStepStatus.failed));
        nextStep(SmartStepApManualConnect());
      }));
    }
  }

  @override
  Future<void> stepDestroy() async {
    isConnecting = false;
    await _cancelableOperation?.cancel();
    _cancelableOperation = null;
    await _wifiConnectStreamSubscription?.cancel();
    _wifiConnectStreamSubscription = null;
  }

  Future<void> _subscribWifiChange() async {
    _wifiConnectStreamSubscription = Connectivity()
        .onConnectivityChanged
        .where((event) => event.last == ConnectivityResult.wifi)
        .listen((event) async {
      /// 获取当前Wi-Fi
      await checkWifi();
    });
  }

  /// 测试一下dhcpInfo: ipaddr 192.168.5.100 gateway 192.168.5.1 netmask 0.0.0.0 dns1 192.168.5.1 dns2 0.0.0.0
  /// DHCP server 192.168.5.1 lease 3600 seconds
  Future<bool> checkWifi() async {
    final ssid = await NetworkInfo()
        .getWifiName()
        .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
    final gatewayIp = await NetworkInfo().getWifiGatewayIP() ?? '';
    final wifiIp = await NetworkInfo().getWifiIP() ?? '';
    LogUtils.e('checkWifi ssid:$ssid, gatewayIp:$gatewayIp wifiIp:$wifiIp');
    final isAp = isIotDeviceAp(ssid, isManual: true);
    final isGatewayIp = gatewayIp == '192.168.5.1';
    LogUtils.i('checkWifi: isAp:$isAp isGatewayIp:$isGatewayIp');
    if (isAp /*&& isGatewayIp*/) {
      /// 发送检测Wi-Fi结果
      return true;
    } else {
      return false;
    }
  }
}
