import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest/product_suggest_page.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'feature/network_diagnostics/network_diagnostics_page.dart';

/// 设备离线提示页面，检测
// 1、检测wifi是否链接
// 2、检测wifi是否有网
// 3、解析http的域名，ping ip
// 4、解析mqtt域名，ping ip
// 5、检测获取到的wifi强度
///
class DeviceOfflineTipsPage extends BasePage {
  static const String routePath = '/device_offline_tips_page';

  const DeviceOfflineTipsPage({super.key});

  @override
  DeviceOfflineTipsPageState createState() => DeviceOfflineTipsPageState();
}

class DeviceOfflineTipsPageState extends BasePageState {
  final Map<String, List> _listData = {};
  final Map<String, List> _vacuumData = {
    'device_offline_tip_title1'.tr(): [
      'device_offline_tip_title1_content1'.tr(),
      'device_offline_tip_title1_content2'.tr(),
      'device_offline_tip_title1_content3'.tr()
    ],
    'device_offline_tip_title2'.tr(): [
      'device_offline_tip_title2_content1'.tr(),
      'device_offline_tip_title2_content2'.tr(),
      'device_offline_tip_title2_content3'.tr()
    ],
    'device_offline_tip_title3'.tr(): [
      'device_offline_tip_title3_content1'.tr()
    ],
  };
  final Map<String, List> _mowerData = {
    'mower_offline_tip_title1'.tr(): [
      'mower_offline_tip_title1_content1'.tr(),
      'mower_offline_tip_title1_content2'.tr(),
      'mower_offline_tip_title1_content3'.tr(),
      'mower_offline_tip_title1_content4'.tr(),
      'mower_offline_tip_title1_content5'.tr(),
    ],
    'mower_offline_tip_title2'.tr(): [
      'mower_offline_tip_title2_content1'.tr(),
      'mower_offline_tip_title2_content2'.tr(),
    ],
    'mower_offline_tip_title3'.tr(): [
      'mower_offline_tip_title3_content1'.tr(),
      'mower_offline_tip_title3_content2'.tr(),
    ],
    'mower_offline_tip_title4'.tr(): [
      'mower_offline_tip_title4_content1'.tr(),
      'mower_offline_tip_title4_content2'.tr(),
      'mower_offline_tip_title4_content3'.tr(),
    ],
    'mower_offline_tip_title5'.tr(): [
      'mower_offline_tip_title5_content1'.tr(),
      'mower_offline_tip_title5_content2'.tr(),
      'mower_offline_tip_title5_content3'.tr(),
    ],
    'mower_offline_tip_title6'.tr(): [
      'mower_offline_tip_title6_content1'.tr(),
      'mower_offline_tip_title6_content2'.tr(),
      'mower_offline_tip_title5_content3'.tr(),
    ],
  };
  StreamSubscription<List<ConnectivityResult>>?
  _onConnectivityChangedSubscription;

  @override
  void initPageState() {
    centerTitle = 'text_device_offline'.tr();
  }

  @override
  void initState() {
    super.initState();
    _onConnectivityChangedSubscription =
        Connectivity().onConnectivityChanged.listen((event) {
          if (event.last == ConnectivityResult.wifi) {
            LogUtils.i('sunzhibin -- onConnectivityChanged --1-- $event');
          } else {
            LogUtils.i('sunzhibin -- onConnectivityChanged --2-- $event');
          }
        });
  }

  @override
  void initData() {
    super.initData();
    var deviceType = GoRouterState
        .of(context)
        .extra as DeviceType;
    if (deviceType == DeviceType.mower) {
      _listData.clear();
      _listData.addAll(_mowerData);
    } else {
      _listData.clear();
      _listData.addAll(_vacuumData);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChangedSubscription?.cancel();
    _onConnectivityChangedSubscription = null;
  }

  /// 跳转到网络诊断页面
  Future<void> gotoDiagnostics() async {
    // wifi连接
    var isWifiConnected = false;
    if (Platform.isAndroid) {
      isWifiConnected = await WiFiForIoTPlugin.isConnected();
    } else {
      List<ConnectivityResult> result =
      await Connectivity().checkConnectivity();
      isWifiConnected = result.last == ConnectivityResult.wifi;
    }
    if (!isWifiConnected) {
      showConfirmDialog(
        title: 'kind_tip'.tr(),
        content: 'network_diagnostics_wifi_tips'.tr(),
        confirmContent: 'know'.tr(),
        confirmCallback: () {},
      );
      return;
    }

    // 跳转到网络诊断页面
    showAlertDialog(
      title: 'kind_tip'.tr(),
      content:
      '${'network_diagnostics_wifi_tips_1'
          .tr()}\n${'network_diagnostics_wifi_tips_2'.tr()}',
      cancelContent: 'cancel'.tr(),
      confirmContent: 'dialog_determine'.tr(),
      confirmCallback: () async {
        /// 跳转到网络诊断页面
        await AppRoutes().push(NetworkDiagnosticsPage.routePath);
      },
    );
  }

  @override
  Widget buildBody(BuildContext context, StyleModel style,
      ResourceModel resource) {
    return Container(
      color: style.bgGray,
      child: Column(
        children: [
          Expanded(
            child: GroupListView(
              itemBuilder: (context, index) {
                String content =
                _listData.values.toList()[index.section][index.index];
                return Container(
                  margin: const EdgeInsets.only(top: 12, left: 24, right: 24)
                      .withRTL(context),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(style.cellBorder),
                      color: style.bgWhite),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin:
                        const EdgeInsets.only(right: 8).withRTL(context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: style.gray3,
                        ),
                      ),
                      Expanded(child: Text(content, style: style.secondStyle()))
                    ],
                  ),
                );
              },
              sectionsCount: _listData.keys
                  .toList()
                  .length,
              groupHeaderBuilder: (context, section) {
                return Padding(
                    padding:
                    const EdgeInsets.only(left: 24, right: 24, top: 20),
                    child: Text(_listData.keys.toList()[section],
                        style: style.mainStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)));
              },
              countOfItemInSection: (section) {
                return _listData.values.toList()[section].length;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: true,
                  child: Text(
                    'network_diagnostics'.tr(),
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        height: 1.2,
                        color: style.brandGoldColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ).onClick(gotoDiagnostics),
                ),
                DMCommonClickButton(
                  height: 48,
                  borderRadius: style.buttonBorder,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin: const EdgeInsets.only(top: 16),
                  disableBackgroundGradient: style.disableBtnGradient,
                  disableTextColor: style.disableBtnTextColorGold,
                  textColor: style.enableBtnTextColorGold,
                  backgroundGradient: style.brandColorGradient,
                  fontsize: 16,
                  fontWidget: FontWeight.bold,
                  onClickCallback: () async {
                    // 跳转到配网页面
                    await UIModule()
                        .generatePairNetEngine(QrScanPage.routePath);
                  },
                  text: 'text_reconnect'.tr(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
