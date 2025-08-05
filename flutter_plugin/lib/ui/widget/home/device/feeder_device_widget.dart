import 'package:auto_size_text/auto_size_text.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/widget/dm_special_button.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/ui/widget/home/home_feeder_popup.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class FeederDeviceWidget extends BaseDeviceWidget {
  final Function(int weightValue)? leftButtonClick;

  FeederDeviceWidget({
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
  FeederDeviceWidgetState createState() => FeederDeviceWidgetState();
}

class FeederDeviceWidgetState extends BaseDeviceWidgetState {
  final GlobalKey keyEating = GlobalKey();
  final GlobalKey keyLogger = GlobalKey();

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    return Pair(
      ActionBtnResourceModel(
        normalImage: 'ic_home_btn_feder_add',
        activeImage: 'ic_home_btn_feder_add',
        disableImage: 'ic_home_btn_feder_add_disable',
        normalText: 'feeder_immediately'.tr(),
        activeText: 'feeder_immediately'.tr(),
        disableText: 'feeder_immediately'.tr(),
      ),
      ActionBtnResourceModel(
        normalImage: 'ic_home_btn_feder_loger',
        activeImage: 'ic_home_btn_feder_loger',
        disableImage: 'ic_home_btn_feder_loger_disable',
        normalText: 'text_food_plan'.tr(),
        activeText: 'text_food_plan'.tr(),
        disableText: 'text_food_plan'.tr(),
      ),
    );
  }

  @override
  Pair<GlobalKey, GlobalKey> provideButtonKey() {
    return Pair(keyEating, keyLogger);
  }

  @override
  Pair<ButtonState, ButtonState> provideButtonState() {
    FeederDeviceModel feederDevice = widget.currentDevice as FeederDeviceModel;
    if (widget.currentDevice.isOnline()) {
      if (feederDevice.latestStatus == 4 &&
          ((feederDevice.feederErrorCode ?? 0) & 4) == 4) {
        //缺粮状态，加粮按你置灰
        return Pair(ButtonState.disable, ButtonState.active);
      }
      return Pair(ButtonState.active, ButtonState.active);
    } else {
      return Pair(ButtonState.disable, ButtonState.disable);
    }
  }

  @override
  Widget buildDeviceStatus(StyleModel style, ResourceModel resource, bool rtl) {
    var statusPair = parseStatus();
    if (widget.currentDevice.latestStatus == 1) {
      String deviceStatus = 'feeder_grain_bowl'.tr(args: [
        '${(widget.currentDevice as FeederDeviceModel).feederRemaindWeight ?? 0}g'
      ]);
      statusPair = Pair(statusPair.first, deviceStatus);
    } else if (widget.currentDevice.latestStatus == 2) {
      String deviceStatus = 'feeder_out_grain'.tr();
      statusPair = Pair(statusPair.first, deviceStatus);
    } else if (widget.currentDevice.latestStatus == 4) {
      String deviceStatus = 'feeder_out_grain_error'.tr();
      int feederErrorCode =
          (widget.currentDevice as FeederDeviceModel).feederErrorCode ?? 0;

      if ((feederErrorCode & 1) == 1) {
        deviceStatus = 'feeder_out_grain_error'.tr();
      } else if ((feederErrorCode & 2) == 2) {
        deviceStatus = 'feeder_block_grain'.tr();
      } else if ((feederErrorCode & 4) == 4) {
        deviceStatus = 'feeder_grain_shortage'.tr();
      } else if ((feederErrorCode & 8) == 8) {
        deviceStatus = 'feeder_low_battery'.tr();
      } else if ((feederErrorCode & 16) == 16) {
        deviceStatus = 'feeder_excedingly'.tr();
      }
      statusPair = Pair(statusPair.first, deviceStatus);
    }

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
          child: AutoSizeText(
            statusPair.second,
            maxLines: 1,
            maxFontSize: 14,
            stepGranularity: 1,
            minFontSize: 8,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: style.textSecond),
          ),
        ),
        Visibility(
          visible: statusPair.first,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Semantics(
              label: 'text_device_offline'.tr(),
              child: Image.asset(
                resource.getResource('ic_home_offline'),
                width: 16,
                height: 16,
              ).withDynamic(),
            ),
          ).onClick(
            () {
              widget.offlineTipClick.call();
            },
          ),
        ),
      ],
    );
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
              if (widget is FeederDeviceWidget) {
                var self = widget as FeederDeviceWidget;
                self.leftButtonClick?.call(selectValue);
              }
            },
            dismissCallback: () => SmartDialog.dismiss(),
          );
        },
        onDismiss: () {});
  }

  @override
  Widget buildBottomContent(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    bool online = widget.currentDevice.isOnline();
    var keyPari = provideButtonKey();
    var btnRes = provideBtnRes();
    var btnState = provideButtonState();

    return Expanded(
        flex: 198,
        child: LayoutBuilder(builder: (context, constraints) {
          // 比例
          final ratio = (MediaQuery.of(context).size.width) / 390;
          final enterWidth = 154 * ratio;
          final cleanWidth = constraints.maxWidth - 56 - enterWidth;
          final cleanHeight = 70 * ratio;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(0xFF955E30).withOpacity(0.16), // 阴影颜色
                        blurRadius: 12, // 阴影模糊半径
                        offset: const Offset(6, 6), // 阴影偏移量，x方向为6，y方向为6
                      ),
                    ],
                  ),
                  child: Container(
                    width: enterWidth,
                    height: enterWidth,
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(
                              resource.getResource('ic_new_vacuum_enter_bg')),
                          fit: BoxFit.fitWidth,
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset(
                          resource.getResource('ic_new_vaccum_logo'),
                          width: 42,
                          height: 42,
                          color: style.textMainWhite,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AutoSizeText(
                                'text_enter_plugin'.tr(),
                                minFontSize: 14,
                                maxFontSize: 24,
                                stepGranularity: 1,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: style.textMainWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Image.asset(
                                resource.getResource('ic_arrow_right_small'),
                                width: 11,
                                height: 18,
                                color: style.textMainWhite,
                              ).flipWithRTL(context),
                            )
                          ],
                        )
                      ],
                    ).flipWithRTL(context),
                  ).flipWithRTL(context).onClick(() {
                    LogModule().eventReport(5, 5,
                        did: widget.currentDevice.did,
                        model: widget.currentDevice.model);
                    widget.enterPluginClick.call();
                  }),
                ),
                const SizedBox(width: 16),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  DMSpecialButton.third(
                    key: keyPari.first,
                    backgroundImage: AssetImage(
                        resource.getResource('ic_new_vacuum_start_bg')),
                    height: cleanHeight,
                    width: cleanWidth,
                    actionBtnRes: btnRes.first,
                    state: btnState.first,
                    textColor: style.homeCleanTextColor,
                    disableTextColor: style.homeCleanTextDisableColor,
                    borderRadius: 8,
                    fontsize: 14,
                    fontWidget: FontWeight.w600,
                    padding: const EdgeInsets.all(12),
                    onClickCallback: (buttonState) {
                      LogModule().eventReport(5, 7,
                          int1: widget.currentDevice.latestStatus,
                          did: widget.currentDevice.did,
                          model: widget.currentDevice.model);
                      if (buttonState == ButtonState.active && online) {
                        showEatingDialogOperate(
                            widget.currentDevice as FeederDeviceModel);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  DMSpecialButton.third(
                    key: keyPari.second,
                    backgroundImage: AssetImage(
                        resource.getResource('ic_new_vacuum_charge_bg')),
                    height: cleanHeight,
                    width: cleanWidth,
                    actionBtnRes: btnRes.second,
                    state: btnState.second,
                    textColor: style.homeCleanTextColor,
                    disableTextColor: style.homeCleanTextDisableColor,
                    borderRadius: 8,
                    fontsize: 14,
                    fontWidget: FontWeight.w600,
                    padding: const EdgeInsets.all(12),
                    onClickCallback: (context) {
                      LogModule().eventReport(5, 8,
                          int1: widget.currentDevice.latestStatus,
                          did: widget.currentDevice.did,
                          model: widget.currentDevice.model);
                      if (online) {
                        widget.rightActionClick?.call(btnState.second);
                      } else {
                        widget.messgaeToast.call('text_device_offline'.tr());
                      }
                    },
                  )
                ]),
              ],
            ),
          );
        }));
  }
}
