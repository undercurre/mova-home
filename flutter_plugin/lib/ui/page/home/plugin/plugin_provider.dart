import 'dart:async';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/download/download_provider.dart';
import 'package:flutter_plugin/common/download/download_result.dart';
import 'package:flutter_plugin/common/download/download_task.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/model/rn_debug_packages.dart';
import 'package:flutter_plugin/model/rn_version_model.dart';
import 'package:flutter_plugin/ui/page/developer/developer_mode_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_model.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_state.dart';
import 'package:flutter_plugin/ui/page/home/plugin/rn_plugin_update_model.dart';
import 'package:flutter_plugin/ui/page/mall/mall_content/mall_plugin_state_notifier.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/string_extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plugin_provider.g.dart';

@riverpod
class Plugin extends _$Plugin {
  // 添加基于 model 的防重复机制
  Map<String, bool> _updatingModels = {};
  CancelToken _cachedCancelToken = CancelToken();
  final Map<String, DateTime> _lastCheckTimes = {};
  final Duration _checkInterval = Duration(minutes: 1);


  @override
  PluginState build() {
    return PluginState();
  }

  void Function()? completionHandler;

  Future<String> getFold(String type, String subType, String partition) async {
    return '$type/$subType/$partition';
  }

  void hideUpdatePlugin(String tag) {
    _cachedCancelToken.cancel();
    ref.read(downLoadProvider.notifier).cancelAll();
  }

  /// 检查并设置 model 更新状态，防止重复更新
  bool _trySetModelUpdating(String model) {
    if (_updatingModels.containsKey(model)) {
      return false; // 已经在更新中
    }
    _updatingModels[model] = true;
    return true; // 成功设置更新状态
  }

  /// 清除 model 更新状态
  void _clearModelUpdating(String model) {
    _updatingModels.remove(model);
  }

  /// 清除所有更新状态
  void _clearAllUpdatingStates() {
    _updatingModels.clear();
  }

  /// SDK下载方法
  Future<bool> _downloadSDK(
      PluginLocalModel sdkLocalModel,
      PluginLocalModel pluginLocalModel,
      RNPluginUpdateModel rnPluginUpdateModel) async {
    try {
      RNVersionModel sdkVersionModel =
          await ref.read(pluginRepositoryProvider.notifier).getRNSDK();
      if (sdkVersionModel.version == null || sdkVersionModel.version == -1) {
        LogModule()
            .eventReport(100, 1, int2: 1, int5: int.parse(Constant.appVersion));
      }
      if (sdkVersionModel.version != null &&
          sdkVersionModel.version != -1 &&
          sdkVersionModel.version.toString() != sdkLocalModel.version) {
        String partition = sdkLocalModel.partition == 'a' ? 'b' : 'a';
        String path = await getFold('rn_plugins', 'sdk', partition);
        DownloadResult downloadResult = await ref
            .read(downLoadProvider.notifier)
            .startDownload(DownloadTask(
                immediate: true,
                url: sdkVersionModel.url,
                md5: sdkVersionModel.md5,
                type: RNSDK,
                cancelToken: _cachedCancelToken,
                checkFileName: 'sdk.bundle',
                targetPath: path,
                downloadCallback: (downloadResult) {
                  if (downloadResult.taskResultStatus == TaskResultStatus.downloading) {
                  }
                }));
        if (downloadResult.taskResultStatus == TaskResultStatus.success) {
          rnPluginUpdateModel.sdkModel = PluginLocalModel(
              type: RNSDK,
              version: sdkVersionModel.version.toString(),
              path: downloadResult.finalPath,
              partition: partition,
              md5: sdkVersionModel.md5);
          await ref
              .read(pluginLocalRepositoryProvider.notifier)
              .updateLocalInfo(RNSDK, sdkVersionModel.version.toString(),
                  downloadResult.finalPath!, partition,
                  md5: sdkVersionModel.md5);

          /// 清理下载的sdk资源
          if (downloadResult.tmpPath != null &&
              File(downloadResult.tmpPath!).existsSync()) {
            await File(downloadResult.tmpPath!).delete();
          }
        } else if (downloadResult.isError()) {
          LogModule().eventReport(100, 1,
              int1: sdkVersionModel.version ?? -1,
              pluginVer: int.parse(pluginLocalModel.version ?? '-1'),
              int2: downloadResult.taskResultStatus?.index ?? -1,
              int5: int.parse(Constant.appVersion));
          throw DreameException(downloadFail);
        }
      }
      return true;
    } catch (e) {
      LogUtils.e('SDK下载失败: $e');
      rethrow;
    }
  }

