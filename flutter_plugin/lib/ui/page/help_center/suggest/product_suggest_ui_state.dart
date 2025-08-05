import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/feedback_tag.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_report_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_suggest_ui_state.freezed.dart';

@freezed
class ProductSuggestUiState with _$ProductSuggestUiState {
  const factory ProductSuggestUiState({
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default(false) bool showTags,
    @Default([]) List<DeviceModel> deviceList,
    @Default([]) List<FeedBackTag> tags,
    @Default([]) List<SuggestReportMedia> medias,
    @Default('0/500') String contentNumber,
    int? selectIndex,
    @Default(false) bool enableUploadLog,
    @Default(false) bool visibleUploadLog,
    DeviceModel? selectedDevice,
  }) = _ProductSuggestUiState;
}
