import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_message_ui_state.freezed.dart';

@freezed
class ServiceMessageUiState with _$ServiceMessageUiState{
  factory ServiceMessageUiState(
      {@Default(false) bool orderShowRedDot,
        @Default(false) bool vipShowRedDot,
        @Default(false) bool activityShowRedDot
      }) =
  _ServiceMessageUiState;
}
