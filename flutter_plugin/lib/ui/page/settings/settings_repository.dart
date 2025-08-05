import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/key_value_model.dart';
import 'package:flutter_plugin/model/ux_plan_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  final ApiClient apiClient;

  SettingsRepository(this.apiClient);

  Future<AppVersionModel> checkAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionStr = packageInfo.buildNumber;
    int? abi;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
      List<String> abis = deviceInfo.supported64BitAbis;
      if (abis.isEmpty) {
        abi = 32;
      } else {
        abi = 64;
      }
    } else if (Platform.isIOS) {
      versionStr = packageInfo.version.replaceAll('.', '');
    }
    return apiClient
        .checkAppVersion(
            int.tryParse(versionStr) ?? 0,
            Platform.isAndroid ? 1 : (Platform.isIOS ? 0 : -1),
            await AccountModule().getTenantId(),
            'movahome',
            abi,
            null)
        .then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<String> lastShowTime() async {
    return await LocalStorage()
            .getString('app_update_show_time', fileName: 'upgrade_show') ??
        '';
  }

  Future<bool> updateShowTime() async {
    final now = DateTime.now();
    return await LocalStorage().putString(
        'app_update_show_time', '${now.month}-${now.day}',
        fileName: 'upgrade_show');
  }

  Future<UXPlanModel> getUXPlanState() async {
    return apiClient.getUXPlanAuthState().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> setUXPlanState(int authState) async {
    UserInfoModel? info = await AccountModule().getUserInfo();
    return apiClient.setUXPlanAuthState(
        <String, dynamic>{'uid': info?.uid, 'value': authState}).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<List<KVModel>> getUserConfigSetting(List<String> keys) async {
    String key = keys.join(',');
    return apiClient.getUserConfigSetting(key).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> setUserConfigSetting(List<KVModel> keys) async {
    return apiClient.setUserConfigSetting({'keys': keys}).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<int> getAduserswitch() async {
    return processApiResponse<int>(apiClient.getAduserswitch());
  }

  Future<dynamic> setAduserswitch(int status) async {
    return processApiResponse<dynamic>(apiClient.setAduserswitch(status));
  }
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  return SettingsRepository(ref.watch(apiClientProvider));
}
