import 'dart:math';

// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/ui/page/home/device_guide/mower_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';

class MowerDeviceWidget extends BaseDeviceWidget {
  MowerDeviceWidget(
      {super.key,
      required super.leftActionClick,
      required super.rightActionClick,
      required super.currentDevice,
      required super.enterPluginClick,
      required super.offlineTipClick,
      required super.nextGuideCallback,
      required super.messgaeToast});

  @override
  MowerDeviceWidgetState createState() => MowerDeviceWidgetState();
}

class MowerDeviceWidgetState extends BaseDeviceWidgetState {
  final GlobalKey keyClean = GlobalKey();
  final GlobalKey keyCharge = GlobalKey();

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    int latestStatus = widget.currentDevice.latestStatus;
    bool leftPause = latestStatus == 3 || latestStatus == 4;
    return Pair(
      ActionBtnResourceModel(
        normalImage: 'ic_home_new_btn_clean',
        activeImage:
           'ic_home_new_btn_clean_pause',
        disableImage: 'ic_home_new_btn_clean_disable',
        normalText:
            leftPause ? 'text_mow_continue'.tr() : 'text_mow_start'.tr(),
        activeText: 'pause'.tr(),
        disableText: 'text_mow_start'.tr(),
      ),
      ActionBtnResourceModel(
        normalImage: 'ic_home_new_btn_charge',
        activeImage: 'ic_home_new_btn_charge_pause',
        disableImage: 'ic_home_new_btn_charge_disable',
        normalText: 'text_mow_back'.tr(),
        activeText:
             'text_stop_back'.tr(),
        disableText: 'text_mow_back'.tr(),
      ),
    );
  }

  @override
  Pair<ButtonState, ButtonState> provideButtonState() {
    int latestStatus = widget.currentDevice.latestStatus;
    if (widget.currentDevice.isOnline()) {
      if (latestStatus == 1) {
        return Pair(ButtonState.active, ButtonState.none);
      } else if (latestStatus == 5) {
        return Pair(ButtonState.none, ButtonState.active);
      }
    } else {
      return Pair(ButtonState.disable, ButtonState.disable);
    }
    return Pair(ButtonState.none, ButtonState.none);
  }

  @override
  Pair<GlobalKey, GlobalKey> provideButtonKey() {
    return Pair(keyClean, keyCharge);
  }

  @override
  Future<void> showDeviceGuide() async {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    Offset cleanOffset = queryWidgetLocation(keyClean).first;
    Size cleanSize = queryWidgetLocation(keyClean).second;
    MowerDeviceGuide(
            rtl: rtl,
            skipCallback: ({required deviceType, holdActionType}) {
              widget.nextGuideCallback?.call();
            },
            nextCallback: ({required step, nextStepSendArgument}) {
              switch (step) {
                case GuideStep.step3:
                  Offset chargeOffset = queryWidgetLocation(keyCharge).first;
                  Size chargeSize = queryWidgetLocation(keyCharge).second;
                  nextStepSendArgument!
                      .call(step: step, offset: chargeOffset, size: chargeSize);
                  break;
                default:
              }
            })
        .showStep(
            guideStep: GuideStep.step2, offset: cleanOffset, size: cleanSize);
  }
}
