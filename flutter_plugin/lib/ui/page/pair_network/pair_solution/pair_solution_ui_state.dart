import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_solution_ui_state.freezed.dart';

@freezed
class PairSolutionUiState with _$PairSolutionUiState {
  factory PairSolutionUiState(
      {@Default([]) List<PairSolutionModel> solutions}) = _PairSolutionUiState;
}
