import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_center_product_list_ui_state.freezed.dart';

@freezed
class HelpCenterProductListUiState with _$HelpCenterProductListUiState {
  const factory HelpCenterProductListUiState({
    @Default([]) List<HelpCenterKindOfProduct> products,
    @Default([]) List<HelpCenterKindOfProduct> childrenList,
    @Default(0) int kindofIndex,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _HelpCenterProductListUiState;
}
