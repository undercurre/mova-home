import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/send_message_action.dart';

sealed class SmscodeTrans {
  SmscodeTrans({required this.action, this.codeKey});
  SendMessageAction action;
  String? codeKey;

  void clearOld() {
    var smsCode = action.smsCodeReq;
    if (smsCode is BaseCodeReq) {
      smsCode.sessionId = '';
      smsCode.sig = '';
      smsCode.token = '';
    }
  }
}

class SmscodeTransByPhone extends SmscodeTrans {
  SmscodeTransByPhone({
    required super.action,
    super.codeKey,
    this.phone,
    this.tel,
  });
  String? phone;
  String? tel;
}

class SmscodeTransByMail extends SmscodeTrans {
  SmscodeTransByMail({
    required super.action,
    super.codeKey,
    this.email,
  });
  String? email;
}
