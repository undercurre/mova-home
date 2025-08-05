import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/email/signup_email_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/countdown/count_down_widget.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import 'mobile_signup_password_state_notifier.dart';

/// 手机号注册 输入密码页
class MobileSignUpPasswordPage extends BasePage {
  static const String routePath = '/mobile_signup_password';

  const MobileSignUpPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MobileSignUpPasswordPageState();
  }
}

class _MobileSignUpPasswordPageState extends BasePageState
    with CountDownWidget, CommonDialog, ResponseForeUiEvent {
  @override
  void initData() {
    super.initData();
    var uiState =
        AppRoutes().getGoRouterStateExtra<RegisterByPasswordReq>(context);
    ref
        .read(mobileSignUpPasswordStateNotifierProvider.notifier)
        .initData(uiState!);
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(mobileSignUpPasswordUiEventProvider, (pre, next) {
      LogUtils.d('----------screenUiShowProvider listen ------ $pre $next');
      var action = responseFor(next);
      if (action is ShowSignUpDialog) {
        showHasSignUpDialog();
      } else if (action is ShowEmailCollectionSubscribe) {
        emailCollectionSubscribeAlert();
      }
    });
  }

  void onTextChangedPassword(text) {
    ref
        .read(mobileSignUpPasswordStateNotifierProvider.notifier)
        .sendInput(text);
  }

  /// 立即登录
  void signInNow() {
    String pagePath = RootPage.getPageRoutePath();
    AppRoutes.resetStacks();
    if (pagePath != MobileLoginPage.routePath) {
      // push 到密码登录
      GoRouter.of(context).push(MobileLoginPage.routePath);
    }
  }

  /// 该账户已注册
  void showHasSignUpDialog() {
    showCommonDialog(
      tag: 'MobileHasSignUp',
      content: 'account_has_registered'.tr(),
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
            child: Text(
              'set_password'.tr(),
              style: TextStyle(
                  color: style.textMain,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20)
                .withRTL(context),
            child: AnimatedInputText(
              onTextChanged: onTextChangedPassword,
              showCountryCode: false,
              showGetDynamicCode: false,
              showEye: true,
              textHint: 'reset_input_new_password'.tr(),
              fontSize: style.head,
              hintFontSize: style.largeText,
              textInputType: TextInputType.text,
              hidePassword: ref.watch(mobileSignUpPasswordStateNotifierProvider
                  .select((value) => value.hidePassword)),
              inputType: AnimatedInputText.INPUT_TYPE_PWD,
              onPassWordHideChanged: (value) {
                LogModule().eventReport(2, 22, int1: 1);
                ref
                    .read(mobileSignUpPasswordStateNotifierProvider.notifier)
                    .passwordHidenChange(value);
              },
              onTap: () {
                LogModule().eventReport(2, 21, int1: 1);
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
            padding: const EdgeInsets.only(left: 24, right: 24, top: 56)
                .withRTL(context),
            child: DMCommonClickButton(
                disableBackgroundGradient: style.disableBtnGradient,
                disableTextColor: style.disableBtnTextColor,
                textColor: style.enableBtnTextColor,
                backgroundGradient: style.confirmBtnGradient,
                borderRadius: style.buttonBorder,
                enable: ref.watch(mobileSignUpPasswordStateNotifierProvider
                    .select((value) => value.isButtonEnable)),
                text: 'reg_now'.tr(),
                onClickCallback: () async {
                  var ret = await ref
                      .read(mobileSignUpPasswordStateNotifierProvider.notifier)
                      .MobileSignUpPassword();
                  if (ret) {
                    await AppRoutes.resetStacks();
                  }
                }),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
