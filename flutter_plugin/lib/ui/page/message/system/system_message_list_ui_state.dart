import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/common_ui_event/common_ui_event.dart';

part 'system_message_list_ui_state.freezed.dart';

@freezed
class SystemMessageListUiState with _$SystemMessageListUiState {
  factory SystemMessageListUiState(
          {@Default(1) int page,
          @Default(20) int size,
          @Default(false) bool hasMore,
          CommonUIEvent? uiEvent,
          @Default([]) List<CommonMsgRecord> systemMessageList}) =
      _SystemMessageListUiState;
}