  /// 插件公版资源下载方法
  Future<bool> _downloadPluginResources(
      String model,
      String keyRes,
      PluginLocalModel pluginResLocalModel,
      RNVersionModel rnVersionModel,
      RNPluginUpdateModel rnPluginUpdateModel,
      PluginLocalModel sdkLocalModel) async {
    try {
      // 判断公版插件资源
      if (rnVersionModel.resPackageUrl != null &&
          rnVersionModel.resPackageUrl!.isNotEmpty &&
          rnVersionModel.resPackageZipMd5 != pluginResLocalModel.md5) {
        String partition = pluginResLocalModel.partition == 'a' ? 'b' : 'a';
        String path = await getFold('rn_plugins_res', model, partition);
        DownloadResult downloadResult = await ref
            .read(downLoadProvider.notifier)
            .startDownload(DownloadTask(
                type: RNPLUGINRES,
                url: rnVersionModel.resPackageUrl,
                md5: rnVersionModel.resPackageZipMd5,
                targetPath: path,
                cancelToken: _cachedCancelToken,
                downloadCallback: (downloadResult) {
                  if (downloadResult.taskResultStatus ==
                      TaskResultStatus.downloading) {
                    if (downloadResult.total > 0) {
                      int progress =
                          (downloadResult.current / downloadResult.total * 100)
                              .floor();
                      progress = (progress * 0.4).toInt();
                      if (state.progress != progress) {
                        state = state.copyWith(progress: progress);
                      }
                    }
                  }
                }));

        if (downloadResult.taskResultStatus == TaskResultStatus.success) {
          rnPluginUpdateModel.resModel = PluginLocalModel(
              type: keyRes,
              version: rnVersionModel.resPackageVersion.toString(),
              sourceCommonPluginVer:
                  rnVersionModel.sourceCommonPluginVer.toString(),
              path: downloadResult.finalPath,
              partition: partition,
              md5: rnVersionModel.resPackageZipMd5);
          await ref
              .read(pluginLocalRepositoryProvider.notifier)
              .updateLocalInfo(
                keyRes,
                rnVersionModel.resPackageVersion.toString(),
                downloadResult.finalPath!,
                partition,
                md5: rnVersionModel.resPackageZipMd5,
                sourceCommonPluginVer:
                    rnVersionModel.sourceCommonPluginVer.toString(),
              );
          // 清理下载的资源文件
          if (downloadResult.tmpPath != null &&
              File(downloadResult.tmpPath!).existsSync()) {
            await File(downloadResult.tmpPath!).delete();
          }
        } else if (downloadResult.isError()) {
          LogModule().eventReport(100, 2,
              pluginVer: rnVersionModel.version ?? -1,
              int1: int.parse(sdkLocalModel.version ?? '-1'),
              int2: 5,
              int5: int.parse(Constant.appVersion));
        }
      }
      return true;
    } catch (e) {
      LogUtils.e('插件资源下载失败: $e');
      rethrow;
    }
  }

