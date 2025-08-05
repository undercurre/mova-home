import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';

// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/command_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/ui/widget/home/home_device_popup.dart';
import 'package:flutter_plugin/ui/widget/home/home_fast_command_pop.dart';
import 'package:flutter_plugin/ui/widget/home/home_new_battery.dart';
import 'package:flutter_plugin/ui/widget/text_icon_baseline.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_device_content_widget.dart';
import 'vacuum_base_device_top_widget.dart';


abstract class VacuumBaseDeviceWidget extends ConsumerStatefulWidget {
  final BaseDeviceModel currentDevice;
  final VoidCallback enterPluginClick;
  final VoidCallback offlineTipClick;
  final VoidCallback? monitorClick;
  final VoidCallback? fastCommandClick;
  final Function(ButtonState)? leftActionClick;
  final Function(ButtonState)? rightActionClick;
  final Function(String) messgaeToast;
  final VoidCallback? nextGuideCallback;

  const VacuumBaseDeviceWidget({
    super.key,
    required this.leftActionClick,
    required this.rightActionClick,
    required this.currentDevice,
    required this.enterPluginClick,
    required this.offlineTipClick,
    required this.messgaeToast,
    required this.monitorClick,
    required this.fastCommandClick,
    this.nextGuideCallback,
  });
}

