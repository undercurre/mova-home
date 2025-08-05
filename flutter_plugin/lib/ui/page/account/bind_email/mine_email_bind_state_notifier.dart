import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/email_collection_respository.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/mine_email_bind_uistate.dart';
import 'package:flutter_plugin/ui/page/email_collection/userinfo_change_event.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mine_email_bind_state_notifier.g.dart';

@riverpod
class MineEmailBindStateNotifier extends _$MineEmailBindStateNotifier {
  String? _email;
  String? _code;
  SmsCodeRes? _codeRes;

  @override
  MineEmailBindUiState build() {
    _email = null;
    _code = null;
    return MineEmailBindUiState(enableSend: false, agreed: false);
  }

  void prepareData() {
    _email = null;
    _code = null;
    _getBindStatus();
    state = state.copyWith(agreed: false, enableSend: false);
    _checkEnable();
  }

  Future<void> _getBindStatus() async {
    UserInfoModel? info = await AccountModule().getUserInfo();
    String? email = info?.email;
    if ((email ?? '').isEmpty) {
      state = state.copyWith(isbindEmail: true);
    }
  }

  void _checkEnable() {
    bool enable = (_email?.isNotEmpty ?? false) && (_code?.isNotEmpty ?? false);
    state = state.copyWith(enableSend: enable);
  }

  void emailChange(String? email) {
    _email = email;
    _checkEnable();
    _checkSendMessageEnable();
  }

  void codeChange(String? code) {
    _code = code;
    _checkEnable();
  }

  void agreementChange() {
    FocusManager.instance.primaryFocus?.unfocus();
    state = state.copyWith(agreed: !state.agreed);
    _checkEnable();
  }

  void _checkSendMessageEnable() {
    bool enable = (_email?.isNotEmpty ?? false);
    state = state.copyWith(canSendMessage: enable);
  }