  /// 插件下载方法
  Future<bool> _downloadPlugin(
      String model,
      String key,
      PluginLocalModel pluginLocalModel,
      RNVersionModel rnVersionModel,
      RNPluginUpdateModel rnPluginUpdateModel,
      PluginLocalModel sdkLocalModel,
      {int baseProgress = 0}) async {
    try {
      if (rnVersionModel.version != null &&
          rnVersionModel.version != -1 &&
          rnVersionModel.version.toString() != pluginLocalModel.version) {
        String partition = pluginLocalModel.partition == 'a' ? 'b' : 'a';
        String path = await getFold('rn_plugins', model, partition);
        DownloadResult downloadResult = await ref
            .read(downLoadProvider.notifier)
            .startDownload(DownloadTask(
                immediate: true,
                cancelToken: _cachedCancelToken,
                url: rnVersionModel.url,
                md5: rnVersionModel.md5,
                checkFileName:
                    'index.${Platform.isAndroid ? 'android' : 'ios'}.bundle',
                targetPath: path,
                downloadCallback: (downloadResult) {
                  if (downloadResult.taskResultStatus ==
                      TaskResultStatus.downloading) {
                    if (downloadResult.total > 0) {
                      int progress =
                          (downloadResult.current / downloadResult.total * 100)
                              .floor();
                      if (baseProgress != 0) {
                        progress = 40 + (progress * 0.6).toInt();
                      }
                      if (progress == 100) {
                        progress = 99;
                      }
                      if (state.progress != progress) {
                        state = state.copyWith(progress: progress);
                      }
                    }
                  }
                },
                type: model));
        if (downloadResult.taskResultStatus == TaskResultStatus.success) {
          rnPluginUpdateModel.pluginModel = PluginLocalModel(
              type: key,
              version: rnVersionModel.version.toString(),
              path: downloadResult.finalPath,
              partition: partition,
              md5: rnVersionModel.md5);
          await ref
              .read(pluginLocalRepositoryProvider.notifier)
              .updateLocalInfo(key, rnVersionModel.version.toString(),
                  downloadResult.finalPath!, partition,
                  md5: rnVersionModel.md5);
          // 清理下载的插件文件
          if (downloadResult.tmpPath != null) {
            await File(downloadResult.tmpPath!).delete();
          }
        } else if (downloadResult.isError()) {
          LogModule().eventReport(100, 2,
              pluginVer: rnVersionModel.version ?? -1,
              int1: int.parse(sdkLocalModel.version ?? '-1'),
              int2: downloadResult.taskResultStatus?.index ?? -1,
              int5: int.parse(Constant.appVersion));
          throw DreameException(downloadFail);
        }
      }
      return true;
    } catch (e) {
      LogUtils.e('插件下载失败: $e');
      rethrow;
    }
  }

  /// 插件资源和插件下载方法（组合方法）
  Future<bool> _downloadPluginAndResources(
      String model,
      String key,
      String keyRes,
      PluginLocalModel pluginLocalModel,
      PluginLocalModel pluginResLocalModel,
      PluginLocalModel sdkLocalModel,
      RNPluginUpdateModel rnPluginUpdateModel) async {
    try {
      RNVersionModel rnVersionModel =
          await ref.read(pluginRepositoryProvider.notifier).getRNPlugin(model);

      if (rnVersionModel.version == null || rnVersionModel.version == -1) {
        LogModule()
            .eventReport(100, 2, int2: 1, int5: int.parse(Constant.appVersion));
      }
      // 下载插件资源
      var progress = 0;
      if (rnVersionModel.resPackageUrl != null &&
          rnVersionModel.resPackageUrl!.isNotEmpty &&
          rnVersionModel.resPackageZipMd5 != pluginResLocalModel.md5) {
        await _downloadPluginResources(model, keyRes, pluginResLocalModel,
            rnVersionModel, rnPluginUpdateModel, sdkLocalModel);
        progress = 40;
      }
      // 下载插件
      await _downloadPlugin(model, key, pluginLocalModel, rnVersionModel,
          rnPluginUpdateModel, sdkLocalModel,
          baseProgress: progress);
      return true;
    } catch (e) {
      LogUtils.e('插件和资源下载失败: $e');
      rethrow;
    }
  }

