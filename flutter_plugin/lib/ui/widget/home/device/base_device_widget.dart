import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/widget/dm_special_button.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/ui/widget/home/home_device_popup.dart';
import 'package:flutter_plugin/ui/widget/home/home_new_battery.dart';
import 'package:flutter_plugin/ui/widget/text_icon_baseline.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseDeviceWidget extends ConsumerStatefulWidget {
  final BaseDeviceModel currentDevice;
  final VoidCallback enterPluginClick;
  final VoidCallback offlineTipClick;
  final Function(ButtonState)? leftActionClick;
  final Function(ButtonState)? rightActionClick;
  final Function(String) messgaeToast;
  final VoidCallback? nextGuideCallback;

  BaseDeviceWidget({
    super.key,
    required this.leftActionClick,
    required this.rightActionClick,
    required this.currentDevice,
    required this.enterPluginClick,
    required this.offlineTipClick,
    required this.messgaeToast,
    this.nextGuideCallback,
  });
}

abstract class BaseDeviceWidgetState<T extends BaseDeviceWidget>
    extends ConsumerState<T> with BaseDeviceWidgetStateDataSources {
  final textIconBaselineKey = GlobalKey(debugLabel: 'deviceNameKey');
  final double maxScreenWidth =
      500; // 最大屏幕宽度500。安卓最大是480。iOS的iPhone16 pro max是440

  @override
  void initState() {
    super.initState();
  }

  /// 展示离线 & 状态
  Pair<bool, String> parseStatus() {
    if (widget.currentDevice.isLocalCache) {
      return Pair(false, '');
    }
    bool online = widget.currentDevice.online == true;
    bool showOffline = false;
    String deviceStatus = widget.currentDevice.latestStatusStr ?? '';
    final lastWill = widget.currentDevice.lastWill;
    if (widget.currentDevice.supportLastWill() &&
        (lastWill != null && lastWill.isNotEmpty)) {
      if (lastWill == '0') {
        showOffline = false;
      } else if (lastWill.startsWith('900_')) {
        deviceStatus = 'text_device_network_reset'.tr();
        showOffline = true;
      } else {
        int lastWillCode = -1;
        showOffline = true;
        try {
          lastWillCode = int.parse(lastWill);
        } catch (e) {
          LogUtils.e('parse lastWill error: $e, lastWill: $lastWill');
        }
        if (lastWillCode == 202 ||
            (lastWillCode >= 300 && lastWillCode <= 499) ||
            (lastWillCode >= 501 && lastWillCode <= 503) ||
            (lastWillCode >= 520 && lastWillCode <= 561) ||
            (lastWillCode >= 601 && lastWillCode <= 603) ||
            (lastWillCode >= 620 && lastWillCode <= 661)) {
          deviceStatus = 'text_device_shut_off'.tr();
        } else if (lastWillCode == 200) {
          deviceStatus = 'text_device_reset'.tr();
        } else if (lastWillCode == 203 || lastWillCode == 204) {
          deviceStatus = 'text_device_reboot'.tr();
        } else if (lastWillCode == 562 ||
            lastWillCode == 662 ||
            lastWillCode == 570 ||
            lastWillCode == 670) {
          deviceStatus = 'text_device_dock_power_off'.tr();
        } else {
          deviceStatus = 'device_offline'.tr();
        }
      }
      widget.currentDevice.online = !showOffline;
    } else {
      if (online) {
        showOffline = false;
      } else {
        showOffline = widget.currentDevice.latestStatus >= 0;
        if (widget.currentDevice.latestStatus >= 0) {
          deviceStatus = 'device_offline'.tr();
        }
      }
    }
    // LogUtils.i(
    //     'HomeItemWidget #状态解析: did:${widget.currentDevice.did}, isLocalCache:${widget.currentDevice.isLocalCache}, online:${widget.currentDevice.online}, lastWill:${widget.currentDevice.lastWill}, latestStatus:${widget.currentDevice.latestStatus}, latestStatusStr:${widget.currentDevice.latestStatusStr}, 结果: showOffline:$showOffline, status:$deviceStatus');
    return Pair(showOffline, deviceStatus);
  }

  /// 设备状态
  Widget buildDeviceStatus(StyleModel style, ResourceModel resource, bool rtl) {
    final statusPair = parseStatus();
    return Expanded(
      child: Row(
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
            child: Container(
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
      ),
    );
  }

  /// 电量
  Widget buildBattery(StyleModel style, ResourceModel resource, bool rtl) {
    bool online = widget.currentDevice.isOnline();
    return view_direction.Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HomeNewBattery(
              electricQuantity: online ? widget.currentDevice.battery : 0,
              batteryLeve: provideBatteryLevel(),
              width: 12,
              height: 22),
          const SizedBox(
            width: 4,
          ),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [style.textSecond, style.textMain])
                  .createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: Text(
                '${(online && widget.currentDevice.battery != -1) ? widget.currentDevice.battery : '--'}%',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(
            width: 4,
          ),
          buildDeviceStatus(style, resource, rtl),
        ],
      ),
    );
  }

  /// z层
  Widget buildOverlay(StyleModel style, ResourceModel resource, bool rtl) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    return ThemeWidget(
      builder: (context, style, resource) {
        return LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  buildTopContent(style, resource, rtl, constraints),
                  buildMeddleContent(style, resource, rtl, constraints),
                  buildBottomContent(style, resource, rtl, constraints),
                ],
              ),
              buildFirstStackLayer(style,resource,rtl,constraints)
            ]
          );
        });
      },
    );
  }

  /// 设备名称
  @override
  Widget buildTopContent(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    return ThemeWidget(builder: (context, style, resource) {
      double statusBarHeight = MediaQuery.of(context).padding.top + 20;
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
                        alignment: AlignmentDirectional.centerStart,
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
            buildBattery(style, resource, rtl),
          ],
        ),
      );
    });
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
        return Stack(children: [
          Column(
            children: [
              // 间隔
              const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),

              // 设备图片
              Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                  ),
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
                            image: AssetImage(devicePlaceHolder(resource)),
                          ).withDynamic(),
                          placeholder: (context, url) => Image(
                            width: deviceImageWidth,
                            height: deviceImageHeight,
                            image: AssetImage(devicePlaceHolder(resource)),
                          ).withDynamic(),
                        )
                      : Image(
                          width: deviceImageWidth,
                          height: deviceImageHeight,
                          image: AssetImage(devicePlaceHolder(resource)),
                        ).withDynamic(),
                ).onClick(() {
                  LogModule().eventReport(5, 5,
                      did: widget.currentDevice.did,
                      model: widget.currentDevice.model);
                  widget.enterPluginClick.call();
                }),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),
            ],
          ),
        ]);
      }),
    );
  }

  Widget buildFirstStackLayer(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints){
    return Container();
  }

  String devicePlaceHolder(ResourceModel resource){
    return resource.getResource('ic_placeholder_robot');
  }

  Widget buildBottomContent(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    return Expanded(
      flex: 198,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxScreenWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 尺寸按设计师给的390宽度为容器宽度
              return Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: Container(),
                  ),
                  Expanded(
                      flex: 350,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 154,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 154,
                                    child: _buildEnterWidget(
                                        style, resource, rtl, constraints),
                                  ),
                                  Expanded(
                                    flex: 40,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 176,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 154,
                                    child: _buildCleanListWidget(
                                        style, resource, rtl, constraints),
                                  ),
                                  Expanded(flex: 40, child: Container()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 20,
                    child: Container(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEnterWidget(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints? constraints) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF955E30).withOpacity(0.16), // 阴影颜色
            blurRadius: 12, // 阴影模糊半径
            offset: const Offset(6, 6), // 阴影偏移量，x方向为6，y方向为6
          ),
        ],
      ),
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(resource.getResource('ic_new_vacuum_enter_bg')),
              fit: BoxFit.fill,
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
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
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
            did: widget.currentDevice.did, model: widget.currentDevice.model);
        widget.enterPluginClick.call();
      }),
    );
  }

  Widget _buildCleanListWidget(StyleModel style, ResourceModel resource,
      bool rtl, BoxConstraints? constraints) {
    var keyPari = provideButtonKey();
    var btnRes = provideBtnRes();
    var btnState = provideButtonState();
    bool online = widget.currentDevice.isOnline();

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        flex: 68,
        child: DMSpecialButton.third(
          key: keyPari.first,
          maxLines: 2,
          backgroundImage:
              AssetImage(resource.getResource('ic_new_vacuum_start_bg')),
          actionBtnRes: btnRes.first,
          state: btnState.first,
          borderRadius: 8,
          fontsize: 14,
          textColor: style.homeCleanTextColor,
          fontWidget: FontWeight.w600,
          padding: const EdgeInsets.all(16),
          onClickCallback: (buttonState) {
            LogModule().eventReport(5, 7,
                int1: widget.currentDevice.latestStatus,
                did: widget.currentDevice.did,
                model: widget.currentDevice.model);
            if (online) {
              widget.leftActionClick?.call(btnState.first);
            } else {
              widget.messgaeToast.call('text_device_offline'.tr());
            }
          },
        ),
      ),
      const Expanded(flex: 15, child: SizedBox(height: 14)),
      Expanded(
        flex: 68,
        child: DMSpecialButton.third(
          key: keyPari.second,
          maxLines: 2,
          backgroundImage:
              AssetImage(resource.getResource('ic_new_vacuum_charge_bg')),
          fontsize: 14,
          textColor: style.homeCleanTextColor,
          fontWidget: FontWeight.w600,
          actionBtnRes: btnRes.second,
          state: btnState.second,
          borderRadius: 8,
          padding: const EdgeInsets.all(16),
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
        ),
      )
    ]);
  }

  ///计算控件布局信息
  Pair<Offset, Size> queryWidgetLocation(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    var offset =
        renderBox?.localToGlobal(Offset(0.0, size.height)) ?? Offset.zero;
    return Pair(offset, size);
  }
}

