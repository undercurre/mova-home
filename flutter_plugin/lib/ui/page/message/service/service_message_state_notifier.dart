import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/message/message_repository.dart';
import 'package:flutter_plugin/ui/page/message/service/service_message_ui_state.dart';
import 'package:flutter_plugin/ui/page/message/service/vip/vip_message_list_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_message_state_notifier.g.dart';

@riverpod
class ServiceMessageStateNotifier extends _$ServiceMessageStateNotifier {
  @override
  ServiceMessageUiState build() {
    return ServiceMessageUiState();
  }

  void initData(int orderMsgUnreadCount,int vipMsgUnreadCount,int activityMsgUnreadCount){
    state = state.copyWith(
        orderShowRedDot: orderMsgUnreadCount > 0,
        vipShowRedDot: vipMsgUnreadCount > 0,
        activityShowRedDot: activityMsgUnreadCount > 0
    );
  }

  void setVipMsgUnreadCount(int vipMsgUnreadCount){
    state = state.copyWith(
      vipShowRedDot: vipMsgUnreadCount > 0
    );
  }

  void setOrderMsgUnreadCount(int orderMsgUnreadCount){
    state = state.copyWith(
        orderShowRedDot: orderMsgUnreadCount > 0
    );
  }

  void setActivityMsgUnreadCount(int activityMsgUnreadCount){
    state = state.copyWith(
        activityShowRedDot: activityMsgUnreadCount > 0
    );
  }
}
