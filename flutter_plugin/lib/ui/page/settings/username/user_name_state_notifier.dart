// ignore_for_file: avoid_public_notifier_properties

import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/page/settings/username/user_name_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_name_state_notifier.g.dart';

@riverpod
class UserNameSetNotifier extends _$UserNameSetNotifier {
  @override
  UserNameUiState build() {
    return UserNameUiState();
  }

  Future<UserInfoModel> getUserInfo() async {
    try {
      SmartDialog.showLoading();
      UserInfoModel userInfo =
          await ref.read(accountSettingRepositoryProvider).getUserInfo();
      SmartDialog.dismiss(status: SmartStatus.loading);
      bool enableButton = false;
      if (userInfo.name != null) {
        enableButton = userInfo.name!.isNotEmpty ? true : false;
      }
      state = state.copyWith(
        userName: userInfo.name ?? '',
        enableSaveButton: enableButton,
        dataPrepared: true,
      );
      unawaited(SmartDialog.dismiss(status: SmartStatus.loading));
      return Future.value(userInfo);
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
      return Future.error(error);
    }
  }

  Future<bool> putUserInfo() async {
    String nickName = state.userName;
    if (_validCommitParams(nickName)) {
      try {
        SmartDialog.showLoading();
        var userInfo = await ref
            .read(accountSettingRepositoryProvider)
            .putUserInfoDetail(null, null, nickName);
        state = state.copyWith(
          userName: userInfo.name ?? '',
        );
        ref
            .read(userNameEventProvider.notifier)
            .sendEvent(ToastEvent(text: 'setting_success'.tr()));
        return Future.value(true);
      } on DreameException catch (e) {
        var code = e.code;
        switch (code) {
          case 30000:
            ref
                .read(userNameEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'input_has_sensitive_words'.tr()));
          default:
            ref
                .read(userNameEventProvider.notifier)
                .sendEvent(ToastEvent(text: 'setting_failure'.tr()));
        }
      } catch (error) {
        ref
            .read(userNameEventProvider.notifier)
            .sendEvent(ToastEvent(text: 'setting_failure'.tr()));
        LogUtils.e(error);
        return Future.value(false);
      } finally {
        SmartDialog.dismiss(status: SmartStatus.loading);
      }
    }
    return Future.value(false);
  }

  bool _validCommitParams(String newName) {
    if (newName.isEmpty) {
      ref
          .read(userNameEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'please_enter_nick_name'.tr()));
      return false;
    } else if (newName.length > 20) {
      ref
          .read(userNameEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'nick_name_too_long'.tr()));
      return false;
    }
    return true;
  }

  void changeNickName(String newName) {
    if (newName.isNotEmpty) {
      state = state.copyWith(userName: newName, enableSaveButton: true);
    } else {
      state = state.copyWith(userName: newName, enableSaveButton: false);
    }
  }
}

@riverpod
class UserNameEvent extends _$UserNameEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent event) {
    state = event;
  }
}