  Future<bool> _submitClick() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      String? codekey = await checkVerifyCode();
      String? email = _email;
      if (codekey == null) {
        return false;
      }
      if (email == null) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        SmartDialog.showToast('bind_failure'.tr());
        return false;
      }
      return fixAndCheckSubScribe(codeKey: codekey, email: email);
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast('bind_failure'.tr());
      return false;
    }
  }

  Future<void> submitClick() async {
    bool result = await _submitClick();
    if (result == true) {
      state = state.copyWith(
        event: PushEvent(func: RouterFunc.pop),
      );
      EventBusUtil.getInstance().fire(UserInfoChangeEvent());
    }
  }

  Future<String?> checkVerifyCode() async {
    if (_codeRes == null) {
      SmartDialog.showToast('get_sms_code'.tr());
      return null;
    }
    try {
      SmartDialog.showLoading();

      EmailCheckCodeReq req = EmailCheckCodeReq(
        codeKey: _codeRes?.codeKey ?? '',
        email: _email ?? '',
        codeValue: _code ?? '',
      );
      SmsCodeCheckRes? _ = await ref
          .read(accountRepositoryProvider)
          .checkSecureByMailVerificationCode(req);
      // SmartDialog.dismiss(status: SmartStatus.loading);
      return _codeRes?.codeKey;
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11010:
        case 11000:
          // 邮箱格式错误
          SmartDialog.showToast('sms_code_invalid_expired'.tr());
          break;
        case 11011:
        case 11001:
          SmartDialog.showToast('email_code_invalid'.tr());
          break;
        default:
          // 其他错误
          SmartDialog.showToast('operate_failed'.tr());
          break;
      }
      return null;
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast('operate_failed'.tr());
      return null;
    }
  }

  Future<bool> fixAndCheckSubScribe(
      {required String codeKey,
      required String email,
      bool force = false}) async {
    try {
      bool fixInfoResult = await fixSafeInfo(codeKey, email, force);
      if (fixInfoResult == false) return false;
      if (!state.agreed) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        SmartDialog.showToast('bind_success'.tr());
        return true;
      } else {
        bool subsriberes = await ref
            .read(emailCollectionRespositoryProvider.notifier)
            .subscribe();
        SmartDialog.dismiss(status: SmartStatus.loading);
        if (subsriberes == true) {
          SmartDialog.showToast('operate_success'.tr());
          return true;
        } else {
          SmartDialog.showToast('operate_failed'.tr());
          return false;
        }
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast('bind_failure'.tr());
      return false;
    }
  }

  Future<bool> fixSafeInfo(String codeKey, String email, bool force) async {
    try {
      FixSafeInfoCodeReq req = FixSafeInfoCodeReq(
          codeKey: codeKey, email: email, coverOtherAccountPhone: force);
      UserInfoModel? info = await ref
          .read(accountRepositoryProvider)
          .fixUserSafeInfoByPhoneVerificationCode(req);
      if (info != null) {
        await AccountModule().saveUserInfo(info);
      } else {
        UserInfoModel? localUserInfo = await AccountModule().getUserInfo();
        localUserInfo?.email = email;
        localUserInfo?.mailChecked = 1;
        if (localUserInfo != null) {
          await AccountModule().saveUserInfo(localUserInfo);
        }
      }
      return true;
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 11005:
        case 11006:
        case 10121:
          // 邮箱格式错误
          SmartDialog.showToast('sms_code_invalid_expired'.tr());
          break;
        case 11015:
          SmartDialog.showToast('email_code_invalid'.tr());
          break;
        case 30911:
          showAlert(
            text: 'text_mine_phone_email_cover'.tr(),
            confirmCallBack: () {
              foreToBind(codeKey, email);
            },
          );
          break;
        default:
          // 其他错误
          SmartDialog.showToast('operate_failed'.tr());
          break;
      }
      return false;
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast('operate_failed'.tr());
      return false;
    }
  }

  Future<void> foreToBind(String codeKey, String email) async {
    bool result =
        await fixAndCheckSubScribe(codeKey: codeKey, email: email, force: true);
    if (result == true) {
      state = state.copyWith(
        event: PushEvent(func: RouterFunc.pop),
      );
      EventBusUtil.getInstance().fire(UserInfoChangeEvent());
    }
  }

  void showAlert({
    required String text,
    String? cancelString,
    String? confirmString,
    Function()? confirmCallBack,
    Function()? cancelCallback,
  }) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: cancelString ?? 'cancel'.tr(),
      confirmContent: confirmString ?? 'confirm'.tr(),
      confirmCallback: confirmCallBack,
      cancelCallback: cancelCallback,
    );
    state = state.copyWith(event: alert);
  }

  Future<bool> sendVerifyCode(RecaptchaModel recaptchaModel) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if ((_email?.length ?? 0) > 45) {
      SmartDialog.showToast('email_too_long'.tr());
      return false;
    }
    SmartDialog.showLoading();
    try {
      var lang = await LocalModule().getLangTag();
      EmailCodeReq req = EmailCodeReq(
        email: _email ?? '',
        token: recaptchaModel.token,
        sessionId: recaptchaModel.csessionid,
        sig: recaptchaModel.sig,
        lang: lang,
        skipEmailBoundVerify: true,
      );
      SmsCodeRes res = await ref
          .read(accountRepositoryProvider)
          .getSecureByMailVerificationCode(req);
      _codeRes = res;
      SmartDialog.dismiss(status: SmartStatus.loading);
      SmartDialog.showToast('send_success'.tr());
      return true;
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      switch (e.code) {
        case 10007:
          // 邮箱格式错误
          SmartDialog.showToast('mail_error'.tr());
          break;
        case 30913:
          SmartDialog.showToast('can_not_change_original_email'.tr());
          break;
        default:
          // 其他错误
          SmartDialog.showToast('send_sms_code_error'.tr());
          break;
      }
      return false;
    } catch (e) {
      SmartDialog.showToast('send_sms_code_error'.tr());
      return false;
    }
  }
}
