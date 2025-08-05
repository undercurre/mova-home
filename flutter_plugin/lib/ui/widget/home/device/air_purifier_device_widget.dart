import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/home/device_guide/vacuum_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/utils/rtl_util.dart';

class AirPurifierDeviceWidget extends BaseDeviceWidget {
  AirPurifierDeviceWidget(
      {super.key,
      required super.currentDevice,
      super.leftActionClick,
      super.rightActionClick,
      required super.enterPluginClick,
      required super.offlineTipClick,
      required super.messgaeToast,
      super.nextGuideCallback});

  @override
  AirPurifierDeviceWidgetState createState() => AirPurifierDeviceWidgetState();
}

class AirPurifierDeviceWidgetState extends BaseDeviceWidgetState {
  final GlobalKey keyClean = GlobalKey();
  final GlobalKey keyCharge = GlobalKey();
  final GlobalKey keyFastCmd = GlobalKey();

  @override
  Future<void> showDeviceGuide() async {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    Offset cleanOffset = queryWidgetLocation(keyClean).first;
    Size cleanSize = queryWidgetLocation(keyClean).second;
    VacuumDeviceGuide(
            rtl: rtl,
            supportFastCommand: false,
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
                  Offset fastCmdOffset = queryWidgetLocation(keyFastCmd).first;
                  nextStepSendArgument!.call(step: step, offset: fastCmdOffset);
                  break;
                default:
              }
            })
        .showStep(
            guideStep: GuideStep.step2, offset: cleanOffset, size: cleanSize);
  }

  @override
  Widget buildBattery(StyleModel style, ResourceModel resource, bool rtl) {
    return widget.currentDevice.master
        ? const Text(
            '',
            style: TextStyle(fontSize: 14),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AutoSizeText(
                    minFontSize: 8,
                    maxLines: 1,
                    maxFontSize: 14,
                    stepGranularity: 1,
                    overflow: TextOverflow.ellipsis,
                    'message_setting_share'.tr(),
                    style:  TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: style.blueShare),
                  ),
                )
              ],
            ),
          );
  }

  @override
  Widget buildBottomContent(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    return Expanded(
      flex: 198,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: DMCommonClickButton(
              height: 50,
              width: double.infinity,
              text: 'enter_device'.tr(),
              fontsize: 16,
              fontWidget: FontWeight.w600,
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.largeGold,
              backgroundGradient: style.brandColorGradient,
              borderRadius: style.circular8,
              onClickCallback: () async {
                LogModule().eventReport(5, 5,
                    did: widget.currentDevice.did,
                    model: widget.currentDevice.model);
                widget.enterPluginClick.call();
              },
            ),
          )
        ],
      ),
    );
  }
}
