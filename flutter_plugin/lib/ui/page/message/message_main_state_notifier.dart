import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/message/message_repository.dart';
import 'package:flutter_plugin/utils/dateformat_utils.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'message_main_ui_state.dart';

part 'message_main_state_notifier.g.dart';

@riverpod
class MessageMainStateNotifier extends _$MessageMainStateNotifier {
  final String _notificationTime = 'notification_time';

  @override
  MessageMainUIState build() {
    return const MessageMainUIState();
  }

  Future<void> init() async {
    bool isChina = (await LocalModule().getCountryCode()).toLowerCase() == 'cn';
    String? phoneCode = (await AccountModule().getUserInfo())?.phoneCode;
    List<MessageItemModel> headMsgs = [
      MessageItemModel(
          img: 'ic_msg_system',
          defaultImg: 'ic_msg_system',
          type: 'system_msg',
          title: 'text_system_message'.tr(),
          date: '',
          unread: 0,
          subTitle: ''),
      MessageItemModel(
          img: 'ic_msg_share',
          defaultImg: 'ic_msg_share',
          type: 'share_msg',
          title: 'text_share_message'.tr(),
          date: '',
          unread: 0,
          subTitle: '')
    ];
    // if (isChina && phoneCode != null && phoneCode == '86') {
    //   headMsgs.add(MessageItemModel(
    //     img: 'ic_msg_service',
    //     defaultImg: 'ic_msg_service',
    //     type: 'service_msg',
    //     title: 'text_service_message'.tr(),
    //     subTitle: '',
    //     date: '',
    //     unread: 0,
    //   ));
    // }
    state = state.copyWith(headMsgs: headMsgs);
  }

  Future<void> getNotificationPermission() async {
    PermissionStatus? statusNotification =
        await Permission.notification.request();
    int? notificationTime = await LocalStorage().getLong(_notificationTime);
    if (notificationTime == null ||
        notificationTime == 0 ||
        DateTime.now().millisecondsSinceEpoch - notificationTime >
            1000 * 60 * 60 * 24 * 7) {
      state = state.copyWith(
          showNoticePermission: statusNotification != PermissionStatus.granted);
    }
  }

