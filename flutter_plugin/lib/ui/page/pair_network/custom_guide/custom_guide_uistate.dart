import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_guide_uistate.freezed.dart';

@freezed
class CustomGuideUiState with _$CustomGuideUiState {
  const factory CustomGuideUiState({
    @Default(false) bool enableBtn,
    IotPairNetworkInfo? iotPairNetworkInfo,
    @Default(EmptyEvent()) CommonUIEvent event,
    PairGuideModel? guideModel,
    @Default(-1) int guideSortIndex,
    @Default(false) bool isShowOver,
    @Default(-1) int currentStep,
    @Default(0) int totalSteps,
  }) = _CustomGuideUiState;
}
