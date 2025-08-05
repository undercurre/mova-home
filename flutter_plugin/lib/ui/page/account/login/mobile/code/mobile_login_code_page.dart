import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/code/mobile_login_code_state_notifier.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/countdown/count_down_widget.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_pincode_text_field.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 输入验证码界面
class MobileLoginCodePage extends BasePage {
  static const String routePath = '/mobile_login_code';

  const MobileLoginCodePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MobileLoginCodePageState();
  }
}

class _MobileLoginCodePageState extends BasePageState
    with CountDownWidget, CommonDialog, ResponseForeUiEvent {
  @override
  // TODO: implement centerTitle
  String get centerTitle => 'input_verify_code'.tr();

  @override
  void initData() {
    super.initData();
    var extra = GoRouterState.of(context).extra as SendCodeModel;
    LogUtils.d('------------- MobileLoginCodePage ----------- $extra ');
    ref.read(mobileLoginCodeStateNotifierProvider.notifier).init(extra);
    startTimer();
  }

  @override
  void addObserver() {
    ref.listen(mobileLoginCodeEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Future<void> login() async {
    LogModule().eventReport(3, 17, int1: 1);
    var result = await ref
        .read(mobileLoginCodeStateNotifierProvider.notifier)
        .mobileSignIn();

    if (result) {
      // 首页
      await AppRoutes.resetStacks();
    }
  }

  Future<void> sendCodeAgain(RecaptchaModel recaptchaModel) async {
    // LogUtils.d('-------- sendCodeAgain recaptchaModel -------- $recaptchaModel');
    bool result = await ref
        .read(mobileLoginCodeStateNotifierProvider.notifier)
        .sendCodeAgain(recaptchaModel);
    if (result) {
      startTimer();
    }
  }

  void onInputChange(String value) {
    ref.read(mobileLoginCodeStateNotifierProvider.notifier).sendInput(value);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      margin: const EdgeInsets.only(left: 32, right: 32).withRTL(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16).withRTL(context),
            child: Consumer(builder: (context, ref, child) {
              var uiState = ref.watch(mobileLoginCodeStateNotifierProvider);
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
          Padding(
              padding:
                  const EdgeInsets.only(top: 50, bottom: 26).withRTL(context),
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
                              args: [ref.watch(countDownProvider).toString()])
                          : 'sms_resend_again'.tr()),
                      style: TextStyle(
                          fontSize: style.middleText,
                          fontWeight: FontWeight.w400,
                          color: ref.watch(countDownProvider) >= 0
                              ? style.textDisable
                              : style.linkGold),
                      textAlign: TextAlign.end,
                    );
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 36).withRTL(context),
            child: DMCommonClickButton(
              borderRadius: style.buttonBorder,
              disableBackgroundGradient: style.disableBtnGradient,
              disableTextColor: style.disableBtnTextColor,
              textColor: style.enableBtnTextColor,
              backgroundGradient: style.confirmBtnGradient,
              enable: ref
                  .watch(mobileLoginCodeStateNotifierProvider)
                  .isInputInvalid,
              onClickCallback: login,
              text: 'text_signIn_or_signUp'.tr(),
            ),
          )
        ],
      ),
    );
  }
}
