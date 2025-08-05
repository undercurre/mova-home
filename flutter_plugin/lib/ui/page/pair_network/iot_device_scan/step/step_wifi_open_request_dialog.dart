import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/basic_permission_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:wifi_iot/wifi_iot.dart';

class StepWifiOpenRequestDialog extends BasicPermissionStep {
  StepWifiOpenRequestDialog(
      {super.stepId = StepId.STEP_WIFI_OPEN_REQUEST_DIALOG,
      super.isMustBe = true,
      super.isOnceAgain = false,
      super.dependenceStepIds = const [StepId.STEP_WIFI_PERMISSION_REQUEST_DIALOG]});

  @override
  Future<StepResult> next(CommonStepChain chain, StepEvent event) async {
    if (Platform.isIOS) {
      return chain.proceed(event.success(stepId), next: true);
    }
    enterCount++;

    final isEnabled = await WiFiForIoTPlugin.isEnabled();
    if (isEnabled) {
      SmartDialog.dismiss(tag: 'scanning_wifi_close');
      return chain.proceed(event.success(stepId), next: true);
    } else if (enterCount <= 1) {
      return showOpenWifiDialog(chain, event);
    } else {
      /// 弹过弹框，再次进来，还未开启，直接跳过
      return chain.proceed(event.fail(stepId),
          success: false, next: true, isDependence: true);
    }
  }

  Future<StepResult> showOpenWifiDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCommonDialog(
        tag: 'scanning_wifi_close',
        content: 'scanning_wifi_close'.tr(),
        contentAlign: TextAlign.center,
        confirmContent: 'text_goto_open'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () {
          // doNothing
          complete.complete(chain.proceed(event.fail(stepId),
              success: false, next: true, isDependence: true));
        },
        confirmCallback: () {
          complete.complete(StepResultWaiting(stepId));
          AppSettings.openAppSettings(
              type: Platform.isAndroid
                  ? AppSettingsType.wifi
                  : AppSettingsType.settings);
        });
    return complete.future;
  }
}
