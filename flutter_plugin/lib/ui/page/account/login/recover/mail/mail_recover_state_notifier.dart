import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/model/send_message_action.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_uistate.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mail_recover_state_notifier.g.dart';

@riverpod
class MailRecoverStateNotifier extends _$MailRecoverStateNotifier {
  String _email = '';
  @override
  MailRecoverUiState build() {
    return MailRecoverUiState();
  }

  void emailChange(String email) {
    _email = email;
    bool enable = email.isNotEmpty;
    if (state.enableSend != enable) {
      state = state.copyWith(enableSend: enable);
    }
  }

  Future<SmscodeTrans> sendMessage() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_email.length > 45) {
      showToast('email_too_long'.tr());
      return Future.error(-1);
    }

    SmartDialog.showLoading();
    try {
      var lang = await LocalModule().getLangTag();
      EmailCodeReq smsCodeReq = EmailCodeReq(
        email: _email,
        lang: lang,
      );
      SendMessageAction<EmailCodeReq> action = SendMessageAction(
          smsCodeReq: smsCodeReq,
          request: ref
              .read(accountRepositoryProvider)
              .getRecoverByMailVerificationCode);
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
        case 30401:
          // 账号未注册
          showAlert('text_account_unregister'.tr());
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
      return Future.error(e);
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      showToast('send_sms_code_error'.tr());
      return Future.error(e);
    }
  }

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
  }

  void showAlert(String text) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: 'cancel'.tr(),
      confirmContent: 'confirm'.tr(),
      confirmCallback: _goToRegister,
    );
    state = state.copyWith(event: alert);
  }

  Future<void> _goToRegister() async {
    String registerPath = MobileSignUpPage.routePath;
    state = state.copyWith(
      event: PushEvent(
        path: registerPath,
        func: RouterFunc.push,
      ),
    );
  }
}