  Future<RNPluginUpdateModel?> updateRNPlugin(String model,
      {required String tag, required UpdateCallback? updateCallback}) async {
    // 检查基于 model 的防重复机制
    if (!_trySetModelUpdating(model)) {
      LogUtils.w(
          'Plugin update for model $model is already in progress, skipping duplicate request');
      RNPluginUpdateModel rnLocalPluginUpdateModel = RNPluginUpdateModel(
          hasLocal: false, code: 0, model: model, progress: 0);
      //获取本地rn版本
      PluginLocalModel sdkLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(RNSDK);
      //获取本地插件版本
      String key = '${model}_$RNPLUGIN';
      PluginLocalModel pluginLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(key);
      //获取本地公版插件资源版本
      String keyRes = '${model}_res_$RNPLUGIN';
      PluginLocalModel pluginResLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(keyRes);

      rnLocalPluginUpdateModel.sdkModel = sdkLocalModel;
      rnLocalPluginUpdateModel.resModel = pluginResLocalModel;
      rnLocalPluginUpdateModel.pluginModel = pluginLocalModel;
      if (sdkLocalModel.path != null && pluginLocalModel.path != null) {
        rnLocalPluginUpdateModel.hasLocal = true;
        return rnLocalPluginUpdateModel;
      } else {
        // waitting

      }
    }
    var time = DateTime.now().millisecondsSinceEpoch;
    RNDebugPackages rnDebugPackages = await ref
        .read(developerModePageStateNotifierProvider.notifier)
        .getProjects();
    if (rnDebugPackages.enable &&
        rnDebugPackages.ip.isNotEmpty &&
        rnDebugPackages.projects != null) {
      Projects? project = rnDebugPackages.projects
          ?.firstWhereOrNull((p0) => p0.model == model && p0.selected == true);
      if (project?.packageName != null) {
        return RNPluginUpdateModel(
            model: model,
            ip: rnDebugPackages.ip,
            isDebug: true,
            debugUrl: 'projects/${project?.packageName}');
      }
    }
    RNPluginUpdateModel rnPluginUpdateModel = RNPluginUpdateModel(
        hasLocal: false, code: 0, model: model, progress: 0);
    try {
      //获取本地rn版本
      PluginLocalModel sdkLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(RNSDK);
      //获取本地插件版本
      String key = '${model}_$RNPLUGIN';
      PluginLocalModel pluginLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(key);
      //获取本地公版插件资源版本
      String keyRes = '${model}_res_$RNPLUGIN';
      PluginLocalModel pluginResLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(keyRes);

      List<Future> futures = [];

      // SDK下载任务
      futures.add(
          _downloadSDK(sdkLocalModel, pluginLocalModel, rnPluginUpdateModel));
      // 插件资源和插件下载任务
      futures.add(_downloadPluginAndResources(
          model,
          key,
          keyRes,
          pluginLocalModel,
          pluginResLocalModel,
          sdkLocalModel,
          rnPluginUpdateModel));

      Directory sdkDic =
          await sdkLocalModel.path?.getDirectory() ?? Directory('');
      if (!sdkDic.existsSync() ||
          sdkDic.listSync().firstWhereOrNull(
                  (element) => element.path.endsWith('.bundle')) ==
              null) {
        sdkLocalModel = PluginLocalModel();
      }

      Directory pluginDic =
          await pluginLocalModel.path?.getDirectory() ?? Directory('');
      if (!pluginDic.existsSync() ||
          pluginDic.listSync().firstWhereOrNull(
                  (element) => element.path.endsWith('.bundle')) ==
              null) {
        pluginLocalModel = PluginLocalModel();
      }

      rnPluginUpdateModel.sdkModel = sdkLocalModel;
      rnPluginUpdateModel.resModel = pluginResLocalModel;
      rnPluginUpdateModel.pluginModel = pluginLocalModel;

      if (sdkLocalModel.path != null && pluginLocalModel.path != null) {
        rnPluginUpdateModel.hasLocal = true;
        if (futures.isNotEmpty) {
          unawaited(Future.wait(futures).catchError((e){
            _clearModelUpdating(model); // 清除
          }));
        }
      } else {
        if (futures.isNotEmpty) {
          state = state.copyWith(progress: 0);
          updateCallback?.call(true);
          _cachedCancelToken = CancelToken();
          await Future.wait(futures);
          var nowTime = DateTime.now().millisecondsSinceEpoch;
          LogUtils.d('插件更新耗时:${(nowTime - time) / 1000}');

          state = state.copyWith(progress: 100);
          _clearModelUpdating(model); // 清除 model 更新状态
          updateCallback?.call(false);
          rnPluginUpdateModel.progress = 100;
        } else {
          rnPluginUpdateModel.code = incompatible;
        }
      }
      rnPluginUpdateModel.hide = false; // 简化逻辑，不再基于 tag 判断
      LogUtils.d('插件更新信息:${rnPluginUpdateModel.toString()}');
      return rnPluginUpdateModel;
    } catch (error) {
      LogUtils.e('插件更新失败:${error.toString()}');
      _clearModelUpdating(model); // 清除 model 更新状态
      if (error is DioException) {
        if (error.type == DioExceptionType.cancel) {
          throw Exception(error);
        }
        rnPluginUpdateModel.code = netError;
        return rnPluginUpdateModel;
      } else if (error is DreameException) {
        rnPluginUpdateModel.code = error.code;
        return rnPluginUpdateModel;
      }
    }
    return null;
  }

