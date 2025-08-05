import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'mall_plugin_state_notifier.g.dart';

// 缓存已加载的商城信息
@Riverpod(keepAlive: true)
class MallPluginNotifier extends _$MallPluginNotifier {
  final Lock _lock = new Lock();

  @override
  PluginLocalModel? build() {
    return null;
  }

  Future<PluginLocalModel> getMallModelInfo({bool forceCheck = false}) async {
    if (state != null && !forceCheck) {
      unawaited(getLocalMallModelInfo());
      return state!;
    } else {
      // 没有保存信息时，主动更新进去
      PluginLocalModel model = await getLocalMallModelInfo();
      if (model.version != state?.version) {
        state = model;
      }
      return model;
    }
  }

  Future<void> checkCommonMallPluginUpgrade({bool forceCheck = false, String? tabType}) async {
    return ref.read(pluginProvider.notifier).checkMallUpdateIfNeeded(
        forceCheck: forceCheck, tabType: tabType ?? CommonPluginType.mall.value);
  }

  /*本地商城解压，存版本号*/
  Future<PluginLocalModel> getLocalMallModelInfo() async {
    String pluginType = CommonPluginType.mall.value;
    String key = '$COMMONPLUGIN$pluginType';
    PluginLocalModel pluginLocalModel =
        await ref.read(pluginLocalRepositoryProvider.notifier).getLocalInfo(key);

    if (pluginLocalModel.path == null || pluginLocalModel.path!.isEmpty) {
      await LocalStorage().remove(key);
      await unzipLocalMallAndSave();
      pluginLocalModel = await ref.read(pluginLocalRepositoryProvider.notifier).getLocalInfo(key);
    }
    return pluginLocalModel;
  }

  Future<void> unzipLocalMallAndSave() async {
    return _lock.synchronized(() => _unzipLocalMallAndSave());
  }

  Future<void> _unzipLocalMallAndSave() async {
    String key = '$COMMONPLUGIN${CommonPluginType.mall.value}';
    PluginLocalModel pluginLocalModel =
        await ref.read(pluginLocalRepositoryProvider.notifier).getLocalInfo(key);
    if (pluginLocalModel.path == null ||
        pluginLocalModel.path!.isEmpty ||
        int.parse(Constant.mallVersionLocal) > int.parse(pluginLocalModel.version ?? '0')) {
      ByteData byteData = await rootBundle.load('assets/webview_resource/mall/mall.zip');
      Uint8List wzzip = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      String md5Str = md5.convert(wzzip).toString();
      final archive = ZipDecoder().decodeBytes(wzzip);
      Directory? appDocumentsDir = await getApplicationDocumentsDirectory();

      String partition = pluginLocalModel.partition == 'a' ? 'b' : 'a';
      String path = await getFold('common_plugins', 'mall', partition);
      String zipPath = await getFold('common_plugins', 'mall', 'zip');

      try {
        // a 存在，说明已经有一个商城版本了，不需要解压assets目录下的包，
        // 可能存在解压 rename过程中，正在加载，因为时序错乱，导致加载的空目录问题
        if (await Directory(path).exists()) {
          return;
        }
        extractArchiveToDiskSync(archive, '${appDocumentsDir.path}/$zipPath');
        var tempPath = '${appDocumentsDir.path}/$zipPath';
        var dirPath = '${appDocumentsDir.path}/$path';
        if (await Directory(dirPath).exists()) {
          await Directory(dirPath).delete(recursive: true);
        }

        await Directory(tempPath).rename(dirPath);
        if (await Directory('${appDocumentsDir.path}/$zipPath').exists()) {
          await Directory('${appDocumentsDir.path}/$zipPath').delete(recursive: true);
        }
        await ref
            .read(pluginLocalRepositoryProvider.notifier)
            .updateLocalInfo(key, Constant.mallVersionLocal, path, partition, md5: md5Str);
      } catch (e) {
        LogUtils.e('-----extractArchiveToDisk-----error----,$e');
      }
    }
  }

  Future<String> getFold(String type, String subType, String partition) async {
    return '$type/$subType/$partition';
  }

  void clear() {
    state = null;
  }
}
