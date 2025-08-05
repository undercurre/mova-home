import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_connect.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/bt/smart_step_bt_connect.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/smart_step_check_qr_pair.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:lifecycle/src/lifecycle_aware.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'iot_step_mixin.dart';
import 'smart_step_config.dart';
import 'smart_step_event.dart';
import 'step/ap/smart_step_ap_manual_connect.dart';

class SmartStepHelper with IotStepMixin implements SmartStepConfigCallback {
  SmartStepHelper._internal();

  factory SmartStepHelper() => _instance;
  static final SmartStepHelper _instance = SmartStepHelper._internal();

  final _stepQueue = Queue<SmartStepConfig>();

  late EventBus _eventBus;

  @override
  Future<void> postEvent<T>(SmartStepEvent<T> event, {int delayMs = 0}) async {
    if (delayMs > 0) {
      Future.delayed(Duration(milliseconds: delayMs), () {
        _eventBus.fire(event);
      });
    } else {
      _eventBus.fire(event);
    }
  }

  void removeEvent(int what) {
    // 暂时用不上
  }

  @override
  void nextStep(SmartStepConfig nextStep, {Map<String, dynamic>? args}) {
    _popStep();
    _switchToStep(nextStep);
  }

  @override
  Future<void> finish(bool success) async {
    await dispose();
  }

  void startFirstPage(EventBus eventBus, {Map<String, dynamic>? arguments}) {
    this._eventBus = eventBus;
    _stepQueue.clear();

    /// android 在扫描附近设备时，选了手动配网按钮，则跳转进入手动配网页面
    var scType = IotPairNetworkInfo().selectIotDevice?.product?.scType ??
        IotPairNetworkInfo().product?.scType;
    var extendScType = IotPairNetworkInfo().product?.extendScType;
    if (arguments?['isManualConnect'] == true) {
      _switchToStep(SmartStepApManualConnect());
    } else if (extendScType
                ?.contains(IotDeviceExtendScType.QR_CODE_V2.extendSctype) ==
            true &&
        arguments?.containsKey('pairQRKey') == true) {
      _switchToStep(SmartStepCheckQrPair(IotPairNetworkInfo().pairQRKey ?? ''));
    } else if (IotPairNetworkInfo().pairEntrance == IotPairEntrance.qr &&
        IotPairNetworkInfo().deviceSsid?.isNotEmpty == true) {
      if (IotPairNetworkInfo()
          .product
          ?.extendScType
          .contains(IotDeviceExtendScType.ENABLE_BC_PAIR.extendSctype) ==
          true) {
        _switchToStep(SmartStepBtConnect());
      } else {
        _switchToStep(SmartStepApConnect());
      }
    } else if (scType == IotScanType.BLE.scanType) {
      _switchToStep(SmartStepBtConnect());
    } else if (scType == IotScanType.WIFI_BLE.scanType) {
      if (IotPairNetworkInfo().selectIotDevice?.bleDevice != null) {
        _switchToStep(SmartStepBtConnect());
      } else {
        _switchToStep(
            Platform.isIOS ? SmartStepApManualConnect() : SmartStepApConnect());
      }
    } else if (scType == IotScanType.WIFI.scanType) {
      _switchToStep(
          Platform.isIOS ? SmartStepApManualConnect() : SmartStepApConnect());
    } else {
      _switchToStep(SmartStepApManualConnect());
    }
  }

  void _popStep() {
    while (_stepQueue.isNotEmpty) {
      final pop = _stepQueue.removeLast();
      if (pop.isStepRunning()) {
        // 隐藏在后台的step,销毁，注意stepDestroy方法重复调用问题
        pop.stepDestroy();
      }
    }
  }

  void _switchToStep(SmartStepConfig step) {
    _stepQueue.add(step);
    step.stepConfigCallback = this;
    step.stepRunning = true;
    step.stepCreate();
  }

  void handleMessage(SmartStepEvent event) {
    _stepQueue.last.handleMessage(event);
  }

  /// activity resume
  void onAppResume() {
    for (var element in _stepQueue) {
      element.stepResume();
    }
  }

  /// activity pause
  void onAppPaused() {
    for (var element in _stepQueue) {
      element.stepPause();
    }
  }

  /// page dispose
  Future<void> dispose() async {
    await forceDisconnectDeviceAP();
    await forceDisConnectDeviceBt(null);
    for (var element in _stepQueue) {
      element.onStepDestroy();
    }
    _stepQueue.clear();
  }

  /// 暂时用不上
  void onLifecycleEvent(LifecycleEvent event) {}

  /// 帮助代码
  @override
  SmartStepConfig? currentStep() => _stepQueue.lastOrNull;

  bool isCurrentManualStep() => currentStep() is SmartStepApManualConnect;

  Future<bool>? onBackClick() {
    finish(false);
    return _stepQueue.firstOrNull?.onBackClick();
  }
}
