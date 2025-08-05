import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 网络频段错误弹窗
class NetBrandErrorDialog extends StatelessWidget {
  final VoidCallback cancelCallback;
  final VoidCallback confirmCallback;
  final VoidCallback guideCallback;
  final String? smartDialogTag;
  final String? ssid;

  const NetBrandErrorDialog({
    super.key,
    required this.confirmCallback,
    required this.guideCallback,
    required this.cancelCallback,
    this.ssid,
    this.smartDialogTag,
  });

  void dismiss() {
    SmartDialog.dismiss(tag: smartDialogTag);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(style.circular20),
            color: style.bgWhite),
        margin: const EdgeInsets.symmetric(horizontal: 35),
        padding: const EdgeInsets.only(top: 28, left: 24, right: 24, bottom: 20)
            .withRTL(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12).withRTL(context),
              child: Text(
                'text_net_band_error'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: style.textMain,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 44),
              child: Text(
                'text_current_band_error'.tr(args: [ssid ?? '']),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: style.textMain,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    resource.getResource('icon_warning_red'),
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: Text(
                      'text_limit_band'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: style.yellow,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'text_connect_guide'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    color: style.gray3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Image.asset(
                  resource.getResource('icon_arrow_right_12'),
                  height: 12,
                  width: 12,
                )
              ],
            ).onClick(() {
              guideCallback.call();
            }),
            Padding(
              padding: const EdgeInsets.only(top: 24).withRTL(context),
              child: Row(
                children: [
                  Expanded(
                    child: DMCommonClickButton(
                        height: 48,
                        borderRadius: style.circular8,
                        width: double.infinity,
                        backgroundGradient: style.cancelBtnGradient,
                        textColor: style.lightDartBlack,
                        text: 'text_contiune_to_connect'.tr(),
                        onClickCallback: () {
                          dismiss();
                          cancelCallback.call();
                        }),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: DMCommonClickButton(
                        height: 48,
                        borderRadius: style.circular8,
                        textColor: style.confirmBtnTextColor,
                        backgroundGradient: style.confirmBtnGradient,
                        text: 'text_switch_other_wifi'.tr(),
                        width: double.infinity,
                        onClickCallback: () {
                          dismiss();
                          confirmCallback.call();
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
