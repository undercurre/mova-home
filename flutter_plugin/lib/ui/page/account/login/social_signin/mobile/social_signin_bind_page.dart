import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/code/social_signin_bind_code_page.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import 'social_signin_bind_state_notifier.dart';
import 'social_signin_bind_uistate.dart';

/// 三方登录，绑定dreame账号页面
class SocialSignInBindPage extends BasePage {
  static const String routePath = '/social_signin_bind';

  const SocialSignInBindPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SocialSignInBindPageState();
  }
}

class _SocialSignInBindPageState extends BasePageState with CommonDialog {
  @override
  void initData() {
    super.initData();
    var extra = GoRouterState.of(context).extra as SocialCodeModel;
    LogUtils.d('------------- _SocialSignInBindPageState ----------- $extra ');
    ref.read(socialSigninBindStateNotifierProvider.notifier).init(extra);
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(socialSignInBindEventProvider, (previous, event) {
      LogUtils.d(
          '------------- _SocialSignInBindPageState eventStream listen----------- $event ');
      if (previous == event) {
        return;
      }
      if (event is ToastShow) {
        SmartDialog.showToast(event.msg);
      } else if (event is Success) {
        // 跳转
        AppRoutes.resetStacks();
      } else if (event is BindCoverDialog) {
        // 弹框
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
            tag: 'BindCoverDialog',
            backDismiss: true,
            cancelCallback: () {
              socialBind(cover: true);
            },
            confirmCallback: () async {
              // 跳转密码登录页

              await AppRoutes.resetStacks();
              var path = RootPage.getPageRoutePath();
              if (PasswordLoginPage.routePath != path) {
                await GoRouter.of(context).push(PasswordLoginPage.routePath);
              }
            });
      } else if (event is ShowAccountLocked) {
        // 账号锁定
        showCommonDialog(
            tag: 'ShowAccountLocked',
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
      }
    });
  }

  void onTextChanged(value) {
    ref.read(socialSigninBindStateNotifierProvider.notifier).sendInput(value);
  }

  void onTextChangedPassword(value) {
    ref.read(socialSigninBindStateNotifierProvider.notifier).sendInput2(value);
  }

// 获取验证码
  Future<void> getDymicCode() async {
    var isEnable = ref
        .watch(socialSigninBindStateNotifierProvider.notifier)
        .checkPhoneNumber();
    if (isEnable) {
      await RecaptchaController(context, (recaptchaModel) {
        sendDymicCode(recaptchaModel);
      }).check();
    }
  }

  Future<void> sendDymicCode(RecaptchaModel recaptchaModel) async {
    var ret = await ref
        .read(socialSigninBindStateNotifierProvider.notifier)
        .autoRegisterBindSms(recaptchaModel)
        .then((value) => value.second);
    if (ret != null) {
      await GoRouter.of(context)
          .push(SocialSignInBindCodePage.routePath, extra: ret);
    }
  }

// 立即绑定
  Future<void> socialBind({bool cover = false}) async {
    await ref
        .read(socialSigninBindStateNotifierProvider.notifier)
        .socialbBind(cover);
  }

  void _pushToRegionPicker(bool forRegion) {
    RegionItem currentItem =
        ref.read(socialSigninBindStateNotifierProvider).currentPhone;
    RegionItem currentItem0 = currentItem;
    Future<RegionItem?> selectItem = GoRouter.of(context).push(
        RegionPickerPage.routePath,
        extra: RegionPickerPage.createExtra(currentItem0));
    ref
        .read(socialSigninBindStateNotifierProvider.notifier)
        .callBackRegion(selectItem, forRegion);
  }

  Future<void> skipSocialBind() async {
    LogUtils.d('----------- skipSocialBind ---------');
    var ret = await ref
        .read(socialSigninBindStateNotifierProvider.notifier)
        .socialbBindSkip();
    if (ret) {
      await AppRoutes.resetStacks();
    }
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: 'Text_3rdPartyBundle_BundlePage_Title'.tr(),
      rightWidget: ref.watch(socialSigninBindStateNotifierProvider
              .select((value) => value.showSkip))
          ? SizedBox(
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
              skipSocialBind();
            })
          : null,
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
    var uiState = ref.watch(socialSigninBindStateNotifierProvider);
    return Container(
      color: style.lightBlack3,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30)
              .withRTL(context),
          child: Text(
            'bind_signin_phone_code'.tr(),
            style: TextStyle(
                fontSize: style.middleText,
                fontWeight: FontWeight.w400,
                color: style.textDisable),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 40)
              .withRTL(context),
          child: const RegionSelectMeun(canTap: false),
        ),

        /// 输入框
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
              .withRTL(context),
          child: AnimatedInputText(
            onTextChanged: onTextChanged,
            showCountryCode: false,
            showGetDynamicCode: false,
            underLineColor: style.lightBlack1,
            textInputType:
                uiState.isMobileOnly ? TextInputType.phone : TextInputType.text,
            textHint: uiState.isInputPhoneNumber
                ? 'please_input_mobile'.tr()
                : 'text_signIn_input_email_phone'.tr(),
            changeCountryCode: () async {
              final code = await LocalModule().getCountryCode();
              if (code.toLowerCase() == 'cn') {
                return;
              }
              _pushToRegionPicker(false);
            },
          ),
        ),
        ref.watch(socialSigninBindStateNotifierProvider).isInputPhoneNumber
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
                    .withRTL(context),
                child: AnimatedInputText(
                  onTextChanged: onTextChangedPassword,
                  showCountryCode: false,
                  showGetDynamicCode: false,
                  showEye: true,
                  hidePassword: ref
                      .watch(socialSigninBindStateNotifierProvider)
                      .hidePassword,
                  inputType: AnimatedInputText.INPUT_TYPE_PWD,
                  textHint: 'enter_pwd'.tr(),
                  fontSize: style.head,
                  hintFontSize: style.largeText,
                  textInputType: TextInputType.text,
                  onPassWordHideChanged: (value) {
                    ref
                        .watch(socialSigninBindStateNotifierProvider.notifier)
                        .passwordHidenChange(value);
                  },
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
            enable:
                ref.watch(socialSigninBindStateNotifierProvider).isButtonEnable,
            onClickCallback: ref
                    .watch(socialSigninBindStateNotifierProvider)
                    .isInputPhoneNumber
                ? getDymicCode
                : socialBind,
            text: ref
                    .watch(socialSigninBindStateNotifierProvider)
                    .isInputPhoneNumber
                ? 'send_sms_code'.tr()
                : 'Text_3rdPartyBundle_CreateDreameBundled_Now'.tr(),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
        if (ref.watch(socialSigninBindStateNotifierProvider
            .select((value) => value.showSkip)))
          Center(
            child: Padding(
                padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 10, right: 10)
                    .withRTL(context),
                child: Text(
                  'text_bind_skip'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: style.middleText,
                      fontWeight: FontWeight.w400,
                      color: style.textDisable),
                )).onClick(skipSocialBind),
          ),
        const SizedBox(
          height: 32,
        )
      ]),
    );
  }
}
