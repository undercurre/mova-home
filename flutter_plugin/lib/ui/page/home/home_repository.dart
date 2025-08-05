import 'dart:convert';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/home/after_sale_config.dart';
import 'package:flutter_plugin/model/home/message_stat.dart';
import 'package:flutter_plugin/model/home/product_resource_config_model.dart';
import 'package:flutter_plugin/model/otc_info.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository(this.apiClient);

  Future<DeviceListModel> getDeviceList() {
    return LocalModule().getLangTag().then((langTag) {
      return apiClient.getDeviceList(
          {'current': 1, 'size': 200, 'lang': langTag, 'sharedStatus': 1});
    }).then((data) {
      if (data.successed()) {
        return Future.value(data.data!);
      } else {
        return Future.error(DreameException(data.code, data.msg));
      }
    });
  }

  Future<ProductResourceConfigModel> getProductResourceConfig(String productId, String dictKey) {
     return apiClient.getProductResourceConfig(productId, dictKey).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<MessageStat> getHomeMsgStat() {
    return apiClient.getHomeMsgStat('v1').then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<IotActionData> sendAction(String host, IotCommandRequest req) {
    return apiClient.sendAction(host, req).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> deleteDevice(String did) {
    return apiClient.deleteDevice({'did': did}).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> renameDevice(String did, String name) {
    return apiClient
        .renameDevice({'did': did, 'deviceCustomName': name}).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<IotResultData> updateProperties(String host, IotCommandRequest req) {
    return apiClient.updateProperty(host, req).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<IotResultData> sendCommand(String host, Map<String, dynamic> req) {
    return apiClient.sendCommand(host, req).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<OtcInfoRes> octInfo(String did, String model) {
    final params = {'did': did, 'model': model};
    return processApiResponse(apiClient.devOTCInfo(params));
  }

  Future<bool?> checkGuideTip(DeviceType deviceType, {String holdExtra = ''}) {
    String key = '';
    if (deviceType == DeviceType.vacuum) {
      key = 'key_home_guide_vaccum_v1';
    } else if (deviceType == DeviceType.hold) {
      key = 'key_home_guide_hold$holdExtra';
    } else {
      key = 'key_home_guide_${deviceType.name}';
    }
    return LocalStorage().getBool(key);
  }

  Future<void> updateGuideTip(DeviceType deviceType, {String holdExtra = ''}) {
    String key = '';
    if (deviceType == DeviceType.vacuum) {
      key = 'key_home_guide_vaccum_v1';
    } else if (deviceType == DeviceType.hold) {
      key = 'key_home_guide_hold$holdExtra';
    } else {
      key = 'key_home_guide_${deviceType.name}';
    }
    return LocalStorage().putBool(key, true);
  }

  Future<AfterSaleConfig> getAfterSaleConfig() async {
    final countryCode = await LocalModule().getCountryCode();
    var value = await apiClient.getAfterSaleConfig(countryCode);
    if (value.successed()) {
      return Future.value(value.data!);
    } else {
      return Future.error(DreameException(value.code, value.msg));
    }
  }

  void saveAfterSaleConfig(AfterSaleConfig result) {
    LocalStorage().putString('after_sale_info', json.encode(result));
  }

  Future<bool> checkUserIp() async {
    try {
      var ret = await apiClient.checkUserIp();
      LogUtils.i('--fenglu----, checkUserIp, ret: ${ret.data}');
      var countryCode = ret.data?.toLowerCase();
      return countryCode == 'cn' || countryCode == 'mo';
    } catch (e) {
      return false;
    }
  }
}

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository(ref.watch(apiClientProvider));
}
