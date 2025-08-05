import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/account/signup/email_standby/email_signup_state_notifier.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/countdown/count_down_widget.dart';
import 'package:flutter_plugin/ui/widget/account/input_agreement_select.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/region_utils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

/// 邮箱注册
class EmailSignUpPage extends BasePage {
  static const String routePath = '/email_signup';

  const EmailSignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EmailSignUpPageState();
  }
}

class _EmailSignUpPageState extends BasePageState
    with CountDownWidget, CommonDialog, ResponseForeUiEvent {
  late EmailSignUpStateNotifier controller =
      ref.read(emailSignUpStateNotifierProvider.notifier);

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(emailSignUpUiEventProvider, (previous, next) {
      var action = responseFor(next);
      if (action is ShowSignUpDialog) {
        showHasSignUpDialog(isEmail: true);
      } else if (action is ShowEmailCollectionSubscribe) {
        emailCollectionSubscribeAlert();
      }
    });

    ref.listen(mobileSignUpUiEventProvider, (previous, next) {
      var action = responseFor(next);
      if (action is ShowSignUpDialog) {
        showHasSignUpDialog(isEmail: false);
      }
    });
  }

  void onTextChangedPassword(text) {
    ref.read(emailSignUpStateNotifierProvider.notifier).sendInput3(text);
  }

  void onTextChangedAccount(text) {
    ref.read(emailSignUpStateNotifierProvider.notifier).sendInput(text);
  }

  /// 立即登录
  void signInNow() {
    AppRoutes.resetStacks();
  }

  void gotoMobileSignIn() {
    LogModule().eventReport(2, 10, int1: 1);
    CommonUIEvent event =
        PushEvent(path: MobileSignUpPage.routePath, func: RouterFunc.go);
    responseFor(event);
  }

  Future<void> skipsubscribe() async {
    String? uid = (await AccountModule().getUserInfo())?.uid;
    if (uid == null) return;
    int timestamp = 1;
    DateTime now = DateTime.now();
    timestamp = now.millisecondsSinceEpoch;
    await LocalStorage().putLong(
        'overser_emall_device_collection_$uid', timestamp,
        fileName: 'keepWithoutUid');
  }

  /// 该账户已注册
  void showHasSignUpDialog({required bool isEmail}) {
    showCommonDialog(
      tag: 'EmailHasSignUp',
      content:
          isEmail ? 'email_has_registered'.tr() : 'account_has_registered'.tr(),
      cancelContent: 'cancel'.tr(),
      confirmContent: 'login_now'.tr(),
      confirmCallback: () {
        LogModule().eventReport(2, 20, int2: 1);
        String pagePath = RootPage.getPageRoutePath();
        AppRoutes.resetStacks();
        if (pagePath != PasswordLoginPage.routePath) {
          // push 到密码登录
          GoRouter.of(context).push(PasswordLoginPage.routePath);
        }
      },
      cancelCallback: () {
        LogModule().eventReport(2, 19, int2: 1);
      },
    );
  }

  /// 邮箱订阅弹框
  void emailCollectionSubscribeAlert() {
    showAlertDialog(
      content: 'email_collection_subscribe_alert'.tr(),
      cancelContent: 'Text_3rdPartyBundle_BundlePage_Skip'.tr(),
      confirmContent: 'subscribe'.tr(),
      confirmCallback: () async {
        await ref.read(emailCollectionRespositoryProvider.notifier).subscribe();
        await LifeCycleManager().logingSuccess();
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('register_success'.tr());
      },
      cancelCallback: () async {
        await skipsubscribe();
        await LifeCycleManager().logingSuccess();
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('register_success'.tr());
      },
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
              .withRTL(context),
          child: Text(
            'text_account_signup'.tr(),
            style: TextStyle(
                color: style.textMain,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 40)
              .withRTL(context),
          child: RegionSelectMeun(
            onRegion: (region) {
              ref
                  .read(emailSignUpStateNotifierProvider.notifier)
                  .changeRegion(region);

              if (RegionUtils.isCn(region.countryCode)) {
                ref
                    .read(mobileSignUpStateNotifierProvider.notifier)
                    .changeRegion(region);
              }
            },
            onTap: () {
              LogModule().eventReport(2, 3, int2: 2);
            },
          ),
        ),
        ...buildInputs(context, style, resource),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20)
              .withRTL(context),
          child: InputAgreementSelect(
            isChecked: ref.watch(emailSignUpStateNotifierProvider
                .select((value) => value.isPrivacyChecked)),
            onSelectChange: (value) {
              ref
                  .watch(emailSignUpStateNotifierProvider.notifier)
                  .onSelectChange(value);
              ref
                  .watch(mobileSignUpStateNotifierProvider.notifier)
                  .onSelectChange(value);
            },
            onTapProtocol: (value) {
              LogModule().eventReport(
                  2, value == InputAgreementButtonType.userProtocol ? 12 : 11,
                  int2: 1);
            },
            styleModel: style,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 56)
              .withRTL(context),
          child: DMCommonClickButton(
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              borderRadius: style.buttonBorder,
              enable: ref.watch(emailSignUpStateNotifierProvider
                      .select((value) => value.isEmail))
                  ? ref.watch(emailSignUpStateNotifierProvider
                      .select((value) => value.isButtonEnable))
                  : ref.watch(mobileSignUpStateNotifierProvider
                      .select((value) => value.isButtonEnable)),
              text: ref.watch(emailSignUpStateNotifierProvider
                      .select((value) => value.isEmail))
                  ? 'reg_now'.tr()
                  : 'next'.tr(),
              onClickCallback: () async {
                LogModule().eventReport(2, 15, int1: 1);
                var isEmail = ref.read(emailSignUpStateNotifierProvider
                    .select((value) => value.isEmail));
                if (!isEmail) {
                  var ret = await ref
                      .read(mobileSignUpStateNotifierProvider.notifier)
                      .mobileSignUpVerifyCode();
                } else {
                  var ret = await ref
                      .read(emailSignUpStateNotifierProvider.notifier)
                      .emailSignUp();
                  //
                }
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
                            LogModule().eventReport(2, 16, int2: 1);
                            signInNow();
                          })
                  ]))),
        ),
      ],
    );
  }

  List<Widget> buildInputs(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return ref.watch(
            emailSignUpStateNotifierProvider.select((value) => !value.isEmail))
        ? buildMobileSingup(context, style, resource)
        : buildEmailSignUp(context, style, resource);
  }

  List<Widget> buildEmailSignUp(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return [
      Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 0).withRTL(context),
        child: AnimatedInputText(
          key: const Key('email_signup_1'),
          onTextChanged: onTextChangedAccount,
          showCountryCode: false,
          showGetDynamicCode: false,
          showEye: false,
          textHint: 'mail_address'.tr(),
          onTap: () {
            LogModule().eventReport(2, 6, int1: 1);
          },
          fontSize: style.head,
          hintFontSize: style.largeText,
          textInputType: TextInputType.text,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
            .withRTL(context),
        child: AnimatedInputText(
          key: const Key('email_signup_1'),
          onTextChanged: onTextChangedPassword,
          showCountryCode: false,
          showGetDynamicCode: false,
          showEye: true,
          textHint: 'reset_input_new_password'.tr(),
          fontSize: style.head,
          hintFontSize: style.largeText,
          textInputType: TextInputType.text,
          inputType: AnimatedInputText.INPUT_TYPE_PWD,
          hidePassword: ref.watch(emailSignUpStateNotifierProvider
              .select((value) => value.hidePassword)),
          onPassWordHideChanged: (value) {
            LogModule().eventReport(2, 22, int2: 1);
            controller.passwordHidenChange(value);
          },
          onTap: () {
            LogModule().eventReport(2, 21, int2: 1);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
            .withRTL(context),
        child: Text(
          'text_new_password_tips'.tr(),
          style: style.secondStyle(),
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20)
              .withRTL(context),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              resource.getResource('icon_mobile'),
              width: 32,
              height: 32,
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Text(
              'reg_by_phone'.tr(),
              style: style.mainStyle(fontWeight: FontWeight.w400),
            ),
          ]).onClick(() {
            // 切换到手机号注册
            ref
                .watch(emailSignUpStateNotifierProvider.notifier)
                .changeRegisterType(isEmail: false);
          }))
    ];
  }

  List<Widget> buildMobileSingup(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return [
      Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 0).withRTL(context),
        child: AnimatedInputText(
          key: const Key('mobile_signup_1'),
          onTextChanged: onTextChangedPhone,
          showCountryCode: false,
          showGetDynamicCode: false,
          showEye: false,
          textHint: 'enter_mobile'.tr(),
          fontSize: style.head,
          hintFontSize: style.largeText,
          textInputType: TextInputType.number,
        ),
      ),
      Consumer(builder: (_, ref, child) {
        var coundownValue = ref.watch(countDownProvider);
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16)
              .withRTL(context),
          child: AnimatedInputText(
            key: const Key('mobile_signup_2'),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onTextChanged: onTextChangedDynamic,
            showCountryCode: false,
            showGetDynamicCode: true,
            enableGetDynamicCode: ref.watch(mobileSignUpStateNotifierProvider
                .select((value) => value.enableGetDynamic)),
            dynamicCodeText: coundownValue == 60 || coundownValue < 0
                ? 'send_sms_code'.tr()
                : '${coundownValue}s',
            onGetDynamicCodePress: () {
              LogModule().eventReport(2, 8, int1: 1);
              var isEnable = ref.watch(countDownProvider.notifier).isEnable();
              if (isEnable) {
                LogUtils.d('------------ onGetDynamicCodePress ---------');
                var phoneNumber =
                    ref.watch(mobileSignUpStateNotifierProvider).account;
                if (phoneNumber == null || phoneNumber.isEmpty) {
                  return;
                }
                bool ret = ref
                    .watch(mobileSignUpStateNotifierProvider.notifier)
                    .checkPhoneNumber();
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
      Visibility(
        visible: ref.watch(
            emailSignUpStateNotifierProvider.select((value) => !value.isCn)),
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20)
              .withRTL(context),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              resource.getResource('icon_email'),
              width: 10.5,
              height: 15,
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
            Text(
              'reg_by_mail'.tr(),
              style: style.mainStyle(fontWeight: FontWeight.w400),
            ),
          ]).onClick(() {
            // 切换到邮箱注册
            ref
                .watch(emailSignUpStateNotifierProvider.notifier)
                .changeRegisterType(isEmail: true);
            ref.read(mobileSignUpStateNotifierProvider.notifier).initData();
          }),
        ),
      ),
    ];
  }

  void onTextChangedDynamic(String value) {
    ref.read(mobileSignUpStateNotifierProvider.notifier).sendInput2(value);
  }

  void onTextChangedPhone(text) {
    ref.read(mobileSignUpStateNotifierProvider.notifier).sendInput(text);
  }

  Future<void> sendDynamic(RecaptchaModel next) async {
    LogUtils.d('-------- sendDynamic ---------  $next');
    var ret = await ref
        .read(mobileSignUpStateNotifierProvider.notifier)
        .sendDynamicCode(next);
    if (ret) {
      startTimer();
    }
  }
}
