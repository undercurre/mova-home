import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/model/device_share/shared_device_thumb_entity.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_detail_ui_state.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/mine_share_permission_model.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_accepted_detail_state_notifier.g.dart';

@riverpod
class DeviceAcceptedDetailStateNotifier
    extends _$DeviceAcceptedDetailStateNotifier {
  final Map<String, bool> orgPermissionMap = {};

  @override
  DeviceAcceptedDetailUiState build() {
    return DeviceAcceptedDetailUiState();
  }

  void initData(SharedDeviceThumbEntity sharedEntity) {
    state = state.copyWith(sharedEntity: sharedEntity);
  }

  Future<void> queryDevicePermissionInfo() async {
    String? uid = (await AccountModule().getUserInfo())?.uid;

    final queryResult =
        await queryDevicePermission(state.sharedEntity?.did ?? '', uid);

    state = state.copyWith(queryResult: queryResult);

    final permissionList =
        await getDevicePermissionInfo(state.sharedEntity?.productId ?? '');

    if (queryResult.isNotEmpty) {
      for (var permission in permissionList) {
        if (permission.entityValue?.permitKey != null) {
          orgPermissionMap[permission.entityValue!.permitKey!] = false;
          if (queryResult.contains(permission.entityValue!.permitKey)) {
            permission.isOn = true;
          }
        }
      }
    }
    state = state.copyWith(permissionList: permissionList);
  }

  Future<List<String>> queryDevicePermission(
      String deviceId, String? shareUid) async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .queryDevicePermission(deviceId, shareUid);
      return result.split(',');
    } catch (error) {
      return [];
    }
  }

  Future<List<MineSharePermissionModel>> getDevicePermissionInfo(
      String productId) async {
    try {
      final result = await ref
          .watch(deviceShareRepositoryProvider)
          .getDevicePermissionInfo(productId);

      final modelResult = await Future.wait(
        result.map((e) => MineSharePermissionModel.fromEntity(e)),
      );

      return modelResult;
    } catch (error) {
      LogUtils.e('Get device permission info error: $error');
      return [];
    }
  }
}
