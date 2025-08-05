import 'package:flutter_plugin/ui/page/mine/device_share/device_share_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_share_state_notifier.g.dart';

@riverpod
class DeviceShareStateNotifier extends _$DeviceShareStateNotifier {
  @override
  DeviceShareUiState build() {
    return DeviceShareUiState();
  }

  void showSharingListPage(bool show) {
    state = state.copyWith(
      showSharingListPage: true,
    );
  }

  void showAcceptedLisePage(bool show) {
    state = state.copyWith(
      showAcceptedLisePage: true,
    );
  }
}
