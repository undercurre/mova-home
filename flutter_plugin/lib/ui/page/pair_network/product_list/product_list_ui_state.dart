// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_scan/iot_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_list_ui_state.freezed.dart';
part 'product_list_ui_state.g.dart';

@freezed
class ProdcutListUiState with _$ProdcutListUiState {
  factory ProdcutListUiState({
    @Default(false) bool loading,
    @Default([]) List<KindOfProduct> menuList,
    @Default([]) List<SeriesOfProduct> productList,
    @Default({}) Map<String, dynamic> menuIndexPath,
    @Default([]) List<IotDevice> scannedList,
    DMIndexPath? selectedIdx,
  }) = _ProdcutListUiState;

  factory ProdcutListUiState.fromJson(Map<String, dynamic> json) =>
      _$ProdcutListUiStateFromJson(json);
}

@unfreezed
class DMIndexPath with _$DMIndexPath {
  DMIndexPath._();

  factory DMIndexPath({
    @Default(0) int section,
    @Default(0) int row,
  }) = _DMIndexPath;

  factory DMIndexPath.fromJson(Map<String, dynamic> json) =>
      _$DMIndexPathFromJson(json);

  bool isEqual(DMIndexPath other) {
    if (section != other.section || row != other.row) {
      return false;
    }
    return true;
  }

  bool isLessThan(DMIndexPath other) {
    if (isEqual(other)) {
      return false;
    }
    if (section < other.section) {
      return true;
    } else if (section == other.section && row < other.row) {
      return true;
    } else {
      return false;
    }
  }
}
