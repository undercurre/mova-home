import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/push/push_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/page/settings/logoff/user_logoff_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_logoff_state_notifier.g.dart';

@riverpod
class UserLogoffStateNotifier extends _$UserLogoffStateNotifier {
  @override
  DeleteAccountUiState build() {
    return DeleteAccountUiState();
  }

  Future<void> prepared() async {
    final country = await LocalModule().getCurrentCountry();
    final region = country.countryCode;
    final userInfo = await AccountModule().getUserInfo();

    String tips = 'logoff_account_tips'.tr();
    if (region.toLowerCase() == 'cn' &&
        userInfo?.phoneCode == '86' &&
        userInfo?.phone?.length == 11) {
      String mallStr =
          '        \n-${'text_remove_acccount_order_tip'.tr()}        \n-${'text_remove_acccount_vip_tip'.tr()}        \n-${'text_remove_acccount_score_tip'.tr()}        \n-${'text_remove_acccount_active_tip'.tr()}';
      tips += mallStr;
    }
    state = state.copyWith(tipStr: tips);
  }

  /// 删除账号，需要处理接口返回
  Future<bool> logoOffAction() async {
    try {
      SmartDialog.showLoading();
      await removePushToken();
      await ref.read(accountSettingRepositoryProvider).deleteUser();
      SmartDialog.dismiss(status: SmartStatus.loading);
      ref
          .read(deleteAccountUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'logoff_success'.tr()));
      await LifeCycleManager().logOut();
      return true;
    } catch (error) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.e(error);
      return false;
    }
  }

  Future<void> removePushToken() async {
    try {
      await ref.read(pushStateNotifierProvider.notifier).removePushToken();
    } catch (e) {
      LogUtils.e('------removePushToken------$e');
    }
  }
}

@riverpod
class DeleteAccountUiEvent extends _$DeleteAccountUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
