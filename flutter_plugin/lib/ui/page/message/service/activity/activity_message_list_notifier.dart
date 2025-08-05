import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/message/message_repository.dart';
import 'package:flutter_plugin/ui/page/message/service/service_message_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'activity_message_list_ui_state.dart';


part 'activity_message_list_notifier.g.dart';

@riverpod
class ActivityMessageListNotifier extends _$ActivityMessageListNotifier {
  @override
  ActivityMessageListUiState build() {
    return ActivityMessageListUiState();
  }

  Future<void> refreshMessage({bool forceRead = false}) async {
    try {
      state = state.copyWith(page: 1);
      List<CommonMsgRecord> systemMessageList = await ref
          .watch(messageRepositoryProvider)
          .getCommonMessageRecord(
              'activity_msg',
              DateTime.now().millisecondsSinceEpoch ~/ 1000,
              state.page,
              state.size,
              forceRead: forceRead,
              readCallback: (readSuccess) => {
                ref.read(serviceMessageStateNotifierProvider.notifier).setActivityMsgUnreadCount(0)
              }
      );

      String langTag = await LocalModule().getLangTag();
      bool isChina =
          (await LocalModule().getCountryCode()).toLowerCase() == 'cn';
      List<CommonMsgRecord> list = [];
      for (var element in systemMessageList) {
        CommonMsgRecordExt? extBean;
        try {
          extBean = CommonMsgRecordExt.fromJson(jsonDecode(element.ext ?? ''));
        } catch (e) {
          LogUtils.d(e);
        }
        list.add(element.copyWith(
            display: _convertMessageDisplay(
                element.multiLangDisplay ?? '', langTag, isChina),
            extBean: extBean));
      }
      state = state.copyWith(activityMessageList: list);
      if (systemMessageList.length >= state.size) {
        state = state.copyWith(page: state.page + 1, hasMore: true);
      } else {
        state = state.copyWith(hasMore: false);
      }
    } catch (error) {
      LogUtils.d(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  Future<bool> loadMoreMessage() async {
    if (!state.hasMore) {
      return Future.value(false);
    }
    try {
      List<CommonMsgRecord> systemMessageList = await ref
          .watch(messageRepositoryProvider)
          .getCommonMessageRecord(
              'activity_msg',
              DateTime.now().millisecondsSinceEpoch ~/ 1000,
              state.page,
              state.size);

      String langTag = await LocalModule().getLangTag();
      bool isChina =
          (await LocalModule().getCountryCode()).toLowerCase() == 'cn';
      List<CommonMsgRecord> list = [...state.activityMessageList];
      for (var element in systemMessageList) {
        CommonMsgRecordExt? extBean;
        try {
          extBean = CommonMsgRecordExt.fromJson(jsonDecode(element.ext ?? ''));
        } catch (e) {
          LogUtils.d(e);
        }
        list.add(element.copyWith(
            display: _convertMessageDisplay(
                element.multiLangDisplay ?? '', langTag, isChina),
            extBean: extBean));
      }
      state = state.copyWith(activityMessageList: list);
      if (systemMessageList.length >= state.size) {
        state = state.copyWith(page: state.page + 1, hasMore: true);
        return Future.value(true);
      } else {
        state = state.copyWith(hasMore: false);
        return Future.value(false);
      }
    } catch (error) {
      LogUtils.d(error);
    }
    return Future.value(false);
  }

  Future<void> deleteMessageByMsgId(String msgId) async {
    try {
      await ref.watch(messageRepositoryProvider).deleteCommonMessage(msgId);
      List<CommonMsgRecord> list = [...state.activityMessageList];
      list.removeWhere((element) {
        return element.id == msgId;
      });

      state = state.copyWith(
          activityMessageList: list,
          uiEvent: ToastEvent(text: 'delete_success'.tr()));
    } catch (error) {
      LogUtils.d(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  Future<void> clearMessage() async {
    try {
      await ref
          .watch(messageRepositoryProvider)
          .clearCommonMessageRecord('activity_msg');
      state = state.copyWith(
          activityMessageList: [],
          uiEvent: ToastEvent(text: 'delete_success'.tr()));
    } catch (error) {
      LogUtils.d(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  CommonMsgRecordDisplay _convertMessageDisplay(
      String display, String langTag, bool isChina) {
    var displayMap = jsonDecode(display);
    var langDisplay = displayMap[langTag];
    if (langDisplay != null) {
      String? content = langDisplay['content'];
      String? name = langDisplay['name'];
      if(content != null && content.isNotEmpty && name != null && name.isNotEmpty ){
        return CommonMsgRecordDisplay.fromJson(langDisplay);
      }
    }
    if (isChina) {
      return CommonMsgRecordDisplay.fromJson(displayMap['zh']);
    } else {
      return CommonMsgRecordDisplay.fromJson(displayMap['en']);
    }
  }
}
