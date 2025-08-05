import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/social.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_setting_repository.g.dart';

class AccountSettingRepository {
  final ApiClient apiClient;

  AccountSettingRepository(this.apiClient);

  // 获取用户信息
  Future<UserInfoModel> getUserInfo() async {
    return apiClient.getUserInfo().then((value) async {
      UserInfoModel? info = value.data;
      if (info != null) {
        await AccountModule().saveUserInfo(info);
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 上传用户头像
  Future<void> uploadAvator(File file) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last,
          contentType: MediaType.parse('image/jpeg'))
    });

    return apiClient
        .uploadUserAvator('multipart/form-data', formData)
        .then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 更新用户信息
  Future<UserInfoModel> putUserInfo(Map<String, dynamic> params) async {
    return apiClient.putUserInfo(params).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 更新用户详细信息
  Future<UserInfoModel> putUserInfoDetail(
      String? country, String? lang, String? name) async {
    Map<String, dynamic> params = {};
    if (country != null && country.isNotEmpty) {
      params['country'] = country;
    }
    if (lang != null && lang.isNotEmpty) {
      params['lang'] = lang;
    }
    if (name != null && name.isNotEmpty) {
      params['name'] = name;
    }
    return apiClient.putUserInfo(params).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 更新用户性别
  Future<void> updateSex(int sex) async {
    ///性别 1:男 2:女 3:保密
    Map<String, int> params = {'sex': sex};
    return apiClient.updateSex(params).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<void> updateBirthday(int timeStamp) async {
    Map<String, int> params = {'birthday': timeStamp};
    return apiClient.updateBirthday(params).then((value) {
      if (value.successed() || value.code == 0) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 获取绑定第三方账号
  Future<List<SocialInfo>> getThirdSociaPlatformlBindList() async {
    return apiClient.getThirdSociaPlatformlBindList().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 绑定第三方账号
  Future<void> bindThirdSocialPlatform(dynamic token, String platformName,
      {bool cover = false}) async {
    assert(token != null);
    assert(platformName.isNotEmpty);
    SocialBindReq req;
    if (token is SocialTruck) {
      if (token.userInfo != null) {
        req = SocialBindReq(
          code: token.token ?? '',
          extraMap: SocialBindextraMapReq(
            facebookUserId: token.userInfo?.id,
            facebookUserName: token.userInfo?.name,
            facebookUserAEmail: token.userInfo?.email,
          ),
          coverType: '',
          source: platformName,
        );
      } else {
        req = SocialBindReq(
          code: token.token ?? '',
          coverType: '',
          source: platformName,
        );
      }
    } else {
      req = SocialBindReq(
        code: token,
        coverType: '',
        source: platformName,
      );
    }
    if (cover == true) {
      /// 强制覆盖
      req.coverType = 'cover';
    }
    return apiClient.bindThirdSocialPlatform(req).then((value) {
      if (value.code == 0 || value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 解绑第三方账号
  Future<void> unbindThirdSocialPlatform(String idSting, String source) async {
    assert(idSting.isNotEmpty);
    assert(source.isNotEmpty);
    SocialUnBindReq req = SocialUnBindReq(
      id: idSting,
      source: source,
    );
    return apiClient.unbindThirdSocialPlatform(req).then((value) {
      if (value.code == 0 || value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 更新用户密码
  Future<bool> changePassword(String oldPwd, String newPwd) async {
    assert(oldPwd.isNotEmpty);
    assert(newPwd.isNotEmpty);
    ChangePwdCheckReq req = ChangePwdCheckReq(
      confirmedPassword: newPwd,
      newPassword: newPwd,
      password: oldPwd,
    );
    return apiClient.changePassword(req).then((value) {
      if (value.successed() || value.code == 0) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 设置用户密码
  Future<void> settingPassword(String pwd) async {
    assert(pwd.isNotEmpty);
    SettingPwdCheckReq req = SettingPwdCheckReq(
      confirmedPassword: pwd,
      newPassword: pwd,
    );
    return apiClient.settingPassword(req).then((value) {
      if (value.successed() || value.code == 0) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 获取邮箱验证码Session
  Future<SmsTrCodeRes> getRecoverByMailVerificationCode(String email,
      String sessionId, String token, String sig, String lang) async {
    assert(email.isNotEmpty);
    EmailCodeReq req = EmailCodeReq(
      email: email,
      sessionId: sessionId,
      token: token,
      sig: sig,
      lang: lang,
    );
    return apiClient.getRecoverByMailVerificationCode(req).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 获取邮箱验证码
  Future<SmsTrCodeRes> getEmailVerificationCode(
      RecaptchaModel recaptchaModel, String email, String lange) async {
    EmailCodeReq req = EmailCodeReq(
      email: email,
      lang: lange,
      sessionId: recaptchaModel.csessionid!,
      token: recaptchaModel.token!,
      sig: recaptchaModel.sig!,
      skipEmailBoundVerify: true,
    );
    return apiClient.getSecureByMailVerificationCode(req).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 校验邮箱验证码 (邮箱)
  Future<bool> checkEmailVerificationCode(
      String email, String codeKey, String codeValue) async {
    EmailCheckCodeReq req = EmailCheckCodeReq(
      email: email,
      codeKey: codeKey,
      codeValue: codeValue,
    );
    return apiClient.checkPhoneOrEmailVerification(req).then((value) {
      if (value.code == 0 || value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 绑定电子邮箱
  Future<UserInfoModel> bindEmail(String email, String codeKey,
      {bool force = false}) async {
    FixSafeInfoCodeReq req = FixSafeInfoCodeReq(
      codeKey: codeKey,
      email: email,
      coverOtherAccountPhone: force,
    );
    try {
      var result = processApiResponse<UserInfoModel>(
          apiClient.fixUserSafeInfoByVerificationCode(req));
      UserInfoModel userInfo = await result;
      await AccountModule().saveUserInfo(userInfo);
      return userInfo;
    } catch (e) {
      return Future.error(e);
    }
  }

  // 解绑定电子邮箱
  Future<bool> unbindEmail(String password) async {
    UnbindEmailReq params = UnbindEmailReq(password: password);

    return apiClient.unbindEmail(params).then((value) {
      if (value.successed() || value.code == 0) {
        getUserInfo();
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 获取手机验证码 (校验、手机号、验证码、语言))
  Future<SmsTrCodeRes> getPhoneVerificationCode(RecaptchaModel recaptchaModel,
      String phone, String reginCode, String lang) async {
    SmsCodeReq req = SmsCodeReq(
        phone: phone,
        phoneCode: reginCode,
        lang: lang,
        skipPhoneBoundVerify: false,
        sessionId: recaptchaModel.csessionid,
        token: recaptchaModel.token,
        sig: recaptchaModel.sig);
    return apiClient.getSecureByPhoneVerificationCode(req).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 解除绑定获取验证码
  Future<SmsTrCodeRes> unbindGetPhoneVertificationCode(
      RecaptchaModel recaptchaModel,
      String phone,
      String reginCode,
      String lang) async {
    SmsCodeReq req = SmsCodeReq(
        phone: phone,
        phoneCode: reginCode,
        lang: lang,
        skipPhoneBoundVerify: false,
        sessionId: recaptchaModel.csessionid,
        token: recaptchaModel.token,
        sig: recaptchaModel.sig);
    return apiClient.unbindGetPhoneVertificationCode(req).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 绑定手机号 (phone手机号/regnCode区号/codeKey(获取验证码接口的codeKey)/codeValue验证码)
  Future<UserInfoModel?> bindPhoneNumber(
      String phone, String regnCode, String codeKey, String codeValue) async {
    // 1.校验
    MobileCheckCodeReq req = MobileCheckCodeReq(
      phone: phone,
      phoneCode: regnCode,
      codeKey: codeKey,
      codeValue: codeValue,
    );

    bool checkSuccess = await checkSecureByPhoneVerificationCode(req);
    if (checkSuccess == false) {
      return null;
    }

    //  2.修改
    FixSafeInfoCodeReq fixReq = FixSafeInfoCodeReq(
      phone: phone,
      phoneCode: regnCode,
      codeKey: codeKey,
      coverOtherAccountPhone: false,
    );
    return await apiClient
        .fixUserSafeInfoByVerificationCode(fixReq)
        .then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 检查绑定(phone \ email)
  Future<bool> checkSecureByPhoneVerificationCode(
      MobileCheckCodeReq req) async {
    return apiClient.checkSecureByPhoneVerificationCode(req).then((value) {
      if (value.successed() || value.code == 0) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 解绑检查(phone \ email)
  Future<bool> checkUnBindPhoneVerificationCode(MobileCheckCodeReq req) async {
    return apiClient.checkUnBindPhoneVerificationCode(req).then((value) {
      if (value.successed() || value.code == 0) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 解绑手机号验证
  Future<bool> unbindPhoneNumber(
      String phone, String phoneCode, String codeKey, String codeValue) async {
    MobileCheckCodeReq req = MobileCheckCodeReq(
      phone: phone,
      phoneCode: phoneCode,
      codeKey: codeKey,
      codeValue: codeValue,
    );
    // 1.检查
    bool checkSuccess = await checkUnBindPhoneVerificationCode(req);
    if (checkSuccess == false) {
      return Future.value(false);
    }

    // 2.解绑
    MobileUnbindReq unbindReq = MobileUnbindReq(
      codeKey: codeKey,
    );
    return await apiClient.unBindPhone(unbindReq).then((value) {
      if (value.successed() || value.code == 0) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  /// 退出登录
  /// 登出接口比较特殊，只能这么操作
  Future<bool> logoutUser() async {
    return apiClient.logoutUser().then((value) {
      if (value.success == 'true' || value.code == 0) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code ?? -1, value.msg));
      }
    });
  }

  // 注销用户
  Future<void> deleteUser() async {
    return apiClient.deleteUser().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // // 海外邮箱信息手机
  // Future<dynamic> emailSubsribue() {
  //   return apiClient
  //       .emailCollectionSubscribe(EmailCollectionSubscribeRep(status: 1))
  //       .then((value) {
  //     if (value.successed()) {
  //       return Future.value(value.data);
  //     } else {
  //       return Future.error(DreameException(value.code, value.msg));
  //     }
  //   });
  // }
}

@riverpod
AccountSettingRepository accountSettingRepository(
    AccountSettingRepositoryRef ref) {
  return AccountSettingRepository(ref.watch(apiClientProvider));
}
