import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/mine_share_permission_model.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_repository.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_add_contacts_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_contacts_detail_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_sharing_contacts_detail_state_notifier.g.dart';

@riverpod
class DeviceSharingContactsDetailStateNotifier
    extends _$DeviceSharingContactsDetailStateNotifier {
  final Map<String, bool> orgPermissionMap = {};

  @override
  DeviceSharingContactsDetailUiState build() {
    return DeviceSharingContactsDetailUiState();
  }

  void initData(SharedDeviceThumbEntity sharedEntity) {
    state = state.copyWith(sharedEntity: sharedEntity);
  }

  Future<void> queryDevicePermissionInfo() async {
    final queryResult = await queryDevicePermission();

    for (var permission in queryResult) {
      orgPermissionMap[permission] = true;
    }

    state = state.copyWith(queryResult: queryResult);
    state = state.copyWith(orgPermissionMap: orgPermissionMap);

    final permissionList = await getDevicePermissionInfo();
    LogUtils.d('DeviceSharing: permissionList: $permissionList');

    // 遍历 permissionList，根据 queryResult 设置 isOn 属性
    for (var permission in permissionList) {
      if (permission.entityValue?.permitKey != null) {
        if (queryResult.contains(permission.entityValue!.permitKey)) {
          permission.isOn = true;
        } else {
          permission.isOn = false;
        }
      } else {
        permission.isOn = false;
      }
    }

    // 更新 state 中的 permissionList
    state = state.copyWith(permissionList: permissionList);
  }

  Future<List<String>> queryDevicePermission() async {
    try {
      final result =
          await ref.watch(deviceShareRepositoryProvider).queryDevicePermission(
                state.sharedEntity?.did ?? '',
                state.sharedEntity?.sharedUid,
              );
      return result.split(',');
    } catch (error) {
      return [];
    }
  }

  Future<List<MineSharePermissionModel>> getDevicePermissionInfo() async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .getDevicePermissionInfo(state.sharedEntity?.productId ?? '');

      final modelResult = await Future.wait(
        result.map((e) => MineSharePermissionModel.fromEntity(e)),
      );

      return modelResult;
    } catch (error) {
      LogUtils.e('Get device permission info failed: $error');
      return [];
    }
  }

  Future<void> updatePermission(Map<String, bool> params, bool savable) async {
    final currentPermissions = Map<String, bool>.from(state.orgPermissionMap);
    params.forEach(
      (key, value) {
        if (value) {
          currentPermissions[key] = value;
        } else {
          if (currentPermissions.containsKey(key)) {
            currentPermissions.remove(key);
          }
        }
      },
    );
    state = state.copyWith(orgPermissionMap: currentPermissions);
    state = state.copyWith(isEditable: savable);
  }

  Future<bool> checkDeviceShareStatus() async {
    try {
      final result =
          await ref.watch(deviceShareRepositoryProvider).checkDeviceShareStatus(
                state.sharedEntity?.did ?? '',
                state.sharedEntity?.sharedUid ?? '',
                state.sharedEntity?.model ?? '',
              );
      return result;
    } on DreameException catch (error) {
      LogUtils.e(error);
      state = state.copyWith(
          uiEvent: ToastEvent(
              text: error.message ?? 'share_device_to_user_error'.tr()));
      state = state.copyWith(
        uiEvent: PushEvent(
          path: DeviceSharingAddContactsPage.routePath,
          func: RouterFunc.pop,
        ),
      );
      return false;
    }
  }

  // 更新设备权限
  Future<void> savePermissionUpdate() async {
    try {
      final result =
          await ref.watch(deviceShareRepositoryProvider).editSharedPermit(
                state.sharedEntity?.did ?? '',
                state.sharedEntity?.user?.uid ?? '',
                state.orgPermissionMap,
              );
      if (result) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'text_permission_has_updated'.tr()));
      } else {
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
      state = state.copyWith(
        uiEvent: PushEvent(
          path: DeviceSharingAddContactsPage.routePath,
          func: RouterFunc.pop,
        ),
      );
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'toast_net_error'.tr()));
      state = state.copyWith(
        uiEvent: PushEvent(
          path: DeviceSharingAddContactsPage.routePath,
          func: RouterFunc.pop,
        ),
      );
    }
  }

  Future<bool> shareWithUser() async {
    try {
      Map<String, dynamic> params = {
        'shareUid': state.sharedEntity?.sharedUid,
        'did': state.sharedEntity?.did,
        'model': state.sharedEntity?.model,
      };
      Map<String, bool>? permissions = state.orgPermissionMap;

      if (permissions.isNotEmpty) {
        String permissionsKeys = permissions.keys.join(',');
        params['permissions'] = permissionsKeys;
      }

      final toShareResult =
          await ref.read(deviceShareRepositoryProvider).toShareDevice(params);

      LogUtils.d('DeviceSharing: toShareResult: $toShareResult');

      if (toShareResult) {
        unawaited(addRecentUser());
        return toShareResult;
      } else {
        state = state.copyWith(
            uiEvent: ToastEvent(text: 'share_device_to_user_error'.tr()));
        state = state.copyWith(
          uiEvent: PushEvent(path: DeviceSharingAddContactsPage.routePath),
        );
        return false;
      }
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'share_device_to_user_error'.tr()));
      state = state.copyWith(
        uiEvent: PushEvent(path: DeviceSharingAddContactsPage.routePath),
      );
      return false;
    }
  }

  Future<void> addRecentUser() async {
    final shareResult = await ref
        .read(deviceShareRepositoryProvider)
        .addRecentContact(state.sharedEntity?.sharedUid ?? '');
    if (shareResult) {
      LogUtils.d('DeviceSharing: addRecentContact success');
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'share_device_success'.tr()));
      state = state.copyWith(
        uiEvent: PushEvent(
          path: DeviceSharingAddContactsPage.routePath,
          func: RouterFunc.pop,
        ),
      );
    } else {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'share_device_to_user_error'.tr()));
    }
  }
}
