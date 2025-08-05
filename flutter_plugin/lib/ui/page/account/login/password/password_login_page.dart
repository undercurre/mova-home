import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/able/reset_router_enable.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart'
    show ResponseForeUiEvent;
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/input_agreement_select.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth_widget.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 密码登录页面参数
const String param_type = 'param_type';
const String param_account = 'param_account';
const String param_pwd = 'param_pwd';

class NewIntentEvent {
  final String routePath;
  final Map<String, dynamic> params;

  NewIntentEvent(this.routePath, this.params);
}

/// 密码登录页面
class PasswordLoginPage extends BasePage {
  static const String routePath = '/mail_login';

  const PasswordLoginPage({super.key});

  @override
  PasswordLoginPageState createState() {
    return PasswordLoginPageState();
  }
}

class PasswordLoginPageState extends BasePageState
    with ResetRouterEnbale, CommonDialog, ResponseForeUiEvent {
  late PasswordLoginStateNotifier controller =
      ref.read(passwordLoginStateNotifierProvider.notifier);

  final GlobalKey<AnimatedInputTextState> _accountGlobalKey =
      GlobalKey(debugLabel: 'account');
  final GlobalKey<AnimatedInputTextState> _passwordGlobalKey =
      GlobalKey(debugLabel: 'pwd');

  @override
  void addObserver() {
    super.addObserver();
    addUIEventListen();
  }

  @override
  void initData() {
    super.initData();
    var extra = GoRouterState.of(context).extra;
    final extras = extra != null ? extra as Map<String, dynamic> : null;
    controller.onLoad(extra: extras);
  }

  void addUIEventListen() {
    ref.listen(
        passwordLoginStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });

    /// 监听消息
    EventBusUtil.getInstance().register<NewIntentEvent>(this, (event) {
      if (event.routePath == PasswordLoginPage.routePath) {
        LogUtils.d('PasswordLoginPageState addUIEventListen ${event.params}');
        if (event.params.containsKey(param_account)) {
          var paramAccount = event.params[param_account] ?? '';
          var paramPwd = event.params[param_pwd] ?? '';
          if (paramAccount !=
              _accountGlobalKey.currentState?.currentInputText()) {
            controller.accountChanged(paramAccount);
            controller.passwordChanged(paramPwd);
            _accountGlobalKey.currentState
                ?.clearAndReInput(input: paramAccount);
            _passwordGlobalKey.currentState?.clearAndReInput(input: paramPwd);
          }
        }
      }
    });
  }

  Future<void> socialAuthCallback(success, authType, token) async {
    if (authType == 'WECHAT_OPEN') {
      LogModule().eventReport(3, 20, int2: 1);
    } else if (authType == 'APPLE') {
      LogModule().eventReport(3, 19, int2: 1);
    }
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
    LogUtils.d('-----------$success $authType $token');
    if (!success) {
      LogModule().eventReport(2, 25, int1: int1, int2: 1);
      return;
    }

    var ret = await ref
        .read(passwordLoginStateNotifierProvider.notifier)
        .socialSignIn(authType, token);

    if (ret) {
      // await ref.read(appConfigProvider.notifier).resetApp();
      LogModule().eventReport(2, 25, int1: int1, int2: 2);
      await AppRoutes.resetStacks();
    } else {
      LogModule().eventReport(2, 25, int1: int1, int2: 1);
    }
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().unRegister(this);
    super.dispose();
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16).withRTL(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            padding: const EdgeInsets.only(top: 40),
            child: RegionSelectMeun(
              onRegion: (RegionItem region) {
                ref
                    .read(passwordLoginStateNotifierProvider.notifier)
                    .updateRegion(region);
              },
              onTap: () {
                LogModule().eventReport(3, 3, int2: 1);
              },
            ),
          ),
          AutofillGroup(
            child: Column(
              children: [
                AnimatedInputText(
                  key: _accountGlobalKey,
                  initialValue: ref.watch(passwordLoginStateNotifierProvider
                      .select((value) => value.initAccount)),
                  textHint: 'login_user_hint'.tr(),
                  showCountryCode: false,
                  underLineColor: style.lightBlack1,
                  animateColor: style.click,
                  showGetDynamicCode: false,
                  // textInputType: TextInputType.name,
                  onTextChanged: (text) {
                    controller.accountChanged(text);
                  },
                  onTap: () {
                    LogModule().eventReport(3, 6, int1: 1);
                  },
                  autofillHints: const [AutofillHints.username],
                ),
                AnimatedInputText(
                  key: _passwordGlobalKey,
                  initialValue: ref.watch(passwordLoginStateNotifierProvider
                      .select((value) => value.initPassword)),
                  inputType: AnimatedInputText.INPUT_TYPE_PWD,
                  textHint: 'enter_pwd'.tr(),
                  underLineColor: style.lightBlack1,
                  animateColor: style.click,
                  hidePassword: ref.watch(passwordLoginStateNotifierProvider
                      .select((value) => value.hidePassword)),
                  showCountryCode: false,
                  textInputType: TextInputType.visiblePassword,
                  showEye: true,
                  onTextChanged: (text) {
                    controller.passwordChanged(text);
                  },
                  onPassWordHideChanged: (value) {
                    LogModule().eventReport(3, 8, int1: 1);
                    controller.passwordHidenChange(value);
                  },
                  onTap: () {
                    LogModule().eventReport(3, 8, int1: 1);
                  },
                  autofillHints: const [AutofillHints.password],
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.red,
            margin: const EdgeInsets.only(top: 16).withRTL(context),
            // alignment: Alignment.centerLeft.withRTL(context),
            // color: Colors.black,
            child: InputAgreementSelect(
              isChecked: ref.watch(passwordLoginStateNotifierProvider
                  .select((value) => value.agreed)),
              onSelectChange: (value) {
                LogModule().eventReport(3, 14, int2: 1);
                controller.agreementStatusUpdate(value);
              },
              onTapProtocol: (value) {
                LogModule().eventReport(
                    3, value == InputAgreementButtonType.userProtocol ? 15 : 16,
                    int2: 1);
              },
              styleModel: style,
            ),
          ),
          DMCommonClickButton(
            borderRadius: style.buttonBorder,
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColorGold,
            textColor: style.enableBtnTextColorGold,
            backgroundGradient: style.brandColorGradient,
            enable: ref.watch(passwordLoginStateNotifierProvider
                .select((value) => value.submitEnable)),
            margin: const EdgeInsets.only(top: 21.5).withRTL(context),
            text: 'login'.tr(),
            onClickCallback: () async {
              LogModule().eventReport(3, 17, int2: 1);
              await ref
                  .read(passwordLoginStateNotifierProvider.notifier)
                  .passWordSignIn();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16).withRTL(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'reg_now'.tr(),
                        style: style.mainStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ).onClick(() {
                  LogModule().eventReport(3, 18, int2: 1);
                  // GoRouter.of(context).push(controller.getToRegisterRouter());
                  pushToRegister();
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16).withRTL(context),
                  child: Text(
                    'forgot_pwd'.tr(),
                    style: style.mainStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ).onClick(() {
                  LogModule().eventReport(3, 13, int1: 1);
                  controller.pushToRecover(context);
                }),
              ),
            ],
          ),
          const Spacer(
            flex: 1,
          ),
          Consumer(builder: (_, ref, child) {
            return SocialLoginAuthWidget(
              isPrivacyChecked:
                  ref.watch(passwordLoginStateNotifierProvider).agreed,
              isCnDomain: ref
                      .watch(passwordLoginStateNotifierProvider)
                      .currentItem
                      ?.countryCode ==
                  'CN',
              text: 'text_other_login_methods'.tr(),
              btnImage: 'social_mobile',
              authCallback: socialAuthCallback,
              otherCallback: () {
                LogModule().eventReport(3, 12, int1: 1);
                String pagePath = RootPage.getPageRoutePath();
                if (pagePath != MobileLoginPage.routePath) {
                  GoRouter.of(context).push(MobileLoginPage.routePath);
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
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(backHidden: true);
  }
}
