// ignore: depend_on_referenced_packages
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/ui/page/home/device_guide/vacuum_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/device/vacuum_base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';


class NewVacuumDeviceWidget extends VacuumBaseDeviceWidget {
  NewVacuumDeviceWidget(
      {super.key,
      required super.currentDevice,
      required super.leftActionClick,
      required super.rightActionClick,
      required super.enterPluginClick,
      required super.offlineTipClick,
      required super.messgaeToast,
      required super.monitorClick,
      required super.fastCommandClick,
      super.nextGuideCallback});

  @override
  VacuumDeviceWidgetState createState() => VacuumDeviceWidgetState();
}

class VacuumDeviceWidgetState extends VacuumBaseDeviceWidgetState
    with SingleTickerProviderStateMixin {

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    FastCommandModel? pinFastComman = getPinFastCommand();
    ActionBtnResourceModel leftModel;
    bool isCanStop =
        (widget.currentDevice as VacuumDeviceModel).isCanStopFastCMD();

    if (pinFastComman != null) {
      /* 快捷指令置顶状态*/
      leftModel = ActionBtnResourceModel(
        normalImage: 'ic_home_new_btn_clean',
        activeImage: 'ic_home_new_btn_clean_pause',
        disableImage: 'ic_home_new_btn_clean_disable',
        normalText: (isCanStop
            ? 'text_device_start'.tr()
            : utf8.decode(base64.decode(pinFastComman.name ?? ''))),
        activeText: 'pause'.tr(),
        disableText: 'text_global_clean'.tr(),
      );
    } else {
      /* 普通清洁任务*/
      leftModel = ActionBtnResourceModel(
        normalImage: 'ic_home_new_btn_clean',
        activeImage: 'ic_home_new_btn_clean_pause',
        disableImage: 'ic_home_new_btn_clean_disable',
        normalText:
            isCanStop ? 'text_device_start'.tr() : 'text_global_clean'.tr(),
        activeText: 'pause'.tr(),
        disableText: 'text_global_clean'.tr(),
      );
    }

    ActionBtnResourceModel rightModel = ActionBtnResourceModel(
      normalImage: 'ic_home_new_btn_charge',
      activeImage: 'ic_home_new_btn_charge_pause',
      disableImage: 'ic_home_new_btn_charge_disable',
      normalText: 'text_device_charge_start'.tr(),
      activeText: 'home_device_charge_pause'.tr(),
      disableText: 'text_device_charge_start'.tr(),
    );

    return Pair(leftModel, rightModel);
  }

  @override
  Pair<ButtonState, ButtonState> provideButtonState() {
    if (widget.currentDevice.isOnline()) {
      int latestStatus = widget.currentDevice.latestStatus;
      if ((widget.currentDevice as VacuumDeviceModel).isCanStopCleanTask()) {
        return Pair(ButtonState.active, ButtonState.none);
      } else if (latestStatus == 5) {
        return Pair(ButtonState.none, ButtonState.active);
      } else {
        return Pair(ButtonState.none, ButtonState.none);
      }
    } else {
      return Pair(ButtonState.disable, ButtonState.disable);
    }
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
    VacuumDeviceGuide(
            rtl: rtl,
            supportFastCommand: (widget.currentDevice as VacuumDeviceModel)
                .isSupportFastCommand(),
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
                case GuideStep.step4:
                  // Offset fastCmdOffset = queryWidgetLocation(keyFastCmd).first;
                  // nextStepSendArgument!.call(step: step, offset: fastCmdOffset);
                  break;
                default:
              }
            })
        .showStep(
            guideStep: GuideStep.step2, offset: cleanOffset, size: cleanSize);
  }

}