  Future<int> getCacheSize() async {
    Directory documentDirector = await getApplicationDocumentsDirectory();
    var commonPluginsdirector =
        Directory('${documentDirector.path}/rn_plugins');
    bool exists = await commonPluginsdirector.exists();
    if (exists == false) {
      return 0;
    }

    return commonPluginsdirector.getSize();
  }

  Future<void> clear() async {
    final keys = await LocalStorage().getKeys();
    keys.forEach((key) async {
      if (key.contains(RNPLUGIN) ||
          key.contains(RNSDK) ||
          key.contains(COMMONPLUGIN)) {
        await LocalStorage().remove(key);
      }
    });
    _lastCheckTimes.clear();
    _clearAllUpdatingStates(); // 清除所有更新状态
    Directory documentDirector = await getApplicationDocumentsDirectory();
    await clearCommonPlugin();
    var rnPluginsdirector = Directory('${documentDirector.path}/rn_plugins');
    bool rnexists = await rnPluginsdirector.exists();
    if (rnexists == true) {
      await rnPluginsdirector.delete(recursive: true);
    }
    var resPluginsDir = Directory('${documentDirector.path}/rn_plugins_res');
    if (await rnPluginsdirector.exists() == true) {
      await resPluginsDir.delete(recursive: true);
    }
    return;
  }

  /// 清理通用插件目录
  /// [type] 通用插件类型 为空-清理所有通用插件
  ///
  Future<void> clearCommonPlugin({String type = ''}) async {
    Directory documentDirector = await getApplicationDocumentsDirectory();
    var commonPluginsdirector =
        Directory('${documentDirector.path}/common_plugins');
    if (type.isNotEmpty) {
      commonPluginsdirector =
          Directory('${documentDirector.path}/common_plugins/$type');
    }
    bool exists = await commonPluginsdirector.exists();
    if (exists) {
      await commonPluginsdirector.delete(recursive: true);
    }
  }



