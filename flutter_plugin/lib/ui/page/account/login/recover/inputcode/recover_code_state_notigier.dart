// ignore_for_file: unused_field

import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/able/verification_code_able.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/inputcode/recover_code_uistate.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recover_code_state_notigier.g.dart';

@riverpod
class RecoverCodeStateNotifier extends _$RecoverCodeStateNotifier
    with VerificationCodeAble {
  // late SmscodeTrans trans;
  int _countTime = 0;
  Timer? _currentTimer;
  String _number = '';
  @override
  RecoverCodeUiState build() {
    return RecoverCodeUiState();
  }

  void updateData(SmscodeTrans trans) {
    updateTrans(trans);
  }

  void updateTrans(SmscodeTrans trans) {
    startTime();
    this.trans = trans;
    String sourceText = '';
    String sourceWayText = '';
    switch (trans) {
      case SmscodeTransByPhone phoneSms:
        sourceText = '+${phoneSms.tel} ${phoneSms.phone}';
        sourceWayText = 'sms_send_to_phone'.tr();
        break;
      case SmscodeTransByMail mailSms:
        sourceText = mailSms.email ?? '';
        sourceWayText = 'sms_send_to_email'.tr();
        break;
    }
    state =
        state.copyWith(sourceText: sourceText, sourceWayText: sourceWayText);
  }

  void startTime() {
    _countTime = 59;
    const period = Duration(seconds: 1);
    _currentTimer?.cancel();
    _currentTimer = Timer.periodic(period, (timer) {
      _countTime--;
      checkTime();
    });
    checkTime();
  }

  Future<void> resetCode(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    //  SmartDialog.showLoading();
    try {
      SmscodeTrans res;

      if (trans.action.smsCodeReq is EmailCodeReq) {
        res = await ref
            .read(sendMessageProviderProvider.notifier)
            .sendCode<EmailCodeReq>();
      } else {
        trans.clearOld();
        res = await ref
            .read(sendMessageProviderProvider.notifier)
            .sendCode<SmsCodeReq>();
      }
      SmartDialog.dismiss();
      showToast('send_success'.tr());
      updateTrans(res);
    } on DreameException catch (e) {
      SmartDialog.dismiss();
      switch (e.code) {
        case 11004:
          showToast('text_error_toomuch'.tr());
          break;
        case 11003:
          showToast('send_sms_too_frequent'.tr());
          break;
        case 30400:
          showAlert('text_account_unregister'.tr());
          break;

        default:
          showToast('send_sms_code_error'.tr());
          break;
      }
    } catch (e) {
      SmartDialog.dismiss();
      if (e != 300101) {
        showToast('send_sms_code_error'.tr());
      }
    }
  }

  void checkTime() {
    String sendButtonText = '';
    bool sendEnable = false;
    if (_countTime >= 0) {
      sendButtonText = 'sms_resend_after'.tr(args: [_countTime.toString()]);
      sendEnable = false;
    } else {
      sendButtonText = 'sms_resend_again'.tr();
      sendEnable = true;
      _currentTimer?.cancel();
      _currentTimer = null;
    }
    state = state.copyWith(
      sendButtonText: sendButtonText,
      enableSend: sendEnable,
    );
  }

  void changeCode(String code) {
    _number = code;
    bool enable = _number.length == 6;
    state = state.copyWith(enableNext: enable);
  }

  void dispose() {
    _currentTimer?.cancel();
    _currentTimer = null;
  }

  Future<SmscodeTrans> checkCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading();

    try {
      switch (trans) {
        case SmscodeTransByPhone phoneSms:
          MobileCheckCodeReq req = MobileCheckCodeReq(
            phone: phoneSms.phone ?? '',
            phoneCode: phoneSms.tel ?? '',
            codeKey: phoneSms.codeKey ?? '',
            codeValue: _number,
          );
          await ref
              .read(accountRepositoryProvider)
              .checkRecoverByPhoneVerificationCode(req);
          SmartDialog.dismiss();
          return Future.value(phoneSms);
        case SmscodeTransByMail mailSms:
          EmailCheckCodeReq req = EmailCheckCodeReq(
            codeKey: mailSms.codeKey ?? '',
            email: mailSms.email ?? '',
            codeValue: _number,
          );
          await ref
              .read(accountRepositoryProvider)
              .checkRecoverByMailVerificationCode(req);
          SmartDialog.dismiss();
          return Future.value(mailSms);
      }
    } on DreameException catch (e) {
      SmartDialog.dismiss();
      switch (e.code) {
        case 11011:
        case 11010:
        case 11001:
        case 11000:
          SmartDialog.showToast('sms_code_invalid_expired'.tr());
          break;
        default:
          SmartDialog.showToast('operate_failed'.tr());
      }

      return Future.error(e);
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('operate_failed'.tr());
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

  void _goToRegister() {
    state = state.copyWith(event: PushEvent(path: MobileSignUpPage.routePath));
  }
}
