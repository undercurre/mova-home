import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/able/verification_code_able.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/check_code/mobile_bind_check_code_uistate.dart';
import 'package:flutter_plugin/ui/page/mine/mine_repository.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mobile_bind_check_code_state_notifier.g.dart';

@riverpod
class MobileBindCheckCodeStateNotifier
    extends _$MobileBindCheckCodeStateNotifier with VerificationCodeAble {
  @override
  late SmscodeTrans trans;
  int _countTime = 0;
  Timer? _currentTimer;
  String _number = '';
  @override
  MobileBindCheckCodeUiState build() {
    return MobileBindCheckCodeUiState();
  }

  void updateData(SmscodeTrans trans) {
    updateTrans(trans);
  }

  void updateTrans(SmscodeTrans trans) {
    startTime();
    this.trans = trans;
    String sourceText = '';
    String sourceWayText = '';
    SmscodeTransByPhone phoneSms = trans as SmscodeTransByPhone;
    sourceText = '+${phoneSms.tel} ${phoneSms.phone}';
    sourceWayText = 'sms_send_to_phone'.tr();
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
    SmartDialog.showLoading();
    try {
      SmscodeTrans res;
      trans.clearOld();
      if (trans.action.smsCodeReq is SmsCodeReq) {
        res = await ref
            .read(sendMessageProviderProvider.notifier)
            .sendCode<SmsCodeReq>();
        SmartDialog.dismiss(status: SmartStatus.loading);
        showToast(text: 'send_success'.tr());
        updateTrans(res);
      }
      SmartDialog.dismiss(status: SmartStatus.loading);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11004:
          showToast(text: 'text_error_toomuch'.tr());
          break;
        case 11003:
          showToast(text: 'send_sms_too_frequent'.tr());
          break;
        case 30910:
          showToast(text: 'phone_has_register'.tr());
          break;
        default:
          showToast(text: 'send_sms_code_error'.tr());
          break;
      }

      return Future.error(e);
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      if (e != 300101) {
        showToast(text: 'send_sms_code_error'.tr());
      }
      return Future.error(e);
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
    );
    if (sendEnable != state.enableSend) {
      state = state.copyWith(enableSend: sendEnable);
    }
  }

  void changeCode(String code) {
    _number = code;
    bool enable = _number.length == 6;
    if (state.enableNext != enable) {
      state = state.copyWith(enableNext: enable);
    }
  }

  void dispose() {
    _currentTimer?.cancel();
    _currentTimer = null;
  }

  Future<void> checkCode() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // loadingEvent(true);
    SmartDialog.showLoading();

    try {
      if (trans is SmscodeTransByPhone) {
        SmscodeTransByPhone phoneSms = trans as SmscodeTransByPhone;
        MobileCheckCodeReq req = MobileCheckCodeReq(
          phone: phoneSms.phone ?? '',
          phoneCode: phoneSms.tel ?? '',
          codeKey: phoneSms.codeKey ?? '',
          codeValue: _number,
        );
        await ref
            .read(accountRepositoryProvider)
            .checkSecureByPhoneVerificationCode(req);

        FixSafeInfoCodeReq re = FixSafeInfoCodeReq(
            codeKey: req.codeKey,
            phone: req.phone,
            phoneCode: req.phoneCode,
            coverOtherAccountPhone: false);
        await ref
            .read(accountRepositoryProvider)
            .fixUserSafeInfoByPhoneVerificationCode(re);
        var userInfo = await ref.read(mineRepositoryProvider).getUserInfo();
        await AccountModule().saveUserInfo(userInfo);
        showToast(text: 'bind_success'.tr());
      }
      SmartDialog.dismiss();
      await pushBack();
      return Future.value();
    } on DreameException catch (e) {
      SmartDialog.dismiss();
      switch (e.code) {
        case 11000:
        case 11005:
        case 11001:
        case 11015:
          showToast(text: 'sms_code_invalid_expired'.tr());
          break;
        case 30910:
          showToast(text: 'phone_has_register'.tr());
          break;
        default:
          showToast(text: 'operate_failed'.tr());
      }

      return Future.error(e);
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('operate_failed'.tr());
      return Future.error(e);
    }
  }

  void showToast({required String text}) {
    state = state.copyWith(event: ToastEvent(text: text));
  }

  Future<void> pushBack() async {
    await ref.read(appConfigProvider.notifier).resetApp();
  }
}
