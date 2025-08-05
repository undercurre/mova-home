import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/dialog_job_manager.dart';
import 'package:flutter_plugin/ui/page/settings/upgrade/app_upgrade_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dialog/content_cancle_confirm_dialog.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/horizontal_progress_bar.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AppUpgradeSheet extends ConsumerStatefulWidget {
  final VoidCallback? dismissCallback;
  const AppUpgradeSheet({super.key, this.dismissCallback});

  @override
  AppUpgradeWidgetState createState() => AppUpgradeWidgetState();
}

class AppUpgradeWidgetState extends ConsumerState<AppUpgradeSheet> {
  void _dismiss() {
    if (ref.read(appUpgradeStateNotifierProvider).isForce) {
      if (Platform.isIOS) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
    } else {
      widget.dismissCallback?.call();
      ref.read(dialogJobManagerProvider.notifier).nextJob();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
        appUpgradeStateNotifierProvider.select((value) => value.installApk),
        (pre, value) {
      if (value) {
        _dismiss();
      }
    });
    ref.listen(appUpgradeStateNotifierProvider.select((value) => value.uiEvent),
        (pre, value) {
      if (value is AlertEvent) {
        SmartDialog.show(
            animationType: SmartAnimationType.fade,
            maskColor: Colors.black.withOpacity(0.5),
            clickMaskDismiss: false,
            builder: (_) {
              return ContentCancelConfirmDialog(
                content: value.content ?? '',
                cancelContent: value.cancelContent ?? '',
                confirmContent: value.confirmContent ?? '',
                confirmCallback: () => value.confirmCallback?.call(),
              );
            });
      }
    });
    return Semantics(
      explicitChildNodes: true,
      child: ThemeWidget(
        builder: (context, style, resource) {
          return Container(
            height: 414,
            decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(style.circular8),
                    topRight: Radius.circular(style.circular8))),
            padding:
                const EdgeInsets.only(left: 32, right: 32, top: 22, bottom: 32)
                    .withRTL(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Semantics(
                      label: 'popup_image'.tr(),
                      child: Image(
                                        image: AssetImage(resource.getResource('ic_upgrade_title')),
                                        width: 121,
                                        height: 93,
                                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                        child: Text(
                      'find_new_version'.tr(),
                      style: style.mainStyle(fontSize: 18),
                    ))),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'version_update_description'.tr(),
                      style: style.secondStyle()),
                  TextSpan(
                      text:
                          '${ref.watch(appUpgradeStateNotifierProvider).versionName}',
                      style: style.secondStyle())
                ])),
                Expanded(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: SingleChildScrollView(
                          child: Text(
                              ref
                                  .watch(appUpgradeStateNotifierProvider)
                                  .versionDesc,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: style.textSecond,
                                  height: 1.5)),
                        ))),
                Visibility(
                    visible:
                        ref.watch(appUpgradeStateNotifierProvider).downloading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HorizontalProgressBar(
                            progress: ref
                                    .watch(appUpgradeStateNotifierProvider)
                                    .progress /
                                100,
                            width: double.infinity,
                            backgroundColor: style.lightBlack2,
                            foregroundColor: style.click),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 12).withRTL(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('upgrading'.tr(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: style.textMain,
                                        fontWeight: FontWeight.bold)),
                                Padding(
                                    padding: const EdgeInsets.only(left: 13)
                                        .withRTL(context),
                                    child: Text(
                                        '${ref.watch(appUpgradeStateNotifierProvider).progress}%',
                                        style: TextStyle(
                                            fontSize: 12, color: style.btnText)))
                              ],
                            )),
                      ],
                    )),
                FocusableActionDetector(
                  autofocus: true,
                  child: Visibility(
                      visible:
                          !ref.watch(appUpgradeStateNotifierProvider).downloading,
                      child: Row(children: [
                        Expanded(
                            child: Semantics(
                              explicitChildNodes: true,
                              child: DMButton(
                                  width: double.infinity,
                                  onClickCallback: (_) => _dismiss(),
                                  text: ref
                                          .watch(appUpgradeStateNotifierProvider)
                                          .isForce
                                      ? 'privacy_policy_quit'.tr()
                                      : 'cancel'.tr(),
                                  fontsize: 14,
                                  textColor: style.lightDartBlack,
                                  fontWidget: FontWeight.bold,
                                  backgroundGradient: style.grayGradient,
                                  borderRadius: style.buttonBorder,
                                  padding: const EdgeInsets.symmetric(vertical: 14)),
                            )),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                            child: FocusableActionDetector(
                              autofocus: true,
                              child: Semantics(
                                explicitChildNodes: true,
                                child: DMButton(
                                    width: double.infinity,
                                    onClickCallback: (_) {
                                      ref
                                          .read(
                                              appUpgradeStateNotifierProvider.notifier)
                                          .download();
                                    },
                                    text: 'upgrade'.tr(),
                                    fontsize: 14,
                                    textColor: style.btnText,
                                    fontWidget: FontWeight.bold,
                                     backgroundGradient: style.confirmBtnGradient,
                                    borderRadius: style.buttonBorder,
                                    padding: const EdgeInsets.symmetric(vertical: 14)),
                              ),
                            ))
                      ])),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
