import 'dart:convert';
import 'dart:io';

import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/model/app_dynamic_resource.dart';
import 'package:flutter_plugin/model/app_res_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_dynamic_res_config_provider.g.dart';

@Riverpod(keepAlive: true)
class AppDynamicResConfigProvider extends _$AppDynamicResConfigProvider {
  @override
  AppDynamicResource build() {
    return const AppDynamicResource();
  }

  Future<void> initData() async {
    try {
      final jsonString = await LocalStorage().getString(
          Constant.dynamicConfigKey,
          fileName: Constant.appAnimFileKey);

      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        final appDynamicResource = AppDynamicResource.fromJson(jsonMap);
        state = appDynamicResource;
      }
    } catch (e) {
      // Handle parsing or storage errors
      LogUtils.e('Error decoding json string: $e');
    }
  }

  Future<void> checkAppDynamicResConfig() async {
    try {
      String path = await getPluginPath();
      LogUtils.d('[AppDynamicResConfigProvider] fetchAppDynamicResConfig path: $path');
      Directory dir = Directory(path);
      await processDirectory(dir);
    } catch (e) {
      LogUtils.e('[AppDynamicResConfigProvider] fetchAppDynamicResConfig error: $e');
    }
  }

  Future<String> getPluginPath() async {
    PluginLocalModel model =
        await ref.read(pluginProvider.notifier).getCommonPlugin(
              CommonPluginType.appAnim.value,
              appVer: Constant.appAnimVersion,
            );
    final path = await model.getPath();

    LogUtils.d(
        '[AppDynamicResConfigProvider] getCommonPlugin: appAnim version: ${model.version}, path: $path');

    return path ?? '';
  }

  Future<void> processDirectory(Directory dir) async {
    if (!dir.existsSync()) {
      LogUtils.d('Directory does not exist: $dir');
      return;
    }

    int startDate = 0;
    int endDate = 0;
    String appLaunchPath = '';
    String addDeviceBgPath = '';
    String addDevideBgCoverPath = '';
    ResourceType appLaunchSourceType = ResourceType.image;
    ResourceType addDeviceSourceType = ResourceType.image;

    var list = dir.listSync();
    for (var element in list) {
      if (element is File) {
        if (element.path.endsWith('config.json')) {
          String contents = await element.readAsString();
          Map<String, dynamic> config = jsonDecode(contents);
          startDate = config['startDate'];
          endDate = config['endDate'];

          if (isExpired(endDate)) {
            state = state.copyWith(
              startDate: startDate,
              endDate: endDate,
              addDeviceBg: '',
              addDeviceBgType: '',
              appLaunch: '',
              appLaunchType: '',
              addDeviceBgCover: '',
            );

            await markForCleanup(dir.path);
            return;
          }
        } else if (element.path.contains('add_device_bg_cover')) {
          // 处理 cover 逻辑
          addDevideBgCoverPath = element.path;
          continue;
        } else if (element.path.contains('add_device_bg')) {
          if (element.path.endsWith('.mp4')) {
            addDeviceSourceType = ResourceType.video;
          } else if (element.path.endsWith('.json')) {
            addDeviceSourceType = ResourceType.lottie;
          } else if (element.path.endsWith('.png') ||
              element.path.endsWith('.jpg') ||
              element.path.endsWith('.jpeg')) {
            addDeviceSourceType = ResourceType.image;
          }
          addDeviceBgPath = element.path;
        } else if (element.path.contains('app_launch')) {
          if (element.path.endsWith('.mp4')) {
            appLaunchSourceType = ResourceType.video;
          } else if (element.path.endsWith('.json')) {
            appLaunchSourceType = ResourceType.lottie;
          } else if (element.path.endsWith('.png') ||
              element.path.endsWith('.jpg') ||
              element.path.endsWith('.jpeg')) {
            appLaunchSourceType = ResourceType.image;
          }
          appLaunchPath = element.path;
        }
      }
    }
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
      addDeviceBg: addDeviceBgPath,
      addDeviceBgType: addDeviceSourceType.name,
      appLaunch: appLaunchPath,
      appLaunchType: appLaunchSourceType.name,
      addDeviceBgCover: addDevideBgCoverPath,
    );

    final jsonMap = state.toJson();
    final jsonString = jsonEncode(jsonMap);
    await LocalStorage().putString(
      Constant.dynamicConfigKey,
      jsonString,
      fileName: Constant.appAnimFileKey,
    );
  }

  ResourceType currentResourceType() {
    switch (state.addDeviceBgType) {
      case 'video':
        return ResourceType.video;
      case 'lottie':
        return ResourceType.lottie;
      case 'image':
        return ResourceType.image;
      default:
        return ResourceType.video;
    }
  }

  void reset() {
    state = const AppDynamicResource();
  }

  bool isExpired(int endDate) {
    if (endDate == 0) return false;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    return currentTime > endDate;
  }

  Future<void> markForCleanup(String dirPath) async {
    try {
      await LocalStorage().putString(
        '${Constant.dynamicConfigKey}_cleanup',
        dirPath,
        fileName: Constant.appAnimFileKey,
      );

      state = state.copyWith(isExpired: true);
    } catch (e) {
      LogUtils.e('Error marking resources for cleanup: $e');
    }
  }

  Future<void> performPendingCleanup() async {
    try {
      final dirPath = await LocalStorage().getString(
        '${Constant.dynamicConfigKey}_cleanup',
        fileName: Constant.appAnimFileKey,
      );
      LogUtils.d('[AppDynamicResConfigProvider] performPendingCleanup dirPath: $dirPath');

      if (dirPath != null && dirPath.isNotEmpty) {
        final dir = Directory(dirPath);
        if (dir.existsSync()) {
          await dir.delete(recursive: true);
          LogUtils.d('Successfully cleaned up resources at: $dirPath');
        }

        await LocalStorage().remove(
          '${Constant.dynamicConfigKey}_cleanup',
          fileName: Constant.appAnimFileKey,
        );
      }
    } catch (e) {
      LogUtils.e('Error performing cleanup: $e');
    }
  }
}
