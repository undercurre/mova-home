import 'package:freezed_annotation/freezed_annotation.dart';

part 'mall_debug_page_ui_state.freezed.dart';

@freezed
class MallDebugPageUIState with _$MallDebugPageUIState {
  factory MallDebugPageUIState({
    @Default(false) bool enable,
    @Default(null) String? host,
  }) = _MallDebugPageUIState;
}
