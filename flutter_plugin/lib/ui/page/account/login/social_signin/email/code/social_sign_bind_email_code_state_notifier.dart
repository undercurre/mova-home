import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/able/verification_code_able.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/send_message_provider.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/code/social_sign_bind_email_code_uistate.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'social_sign_bind_email_code_state_notifier.g.dart';

@riverpod
class SocialSignBindEmailCodeStateNotifier
    extends _$SocialSignBindEmailCodeStateNotifier with VerificationCodeAble {
  int _countTime = 0;
  Timer? _currentTimer;
  String _number = '';
  String? _authType;
  dynamic _token;
  @override
  SocialSignBindEmailCodeUiState build() {
    return SocialSignBindEmailCodeUiState();
  }

  void updateData(SmscodeTrans trans, String authType, dynamic token) {
    _authType = authType;
    _token = token;
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
    SmartDialog.showLoading();
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
      SmartDialog.dismiss(status: SmartStatus.loading);
      showToast('send_success'.tr());
      updateTrans(res);
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11004:
          showToast('text_error_toomuch'.tr());
          break;
        case 11003:
          showToast('send_sms_too_frequent'.tr());
          break;
        case 30400:
          // showAlert('text_account_unregister'.tr());
          break;

        default:
          showToast('send_sms_code_error'.tr());
          break;
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
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

  Future<bool?> checkCode() async {
    // 校验验证码
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading();
    var lang = await LocalModule().getLangTag();
    try {
      switch (trans) {
        //为什么留着这个手机号的，因为在接口还没出来之前，我认为整个流程和接口跟第三方绑定一样，所以计划将两者合一，但是后来完全是两套不一样的流程和接口
        case SmscodeTransByPhone phoneSms:
          // MobileCheckCodeReq req = MobileCheckCodeReq(
          //   phone: phoneSms.phone ?? '',
          //   phoneCode: phoneSms.tel ?? '',
          //   codeKey: phoneSms.codeKey ?? '',
          //   codeValue: _number,
          // );

          //  ref.read(accountRepositoryProvider).verifyRegisterSmsCode(req);
          // SmartDialog.dismiss();
          return Future.error('error');
        case SmscodeTransByMail mailSms:
          EmailCheckCodeReq req = EmailCheckCodeReq(
            codeKey: mailSms.codeKey ?? '',
            email: mailSms.email ?? '',
            lang: lang,
            codeValue: _number,
          );
          // 调用校验验证码接口
          await ref.read(accountRepositoryProvider).verifySocialEmailCode(req);

          SocialLoginReq re;
          if (_token is SocialTruck) {
            if (_token.userInfo != null) {
              re = SocialLoginReq.createFaceBookLimit(
                authType: _authType ?? '',
                thirdPartCode: _token.token ?? '',
                facebookUserId: _token.userInfo?.id ?? '',
                facebookUserName: _token.userInfo?.name ?? '',
                facebookUserAEmail: _token.userInfo?.email,
                emailCheck: 1,
                registerEmail: mailSms.email,
              );
            } else {
              re = SocialLoginReq.create(
                authType: _authType ?? '',
                thirdPartCode: _token.token ?? '',
                emailCheck: 1,
                registerEmail: mailSms.email,
              );
            }
          } else {
            re = SocialLoginReq.create(
              authType: _authType ?? '',
              thirdPartCode: _token ?? '',
              emailCheck: 1,
              registerEmail: mailSms.email,
            );
          }
          //校验成功调用登录或注册，重要的点为registerEmail
          return login(re);

        // TODO: Handle this case.
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

      return false;
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast('operate_failed'.tr());
      return false;
    }
  }

  Future<bool> login(SocialLoginReq req) async {
    SmartDialog.showLoading();
    try {
      bool res =
          await ref.read(accountRepositoryProvider).socialSignIn(req) ?? true;
      SmartDialog.dismiss();
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

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
  }
}
