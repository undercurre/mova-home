import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/question_report_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_report_ui_state.freezed.dart';

@freezed
class QuestionReportUiState with _$QuestionReportUiState {
  const factory QuestionReportUiState({
    @Default([]) List<QuestionReportItem> reports,
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(true) bool appFeedbackIsCheck,
    @Default(false) bool submitEnable,
  }) = _QuestionReportUiState;
}
