import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/mobile/social_signin_bind_uistate.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class SocialSignInBindUseCase {
  AccountRepository repository;

  SocialSignInBindUseCase(this.repository);

  Future<Triple<bool, String?, SendCodeModel?>> sendAutoRegisterBindSms(
      RecaptchaModel recaptchaModel, SocialSignInBindUiState state) async {
    LogUtils.d('----------- autoRegisterBindSms  ---------$recaptchaModel');

    if (recaptchaModel.result == -100) {
      // 取消
      return Future.value(Triple(false, null, null));
    }
    if (recaptchaModel.result != 0) {
      return Future.value(Triple(false, 'send_sms_code_error'.tr(), null));
    }
    var lang = await LocalModule().getLangTag();
    var req = SmsCodeSocialReq(
      phone: state.account ?? '',
      phoneCode: state.currentPhone.code,
      lang: lang,
      token: recaptchaModel.token ?? '',
      sessionId: recaptchaModel.csessionid ?? '',
      sig: recaptchaModel.sig ?? '',
      socialUUid: state.socialUUid ?? '',
      source: state.source ?? '',
    );
    try {
      var data = await repository.autoRegisterBindSms(req);
      var sendCodeModel = SendCodeModel(
        interval: data.interval ?? 60,
        phone: state.account ?? '',
        codeKey: data.codeKey ?? '',
        currentPhone: state.currentPhone,
        currentRegion: state.currentRegion,
      );
      return Future.value(Triple(true, null, sendCodeModel));
    } on DreameException catch (e) {
      switch (e.code) {
        case 11002:
          return Future.value(Triple(false, 'send_sms_code_error'.tr(), null));
        case 11003:
          return Future.value(
              Triple(false, 'send_sms_too_frequent'.tr(), null));
        case 11004:
          return Future.value(Triple(false, 'text_error_toomuch'.tr(), null));
        case 10016:
          return Future.value(Triple(false, 'phone_has_register'.tr(), null));
        case 20100:
          return Future.value(Triple(false, 'user_not_exist'.tr(), null));
        default:
          return Future.value(Triple(false, 'send_sms_code_error'.tr(), null));
      }
    } catch (e) {
      LogUtils.d('------sendVerifyCode --------${e.toString()}');
    }
    return Future.value(Triple(false, 'send_sms_code_error'.tr(), null));
  }

  Future<Triple<bool, String?, OAuthModel?>> socialbBindSkipTwo(
      {required String source,
      required String socialUUid,
      required String countryCode}) async {
    LogUtils.d('----------- socialbBindSkip  ---------');
    var lang = await LocalModule().getLangTag();
    var req = SocialSkipBindReq.create(
        source: source,
        socialUUid: socialUUid,
        lang: lang,
        country: countryCode);
    try {
      var data = await repository.login(req.toJson());
      return Future.value(Triple(true, null, data));
    } on DreameException catch (e) {
      switch (e.code) {
        case 10015:
          return Future.value(Triple(false,
              'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr(), null));
        case 20102:
          return Future.value(
              Triple(false, 'login_request_too_much'.tr(), null));
        case -1:
          return Future.value(Triple(false, e.message, null));
        default:
          return Future.value(
              Triple(false, 'Toast_3rdPartyBundle_ResultFailed'.tr(), null));
      }
    } catch (e) {
      LogUtils.d('------socialbBindSkip --------$e');
    }
    return Future.value(
        Triple(false, 'Toast_3rdPartyBundle_ResultFailed'.tr(), null));
  }

  Future<Triple<bool, String?, OAuthModel?>> socialbBindSkip(
      SocialSignInBindUiState state) async {
    LogUtils.d('----------- socialbBindSkip  ---------');
    var lang = await LocalModule().getLangTag();
    var req = SocialSkipBindReq.create(
        source: state.source ?? '',
        socialUUid: state.socialUUid ?? '',
        lang: lang,
        country: state.currentRegion.countryCode);
    try {
      var data = await repository.login(req.toJson());
      return Future.value(Triple(true, null, data));
    } on DreameException catch (e) {
      switch (e.code) {
        case 10015:
          return Future.value(Triple(false,
              'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr(), null));
        case 20102:
          return Future.value(
              Triple(false, 'login_request_too_much'.tr(), null));
        case -1:
          return Future.value(Triple(false, e.message, null));
        default:
          return Future.value(
              Triple(false, 'Toast_3rdPartyBundle_ResultFailed'.tr(), null));
      }
    } catch (e) {
      LogUtils.d('------socialbBindSkip --------$e');
    }
    return Future.value(
        Triple(false, 'Toast_3rdPartyBundle_ResultFailed'.tr(), null));
  }

  /// 账号绑定
  Future<SocialSignInBindUiEvent> socialbBind(
      SocialSignInBindUiState state, bool cover) async {
    LogUtils.d('----------- socialbBind  --------- $cover ');
    var lang = await LocalModule().getLangTag();
    String password = await InfoModule().signPassword(state.password ?? '');
    var req = SocialSignInBindReq.createBindAccount(
      username: state.account ?? '',
      palinTextPwd: state.password ?? '',
      password: password,
      source: state.source ?? '',
      socialUUid: state.socialUUid ?? '',
      country: state.currentRegion.countryCode,
      lang: lang,
      cover: cover,
    );
    try {
      var data = await repository.login(req.toJson());
      return Future.value(Success(oAuthRes: data));
    } on DreameAuthException catch (e) {
      switch (e.code) {
        case 11000:
          return Future.value(ToastShow(msg: 'sms_code_invalid_expired'.tr()));
        case 11001:
          return Future.value(ToastShow(msg: 'sms_code_invalid_expired'.tr()));
        case 10015:
          return Future.value(ToastShow(
              msg: 'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr()));
        case 10016:
          // bindCoverDialog
          if (state.source == GOOGLE_AUTH) {
            return Future.value(BindCoverDialog(msg: 'Google'));
          } else if (state.source == FACEBOOK_AUTH) {
            return Future.value(BindCoverDialog(msg: 'Facebook'));
          } else if (state.source == WECHAT_AUTH) {
            return Future.value(BindCoverDialog(msg: 'share_weixin'.tr()));
          } else if (state.source == APPLE_AUTH) {
            return Future.value(BindCoverDialog(msg: 'Apple'));
          } else {
            return Future.value(BindCoverDialog(msg: ''));
          }
        case 20101:
          if ('0' == e.remains) {
            // ShowAccountLocked
            return Future.value(ShowAccountLocked());
          } else {
            return Future.value(ToastShow(msg: 'user_password_not_match'.tr()));
          }
        case 20100:
          return Future.value(ToastShow(msg: 'user_not_exist'.tr()));
        case 20105:
          return Future.value(ToastShow(msg: 'mail_error'.tr()));
        case 20102:
          return Future.value(ToastShow(msg: 'login_request_too_much'.tr()));
        case -1:
          return Future.value(ToastShow(msg: e.message ?? ''));
        default:
          return Future.value(
              ToastShow(msg: 'Toast_3rdPartyBundle_ResultFailed'.tr()));
      }
    } catch (e) {
      LogUtils.d('------socialbBindSkip --------$e');
    }
    return Future.value(
        ToastShow(msg: 'Toast_3rdPartyBundle_ResultFailed'.tr()));
  }

  Future<bool> getBindSwitch() async {
    var data = await repository.getPhoneBindSwitch();
    return data;
  }
}
