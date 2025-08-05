import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_ble_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_bt_wifi_state_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_device_cache_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_device_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_wifi_scanner_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_bt_open_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_bt_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_location_service_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_open_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_uistate.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_device_ap_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

/// 扫描设备热点页面
class NearbyConnectPage extends BasePage {
  static const routePath = '/nearby_connect';

  const NearbyConnectPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NearbyConnectPageState();
}

class _NearbyConnectPageState extends BasePageState
    with
        IotScanPermissionRequestMixin,
        IotScanDeviceCacheMixin,
        IotBtWifiStateMixin,
        IotBleScannerMixin,
        IotWiFiScannerMixin,
        IotScanDeviceMixin,
        TickerProviderStateMixin,
        IotPairNetInfoStepMixin,
        PairNetDeviceApMixin {
  AnimationController? _animationController;
  Tween<double>? tweenAnimation;

  @override
  String get centerTitle => 'text_connect_device_hotspot'.tr();

  @override
  CommonStepChain initStepChain() {
    return CommonStepChain()
      ..configureStepChain(Platform.isAndroid
          ? _btCommonStep()
          : [
        StepBtOpenRequestDialog(), // StepBtPermissionRequestDialog(),
      ]);
  }

  /// 判断如果只支持WIFI，则只需要校验Wi-Fi权限，无需关注蓝牙权限
  /// 如果支持WIFI_BLE 则校验Wi-Fi和蓝牙权限
  /// 如果支持BLE，则考虑到后续需要增加GPS锁区，所以需要同时打开蓝牙和Wi-Fi权限
  List<CommonStep> _btCommonStep() {
    if (IotPairNetworkInfo().product?.scType == IotScanType.WIFI.scanType) {
      return [
        StepWifiPermissionRequestDialog(),
        StepWifiLocationServiceDialog(),
        StepWifiOpenRequestDialog(),
      ];
    } else {
      return [
        StepWifiPermissionRequestDialog(),
        StepWifiLocationServiceDialog(),
        StepBtPermissionRequestDialog(),
        StepWifiOpenRequestDialog(),
        StepBtOpenRequestDialog(),
      ];
    }
  }

  @override
  void initData() {
    final pairNetworkHelper =
        AppRoutes().getGoRouterStateExtra<IotPairNetworkInfo>(context);
    ref
        .read(nearbyConnectStateNotifierProvider.notifier)
        .initData(pairNetworkHelper);
    stepChainCheckPermission();
  }

  @override
  void onAppResumeAndActive() {
    stepChainCheckPermission();
  }

  @override
  void onDeviceApConnect(String ap) async {
    /// 跳转到下一步，发数据
    IotPairNetworkInfo().deviceSsid = ap;
    await AppRoutes().push(PairConnectPage.routePath, extra: {'ap': ap});
  }

  @override
  void updateScanDeviceList(List<IotDevice> scanList) {
    if (mounted) {
      ref
          .read(nearbyConnectStateNotifierProvider.notifier)
          .updataScanDeviceList(scanList);
    }
  }

  var lastShowToastTime = 0;

  @override
  void toastNetError() {
    var millisecondsSinceEpoch2 = DateTime.now().millisecondsSinceEpoch;
    if (millisecondsSinceEpoch2 - lastShowToastTime < 5000) {
      return;
    }
    lastShowToastTime = millisecondsSinceEpoch2;
    showToast('no_net_check_state'.tr());
  }

  @override
  void onStartCallback() {
    LogUtils.i('-----sunzhibin------ onStartCallback ----------- :$this');
    if (_animationController?.isAnimating == true ||
        ref.watch(nearbyConnectStateNotifierProvider
            .select((value) => value.scanList.isNotEmpty))) {
      return;
    }
    LogUtils.i('-----sunzhibin------ onStopCallback start----------- :$this');
    _animationController ??=
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
    tweenAnimation = Tween<double>(begin: 0, end: 1);
    _animationController?.addListener(() {
      if (_animationController?.isAnimating == true) {
        var value = tweenAnimation?.evaluate(_animationController!);
        ref
            .read(nearbyConnectStateNotifierProvider.notifier)
            .updateProgress(value!);
      }
    });

    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController?.reset();
        stopScanBt();
        ref
            .read(nearbyConnectStateNotifierProvider.notifier)
            .updatescaningResult(ScanState.ScanStop, 1.0);
      }
    });
    _animationController?.forward();
  }

  @override
  void onStopCallback(StepId stepId) {
    LogUtils.i('-----sunzhibin------ onStopCallback ----------- :$this');

    if (_animationController?.isAnimating == true) {
      _animationController?.stop(canceled: true);
      _animationController?.reset();
    }

    /// 重新扫描，♻️循环扫，不停扫
    if (ref.read(nearbyConnectStateNotifierProvider
            .select((value) => value.scanList.isNotEmpty)) &&
        isVisible()) {
      ref
          .read(nearbyConnectStateNotifierProvider.notifier)
          .updatescaningResult(ScanState.Scaning, 0);
      startScanDevice(isScanningSkip: false);
    } else {
      ref
          .read(nearbyConnectStateNotifierProvider.notifier)
          .updatescaningResult(ScanState.ScanStop, 1.0);
    }

    /// 如果选中的配网类型，只支持蓝牙，且蓝牙权限未实现，则 pop
    if (IotPairNetworkInfo().product?.scType == IotScanType.BLE.scanType) {
      /// 蓝牙权限未开启
      if (stepId == StepId.STEP_BT_PERMISSION_REQUEST_DIALOG ||
          stepId == StepId.STEP_BT_OPEN_REQUEST_DIALOG) {
        AppRoutes().pop();
      }
    }
  }

  @override
  void dispose() {
    _animationController?.stop(canceled: true);
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.active) {
      /// 清理一下扫描到的缓存
      if (ref.watch(nearbyConnectStateNotifierProvider.select(
          (value) => value.scanList.isNotEmpty && value.progress != 1))) {
        startScanDevice(isScanningSkip: false);
      }
      // 判断没有网络,则toast 提示
    } else if (event == LifecycleEvent.inactive) {
      stopScanDevice();
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    backgroundColor = style.bgGray;
    final scanList = ref.watch(
        nearbyConnectStateNotifierProvider.select((value) => value.scanList));
    final scanState = ref.watch(
        nearbyConnectStateNotifierProvider.select((value) => value.scanState));

    if (scanList.isNotEmpty) {
      return scanList.length == 1
          ? _buildScanOneWidget(context, style, resource, scanList.first!)
          : _buildScanMultiWidget(context, style, resource, scanList);
    } else {
      if (scanState == ScanState.Scaning) {
        return _buildScanningWidget(context, style, resource);
      } else {
        return _buildEmptyWidget(context, style, resource);
      }
    }
  }

  String extractSubstring(String input) {
    int underscoreIndex = input.indexOf('_');
    if (underscoreIndex != -1) {
      return input.substring(underscoreIndex);
    }
    return input;
  }

  Widget _buildScanOneWidget(BuildContext context, StyleModel style,
      ResourceModel resource, IotDevice iotDevice) {
    String devicename = (iotDevice.product?.displayName ?? '') +
        extractSubstring(iotDevice.wifiSsid ?? '');

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (iotDevice.product?.mainImage?.imageUrl ?? '').isEmpty
                  ? Image.asset(
                      resource.getResource('ic_placeholder_robot'),
                      height: 254,
                      width: 254,
                    )
                  : CachedNetworkImage(
                      imageUrl: iotDevice.product?.mainImage?.imageUrl ?? '',
                      width: 254,
                      height: 254,
                    ),
              const SizedBox(
                height: 43,
              ),
              SizedBox(
                width: 254,
                child: Text(
                  devicename,
                  style: style.mainStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: DMCommonClickButton(
            backgroundGradient: style.confirmBtnGradient,
            disableBackgroundGradient: style.disableBtnGradient,
            borderRadius: style.buttonBorder,
            enable: true,
            text: 'next'.tr(),
            onClickCallback: () async {
              ref
                  .watch(nearbyConnectStateNotifierProvider.notifier)
                  .selectedIotDevice(iotDevice);
              // 下一步
              await ref
                  .watch(nearbyConnectStateNotifierProvider.notifier)
                  .gotoNextPage();
              clearAllCache();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: PairNetIndicatorWidget(
              ref.watch(nearbyConnectStateNotifierProvider
                  .select((value) => value.currentStep)),
              ref.watch(nearbyConnectStateNotifierProvider
                  .select((value) => value.totalStep))),
        ),
      ],
    );
  }

  Widget _buildScanMultiWidget(BuildContext context, StyleModel style,
      ResourceModel resource, List<IotDevice> scannedList) {
    return Container(
      color: style.bgBlack,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 156 / 186,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var iotDevice = scannedList[index];
                  return InkWell(
                      onTap: () {
                        ref
                            .watch(nearbyConnectStateNotifierProvider.notifier)
                            .selectedIotDevice(iotDevice);
                      },
                      child: _buildProductGridItem(
                          context, style, resource, iotDevice!));
                },
                itemCount: scannedList.length,
              ),
            ),
            DMCommonClickButton(
              backgroundGradient: style.confirmBtnGradient,
              disableBackgroundGradient: style.disableBtnGradient,
              borderRadius: style.buttonBorder,
              enable: ref.watch(nearbyConnectStateNotifierProvider
                  .select((value) => value.selectedDevice != null)),
              text: 'next'.tr(),
              onClickCallback: () async {
                await AppRoutes().push(PairConnectPage.routePath);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 32),
              child: PairNetIndicatorWidget(
                  ref.watch(nearbyConnectStateNotifierProvider
                      .select((value) => value.currentStep)),
                  ref.watch(nearbyConnectStateNotifierProvider
                      .select((value) => value.totalStep))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGridItem(BuildContext context, StyleModel style,
      ResourceModel resource, IotDevice iotDevice) {
    String devicename = (iotDevice.product?.displayName ?? '') +
        extractSubstring(iotDevice.wifiSsid ?? '');
    const childAspectRatio = 156 / 186;
    final itemWidth = (MediaQuery.of(context).size.width - 32 - 32 - 14);
    final itemHeight = (itemWidth / 2) / childAspectRatio;
    return Container(
      decoration: BoxDecoration(
        color: style.bgWhite,
        borderRadius: BorderRadius.circular(style.cellBorder),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: (iotDevice.product?.mainImage?.imageUrl ?? '').isEmpty ==
                        true
                    ? Image.asset(
                        resource.getResource('ic_placeholder_robot'),
                        width: itemWidth - 20 - 20,
                        height: itemHeight - 15 - 14 - 34 - 14,
                      )
                    : CachedNetworkImage(
                        imageUrl: iotDevice.product?.mainImage?.imageUrl ?? '',
                        width: itemWidth - 20 - 20,
                        height: itemHeight - 15 - 14 - 34 - 14,
                      ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
                child: Text(
                  devicename,
                  style: style.mainStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Image.asset(
              resource.getResource(ref.watch(nearbyConnectStateNotifierProvider
                      .select((value) => value.selectedDevice == iotDevice))
                  ? 'ic_agreement_selected'
                  : 'ic_agreement_unselect'),
              width: 20,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScanningWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(children: [
          Image.asset(
            resource.getResource('ic_placeholder_device_scan'),
            width: 264,
            height: 264,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
                value: ref
                    .watch(nearbyConnectStateNotifierProvider
                        .select((value) => value.progress))
                    .toDouble(),
                minHeight: 4,
                backgroundColor: style.loadingInActiveColor,
                valueColor:
                    AlwaysStoppedAnimation<Color>(style.loadingActiveColor),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: Text('text_search_nearby_robot'.tr(),
                    style: style.mainStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('text_close_to_device_connect'.tr(),
                    style: style.secondStyle(fontSize: 14)),
              )
            ],
          ),
          const Spacer(),
        ]));
  }

  Widget _buildEmptyWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(children: [
          Image.asset(
            resource.getResource('ic_placeholder_device_scan_nothing'),
            width: 264,
            height: 264,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: Text('tips_device_scan_failed'.tr(),
                    textAlign: TextAlign.center,
                    style: style.mainStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const Spacer(),
          Visibility(
            visible: ref.watch(nearbyConnectStateNotifierProvider.select(
                (value) =>
                    value.scanList.isEmpty &&
                    IotPairNetworkInfo().product?.scType !=
                        IotScanType.BLE.name)),
            child: DMCommonClickButton(
                borderRadius: style.buttonBorder,
                disableBackgroundGradient: style.disableBtnGradient,
                disableTextColor: style.disableBtnTextColor,
                textColor: style.enableBtnTextColor,
                backgroundGradient: style.confirmBtnGradient,
                text: 'text_connect_by_manual'.tr(),
                onClickCallback: () {
                  // 手动连接,跳转到手动连接页面
                  ref
                      .watch(nearbyConnectStateNotifierProvider.notifier)
                      .selectedIotDevice(null);
                  ref
                      .watch(nearbyConnectStateNotifierProvider.notifier)
                      .gotoNextPage(isManualConnect: true);
                  clearAllCache();
                }),
          ),
          Visibility(
            visible: ref.watch(nearbyConnectStateNotifierProvider
                .select((value) => value.scanList.isEmpty)),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 48),
              child: DMCommonClickButton(
                  width: double.infinity,
                  height: 48,
                  borderRadius: style.buttonBorder,
                  disableBackgroundGradient: style.disableBtnGradient,
                  textColor: style.cancelBtnTextColor,
                  backgroundGradient: style.cancelBtnGradient,
                  borderWidth: 0,
                  fontsize: 14,
                  text: 'text_armap_rescan'.tr(),
                  onClickCallback: () {
                    // 重新扫描
                    ref
                        .watch(nearbyConnectStateNotifierProvider.notifier)
                        .updatescaningResult(ScanState.Scaning, 0.0);
                    startScanDevice(isScanningSkip: false);
                  }),
            ),
          ),
        ]));
  }
}
