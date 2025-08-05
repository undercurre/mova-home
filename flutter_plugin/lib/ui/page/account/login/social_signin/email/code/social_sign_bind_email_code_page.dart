import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/code/social_sign_bind_email_code_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SocialSignBindEmailCodePage extends BasePage {
  static const String routePath = '/social_sign_bind_email_code_page';

  const SocialSignBindEmailCodePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ScocialSignBindEmailCodePageState<SocialSignBindEmailCodePage>();
  }
}

class _ScocialSignBindEmailCodePageState<SocialSignBindEmailCodePage>
    extends BasePageState {
  @override
  String get centerTitle => 'Text_3rdPartyBundle_BundlePage_Title'.tr();

  @override
  void initData() {
    super.initData();
    var extras = GoRouterState.of(context).extra as Map<String, dynamic>;
    var trans = extras['trans'];
    var authType = extras['authType'];
    var token = extras['token'];

    ref
        .read(socialSignBindEmailCodeStateNotifierProvider.notifier)
        .updateData(trans, authType, token);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 22, right: 22)
              .withRTL(context),
          child: Consumer(builder: (context, ref, child) {
            return Text.rich(
              TextSpan(
                  text: ref.watch(socialSignBindEmailCodeStateNotifierProvider
                      .select((value) => value.sourceWayText ?? '')),
                  style: TextStyle(
                    color: style.textSecond,
                    fontSize: style.middleText,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                        text: ref.watch(
                            socialSignBindEmailCodeStateNotifierProvider
                                .select((value) => value.sourceText ?? '')),
                        style: TextStyle(
                          color: style.click,
                          fontSize: style.middleText,
                          fontWeight: FontWeight.w400,
                        ))
                  ]),
            );
          }),
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 26)
                        .withRTL(context),
                    child: DmPincodeTextField(
                      length: 6,
                      width: 48,
                      height: 54,
                      fontSize: style.input_number,
                      fontWeight: FontWeight.w600,
                      onChanged: (value) {
                        ref
                            .read(socialSignBindEmailCodeStateNotifierProvider
                                .notifier)
                            .changeCode(value);
                      },
                    )),
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(bottom: 36).withRTL(context),
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        bool enable = ref.watch(
                            socialSignBindEmailCodeStateNotifierProvider
                                .select((value) => value.enableSend));
                        if (enable) {
                          ref
                              .read(socialSignBindEmailCodeStateNotifierProvider
                                  .notifier)
                              .resetCode(context);
                        }
                      },
                      child: Consumer(
                        builder: (context, ref, child) {
                          return Text(
                            ref.watch(
                                socialSignBindEmailCodeStateNotifierProvider
                                    .select((value) => value.sendButtonText)),
                            style: ref.watch(
                                    socialSignBindEmailCodeStateNotifierProvider
                                        .select((value) => value.enableSend))
                                ? style.clickStyle()
                                : style.secondStyle(),
                          );
                        },
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 36).withRTL(context),
                  child: Consumer(builder: (_, ref, child) {
                    return DMCommonClickButton(
                      disableBackgroundGradient: style.disableBtnGradient,
                      disableTextColor: style.disableBtnTextColorGold,
                      textColor: style.enableBtnTextColorGold,
                      backgroundGradient: style.brandColorGradient,
                      borderRadius: style.buttonBorder,
                      enable: ref.watch(
                          socialSignBindEmailCodeStateNotifierProvider
                              .select((value) => value.enableNext)),
                      onClickCallback: () {
                        ref
                            .read(socialSignBindEmailCodeStateNotifierProvider
                                .notifier)
                            .checkCode();
                      },
                      text: 'Text_3rdPartyBundle_CreateDreameBundled_Now'.tr(),
                    );
                  }),
                )
              ],
            )),
      ],
    );
  }
}
