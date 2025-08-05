import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/common/bridge/pair_net_module.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/basic_permission_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';

/// 蓝牙打开步骤
class StepBtOpenRequestDialog extends BasicPermissionStep {
  StepBtOpenRequestDialog(
      {super.stepId = StepId.STEP_BT_OPEN_REQUEST_DIALOG,
      super.isMustBe = true,
      super.isOnceAgain = true,
      super.dependenceStepIds = const [
        StepId.STEP_BT_PERMISSION_REQUEST_DIALOG
      ]});

  StreamSubscription? streamSubscription = null;

  @override
  void onStepStart(CommonStepChain chain, StepEvent event) {
    super.onStepStart(chain, event);
    streamSubscription = FlutterBluePlus.adapterState.listen((event) {
      /// 蓝牙开关状态
    });
  }

  @override
  void onStepStop(CommonStepChain chain) {
    super.onStepStop(chain);
    streamSubscription?.cancel();
    streamSubscription = null;
  }

  @override
  Future<StepResult> next(CommonStepChain chain, StepEvent event) async {
    enterCount++;
    var adapterState = BluetoothAdapterState.unknown;
    Set<BluetoothAdapterState> inProgress = {
      BluetoothAdapterState.unknown,
      BluetoothAdapterState.turningOn
    };
    var asyncAdapterState = FlutterBluePlus.adapterState
        .where((v) => !inProgress.contains(v))
        .first;
    await asyncAdapterState
        .timeout(const Duration(seconds: 3))
        .then((value) => adapterState = value)
        .onError((error, stackTrace) => BluetoothAdapterState.unknown);
    if (Platform.isAndroid) {
      final isHalfOPen = await PairNetModule().readBluetoothHalfState();
      if (isHalfOPen) {
        adapterState = BluetoothAdapterState.off;
      }
    }
    if (adapterState == BluetoothAdapterState.on ||
        adapterState == BluetoothAdapterState.turningOn) {
      return chain.proceed(event.success(stepId), next: true);
    } else if (enterCount <= 1) {
      if (Platform.isIOS) {
        if (adapterState == BluetoothAdapterState.unauthorized) {
          return await showAuthorizedDialog(chain, event);
        } else if (adapterState == BluetoothAdapterState.off) {
          return await showOpenBtDialog(chain, event);
        }
      } else {
        return await showOpenBtDialog(chain, event);
      }
    }

    /// 弹过弹框，再次进来，还未开启，直接跳过
    return chain.proceed(event.fail(stepId),
        success: false, next: true, isDependence: true);
  }

  Future<StepResult> showOpenBtDialog(CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCommonDialog(
        content: 'scanning_bluetooth_close'.tr(),
        contentAlign: TextAlign.center,
        confirmContent: 'text_goto_open'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () {
          complete.complete(chain.proceed(event.fail(stepId), success: false));
        },
        confirmCallback: () {
          complete.complete(StepResultWaiting(stepId));
          if (Platform.isIOS) {
            OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
            settings.bluetooth();
          } else {
            AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
          }
        });
    return complete.future;
  }

  Future<StepResult> showAuthorizedDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCommonDialog(
        content: 'text_bt__request_permission_grant_tips'.tr(),
        contentAlign: TextAlign.center,
        cancelContent: 'cancel'.tr(),
        cancelCallback: () {
          complete.complete(chain.proceed(event.fail(stepId), success: false));
        },
        confirmContent: 'text_goto_open'.tr(),
        confirmCallback: () {
          complete.complete(StepResultWaiting(stepId));
          OpenSettingsPlusIOS settings = const OpenSettingsPlusIOS();
          settings.appSettings();
          enterCount -= 1;
        });
    return complete.future;
  }
}
