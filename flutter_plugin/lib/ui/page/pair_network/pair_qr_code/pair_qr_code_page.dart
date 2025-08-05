import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_code/pair_qr_code_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PairQrCodePage extends BasePage {
  static const String routePath = '/pair_qr_code_page';

  const PairQrCodePage({super.key});

  @override
  PairQrCodePageState createState() {
    return PairQrCodePageState();
  }
}

class PairQrCodePageState extends BasePageState with IotPairNetInfoStepMixin {
  @override
  String get centerTitle => 'text_pair_qrcode'.tr();

  @override
  void initData() {
    super.initData();
    ref.read(pairQrCodeStateNotifierProvider.notifier).initData();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(pairQrCodeStateNotifierProvider, (previous, next) {
      if (next.showLoading) {
        showLoading();
      } else {
        dismissLoading();
      }
    });
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    super.onLifecycleEvent(event);
    if (event == LifecycleEvent.active) {
      // 注意时序问题,需要解决;
      if (mounted) {
        ref
            .read(pairQrCodeStateNotifierProvider.notifier)
            .queryQRCodeKey()
            .catchError((e) {

        });
      }
    } else if (event == LifecycleEvent.inactive) {
      if (mounted) {
        dismissLoading();
      }
    }
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      children: [
        _buildQrCodeContent(context, style, resource),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildQrCodeContentBottom(context, style, resource),
                const SizedBox(
                  height: 20,
                ),
                _buildControlButton(context, style, resource),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildQrCodeContent(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: style.lightDartWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
      child: Center(
        child: ref.watch(pairQrCodeStateNotifierProvider).pairQRValue.isEmpty
            ? SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.width - 50,
              )
            : QrImageView(
                padding: const EdgeInsets.all(20),
                data: ref.watch(pairQrCodeStateNotifierProvider).pairQRValue,
                version: QrVersions.auto,
                size: MediaQuery.of(context).size.width - 50,
              ),
      ),
    );
  }

  Widget _buildQrCodeContentBottom(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var imgWidth = MediaQuery.of(context).size.width / 390 * 205;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: style.lightDartWhite,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(12))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                // 'text_qrcode_pair_desc1'.tr(),
                'text_qrcode_pair_desc1'.tr(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: style.textSecond),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                // 'text_qrcode_pair_desc2'.tr(),
                'text_qrcode_pair_desc2'.tr(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: style.textSecond),
              ),
            ),
          ),
          Image.asset(resource.getResource('ic_pair_qrcode_guide'),
              width: imgWidth,
              height: imgWidth / 205 * 96,
              fit: BoxFit.contain),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(resource.getResource(ref.watch(
                      pairQrCodeStateNotifierProvider
                          .select((value) => value.enableBtn))
                  ? 'ic_agreement_selected'
                  : 'ic_agreement_unselect')),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Text(
                  'text_has_heard_checkbox'.tr(),
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: style.textMain),
                ),
              ),
            ],
          ).onClick(() {
            ref
                .read(pairQrCodeStateNotifierProvider.notifier)
                .toggleEnableBtn();
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DMCommonClickButton(
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColor,
            textColor: style.enableBtnTextColor,
            backgroundGradient: style.confirmBtnGradient,
            borderRadius: style.buttonBorder,
            enable: ref.watch(pairQrCodeStateNotifierProvider
                .select((value) => value.enableBtn)),
            text: 'next'.tr(),
            onClickCallback: () async {
              await AppRoutes().push(PairConnectPage.routePath,
                  extra: {'pairQRKey': IotPairNetworkInfo().pairQRKey ?? ''});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: DMCommonClickButton(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            text: 'text_switch_to_hotspot'.tr(),
            borderRadius: style.buttonBorder,
            textColor: style.cancelBtnTextColor,
            fontsize: 14,
            backgroundGradient: style.cancelBtnGradient,
            onClickCallback: () async {
              var index = Navigator.of(context).widget.pages.indexWhere(
                  (element) => element.name == PairConnectPage.routePath);
              IotPairNetworkInfo().pairQRKey = '';
              if (index == -1) {
                if (Platform.isAndroid) {
                  await AppRoutes().push(NearbyConnectPage.routePath);
                } else {
                  await AppRoutes().push(PairConnectPage.routePath);
                }
              }
            },
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: PairNetIndicatorWidget(
              ref.watch(pairQrCodeStateNotifierProvider
                  .select((value) => value.currentStep)),
              ref.watch(pairQrCodeStateNotifierProvider
                  .select((value) => value.totalSteps)),
            ),
          ),
        )
      ],
    );
  }
}
