import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/after_sale_item.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_center_ui_state.freezed.dart';

@freezed
class HelpCenterUiState with _$HelpCenterUiState {
  const factory HelpCenterUiState({
    @Default([]) List<HelpCenterProduct> topList,
    @Default([]) List<HelpCenterProduct> products,
    @Default([]) List<HelpCenterKindOfProduct> kindOfProducts,
    @Default(false) bool isShowTop,
    @Default(0) int topNumber,
    @Default(false) bool isOverSea,
    @Default([]) List<AfterSaleContactItem> saleContacts,
    @Default(true) bool expandContact,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _HelpCenterUiState;
}
