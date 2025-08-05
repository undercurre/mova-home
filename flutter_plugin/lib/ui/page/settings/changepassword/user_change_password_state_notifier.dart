import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart'; //数据源
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_change_password_state_notifier.g.dart';

@riverpod
class UserChangePasswordStateNotifier
    extends _$UserChangePasswordStateNotifier {
  @override
  UserChangePasswordUiState build() {
    return UserChangePasswordUiState();
  }

  Future<bool> changePasswordAction() async {
    if (_validCommitParams(state.oldPassword ?? '', state.newPassword1 ?? '',
        state.newPassword2 ?? '')) {
      try {
        SmartDialog.showLoading();
        await ref
            .watch(accountSettingRepositoryProvider)
            .changePassword(state.oldPassword!, state.newPassword1!);
        SmartDialog.dismiss(status: SmartStatus.loading);
        return Future.value(true);
      } on DreameException catch (e) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        var code = e.code;
        switch (code) {
          case 30410:
            ref
                .read(userChangePasswordUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'user_not_exist'.tr()));
            break;
          case 30916:
            ref.read(userChangePasswordUiEventProvider.notifier).sendEvent(
                ToastEvent(text: 'reset_original_password_error'.tr()));
            break;
          case 30917:
            ref.read(userChangePasswordUiEventProvider.notifier).sendEvent(
                ToastEvent(text: 'reset_original_password_too_much'.tr()));
            break;
          case 30918:
            ref.read(userChangePasswordUiEventProvider.notifier).sendEvent(
                ToastEvent(text: 'reset_original_password_duplicate'.tr()));
            break;
          default:
            ref
                .read(userChangePasswordUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'operate_failed'.tr()));
            break;
        }
      } catch (error) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        LogUtils.e(error);
      }
    }
    return Future.value(false);
  }

  void changeOldPasswrd(String content) {
    state = state.copyWith(oldPassword: content);
    _validCanClickButton(state.oldPassword ?? '', state.newPassword1 ?? '',
        state.newPassword2 ?? '');
  }

  void changeNewPasswrd1(String content) {
    state = state.copyWith(newPassword1: content);
    _validCanClickButton(state.oldPassword ?? '', state.newPassword1 ?? '',
        state.newPassword2 ?? '');
  }

  void changeNewPasswrd2(String content) {
    state = state.copyWith(newPassword2: content);
    _validCanClickButton(state.oldPassword ?? '', state.newPassword1 ?? '',
        state.newPassword2 ?? '');
  }

  void changeSubmitButtonStatus(bool enable) {
    state = state.copyWith(enableCommitButton: enable);
  }

  // 验证按钮是否可点击
  void _validCanClickButton(
      String oldPassword, String newPassword1, String newpassword2) {
    if (oldPassword.isNotEmpty &&
        newPassword1.isNotEmpty &&
        newpassword2.isNotEmpty) {
      changeSubmitButtonStatus(true);
    } else {
      changeSubmitButtonStatus(false);
    }
  }

  // 提交网络请求前的本地验证
  bool _validCommitParams(
      String oldPassword, String newPassword, String newPassword2) {
    if (newPassword != newPassword2) {
      ref
          .read(userChangePasswordUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'pwd_different'.tr()));
      return false;
    } else if (oldPassword == newPassword) {
      ref.read(userChangePasswordUiEventProvider.notifier).sendEvent(
          ToastEvent(text: 'reset_original_password_duplicate'.tr()));
      return false;
    } else if (!isVaildPassword(newPassword) ||
        !isVaildPassword(newPassword2)) {
      ref
          .read(userChangePasswordUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'pwd_error'.tr()));
      return false;
    }
    return true;
  }

  void focusOldPassword1() {
    state = state.copyWith(
        oldPasswordFocus: true,
        newPassword1Focus: false,
        newPassword2Focus: false);
  }

  void focusNewPassword1() {
    state = state.copyWith(
        oldPasswordFocus: false,
        newPassword1Focus: true,
        newPassword2Focus: false);
  }

  void focusNewPassword2() {
    state = state.copyWith(
        oldPasswordFocus: false,
        newPassword1Focus: false,
        newPassword2Focus: true);
  }

  void unfocusAlltextField() {
    state = state.copyWith(
        oldPasswordFocus: false,
        newPassword1Focus: false,
        newPassword2Focus: false);
  }
}

@riverpod
class UserChangePasswordUiEvent extends _$UserChangePasswordUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
