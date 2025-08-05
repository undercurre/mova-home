import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/countdown/count_down_widget.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import 'social_signin_bind_code_state_notifier.dart';
import 'social_signin_bind_code_uistate.dart';

/// 输入验证码界面
class SocialSignInBindCodePage extends BasePage {
  static const String routePath = '/social_signin_bind_code';

  const SocialSignInBindCodePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SocialSignInBindCodePageState();
  }
}

class _SocialSignInBindCodePageState extends BasePageState
    with CountDownWidget, CommonDialog {
  @override
  void initData() {
    super.initData();
    var extra = GoRouterState.of(context).extra as SocialCodeModel;
    LogUtils.d('------------- SocialSignInBindCodePage ----------- $extra ');
    ref.read(socialSignInBindCodeStateNotifierProvider.notifier).init(extra);
    LogUtils.d(
        '------------- SocialSignInBindCodePage ----------- init $extra ');
    startTimer();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(socialSignInBindCodeEventProvider, (previous, event) {
      if (event is BindCoverDialog) {
        var source = event.msg;
        switch (event.msg) {
          case GOOGLE_AUTH:
            source = 'Google';
            break;
          case FACEBOOK_AUTH:
            source = 'Facebook';
            break;
          case WECHAT_AUTH:
            source = 'share_weixin'.tr();
            break;
          case APPLE_AUTH:
            source = 'Apple';
            break;
        }
        showCommonDialog(
            content: 'Text_3rdPartyBundle_LinkPage_DoubleBundle_Tip'
                .tr(args: [source, source, source]),
            cancelContent: 'continue_bind'.tr(),
            confirmContent: 'login'.tr(),
            cancelCallback: () {
              socialBind(cover: true);
            },
            confirmCallback: () async {
              // 跳转登录页
              AppRoutes.resetStacks();
            });
      } else if (event is ShowAccountLocked) {
        showCommonDialog(
            content: 'password_error_exceeded_the_maximum'.tr(),
            cancelContent: 'cancel'.tr(),
            confirmContent: 'text_retrieve_password'.tr(),
            confirmCallback: () async {
              // 跳转找回密码界面
              var region = await LocalModule().getCountryCode();
              var path = region.toLowerCase() == 'cn'
                  ? MobileRecoverPage.routePath
                  : MailRecoverPage.routePath;
              await GoRouter.of(context).push(path);
            });
      } else if (event is ToastShow) {
        SmartDialog.showToast(event.msg);
      }
    });
  }

  /// 立即绑定
  /// 手机号不允许覆盖绑定
  Future<void> socialBind({bool cover = false}) async {
    var result = await ref
        .read(socialSignInBindCodeStateNotifierProvider.notifier)
        .socialSignInMobileBind(cover);
    LogUtils.d('-------- login --------$result ');
    if (result) {
      // 首页
      await AppRoutes.resetStacks();
    }
  }

  Future<void> sendCodeAgain(RecaptchaModel recaptchaModel) async {
    bool result = await ref
        .read(socialSignInBindCodeStateNotifierProvider.notifier)
        .sendCodeAgain(recaptchaModel);
    LogUtils.d('-------- sendCodeAgain sendCodeAgain --------');
    if (result) {
      LogUtils.d('-------- sendCodeAgain startTimer --------');
      startTimer();
    }
  }

  void onInputChange(String value) {
    ref
        .read(socialSignInBindCodeStateNotifierProvider.notifier)
        .sendInput(value);
  }

  @override
  String get centerTitle => 'input_verify_code'.tr();

  @override
  Color? get navBackgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    LogUtils.d(
        '--------------- SocialSignInBindCodePage buildBody -----------');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 22, right: 22)
              .withRTL(context),
          child: Consumer(builder: (context, ref, child) {
            var uiState = ref.watch(socialSignInBindCodeStateNotifierProvider);
            return Text.rich(
              TextSpan(
                  text: 'sms_send_to_phone'.tr(),
                  style: TextStyle(
                    color: style.textSecond,
                    fontSize: style.middleText,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                        text:
                            '+${uiState.currentPhone.code} ${uiState.account}',
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
                        onChanged: onInputChange)),
                SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () async {
                        if (ref.read(countDownProvider.notifier).isEnable()) {
                          await RecaptchaController(context, (recaptchaModel) {
                            sendCodeAgain(recaptchaModel);
                          }).check();
                        }
                      },
                      child: Consumer(
                        builder: (context, ref, child) {
                          return Text(
                            (ref.watch(countDownProvider) >= 0
                                ? 'sms_resend_after'.tr(
                                    args: ['${ref.watch(countDownProvider)}'])
                                : 'sms_resend_again'.tr()),
                            style: TextStyle(
                                fontSize: style.middleText,
                                fontWeight: FontWeight.w400,
                                color: ref.watch(countDownProvider) >= 0
                                    ? style.textDisable
                                    : style.click),
                            textAlign: TextAlign.end,
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
                      enable: ref
                          .watch(socialSignInBindCodeStateNotifierProvider)
                          .isInputInvalid,
                      onClickCallback: socialBind,
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
