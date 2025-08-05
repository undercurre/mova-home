import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_list_ui_state.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_accepted_list_state_notifier.g.dart';

@riverpod
class DeviceAcceptedListStateNotifier
    extends _$DeviceAcceptedListStateNotifier {
  @override
  DeviceAcceptedListUiState build() {
    return DeviceAcceptedListUiState();
  }

  Future<void> refreshSharedDeviceList() async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .getMySharedDeviceList();
      final recordsData = result.page.records;
      List<DeviceModel> records = List.from(recordsData);

      state = state.copyWith(
        deviceList: records,
      );
    } catch (error) {
      LogUtils.e(error);
    }
  }

  Future<void> deleteSharedDevice(String did) async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .deleteSharedDevice(did);
      if (result) {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'delete_success'.tr()));
        ref.read(homeStateNotifierProvider.notifier).refreshDevice(slience: true);
      }
      // 再获取一次分享列表
      await refreshSharedDeviceList();
    } on DreameAuthException catch (error) {
      LogUtils.e(error);
      final errorCode = error.code;
      if (errorCode == 30410) {
        // 用户不存在
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'user_not_exist'.tr()));
      } else {
        state = state.copyWith(uiEvent: ToastEvent(text: 'delete_failed'.tr()));
      }
      await refreshSharedDeviceList();
    }
  }
}