  Future<void> deleteMessages(Map<String, String> req) async {
    try {
      LogUtils.i('[message] MessageMainStateNotifier deleteMessages req: ${req.toString()}');
      await ref.watch(messageRepositoryProvider).deleteMessages(req);
      state = state.copyWith(uiEvent: ToastEvent(text: 'delete_success'.tr()));
      unawaited(getMessageHomeRecord());
    } catch (error) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'delete_failed'.tr()));
      LogUtils.d(error);
    }
  }

  Future<void> markAllMessageRead() async {
    try {
      if (state.unreadTotal == 0) {
        SmartDialog.showToast('message_all_read'.tr());
        return;
      }
      await ref.watch(messageRepositoryProvider).markAllMessageRead();
      await getMessageHomeRecord();
    } catch (error) {
      LogUtils.d(error);
    }
  }

  Future<void> closeTips() async {
    await LocalStorage().putLong(
        _notificationTime, DateTime.now().millisecondsSinceEpoch.toInt());
    state = state.copyWith(showNoticePermission: false);
  }

  Future<void> getMessageHomeRecord() async {
    String langTag = await LocalModule().getLangTag();
    bool isChina = (await LocalModule().getCountryCode()).toLowerCase() == 'cn';
    String? phoneCode = (await AccountModule().getUserInfo())?.phoneCode;
    state = state.copyWith(loading: true);
    try {
      int unreadTotal = 0;
      MessageMainModel messageMainModel =
          await ref.watch(messageRepositoryProvider).getMessageHomeRecord('v1');
      List<MessageItemModel> deviceMsgs = [];
      if (messageMainModel.deviceMsgs != null &&
          messageMainModel.deviceMsgs!.isNotEmpty) {
        deviceMsgs.addAll(messageMainModel.deviceMsgs!.map((item) {
          unreadTotal += item.unread ?? 0;
          return MessageItemModel(
              img: item.icon ?? '',
              defaultImg: 'ic_placeholder_robot',
              type: 'device_msg',
              title: item.deviceName ?? '',
              showShared: item.message?.share == 1,
              rawData: item,
              date: item.message?.sendTime != null
                  ? DateFormatUtils.formatLocal(item.message!.sendTime!,
                      format: 'yyyy-MM-dd')
                  : '',
              unread: item.unread ?? 0,
              subTitle:
                  item.message?.getLocalizationContent(langTag, isChina) ?? '',
              link: '');
        }));
      }
      unreadTotal += messageMainModel.systemMsg?.unread ?? 0;
      unreadTotal += messageMainModel.shareMsg?.unread ?? 0;
      unreadTotal += messageMainModel.serviceMsg?.unread ?? 0;

      List<MessageItemModel> headMsgs = [
        MessageItemModel(
            img: '',
            defaultImg: 'ic_msg_system',
            type: 'system_msg',
            title: 'text_system_message'.tr(),
            rawData: messageMainModel.systemMsg,
            date: messageMainModel.systemMsg?.msgRecord?.createTime != null
                ? DateFormatUtils.formatLocal(
                    messageMainModel.systemMsg!.msgRecord!.createTime!,
                    format: 'yyyy-MM-dd')
                : '',
            unread: messageMainModel.systemMsg?.unread ?? 0,
            subTitle:
                messageMainModel.systemMsg?.msgRecord?.multiLangDisplay == null
                    ? 'message_list_empty'.tr()
                    : messageMainModel.systemMsg?.msgRecord
                        ?.getLangDisplay(langTag, isChina)
                        .first,
            link: messageMainModel.systemMsg?.msgRecord
                    ?.getLangDisplay(langTag, isChina)
                    .second ??
                ''),
        MessageItemModel(
            img: '',
            defaultImg: 'ic_msg_share',
            type: 'share_msg',
            title: 'text_share_message'.tr(),
            rawData: messageMainModel.shareMsg?.shareMessage,
            date: messageMainModel.shareMsg?.shareMessage?.sendTime != null
                ? DateFormatUtils.formatLocal(
                    messageMainModel.shareMsg!.shareMessage!.sendTime!,
                    format: 'yyyy-MM-dd')
                : '',
            unread: messageMainModel.shareMsg?.unread ?? 0,
            subTitle: (messageMainModel.shareMsg?.shareMessage
                        ?.localizationContents?.isNotEmpty ==
                    true)
                ? (messageMainModel.shareMsg?.shareMessage
                        ?.getLocalizationContent(langTag, isChina) ??
                    '')
                : 'message_list_empty'.tr())
      ];
      if (isChina && phoneCode != null && phoneCode == '86') {
        String lastMessageCategory =
            messageMainModel.serviceMsg?.msgRecord?.msgCategory ?? '';
        int memberMsg =
            messageMainModel.serviceMsg?.categoryUnread?.member_msg ?? 0;
        int activityMsg =
            messageMainModel.serviceMsg?.categoryUnread?.activity_msg ?? 0;
        int orderMsg =
            messageMainModel.serviceMsg?.categoryUnread?.order_msg ?? 0;

        var initialIndex = 0;
        if (lastMessageCategory == 'order_msg') {
          if (orderMsg > 0) {
            initialIndex = 0;
          }
        } else if (lastMessageCategory == 'member_msg') {
          if (memberMsg > 0) {
            initialIndex = 1;
          }
        } else if (lastMessageCategory == 'activity_msg') {
          if (activityMsg > 0) {
            initialIndex = 2;
          }
        }
        headMsgs.add(MessageItemModel(
            img: '',
            defaultImg: 'ic_msg_service',
            type: 'service_msg',
            rawData: messageMainModel.serviceMsg?.msgRecord,
            title: 'text_service_message'.tr(),
            date: messageMainModel.serviceMsg?.msgRecord?.createTime != null
                ? DateFormatUtils.formatLocal(
                    messageMainModel.serviceMsg!.msgRecord!.createTime!,
                    format: 'yyyy-MM-dd')
                : '',
            unread: messageMainModel.serviceMsg?.unread ?? 0,
            subTitle:
                messageMainModel.serviceMsg?.msgRecord?.multiLangDisplay == null
                    ? 'message_list_empty'.tr()
                    : messageMainModel.serviceMsg?.msgRecord
                        ?.getLangDisplay(langTag, isChina)
                        .third,
            link: messageMainModel.serviceMsg?.msgRecord
                    ?.getLangDisplay(langTag, isChina)
                    .second ??
                '',
            categoryUnread: CategoryUnread(
                member_msg: memberMsg,
                activity_msg: activityMsg,
                order_msg: orderMsg,
                initialIndex: initialIndex)));
      }
      state = state.copyWith(
          loading: false,
          unreadTotal: unreadTotal,
          headMsgs: headMsgs,
          deviceMsgs: deviceMsgs);
    } catch (error) {
      LogUtils.d(error);
    }
  }
}
