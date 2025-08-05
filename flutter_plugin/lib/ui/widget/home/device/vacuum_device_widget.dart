import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/home/device_guide/vacuum_device_guide.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/base_device_guide_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/device/base_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class VacuumDeviceWidget extends BaseDeviceWidget {
  final VoidCallback? monitorClick;
  final VoidCallback? fastCommandClick;

  VacuumDeviceWidget(
      {super.key,
      required super.currentDevice,
      required super.leftActionClick,
      required super.rightActionClick,
      required super.enterPluginClick,
      required super.offlineTipClick,
      required super.messgaeToast,
      required this.monitorClick,
      required this.fastCommandClick,
      super.nextGuideCallback});

  @override
  VacuumDeviceWidgetState createState() => VacuumDeviceWidgetState();
}

class VacuumDeviceWidgetState extends BaseDeviceWidgetState {
  final GlobalKey keyClean = GlobalKey();
  final GlobalKey keyCharge = GlobalKey();
  final GlobalKey keyFastCmd = GlobalKey();
  final GlobalKey keyMonitor = GlobalKey();

  @override
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    return Pair(
        ActionBtnResourceModel(
          normalImage: 'ic_home_btn_clean',
          activeImage: 'ic_home_btn_clean_pause',
          disableImage: 'ic_home_btn_clean_disable',
        ),
        ActionBtnResourceModel(
          normalImage: 'ic_home_btn_charge',
          activeImage: 'ic_home_btn_charge_pause',
          disableImage: 'ic_home_btn_charge_disable',
        ));
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

  Widget _buildMonitor(StyleModel style, ResourceModel resource, bool rtl) {
    bool online = widget.currentDevice.isOnline();
    return Container(
      width: 42,
      height: 42,
      key: keyMonitor,
      decoration: BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 15,
              spreadRadius: 1.0)
        ],
      ),
      child: Semantics(
        label: online &&
                (widget.currentDevice.master ||
                    (widget.currentDevice as VacuumDeviceModel)
                        .getVideoPermission())
            ? 'view_live_video'.tr()
            : 'view_live_video'.tr() + 'device_offline'.tr(),
        child: Image.asset(
          width: 30,
          height: 24,
          online &&
                  (widget.currentDevice.master ||
                      (widget.currentDevice as VacuumDeviceModel)
                          .getVideoPermission())
              ? resource.getResource('ic_home_monitor')
              : resource.getResource('ic_home_monitor_offline'),
        ).withDynamic().onClick(() {
          LogModule().eventReport(5, 9,
              int1: widget.currentDevice.latestStatus,
              did: widget.currentDevice.did,
              model: widget.currentDevice.model);
          if (online) {
            if (widget.currentDevice.master ||
                (widget.currentDevice as VacuumDeviceModel)
                    .getVideoPermission()) {
              (widget as VacuumDeviceWidget).monitorClick?.call();
            } else if ((widget.currentDevice as VacuumDeviceModel)
                .canShareVideo()) {
              widget.messgaeToast('home_require_permission_tip'.tr());
            }
          } else {
            widget.messgaeToast('text_device_offline'.tr());
          }
        }).flipWithRTL(context),
      ),
    );
  }

  Widget _buildFastCommandMenu(
      StyleModel style, ResourceModel resource, bool rtl) {
    bool online = widget.currentDevice.isOnline();
    return Container(
      key: keyFastCmd,
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 15,
              spreadRadius: 1.0)
        ],
      ),
      child: Image.asset(
        width: 30,
        height: 24,
        resource.getResource(
            online ? 'ic_home_fast_cmd' : 'ic_home_fast_cmd_disable'),
      ).withDynamic().onClick(() {
        if (online) {
          (widget as VacuumDeviceWidget).fastCommandClick?.call();
        } else {
          widget.messgaeToast('text_device_offline'.tr());
        }
      }).flipWithRTL(context),
    );
  }

  Widget _buildRightMenu(StyleModel style, ResourceModel resource, bool rtl) {
    bool showVideo = (widget.currentDevice as VacuumDeviceModel).isShowVideo();
    bool supportFastCommand =
        (widget.currentDevice as VacuumDeviceModel).isSupportFastCommand();

    return Row(
      mainAxisAlignment: rtl ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, right: 10).withRTL(context),
          // height: 90,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showVideo
                  ? _buildMonitor(style, resource, rtl)
                  : const SizedBox(),
              showVideo && supportFastCommand
                  ? const SizedBox(height: 14)
                  : const SizedBox(),
              supportFastCommand
                  ? _buildFastCommandMenu(style, resource, rtl)
                  : const SizedBox(),
            ],
          ),
        )
      ],
    );
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
  Widget buildMeddleContent(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double deviceImageWidth = screenWidth - 2 * (60);
    double deviceImageHeight = deviceImageWidth;
    return Expanded(
      flex: 414,
      child: LayoutBuilder(builder: (context, imgConstraints) {
        var imageWidth = min(screenWidth * 290 / 390, screenHeight * 290 / 844);
        // 图片的上下间距默认 30 20 ,按钮大小 默认52,下方间距 默认 16, 剩余高度设置图片大小,如果图片大小超过最大高度,则设置为最大高度
        imageWidth =
            min(imageWidth, imgConstraints.maxHeight - 30 - 20 - 52 - 16);
        return Column(children: [
          // 间隔
          const Expanded(
            flex: 10,
            child: SizedBox.shrink(),
          ),
          Stack(
            children: [
              // 设备图片
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 20),
                  width: imageWidth,
                  height: imageWidth,
                  child: widget.currentDevice.deviceInfo?.mainImage.imageUrl
                              ?.isNotEmpty ==
                          true
                      ? CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl: widget.currentDevice.deviceInfo!.mainImage
                                  .imageUrl ??
                              '',
                          fadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          errorWidget: (context, url, error) => Image(
                            image: AssetImage(
                                resource.getResource('ic_placeholder_robot')),
                          ).withDynamic(),
                          placeholder: (context, url) => Image(
                            width: deviceImageWidth,
                            height: deviceImageHeight,
                            image: AssetImage(
                                resource.getResource('ic_placeholder_robot')),
                          ).withDynamic(),
                        )
                      : Image(
                          width: deviceImageWidth,
                          height: deviceImageHeight,
                          image: AssetImage(
                              resource.getResource('ic_placeholder_robot')),
                        ).withDynamic(),
                ).onClick(() {
                  LogModule().eventReport(5, 5,
                      did: widget.currentDevice.did,
                      model: widget.currentDevice.model);
                  widget.enterPluginClick.call();
                }),
              ),
              // 右上角菜单
              Visibility(
                visible: (widget.currentDevice is VacuumDeviceModel)
                    ? ((widget.currentDevice as VacuumDeviceModel)
                            .isShowVideo() ||
                        (widget.currentDevice as VacuumDeviceModel)
                            .isSupportFastCommand())
                    : false,
                child: _buildRightMenu(style, resource, rtl),
              ),
            ],
          ),
          // 间隔
          const Expanded(
            flex: 1,
            child: SizedBox.shrink(),
          ),
          // 底部操作按钮
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: style.lightBlack1, width: 1),
                borderRadius:
                    BorderRadius.all(Radius.circular(style.circular8))),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Text('enter_device'.tr(),
                style:
                    style.mainStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ).onClick(() {
            LogModule().eventReport(5, 5,
                did: widget.currentDevice.did,
                model: widget.currentDevice.model);
            widget.enterPluginClick.call();
          }),
          // 间隔
          const Expanded(
            flex: 1,
            child: SizedBox.shrink(),
          ),
        ]);
      }),
    );
  }
}
