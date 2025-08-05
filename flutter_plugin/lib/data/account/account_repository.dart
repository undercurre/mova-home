import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/configure/user_info_store.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/data/account/account_data_source.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/model/account/smscode.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository.g.dart';

class AccountRepository {
  final AccountDataSource _dataSource;

  const AccountRepository(this._dataSource);

  Future<SmsCodeRes> getLoginVerificationCode(SmsCodeReq req) async {
    return _dataSource.getLoginVerificationCode(req);
  }

  Future<SmsCodeRes> getRecoverByPhoneVerificationCode(SmsCodeReq req) async {
    return _dataSource.getRecoverByPhoneVerificationCode(req);
  }

  Future<SmsCodeRes> getSecureByPhoneVerificationCode(SmsCodeReq req) async {
    return _dataSource.getSecureByPhoneVerificationCode(req);
  }

  Future<SmsCodeRes> getRecoverByMailVerificationCode(EmailCodeReq req) async {
    return _dataSource.getRecoverByMailVerificationCode(req);
  }

  Future<SmsCodeRes> getSecureByMailVerificationCode(EmailCodeReq req) async {
    return _dataSource.getSecureByMailVerificationCode(req);
  }

  Future<SmsCodeCheckRes?> checkSecureByMailVerificationCode(
      EmailCheckCodeReq req) async {
    return _dataSource.checkSecureByMailVerificationCode(req);
  }

  Future<SmsCodeCheckRes?> checkRecoverByMailVerificationCode(
      EmailCheckCodeReq req) async {
    return _dataSource.checkRecoverByMailVerificationCode(req);
  }

  Future<SmsCodeCheckRes?> checkRecoverByPhoneVerificationCode(
      MobileCheckCodeReq req) async {
    return _dataSource.checkRecoverByPhoneVerificationCode(req);
  }

  Future<SmsCodeCheckRes?> checkSecureByPhoneVerificationCode(
      MobileCheckCodeReq req) async {
    return _dataSource.checkSecureByPhoneVerificationCode(req);
  }

  Future<UserInfoModel?> fixUserSafeInfoByPhoneVerificationCode(
      FixSafeInfoCodeReq req) async {
    return _dataSource.fixUserSafeInfoByPhoneVerificationCode(req);
  }

  Future<SmsCodeCheckRes?> changeRecoverByMailVerificationCode(
      ResetPswByMailReq req) async {
    return _dataSource.changeRecoverByMailVerificationCode(req);
  }

  Future<SmsCodeCheckRes?> changeRecoverByPhoneVerificationCode(
      ResetPswByPhoneReq req) async {
    return _dataSource.changeRecoverByPhoneVerificationCode(req);
  }

