import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter_plugin/ui/page/home/device_guide/hold_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/ui/widget/home/home_new_battery.dart';
import 'package:flutter_plugin/utils/hold_common_feature_data.dart';

class HoldDeviceWidget extends BaseDeviceWidget {
  HoldDeviceWidget(
      {super.key,
      required super.currentDevice,
      required super.leftActionClick,
      required super.rightActionClick,
      required super.enterPluginClick,
      required super.offlineTipClick,
      required super.messgaeToast,
      super.nextGuideCallback});

  @override
  HoldDeviceWidgetState createState() => HoldDeviceWidgetState();
}

class HoldDeviceWidgetState extends BaseDeviceWidgetState {
  final GlobalKey keyClean = GlobalKey();
  final GlobalKey keyCharge = GlobalKey();

  @override
  List<BatteryLevel> provideBatteryLevel() {
    return [
      BatteryLevel(0xff88D644, Pair(100, 20)),
      BatteryLevel(0xFFF44336, Pair(20, 0)),
      BatteryLevel(0x00000000, Pair(0, -100)),
    ];
  }

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    List<String> defaultTextStr = HoldCommonFeatureData.getBtnListStrByFeature(widget.currentDevice.deviceInfo?.feature);
    return Pair(
      ActionBtnResourceModel(
        normalImage: 'ic_home_btn_hold_clean',
        activeImage: 'ic_home_btn_hold_stop',
        disableImage: 'ic_home_btn_hold_clean_disable',
        normalText: defaultTextStr[0],
        activeText: 'wash_text_over_cleaning'.tr(),
        disableText: defaultTextStr[0],
      ),
      ActionBtnResourceModel(
        normalImage: 'ic_home_btn_hold_clean',
        activeImage: 'ic_home_btn_hold_stop',
        disableImage: 'ic_home_btn_hold_clean_disable',
        normalText: defaultTextStr[1],
        activeText: 'wash_text_over_cleaning'.tr(),
        disableText: defaultTextStr[1],
      ),
    );
  }

  @override
  Pair<ButtonState, ButtonState> provideButtonState() {
    if (widget.currentDevice.isOnline()) {
      int latestStatus = widget.currentDevice.latestStatus;
      if (latestStatus == 4 ||
          latestStatus == 7 ||
          latestStatus == 9 ||
          latestStatus == 15) {
        return Pair(ButtonState.none, ButtonState.none);
      }
      if ((widget.currentDevice as HoldDeviceModel).holdActionType() ==
          HoldActionType.cleanDry) {
        if (latestStatus == 5 ||
            latestStatus == 26 ||
            latestStatus == 27 ||
            latestStatus == 28) {
          return Pair(ButtonState.active, ButtonState.disable);
        } else if (latestStatus == 6 ||
            latestStatus == 23 ||
            latestStatus == 24 ||
            latestStatus == 25) {
          return Pair(ButtonState.disable, ButtonState.active);
        }
      } else if ((widget.currentDevice as HoldDeviceModel).holdActionType() ==
          HoldActionType.cleanDeepClean) {
        if (latestStatus == 26 || latestStatus == 32) {
          return Pair(ButtonState.active, ButtonState.disable);
        } else if (latestStatus == 27 || latestStatus == 33) {
          return Pair(ButtonState.disable, ButtonState.active);
        } else if (latestStatus == 30 || latestStatus == 31) {
          // 自清洁故障暂停
          return Pair(ButtonState.disable, ButtonState.disable);
        }
      } else {
        return Pair(ButtonState.none, ButtonState.none);
      }
      return Pair(ButtonState.disable, ButtonState.disable);
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
    HoldDeviceGuide(
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
