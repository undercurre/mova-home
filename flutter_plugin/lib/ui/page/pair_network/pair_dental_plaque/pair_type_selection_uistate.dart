import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_connect_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_type_selection_uistate.freezed.dart'; // 确保文件实际存在

@freezed
class PairTypeSelectionUIState with _$PairTypeSelectionUIState {
  const factory PairTypeSelectionUIState({
    @Default(PairConnectMethod.WIFI) PairConnectMethod connectMethod,
  }) = _PairTypeSelectionUIState;
}
