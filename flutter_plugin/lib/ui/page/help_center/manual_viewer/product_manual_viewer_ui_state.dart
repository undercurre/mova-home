import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_manual_viewer_ui_state.freezed.dart';

@freezed
class ProductManualViewerUIState with _$ProductManualViewerUIState {
  const factory ProductManualViewerUIState({
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool requestFaild,
    String? pdfUrl,
  }) = _ProductManualViewerUIState;
}
