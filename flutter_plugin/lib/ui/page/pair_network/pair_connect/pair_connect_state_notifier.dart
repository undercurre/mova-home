import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/uiconfig/base_uiconfig.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'config/smart_step_event.dart';
import 'pair_connect_uistate.dart';

part 'pair_connect_state_notifier.g.dart';

@riverpod
class PairConnectStateNotifier extends _$PairConnectStateNotifier {
  @override
  PairConnectUiState build() {
    return PairConnectUiState();
  }

  Future<void> initData() async {
    final isZh = await LocalModule().getLangTag() == 'zh';
    var isOppo = false;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      isOppo = androidInfo.manufacturer.toUpperCase() == 'oppo'.toUpperCase() ||
          androidInfo.fingerprint.toUpperCase() == 'oppo'.toUpperCase();
    }
    // 手动
    var manualAnimPath = isZh
        ? ref
            .watch(resourceModelProvider)
            .getResource('anim_manual_connect_zh', suffix: '.json')
        : ref
            .watch(resourceModelProvider)
            .getResource('anim_manual_connect_en', suffix: '.json');

    state = state.copyWith(
      manualAnimPath: manualAnimPath,
      // isShowManual: false,
      // step1Status:
      //     Platform.isIOS ? UIStep.STEP_STATUS_NONE : UIStep.STEP_STATUS_LOADING,
      // step2Status: UIStep.STEP_STATUS_NONE,
      // step3Status: UIStep.STEP_STATUS_NONE,
    );
  }

  /// 已经绑定了别人
  void updateStepHasOwnUI(int currentStep) {
    state = state.copyWith(
        showPinCode: false,
        isShowManual: false,
        step1Status: UIStep.STEP_STATUS_SUCCESS,
        step1Text: 'phone_connect_device_success'.tr(),
        step2Status: UIStep.STEP_STATUS_FAIL,
        step2Text: 'text_robot_is_bound'.tr(),
        step3Status: UIStep.STEP_STATUS_NONE,
        navTitle: 'pair_failure'.tr());
  }

  void updateStepUI(int currentStep, int stepStatus) {
    switch (currentStep) {
      case UIStep.STEP_1_UI:
        state = state.copyWith(
            isShowManual: false,
            step1Status: stepStatus,
            step1Text: stepStatus == UIStep.STEP_STATUS_LOADING
                ? 'phone_connecting_device'.tr()
                : stepStatus == UIStep.STEP_STATUS_SUCCESS
                    ? 'phone_connect_device_success'.tr()
                    : 'phone_connect_device_failed'.tr(),
            step2Status: stepStatus == UIStep.STEP_STATUS_SUCCESS
                ? UIStep.STEP_STATUS_LOADING
                : UIStep.STEP_STATUS_NONE,
            step3Status: UIStep.STEP_STATUS_NONE,
            step2Text: 'sending_data_to_device'.tr(),
            step3Text: 'query_devices_state'.tr(),
            navTitle: stepStatus == UIStep.STEP_STATUS_FAIL
                ? 'pair_failure'.tr()
                : 'device_connecting'.tr());
        break;
      case UIStep.STEP_2_UI:
        state = state.copyWith(
            isShowManual: false,
            step1Status: UIStep.STEP_STATUS_SUCCESS,
            step1Text: 'phone_connect_device_success'.tr(),
            step2Status: stepStatus,
            step2Text: stepStatus == UIStep.STEP_STATUS_LOADING
                ? 'sending_data_to_device'.tr()
                : stepStatus == UIStep.STEP_STATUS_SUCCESS
                    ? 'send_data_to_device_success'.tr()
                    : 'send_data_to_device_failed'.tr(),
            step3Status: stepStatus == UIStep.STEP_STATUS_SUCCESS
                ? UIStep.STEP_STATUS_LOADING
                : UIStep.STEP_STATUS_NONE,
            navTitle: stepStatus == UIStep.STEP_STATUS_FAIL
                ? 'pair_failure'.tr()
                : 'device_connecting'.tr());
        break;
      case UIStep.STEP_3_UI:
        state = state.copyWith(
            isShowManual: false,
            step1Status: UIStep.STEP_STATUS_SUCCESS,
            step1Text: 'phone_connect_device_success'.tr(),
            step2Status: UIStep.STEP_STATUS_SUCCESS,
            step2Text: 'send_data_to_device_success'.tr(),
            step3Status: stepStatus,
            step3Text: stepStatus == UIStep.STEP_STATUS_LOADING
                ? 'query_devices_state'.tr()
                : stepStatus == UIStep.STEP_STATUS_SUCCESS
                    ? 'query_devices_state_success'.tr()
                    : 'query_devices_state_failed'.tr(),
            navTitle: stepStatus == UIStep.STEP_STATUS_FAIL
                ? 'pair_failure'.tr()
                : 'device_connecting'.tr());
        if (stepStatus == UIStep.STEP_STATUS_SUCCESS) {
          /// 通知首页刷新设备列表
          state = state.copyWith(
            navTitle: 'pair_success'.tr(),
          );
        }
        break;
      case UIStep.STEP_QR_PAIR_UI:
        state = state.copyWith(
            isShowManual: false,
            step1Status: stepStatus,
            step1Text: stepStatus == UIStep.STEP_STATUS_LOADING
                ? 'query_devices_state'.tr()
                : stepStatus == UIStep.STEP_STATUS_SUCCESS
                    ? 'query_devices_state_success'.tr()
                    : 'query_devices_state_failed'.tr(),
            navTitle: stepStatus == UIStep.STEP_STATUS_FAIL
                ? 'pair_failure'.tr()
                : stepStatus == UIStep.STEP_STATUS_SUCCESS
                    ? 'pair_success'.tr()
                    : 'device_connecting'.tr());
        if (stepStatus == UIStep.STEP_STATUS_SUCCESS) {
          /// 通知首页刷新设备列表
          state = state.copyWith(
            navTitle: 'pair_success'.tr(),
          );
        }
        break;
      case UIStep.STEP_MANUAL_UI:
        state = state.copyWith(
            isShowManual: true,
            step1Status: UIStep.STEP_STATUS_NONE,
            step2Status: stepStatus == UIStep.STEP_STATUS_SUCCESS
                ? UIStep.STEP_STATUS_LOADING
                : UIStep.STEP_STATUS_NONE,
            step3Status: UIStep.STEP_STATUS_NONE,
            navTitle: 'text_connect_device_hotspot');
        break;
    }
  }

  void gotoStepManual() {}

  void updateCurrentConnectWifiName(wifiName) {
    state = state.copyWith(wifiName: wifiName);
  }

  void updateConnectDialogShowState(bool isShow) {
    state = state.copyWith(isShowConnectDialog: isShow);
  }

  void updatePinCode(int what, String s) {
    if (s.isEmpty) s = '0';
    state = state.copyWith(
        showPinCode: what != WHAT_PINCODE_HIDE,
        pinCodeStatus: what,
        remain: int.parse(s));
  }
}
