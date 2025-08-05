import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_solution_uistate.freezed.dart';

@freezed
class PairSolutionUiState with _$PairSolutionUiState {
  const factory PairSolutionUiState({
    @Default([]) List<String> listContent,
    @Default(EmptyEvent()) CommonUIEvent event,
  }) = _PairSolutionUiState;
}
