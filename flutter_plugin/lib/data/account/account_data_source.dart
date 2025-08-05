import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/model/account/signup.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class AccountDataSource {
  ApiClient _apiClient;

  AccountDataSource(this._apiClient) {
    LogUtils.d('------------ LoginDataSourceRemote -------------');
  }

  Future<SmsCodeRes> getLoginVerificationCode(SmsCodeReq req) async {
    var result = processApiResponse<SmsCodeRes>(
        _apiClient.getLoginVerificationCode(req));
    return result;
  }

  Future<SmsCodeRes> getRecoverByPhoneVerificationCode(SmsCodeReq req) async {
    var result = processApiResponse<SmsTrCodeRes>(
        _apiClient.getRecoverByPhoneVerificationCode(req));
    try {
      SmsTrCodeRes res = await result;
      return Future.value(res.toResult());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SmsCodeRes> getSecureByPhoneVerificationCode(SmsCodeReq req) async {
    var result = processApiResponse<SmsTrCodeRes>(
        _apiClient.getSecureByPhoneVerificationCode(req));
    try {
      SmsTrCodeRes res = await result;
      return Future.value(res.toResult());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SmsCodeRes> getRecoverByMailVerificationCode(EmailCodeReq req) async {
    var result = processApiResponse<SmsTrCodeRes>(
        _apiClient.getRecoverByMailVerificationCode(req));
    try {
      SmsTrCodeRes res = await result;
      return Future.value(res.toResult());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SmsCodeRes> getSecureByMailVerificationCode(EmailCodeReq req) async {
    var result = processApiResponse<SmsTrCodeRes>(
        _apiClient.getSecureByMailVerificationCode(req));
    try {
      SmsTrCodeRes res = await result;
      return Future.value(res.toResult());
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<SmsCodeCheckRes?> checkRecoverByMailVerificationCode(
      EmailCheckCodeReq req) async {
    var result = processApiResponse<SmsCodeCheckRes?>(
        _apiClient.checkRecoverByMailVerificationCode(req));
    // try {
    //   SmsTrCodeRes res = await result;
    //   return Future.value(res.toResult());
    // } catch (e) {
    //   return Future.error(e);
    // }
    return result;
  }

  Future<SmsCodeCheckRes?> checkSecureByMailVerificationCode(
      EmailCheckCodeReq req) async {
    var result = processApiResponse<SmsCodeCheckRes?>(
        _apiClient.checkSecureByMailVerificationCode(req));
    // try {
    //   SmsTrCodeRes res = await result;
    //   return Future.value(res.toResult());
    // } catch (e) {
    //   return Future.error(e);
    // }
    return result;
  }

  Future<SmsCodeCheckRes?> checkRecoverByPhoneVerificationCode(
      MobileCheckCodeReq req) async {
    var result = processApiResponse<SmsCodeCheckRes?>(
        _apiClient.checkRecoverByPhoneVerificationCode(req));
    // try {
    //   SmsTrCodeRes res = await result;
    //   return Future.value(res.toResult());
    // } catch (e) {
    //   return Future.error(e);
    // }
    return result;
  }

  Future<SmsCodeCheckRes?> checkSecureByPhoneVerificationCode(
      MobileCheckCodeReq req) async {
    var result = processApiResponse<SmsCodeCheckRes?>(
        _apiClient.checkSecureByPhoneVerificationCode(req));
    return result;
  }

  Future<UserInfoModel?> fixUserSafeInfoByPhoneVerificationCode(
      FixSafeInfoCodeReq req) async {
    var result = processApiResponse<UserInfoModel?>(
        _apiClient.fixUserSafeInfoByVerificationCode(req));
    return result;
  }

  Future<SmsCodeCheckRes?> changeRecoverByMailVerificationCode(
      ResetPswByMailReq req) async {
    var result = processApiResponse<SmsCodeCheckRes?>(
        _apiClient.changeRecoverByMailVerificationCode(req));
    // try {
    //   SmsTrCodeRes res = await result;
    //   return Future.value(res.toResult());
    // } catch (e) {
    //   return Future.error(e);
    // }
    return result;
  }

  Future<SmsCodeCheckRes?> changeRecoverByPhoneVerificationCode(
      ResetPswByPhoneReq req) async {
    var result = processApiResponse<SmsCodeCheckRes?>(
        _apiClient.changeRecoverByPhoneVerificationCode(req));
    return result;
  }

  /// 获取用户信息
  Future<UserInfoModel> getUserInfo() async {
    var result = processApiResponse<UserInfoModel>(_apiClient.getUserInfo());
    return result;
  }

  /// 商城登录
  Future<MallLoginRes?> loginForMall(MallLoginReq req) async {
    var result =
        processMallApiResponse<MallLoginRes?>(_apiClient.loginForMall(req));
    return result;
  }

  Future<OAuthModel> loginWithPhone(
      String codeKey, String code, Map<String, dynamic> req) async {
    var result = processAuthResponse<OAuthModel>(
        _apiClient.loginWithPhone(codeKey, code, req));
    return result;
  }

  Future<OAuthModel> login(Map<String, dynamic> req) async {
    var result = processAuthResponse<OAuthModel>(_apiClient.login(req));
    return result;
  }

  Future<OAuthModel> loginWithPassword(PasswordLoginReq req) async {
    var result =
        processAuthResponse<OAuthModel>(_apiClient.loginWithPassword(req));
    return result;
  }

  Future<OAuthModel> oneKeySignIn(OneKeyLoginReq req) async {
    var result = processAuthResponse<OAuthModel>(_apiClient.oneKeySignIn(req));
    return result;
  }

  Future<OAuthModel> socialSignIn(SocialLoginReq req) async {
    var result = processAuthResponse<OAuthModel>(_apiClient.socialSignIn(req));
    return result;
  }

  Future<String?> getDiscuzAuthCode(String? clientId) async {
    var result =
        processApiResponse<String?>(_apiClient.getDiscuzAuthCode(clientId));
    return result;
  }

  Future<SmsCodeRes> autoRegisterBindSms(SmsCodeSocialReq req) async {
    var result =
        processApiResponse<SmsCodeRes>(_apiClient.autoRegisterBindSms(req));
    return result;
  }

  Future<SmsTrCodeRes> sendRegisterSmsCode(SmsCodeReq req) {
    var result =
        processApiResponse<SmsTrCodeRes>(_apiClient.sendRegisterSmsCode(req));
    return result;
  }

  Future<SmsTrCodeRes> sendRegisterEmailCode(EmailCodeReq req) {
    var result =
        processApiResponse<SmsTrCodeRes>(_apiClient.sendRegisterEmailCode(req));
    return result;
  }

  Future<SmsTrCodeRes> sendSocialBindEmailCode(EmailCodeReq req) {
    return processApiResponse<SmsTrCodeRes>(
        _apiClient.sendSocialBindEmailCode(req));
  }

  Future<dynamic> verifyRegisterSmsCode(MobileCheckCodeReq req) {
    var result =
        processApiResponse<dynamic>(_apiClient.verifyRegisterSmsCode(req));
    return result;
  }

  Future<dynamic> verifyRegisterEmailCode(EmailCheckCodeReq req) {
    var result =
        processApiResponse<dynamic>(_apiClient.verifyRegisterEmailCode(req));
    return result;
  }

  Future<dynamic> verifySocialEmailCode(EmailCheckCodeReq req) {
    var result =
        processApiResponse<dynamic>(_apiClient.verifySocialEmailCode(req));
    return result;
  }

  Future<Object?> registerByPhoneAndPassword(RegisterByPhonePasswordReq req) {
    var result =
        processApiResponse<Object?>(_apiClient.registerByPhoneAndPassword(req));
    return result;
  }

  Future<Object?> registerByPhoneAndPassword1(RegisterByPhoneReq req) {
    var result = processApiResponse<Object?>(
        _apiClient.registerByPhoneAndPassword1(req));
    return result;
  }

  Future<Object?> registerByEmailAndPassword1(RegisterByEmailReq req) {
    var result = processApiResponse<Object?>(
        _apiClient.registerByEmailAndPassword1(req));
    return result;
  }

  Future<dynamic> registerByEmail(EmailRegisterReq req) {
    var result = processApiResponse<dynamic>(_apiClient.registerByEmail(req));
    return result;
  }

  Future<PrivacyUpgradeRes> queryPrivacyPolicy({String version = ''}) {
    var result =
        processApiResponse<PrivacyUpgradeRes>(_apiClient.getPrivacy(version));
    return result;
  }

  Future<dynamic> agreePrivacy(int version) {
    var params = {'version': version};
    var result = processApiResponse<dynamic>(_apiClient.agreePrivacy(params));
    return result;
  }

  Future<bool> getPhoneBindSwitch() {
    return processApiResponse<bool>(_apiClient.getBindSwitch());
  }

  Future<EmailCollectionRes> getSeaEmailCollectInfo() {
    return processApiResponse<EmailCollectionRes>(
        _apiClient.getSeaEmailCollectInfo());
  }
}
