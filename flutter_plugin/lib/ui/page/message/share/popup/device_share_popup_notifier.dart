import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/message_main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup_repository.dart';
import 'package:flutter_plugin/ui/page/message/share/popup/device_share_popup_state.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_list_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_share_popup_notifier.g.dart';

@riverpod
class DeviceSharePopupNotifier extends _$DeviceSharePopupNotifier {
  @override
  DeviceSharePopupState build() {
    return DeviceSharePopupState(null);
  }

  void initData(int ackResult, String did, String model, String ownUid,
      String messageId) {}

  Future<void> ackShareFromMessage(String messageId, bool accept) async {
    try {
      bool ret = await ref
          .watch(deviceSharePopupRepositoryProviderProvider)
          .ackShareFromMessage(messageId, accept);
      if (ret) {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_success'.tr()));
        await ref
            .read(shareMessageListNotifierProvider.notifier)
            .refreshShareMessage();
        await ref
            .read(homeStateNotifierProvider.notifier)
            .refreshDevice(slience: true);
      }
    } catch (e) {
      LogUtils.e('ackShareFromMessage error: $e');
      if (e is DreameException) {
        switch (e.code) {
          case 60000:
          case 60400:
          case 60900:
          case 60901:
          case 40040:
            state = state.copyWith(
                uiEvent: ToastEvent(text: 'share_msg_already_invalid'.tr()));
            break;
          default:
            state = state.copyWith(
                uiEvent: ToastEvent(text: 'toast_server_error'.tr()));
            break;
        }
      } else {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'toast_server_error'.tr()));
      }
    }
  }

  Future<void> ackshareFromDevice(
      bool accept, String deviceId, String model, String ownUid) async {
    try {
      bool ret = await ref
          .watch(deviceSharePopupRepositoryProviderProvider)
          .ackShareFromDevice(accept, deviceId, model, ownUid);
      if (ret) {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_success'.tr()));
        await ref
            .read(deviceAcceptedListStateNotifierProvider.notifier)
            .refreshSharedDeviceList();
        await ref
            .read(homeStateNotifierProvider.notifier)
            .refreshDevice(slience: true);
      }
    } catch (e) {
      if (e is DreameException) {
        switch (e.code) {
          case 60000:
          case 60400:
          case 60900:
          case 60901:
          case 40040:
            state = state.copyWith(
                uiEvent: ToastEvent(text: 'share_msg_already_invalid'.tr()));
            break;
          default:
            state = state.copyWith(
                uiEvent: ToastEvent(text: 'toast_server_error'.tr()));
            break;
        }
      } else {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'toast_server_error'.tr()));
      }
    }
  }

  Future<void> readMessageById(String messageId) async {
    try {
      bool ret = await ref
          .watch(deviceSharePopupRepositoryProviderProvider)
          .readMessageById(messageId);
      if (ret) {
        ref.read(homeStateNotifierProvider.notifier).refreshMsgCount();
        await ref
            .read(messageMainStateNotifierProvider.notifier)
            .getMessageHomeRecord();
      }
    } catch (e) {
      debugPrint('readMessageById error: $e');
    }
  }
}
