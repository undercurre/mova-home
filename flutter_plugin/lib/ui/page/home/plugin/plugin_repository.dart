import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/rn_version_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/rn_plugin_update_model.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plugin_repository.g.dart';

@riverpod
class PluginRepository extends _$PluginRepository {
  @override
  int build() {
    return 0;
  }

  Future<RNVersionModel> getRNSDK() async {
    return ref
        .watch(apiClientProvider)
        .getRNSDKPlugin(Constant.appVersion, Platform.isAndroid ? '1' : '0')
        .then((value) {
      if (value.successed()) {
        if (value.data == null ||
            value.data!.version == null ||
            value.data!.version! <= 0) {
          return Future.error(DreameException(incompatible));
        }
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<RNVersionModel> getRNPlugin(String model) async {
    return ref
        .watch(apiClientProvider)
        .getRNPlugin(model, Constant.appVersion, Platform.isAndroid ? '1' : '0')
        .then((value) {
      if (value.successed()) {
        if (value.data == null ||
            value.data!.version == null ||
            value.data!.version! <= 0) {
          return Future.error(DreameException(incompatible));
        }
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<RNVersionModel> getLatestCommonPluginInfo(
      String pluginType, String appVer) async {
    return processApiResponse(ref
        .watch(apiClientProvider)
        .getCommonPlugin(<String, String>{
      'appVer': appVer,
      'os': Platform.isAndroid ? '1' : '0',
      'pluginType': pluginType
    }));
  }
}
