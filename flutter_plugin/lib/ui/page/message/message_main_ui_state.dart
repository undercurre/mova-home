import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_main_ui_state.freezed.dart';

@freezed
class MessageMainUIState with _$MessageMainUIState {
  const factory MessageMainUIState(
      {@Default(true) bool loading,
      @Default(0) int unreadTotal,
      CommonUIEvent? uiEvent,
      @Default(false) bool showNoticePermission,
      @Default([]) List<MessageItemModel> headMsgs,
      @Default([]) List<MessageItemModel> deviceMsgs}) = _MessageMainUIState;
}

@unfreezed
class MessageItemModel with _$MessageItemModel {
  factory MessageItemModel({
    String? type,
    @Default('') String title,
    @Default('') String subTitle,
    @Default('') String date,
    @Default('') String img,
    @Default('') String defaultImg,
    @Default(0) int unread,
    String? link,
    @Default(false) showShared,
    dynamic rawData,
    dynamic categoryUnread
  }) = _MessageItemModel;
}
