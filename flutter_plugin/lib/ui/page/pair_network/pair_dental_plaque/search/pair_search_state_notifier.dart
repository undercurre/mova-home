import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search/pair_search_uistate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pair_search_state_notifier.g.dart';

@riverpod
class PairSearchStateNotifier extends _$PairSearchStateNotifier {
  @override
  PairSearchUiState build() {
    return const PairSearchUiState();
  }

  void updateDisplayName(String displayName) {
    state = state.copyWith(displayName: displayName);
  }

  void updateProductId(String productId) {
    state = state.copyWith(productId: productId);
  }

  void updateCurrentStep(int currentStep) {
    state = state.copyWith(currentStep: currentStep);
  }

  void updateTotalStep(int totalStep) {
    state = state.copyWith(totalStep: totalStep);
  }

  void toggleEnableBtn() {
    state = state.copyWith(enableBtn: !state.enableBtn);
  }

  Future<void> initData() async {
    state = state.copyWith(
        currentStep: IotPairNetworkInfo().currentStep,
        totalStep: IotPairNetworkInfo().totalStep);
  }
}
