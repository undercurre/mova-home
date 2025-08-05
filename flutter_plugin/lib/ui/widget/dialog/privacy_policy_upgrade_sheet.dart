// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/webview/webview_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 隐私更新Dialog
class PrivacyPolicyUpgradeSheet extends ConsumerStatefulWidget {
  final String content;
  final String privacyUrl;
  final String agreementUrl;

  VoidCallback agreeClick;
  VoidCallback rejectClick;

  PrivacyPolicyUpgradeSheet(
      {super.key,
      required this.content,
      required this.privacyUrl,
      required this.agreementUrl,
      required this.agreeClick,
      required this.rejectClick});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PrivacyPolicyUpgradeSheetState();
  }
}

class _PrivacyPolicyUpgradeSheetState
    extends ConsumerState<PrivacyPolicyUpgradeSheet> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      child: ThemeWidget(builder: (_, style, resource) {
        return Container(
          height: 414,
          decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.all(Radius.circular(style.circular20))),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 30, right: 30)
                  .withRTL(context),
              child: Semantics(
                label: 'text_privacy_policy_upgrade'.tr(),
                child: Text(
                  'text_privacy_policy_upgrade'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.mainStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20, bottom: 30, left: 7, right: 7)
                        .withRTL(context),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Semantics(
                        label: widget.content,
                        child: DMFormatRichText(
                          content: widget.content,
                          normalTextStyle: style.secondStyle(),
                          clickTextStyle: style.clickStyle(),
                          richCallback: (index, key, content) async {
                            /// 点击隐私
                            if (key.isNotEmpty && key.startsWith("http")) {
                              await AppRoutes().push(WebviewPage.routePath,
                                  extra: WebviewPage.createParams(
                                      url: key, title: content));
                            } else if (key.isNotEmpty && key == 'privacy' ||
                                key == 'user') {
                              await AppRoutes().push(WebviewPage.routePath,
                                  extra: WebviewPage.createParams(
                                      url: key == 'privacy'
                                          ? widget.privacyUrl
                                          : widget.agreementUrl,
                                      title: content));
                            } else {}
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 底部按钮
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32).withRTL(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  Expanded(
                    child: DMButton(
                      onClickCallback: (_) {
                        //
                        widget.rejectClick();
                      },
                      text: 'privacy_policy_reject_quit'.tr(),
                      borderRadius: style.buttonBorder,
                      textColor: style.lightDartBlack,
                      backgroundGradient: style.cancelBtnGradient,
                      fontWidget: FontWeight.w600,
                      width: double.infinity,
                      fontsize: 16,
                      height: 48,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: DMButton(
                      onClickCallback: (_) {
                        //
                        widget.agreeClick();
                      },
                      text: 'privacy_policy_agree'.tr(),
                      backgroundGradient: style.confirmBtnGradient,
                      textColor: style.btnText,
                      borderRadius: style.buttonBorder,
                      borderColor: style.lightBlack2,
                      fontsize: 16,
                      borderWidth: 0,
                      fontWidget: FontWeight.w600,
                      width: double.infinity,
                      height: 48,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 34))
          ]),
        );
      }),
    );
  }
}