  Future<void> updateCommonPlugin(
      PluginLocalModel pluginLocalModel, String pluginType, String key, String appVer,
      {bool sync = false}) async {
    // 检查基于 key 的防重复机制
    if (!_trySetModelUpdating(key)) {
      LogUtils.i(
          'Common plugin update for type $key is already in progress, skipping duplicate request');
      return;
    }

    try {
      RNVersionModel rnVersionModel = await ref
          .read(pluginRepositoryProvider.notifier)
          .getLatestCommonPluginInfo(pluginType, appVer);

      if (rnVersionModel.version.toString() != pluginLocalModel.version) {
        String partition = pluginLocalModel.partition == 'a' ? 'b' : 'a';
        String path = await getFold('common_plugins', pluginType, partition);

        final downloadNotifier = ref.read(downLoadProvider.notifier);
        final newTask = DownloadTask(
          url: rnVersionModel.url,
          md5: rnVersionModel.md5,
          type: pluginType,
          targetPath: path,
          downloadCallback: (downloadResult) async {
            if (downloadResult.taskResultStatus == TaskResultStatus.success) {
              if (downloadResult.finalPath != null &&
                  downloadResult.finalPath!.isNotEmpty) {
                await ref
                    .read(pluginLocalRepositoryProvider.notifier)
                    .updateLocalInfo(key, rnVersionModel.version.toString(),
                        downloadResult.finalPath!, partition);
                if (pluginType == CommonPluginType.mall.value) {
                  PluginLocalModel newModel = await ref
                      .read(pluginLocalRepositoryProvider.notifier)
                      .getLocalInfo(key);
                  LogUtils.d(
                      '[plugin_provider] latest version: ${newModel.version}, ${newModel.partition} after update');
                  // 商城升级完成
                  EventBusUtil.getInstance().fire(ForceUpdateMallEvent());
                }

                // 清理下载的缓存文件 *.zip
                if (downloadResult.tmpPath != null) {
                  final file = File(downloadResult.tmpPath!);
                  if (await file.exists()) {
                    await file.delete();
                    LogUtils.i(
                        '[plugin_provider] updateCommonPlugin File deleted: ${downloadResult.tmpPath}');
                  }
                }
              }
              _clearModelUpdating(key);
            } else if (downloadResult.isError()) {
              _clearModelUpdating(key);
            }
          },
        );
        if (sync) {
          await downloadNotifier.startDownload(newTask);
        } else {
          await downloadNotifier.addDownloadTask(newTask);
        }
      } else {
        _clearModelUpdating(key);
        LogUtils.d(
            '[plugin_provider] version type: $pluginType, key: $key, remote version: ${rnVersionModel.version}, local version: ${pluginLocalModel.version}');
      }
    } catch (e) {
      // 清除 pluginType 更新状态
      _clearModelUpdating(key);
      LogUtils.e('An error occurred: $e');
    }
  }

  


