import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';



part 'vip_message_list_ui_state.freezed.dart';

@freezed
class VipMessageListUiState with _$VipMessageListUiState {
  factory VipMessageListUiState(
      {@Default(1) int page,
        @Default(20) int size,
        @Default(false) bool hasMore,
        @Default([]) List<CommonMsgRecord> vipMessageList,
        CommonUIEvent? uiEvent}) =
  _VipMessageListUiState;
}
