import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_repository.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing/device_sharing_list_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_sharing_list_state_notifier.g.dart';

@riverpod
class DeviceSharingListStateNotifier extends _$DeviceSharingListStateNotifier {
  @override
  DeviceSharingListUiState build() {
    return DeviceSharingListUiState();
  }

  Future<void> refreshSharingDeviceList() async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .getMySharingDeviceList();
      List<DeviceModel> records = result.page.records;

      state = state.copyWith(
        deviceList: records,
      );
    } catch (error) {
      LogUtils.e(error);
    }
  }
}
