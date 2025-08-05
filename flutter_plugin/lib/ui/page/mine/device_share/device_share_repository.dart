import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/device_share/mine_share_permission_entity.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_share_repository.g.dart';

class DeviceShareRepository {
  final ApiClient apiClient;
  final DeviceShareRepositoryRef ref;

  DeviceShareRepository(this.ref, this.apiClient);

  // 获取我分享的设备列表
  Future<DeviceListModel> getMySharingDeviceList() {
    return LocalModule().getLangTag().then((langTag) {
      return apiClient.fetchMyDeviceList({
        'size': 9999,
        'master': 1,
        'lang': langTag,
      });
    }).then((data) {
      if (data.successed()) {
        return Future.value(data.data!);
      } else {
        return Future.error(DreameException(data.code, data.msg));
      }
    });
  }

  // 获取分享给我的设备列表
  Future<DeviceListModel> getMySharedDeviceList() {
    return LocalModule().getLangTag().then((langTag) {
      return apiClient.fetchMyDeviceList({
        'size': 9999,
        'master': 0,
        'lang': langTag,
      });
    }).then((data) {
      if (data.successed()) {
        return Future.value(data.data!);
      } else {
        return Future.error(DreameException(data.code, data.msg));
      }
    });
  }

  // 根据设备 ID 获取用户列表
  Future<List<MineRecentUser>> getSharedUserList(String did) async {
    Map<String, dynamic> params = {
      'did': did,
    };
    return apiClient.fetchSharedUserList(params).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        LogUtils.e('getMySharedDeviceList error: ${value.msg}');
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 最近联系人列表
  Future<List<MineRecentUser>> fetchRecentContactedUserList() async {
    return apiClient.fetchRecentUserList(20).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        LogUtils.e('fetchRecentContactedUserList error: ${value.msg}');

        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 根据用户输入信息获取用户列表
  Future<List<MineRecentUser>> fetchSearchedUserList(String text) async {
    return apiClient.fetchSearchedUserList(text).then((value) {
      if (value.success == true) {
        if (value.data != null) {
          return Future.value(value.data);
        } else {
          LogUtils.d('fetchSearchedUserList data is null');
          return Future.value([]);
        }
      } else {
        LogUtils.e('fetchSearchedUserList error: ${value.msg}');
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 检查设备分享状态
  Future<bool> checkDeviceShareStatus(
    String did,
    String shareUid,
    String model,
  ) async {
    Map<String, dynamic> params = {
      'did': did,
      'shareUid': shareUid,
      'model': model,
    };
    return apiClient.checkDeviceShareStatus(params).then((value) {
      if (value.success && value.code == 0) {
        return Future.value(value.data);
      } else {
        String errorMsg = value.msg ?? 'share_device_to_user_error'.tr();

        if (value.code > 0) {
          switch (value.code) {
            case 40010:
              errorMsg = 'share_device_over_times'.tr();
              break;
            case 40030:
              errorMsg = 'share_wait_deal'.tr();
              break;
            case 40031:
              errorMsg = 'share_already_share'.tr();
              break;
            case 40040:
              errorMsg = 'share_device_not_exist'.tr();
              break;
            case 40033:
              errorMsg = 'share_reject_with_yourself'.tr();
              break;
            case 40050:
              errorMsg = 'account_not_register'.tr();
              break;
            case 40060:
              errorMsg = 'cancel_share'.tr();
              break;
            case 40070:
              errorMsg = 'Toast_DeviceShare_UserOutOfService'.tr();
              break;
            default:
              break;
          }
        }
        return Future.error(DreameException(value.code, errorMsg));
      }
    });
  }

  // 保存共享设备权限更改
  Future<bool> editSharedPermit(
    String did,
    String? shareUid, [
    Map<String, bool>? permissions,
  ]) async {
    Map<String, dynamic> params = {
      'did': did,
    };

    if (shareUid != null) {
      params['shareUid'] = shareUid;
    }

    // 当 permissions 有值时，将其合并到 params 中
    if (permissions != null && permissions.isNotEmpty) {
      String permissionsString =
          permissions.entries.map((entry) => entry.key).join(',');
      params['permissions'] = permissionsString;
    }

    return apiClient.editSharedPermit(params).then((value) {
      if (value.success) {
        return Future.value(true);
      } else {
        LogUtils.e('editSharedPermit error: ${value.msg}');
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 添加设备分享者
  Future<bool> addRecentContact(String uid) async {
    return apiClient.addRecentContact(uid).then((value) {
      if (value.success) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 取消设备分享
  Future<bool> cancelShareDevice(String did, String shareUid) async {
    Map<String, dynamic> params = {
      'did': did,
      'shareUid': shareUid,
    };
    return apiClient.cancelShareDevice(params).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 设备分享
  Future<bool> toShareDevice(Map<String, dynamic> params) async {
    return apiClient.toShareDevice(params).then((value) {
      if (value.success) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<String> queryDevicePermission(String did, String? shareUid) async {
    Map<String, dynamic> params = {
      'did': did,
    };
    if (shareUid != null) {
      params['sharedUid'] = shareUid;
    }
    return apiClient.queryDevicePermit(params).then((value) {
      if (value.success && value.code == 0) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 获取设备权限
  Future<List<MineSharePermissionEntity>> getDevicePermissionInfo(
      String productId) async {
    return apiClient.devicePermissionInfo(productId).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 删除设备分享者
  Future<bool> deleteSharedDevice(String did) async {
    return apiClient.deleteDevice({'did': did}).then((value) {
      if (value.success && value.code == 0) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
DeviceShareRepository deviceShareRepository(DeviceShareRepositoryRef ref) {
  return DeviceShareRepository(ref, ref.watch(apiClientProvider));
}
