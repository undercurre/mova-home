import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/basic_permission_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:location/location.dart';

class StepWifiLocationServiceDialog extends BasicPermissionStep {
  StepWifiLocationServiceDialog({
    super.stepId = StepId.STEP_WIFI_LOCATION_SERVICE_REQUEST_DIALOG,
    super.isMustBe = true,
    super.isOnceAgain = true,
    super.dependenceStepIds = const [],
  });

  @override
  Future<StepResult> next(CommonStepChain chain, StepEvent event) async {
    enterCount++;
    if (Platform.isIOS) {
      return chain.proceed(event.success(stepId),
          next: true, isDependence: true);
    } else if (Platform.isAndroid) {
      final serviceEnabled = await Location.instance.serviceEnabled();
      if (!serviceEnabled) {
        return showGotoSettingDialog(chain, event);
      } else {
        return chain.proceed(event.success(stepId),
            next: true, isDependence: true);
      }
    }
    return chain.proceed(event.success(stepId), next: true, isDependence: true);
  }

  Future<StepResult> showGotoSettingDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCustomCommonDialog(
        showLogo: true,
        tag: 'text_open_wifi_tips',
        content: 'text_open_wifi_tips'.tr(),
        contentAlign: TextAlign.center,
        confirmContent: 'next'.tr(),
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
                  ? AppSettingsType.location
                  : AppSettingsType.settings);
        });
    return complete.future;
  }
}
