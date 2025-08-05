import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/model/send_message_action.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/send/social_sign_bind_email_uistate.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'social_sign_bind_email_state_notifier.g.dart';

@riverpod
class SocailSignBindEmailStateNotifier
    extends _$SocailSignBindEmailStateNotifier {
  String _email = '';

  @override
  SocailSignBindEmailUiState build() {
    return const SocailSignBindEmailUiState();
  }

  void init() {
    getBindSwitch();
  }

  Future<void> getBindSwitch() async {
    try {
      var isShowSkip =
          await ref.read(accountRepositoryProvider).getPhoneBindSwitch();
      state = state.copyWith(showSkip: !isShowSkip);
    } catch (e) {
      state = state.copyWith(showSkip: false);
    }
  }

  void emailChange(String email) {
    _email = email;
    bool enable = email.isNotEmpty;
    if (state.enableSend != enable) {
      state = state.copyWith(enableSend: enable);
    }
  }

  Future<SmscodeTrans?> sendMessage({bool checkRegisterFlag = true}) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_email.length > 45) {
      showToast('email_too_long'.tr());
      return null;
    }

    SmartDialog.showLoading();
    try {
      var lang = await LocalModule().getLangTag();
      EmailCodeReq smsCodeReq = EmailCodeReq(
        email: _email,
        lang: lang,
        checkRegisterFlag: checkRegisterFlag,
      );
      SendMessageAction<EmailCodeReq> action = SendMessageAction(
          smsCodeReq: smsCodeReq,
          request: ref.read(accountRepositoryProvider).sendSocialBindEmailCode);

      ref.read(sendMessageProviderProvider.notifier).updateAction(action);
      var request = await ref
          .read(sendMessageProviderProvider.notifier)
          .sendCode<EmailCodeReq>();
      SmartDialog.dismiss(status: SmartStatus.loading);
      showToast('send_success'.tr());
      return Future.value(request);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 30901:
          // 邮箱已注册
          // showAlert('text_account_unregister'.tr());
          showTip();
          break;
        case 10007:
          // 邮箱格式错误
          showToast('mail_error'.tr());
          break;
        default:
          // 其他错误
          showToast('send_sms_code_error'.tr());
          break;
      }
      return null;
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      showToast('send_sms_code_error'.tr());
      return null;
    }
  }

  void showToast(String text) {
    SmartDialog.showToast(text);
  }

  void showTip() {
    state = state.copyWith(event: SocialAlertTipEvent());
  }

  //这边是直接登录，就是跳过邮箱验证码，关键点为registerEmailSkip参数
  Future<bool> login({required String authType, required String token}) async {
    SocialLoginReq re = SocialLoginReq.create(
      authType: authType,
      thirdPartCode: token,
      emailCheck: 1,
      registerEmailSkip: true,
    );

    SmartDialog.showLoading();
    try {
      bool res =
          await ref.read(accountRepositoryProvider).socialSignIn(re) ?? true;
      if (res) {
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
      } else {
        SmartDialog.showToast('operate_failed'.tr());
      }

      return res;
    } on DreameAuthException catch (e) {
      SmartDialog.dismiss();
      var code = e.code;
      switch (code) {
        case 10017:
          // 绑定账号
          // return ActionEvent(
          //     action: ActionSocialAccountBind(
          //         source: e.oauthSource ?? '', uuid: e.uuid ?? ''));
          SmartDialog.showToast('operate_failed'.tr());
        case 20104:
          SmartDialog.showToast('operate_failed'.tr());
        case 20106:
          SmartDialog.showToast('operate_failed'.tr());
        case 20107:
          SmartDialog.showToast('operate_failed'.tr());
        case 10015:
          SmartDialog.showToast(
              'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr());
        case BadResultCode.NET_ERROR:
          SmartDialog.showToast('toast_net_error'.tr());

        case BadResultCode.CANCEL:
          SmartDialog.showToast('toast_net_error'.tr());

        case -1:
          SmartDialog.showToast('operate_failed'.tr());
        default:
          SmartDialog.showToast('operate_failed'.tr());
      }
      return false;
    } catch (e) {
      SmartDialog.dismiss();
      LogUtils.e('----------- socialSignIn -------- $e');
      SmartDialog.showToast('operate_failed'.tr());
      return false;
    }
  }
}
