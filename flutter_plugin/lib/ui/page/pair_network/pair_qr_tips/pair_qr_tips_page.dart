import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_back_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_tips/pair_qr_tips_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:lottie/lottie.dart';

class PairQrTipsPage extends BasePage {
  static const String routePath = '/pair_qr_tips_page';

  const PairQrTipsPage({super.key});

  @override
  PairQrTipsPageState createState() {
    return PairQrTipsPageState();
  }
}

class PairQrTipsPageState extends BasePageState
    with IotPairNetInfoStepMixin, TickerProviderStateMixin, PairNetBackHelper {
  @override
  String get centerTitle => 'text_connect_device_hotspot'.tr();

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
  void initData() {
    super.initData();
    ref.read(pairQrTipsStateNotifierProvider.notifier).initData();
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
           ref.read(pairQrTipsStateNotifierProvider.notifier).initData();
          });
        }
      }
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final manualAnimPath =
        ref.watch(pairQrTipsStateNotifierProvider).manualAnimPath;
    return Container(
      color: style.bgBlack,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              color: style.bgBlack,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  manualAnimPath.isNotEmpty
                      ? Lottie.asset(
                          controller: _controller,
                          manualAnimPath,
                          width: double.infinity,
                          height: (MediaQuery.of(context).size.width - 40) *
                              240 /
                              350,
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
                        )
                      : Container(height: 240),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: DMButton(
                      onClickCallback: (context) {
                        _controller.reset();
                        _controller.forward();
                      },
                      backgroundColor: Colors.transparent,
                      width: 32,
                      height: 32,
                      prefixWidget: Image.asset(
                          resource.getResource('ic_pair_connect_anim_play')),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.only(top: 20, right: 32, left: 32),
                child: Center(
                  child: Text('text_qr_connect_tips'.tr(), style: style.secondStyle(),),
                )),
            Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 32, left: 32, bottom: 32),
                child: DMCommonClickButton(
                    disableBackgroundGradient: style.disableBtnGradient,
                    disableTextColor: style.disableBtnTextColor,
                    textColor: style.enableBtnTextColor,
                    backgroundGradient: style.confirmBtnGradient,
                    borderRadius: style.buttonBorder,
                    text: 'text_connect_device_hotspot'.tr(),
                    onClickCallback: () async {
                      // 直接跳转连接机器热点
                      await AppRoutes().push(PairConnectPage.routePath);
                    })),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: PairNetIndicatorWidget(
                  ref.watch(pairQrTipsStateNotifierProvider
                      .select((value) => value.currentStep)),
                  ref.watch(pairQrTipsStateNotifierProvider
                      .select((value) => value.totalSteps))),
            ),
          ]),
    );
  }
}
