import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/model/send_message_action.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'send_message_provider.g.dart';

@Riverpod(keepAlive: true)
class SendMessageProvider extends _$SendMessageProvider {
  late SendMessageAction _action;
  @override
  int build() {
    return 0;
  }

  void updateAction(SendMessageAction action) {
    _action = action;
  }

  Future<SmscodeTrans> sendCode<T>() async {
    SendMessageAction<T> currentAction = _action as SendMessageAction<T>;
    Future<SmsCodeRes> freq;
    if (_action.contex == null) {
      freq = currentAction.request(currentAction.smsCodeReq);
    } else {
      // SmartDialog.showLoading();
      await RecaptchaController(_action.contex!, (recaptchaModel) {
        SmartDialog.showLoading();
        currentAction = currentAction.updateWith(recaptchaModel);
      }).check();
      var req = currentAction.smsCodeReq;
      if (req is SmsCodeReq) {
        if (req.sessionId == null || req.sessionId!.isEmpty) {
          return Future.error(300101);
        }
      } else if (req is EmailCodeReq) {
        if (req.sessionId == null || req.sessionId!.isEmpty) {
          return Future.error(300101);
        }
      }
      freq = currentAction.request(req);
    }

    SmsCodeRes res = await freq;

    SmscodeTrans tran;
    if (currentAction.smsCodeReq is EmailCodeReq) {
      EmailCodeReq req = currentAction.smsCodeReq as EmailCodeReq;
      tran = SmscodeTransByMail(
          action: currentAction, codeKey: res.codeKey, email: req.email);
    } else {
      SmsCodeReq req = currentAction.smsCodeReq as SmsCodeReq;
      tran = SmscodeTransByPhone(
        action: currentAction,
        codeKey: res.codeKey,
        phone: req.phone,
        tel: req.phoneCode,
      );
    }
    return Future.value(tran);
  }
}
