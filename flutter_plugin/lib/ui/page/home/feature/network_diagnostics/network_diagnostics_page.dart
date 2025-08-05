import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/home/feature/network_diagnostics/diagnostics_progress_widget.dart';
import 'package:flutter_plugin/ui/page/home/feature/network_diagnostics/network_diagnostics_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/scan/iot_scan_permission_request_mixin.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_location_service_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_open_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/step/step_wifi_permission_request_dialog.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/common_step_chain.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'count_down_timer.dart';

class NetworkDiagnosticsPage extends BasePage {
  static const String routePath = '/network_diagnostics';

  const NetworkDiagnosticsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NetworkDiagnosticsPageState();
  }
}

class _NetworkDiagnosticsPageState extends BasePageState
    with CountDownTimer, IotScanPermissionRequestMixin {
  @override
  String get centerTitle => 'network_diagnostics'.tr();
  bool _isProgress = false;
  bool _isCompelete = false;

  @override
  CommonStepChain initStepChain() {
    return CommonStepChain()
      ..configureStepChain([
        StepWifiPermissionRequestDialog(isOnceAgain: true),
        StepWifiLocationServiceDialog(),
        StepWifiOpenRequestDialog(),
      ]);
  }

  @override
  void initData() {
    super.initData();
    ref.watch(networkDiagnosticsStateNotifierProvider.notifier).initData();
    stepChainCheckPermission();
  }

  @override
  void onAppResumeAndActive() {
    LogUtils.i(' sunzhibin NetworkDiagnostics onAppResume $this');
    stepChainCheckPermission();
  }

  @override
  void onPermissionSuccess(StepEvent event) {
    super.onPermissionSuccess(event);
    startCheckTimer();
  }

  @override
  void onPermissionFail(StepId stepId) {
    super.onPermissionFail(stepId);
    startCheckTimer();
  }

  void startCheckTimer() {
    try {
      if (!isTimerEnable &&
          ref.watch(networkDiagnosticsStateNotifierProvider
              .select((value) => value.status == 0))) {
        startTimer();
        ref
            .watch(networkDiagnosticsStateNotifierProvider.notifier)
            .networkDiagnostics();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void countDown(int value, int progress) {
    super.countDown(value, progress);
    var watch = ref.watch(networkDiagnosticsStateNotifierProvider);
    if (mounted && watch.status == 0) {
      _isProgress = true;
      ref
          .watch(networkDiagnosticsStateNotifierProvider.notifier)
          .updateProgress(progress);
    } else {
      cancelTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    LogUtils.i(' sunzhibin NetworkDiagnostics dispose $this');
    _isProgress = false;
    cancelTimer(force: true);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    backgroundColor = style.bgGray;
    return Stack(
      children: [
        Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ref.watch(networkDiagnosticsStateNotifierProvider).status ==
                        0 &&
                    !_isCompelete
                ? buildProgressWidget(context, style, resource)
                : buildStatusWidget(context, style, resource)),
      ],
    );
  }

  Widget buildProgressWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: DiagnosticsProgressWidget(isRunning: _isProgress, resource: resource,),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
          child: Text(
            '${ref.watch(networkDiagnosticsStateNotifierProvider.select((value) => value.progress))}%',
            style: TextStyle(
                fontSize: 48, fontWeight: FontWeight.w400, color: style.click),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
          child: Text(
            'network_diagnostics_ing'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: style.textNormal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
          child: Text(
            'network_diagnostics_ing_desc'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: style.textNormal),
          ),
        ),
      ],
    );
  }

  Widget buildSuccessWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Image.asset(
                resource.getResource('ic_offline_diagnostic_complete'),
                width: 120,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
              child: Text(
                'network_diagnostics_change_complete'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: style.click),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
              child: Text(
                textAlign: TextAlign.center,
                'text_network_diagnostics_done'.tr(),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9E9E9E)),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 49,
          left: 0,
          right: 0,
          child: DMButton(
            height: 48,
            borderRadius: style.buttonBorder,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(top: 16),
            backgroundGradient: style.confirmBtnGradient,
            fontsize: 16,
            fontWidget: FontWeight.bold,
            textColor: style.enableBtnTextColor,
            onClickCallback: (_) async {
              // 跳转到配网页面
              await UIModule().generatePairNetEngine(QrScanPage.routePath);
            },
            text: 'text_reconnect'.tr(),
          ),
        ),
      ],
    );
  }

  Widget buildStatusWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    _isProgress = false;
    _isCompelete = true;
    final state = ref.watch(networkDiagnosticsStateNotifierProvider);
    if (state.result == 1) {
      return buildSuccessWidget(context, style, resource);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 63),
          child: Image.asset(
            resource.getResource('ic_offline_diagnostic_complete'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
          child: Text(
            state.resultText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: style.red1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
          child: Text(
            state.resultText2,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9E9E9E)),
          ),
        ),
      ],
    );
  }
}
