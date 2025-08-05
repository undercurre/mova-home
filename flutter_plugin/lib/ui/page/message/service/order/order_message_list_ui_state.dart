import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';




part 'order_message_list_ui_state.freezed.dart';

@freezed
class OrderMessageListUiState with _$OrderMessageListUiState {
  factory OrderMessageListUiState(
      {@Default(1) int page,
        @Default(20) int size,
        @Default(false) bool hasMore,
        @Default([]) List<CommonMsgRecord> orderMessageList,
        CommonUIEvent? uiEvent}) =
  _OrderMessageListUiState;
}
