import 'dart:async';

import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/uiconfig/base_uiconfig.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/widgets/dialog/connect_hotspot_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/widgets/pincode/pair_net_pincode_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_connect_method.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/eventbus_mixin.dart';
import 'config/smart_step_handle_message_mixin.dart';
import 'config/smart_step_lifecycle_mixin.dart';
import 'mixin/pair_net_back_helper.dart';
import 'mixin/pair_net_device_ap_mixin.dart';
import 'widgets/connect/pair_net_connect_widget.dart';
import 'widgets/manual/pair_net_manual_widget.dart';

/// 配网页面
class PairConnectPage extends BasePage {
  static const routePath = '/pair_connect';

  const PairConnectPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PairConnectPageState();
  }
}

class _PairConnectPageState extends BasePageState
    with
        EventBusMixin<SmartStepEvent>,
        SmartStepHandleMessageMixin,
        SmartStepLifecycleMixin,
        IotPairNetInfoStepMixin,
        PairNetBackHelper,
        PairNetDeviceApMixin {
  @override
  void initState() {
    super.initState();
    subscribeMsg();
  }

  @override
  void dispose() {
    SmartStepHelper().dispose();
    unSubscribeMsg();
    super.dispose();
  }

  @override
  void initData() {
    super.initData();
    final arguments =
        AppRoutes().getGoRouterStateExtra<Map<String, dynamic>>(context);
    ref.read(pairConnectStateNotifierProvider.notifier).initData();
    SmartStepHelper().startFirstPage(eventBus, arguments: arguments ?? {});
  }


  @override
  void addObserver() {
    super.addObserver();
    // 监听状态变化.因为主题切换会清空pairQrTipsStateNotifierProvider的数据
    ref.listen(appThemeStateNotifierProvider, (previous, next) {
      // 监听状态变化
      if (mounted) {
        if (previous != next) {
          Future.delayed(const Duration(milliseconds: 500), () {
           ref.read(pairConnectStateNotifierProvider.notifier).initData();
          });
        }
      }
    });
  }

  @override
  Future<void> onAppResumeAndActive() async {
    super.onAppResumeAndActive();
    // 如果是2501相关设备 则需要获取当前配网方式
    PairConnectMethod connectMethod = IotPairNetworkInfo().pairConnectMethod;
    // 如果是热点配网，则不需要弹窗提示连接WiFi的操作
    if (connectMethod == PairConnectMethod.HOTSPOT){
      return;
    }
    bool isShowDialog =
        ref.read(pairConnectStateNotifierProvider).isShowConnectDialog;
    var isDeviceAp = await checkWifi(isCheckGatewayIp: false);
    if (!isDeviceAp &&
        SmartStepHelper().isCurrentManualStep() &&
        isShowDialog) {
      showConnectHotspotDialog();
    }
  }

  @override
  Future<void> handleMessage(SmartStepEvent event) async {
    final ret = await handleUIMessage(event);
    if (!ret) {
      SmartStepHelper().handleMessage(event);
    }
  }

  @override
  PreferredSizeWidget buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: ref.watch(pairConnectStateNotifierProvider).navTitle.tr(),
      bgColor: style.bgGray,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          onTitleLeftClick();
        }
      },
    );
  }

  void onTitleLeftClick() {
    onBackClick();
  }

  @override
  Future<bool> onBackClick() async {
    // 如果配网成功，则跳转到首页
    var onBackClick = await SmartStepHelper().onBackClick();
    if (onBackClick != null) {
      return onBackClick;
    } else {
      final status = ref.read(pairConnectStateNotifierProvider).step3Status;
      final status1 = ref.read(pairConnectStateNotifierProvider).step1Status;
      if (status == UIStep.STEP_STATUS_SUCCESS ||
          (
              /*配网码配网，只有第一步*/
              IotPairNetworkInfo().pairQRKey?.isNotEmpty == true &&
                  status1 == UIStep.STEP_STATUS_SUCCESS)) {
        /// 配网成功，跳转到首页
        gotoHomePage();
      } else {
        gotoPairNetBackToFirst();
      }

      return super.onBackClick();
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    backgroundColor = style.bgGray;
    return ref.watch(pairConnectStateNotifierProvider
            .select((value) => value.showPinCode))
        ? PairNetPinCodeWidget()
        : ref.watch(pairConnectStateNotifierProvider.select((value) =>
                value.step1Status == UIStep.STEP_STATUS_NONE &&
                value.step2Status == UIStep.STEP_STATUS_NONE &&
                value.step3Status == UIStep.STEP_STATUS_NONE))
            ? PairNetManualWidget(ref.watch(pairConnectStateNotifierProvider
                .select((value) => value.wifiName)))
            : PairNetConnectWidget(
                currentStep: IotPairNetworkInfo().totalStep,
                totalStep: IotPairNetworkInfo().totalStep,
                step1Status: ref.watch(pairConnectStateNotifierProvider
                    .select((value) => value.step1Status)),
                step2Status: ref.watch(pairConnectStateNotifierProvider
                    .select((value) => value.step2Status)),
                step3Status: ref.watch(pairConnectStateNotifierProvider
                    .select((value) => value.step3Status)),
                step1Text: ref.watch(pairConnectStateNotifierProvider.select(
                    (value) =>
                        value.step1Text ?? 'phone_connecting_device'.tr())),
                step2Text: ref.watch(pairConnectStateNotifierProvider.select(
                    (value) =>
                        value.step2Text ?? 'sending_data_to_device'.tr())),
                step3Text: ref.watch(pairConnectStateNotifierProvider.select(
                    (value) => value.step3Text ?? 'query_devices_state'.tr())),
              );
  }

  void showConnectHotspotDialog() {
    SmartDialog.dismiss();
    SmartDialog.show(
        clickMaskDismiss: false,
        animationType: SmartAnimationType.fade,
        onDismiss: () {
          ref
              .read(pairConnectStateNotifierProvider.notifier)
              .updateConnectDialogShowState(false);
        },
        builder: (context) {
          return ConnectHotspotDialog(
              ssid:
                  'mova-${IotPairNetworkInfo().product?.deviceType.name}_xxxx',
              animPath:
                  ref.watch(pairConnectStateNotifierProvider).manualAnimPath);
        });
  }
}