mixin BaseDeviceWidgetStateDataSources<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// 设备按钮状态
  /// 左按钮状态、右按钮状态
  Pair<ButtonState, ButtonState> provideButtonState() {
    throw UnimplementedError();
  }

  /// 展示设备引导
  Future<void> showDeviceGuide();

  /// 自定义电量等级
  List<BatteryLevel> provideBatteryLevel() {
    return [
      BatteryLevel(0xff88D644, Pair(100, 15)),
      BatteryLevel(0xFFF44336, Pair(15, 0)),
      BatteryLevel(0x00000000, Pair(0, -100)),
    ];
  }

  /// 设备按钮资源图片
  Pair<ActionBtnResourceModel, ActionBtnResourceModel> provideBtnRes() {
    throw UnimplementedError();
  }

  Pair<GlobalKey, GlobalKey> provideButtonKey() {
    throw UnimplementedError();
  }
}

extension BaseDeviceWidgetStateExtension on BaseDeviceWidgetState {
  void showMoreOperate(BaseDeviceModel currentDevice) {
    LogModule().eventReport(5, 12);
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    final renderBox =
        textIconBaselineKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset position =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;
    final deviceNameTopMargin = position.dy;
    final deviceNameStartMargin = position.dx;
    SmartDialog.showAttach(
        debounce: true,
        maskColor: Colors.transparent,
        alignment: rtl ? Alignment.bottomLeft : Alignment.bottomRight,
        animationTime: const Duration(milliseconds: 300),
        targetContext: null,
        targetBuilder: (targetOffset, targetSize) {
          return Offset(
              rtl ? deviceNameStartMargin : deviceNameStartMargin + size.width,
              deviceNameTopMargin + size.height - 22);
        },
        animationBuilder: (controller, child, animationParam) {
          return HomePopupAnmiation(
            animationParam: animationParam,
            child: child,
          );
        },
        builder: (_) {
          var isHideDeleteButton = widget.currentDevice.deviceInfo?.feature
                  ?.contains(IotDeviceFeature.HIDE_DELETE.feature) ??
              false;
          return BlockSemantics(
              child: HomeDevicePopup(
              isHideDeleteButton: isHideDeleteButton,
              clickAdd: () {},
              clickShare: () async {
                await SmartDialog.dismiss();
                if (mounted) {
                  await ref
                      .read(homeStateNotifierProvider.notifier)
                      .shareDevice(currentDevice);
                }
              },
              clickRename: () {
                SmartDialog.dismiss();
                ref
                    .read(homeStateNotifierProvider.notifier)
                    .clickRenameDevice();
              },
              clickDelete: () {
                SmartDialog.dismiss();
                ref
                    .read(homeStateNotifierProvider.notifier)
                    .clickDeleteDevice();
              },
                  currentDevice: currentDevice));
        });
  }
}
