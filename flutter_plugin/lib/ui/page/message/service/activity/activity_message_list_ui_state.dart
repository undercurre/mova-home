import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';




part 'activity_message_list_ui_state.freezed.dart';

@freezed
class ActivityMessageListUiState with _$ActivityMessageListUiState {
  factory ActivityMessageListUiState(
      {@Default(1) int page,
        @Default(20) int size,
        @Default(false) bool hasMore,
        @Default([]) List<CommonMsgRecord> activityMessageList,
        CommonUIEvent? uiEvent}) =
  _ActivityMessageListUiState;
}
