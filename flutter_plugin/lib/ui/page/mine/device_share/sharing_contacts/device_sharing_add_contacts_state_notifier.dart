import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_repository.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_add_contacts_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../sharing/device_sharing_list_state_notifier.dart';

part 'device_sharing_add_contacts_state_notifier.g.dart';

@riverpod
class DeviceSharingAddContactsStateNotifier
    extends _$DeviceSharingAddContactsStateNotifier {
  @override
  DeviceSharingAddContactsUiState build() {
    return DeviceSharingAddContactsUiState();
  }

  void initData(SharedDeviceThumbEntity sharedEntity) {
    state = state.copyWith(sharedEntity: sharedEntity);
    fetchMineSharedUserList();
  }

  Future<void> fetchMineSharedUserList() async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .getSharedUserList(state.sharedEntity?.did ?? '');
      List<MineRecentUser> users = result;

      state = state.copyWith(
        userList: users,
      );
    } catch (error) {
      LogUtils.e(error);
    }
  }

  Future<void> cancelShareDevice(String uid) async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .cancelShareDevice(state.sharedEntity?.did ?? '', uid);
      if (result) {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'delete_success'.tr()));
      } else {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
      // 再获取一次分享列表
      await fetchMineSharedUserList();
      await ref
          .read(deviceSharingListStateNotifierProvider.notifier)
          .refreshSharingDeviceList();
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  Future<void> savePermissionUpdate(String did, String uid) async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .editSharedPermit(did, uid);
      if (result) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'text_permission_has_updated'.tr()));
      } else {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'toast_net_error'.tr()));
    }
  }
}