abstract class VacuumBaseDeviceWidgetState<T extends VacuumBaseDeviceWidget>
    extends ConsumerState<T> with VacuumBaseDeviceWidgetStateDataSources {
  late final GlobalKey textIconBaselineKey =
      GlobalKey(debugLabel: 'deviceNameKey');
  late final GlobalKey keyClean;
  late final GlobalKey keyCharge;

  final double maxScreenWidth =
      500; // 最大屏幕宽度500。安卓最大是480。iOS的iPhone16 pro max是440

  // 设计标准：390 x 844
  // iPhone 6s（375 x 667）的屏幕尺寸下，flex: 198 的高度可能不足
  // 如果这里要调整，需要调试一下iPhone 6s的屏幕尺寸
  // 设计稿地址：https://mastergo.com/file/142464713987673?page_id=733%3A634&shareId=142464713987673&devMode=true
  // 设备页占比：126 + 412 + 198
  final int _topFlex = 126;
  int _middleFlex = 412;
  int _bottomFlex = 198;
  final int _totalFlex = 736;

  @override
  void initState() {
    super.initState();
    keyClean = GlobalKey(
        debugLabel:
            'keyClean_${widget.currentDevice.model}_${widget.currentDevice.did}');
    keyCharge = GlobalKey(
        debugLabel:
            'keyCharge_${widget.currentDevice.model}_${widget.currentDevice.did}');
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
        // 遗嘱相关文档:[https://dreametech.feishu.cn/docx/Elw3dWmOBo33l8xhETJcIMHwnZc?from=from_copylink]
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
      flex: 1,
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
                            fontWeight: FontWeight.w400,
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
              style: TextStyle(
                  fontSize: 14, color: style.homeDeviceStateTextColor),
            ),
          ),
          Visibility(
            visible: statusPair.first,
            child: Container(
              padding: const EdgeInsetsDirectional.only(end: 30, start: 8),
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
          Semantics(
            label:
                '${'battery_percentage'.tr()}${(online && widget.currentDevice.battery != -1) ? widget.currentDevice.battery : '--'}%',
            child: ExcludeSemantics(
              child: Row(
                children: [
                  HomeNewBattery(
                    electricQuantity:
                        (online && widget.currentDevice.battery != -1)
                            ? widget.currentDevice.battery
                            : 0,
                    isCharging: (widget.currentDevice as VacuumDeviceModel)
                                .charingStatus ==
                            1
                        ? true
                        : false,
                    batteryLeve: provideBatteryLevel(),
                    width: 80,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    '${(online && widget.currentDevice.battery != -1) ? widget.currentDevice.battery : '--'}%',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: style.homeDeviceStateTextColor),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
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
    // iphone 6s小尺寸
    if (MediaQuery.of(context).size.height <= 667) {
      _bottomFlex = 218;
      _middleFlex = _totalFlex - _topFlex - _bottomFlex;
    }
    return ThemeWidget(
      builder: (context, style, resource) {
        return Stack(
          children: [
            buildBottomLayer(style, resource, rtl),
            // buildMiddleLayer(style, resource, rtl, constraints),
            // 最顶部一层，快捷指令动画。视频监控按钮。
            _buildTopLayer(style, resource, rtl),
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: _buildMiddleLayerTopContent(style, resource, rtl),
            ),
          ],
        );
      },
    );
  }

  // 最顶部一层，快捷指令动画。视频监控按钮。
  Widget _buildTopLayer(StyleModel style, ResourceModel resource, bool rtl) {
    var btnRes = provideBtnRes();
    var btnState = provideButtonState();
    bool online = widget.currentDevice.isOnline();
    return view_direction.Center(
      child: ConstrainedBox(
        // 设计标准：390 x 844
        // iPhone 6s（375 x 667）的屏幕尺寸下，flex: 198 的高度可能不足
        // 如果这里要调整，需要调试一下iPhone 6s的屏幕尺寸
        // 设计稿地址：https://mastergo.com/file/142464713987673?page_id=733%3A634&shareId=142464713987673&devMode=true
        // 设备页占比：126 + 412 + 198
        constraints: BoxConstraints(minHeight: 180, maxWidth: maxScreenWidth),
        child: LayoutBuilder(builder: (context, constraints) {
          return Semantics(
            explicitChildNodes:  true,
            child: VacuumBaseDeviceTopWidget(
              style: style,
              resource: resource,
              bottomFlex: _bottomFlex,
              middleFlex: _middleFlex,
              topFlex: _topFlex,
              totalFlex: _totalFlex,
              constraintsWidth: constraints.maxWidth <= 0
                  ? MediaQuery.of(context).size.width
                  : constraints.maxWidth,
              // 73是底部tabbar的高度
              constraintsHeight: constraints.maxHeight <= 0
                  ? (MediaQuery.of(context).size.height - 73)
                  : constraints.maxHeight,
              topPadding: MediaQuery.of(context).padding.top + 20,
              enterPluginClick: () {
                LogModule().eventReport(5, 5,
                    did: widget.currentDevice.did,
                    model: widget.currentDevice.model);
                widget.enterPluginClick.call();
              },
              btnRes: btnRes,
              btnState: btnState,
              fastCmdTitle: _isFastCommandNotEmpty()
                  ? 'text_add_fast_list'.tr()
                  : 'text_add_fast_cmd'.tr(),
              // 这里不能用HomeDeviceCleanBtnWidget的click事件。
              // 这里要区分快捷指令和清扫指令的点击事件
              onFastCmdClick: () {
                if (online) {
                  showFastCommandPop(widget.currentDevice as VacuumDeviceModel);
                } else {
                  widget.messgaeToast('text_device_offline'.tr());
                }
              },
              onCleanClick: () {
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
              monitorClick: () {
                LogModule().eventReport(5, 9,
                    int1: widget.currentDevice.latestStatus,
                    did: widget.currentDevice.did,
                    model: widget.currentDevice.model);
                if (online) {
                  if (widget.currentDevice.master ||
                      (widget.currentDevice as VacuumDeviceModel)
                          .getVideoPermission()) {
                    widget.monitorClick?.call();
                  } else if ((widget.currentDevice as VacuumDeviceModel)
                      .canShareVideo()) {
                    widget.messgaeToast('home_require_permission_tip'.tr());
                  }
                } else {
                  widget.messgaeToast('text_device_offline'.tr());
                }
              },
              onCleanTopClick: () async {
                FastCommandModel? pinFastCommandModel = getPinFastCommand();
                if (pinFastCommandModel != null) {
                  await ref
                      .read(fastCommandStateNotifierProvider.notifier)
                      .onFastCommandClick(pinFastCommandModel);
                } else {
                  LogModule().eventReport(5, 7,
                      int1: widget.currentDevice.latestStatus,
                      did: widget.currentDevice.did,
                      model: widget.currentDevice.model);
                  if (online) {
                    widget.leftActionClick?.call(btnState.first);
                  } else {
                    widget.messgaeToast.call('text_device_offline'.tr());
                  }
                }
              },
              device: widget.currentDevice as VacuumDeviceModel,
              messgaeToast: widget.messgaeToast,
              rtl: rtl,
              keyClean: keyClean,
              keyCharge: keyCharge,
            ),
          );
        }),
      ),
    );
  }

  Widget buildMiddleLayer(StyleModel style, ResourceModel resource, bool rtl,
      BoxConstraints constraints) {
    return Container(
        constraints: BoxConstraints(
            maxWidth: constraints.maxWidth, maxHeight: constraints.maxHeight),
        child: Column(
          /* 设备图、状态等信息*/
          children: [
            Expanded(
              flex: _topFlex,
              child: const SizedBox.shrink(),
            ),
            _buildMiddleLayerMiddleContent(style, resource, rtl, constraints),
            _buildMiddleLayerBottomContent(style, resource, rtl, constraints),
          ],
        ));
  }

  Widget _buildMiddleLayerTopContent(
      StyleModel style, ResourceModel resource, bool rtl) {
    double statusBarHeight = MediaQuery.of(context).padding.top + 20;
    return Container(
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(color: Color(0x01FFFFFF), width: 0.1))),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: EdgeInsets.only(top: statusBarHeight),
        child: Semantics(
          explicitChildNodes: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:
                    rtl ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showMoreOperate(widget.currentDevice);
                      },
                      child: Align(
                        alignment:
                            rtl ? Alignment.centerRight : Alignment.centerLeft,
                        child: TextIconBaselineWidget(
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 2, left: 2, right: 2),
                          key: textIconBaselineKey,
                          text: widget.currentDevice.getShowName(),
                          style: TextStyle(
                              color: style.homeDeviceNameTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          icon: Semantics(
                            label: 'more_features'.tr(),
                            child: Image.asset(
                              resource.getResource('ic_home_device_name_edit'),
                            ).flipWithRTL(context),
                          ),
                        ),
                      ),
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
        ));
  }

  Widget buildBottomLayer(StyleModel style, ResourceModel resource, bool rtl) {
    return LayoutBuilder(builder: (context, imgConstraints) {
      return Center(
        child: ConstrainedBox(
          // 设计标准：390 x 844
          // iPhone 6s（375 x 667）的屏幕尺寸下，flex: 198 的高度可能不足
          // 如果这里要调整，需要调试一下iPhone 6s的屏幕尺寸
          // 设计稿地址：https://mastergo.com/file/142464713987673?page_id=733%3A634&shareId=142464713987673&devMode=true
          // 设备页占比：126 + 412 + 198
          constraints: BoxConstraints(minHeight: 180, maxWidth: maxScreenWidth),
          child: HomeDeviceContentWidget(
            imageUrl: widget.currentDevice.deviceInfo?.mainImage.imageUrl ?? '',
            currentDevice: widget.currentDevice,
            enterPluginClick: widget.enterPluginClick,
            online: widget.currentDevice.online,
            productId: widget.currentDevice.deviceInfo?.productId ?? '',
          ),
        ),
      );
    });
  }



  Widget _buildMiddleLayerMiddleContent(StyleModel style,
      ResourceModel resource, bool rtl, BoxConstraints constraints) {
    return Expanded(
      flex: _middleFlex, // 这里已经比例设置了
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildMiddleLayerBottomContent(StyleModel style,
      ResourceModel resource, bool rtl, BoxConstraints? constraints) {
    return Expanded(
      flex: _bottomFlex,
      child: const SizedBox.shrink(),
    );
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

mixin VacuumBaseDeviceWidgetStateDataSources<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// 左按钮状态、右按钮状态
  Pair<ButtonState, ButtonState> provideButtonState() {
    throw UnimplementedError();
  }

  /// 展示设备引导
  Future<void> showDeviceGuide();

  /// 自定义电量等级
  List<BatteryLevel> provideBatteryLevel() {
    return [
      BatteryLevel(0xff88D644, Pair(100, 0)),
      BatteryLevel(0xFFF44336, Pair(20, 0)),
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

extension VacuumBaseDeviceWidgetStateExtension on VacuumBaseDeviceWidgetState {
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

  /* 是否有置顶置快捷指令*/
  FastCommandModel? getPinFastCommand() {
    List<FastCommandModel>? fastCommandList =
        (widget.currentDevice as VacuumDeviceModel).fastCommandList;
    if (fastCommandList == null || fastCommandList.isEmpty) {
      return null;
    }
    FastCommandModel? desCommand;
    for (var element in fastCommandList) {
      if (element.property != null) {
        if (element.property!.contains('pin')) {
          desCommand = element;
          break;
        }
      }
    }

    return desCommand;
  }

  /* 是否有配置快捷指令*/
  bool _isFastCommandNotEmpty() {
    VacuumDeviceModel devie = (widget.currentDevice as VacuumDeviceModel);
    if (devie.fastCommandList == null) {
      return false;
    }
    return devie.isSupportFastCommand() && devie.fastCommandList!.isNotEmpty;
  }

  /*  是否有正在运行的快捷指令任务*/
  bool isFastCommandRunning() {
    bool running = false;
    List<FastCommandModel>? fastCommandList =
        (widget.currentDevice as VacuumDeviceModel).fastCommandList;
    if (fastCommandList == null || fastCommandList.isEmpty) {
      return running;
    }
    for (int i = 0; i < fastCommandList.length; i++) {
      FastCommandModel command = fastCommandList[i];
      if (command.state == '1') {
        running = true;
        break;
      }
    }

    return running;
  }

  /*  是否有正在运行的快捷指令任务*/
  bool isNotFastCommandRunning() {
    bool running = false;
    List<FastCommandModel>? fastCommandList =
        (widget.currentDevice as VacuumDeviceModel).fastCommandList;
    if (fastCommandList == null || fastCommandList.isEmpty) {
      return running;
    }

    for (int i = 0; i < fastCommandList.length; i++) {
      FastCommandModel command = fastCommandList[i];
      if (command.state == null || command.state!.isEmpty) {
        running = true;
        break;
      }
    }
    return running;
  }

  /* 当前状态是否是任务暂停（普通清洁任务、快捷指令任务）*/
  bool isCleanTaskPause() {
    if (widget.currentDevice.latestStatus == 3 ||
        widget.currentDevice.latestStatus == 4) {
      return true;
    }
    return false;
  }

  /* 展示快捷指令气泡*/
  void showFastCommandPop(VacuumDeviceModel currentDevice) {
    if (!context.mounted) {
      return;
    }

    final renderBox =
        keyCharge.currentContext?.findRenderObject() as RenderBox?;
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    final Offset position =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;
    final deviceNameTopMargin = position.dy;
    final deviceNameStartMargin = position.dx;

    List<FastCommandModel> fastList = currentDevice.fastCommandList ?? [];

    if (fastList.isEmpty) {
      ref.read(homeStateNotifierProvider.notifier).openPlugin('quickCommand');
      return;
    }

    SmartDialog.showAttach(
        targetContext: null,
        debounce: true,
        maskColor: Colors.transparent,
        alignment: rtl ? Alignment.topLeft : Alignment.topRight,
        animationTime: const Duration(milliseconds: 200),
        targetBuilder: (targetOffset, targetSize) {
          return Offset(
              rtl ? deviceNameStartMargin : deviceNameStartMargin + size.width,
              deviceNameTopMargin + size.height + 20); // 固定底部高度
        },
        animationBuilder: (controller, child, animationParam) {
          return HomeFastPopupAnmiation(
            animationParam: animationParam,
            child: child,
          );
        },
        builder: (_) {
          return BlockSemantics(
              child: HomeFastCommandPop(
                  // fastCommandList: fastList,
                  addCommandCallback: () async {
                    await ref
                        .read(homeStateNotifierProvider.notifier)
                        .openPlugin('quickCommand');
                  },
                  closeCallback: (needAnimate) {
                    SmartDialog.dismiss(tag: 'fast_command_action_pop');
                  },
                  editCommandCallback: (id) async {
                    await ref
                        .read(homeStateNotifierProvider.notifier)
                        .openPlugin('quickCommand',
                            extraData: jsonEncode({'cmdId': id}));
                  },
                  toastCallback: (message) {
                    SmartDialog.showToast(message);
                  },
                  currentDevice: currentDevice));
        });
  }

}
