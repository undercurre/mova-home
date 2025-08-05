import 'dart:io';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_setting_state_notifier.g.dart';

@riverpod
class AccountSettingStateNotifier extends _$AccountSettingStateNotifier {
  @override
  AccountSettingUiState build() {
    return AccountSettingUiState();
  }

  void showConfirmAlert(
    CommonUIEvent event,
  ) {
    state = state.copyWith(uiEvent: event);
  }

  Future<void> loadUserInfo() async {
    UserInfoModel? userInfo = await AccountModule().getUserInfo();
    if (userInfo != null) {
      state = state.copyWith(userInfo: userInfo);
      String regin = (await LocalModule().getCurrentCountry()).countryCode;
      state = state.copyWith(userInfo: userInfo, regin: regin);
    }
    return getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      UserInfoModel userInfo =
          await ref.read(accountSettingRepositoryProvider).getUserInfo();
      String regin = (await LocalModule().getCurrentCountry()).countryCode;
      state = state.copyWith(userInfo: userInfo, regin: regin);
    } catch (error) {
      LogUtils.e(error);
    }
  }

  Future<void> updateUserSex(int sex) async {
    try {
      await ref.read(accountSettingRepositoryProvider).updateSex(sex);

      ref
          .read(accountSettingUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'setting_success'.tr()));
      UserInfoModel userInfo =
          await ref.read(accountSettingRepositoryProvider).getUserInfo();
      state = state.copyWith(userInfo: userInfo);
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(accountSettingUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'setting_failure'.tr()));
      LogUtils.e(error);
    }
  }

  Future<void> updateUserBirthday(DateTime time) async {
    try {
      SmartDialog.showLoading();
      //长度13
      await ref
          .read(accountSettingRepositoryProvider)
          .updateBirthday(time.millisecondsSinceEpoch);
      UserInfoModel userInfo =
          await ref.read(accountSettingRepositoryProvider).getUserInfo();
      state = state.copyWith(userInfo: userInfo);
      SmartDialog.dismiss(status: SmartStatus.loading);

      ref
          .read(accountSettingUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'setting_success'.tr()));
    } on DreameException catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      var code = e.code;
      switch (code) {
        default:
          ref
              .read(accountSettingUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'setting_failure'.tr()));
          break;
      }
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
    }
  }

  Future<void> uploadAvator(File file) async {
    try {
      SmartDialog.showLoading();
      await ref.read(accountSettingRepositoryProvider).uploadAvator(file);
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(accountSettingUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'operate_success'.tr()));
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(accountSettingUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'operate_failed'.tr()));
      LogUtils.e(error);
    }
  }

  /// 退出登录，忽略接口返回，都返回true
  Future<bool> logOutAccount() async {
    try {
      await ref.read(accountSettingRepositoryProvider).logoutUser();
    } catch (error) {
      LogUtils.e(error);
    }
    return true;
  }
}

@riverpod
class AccountSettingUiEvent extends _$AccountSettingUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
