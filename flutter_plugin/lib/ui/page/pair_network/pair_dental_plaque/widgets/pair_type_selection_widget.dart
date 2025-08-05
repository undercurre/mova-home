import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_connect_method.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/guidance/pair_mobile_hotspot_guidance_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search/pair_search_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_page.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PairTypeSelectionWidget extends ConsumerStatefulWidget {
  final String productName;
  final List<PairGuideModel> guides;

  const PairTypeSelectionWidget(
    this.productName,
    this.guides, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PairTypeSelectionWidgetState();
  }
}

class _PairTypeSelectionWidgetState
    extends ConsumerState<PairTypeSelectionWidget> {
  @override
  void initState() {
    super.initState();
  }

  /// 选择设备连接方式 - WiFi
  void onSelectConnectionByWifi() {
    IotPairNetworkInfo().pairConnectMethod = PairConnectMethod.WIFI;
    IotPairNetworkInfo()
        .calculateTotalStepForConnectMethod(PairConnectMethod.WIFI);
    AppRoutes().push(RouterPasswordPage.routePath, extra: widget.guides);
    LogUtils.d('onSelectConnectionByWifi');
  }

  /// 选择设备连接方式 - 手机热点
  void onSelectConnectionByHotspot() {
    IotPairNetworkInfo().pairConnectMethod = PairConnectMethod.HOTSPOT;
    IotPairNetworkInfo()
        .calculateTotalStepForConnectMethod(PairConnectMethod.HOTSPOT);
    AppRoutes().push(PairMobileHotspotGuidancePage.routePath);
    LogUtils.d('onSelectConnectionByHotspot');
  }

  ///连接设备方式 UI组件
  Widget buildConnectionMethod({
    required String title,
    required String imageName,
    required String description,
    required VoidCallback onTap,
    required StyleModel style,
    required ResourceModel resource,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: style.bgGray,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            width: 130,
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: style.textNormal,
                    fontSize: style.largeText,
                  ),
                ),
                Image(
                  image: AssetImage(resource.getResource(imageName)),
                  width: 48,
                  height: 46,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 110,
            child: Text(
              // ✅ 修改此处
              description,
              style: TextStyle(
                color: style.textSecond,
                fontSize: style.smallText,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              // ✅ 显示省略号
              maxLines: 2, // ✅ 限制最大行数
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: style.bgGray,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Text(
                    widget.productName,
                    style: TextStyle(
                        color: style.textSecond,
                        fontSize: style.largeText,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                const SizedBox(height: 50),
                Stack(
                  children: [
                    Visibility(
                      visible: false, //TODO 后续可能需要打开暂时不显示
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          child: Image(
                            fit: BoxFit.cover, // 根据实际需求调整缩放模式
                            image: AssetImage(
                              resource
                                  .getResource('ic_pair_search_dental_plaque'),
                            ),
                            height: 429,
                            width: 98,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: style.bgWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin:
                          const EdgeInsets.only(left: 35, right: 35, top: 76),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Text(
                              'text_select_the_device_connection_method'.tr(),
                              style: TextStyle(
                                  color: style.textMain,
                                  fontSize: style.largeText,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildConnectionMethod(
                                  title: 'Wi-Fi'.tr(),
                                  imageName: 'ic_pair_search_wifi',
                                  description: 'text_use_when_home_wifi'.tr(),
                                  onTap: onSelectConnectionByWifi,
                                  style: style,
                                  resource: resource),
                              buildConnectionMethod(
                                  title: 'text_mobile_hotspot'.tr(),
                                  imageName: 'ic_pair_search_hotspot',
                                  description:
                                      'text_use_when_using_public_wifi'.tr(),
                                  onTap: onSelectConnectionByHotspot,
                                  style: style,
                                  resource: resource),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: PairNetIndicatorWidget(
                      ref.watch(pairSearchStateNotifierProvider
                          .select((value) => value.currentStep)),
                      ref.watch(pairSearchStateNotifierProvider
                          .select((value) => value.totalStep)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
