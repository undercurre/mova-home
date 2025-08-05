import 'package:freezed_annotation/freezed_annotation.dart';

part 'pair_search_uistate.freezed.dart'; // 确保文件实际存在

@freezed
class PairSearchUiState with _$PairSearchUiState {
  const factory PairSearchUiState({
    @Default('search') String navTitle,
    @Default('') String displayName,
    @Default('') String productId,
    @Default(1) int currentStep,
    @Default(1) int totalStep,
    @Default(false) bool enableBtn,

  }) = _PairConnectUiState;
}
