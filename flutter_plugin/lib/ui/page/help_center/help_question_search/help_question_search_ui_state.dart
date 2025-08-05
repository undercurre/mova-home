import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_question_search_ui_state.freezed.dart';

@freezed
class HelpQuestionSearchUiState with _$HelpQuestionSearchUiState {
  const factory HelpQuestionSearchUiState({
    @Default(EmptyEvent()) CommonUIEvent event,
    List<AppFaq>? faqs,
    String? searchText,
  }) = _HelpQuestionSearchUiState;
}
