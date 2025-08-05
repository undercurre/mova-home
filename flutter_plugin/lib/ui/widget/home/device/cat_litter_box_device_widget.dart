import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/ui/widget/home/home_feeder_popup.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

import '../../text_icon_baseline.dart';

class CatLitterBoxDeviceWidget extends BaseDeviceWidget {
  final Function(int weightValue)? leftButtonClick;

  CatLitterBoxDeviceWidget({
    super.key,
    required super.leftActionClick,
    required super.rightActionClick,
    required super.currentDevice,
    required super.enterPluginClick,
    required super.offlineTipClick,
    required super.nextGuideCallback,
    required super.messgaeToast,
    required this.leftButtonClick,
  });

  @override
  CatLitterBoxDeviceWidgetState createState() =>
      CatLitterBoxDeviceWidgetState();
}

class CatLitterBoxDeviceWidgetState extends BaseDeviceWidgetState {
  final GlobalKey keyEating = GlobalKey();
  final GlobalKey keyLogger = GlobalKey();

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    // mock
    // widget.currentDevice.latestStatus = 12;

    int latestStatus = widget.currentDevice.latestStatus;
    var leftBtnText = 'litterbox_clean_now'.tr();
    if (latestStatus == 1) {
      leftBtnText = 'litterbox_pause'.tr();
    } else if (latestStatus == 2) {
      leftBtnText = 'litterbox_resume'.tr();
    }

    return Pair(
      ActionBtnResourceModel(
        normalImage: 'ic_home_btn_litter_clean',
        activeImage: 'ic_home_btn_litter_clean',
        disableImage: 'ic_home_btn_litter_clean_disable',
        normalText: leftBtnText,
        activeText: leftBtnText,
        disableText: leftBtnText,
      ),
      ActionBtnResourceModel(
        normalImage: 'ic_home_btn_litter_box_data',
        activeImage: 'ic_home_btn_litter_box_data',
        disableImage: 'ic_home_btn_litter_box_data_disable',
        normalText: 'litterbox_data'.tr(),
        activeText: 'litterbox_data'.tr(),
        disableText: 'litterbox_data'.tr(),
      ),
    );
  }

  @override
  Pair<GlobalKey, GlobalKey> provideButtonKey() {
    return Pair(keyEating, keyLogger);
  }

  @override
  Pair<ButtonState, ButtonState> provideButtonState() {
    // mock
    // widget.currentDevice.latestStatus = 17;

    if (widget.currentDevice.isOnline()) {
      if (widget.currentDevice.latestStatus == 0 ||
          widget.currentDevice.latestStatus == 1 ||
          widget.currentDevice.latestStatus == 2 ||
          widget.currentDevice.latestStatus == 17) {
        return Pair(ButtonState.active, ButtonState.active);
      } else if (widget.currentDevice.latestStatus == 10 ||
          widget.currentDevice.latestStatus == 11 ||
          widget.currentDevice.latestStatus == 12 ||
          widget.currentDevice.latestStatus == 13 ||
          widget.currentDevice.latestStatus == 14 ||
          widget.currentDevice.latestStatus == 15 ||
          widget.currentDevice.latestStatus == 16) {
        return Pair(ButtonState.disable, ButtonState.active);
      }
      return Pair(ButtonState.active, ButtonState.active);
    } else {
      return Pair(ButtonState.disable, ButtonState.disable);
    }
  }

  @override
  Future<void> showDeviceGuide() async {}

  void showEatingDialogOperate(
    FeederDeviceModel? currentDevice,
  ) {
    SmartDialog.show(
        clickMaskDismiss: false,
        animationType: SmartAnimationType.fade,
        builder: (context) {
          return HomeFeederPopup(
            defaultWeight:
                (currentDevice as FeederDeviceModel).feederSegmentCount ?? 5,
            defaultIndex: 0,
            confirmCallback: (selectIndex, selectValue) {
              SmartDialog.dismiss();
              if (widget is CatLitterBoxDeviceWidget) {
                var self = widget as CatLitterBoxDeviceWidget;
                self.leftButtonClick?.call(selectValue);
              }
            },
            dismissCallback: () => SmartDialog.dismiss(),
          );
        },
        onDismiss: () {});
  }

  @override
  Widget buildTopContent(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    return ThemeWidget(builder: (context, style, resource) {
      double statusBarHeight = MediaQuery.of(context).padding.top;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              /* 导航头高度*/
              height: statusBarHeight,
              width: double.infinity,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      showMoreOperate(widget.currentDevice);
                    },
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: TextIconBaselineWidget(
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 2, left: 2, right: 2),
                          key: textIconBaselineKey,
                          text: widget.currentDevice.getShowName(),
                          style: TextStyle(
                              color: style.homeDeviceNameTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          icon: Image.asset(
                            resource.getResource('ic_home_device_name_edit'),
                          ).flipWithRTL(context),
                        )),
                  ),
                ),
                const SizedBox(
                  width: 120,
                  height: 5,
                )
              ],
            ),
            buildWorkingStatus(style, resource, rtl),
          ],
        ),
      );
    });
  }

  //  运行中：清理中、清空中、抚平中
  //  暂停中：清理暂停、清空暂停、抚平暂停
  Widget buildWorkingStatus(
      StyleModel style, ResourceModel resource, bool rtl) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
            visible: !widget.currentDevice.master,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: AutoSizeText(
                      minFontSize: 8,
                      maxLines: 1,
                      maxFontSize: 14,
                      stepGranularity: 1,
                      overflow: TextOverflow.ellipsis,
                      'message_setting_share'.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: style.blueShare),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 1,
                  height: 12,
                )
              ],
            )),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: AutoSizeText(
              minFontSize: 8,
              maxLines: 1,
              maxFontSize: 14,
              stepGranularity: 1,
              overflow: TextOverflow.ellipsis,
              (widget.currentDevice as LitterBoxDeviceModel).statusText(),
              style: TextStyle(fontSize: 14, color: style.textSecond),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 1,
          height: 12,
        )
      ],
    );
  }
}

