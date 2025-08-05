
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';

mixin VerificationCodeAble {
  @required
  late SmscodeTrans trans;
  void checkVerificationCode() {}
}

mixin VerificationCodeForPhoneAble on VerificationCodeAble {}
