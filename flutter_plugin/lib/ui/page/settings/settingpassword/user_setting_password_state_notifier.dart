import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart'; //数据源
import 'package:flutter_plugin/ui/page/settings/settingpassword/user_setting_password_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_setting_password_state_notifier.g.dart';

@riverpod
class UserSettingPasswordStateNotifier
    extends _$UserSettingPasswordStateNotifier {
  @override
  UserSettingPasswordUiState build() {
    return UserSettingPasswordUiState();
  }

  Future<bool> settingPasswordAction() async {
    if (_validCommitParams(state.password1!, state.password2!)) {
      try {
        SmartDialog.showLoading();
        await ref
            .watch(accountSettingRepositoryProvider)
            .settingPassword(state.password1!);
        SmartDialog.dismiss(status: SmartStatus.loading);
        return Future.value(true);
      } on DreameException catch (e) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        var code = e.code;
        switch (code) {
          case 30410:
            ref
                .read(userSettingPasswordUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'user_not_exist'.tr()));
          case 30917:
            ref.read(userSettingPasswordUiEventProvider.notifier).sendEvent(
                ToastEvent(text: 'reset_original_password_too_much'.tr()));
          default:
            ref
                .read(userSettingPasswordUiEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'setting_failure'.tr()));
        }
      } catch (error) {
        SmartDialog.dismiss(status: SmartStatus.loading);
        LogUtils.e(error);
        return Future.value(false);
      }
    }
    return Future.value(false);
  }

  void changeSubmitButtonStatus(bool enable) {
    state = state.copyWith(enableCommitButton: enable);
  }

  void changePassword1(String content) {
    state = state.copyWith(password1: content);
    _validCanClickButton(state.password1 ?? '', state.password2 ?? '');
  }

  void changePassword2(String content) {
    state = state.copyWith(password2: content);
    _validCanClickButton(state.password1 ?? '', state.password2 ?? '');
  }

  // 验证按钮是否可点击
  void _validCanClickButton(String newPassword1, String newPassword2) {
    if (newPassword1.isNotEmpty && newPassword2.isNotEmpty) {
      changeSubmitButtonStatus(true);
    } else {
      changeSubmitButtonStatus(false);
    }
  }

  // 提交网络请求前的本地验证
  bool _validCommitParams(String newPassword1, String newPassword2) {
    if (!isVaildPassword(newPassword1) || !isVaildPassword(newPassword2)) {
      ref
          .read(userSettingPasswordUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'pwd_error'.tr()));
      return false;
    } else if (newPassword1 != newPassword2) {
      ref
          .read(userSettingPasswordUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'pwd_different'.tr()));
      return false;
    }
    return true;
  }
}

@riverpod
class UserSettingPasswordUiEvent extends _$UserSettingPasswordUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
