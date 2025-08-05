import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/code/social_sign_bind_email_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/mixin/social_bind_cover_minxin.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/send/social_sign_bind_email_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 三方登录，绑定邮箱页面
class SocialSignBindEmailPage extends BasePage {
  static const String routePath = '/social_sign_bind_email_page';

  final String authType;
  final dynamic token;

  /// 是否显示跳过按钮, true 表示不显示, false 表示显示
  final bool socialNoEmail;

  const SocialSignBindEmailPage(
      {super.key,
      required this.authType,
      required this.token,
      this.socialNoEmail = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SocialSignBindeEmailPageState();
  }
}

class _SocialSignBindeEmailPageState
    extends BasePageState<SocialSignBindEmailPage> with SocialBindeCoverMinxin {
  TextEditingController editController = TextEditingController();

  @override
  void initData() {
    super.initData();
    ref.read(socailSignBindEmailStateNotifierProvider.notifier).init();
  }

  @override
  void addObserver() {
    ref.listen(
        socailSignBindEmailStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      if (next is SocialAlertTipEvent) {
        showTips();
      }
    });
  }

  void showTips() {
    showSocialAlert(
      (type) {
        switch (type) {
          case SocialBindAlertType.changeEmail:
            //切换邮箱，清空
            changeEmail();
            break;
          case SocialBindAlertType.login:
            // 返回邮箱登录页面
            backToMailLogin();
            break;
          default:
            //直接登录
            skip();
            break;
        }
      },
    );
  }

  Future<void> pushToCode() async {
    // Navigator.of(context).push(SocialSignBindEmailCodePage.routePath);
    // GoRouter.of(context).push(SocialSignBindEmailCodePage.routePath);
    SmscodeTransByMail? smsTrans = await ref
            .read(socailSignBindEmailStateNotifierProvider.notifier)
            .sendMessage(checkRegisterFlag: !widget.socialNoEmail)
        as SmscodeTransByMail?;
    if (smsTrans != null) {
      pushToBindPage(smsTrans);
    }
  }

  void pushToBindPage(SmscodeTrans smsTrans) {
    GoRouter.of(context).push(SocialSignBindEmailCodePage.routePath, extra: {
      'trans': smsTrans,
      'authType': widget.authType,
      'token': widget.token,
    });
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    LogUtils.d(
        'buildNavBar:---------${widget.socialNoEmail} ${ref.watch(socailSignBindEmailStateNotifierProvider.select((value) => value.showSkip))}---------');
    return NavBar(
      title: 'Text_3rdPartyBundle_BundlePage_Title'.tr(),
      rightWidget: !ref.watch(socailSignBindEmailStateNotifierProvider
                  .select((value) => value.showSkip)) ||
              widget.socialNoEmail

          /// !A 、A&B
          ? const SizedBox(width: 60, height: 52)
          : SizedBox(
              width: 60,
              height: 52,
              child: Text(
                'Text_3rdPartyBundle_BundlePage_Skip'.tr(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: style.textNormal),
              ),
            ).onClick(() {
              skip();
            }),
      backHidden: false,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          GoRouter.of(context).pop();
        }
      },
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30)
              .withRTL(context),
          child: Text(
            'bind_signin_email_code'.tr(),
            style: TextStyle(
                fontSize: style.middleText,
                fontWeight: FontWeight.w400,
                color: style.textDisable),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
              .withRTL(context),
          child: AnimatedInputText(
            onTextChanged: ref
                .read(socailSignBindEmailStateNotifierProvider.notifier)
                .emailChange,
            showCountryCode: false,
            showGetDynamicCode: false,
            textInputType: TextInputType.text,
            textHint: 'please_input_email'.tr(),
            changeCountryCode: () async {},
            textEditingController: editController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 52)
              .withRTL(context),
          child: DMCommonClickButton(
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColorGold,
            textColor: style.enableBtnTextColorGold,
            backgroundGradient: style.brandColorGradient,
            borderRadius: style.buttonBorder,
            enable: ref.watch(socailSignBindEmailStateNotifierProvider
                .select((value) => value.enableSend)),
            onClickCallback: () {
              pushToCode();
              // showTips();
            },
            text: 'send_sms_code'.tr(),
          ),
        )
      ],
    );
  }

  void changeEmail() {
    editController.clear();
    ref.read(socailSignBindEmailStateNotifierProvider.notifier).emailChange('');
  }

  void backToMailLogin() {
    String pagePath = RootPage.getPageRoutePath();
    String dirPath = PasswordLoginPage.routePath;
    AppRoutes.resetStacks();
    var extra2 = {
      param_account: editController.text,
      param_pwd: '',
      param_type: 'input'
    };
    EventBusUtil.getInstance().fire(NewIntentEvent(dirPath, extra2));
    if (pagePath != dirPath) {
      GoRouter.of(context).push(dirPath, extra: extra2);
    }
  }

  Future<void> skip() async {
    bool reset = await ref
        .read(socailSignBindEmailStateNotifierProvider.notifier)
        .login(authType: widget.authType, token: widget.token);
    if (reset) {
      await AppRoutes.resetStacks();
    }
  }
}