  Future<RNPluginUpdateModel?> updateSDKTestPlugin(
      {String pluginType = 'sdkDemo',
      String appVer = '1',
      String tag = '',
      String model = '',
      UpdateCallback? updateCallback}) async {
    RNPluginUpdateModel rnPluginUpdateModel =
        RNPluginUpdateModel(hasLocal: false, code: 0, model: model);
    try {
      //获取本地sdk版本
      PluginLocalModel sdkLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(RNSDK);
      //获取本地SDK测试插件版本
      String pluginKey = '$COMMONPLUGIN$pluginType';
      PluginLocalModel pluginLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(pluginKey);

      List<Future> futures = [];
      //判断sdk版本
      // SDK下载任务
      futures.add(
          _downloadSDK(sdkLocalModel, pluginLocalModel, rnPluginUpdateModel));
      // 插件资源和插件下载任务
      futures.add(Future.value(() async {
        // 获取远端SDK测试插件版本
        RNVersionModel rnVersionModel = await ref
            .read(pluginRepositoryProvider.notifier)
            .getLatestCommonPluginInfo(pluginType, appVer);
        if (rnVersionModel.version != null &&
            rnVersionModel.version != -1 &&
            rnVersionModel.version.toString() != pluginLocalModel.version) {
          String partition = pluginLocalModel.partition == 'a' ? 'b' : 'a';
          String path = await getFold('common_plugins', pluginType, partition);
          DownloadResult downloadResult = await ref
              .read(downLoadProvider.notifier)
              .startDownload(DownloadTask(
                immediate: true,
                type: pluginType,
                url: rnVersionModel.url,
                md5: rnVersionModel.md5,
                targetPath: path,
                cancelToken: _cachedCancelToken,
                downloadCallback: (downloadResult) {
                  if (downloadResult.taskResultStatus ==
                      TaskResultStatus.downloading) {
                    if (downloadResult.total > 0) {
                      int progress =
                          (downloadResult.current / downloadResult.total * 100)
                              .floor();
                      state = state.copyWith(progress: progress);
                    }
                  }
                },
              ));

          if (downloadResult.taskResultStatus == TaskResultStatus.success) {
            rnPluginUpdateModel.pluginModel = PluginLocalModel(
                type: pluginType,
                version: rnVersionModel.version.toString(),
                path: downloadResult.finalPath,
                partition: partition,
                md5: rnVersionModel.md5);
            await ref
                .read(pluginLocalRepositoryProvider.notifier)
                .updateLocalInfo(
                  pluginKey,
                  rnVersionModel.version.toString(),
                  downloadResult.finalPath!,
                  partition,
                  md5: rnVersionModel.md5,
                );
            // 清理下载的sdk资源
            if (downloadResult.tmpPath != null) {
              await File(downloadResult.tmpPath!).delete();
            }
          } else if (downloadResult.isError()) {
            throw DreameException(downloadFail);
          }
        }
        return true;
      }));

      Directory sdkDic =
          await sdkLocalModel.path?.getDirectory() ?? Directory('');
      if (!sdkDic.existsSync() ||
          sdkDic.listSync().firstWhereOrNull(
                  (element) => element.path.endsWith('.bundle')) ==
              null) {
        sdkLocalModel = PluginLocalModel();
      }

      Directory pluginDic =
          await pluginLocalModel.path?.getDirectory() ?? Directory('');
      if (!pluginDic.existsSync() ||
          pluginDic.listSync().firstWhereOrNull(
                  (element) => element.path.endsWith('.bundle')) ==
              null) {
        pluginLocalModel = PluginLocalModel();
      }
      rnPluginUpdateModel.sdkModel = sdkLocalModel;
      rnPluginUpdateModel.pluginModel = pluginLocalModel;

      if (sdkLocalModel.path != null && pluginLocalModel.path != null) {
        rnPluginUpdateModel.hasLocal = true;
        if (futures.isNotEmpty) {
          unawaited(Future.wait(futures));
        }
      } else {
        if (futures.isNotEmpty) {
          updateCallback?.call(true);
          _cachedCancelToken = CancelToken();
          await Future.wait(futures);
          rnPluginUpdateModel.progress = 100;
        } else {
          rnPluginUpdateModel.code = incompatible;
        }
      }
      rnPluginUpdateModel.hide = false; // 简化逻辑，不再基于 tag 判断
      LogUtils.d('插件更新信息:${rnPluginUpdateModel.toString()}');
      return rnPluginUpdateModel;
    } catch (error) {
      LogUtils.e('插件更新失败:${error.toString()}');
      if (error is DioException) {
        if (error.type == DioExceptionType.cancel) {
          throw Exception(error);
        }
        rnPluginUpdateModel.code = netError;
        return rnPluginUpdateModel;
      } else if (error is DreameException) {
        rnPluginUpdateModel.code = error.code;
        return rnPluginUpdateModel;
      }
    }
    // 注意：updateSDKTestPlugin 方法没有使用 model 参数，所以这里不需要清除 _updatingModels
    return null;
  }
}

extension CommonPlugin on Plugin {
  Future<void> checkMallUpdateIfNeeded({
    bool forceCheck = false,
    String? tabType,
  }) async {
    final type = tabType ?? 'mall';
    final now = DateTime.now();
    final lastCheckTime = _lastCheckTimes[type];
    // 如果状态显示需要更新，强制进行检查
    final shouldCheck = forceCheck ||
        lastCheckTime == null ||
        now.difference(lastCheckTime) >= _checkInterval;

    if (!shouldCheck) {
      LogUtils.d(
          '[plugin_provider] [$type] 距离上次检查时间未超过间隔，使用缓存结果 $lastCheckTime $_checkInterval');
      return;
    }

    LogUtils.d('[plugin_provider] [$type] 开始检查更新');
    _lastCheckTimes[type] = now;
    unawaited(getCommonPlugin(tabType ?? CommonPluginType.mall.value));
  }

