import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_bt_wifi_state_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_location_service_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/hotspot/pair_set_hotspot_check_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/hotspot/pair_set_hotspot_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search_guide/pair_search_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/pair_net_check_mixin.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';

/// 设置热点页面
class PairSetHotspotPage extends BasePage {
  static const routePath = '/pair_set_hotspot';

  const PairSetHotspotPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PairSetHotspotPageState();
}

class _PairSetHotspotPageState extends BasePageState
    with
        CommonDialog,
        ResponseForeUiEvent,
        IotBtWifiStateMixin,
        IotScanPermissionRequestMixin,
        SetHotspotCheckMixin,
        CommonDialog,
        ResponseForeUiEvent,
        IotPairNetInfoStepMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _pwdController = TextEditingController();
  GlobalKey<DMTextFieldItemState> textFieldKey =
      GlobalKey<DMTextFieldItemState>();

  final FocusNode _focusNameNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  GlobalKey<DMTextFieldItemState> textFieldNameKey =
      GlobalKey<DMTextFieldItemState>();

  @override
  String get centerTitle => 'text_set_up_a_hotspot'.tr();

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
            ]);
  }

  @override
  void initData() {
    final pairGuides =
        AppRoutes().getGoRouterStateExtra<List<PairGuideModel>>(context);
    ref
        .watch(pairSetHotspotStateNotifierProvider.notifier)
        .initData(pairGuides ?? []);
    stepChainCheckPermission();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        pairSetHotspotStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
    ref.listen(
        pairSetHotspotStateNotifierProvider
            .select((value) => value.routerWifiName), (previous, next) {
      final routerWifipwd = ref.read(pairSetHotspotStateNotifierProvider
          .select((value) => value.routerWifipwd));
      _pwdController.text = routerWifipwd;
      final routerWifiName = ref.read(pairSetHotspotStateNotifierProvider
          .select((value) => value.routerWifiName));
      _nameController.text = routerWifiName ?? '';
    });

    ref.listen(
        pairSetHotspotStateNotifierProvider.select((value) => value.autoFocus),
        (previous, next) {
      if (!_focusNameNode.hasFocus) {
        _focusNameNode.requestFocus();
      }
    });
  }

  @override
  void onAppResumeAndActive() async {
    super.onAppResumeAndActive();
    await stepChainCheckPermission();

    /// 获取当前连接的Wi-Fi名称
    if (ref.exists(pairSetHotspotStateNotifierProvider)) {
      await ref
          .read(pairSetHotspotStateNotifierProvider.notifier)
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
    if (ref.exists(pairSetHotspotStateNotifierProvider)) {
      await ref
          .watch(pairSetHotspotStateNotifierProvider.notifier)
          .updatePageState();
    }
  }

  @override
  Future<void> onPermissionSuccess(StepEvent event) async {
    if (ref.exists(pairSetHotspotStateNotifierProvider)) {
      await ref
          .watch(pairSetHotspotStateNotifierProvider.notifier)
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
    return buildWifiConnectWidget(resource, style);
  }

  Widget buildWifiConnectWidget(ResourceModel resource, StyleModel style) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'text_explanation_of_supported_network_standards'.tr(),
              style: TextStyle(
                  color: const Color(0xFFFFB50A),
                  fontSize: style.largeText,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'hint_only_configure_for_the_first_time'.tr(),
              style: TextStyle(
                  color: style.textSecond,
                  fontSize: style.largeText,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 40),
            child: Text(
              'hint_fill_hotspot_and_password'.tr(),
              style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: style.secondary,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius:
                      BorderRadius.all(Radius.circular(style.viewBorder))),
              child: DMTextFieldItem(
                  controller: _nameController,
                  focusNode: _focusNameNode,
                  key: textFieldNameKey,
                  showBottomDivider: false,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.zero,
                  borderRadius: 0,
                  width: double.infinity,
                  height: 48,
                  showClear: false,
                  showPrivate: false,
                  obscureText: false,
                  maxLength: 20,
                  text: ref
                      .watch(pairSetHotspotStateNotifierProvider)
                      .routerWifiName,
                  placeText: 'hint_enter_hotspot_name'.tr(),
                  inputStyle: style.mainStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  onEditingComplete: (value) {},
                  onSubmitted: (value) {
                    ref
                        .read(pairSetHotspotStateNotifierProvider.notifier)
                        .inputRouterWifiName(value);
                  },
                  rightWidget: GestureDetector(
                    onTap: () => {
                      ref
                          .watch(pairSetHotspotStateNotifierProvider.notifier)
                          .gotoSettingSelectWifi()
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        resource.getResource('icon_arrow_right2'),
                        width: 7,
                        height: 13,
                      ),
                    ),
                  ),
                  onDismiss: () {
                    ref
                        .read(pairSetHotspotStateNotifierProvider.notifier)
                        .updatePwdAutoFocus(false);
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: style.bgWhite,
                  borderRadius:
                      BorderRadius.all(Radius.circular(style.viewBorder))),
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
                  maxLength: 20,
                  text: ref
                      .watch(pairSetHotspotStateNotifierProvider)
                      .routerWifipwd,
                  placeText: 'enter_pwd'.tr(),
                  inputStyle: style.mainStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  onEditingComplete: (value) {},
                  onChanged: (value) {
                    ref
                        .read(pairSetHotspotStateNotifierProvider.notifier)
                        .inputRouterPwd(value);
                  },
                  onDismiss: () {
                    ref
                        .read(pairSetHotspotStateNotifierProvider.notifier)
                        .updatePwdAutoFocus(false);
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'text_correct_pwd_tip'.tr(),
              style: style.secondStyle(),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => AppRoutes().pop(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'hint_how_to_view_hotspot_and_password'.tr(),
                  style: TextStyle(
                    color: style.textSecond,
                    fontSize: style.smallText,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  resource.getResource('icon_arrow_right2'),
                  width: 7,
                  height: 13,
                ),
              ],
            ),
          ),
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
                        color: const Color(0xFFFFB50A),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: DMCommonClickButton(
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              borderRadius: style.buttonBorder,
              enable: ref.watch(pairSetHotspotStateNotifierProvider
                  .select((value) => value.enableBtn)),
              text: 'text_immediately_connect_to_the_network'.tr(),
              onClickCallback: () async {
                await checkNetworkCondition();
              },
            ),
          ),
          Visibility(
            visible: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 32),
              child: PairNetIndicatorWidget(
                ref.watch(pairSetHotspotStateNotifierProvider
                    .select((value) => value.currentStep)),
                ref.watch(pairSetHotspotStateNotifierProvider
                    .select((value) => value.totalStep)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
