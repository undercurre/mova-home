import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/account/signup/email/signup_email_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/email_standby/email_signup_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/countdown/count_down_widget.dart';
import 'package:flutter_plugin/ui/widget/account/input_agreement_select.dart';
import 'package:flutter_plugin/ui/widget/account/personalized_advertising_select.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 手机号注册
class MobileSignUpPage extends BasePage {
  static const String routePath = '/mobile_signup';

  const MobileSignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MobileSignUpPageState();
  }
}

class _MobileSignUpPageState extends BasePageState
    with CountDownWidget, CommonDialog, ResponseForeUiEvent {
  TextEditingController accountEditingController = TextEditingController();
  TextEditingController codeEditingController = TextEditingController();
  @override
  void addObserver() {
    super.addObserver();
    ref.listen(mobileSignUpUiEventProvider, (pre, next) {
      LogUtils.d('----------screenUiShowProvider listen ------ $pre $next');
      var action = responseFor(next);
      if (action is ShowSignUpDialog) {
        showHasSignUpDialog();
      }
    });
  }

  void onTextChangedPhone(text) {
    ref.read(mobileSignUpStateNotifierProvider.notifier).sendInput(text);
  }

  void onTextChangedDynamic(text) {
    ref.read(mobileSignUpStateNotifierProvider.notifier).sendInput2(text);
  }

  Future<void> sendDynamic(RecaptchaModel next) async {
    LogUtils.d('-------- sendDynamic ---------  $next');

    /// 隐藏键盘
    ///
    var ret = await ref
        .read(mobileSignUpStateNotifierProvider.notifier)
        .sendDynamicCode(next);
    if (ret) {
      startTimer();
    }
  }

  /// 立即登录
  void signInNow() {
    String pagePath = RootPage.getPageRoutePath();
    String willPushPath = ref
                .read(mobileSignUpStateNotifierProvider
                    .select((value) => value.currentRegion))
                .countryCode
                .toLowerCase() ==
            'cn'
        ? MobileLoginPage.routePath
        : PasswordLoginPage.routePath;
    AppRoutes.resetStacks();
    if (pagePath != willPushPath) {
      // push 到密码登录BUG2177-7681
      GoRouter.of(context).push(willPushPath);
    }
  }

  void gotoEmailSignIn() {
    LogModule().eventReport(2, 9, int1: 1);
    // CommonUIEvent event =
    //     PushEvent(path: SignUpEmailPage.routePath, func: RouterFunc.go);
    // responseFor(event);
    countReset();
    ref.read(mobileSignUpStateNotifierProvider.notifier).changeSignType();
    accountEditingController.clear();
    codeEditingController.clear();
  }

  /// 该账户已注册
  void showHasSignUpDialog() {
    showCommonDialog(
      tag: 'MobileHasSignUp',
      content: ref.read(mobileSignUpStateNotifierProvider
                  .select((value) => value.singupType)) ==
              SignUpType.phoneNumber
          ? 'account_has_registered'.tr()
          : 'email_has_registered'.tr(),
      cancelContent: 'cancel'.tr(),
      confirmContent: 'login_now'.tr(),
      confirmCallback: () {
        LogModule().eventReport(2, 20, int1: 1);
        signInNow();
      },
      cancelCallback: () {
        LogModule().eventReport(2, 19, int1: 1);
      },
    );
  }

  void tryToPushStandBy() {
    if (ref.read(mobileSignUpStateNotifierProvider
            .select((value) => value.singupType)) ==
        SignUpType.phoneNumber) {
      return;
    }
    GoRouter.of(context).push(EmailSignUpPage.routePath);
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
                .withRTL(context),
            child: GestureDetector(
              onLongPressUp: () {
                tryToPushStandBy();
              },
              child: Text(
                'text_account_signup'.tr(),
                style: TextStyle(
                    color: style.textMain,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 40)
                .withRTL(context),
            child: RegionSelectMeun(
              onRegion: (region) {
                ref
                    .read(mobileSignUpStateNotifierProvider.notifier)
                    .changeRegion(region);
              },
              onTap: () {
                LogModule().eventReport(2, 3, int1: 1);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 0)
                .withRTL(context),
            child: AnimatedInputText(
              underLineColor: style.lightBlack1,
              animateColor: style.click,
              textEditingController: accountEditingController,
              onTextChanged: onTextChangedPhone,
              showCountryCode: false,
              showGetDynamicCode: false,
              showEye: false,
              textHint: ref.read(mobileSignUpStateNotifierProvider
                          .select((value) => value.singupType)) ==
                      SignUpType.phoneNumber
                  ? 'enter_mobile'.tr()
                  : 'please_input_email'.tr(),
              fontSize: style.head,
              hintFontSize: style.largeText,
              textInputType: ref.read(mobileSignUpStateNotifierProvider
                          .select((value) => value.singupType)) ==
                      SignUpType.phoneNumber
                  ? TextInputType.number
                  : TextInputType.emailAddress,
            ),
          ),
          Consumer(builder: (_, ref, child) {
            var coundownValue = ref.watch(countDownProvider);
            return Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
                  .withRTL(context),
              child: AnimatedInputText(
                underLineColor: style.lightBlack1,
                animateColor: style.click,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                textEditingController: codeEditingController,
                onTextChanged: onTextChangedDynamic,
                showCountryCode: false,
                showGetDynamicCode: true,
                enableGetDynamicCode: ref.watch(
                    mobileSignUpStateNotifierProvider
                        .select((value) => value.enableGetDynamic)),
                dynamicCodeText: coundownValue == 60 || coundownValue < 0
                    ? 'send_sms_code'.tr()
                    : '${coundownValue}s',
                onGetDynamicCodePress: () {
                  LogModule().eventReport(2, 8, int1: 1);
                  var isEnable =
                      ref.watch(countDownProvider.notifier).isEnable();
                  if (isEnable) {
                    LogUtils.d('------------ onGetDynamicCodePress ---------');
                    var phoneNumber =
                        ref.watch(mobileSignUpStateNotifierProvider).account;
                    if (phoneNumber == null || phoneNumber.isEmpty) {
                      return;
                    }
                    bool ret = true;
                    if (ref.read(mobileSignUpStateNotifierProvider.select(
                        (value) =>
                            value.singupType == SignUpType.phoneNumber))) {
                      ret = ref
                          .watch(mobileSignUpStateNotifierProvider.notifier)
                          .checkPhoneNumber();
                    }

                    if (ret) {
                      RecaptchaController(context, (recaptchaModel) {
                        sendDynamic(recaptchaModel);
                      }).check();
                    }
                  }
                },
                showEye: false,
                textHint: 'input_verify_code'.tr(),
                fontSize: style.head,
                hintFontSize: style.largeText,
                textInputType: TextInputType.number,
              ),
            );
          }),
          ref.watch(mobileSignUpStateNotifierProvider
                      .select((value) => value.showChangeType)) ==
                  -1
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 20)
                      .withRTL(context),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          resource.getResource(ref.watch(
                                      mobileSignUpStateNotifierProvider.select(
                                          (value) => value.showChangeType)) ==
                                  1
                              ? 'icon_email'
                              : 'icon_mobile'),
                          width: 32,
                          height: 32,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0)),
                        Expanded(
                          // width: double.maxFinite,
                          child: Text(
                            ref.watch(mobileSignUpStateNotifierProvider.select(
                                        (value) => value.showChangeType)) ==
                                    1
                                ? 'reg_by_mail'.tr()
                                : 'reg_by_phone'.tr(),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: style.mainStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ]).onClick(() {
                    gotoEmailSignIn();
                  }),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 0)
                .withRTL(context),
            child: InputAgreementSelect(
              isChecked: ref.watch(mobileSignUpStateNotifierProvider
                  .select((value) => value.isPrivacyChecked)),
              onSelectChange: (value) {
                ref
                    .read(mobileSignUpStateNotifierProvider.notifier)
                    .onSelectChange(value);
              },
              onTapProtocol: (value) {
                LogModule().eventReport(
                    2, value == InputAgreementButtonType.userProtocol ? 12 : 11,
                    int1: 1);
              },
              styleModel: style,
            ),
          ),
          Visibility(
            visible: RegionStore().currentRegion.countryCode.toLowerCase() != 'cn',
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 0)
                      .withRTL(context),
              child: PersonalizedAdvertisingSelect(
                isChecked: ref.watch(mobileSignUpStateNotifierProvider
                    .select((value) => value.isPersonalizedAdChecked)),
                isCenter: true,
                styleModel: style,
                onSelectChange: (value) {
                  ref
                      .read(mobileSignUpStateNotifierProvider.notifier)
                      .onPersonalizedAdSelectChange(value);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 56)
                .withRTL(context),
            child: DMCommonClickButton(
                disableBackgroundGradient: style.disableBtnGradient,
                disableTextColor: style.disableBtnTextColorGold,
                textColor: style.enableBtnTextColorGold,
                backgroundGradient: style.brandColorGradient,
                borderRadius: style.buttonBorder,
                enable: ref.watch(mobileSignUpStateNotifierProvider
                    .select((value) => value.isButtonEnable)),
                text: 'next'.tr(),
                onClickCallback: () async {
                  var ret = await ref
                      .read(mobileSignUpStateNotifierProvider.notifier)
                      .mobileSignUpVerifyCode();
                }),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 32)
                    .withRTL(context),
                child: Text.rich(TextSpan(
                    text: 'already_have_account'.tr(),
                    style: style.secondStyle(),
                    children: [
                      TextSpan(
                          text: 'login_now'.tr(),
                          style: style.clickStyle(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              LogModule().eventReport(2, 16, int1: 1);
                              String pagePath = RootPage.getPageRoutePath();

                              String dirPath = ref.read(
                                          mobileSignUpStateNotifierProvider
                                              .select((value) =>
                                                  value.singupType)) ==
                                      SignUpType.phoneNumber
                                  ? MobileLoginPage.routePath
                                  : PasswordLoginPage.routePath;
                              AppRoutes.resetStacks();
                              if (pagePath != dirPath) {
                                GoRouter.of(context).push(dirPath);
                              }
                            })
                    ]))),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