  Future<PluginLocalModel> getCommonPlugin(String pluginType,
      {String appVer = ''}) async {
    String appVersion = appVer.isNotEmpty ? appVer : Constant.mallSdkVersion;
    String key = '$COMMONPLUGIN$pluginType';
    PluginLocalModel pluginLocalModel = await ref
        .read(pluginLocalRepositoryProvider.notifier)
        .getLocalInfo(key);
    if (pluginType == CommonPluginType.mall.value) {
      if (pluginLocalModel.path == null || pluginLocalModel.path!.isEmpty) {
        await LocalStorage().remove(key);
        await unzipLocalMall();
        //内置商城包版本已更新
        pluginLocalModel = await ref
            .read(pluginLocalRepositoryProvider.notifier)
            .getLocalInfo(key);
      }
    }
    await updateCommonPlugin(
      pluginLocalModel,
      pluginType,
      key,
      appVersion,
    );
    return pluginLocalModel;
  }

  Future<void> unzipLocalMall() async {
    return ref
        .read(mallPluginNotifierProvider.notifier)
        .unzipLocalMallAndSave();
  }

  /*  检查是否需要更新 (true:需要更新，false:不需要更新)*/
  Future<bool> checkMallNeedUpdate() async {
    RNVersionModel serverVersion = await ref
        .read(pluginRepositoryProvider.notifier)
        .getLatestCommonPluginInfo(
            CommonPluginType.mall.value, Constant.mallSdkVersion);
    int mallVersion = serverVersion.version ?? 0;
    final localVersion = await ref
        .read(pluginLocalRepositoryProvider.notifier)
        .getLocalInfo('$COMMONPLUGIN${CommonPluginType.mall.value}');
    LogUtils.i(
        '[plugin_provider] [checkMallNeedUpdate] @mallVersion: $mallVersion, local version: ${localVersion.version}');
    if (mallVersion > int.parse(localVersion.version ?? '0')) {
      return true;
    } else {
      return false;
    }
  }

  /* 更新商场插件*/
  Future<bool> updateMallForce() async {
    final type = CommonPluginType.mall.value;
    final now = DateTime.now();
    final lastCheckTime = _lastCheckTimes[type];
    // 如果状态显示需要更新，强制进行检查
    final shouldCheck = lastCheckTime == null || now.difference(lastCheckTime) >= _checkInterval;

    if (!shouldCheck) {
      LogUtils.d('[plugin_provider] [$type] 距离上次检查时间未超过间隔，使用缓存结果 $lastCheckTime $_checkInterval');
      return false;
    }

    LogUtils.d('[plugin_provider] [$type] 开始检查更新');
    _lastCheckTimes[type] = now;
    PluginLocalModel newLocalModel = await getMallCommonPlugin(sync: true);
    bool value = (newLocalModel.path != null || newLocalModel.path!.isNotEmpty) ? true : false;
    LogUtils.i('[plugin_provider] [updateMallForce] updateSuccess: $value');
    return value;
  }

  /* 仅处理商城通用插件*/
  Future<PluginLocalModel> getMallCommonPlugin({String appVer = '', bool sync = false}) async {
    String pluginType = CommonPluginType.mall.value;
    String key = '$COMMONPLUGIN$pluginType';
    PluginLocalModel pluginLocalModel = await ref
        .read(pluginLocalRepositoryProvider.notifier)
        .getLocalInfo(key);

    if (pluginLocalModel.path == null || pluginLocalModel.path!.isEmpty) {
      await LocalStorage().remove(key);
      await unzipLocalMall();
      //内置商城包版本已更新
      pluginLocalModel = await ref
          .read(pluginLocalRepositoryProvider.notifier)
          .getLocalInfo(key);
    }
    await updateCommonPlugin(pluginLocalModel, pluginType, key, Constant.mallSdkVersion,
        sync: sync);
    return pluginLocalModel;
  }
}

extension GetSizeAble on Directory {
  Future<int> getSize() async {
    int size = 0;
    await for (FileSystemEntity entity in list(recursive: false)) {
      if (entity is File) {
        size += await entity.length();
      } else if (entity is Directory) {
        size += await entity.getSize();
      }
    }
    return size;
  }
}
