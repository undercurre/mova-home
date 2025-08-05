import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheme_state.freezed.dart';

@freezed
class SchemeState with _$SchemeState {
  factory SchemeState(
      {@Default('') String schemeType,
      @Default('') String ext,
      @Default(false) bool fromColdBoot,
      CommonUIEvent? uiEvent}) = _SchemeState;
}
