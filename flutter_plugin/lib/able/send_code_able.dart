import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';

mixin SendCodeAble {
  //开始发送验证码
  @required
  Future<SmscodeTrans> startSendCode(BuildContext contex) async {
    RecaptchaModel? cap = await checkCap(contex);
    return _sendCode(cap);
  }

  //机器人检查
  @required
  Future<RecaptchaModel?> checkCap(BuildContext contex) async {
    // await ref.read(recaptchaHanderProvider.notifier).check(contex);
    // var recaptchaModel = ref.read(recaptchaHanderProvider);
    return Future.value(null);
  }

  // 发送验证码
  Future<SmscodeTrans> _sendCode(RecaptchaModel? recaptchaModel) async {
    Future<SmsCodeRes> request = requestFunction(recaptchaModel);
    SmsCodeRes res = await request;
    SmscodeTrans? trans = null;
    return Future.value(trans!);
  }

  // SmscodeTrans getTransFormRes(SmsCodeRes res) {
  //   return SmscodeTransByPhone(codeKey: res.codeKey, phone: '', tel: '');
  // }

// 获取发送请求方法
  Future<SmsCodeRes> requestFunction(RecaptchaModel? recaptchaModel) {
    return Future.value(const SmsCodeRes());
  }
}
mixin SendCodeByPhoneAble on SendCodeAble {
  late String _sendAblePhone = '';
  late String _sendAblePhoneCode = '';
  @override
  Future<SmsCodeRes> requestFunction(RecaptchaModel? recaptchaModel) {
    var smsCodeReq = SmsCodeReq(
      phone: '',
      phoneCode: '',
      lang: 'zh',
      token: recaptchaModel?.token ?? '',
      sessionId: recaptchaModel?.csessionid ?? '',
      sig: recaptchaModel?.sig ?? '',
    );
    smsCodeReq = tryToFixReq(smsCodeReq);
    _sendAblePhone = smsCodeReq.phone;
    _sendAblePhoneCode = smsCodeReq.phoneCode;
    return getRequestFounction(smsCodeReq);
  }

  @required
  SmsCodeReq tryToFixReq(SmsCodeReq smsCodeReq) {
    return smsCodeReq;
  }

  Future<SmsCodeRes> getRequestFounction(SmsCodeReq smsCodeReq) {
    return Future.error(DreameException(-1, 'Request method not implemented'));
  }

  @override
  SmscodeTrans getTransFormRes(SmsCodeRes res) {
    SmscodeTransByPhone? dd = null;
    return dd!;
    // return SmscodeTransByPhone(
    //     codeKey: res.codeKey, phone: _sendAblePhone, tel: _sendAblePhoneCode);
  }
}

mixin SendCodeByMailAble on SendCodeAble {
  late String _email = '';
  @override
  Future<SmsCodeRes> requestFunction(RecaptchaModel? recaptchaModel) {
    var smsCodeReq = EmailCodeReq(
      email: '',
      lang: 'zh',
      token: recaptchaModel?.token,
      sessionId: recaptchaModel?.csessionid,
      sig: recaptchaModel?.sig,
    );
    smsCodeReq = tryToFixReq(smsCodeReq);
    _email = smsCodeReq.email;
    return getRequestFounction(smsCodeReq);
  }

  @required
  EmailCodeReq tryToFixReq(EmailCodeReq smsCodeReq) {
    return smsCodeReq;
  }

  Future<SmsCodeRes> getRequestFounction(EmailCodeReq smsCodeReq) {
    return Future.error(DreameException(-1, 'Request method not implemented'));
  }

  @override
  SmscodeTrans getTransFormRes(SmsCodeRes res) {
    SmscodeTransByMail? dd = null;
    return dd!;
    // return SmscodeTransByMail(
    //   codeKey: res.codeKey,
    //   email: _email,
    // );
  }
}
