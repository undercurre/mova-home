import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/ads/home_ads_manager_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/email_collection/email_collection_check_mixin.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_repository.dart';
import 'package:flutter_plugin/ui/page/home/command_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/home/home_page_theme_mixin.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/home/user_dialog_mixin.dart';
import 'package:flutter_plugin/ui/page/home/user_mark_mixin.dart';
import 'package:flutter_plugin/ui/page/message/message_main_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_upgrade_mixin.dart';
import 'package:flutter_plugin/ui/page/settings/about/user_experience_plan/ux_plan_mixin.dart';
import 'package:flutter_plugin/ui/widget/dialog/device_guide/device_guide_step_first_dialog.dart';
import 'package:flutter_plugin/ui/widget/home/device/air_purifier_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/cat_litter_box_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/feeder_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/hold_common_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/mower_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/new_vacuum_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/device/toothbrush_device_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/ui/widget/home/home_empty.dart';
import 'package:flutter_plugin/ui/widget/home/home_error_widget.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/debounce_utils.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';

class HomePage extends BasePage {
  static const String routePath = '/home_page';
  const HomePage({super.key});

  @override
  HomaPageState createState() {
    return HomaPageState();
  }
}

class HomaPageState extends BasePageState
    with
        ResponseForeUiEvent,
        HomePageThemeMixin,
        PrivacyPolicyUpgradeMixin,
        EmailCollectionCheckMixin,
        UxPlanMixin,
        UserMarkMixin,
        UserDialogMixin {
  final ScrollController _scrollController = ScrollController();
  final PageController _controller = PageController();
  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishLoad: false, controlFinishRefresh: true);
  double _contentTopMargin = 50;

  final Map<String, Key> _deviceKeys = {};
  final int disagree = 2;
  final int agree = 1;
  bool isSecondPage = false;

  @override
  Future<void> initPageState() async {
    showTitle = false;
    if (Platform.isIOS) {
      _contentTopMargin = await InfoModule().isNotchScreen() ? 60 : 30;
    }
  }

  @override
  void initData() {
    ref.read(homeStateNotifierProvider.notifier).initData();
    SmartDialog.config.attach = SmartConfigAttach(
        attachAlignmentType: SmartAttachAlignmentType.outside);
    // 日活埋点
    LogModule().eventReport(9, 2);

    GoRouterState? state = AppRoutes().getGoRouterState(context);
    final Map<String, dynamic>? extraData =
        state?.extra as Map<String, dynamic>?;
    final String? fromPage = extraData?['from'] as String?;
    isSecondPage = fromPage == 'mall';
  }

  @override
  void updateEvent(PushEvent event) {
    responseFor(event);
  }

  @override
  void addObserver() {
    handleUserDialog(
        showDeviceGuideAction: (params) async {
          final bundle = params as Map<String, dynamic>;
          await _showGuide(bundle['supportFastCommand'], bundle['type'],
              holdActionType: bundle['holdActionType'] as HoldActionType);
        },
        // 这里逻辑和main_page.dart保持相反，防止多次监听
        dialogTypes: RegionStore().isChinaServer()
            ? []
            : [
                DialogType.guide,
                DialogType.personalizedAd,
                DialogType.ad,
                DialogType.privacy,
                DialogType.upgrade,
                DialogType.bindPhone,
                DialogType.userMark,
                DialogType.uxPlan,
                DialogType.emailCollect,
              ]);

    ref.listen(homeStateNotifierProvider.select((value) => value.uiEvent),
        (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });
    ref.listen(homeStateNotifierProvider.select((value) => value.refreshing),
        (previous, next) async {
      if (!next) {
        try {
          if (mounted) _refreshController.finishRefresh();
        } catch (e) {
          LogUtils.e('refresh error: $e');
        }
      }
    });
    ref.listen(homeStateNotifierProvider.select((value) => value.loading),
        (previous, next) {
      next ? showLoading() : dismissLoading();
    });
    ref.listen(homeStateNotifierProvider.select((value) => value.targetTab),
        (previous, next) {
      if (next != -1 && mounted) {
        _controller.jumpToPage(next);
        if (ref.exists(homeStateNotifierProvider)) {
          ref.read(homeStateNotifierProvider.notifier).resetTargetTab();
        }
      }
    });
    ref.listen(fastCommandStateNotifierProvider, (previous, next) {
      if (next is ToastEvent) {
        if (next.text.isNotEmpty) {
          showToast(next.text);
        }
      } else if (next != null) {
        responseFor(next);
      }
    });

    ref.listen(pluginProvider, (previous, next) {});
  }

  @override
  void activate() {
    if (ref.exists(homeStateNotifierProvider)) {
      LogUtils.d('getItemKey: activate $this');
      ref.read(homeStateNotifierProvider.notifier).clearItemKeys();
    }
    super.activate();
  }

  @override
  void deactivate() {
    if (ref.exists(homeStateNotifierProvider)) {
      LogUtils.d('getItemKey: deactivate $this');
      ref.read(homeStateNotifierProvider.notifier).clearItemKeys();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    SmartDialog.dismiss();
    EventBusUtil.getInstance().unRegister(this);
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void onAppResume() {
    super.onAppResume();
    if (mounted && ref.exists(homeStateNotifierProvider)) {
      ref.read(homeStateNotifierProvider.notifier).onAppResume();
    }
  }

  void _nextDialog() {
    ref.read(dialogJobManagerProvider.notifier).nextJob();
  }

  void openCustomerS() {
    List<BaseDeviceModel> deviceList = [];
    if (ref.exists(homeStateNotifierProvider)) {
      deviceList = ref
          .read(homeStateNotifierProvider.select((value) => value.deviceList));
    }
    ref
        .read(helpCenterRepositoryProvider)
        .pushToChat(context: context, deviceList: deviceList);
  }

  void jump2Message() {
    LogModule().eventReport(5, 2);
    GoRouter.of(context).push(MessageMainPage.routePath).then((value) =>
        ref.read(homeStateNotifierProvider.notifier).refreshMsgCount());
  }

  void addDevice() {
    UIModule().generatePairNetEngine(ProductListPage.routePath);
  }

  void addDeviceByScan() {
    UIModule().generatePairNetEngine(QrScanPage.routePath);
  }

  /// 展示引导第一步
  Future<void> _showGuide(
    bool supportFastCommand,
    DeviceType deviceType, {
    HoldActionType holdActionType = HoldActionType.cleanDry,
  }) async {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    double contentTopMargin = 50;
    if (Platform.isIOS) {
      contentTopMargin = await InfoModule().isNotchScreen() ? 60 : 30;
    }
    final stepCount =
        deviceType == DeviceType.vacuum ? (supportFastCommand ? 4 : 3) : 3;
    final desc = rtl ? '($stepCount/1)' : '(1/$stepCount)';
    DeviceGuideStepFirstDialog(
        titleOffset: Offset(24, contentTopMargin),
        provideTitleDescOrders: Triple(
            'text_more_operate'.tr(), 'text_guide_step_1_desc_v2'.tr(), desc),
        provideImageRes: 'ic_home_step_1',
        lastStep: false,
        rtl: rtl,
        skipCallback: () {
          _skipGuide(deviceType, holdActionType);
        },
        nextStepCallback: () {
          final itemKey = ref
              .read(homeStateNotifierProvider.notifier)
              .getItemKey(
                  ref.read(homeStateNotifierProvider).currentDevice?.did ?? '',
                  toStringShort());
          itemKey.currentState == null
              ? _nextDialog()
              : itemKey.currentState?.showDeviceGuide();
        }).show();
  }

  void _skipGuide(DeviceType deviceType, HoldActionType? holdActionType) {
    _nextDialog();
    ref
        .read(homeStateNotifierProvider.notifier)
        .updateGuide(deviceType, holdActionType);
  }

  Widget _buildHeader() {
    return ThemeWidget(builder: (context, style, resource) {
      final dynamicColor = style.textMain;
      double statusBarHeight = MediaQuery.of(context).padding.top;
      return Container(
          margin:
              EdgeInsets.only(top: statusBarHeight + 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                  visible: isSecondPage ? true : false,
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Container(
                      alignment: Alignment.center,
                      child: Semantics(
                        label: 'go_back_previous_page'.tr(),
                        child: Image.asset(
                          resource.getResource('ic_nav_back'),
                          width: 24,
                          height: 24,
                        ).flipWithRTL(context),
                      ),
                    ),
                  ).onClick(
                    () {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      }
                    },
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                      visible: ref.watch(homeStateNotifierProvider
                          .select((value) => value.showCustomerS)),
                      child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20).withRTL(context),
                          child: Semantics(
                            label: 'contact_customer_service'.tr(),
                            child: Image(
                              width: 24,
                              height: 24,
                              color: dynamicColor,
                              image: AssetImage(resource
                                  .getResource('ic_home_customer_service')),
                            ).withDynamic().onClick(openCustomerS),
                          ))),
                  Stack(
                    children: [
                      Semantics(
                        label: 'go_to_message_page'.tr(),
                        child: Image(
                          width: 24,
                          height: 24,
                          color: dynamicColor,
                          image:
                              AssetImage(resource.getResource('ic_home_msg')),
                        ).withDynamic().onClick(jump2Message),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Opacity(
                            opacity: ref.watch(homeStateNotifierProvider
                                    .select((value) => value.showMsgTips))
                                ? 1
                                : 0,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: style.red1),
                            )),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20).withRTL(context),
                    child: Semantics(
                      label: 'select_device'.tr(),
                      child: Image(
                        width: 24,
                        height: 24,
                        color: dynamicColor,
                        image: AssetImage(resource.getResource('ic_home_more')),
                      ).withDynamic().onClick(() {
                        /// 添加设备
                        addDeviceByScan();
                      }),
                    ),
                  )
                ],
              ),
            ],
          ));
    });
  }

  Widget _buildItem(BaseDeviceModel device, int index, ResourceModel resource) {
    Key? deviceKey = deviceKeyForDid(device);
    switch (device.deviceType()) {
      case DeviceType.vacuum:
        return NewVacuumDeviceWidget(
            currentDevice: device,
            key: deviceKey,
            enterPluginClick: () async {
              // 限流
              DebounceUtils.debounce(
                  key: 'enterPluginClick',
                  callback: () async {
                    await ref
                        .read(homeStateNotifierProvider.notifier)
                        .openPlugin('main');
                  });
            },
            leftActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onCleanClick(device as VacuumDeviceModel);
            },
            rightActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onChargeClick(device as VacuumDeviceModel);
            },
            monitorClick: () {
              ref
                  .read(homeStateNotifierProvider.notifier)
                  .onMonitroClick(device as VacuumDeviceModel);
            },
            fastCommandClick: () async {},
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              _skipGuide(device.deviceType(), null);
            },
            messgaeToast: showToast);
      case DeviceType.hold:
        return HoldCommonDeviceWidget(
            key: deviceKey,
            currentDevice: device,
            leftActionClick: (leftState) async {
              if (leftState == ButtonState.disable) {
                return;
              }
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onHoldLeftClick(device as HoldDeviceModel,
                      leftState == ButtonState.active);
            },
            rightActionClick: (rightState) async {
              if (rightState == ButtonState.disable) {
                return;
              }
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onHoldRightClick(device as HoldDeviceModel,
                      rightState == ButtonState.active);
            },
            enterPluginClick: () async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main');
            },
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              _skipGuide(device.deviceType(),
                  (device as HoldDeviceModel).holdActionType());
            },
            messgaeToast: showToast);
      case DeviceType.mower:
        return MowerDeviceWidget(
            key: deviceKey,
            currentDevice: device,
            leftActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onMowerLeft(device);
            },
            rightActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onMowerRight(device);
            },
            enterPluginClick: () async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main');
            },
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              _skipGuide(device.deviceType(), null);
            },
            messgaeToast: showToast);
      case DeviceType.airPurifier:
        return AirPurifierDeviceWidget(
            key: deviceKey,
            currentDevice: device,
            leftActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onMowerLeft(device);
            },
            rightActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onMowerRight(device);
            },
            enterPluginClick: () async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main');
            },
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              //该类型引导弹窗暂未实现
              _nextDialog();
            },
            messgaeToast: showToast);
      case DeviceType.toothbrush:
      case DeviceType.detector:
        return ToothBrushDeviceWidget(
            currentDevice: device,
            key: deviceKey,
            isAddTestStick: device.model.startsWith('mova.toothbrush.n2501') &&
                device.model.endsWith('2'),
            //根据设备MODEL判断是2501牙刷，支持是否显示添加检测棒按钮
            enterPluginClick: () async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main');
            },
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              _skipGuide(device.deviceType(), null);
            },
            addTestStickClick: () {
              /// 进入牙菌斑设备连接类型选择页面
              addDevice();
            },
            messgaeToast: showToast);
      case DeviceType.feeder:
        return FeederDeviceWidget(
            key: deviceKey,
            currentDevice: device,
            leftButtonClick: (value) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onFeederLeft(value);
            },
            leftActionClick: (_) async {},
            rightActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('feederPlan');
            },
            enterPluginClick: () async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main');
            },
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              //该类型引导弹窗暂未实现
              _nextDialog();
            },
            messgaeToast: showToast);
      case DeviceType.litterbox:
        return CatLitterBoxDeviceWidget(
            key: deviceKey,
            currentDevice: device,
            leftButtonClick: (value) async {},
            leftActionClick: (_) async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .onLitterBoxLeft();
            },
            rightActionClick: (_) async {
              LogModule().eventReport(130, 1,
                  str1: '点击如厕数据',
                  str2: 'home',
                  str3: 'data',
                  did: device.did,
                  model: device.model);
              const extraData = {'tab': 'data'};
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main', extraData: jsonEncode(extraData));
            },
            enterPluginClick: () async {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .openPlugin('main');
            },
            offlineTipClick:
                ref.read(homeStateNotifierProvider.notifier).offlineTipClick,
            nextGuideCallback: () {
              //该类型引导弹窗暂未实现
              _nextDialog();
            },
            messgaeToast: showToast);
      default:
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child:
                  Text('${device.getShowName()}_${device.model}_${device.did}'),
            ),
            Flexible(
              child: Center(
                child: Image.asset(
                  resource.getResource('ic_placeholder_robot'),
                  width: 300,
                  height: 300,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text('text_home_enter_device'.tr()),
            ),
          ],
        ).onClick(() async {
          await ref.read(homeStateNotifierProvider.notifier).openPlugin('main');
        });
    }
  }

  Key? deviceKeyForDid(BaseDeviceModel device) {
    Key? deviceKey = _deviceKeys[device.did];

    if (deviceKey == null) {
      deviceKey = ref
          .read(homeStateNotifierProvider.notifier)
          .createItemKey(device.did, '${device.hashCode}_$hashCode');
      _deviceKeys[device.did] = deviceKey;
    }
    return deviceKey;
  }

  Widget _buildPageIndicator(StyleModel style, ResourceModel resource) {
    return Semantics(
      button: true,
      focusable: true,
      label: 'page_position'.tr(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: DotsIndicator(
          dotsCount: ref
                  .watch(homeStateNotifierProvider
                      .select((value) => value.deviceList))
                  .length +
              1,
          position: ref
              .watch(homeStateNotifierProvider.select(
                  (value) => value.currentIndex < 0 ? 0 : value.currentIndex))
              .toDouble(),
          mainAxisSize: MainAxisSize.min,
          decorator: DotsDecorator(
              size: const Size(6.0, 6.0),
              activeSize: const Size(18.0, 6.0),
              color: style.homePageIndicatorColor,
              activeColor: style.homePageIndicatorActiveColor,
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // 激活的点的圆角半径
              ),
              spacing: const EdgeInsets.all(4.0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final homeState = ref.watch(homeStateNotifierProvider);
    final protocolsList = homeState.deviceList;
   
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage(resource.getResource('ic_home_device_bg')),
                fit: BoxFit.fitWidth),
          ),
          width: double.infinity,
          height: double.infinity,
        ),
        EasyRefresh.builder(
          controller: _refreshController,
          onRefresh: () async {
            if (ref.read(homeStateNotifierProvider
                .select((value) => !value.refreshing))) {
              await ref
                  .read(homeStateNotifierProvider.notifier)
                  .refreshDevice();
            }
          },
          childBuilder: (context, physics) {
            return LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                physics: physics,
                controller: _scrollController,
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraint.maxHeight),
                    child: Stack(children: [
                      Column(
                        children: [
                          Visibility(
                            visible: ref.watch(homeStateNotifierProvider
                                .select((value) => value.loadError)),
                            child: HomeErrorWidget(
                              retryCallback: () async => await ref
                                  .read(homeStateNotifierProvider.notifier)
                                  .refreshDevice(),
                            ),
                          ),
                          Visibility(
                            visible: !ref.watch(homeStateNotifierProvider
                                .select((value) => value.loadError)),
                            child: Expanded(
                              flex: 1,
                              child: PageView.builder(
                                  controller: _controller,
                                  itemCount: protocolsList.length + 1,
                                  onPageChanged: (index) {
                                    ref
                                        .read(
                                            homeStateNotifierProvider.notifier)
                                        .changeIndex(index);
                                  },
                                  itemBuilder: (context, index) {
                                    if (index == protocolsList.length) {
                                      return HomeEmptyWidget(
                                        scanCallback: () {
                                          LogModule().eventReport(5, 11);
                                          addDeviceByScan();
                                        },
                                        addCallback: () {
                                          LogModule().eventReport(5, 10);
                                          addDevice();
                                        },
                                        isSecondPage: isSecondPage,
                                      );
                                    } else {
                                      return _buildItem(protocolsList[index],
                                          index, resource);
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                      (ref
                              .watch(homeStateNotifierProvider
                                  .select((value) => value.deviceList))
                              .isNotEmpty
                          ? Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: _buildPageIndicator(style, resource))
                          : const SizedBox.shrink()),
                      Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: _buildHeader()),
                    ])),
              );
            });
          },
        ),
      ],
    );
  }
}

class MyCustomLayoutDelegate extends SingleChildLayoutDelegate {
  final Size screenSize;

  MyCustomLayoutDelegate({required this.screenSize});

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: screenSize.width,
      maxWidth: screenSize.width,
      minHeight: screenSize.height,
      maxHeight: screenSize.height,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0, 0);
  }

  @override
  bool shouldRelayout(MyCustomLayoutDelegate oldDelegate) => false;
}
