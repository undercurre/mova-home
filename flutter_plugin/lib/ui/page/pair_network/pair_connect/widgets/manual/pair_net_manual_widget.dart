import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_back_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_code/pair_qr_code_page.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';

class PairNetManualWidget extends ConsumerStatefulWidget {
  final String wifiName;

  const PairNetManualWidget(
    this.wifiName, {
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PairNetManualWidgetState();
  }
}

class _PairNetManualWidgetState extends ConsumerState<PairNetManualWidget>
    with TickerProviderStateMixin, PairNetBackHelper {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return buildManualWidget(context, style, resource);
    });
  }

  Widget buildManualWidget(
    BuildContext context,
    StyleModel style,
    ResourceModel resource,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(style.cellBorder),
                child: Lottie.asset(
                  controller: _controller,
                  ref.watch(pairConnectStateNotifierProvider).manualAnimPath,
                  width: double.infinity,
                  height: (MediaQuery.of(context).size.width - 40) * 240 / 350,
                  fit: BoxFit.cover,
                  repeat: false,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                    _controller.forward();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 240,
                    );
                  },
                ),
              ),
              PositionedDirectional(
                end: 8,
                bottom: 8,
                child: Image.asset(
                        width: 32,
                        height: 32,
                        resource.getResource('ic_pair_connect_anim_play'))
                    .onClick(() {
                  _controller.reset();
                  _controller.forward();
                }),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 28, top: 24, right: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'text_current_wifi_prefix'.tr()}${widget.wifiName}',
                style: TextStyle(
                    color: style.carbonBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 35),
              DMFormatRichText(
                  type: 2,
                  normalTextStyle: TextStyle(
                    color: style.gray3,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  clickTextStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: style.pairProcessActiveColor,
                  ),
                  content: 'text_manual_connect_1'.tr(
                    args: [
                      'mova-${IotPairNetworkInfo().product?.deviceType.name}_xxx'
                    ],
                  ),
                  indexs: [
                    'mova-${IotPairNetworkInfo().product?.deviceType.name}_xxx'
                  ],
                  richCallback: (index, key, content) {}),
              const SizedBox(height: 12),
              Text(
                'text_manual_connect_2'.tr(),
                style: TextStyle(
                  color: style.gray3,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: true,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'text_not_found'.tr(args: [
                          'mova-${IotPairNetworkInfo().product?.deviceType.name}_xxx'
                        ]),
                        style: TextStyle(
                          fontSize: 14,
                          color: style.gray3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Image.asset(
                            resource.getResource('icon_arrow_right_12')),
                      ),
                    ]).onClick(() {
                  gotoTriggerApPage();
                }),
              ),
              Visibility(
                visible: true,
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: DMCommonClickButton(
                        backgroundGradient: style.confirmBtnGradient,
                        disableBackgroundGradient: style.disableBtnGradient,
                        textColor: style.confirmBtnTextColor,
                        disableTextColor: style.disableBtnTextColor,
                        borderRadius: style.buttonBorder,
                        text: 'text_connect_device_hotspot'.tr(),
                        onClickCallback: () {
                          gotoSettingWifi();
                        })),
              ),
              Visibility(
                visible: IotPairNetworkInfo().product?.extendScType.contains(
                        IotDeviceExtendScType.QR_CODE_V2.extendSctype) ??
                    false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: DMCommonClickButton(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundGradient: style.cancelBtnGradient,
                    borderRadius: style.buttonBorder,
                    text: 'text_to_qrcode_pair'.tr(),
                    disableBackgroundGradient: style.disableBtnGradient,
                    disableTextColor: style.disableBtnTextColor,
                    textColor: style.lightDartBlack,
                    onClickCallback: () {
                      var index = Navigator.of(context).widget.pages.indexWhere(
                          (element) =>
                              element.name == PairQrCodePage.routePath);
                      if (index == -1) {
                        AppRoutes().replace(PairQrCodePage.routePath);
                      } else {
                        AppRoutes().popUntil(path: PairQrCodePage.routePath);
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 34),
                  child: PairNetIndicatorWidget(
                    IotPairNetworkInfo().totalStep,
                    IotPairNetworkInfo().totalStep,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void gotoSettingWifi() {
    Platform.isIOS
        ? const OpenSettingsPlusIOS().wifi()
        : const OpenSettingsPlusAndroid().wifi();
    ref
        .read(pairConnectStateNotifierProvider.notifier)
        .updateConnectDialogShowState(true);
  }
}
