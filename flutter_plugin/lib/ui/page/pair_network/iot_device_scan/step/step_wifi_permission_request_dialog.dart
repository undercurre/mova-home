import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/basic_permission_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_status.dart';
import 'package:location/location.dart' as iosLocation;
import 'package:location/location_platform_interface/location_platform_interface.dart'
    as iosLocation;
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;

class StepWifiPermissionRequestDialog extends BasicPermissionStep {
  StepWifiPermissionRequestDialog({
    super.stepId = StepId.STEP_WIFI_PERMISSION_REQUEST_DIALOG,
    super.isMustBe = true,
    super.isOnceAgain = false,
    super.dependenceStepIds = const [],
  });

  var _isGotoSetting = false;
  var _isNeedSetting = false;
  var _requestCount = 0;

  final iosLocation.Location location = iosLocation.Location();
  iosLocation.PermissionStatus? _permissionGranted;

  @override
  Future<StepResult> next(CommonStepChain chain, StepEvent event) async {
    enterCount++;

    /// Android location 库不好用
    if (Platform.isAndroid) {
      /// fix: 从失败再次进来，直接去设置，华为手机比较辣鸡,选了拒绝，shouldShowRequestRationale不会true
      if (event.resultStatus[stepId] == StepResultStatus.failed &&
          (_requestCount <= 0 || (isOnceAgain && _requestCount <= 1))) {
        return showGotoSettingDialog(chain, event);
      }
      final status =
          await permissionHandler.Permission.locationWhenInUse.status;
      final shouldShowRequestRationale = await permissionHandler
          .Permission.locationWhenInUse.shouldShowRequestRationale;
      if (status == permissionHandler.PermissionStatus.granted) {
        return chain.proceed(event.success(stepId), next: true);
      } else {
        /// 永久拒绝或者拒绝并且勾选了不再询问
        final isPermanentlyDenied =
            status == permissionHandler.PermissionStatus.permanentlyDenied ||
                (status == permissionHandler.PermissionStatus.denied &&
                    shouldShowRequestRationale);
        if ((isPermanentlyDenied &&
                !_isGotoSetting /*status==PermissionStatus.permanentlyDenied  永远走不进来*/) ||
            _isNeedSetting) {
          _isNeedSetting = false;
          _isGotoSetting = true;
          return showRequestAndGotoSettingDialog(chain, event);
        } else if (status == permissionHandler.PermissionStatus.denied &&
            (_requestCount <= 0 ||
                (isOnceAgain && _requestCount <= 1 /*onceAgain 增加一次请求机会*/))) {
          _requestCount++;
          return showRequestDialog(chain, event);
        } else {
          /// 其他情况，直接跳过
          return chain.proceed(event.fail(stepId),
              success: false, next: true, isDependence: true);
        }
      }
    } else if (Platform.isIOS) {
      final enable = await location.serviceEnabled();
      if (!enable) {
        return showGotoSettingDialog(chain, event);
      }
      final permissionGrantedResult = await location.hasPermission();
      _permissionGranted = permissionGrantedResult;
      if (_permissionGranted == iosLocation.PermissionStatus.granted) {
        return chain.proceed(event.success(stepId), next: true);
      } else {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == iosLocation.PermissionStatus.grantedLimited) {
          _permissionGranted = await location.requestFullAccuracyPermission(
              purposeKey: Platform.isIOS ? 'WantsToGetWiFiSSID' : '');
          if (_permissionGranted == iosLocation.PermissionStatus.granted) {
            return chain.proceed(event.success(stepId), next: true);
          } else {
            return chain.proceed(event.fail(stepId),
                success: false, next: true, isDependence: true);
          }
        } else if (_permissionGranted == iosLocation.PermissionStatus.granted) {
          return chain.proceed(event.success(stepId), next: true);
        } else {
          return showGotoSettingDialog(chain, event);
        }
      }
    } else {
      /// 其他平台不管
      return chain.proceed(event.fail(stepId),
          success: true, next: true, isDependence: true);
    }
  }

  Future<StepResult> showGotoSettingDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    var permisson = 'common_permission_location'.tr();
    String content = Platform.isAndroid
        ? 'common_permission_fail_3'.tr(args: [permisson])
        : 'authorize_location_tip'.tr();
    showCommonDialog(
        tag: 'network_config_error_location',
        content: content,
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

  /// 仅Android 使用
  @override
  Future<StepResult> showRequestAndGotoSettingDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCustomCommonDialog(
        showLogo: true,
        tag: 'Toast_SystemServicePermission_Location',
        content: 'Toast_SystemServicePermission_Location'.tr(),
        confirmContent: 'next'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () async {
          // doNothing
          complete.complete(chain.proceed(event.fail(stepId),
              success: false, next: true, isDependence: true));
        },
        confirmCallback: () async {
          complete.complete(showGotoSettingDialog(chain, event));
        });
    return complete.future;
  }

  /// 仅Android 使用
  Future<StepResult> showRequestDialog(CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCustomCommonDialog(
        showLogo: true,
        tag: 'Toast_SystemServicePermission_Location',
        content: 'Toast_SystemServicePermission_Location'.tr(),
        confirmContent: 'next'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () async {
          var status =
              await permissionHandler.Permission.locationWhenInUse.status;
          complete.complete(chain.proceed(
              status == permissionHandler.PermissionStatus.granted
                  ? event.success(stepId)
                  : event.fail(stepId),
              next: true,
              success: status == permissionHandler.PermissionStatus.granted,
              isDependence: true));
        },
        confirmCallback: () async {
          var permissionStatus =
              await permissionHandler.Permission.locationWhenInUse.request();
          if (permissionStatus == permissionHandler.PermissionStatus.granted) {
            // 判断精准定位权限是否授权,否则需要再次请求
            var locationWhenInUse =
                await permissionHandler.Permission.locationWhenInUse.status;
            if (locationWhenInUse ==
                permissionHandler.PermissionStatus.granted) {
              complete
                  .complete(chain.proceed(event.success(stepId), next: true));
            } else {
              // 精准权限未授权
              complete.complete(next(chain, event.fail(stepId)));
            }
          } else if (permissionStatus ==
              permissionHandler.PermissionStatus.permanentlyDenied) {
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
}