  Future<OAuthModel> loginWithPhone(
      String codeKey, String code, Map<String, dynamic> req) async {
    var authRes = await _dataSource.loginWithPhone(codeKey, code, req);
    await AccountModule().refreshAuthBean(authRes);
    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);
    await LifeCycleManager().logingSuccess();
    return authRes;
  }

  Future<OAuthModel> login(Map<String, dynamic> req) async {
    var authRes = await _dataSource.login(req);
    await AccountModule().refreshAuthBean(authRes);
    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);
    await LifeCycleManager().logingSuccess();
    return authRes;
  }

  Future<OAuthModel> loginWithPassWord(PasswordLoginReq req) async {
    var authRes = await _dataSource.loginWithPassword(req);
    await AccountModule().refreshAuthBean(authRes);
    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);

    await LifeCycleManager().logingSuccess();

    return authRes;
  }

  Future<MallLoginRes?> loginMall(String jwtToken) async {
    MallLoginReq req = MallLoginReq(jwtToken: jwtToken);
    return await _dataSource.loginForMall(req);
  }

  Future<bool?> oneKeySignIn(OneKeyLoginReq req) async {
    var authRes = await _dataSource.oneKeySignIn(req);
    // save
    var ret = AccountModule().refreshAuthBean(authRes);
    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);
    await LifeCycleManager().logingSuccess();
    return ret;
  }

  Future<bool?> socialSignIn(SocialLoginReq req) async {
    var authRes = await _dataSource.socialSignIn(req);
    // save
    var ret = await AccountModule().refreshAuthBean(authRes);
    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);
    await LifeCycleManager().logingSuccess();
    return ret;
  }

  Future<String?> getDiscuzAuthCode(String? clientId) async {
    return _dataSource.getDiscuzAuthCode(clientId);
  }

  Future<SmsCodeRes> autoRegisterBindSms(SmsCodeSocialReq req) async {
    return _dataSource.autoRegisterBindSms(req);
  }

  Future<SmsTrCodeRes> sendRegisterSmsCode(SmsCodeReq req) {
    return _dataSource.sendRegisterSmsCode(req);
  }

  Future<SmsTrCodeRes> sendRegisterEmailCode(EmailCodeReq req) {
    return _dataSource.sendRegisterEmailCode(req);
  }

  Future<SmsCodeRes> sendRegisterEmailCode2(EmailCodeReq req) async {
    return (await _dataSource.sendRegisterEmailCode(req)).toResult();
  }

  Future<SmsCodeRes> sendSocialBindEmailCode(EmailCodeReq req) async {
    return (await _dataSource.sendSocialBindEmailCode(req)).toResult();
  }

  Future<dynamic> verifyRegisterSmsCode(MobileCheckCodeReq req) {
    return _dataSource.verifyRegisterSmsCode(req);
  }

  Future<dynamic> verifyRegisterEmailCode(EmailCheckCodeReq req) {
    return _dataSource.verifyRegisterEmailCode(req);
  }

  Future<dynamic> verifySocialEmailCode(EmailCheckCodeReq req) {
    return _dataSource.verifySocialEmailCode(req);
  }

  Future<bool> registerByPhoneAndPassword(
      RegisterByPhonePasswordReq req) async {
    var ret = await _dataSource.registerByPhoneAndPassword(req);
    // 登录
    await Future.delayed(const Duration(seconds: 2));
    var passwordSign = await InfoModule().signPassword(req.password);
    var reqLogin = MobilePasswordLoginReq(
        username: req.phone, password: passwordSign, phoneCode: req.phoneCode);
    var loginRet = await _dataSource.login(reqLogin.toJson());
    // save
    var saveRet = await AccountModule().refreshAuthBean(loginRet);

    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);

    await LifeCycleManager().logingSuccess();
    return Future(() => saveRet ?? false);
  }

  Future<bool> registerByPassword(RegisterByPasswordReq req) async {
    if (req is RegisterByPhoneReq) {
      return registerByPhoneAndPassword1(req);
    } else if (req is RegisterByEmailReq) {
      return registerByEmailAndPassword1(req);
    }
    return Future.value(false);
  }

  /// 调用此接口，需要先调用发送验证码接口，验证验证码后，再调用此接口
  Future<bool> registerByPhoneAndPassword1(RegisterByPhoneReq req) async {
    var ret = await _dataSource.registerByPhoneAndPassword1(req);
    // 登录
    await Future.delayed(const Duration(seconds: 2));
    var passwordSign = await InfoModule().signPassword(req.password);
    var reqLogin = MobilePasswordLoginReq(
        username: req.phone, password: passwordSign, phoneCode: req.phoneCode);
    var loginRet = await _dataSource.login(reqLogin.toJson());
    // save
    var saveRet = await AccountModule().refreshAuthBean(loginRet);

    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);

    await LifeCycleManager().logingSuccess();
    return Future(() => saveRet ?? false);
  }

  Future<bool> registerByEmailAndPassword1(RegisterByEmailReq req) async {
    var ret = await _dataSource.registerByEmailAndPassword1(req);
    // // 登录
    await Future.delayed(const Duration(seconds: 2));
    var passwordSign = await InfoModule().signPassword(req.password);
    PasswordLoginReq reqLogin = PasswordLoginReq(
        username: req.email,
        password: passwordSign,
        country: req.country,
        lang: req.lang);

    var loginRet = await _dataSource.loginWithPassword(reqLogin);
    // save
    var saveRet = await AccountModule().refreshAuthBean(loginRet);

    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);

    await LifeCycleManager().logingSuccess();
    return Future(() => saveRet ?? false);
  }

  Future<bool> registerByEmail(EmailRegisterReq req) async {
    var ret = await _dataSource.registerByEmail(req);
    // 登录
    await Future.delayed(const Duration(seconds: 2));
    var passwordSign = await InfoModule().signPassword(req.password);
    var reqLogin = MobilePasswordLoginReq(
        username: req.email, password: passwordSign, phoneCode: '');
    var loginRet = await _dataSource.login(reqLogin.toJson());
    // save
    var saveRet = await AccountModule().refreshAuthBean(loginRet);
    // userInfo
    var userInfo = await _dataSource.getUserInfo();
    await AccountModule().saveUserInfo(userInfo);
    // await LifeCycleManager().logingSuccess();
    return Future(() => saveRet ?? false);
  }

  /// 查询隐私配置
  Future<PrivacyUpgradeRes> queryPrivacyPolicy() async {
    return _dataSource.queryPrivacyPolicy();
  }

  Future<dynamic> agreePrivacy({required int version}) async {
    return _dataSource.agreePrivacy(version);
  }

  Future<bool> getPhoneBindSwitch() async {
    return _dataSource.getPhoneBindSwitch();
  }
}

@riverpod
AccountRepository accountRepository(AccountRepositoryRef ref) {
  return AccountRepository(AccountDataSource(ref.watch(apiClientProvider)));
}