extension LitterBoxErrorCode on LitterBoxDeviceModel {
  String statusText() {
    if (!online) {
      return 'device_offline'.tr();
    }
    // mock
    // latestStatus = 12;
    // 【0.待机】【1.清理中】【2.清理暂停】【3：清空中】 【4：清空暂停】【5：抚平中】【6：抚平暂停】【7：清理取消中】【8：清空取消中】【9：抚平取消中】【10.宠物如厕异常】【11.集便仓未装】【12.集便仓已满】【13.球仓未装配】【14.称重保护中】【15.电机堵转】【16.防夹保护中】【17.新风工作中】
    switch (latestStatus) {
      case 0:
        return 'litterbox_standby'.tr();
      case 1:
        return 'litterbox_cleaning'.tr();
      case 2:
        return 'litterbox_cleaning_pause'.tr();
      case 3:
        return 'litterbox_emptying'.tr();
      case 4:
        return 'litterbox_emptying_paused'.tr();
      case 5:
        return 'litterbox_smoothing'.tr();
      case 6:
        return 'litterbox_smoothing_paused'.tr();
      case 7:
        return 'litterbox_cleaning_canceling'.tr();
      case 8:
        return 'litterbox_emptying_canceling'.tr();
      case 9:
        return 'litterbox_smoothing_canceling'.tr();
      case 14:
        return 'litterbox_weighting_protected'.tr();
      case 17:
        return 'litterbox_fresh_air'.tr();
      default:
        return 'litterbox_device_error'.tr();
    // 11.集便仓未装,
    // 12.集便仓已满,
    // 13.球仓未装配,
    // 15.电机堵转,
    // 16.防夹保护中
    // 以上都显示 设备异常
    }
  }
}
