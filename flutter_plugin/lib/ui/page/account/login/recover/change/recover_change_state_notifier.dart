import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/account/smscode_trans.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/change/recover_change_uistate.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recover_change_state_notifier.g.dart';

@riverpod
class RecoverChangeStateNotifier extends _$RecoverChangeStateNotifier {
  late SmscodeTrans _trans;
  String _password = '';
  String _confim = '';
  @override
  RecoverChangeUiState build() {
    return RecoverChangeUiState();
  }

  void updateTrans(SmscodeTrans trans) {
    _trans = trans;
  }

  void passwordChange(String text) {
    _password = text;
    check();
  }

  void confimWordChange(String text) {
    _confim = text;
    check();
  }

  void check() {
    bool enable = _password.isNotEmpty && _confim.isNotEmpty;
    state = state.copyWith(
      enableNext: enable,
    );
  }

  void changehidePassword(bool hide) {
    state = state.copyWith(hidePassword: hide);
  }

  void changeConfigPassword(bool hide) {
    state = state.copyWith(configPassword: hide);
  }

  Future<SmsCodeCheckRes?> getRequest() {
    if (_password != _confim) {
      return Future.error(DreameException(10007, 'pwd_different'));
    } else if (!isVaildPassword(_password)) {
      return Future.error(DreameException(90036, 'pwd_different'));
    }

    switch (_trans) {
      case SmscodeTransByPhone phoneSms:
        ResetPswByPhoneReq req = ResetPswByPhoneReq(
          codeKey: phoneSms.codeKey ?? '',
          phone: phoneSms.phone ?? '',
          phoneCode: phoneSms.tel ?? '',
          password: _password,
          confirmedPassword: _confim,
        );

        return ref
            .read(accountRepositoryProvider)
            .changeRecoverByPhoneVerificationCode(req);
      case SmscodeTransByMail mailSms:
        // changeRecoverByMailVerificationCode

        ResetPswByMailReq req = ResetPswByMailReq(
          codeKey: mailSms.codeKey ?? '',
          email: mailSms.email ?? '',
          password: _password,
          confirmedPassword: _confim,
        );
        return ref
            .read(accountRepositoryProvider)
            .changeRecoverByMailVerificationCode(req);
    }
  }

  void inputBegin(int event) {
    switch (_trans) {
      case SmscodeTransByPhone:
        LogModule().eventReport(4, event, int1: 1);
      default:
        LogModule().eventReport(4, event, int2: 1);
    }
  }

  Future<void> changePassword() async {
    switch (_trans) {
      case SmscodeTransByPhone:
        LogModule().eventReport(4, 12, int1: 1);
      default:
        LogModule().eventReport(4, 12, int2: 1);
    }

    SmartDialog.showLoading();
    try {
      await getRequest();
      SmartDialog.dismiss();
      LogModule().eventReport(4, 13, int1: 1);
      showToast('reset_password_success'.tr());
      _getBackToLogin();
    } on DreameException catch (e) {
      switch (_trans) {
        case SmscodeTransByPhone:
          LogModule().eventReport(4, 13, int1: 1);
        default:
          LogModule().eventReport(4, 13, int2: 1);
      }
      SmartDialog.dismiss();
      switch (e.code) {
        case 11005:
          showToast('sms_code_invalid_expired'.tr());
          break;
        case 11006:
          showToast('sms_code_invalid_expired'.tr());
          break;
        case 30918:
          showToast('reset_original_password_duplicate'.tr());
          break;
        case 10007:
          showToast('pwd_different'.tr());
          break;
        case 10009:
          showToast('pwd_error'.tr());
          break;
        case 90036:
          showToast('pwd_error'.tr());
          break;
        default:
          showToast('operate_failed'.tr());
      }
    } catch (e) {
      SmartDialog.dismiss();
      showToast('operate_failed'.tr());
    }
  }

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
  }

  void _getBackToLogin() {
    AppRoutes.resetStacks();
    String pagePath = RootPage.getPageRoutePath();
    if (pagePath != PasswordLoginPage.routePath) {
      state = state.copyWith(
        event: PushEvent(
          path: PasswordLoginPage.routePath,
          func: RouterFunc.push,
        ),
      );
    }
  }
}
