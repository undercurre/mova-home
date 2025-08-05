// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/home/device_guide/hold_common_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/device/hold_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';

class HoldCommonDeviceWidget extends HoldDeviceWidget {
  HoldCommonDeviceWidget(
      {super.key,
      required super.currentDevice,
      required super.leftActionClick,
      required super.rightActionClick,
      required super.enterPluginClick,
      required super.offlineTipClick,
      required super.messgaeToast,
      super.nextGuideCallback});

  @override
  HoldCommonDeviceWidgetState createState() => HoldCommonDeviceWidgetState();
}

class HoldCommonDeviceWidgetState extends HoldDeviceWidgetState {
  @override
  Pair<ButtonState, ButtonState> provideButtonState() {
    if (widget.currentDevice.isOnline()) {
      CommonBtnProtolModel? btnProtool = widget.currentDevice.getBtnProtol();
      if (btnProtool != null) {
        var leftBtnState = ButtonState.none;
        var rightBtnState = ButtonState.none;
        if (btnProtool.leftStatus == 0) {
          leftBtnState = ButtonState.none;
        } else if (btnProtool.leftStatus == 1) {
          leftBtnState = ButtonState.active;
        } else if (btnProtool.leftStatus == 2) {
          leftBtnState = ButtonState.disable;
        }
        if (btnProtool.rightStatus == 0) {
          rightBtnState = ButtonState.none;
        } else if (btnProtool.rightStatus == 1) {
          rightBtnState = ButtonState.active;
        } else if (btnProtool.rightStatus == 2) {
          rightBtnState = ButtonState.disable;
        }
        return Pair(leftBtnState, rightBtnState);
      } else {
        super.provideButtonState();
      }
    }
    return super.provideButtonState();
  }

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    CommonBtnProtolModel? btnProtool = widget.currentDevice.getBtnProtol();
    if (btnProtool != null) {
      var leftRes = getButtonResourceWithValue(
          btnProtool.leftWorkMode, btnProtool.leftStatus);
      var rightRes = getButtonResourceWithValue(
          btnProtool.rightWorkMode, btnProtool.rightStatus);

      return Pair(leftRes, rightRes);
    } else {
      return super.provideBtnRes();
    }
  }

  ActionBtnResourceModel getButtonResourceWithValue(
    int workMode,
    int buttonStatus,
  ) {
    ActionBtnResourceModel buttonRes;

    switch (workMode) {
      case 0:
        buttonRes = ActionBtnResourceModel(
          normalImage: 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: 'wash_text_drying'.tr(),
          activeText: 'wash_text_drying_stop'.tr(),
          disableText: 'wash_text_drying'.tr(),
        );
        break;
      case 1:
        buttonRes = ActionBtnResourceModel(
          normalImage: buttonStatus == 3
              ? 'ic_home_btn_hold_continue'
              : 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: buttonStatus == 3
              ? 'wash_text_continue_cleaning'.tr()
              : 'wash_text_self_cleaning_start'.tr(),
          activeText: 'wash_text_over_cleaning'.tr(),
          disableText: 'wash_text_self_cleaning_start'.tr(),
        );
        break;
      case 2:
        buttonRes = ActionBtnResourceModel(
          normalImage: 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: 'wash_text_hot_water_cleaning'.tr(),
          activeText: 'wash_text_over_cleaning'.tr(),
          disableText: 'wash_text_hot_water_cleaning'.tr(),
        );
        break;
      case 3:
        buttonRes = ActionBtnResourceModel(
          normalImage: 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: 'wash_text_hot_deep_cleaning'.tr(),
          activeText: 'wash_text_over_cleaning'.tr(),
          disableText: 'wash_text_hot_deep_cleaning'.tr(),
        );
        break;
      case 4:
        buttonRes = ActionBtnResourceModel(
          normalImage: 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: 'wash_text_mild_soka_cleaning'.tr(),
          activeText: 'wash_text_over_cleaning'.tr(),
          disableText: 'wash_text_mild_soka_cleaning'.tr(),
        );
        break;
      case 5:
        buttonRes = ActionBtnResourceModel(
          normalImage: buttonStatus == 3
              ? 'ic_home_btn_hold_continue'
              : 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: buttonStatus == 3
              ? 'wash_text_continue_cleaning'.tr()
              : 'wash_text_hot_deep_cleaning'.tr(),
          activeText: 'wash_text_over_cleaning'.tr(),
          disableText: 'wash_text_hot_deep_cleaning'.tr(),
        );
        break;
      case 6:
        buttonRes = ActionBtnResourceModel(
          normalImage: buttonStatus == 3
              ? 'ic_home_btn_hold_continue'
              : 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: buttonStatus == 3
              ? 'wash_text_continue_cleaning'.tr()
              : 'wash_text_smart_cleaning'.tr(),
          activeText: 'wash_text_over_cleaning'.tr(),
          disableText: 'wash_text_smart_cleaning'.tr(),
        );
        break;
      default:
        buttonRes = ActionBtnResourceModel(
          normalImage: 'ic_home_btn_hold_clean',
          activeImage: 'ic_home_btn_hold_stop',
          disableImage: 'ic_home_btn_hold_clean_disable',
          normalText: 'wash_text_drying'.tr(),
          activeText: 'wash_text_drying_stop'.tr(),
          disableText: 'wash_text_drying'.tr(),
        );
        break;
    }

    return buttonRes;
  }

  @override
  Future<void> showDeviceGuide() async {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    Offset cleanOffset = queryWidgetLocation(keyClean).first;
    Size cleanSize = queryWidgetLocation(keyClean).second;
    HoldCommonDeviceGuide(
            btnProtool: widget.currentDevice.commonBtnProtol,
            holdActionType:
                (widget.currentDevice as HoldDeviceModel).holdActionType(),
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
