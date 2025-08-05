import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_message_list_ui_state.freezed.dart';

@freezed
class ShareMessageListUiState with _$ShareMessageListUiState {
  factory ShareMessageListUiState(
      {@Default(0) int offset,
      @Default(10) int limit,
      @Default([]) List<ShareMessageModel> shareMessageList,
      @Default('') String searchKey,
      CommonUIEvent? uiEvent}) = _ShareMessageListUiState;
}
