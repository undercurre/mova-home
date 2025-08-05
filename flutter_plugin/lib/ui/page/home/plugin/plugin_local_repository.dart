import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plugin_local_repository.g.dart';

const String RNSDK = 'rn_sdk_plugin';
const String RNPLUGIN = 'rn_plugin';
const String RNPLUGINRES = 'rn_plugin_res';
const String COMMONPLUGIN = 'common_plugin_';

enum CommonPluginType {
  mall('mall'),
  appSource('appSource'),
  appAnim('appAnim'),
  sdkDemo('sdkDemo'),
  ;

  final String value;
  const CommonPluginType(this.value);
}

@riverpod
class PluginLocalRepository extends _$PluginLocalRepository {
  @override
  void build() {
    return;
  }

  Future<PluginLocalModel> getLocalInfo(String type) async {
    List<String>? items = await LocalStorage().getStringList(type);
    if (items == null || items.isEmpty == true) {
      return PluginLocalModel();
    }
    if (items.length > 3) {
      String sourceCommonExtensionId = items[3];
      String sourceCommonPluginId = items[4];
      String sourceCommonPluginVer = items[5];
      String md5 = items[6];
      return PluginLocalModel(
          version: items[0],
          path: items[1],
          partition: items[2],
          sourceCommonExtensionId: sourceCommonExtensionId,
          sourceCommonPluginId: sourceCommonPluginId,
          sourceCommonPluginVer: sourceCommonPluginVer,
          md5: md5);
    }
    return PluginLocalModel(
      version: items[0],
      path: items[1],
      partition: items[2],
    );
  }

  Future<void> updateLocalInfo(
      String type, String version, String path, String partition,
      {String? sourceCommonExtensionId,
      String? sourceCommonPluginId,
      String? sourceCommonPluginVer,
      String? md5}) async {
    List<String> list = [version, path, partition];
    list.addAll([
      sourceCommonExtensionId ?? '',
      sourceCommonPluginId ?? '',
      sourceCommonPluginVer ?? '',
      md5 ?? '',
    ]);
    await LocalStorage().putStringList(type, list);
  }

  Future<void> removeLocalInfo(String type) async {
    await LocalStorage().remove(type);
  }
}
