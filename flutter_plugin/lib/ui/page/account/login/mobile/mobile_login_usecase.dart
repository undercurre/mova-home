import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_uistate.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class MobileLoginUsecase {
  AccountRepository repository;

  MobileLoginUsecase(this.repository);

  Future<CommonUIEvent> sendVerifyCode(
      RecaptchaModel recaptchaModel, MobileLoginUiState state) async {
    // 验证滑块验证码是否错误
    if (recaptchaModel.result == -100) {
      // 取消
      return const EmptyEvent();
    }
    if (recaptchaModel.result != 0) {
      return ToastEvent(text: 'send_sms_code_error'.tr());
    }
    if (recaptchaModel.result == 0) {
      LogUtils.d('----- sendVerifyCode ------++++++ ${repository.toString()} ');
      var lang = await LocalModule().getLangTag();
      var smsCodeReq = SmsCodeReq(
        phone: state.phoneNumber ?? '',
        phoneCode: state.currentPhone.code,
        lang: lang,
        token: recaptchaModel.token ?? '',
        sessionId: recaptchaModel.csessionid ?? '',
        sig: recaptchaModel.sig ?? '',
      );
      try {
        var data = await repository.getLoginVerificationCode(smsCodeReq);
        LogUtils.d('----- sendVerifyCode ------++++++ $data');
        // 验证码发送成功
        return SuccessEvent<SmsCodeRes>(data: data);
      } on DreameException catch (e) {
        var code = e.code;
        switch (code) {
          case 11002:
            return ToastEvent(text: 'send_sms_code_error'.tr());
          case 11003:
            return ToastEvent(text: 'send_sms_too_frequent'.tr());
          case 11004:
            return ToastEvent(text: 'text_error_toomuch'.tr());
          case BadResultCode.NET_ERROR:
            return ToastEvent(text: 'toast_net_error'.tr());
          case BadResultCode.CANCEL:
            return const EmptyEvent();
          default:
            return ToastEvent(text: 'send_sms_code_error'.tr());
        }
      } catch (e) {
        return ToastEvent(text: 'send_sms_code_error'.tr());
      }
    }
    return const EmptyEvent();
  }
}
