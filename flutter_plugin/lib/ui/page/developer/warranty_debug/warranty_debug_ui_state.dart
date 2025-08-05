import 'package:flutter_plugin/model/debug/warranty_debug_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'warranty_debug_ui_state.freezed.dart';

@unfreezed
class WarrantyDebugUiState with _$WarrantyDebugUiState {
  factory WarrantyDebugUiState({
    bool? isDebug,
    WarrantyDebugModel? debugModel,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _WarrantyDebugUiState;
}
