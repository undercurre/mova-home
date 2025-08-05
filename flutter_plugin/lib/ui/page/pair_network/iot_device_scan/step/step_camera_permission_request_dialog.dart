import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/basic_permission_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_status.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCameraPermissionRequestDialog extends BasicPermissionStep {
  StepCameraPermissionRequestDialog({
    super.stepId = StepId.STEP_CAMERA_PERMISSION_REQUEST_DIALOG,
    super.isMustBe = true,
    super.isOnceAgain = true,
    super.dependenceStepIds = const [],
  });

  var _isGotoSetting = false;
  var _isNeedSetting = false;
  var _requestCount = 0;

  @override
  Future<StepResult> next(CommonStepChain chain, StepEvent event) async {
    enterCount++;
    final status = await Permission.camera.status;
    final shouldShowRequestRationale =
        await Permission.camera.shouldShowRequestRationale;

    /// fix: 从失败再次进来，直接去设置，华为手机比较辣鸡,选了拒绝，shouldShowRequestRationale不会true
    if (event.resultStatus[stepId] == StepResultStatus.failed) {
      return showGotoSettingDialog(chain, event);
    }
    if (status == PermissionStatus.granted) {
      return chain.proceed(event.success(stepId), next: true);
    } else {
      /// 永久拒绝或者拒绝并且勾选了不再询问
      final isPermanentlyDenied =
          status == PermissionStatus.permanentlyDenied ||
              (status == PermissionStatus.denied && shouldShowRequestRationale);
      if ((isPermanentlyDenied &&
              !_isGotoSetting /*status==PermissionStatus.permanentlyDenied  永远走不进来*/) ||
          _isNeedSetting) {
        _isNeedSetting = false;
        _isGotoSetting = true;
        return showGotoSettingDialog(chain, event);
      } else if (status == PermissionStatus.denied &&
          (_requestCount <= 0 ||
              (isOnceAgain && _requestCount <= 1 /*onceAgain 增加一次请求机会*/))) {
        _requestCount++;
        if (Platform.isIOS) {
          return await requestCameraPermission(chain, event);
        } else {
          return showRequestDialog(chain, event);
        }
      } else {
        /// 其他情况，直接跳过
        return chain.proceed(event.fail(stepId),
            success: false, next: true, isDependence: true);
      }
    }
  }

  Future<StepResult> showGotoSettingDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCommonDialog(
        content: 'camera_permission_not_allow'.tr(),
        contentAlign: TextAlign.center,
        confirmContent: 'common_permission_goto'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () {
          // doNothing
          complete.complete(chain.proceed(event.fail(stepId),
              success: false, next: true, isDependence: true));
        },
        confirmCallback: () {
          complete.complete(StepResultWaiting(stepId));
          AppSettings.openAppSettings(type: AppSettingsType.settings);
        });
    return complete.future;
  }

  Future<StepResult> showRequestDialog(CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCustomCommonDialog(
        showLogo: true,
        content: 'Toast_SystemServicePermission_CameraPhoto'.tr(),
        contentAlign: TextAlign.left,
        confirmContent: 'next'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () async {
          var status = await Permission.camera.status;
          complete.complete(chain.proceed(event,
              next: true,
              success: status == PermissionStatus.granted,
              isDependence: true));
        },
        confirmCallback: () async {
          final permissionStatus = await Permission.camera.request();
          final shouldShowRequestRationale =
              await Permission.camera.shouldShowRequestRationale;

          if (permissionStatus == PermissionStatus.granted) {
            complete.complete(chain.proceed(event, next: true));
          } else if (permissionStatus == PermissionStatus.permanentlyDenied ||
              (permissionStatus == PermissionStatus.denied &&
                  shouldShowRequestRationale)) {
            _isNeedSetting = true;
            complete.complete(next(chain, event.fail(stepId)));
          } else {
            if (isOnceAgain) {
              complete.complete(next(chain, event.fail(stepId)));
            } else {
              complete.complete(chain.proceed(event.fail(stepId),
                  success: false, next: true, isDependence: true));
            }
          }
        });
    return complete.future;
  }

  Future<StepResult> requestCameraPermission(
      CommonStepChain chain, StepEvent event) async {
    var complete = Completer<StepResult>();
    final permissionStatus = await Permission.camera.request();
    final shouldShowRequestRationale =
        await Permission.camera.shouldShowRequestRationale;

    if (permissionStatus == PermissionStatus.granted) {
      complete.complete(chain.proceed(event, next: true));
    } else if (permissionStatus == PermissionStatus.permanentlyDenied ||
        (permissionStatus == PermissionStatus.denied &&
            shouldShowRequestRationale)) {
      _isNeedSetting = true;
      complete.complete(next(chain, event.fail(stepId)));
    } else {
      if (isOnceAgain) {
        complete.complete(next(chain, event.fail(stepId)));
      } else {
        complete.complete(chain.proceed(event.fail(stepId),
            success: false, next: true, isDependence: true));
      }
    }
    return complete.future;
  }
}
