import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/mixin/pair_net_back_helper.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/uiconfig/base_uiconfig.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_solution/pair_solution_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../step_by_step_widget.dart';

class PairNetConnectWidget extends ConsumerStatefulWidget {
  final int step1Status;
  final int step2Status;
  final int step3Status;
  final String step1Text;
  final String step2Text;
  final String step3Text;

  final int currentStep;
  final int totalStep;

  const PairNetConnectWidget({
    super.key,
    required this.step1Status,
    required this.step2Status,
    required this.step3Status,
    required this.currentStep,
    required this.totalStep,
    required this.step1Text,
    required this.step2Text,
    required this.step3Text,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PairNetConnectWidgetState();
  }
}

class _PairNetConnectWidgetState extends ConsumerState<PairNetConnectWidget>
    with PairNetBackHelper {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return buildPairNetWidget(context, style, resource);
    });
  }

  Widget buildPairNetWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              resource.getResource('ic_connect_device'),
              height: 240,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'text_close_to_device_connect'.tr(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: style.textMainBlack),
            ),
          ),
          Visibility(
            visible: widget.step1Status >= 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: StepByStepWidget(
                text: widget.step1Text,
                status: widget.step1Status,
              ),
            ),
          ),
          Visibility(
              visible: widget.step2Status >= 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: StepByStepWidget(
                  text: widget.step2Text,
                  status: widget.step2Status,
                ),
              )),
          Visibility(
            visible: widget.step3Status >= 0,
            child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: StepByStepWidget(
                  text: widget.step3Text,
                  status: widget.step3Status,
                )),
          ),
          Spacer(),
          Visibility(
            visible: widget.step1Status == UIStep.STEP_STATUS_FAIL ||
                widget.step2Status == UIStep.STEP_STATUS_FAIL ||
                widget.step3Status == UIStep.STEP_STATUS_FAIL,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'text_review_failed_reason'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: style.gray3,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Image.asset(resource.getResource('icon_arrow_right_12'))
                ]).onClick(() async {
              await AppRoutes().push(PairSolutionPage.routePath);
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: (widget.step3Status == UIStep.STEP_STATUS_FAIL ||
                    widget.step1Status == UIStep.STEP_STATUS_FAIL ||
                    widget.step2Status == UIStep.STEP_STATUS_FAIL)
                ? DMCommonClickButton(
                    width: double.infinity,
                    height: 48,
                    borderRadius: style.buttonBorder,
                    disableTextColor: style.disableBtnTextColor,
                    textColor: style.enableBtnTextColor,
                    backgroundGradient: style.confirmBtnGradient,
                    disableBackgroundGradient: style.disableBtnGradient,
                    text: 'retry'.tr(),
                    onClickCallback: () {
                      gotoPairNetBackToFirst();
                    })
                : DMCommonClickButton(
                    borderRadius: style.buttonBorder,
                    text: 'complete'.tr(),
                    disableTextColor: style.disableBtnTextColor,
                    textColor: style.enableBtnTextColor,
                    backgroundGradient: style.confirmBtnGradient,
                    disableBackgroundGradient: style.disableBtnGradient,
                    enable:
                        !(widget.step1Status == UIStep.STEP_STATUS_LOADING ||
                            widget.step2Status == UIStep.STEP_STATUS_LOADING ||
                            widget.step3Status == UIStep.STEP_STATUS_LOADING),
                    onClickCallback: () async {
                      await SmartStepHelper().finish(true);
                      // 完成 跳转首页
                      gotoHomePage();

                    }),
          ),
          Visibility(
            visible: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 48),
              child:
                  PairNetIndicatorWidget(widget.currentStep, widget.totalStep),
            ),
          ),
        ],
      ),
    );
  }
}
