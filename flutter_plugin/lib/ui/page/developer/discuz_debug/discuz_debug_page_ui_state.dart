import 'package:freezed_annotation/freezed_annotation.dart';

part 'discuz_debug_page_ui_state.freezed.dart';

@freezed
class DiscuzDebugPageUIState with _$DiscuzDebugPageUIState {
  factory DiscuzDebugPageUIState({
    @Default(false) bool enable,
    @Default(null) String? host,
  }) = _DiscuzDebugPageUIState;
}
