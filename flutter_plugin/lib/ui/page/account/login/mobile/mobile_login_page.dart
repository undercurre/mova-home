import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/able/reset_router_enable.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/code/mobile_login_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/mixin/social_bind_cover_minxin.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/mobile/social_signin_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/account/input_agreement_select.dart';
import 'package:flutter_plugin/ui/widget/account/onekey/onekey_login.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth_widget.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'mobile_login_state_notifier.dart';

/// 验证码登录页面
class MobileLoginPage extends BasePage {
  static const String routePath = '/mobile_login';

  const MobileLoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MobileLoginPage();
  }
}

class _MobileLoginPage extends BasePageState
    with
        ResetRouterEnbale,
        CommonDialog,
        ResponseForeUiEvent,
        SocialBindeCoverMinxin {
  late MobileLoginController controller =
      ref.read(mobileLoginControllerProvider.notifier);

  @override
  void initPageState() {
    controller.onLoad();
  }

  void onTextChanged(value) {
    ref.read(mobileLoginControllerProvider.notifier).sendInput(value);
  }

  Future<void> onekeyLogin(int code, String? msg) async {
    // 一键登录
    LogUtils.d('onekeyLogin $code  $msg');
    if (code == 0) {
      var ret = await ref
          .read(mobileLoginControllerProvider.notifier)
          .onekeyLogin(msg!);
      if (ret) {
        await AppRoutes.resetStacks();
        // await ref.read(appConfigProvider.notifier).resetApp();
      }
    }
  }

  Future<void> socialAuthCallback(success, authType, token) async {
    int int1 = 0;
    switch (authType) {
      case 'WECHAT_OPEN':
        int1 = 1;
        break;
      case 'APPLE':
        int1 = 2;
        break;
      case 'GOOGLE_APP':
        int1 = 3;
        break;
      case 'FACEBOOK_APP':
        int1 = 4;
        break;
      default:
    }
    // social auth 登录
    LogUtils.d('----- socialAuthCallback ------$success $authType $token');
    if (!success) {
      LogModule().eventReport(2, 25, int1: int1, int2: 1);
      return;
    }
    var ret = await ref
        .read(mobileLoginControllerProvider.notifier)
        .socialSignIn(authType, token);
    if (ret) {
      LogModule().eventReport(2, 25, int1: int1, int2: 2);
      await AppRoutes.resetStacks();
    } else {
      LogModule().eventReport(2, 25, int1: int1, int2: 1);
    }
  }

  // 发送验证码
  Future<void> sendVerifyCode(RecaptchaModel recaptchaModel) async {
    var ret = await ref
        .read(mobileLoginControllerProvider.notifier)
        .sendVerifyCode(recaptchaModel)
        .then((value) => value.second);
    if (ret != null) {
      await GoRouter.of(context)
          .push(MobileLoginCodePage.routePath, extra: ret);
    }
  }

  void onSelectChange(bool value) {
    LogModule().eventReport(3, 14, int1: 1);
    var notifier = ref.read(mobileLoginControllerProvider.notifier);
    notifier.toggleAgree(value);
  }

  /// 点击获取验证码按钮
  Future<void> getDynamicPress() async {
    LogModule().eventReport(3, 10, int1: 1);
    var isValiad =
        ref.read(mobileLoginControllerProvider.notifier).checkPhoneNumber();
    if (isValiad) {
      await RecaptchaController(context, (recaptchaModel) {
        sendVerifyCode(recaptchaModel);
      }).check();
    }
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(mobileLoginEventProvider, (previous, next) {
      var action = responseFor(next);
      if (action != null) {
        if (action is ActionSocialAccountBind) {
          GoRouter.of(context)
              .go(SocialSignInBindPage.routePath, extra: action.model);
        }
      }
    });
  }

  void _pushToRegionPicker(bool forRegion) {
    RegionItem currentItem =
        ref.read(mobileLoginControllerProvider).currentRegion;
    RegionItem currentItem0 = currentItem;
    Future<RegionItem?> selectItem = GoRouter.of(context).push(
        RegionPickerPage.routePath,
        extra: RegionPickerPage.createExtra(currentItem0));
    controller.callBackRegion(selectItem, forRegion);
  }

  GlobalKey<OnekeyLoginWidgetState> _childKey =
      GlobalKey<OnekeyLoginWidgetState>();

  void cancelAuthPage() {
    LogUtils.i(
        '----------cancelAuthPage--------------_childKey.currentState?.cancelAuthPage()');
    _childKey.currentState?.cancelAuthPage();
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resouce) {
    return NavBar(
      backHidden: true,
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    if (ref.watch(
        mobileLoginControllerProvider.select((value) => value.prepared))) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 32, right: 32).withRTL(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnekeyLoginWidget(
              key: _childKey,
              isCnInit:
                  RegionUtils.isCn(RegionStore().currentRegion.countryCode),
              function:
                  ref.watch(privacyPolicyProvider.notifier).viewPrivacyInfo(),
              callback: onekeyLogin,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16).withRTL(context),
              child: Text(
                'text_account_login'.tr(),
                style: TextStyle(
                    fontSize: 28,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    color: style.textMain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16).withRTL(context),
              child: Text(
                'text_signIn_create_account_tip'.tr(),
                style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                    color: style.textSecond),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: RegionSelectMeun(
                onRegion: (RegionItem region) {
                  ref
                      .read(mobileLoginControllerProvider.notifier)
                      .changeRegion(region);
                },
                onTap: () {
                  LogModule().eventReport(3, 3, int2: 1);
                },
              ),
            ),
            // 输入框
            AnimatedInputText(
              key: const Key('mobile_input'),
              initialValue: ref.watch(mobileLoginControllerProvider
                  .select((value) => value.initAccount)),
              onTextChanged: onTextChanged,
              showCountryCode: false,
              underLineColor: style.lightBlack1,
              animateColor: style.click,
              showGetDynamicCode: false,
              textInputType: TextInputType.number,
              textHint: 'enter_mobile'.tr(),
              changeCountryCode: () {
                LogModule().eventReport(3, 4, int1: 1);
                // changeRegion(context, ref.read(mobileLoginControllerProvider),
                // onlyChangePhoneCode: true);
                _pushToRegionPicker(false);
              },
              onTap: () {
                LogModule().eventReport(3, 5, int1: 1);
              },
            ),
            const SizedBox(
              height: 62,
            ),
            // 按钮
            DMCommonClickButton(
                borderRadius: style.buttonBorder,
                disableBackgroundGradient: style.disableBtnGradient,
                disableTextColor: style.disableBtnTextColorGold,
                textColor: style.enableBtnTextColorGold,
                backgroundGradient: style.brandColorGradient,
                enable: ref.watch(mobileLoginControllerProvider).isButtonEnable,
                text: 'send_sms_code'.tr(),
                onClickCallback: getDynamicPress),
            const SizedBox(
              height: 32,
            ),
            InputAgreementSelect(
              isChecked: ref.watch(mobileLoginControllerProvider
                  .select((value) => value.isPrivacyChecked)),
              isCenter: true,
              onSelectChange: onSelectChange,
              onTapProtocol: (value) {
                LogModule().eventReport(
                    3, value == InputAgreementButtonType.userProtocol ? 15 : 16,
                    int1: 1);
              },
              styleModel: style,
            ),
            const Spacer(
              flex: 1,
            ),
            Consumer(builder: (_, ref, child) {
              return SocialLoginAuthWidget(
                isPrivacyChecked:
                    ref.watch(mobileLoginControllerProvider).isPrivacyChecked,
                isCnDomain: isCnRegion(ref
                    .watch(mobileLoginControllerProvider)
                    .currentRegion
                    .countryCode),
                text: 'text_other_login_methods'.tr(),
                btnImage: 'social_password',
                authCallback: socialAuthCallback,
                onCallingCallback: (calling) {
                  cancelAuthPage();
                },
                otherCallback: () {
                  LogModule().eventReport(3, 11, int1: 1);
                  String pagePath = RootPage.getPageRoutePath();
                  if (pagePath != PasswordLoginPage.routePath) {
                    GoRouter.of(context).push(PasswordLoginPage.routePath);
                  } else {
                    AppRoutes.resetStacks();
                  }
                },
              );
            }),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
