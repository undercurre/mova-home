import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_bt_wifi_state_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_location_service_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';

import 'pair_net_check_mixin.dart';

/// Wi-Fi配网，输入路由器密码页面
class RouterPasswordPage extends BasePage {
  static const String routePath = '/router_password';

  const RouterPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RouterPasswordPageState();
  }
}

class _RouterPasswordPageState extends BasePageState
    with
        CommonDialog,
        ResponseForeUiEvent,
        IotBtWifiStateMixin,
        IotScanPermissionRequestMixin,
        PairNetCheckMixin,
        IotPairNetInfoStepMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _pwdController = TextEditingController();
  GlobalKey<DMTextFieldItemState> textFieldKey =
      GlobalKey<DMTextFieldItemState>();

  @override
  String get centerTitle => 'text_connect_router'.tr();

  @override
  CommonStepChain initStepChain() {
    return CommonStepChain()
      ..configureStepChain(Platform.isIOS
          ? [StepWifiPermissionRequestDialog()]
          : [
              StepWifiPermissionRequestDialog(),
              StepWifiLocationServiceDialog(dependenceStepIds: [
                StepId.STEP_WIFI_PERMISSION_REQUEST_DIALOG
              ]),
              // StepWifiOpenRequestDialog(dependenceStepIds: [
              //   StepId.STEP_WIFI_PERMISSION_REQUEST_DIALOG
              // ]),
            ]);
  }

  @override
  void initData() {
    final pairGuides =
        AppRoutes().getGoRouterStateExtra<List<PairGuideModel>>(context);
    ref
        .watch(routerPasswordStateNotifierProvider.notifier)
        .initData(pairGuides ?? []);
    stepChainCheckPermission();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        routerPasswordStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
    ref.listen(
        routerPasswordStateNotifierProvider
            .select((value) => value.routerWifiName), (previous, next) {
      final routerWifipwd = ref.read(routerPasswordStateNotifierProvider
          .select((value) => value.routerWifipwd));
      _pwdController.text = routerWifipwd;
    });

    ref.listen(
        routerPasswordStateNotifierProvider.select((value) => value.autoFocus),
        (previous, next) {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void onAppResumeAndActive() async {
    super.onAppResumeAndActive();
    await stepChainCheckPermission();

    /// 获取当前连接的Wi-Fi名称
    if (ref.exists(routerPasswordStateNotifierProvider)) {
      await ref
          .read(routerPasswordStateNotifierProvider.notifier)
          .updatePageState();
    }
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.visible) {
      if (onConnectivityChangedSubscription?.isPaused == true) {
        onConnectivityChangedSubscription?.resume();
      }
    } else if (event == LifecycleEvent.invisible) {
      onConnectivityChangedSubscription?.pause();
    }
  }

  @override
  Future<void> wifiStateChanged(bool isOpen, ConnectivityResult state) async {
    super.wifiStateChanged(isOpen, state);
    LogUtils.i('sunzhibin wifiStateChanged $this $isOpen');
    if (ref.exists(routerPasswordStateNotifierProvider)) {
      await ref
          .watch(routerPasswordStateNotifierProvider.notifier)
          .updatePageState();
    }
  }

  @override
  Future<void> onPermissionSuccess(StepEvent event) async {
    if (ref.exists(routerPasswordStateNotifierProvider)) {
      await ref
          .watch(routerPasswordStateNotifierProvider.notifier)
          .updatePageState();
    }
  }

  @override
  void onPermissionFail(StepId stepId) {
    super.onPermissionFail(stepId);
    // 授权失败，展示未获取网络UI。
    // ref.read(routerPasswordStateNotifierProvider.notifier).updatePageState();
    /// 不给权限，就pop
    AppRoutes().pop(context);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    backgroundColor = style.bgGray;
    final state = ref.watch(routerPasswordStateNotifierProvider);
    return state.isWifiOpen && state.routerWifiName == null
        ? Container()
        : state.isWifiOpen && state.routerWifiName?.isNotEmpty == true
            ? buildWifiConnectWidget(resource, style)
            : buildWifiNotConnect(resource, style);
  }

  Widget buildWifiConnectWidget(ResourceModel resource, StyleModel style) {
    return Container(
      color: style.bgBlack,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                resource.getResource('icon_connect_router_tips'),
                height: 156,
              ),
            ),
            Container(
              height: 48,
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius:
                      BorderRadius.all(Radius.circular(style.circular8))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ref.watch(routerPasswordStateNotifierProvider
                        .select((value) => value.routerWifiName ?? '')),
                    style: style.mainStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Image.asset(
                    resource.getResource('icon_arrow_right2'),
                    width: 7,
                    height: 13,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ).onClick(() {
                // 选择Wi-Fi
                ref
                    .watch(routerPasswordStateNotifierProvider.notifier)
                    .gotoSettingSelectWifi();
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: style.bgWhite,
                    borderRadius:
                        BorderRadius.all(Radius.circular(style.circular8))),
                child: DMTextFieldItem(
                    controller: _pwdController,
                    focusNode: _focusNode,
                    key: textFieldKey,
                    showBottomDivider: false,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.zero,
                    borderRadius: 0,
                    width: double.infinity,
                    height: 48,
                    showClear: true,
                    showPrivate: true,
                    obscureText: false,
                    text: ref
                        .watch(routerPasswordStateNotifierProvider)
                        .routerWifipwd,
                    placeText: 'enter_pwd'.tr(),
                    inputStyle: style.mainStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    onEditingComplete: (value) {},
                    onChanged: (value) {
                      ref
                          .read(routerPasswordStateNotifierProvider.notifier)
                          .inputRouterPwd(value);
                    },
                    onDismiss: () {
                      ref
                          .read(routerPasswordStateNotifierProvider.notifier)
                          .updatePwdAutoFocus(false);
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'text_correct_pwd_tip'.tr(),
                style: style.secondStyle(),
              ),
            ),

            ///
            Visibility(
              visible: ref.watch(routerPasswordStateNotifierProvider
                  .select((value) => value.isAfterSale)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(resource.getResource(ref.watch(
                              routerPasswordStateNotifierProvider
                                  .select((value) => value.isClearLog))
                          ? 'ic_agreement_selected'
                          : 'ic_agreement_unselect')),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(
                          '是否保留设备原有日志',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: style.textMain),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ).onClick(() {
                    ref
                        .read(routerPasswordStateNotifierProvider.notifier)
                        .toggleClearLog();
                  })),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(resource.getResource('icon_tips_help')),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'text_network_band_tip'.tr(),
                      style: TextStyle(
                          color: style.yellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            DMCommonClickButton(
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              borderRadius: style.buttonBorder,
              enable: ref.watch(routerPasswordStateNotifierProvider
                  .select((value) => value.enableBtn)),
              text: 'next'.tr(),
              onClickCallback: () async {
                // 下一步
                await checkNetworkCondition();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              child: PairNetIndicatorWidget(
                ref.watch(routerPasswordStateNotifierProvider
                    .select((value) => value.currentStep)),
                ref.watch(routerPasswordStateNotifierProvider
                    .select((value) => value.totalStep)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWifiNotConnect(ResourceModel resource, StyleModel style) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            resource.getResource('ic_tips_wifi_unreahable'),
            height: 240,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 37, left: 12, right: 12),
            child: Text(
              'text_not_connect_desc'.tr(),
              style:
                  style.clickStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(resource.getResource('icon_tips_help')),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'text_network_band_tip'.tr(),
                    style: TextStyle(
                        color: style.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20),
            child: DMCommonClickButton(
              borderRadius: style.buttonBorder,
              enable: true,
              text: 'text_connect_router'.tr(),
              onClickCallback: () {
                // 连接路由器
                ref
                    .watch(routerPasswordStateNotifierProvider.notifier)
                    .gotoSettingSelectWifi();
              },
            ),
          ),
        ],
      ),
    );
  }
}
