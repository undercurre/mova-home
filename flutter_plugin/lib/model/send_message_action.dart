import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/model/account/smscode.dart';

class SendMessageAction<T> {
  SendMessageAction(
      {required this.smsCodeReq, required this.request, this.contex});
  T smsCodeReq;
  BuildContext? contex;
  Future<SmsCodeRes> Function(T) request;
  SendMessageAction<T> updateWith(RecaptchaModel recap) {
    // smsCodeReq.
    BaseCodeReq fixReq = smsCodeReq as BaseCodeReq;
    fixReq.token = recap.token;
    fixReq.sessionId = recap.csessionid;
    fixReq.sig = recap.sig;
    return SendMessageAction<T>(
        request: this.request, smsCodeReq: fixReq as T, contex: this.contex);
  }
}
