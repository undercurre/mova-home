import 'package:flutter_plugin/model/debug/gps_debug_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gps_debug_ui_state.freezed.dart';

@unfreezed
class GPSDebugUiState with _$GPSDebugUiState {
  factory GPSDebugUiState({
    GPSDebugModel? debugModel,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _GPSDebugUiState;
}
