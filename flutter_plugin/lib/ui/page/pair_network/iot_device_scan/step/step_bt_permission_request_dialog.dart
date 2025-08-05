import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/basic_permission_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_status.dart';
import 'package:permission_handler/permission_handler.dart';

class StepBtPermissionRequestDialog extends BasicPermissionStep {
  StepBtPermissionRequestDialog({
    super.stepId = StepId.STEP_BT_PERMISSION_REQUEST_DIALOG,
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

    /// fix: 从失败再次进来，直接去设置，华为手机比较辣鸡,选了拒绝，shouldShowRequestRationale不会true
    if (event.resultStatus[stepId] == StepResultStatus.failed) {
      return showGotoSettingDialog(chain, event);
    }
    var status = await bluetoothPermissionStatus();
    if (status == PermissionStatus.granted) {
      return chain.proceed(event.success(stepId), next: true);
    } else {
      if ((status == PermissionStatus.permanentlyDenied &&
              !_isGotoSetting /*status==PermissionStatus.permanentlyDenied  永远走不进来*/) ||
          _isNeedSetting) {
        _isNeedSetting = false;
        _isGotoSetting = true;
        return showGotoSettingDialog(chain, event);
      } else if (status == PermissionStatus.denied &&
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
  }

  /// 蓝牙权限是否已经授权
  /// 返回值，只会有两种 [PermissionStatus.granted] 和 [PermissionStatus.denied]
  Future<PermissionStatus> bluetoothPermissionStatus() async {
    if (Platform.isIOS) {
      return await Permission.bluetooth.status;
    }
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt >= 31) {
        var bluetoothConnect = await Permission.bluetoothConnect.isGranted;
        var bluetoothScan = await Permission.bluetoothScan.isGranted;
        if (bluetoothConnect && bluetoothScan) {
          return PermissionStatus.granted;
        }
        final shouldShowRequestRationale1 =
            await Permission.bluetoothConnect.shouldShowRequestRationale;
        final shouldShowRequestRationale2 =
            await Permission.bluetoothScan.shouldShowRequestRationale;
        if (shouldShowRequestRationale1 || shouldShowRequestRationale2) {
          return PermissionStatus.permanentlyDenied;
        }
      } else {
        var bluetooth = await Permission.bluetooth.isGranted;
        var locationWhenInUse = await Permission.locationWhenInUse.isGranted;
        if (bluetooth && locationWhenInUse) {
          return PermissionStatus.granted;
        }
        final shouldShowRequestRationale =
            await Permission.locationWhenInUse.shouldShowRequestRationale;
        if (shouldShowRequestRationale) {
          return PermissionStatus.permanentlyDenied;
        }
      }
    }
    return PermissionStatus.denied;
  }

  Future<StepResult> showGotoSettingDialog(
      CommonStepChain chain, StepEvent event) {
    var complete = Completer<StepResult>();
    showCommonDialog(
        content: 'text_scan_ble_tips'.tr(),
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
        content: Platform.isAndroid
            ? 'text_scan_ble_tips'.tr()
            : 'text_bt__request_permission_grant_tips'.tr(),
        confirmContent: 'next'.tr(),
        cancelContent: 'cancel'.tr(),
        cancelCallback: () async {
          var status = await Permission.locationWhenInUse.status;
          complete.complete(chain.proceed(event,
              next: true,
              success: status == PermissionStatus.granted,
              isDependence: true));
        },
        confirmCallback: () async {
          if (Platform.isIOS) {
            final permissionStatus = await Permission.bluetooth.request();
            complete.complete(
                handlePermissionResult(chain, event, permissionStatus));
          }
          if (Platform.isAndroid) {
            final androidInfo = await DeviceInfoPlugin().androidInfo;
            final sdkInt = androidInfo.version.sdkInt;
            if (sdkInt >= 31) {
              final ret = await [
                Permission.bluetoothConnect,
                Permission.bluetoothScan,
                Permission.bluetooth
              ].request();
              final PermissionStatus permissionStatus;
              if (ret[Permission.bluetoothConnect] ==
                      PermissionStatus.granted &&
                  ret[Permission.bluetoothScan] == PermissionStatus.granted) {
                permissionStatus = PermissionStatus.granted;
              } else if (ret[Permission.bluetoothConnect] ==
                      PermissionStatus.permanentlyDenied ||
                  ret[Permission.bluetoothScan] ==
                      PermissionStatus.permanentlyDenied) {
                permissionStatus = PermissionStatus.permanentlyDenied;
              } else {
                permissionStatus = PermissionStatus.denied;
              }
              complete.complete(
                  handlePermissionResult(chain, event, permissionStatus));
            } else {
              final ret = await [
                Permission.bluetooth,
                Permission.locationWhenInUse
              ].request();
              final PermissionStatus permissionStatus;
              if (ret[Permission.locationWhenInUse] ==
                  PermissionStatus.granted) {
                permissionStatus = PermissionStatus.granted;
              } else if (ret[Permission.locationWhenInUse] ==
                  PermissionStatus.permanentlyDenied) {
                permissionStatus = PermissionStatus.permanentlyDenied;
              } else {
                permissionStatus = PermissionStatus.denied;
              }
              complete.complete(
                  handlePermissionResult(chain, event, permissionStatus));
            }
          }
        });
    return complete.future;
  }

  Future<StepResult> handlePermissionResult(CommonStepChain chain,
      StepEvent event, PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.granted) {
      return chain.proceed(event.success(stepId), next: true);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _isNeedSetting = true;
      return next(chain, event.fail(stepId));
    } else {
      if (isOnceAgain) {
        return next(chain, event.fail(stepId));
      } else {
        return chain.proceed(event.fail(stepId),
            success: false, next: true, isDependence: true);
      }
    }
  }
}
