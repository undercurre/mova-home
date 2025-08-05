import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggest_history_detail_ui_state.freezed.dart';

@freezed
class SuggestHistoryDetailUiState with _$SuggestHistoryDetailUiState {
  const factory SuggestHistoryDetailUiState({
    @Default(EmptyEvent()) CommonUIEvent event,
    SuggestHistoryItem? history,
  }) = _SuggestHistoryDetailUiState;
}
