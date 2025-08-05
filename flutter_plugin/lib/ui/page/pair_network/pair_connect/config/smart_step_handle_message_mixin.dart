import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/uiconfig/base_uiconfig.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/extension/quoted_ssid_extension.dart';

mixin SmartStepHandleMessageMixin on BasePageState {
  /// 带了stepStatus 表示处理UI信息的消息处理，否则step可处理
  Future<bool> handleUIMessage(SmartStepEvent event) async {
    dismissLoading();
    if (event.stepName == StepName.STEP_MAUNAL) {
      var wifiName = event.obj?.toString() ?? '';
      if (wifiName.isEmpty) {
        wifiName = await WiFiForIoTPlugin.getSSID()
            .then((value) => value?.decodeQuotedAndUnknownSSID() ?? '');
      }
      LogUtils.i('---handleUIMessage ssid:$wifiName');
      ref
          .watch(pairConnectStateNotifierProvider.notifier)
          .updateCurrentConnectWifiName(wifiName);
    }

    /// 是否已被别人绑定
    if (event.what == WHAT_BIND_HAS_OWN) {
      ref.watch(pairConnectStateNotifierProvider.notifier).updateStepHasOwnUI(
          event.stepName == StepName.STEP_TRANSFORM
              ? UIStep.STEP_2_UI
              : UIStep.STEP_3_UI);
      return true;
    }

    /// 处理pincode 操作
    if (handlePinCode(event)) {
      return true;
    }
    if (event.status != null) {
      onStepResult(event.stepName, event);
      return true;
    }
    return false;
  }

  bool handlePinCode(SmartStepEvent event) {
    /// pincode
    if (event.what == WHAT_PINCODE_LOCK ||
        event.what == WHAT_PINCODE_ERROR ||
        event.what == WHAT_PINCODE_INPUT ||
        event.what == WHAT_PINCODE_HIDE) {
      ref
          .watch(pairConnectStateNotifierProvider.notifier)
          .updatePinCode(event.what, event.obj?.toString() ?? '');
      return true;
    }
    return false;
  }

  void onStepResult(StepName stepName, SmartStepEvent event) {
    switch (stepName) {
      case StepName.STEP_CONNECT:
        stepConnectUI(event.status!, event.canManualConnect);
        break;
      case StepName.STEP_QR_NET_PAIR:
        stepQrNetPairUI(event.status!, event.canManualConnect);
        break;
      case StepName.STEP_TRANSFORM:
        stepTransformUI(event.status!, event.canManualConnect);
        break;
      case StepName.STEP_CHECK_PAIR:
        stepPairUI(event.status!, event.canManualConnect);
        break;

      case StepName.STEP_MAUNAL:
        stepManualUI(event.status!, event.canManualConnect);
        break;

      default:
        break;
    }
  }

  void stepConnectUI(SmartStepStatus status, bool canManualConnect) {
    switch (status) {
      case SmartStepStatus.start:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_1_UI, UIStep.STEP_STATUS_LOADING);
        break;
      case SmartStepStatus.success:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_1_UI, UIStep.STEP_STATUS_SUCCESS);
        break;
      case SmartStepStatus.failed:
      case SmartStepStatus.stop:

        /// 可以跳转手动
        if (canManualConnect) {
          /// manual ui
          ref
              .watch(pairConnectStateNotifierProvider.notifier)
              .updateStepUI(UIStep.STEP_MANUAL_UI, UIStep.STEP_STATUS_NONE);
        } else {
          ref
              .watch(pairConnectStateNotifierProvider.notifier)
              .updateStepUI(UIStep.STEP_1_UI, UIStep.STEP_STATUS_FAIL);
        }
        break;
    }
  }

  void stepManualUI(SmartStepStatus status, bool canManualConnect) {
    switch (status) {
      case SmartStepStatus.start:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_MANUAL_UI, UIStep.STEP_STATUS_NONE);
        break;
      case SmartStepStatus.success:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_1_UI, UIStep.STEP_STATUS_SUCCESS);
        break;
      case SmartStepStatus.failed:
      case SmartStepStatus.stop:

        /// manual ui
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_MANUAL_UI, UIStep.STEP_STATUS_NONE);

        break;
    }
  }

  void stepTransformUI(SmartStepStatus status, bool canManualConnect) {
    switch (status) {
      case SmartStepStatus.start:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_2_UI, UIStep.STEP_STATUS_LOADING);
        break;
      case SmartStepStatus.success:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_2_UI, UIStep.STEP_STATUS_SUCCESS);
        break;
      case SmartStepStatus.failed:
      case SmartStepStatus.stop:

        /// 可以跳转手动
        if (canManualConnect) {
          /// manual ui
          ref
              .watch(pairConnectStateNotifierProvider.notifier)
              .updateStepUI(UIStep.STEP_MANUAL_UI, UIStep.STEP_STATUS_NONE);
        } else {
          ref
              .watch(pairConnectStateNotifierProvider.notifier)
              .updateStepUI(UIStep.STEP_2_UI, UIStep.STEP_STATUS_FAIL);
        }
        break;
    }
  }

  void stepPairUI(SmartStepStatus status, bool canManualConnect) {
    switch (status) {
      case SmartStepStatus.start:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_3_UI, UIStep.STEP_STATUS_LOADING);
        break;
      case SmartStepStatus.success:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_3_UI, UIStep.STEP_STATUS_SUCCESS);
        break;
      case SmartStepStatus.failed:
      case SmartStepStatus.stop:

        /// 可以跳转手动
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_3_UI, UIStep.STEP_STATUS_FAIL);
        break;
    }
  }

  void stepQrNetPairUI(SmartStepStatus status, bool canManualConnect) {
    switch (status) {
      case SmartStepStatus.start:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_QR_PAIR_UI, UIStep.STEP_STATUS_LOADING);
        break;
      case SmartStepStatus.success:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_QR_PAIR_UI, UIStep.STEP_STATUS_SUCCESS);
        break;
      case SmartStepStatus.failed:
      case SmartStepStatus.stop:
        ref
            .watch(pairConnectStateNotifierProvider.notifier)
            .updateStepUI(UIStep.STEP_QR_PAIR_UI, UIStep.STEP_STATUS_FAIL);
        break;
    }
  }
}
