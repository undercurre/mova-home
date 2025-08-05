import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_connect_method.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_type_selection_uistate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pair_type_selection_state_notifier.g.dart';

@riverpod
class PairTypeSelectionStateNotifier extends _$PairTypeSelectionStateNotifier {
  @override
  PairTypeSelectionUIState build() {
    return const PairTypeSelectionUIState();
  }

  void setPairConnectMethod(PairConnectMethod connectMethod) {
    state = state.copyWith(connectMethod: connectMethod);
  }
}
