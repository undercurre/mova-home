import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_item.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product_medias.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_manual_ui_state.freezed.dart';

@freezed
class ProductManualUiState with _$ProductManualUiState {
  const factory ProductManualUiState({
    @Default(EmptyEvent()) CommonUIEvent event,
    @Default([]) List<AppFaq> faqs,
    @Default(false) bool showMore,
    @Default(false) bool showFaq,
    @Default([]) List<AfterSaleContactItem> saleContacts,
    String? video,
    @Default(false) bool showVideo,
    @Default(false) bool showAR,
    @Default(true) bool isExpand,
    @Default('') String productIntroduce,
    @Default('') String pdfUrl,
    List<DisplayMediaList>? displayMediaList,
  }) = _ProductManualUiState;
}
