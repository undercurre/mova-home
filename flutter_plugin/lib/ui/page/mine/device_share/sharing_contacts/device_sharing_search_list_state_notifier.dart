import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_repository.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_search_list_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_sharing_search_list_state_notifier.g.dart';

@riverpod
class DeviceSharingSearchListStateNotifier
    extends _$DeviceSharingSearchListStateNotifier {
  @override
  DeviceSharingSearchListUiState build() {
    return DeviceSharingSearchListUiState();
  }

  void initData(SharedDeviceThumbEntity sharedEntity) {
    state = state.copyWith(sharedEntity: sharedEntity);
    fetchRecentContactedUserList();
  }

  Future<void> updateSearchedKeyword(String value) async {
    state = state.copyWith(
        searchedKeyword: value, nextStepEnable: value.isNotEmpty);
  }

  // 根据用户填写的关键字进行搜索
  Future<List<MineRecentUser>> searchUser() async {
    try {
      final result = await ref
          .read(deviceShareRepositoryProvider)
          .fetchSearchedUserList(state.searchedKeyword!);
      if (result.isEmpty) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'invalid_account_to_retry'.tr()));
        return [];
      } else {
        return result;
      }
    } catch (error) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      LogUtils.e('DeviceSharing: searchUser error: $state');
      return [];
    }
  }

  // 获取最近联系用户列表
  Future<void> fetchRecentContactedUserList() async {
    try {
      final result = await ref
          .read(deviceShareRepositoryProvider)
          .fetchRecentContactedUserList();
      state = state.copyWith(userList: result);
    } catch (error) {
      state = state.copyWith(userList: []);
    }
  }

  Future<bool> checkDeviceShareStatus(
    String did,
    String uid,
    String model,
  ) async {
    try {
      final result = await ref
          .read(deviceShareRepositoryProvider)
          .checkDeviceShareStatus(did, uid, model);
      return result;
    } on DreameException catch (error) {
      state = state.copyWith(uiEvent: ToastEvent(text: error.message ?? ''));
      return false;
    }
  }
}
