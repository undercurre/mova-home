import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/feature_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/providers/dio_provider.dart';
import 'package:flutter_plugin/ui/page/home/device_status/key_define_provider.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/string_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

class HomeLocalRepository {
  final HomeLocalRepositoryRef ref;

  HomeLocalRepository(this.ref);

  /// 获取保存到手机存储的keydefine
  Future<Map> readCachedKeyDefine(BaseDeviceModel deviceBean) async {
    File cachedKeyDefine =
        await getKeyDefineFilePath(deviceBean.model).getFile();
    if (cachedKeyDefine.existsSync()) {
      String keyDefineStr = cachedKeyDefine.readAsStringSync();
      return json.decode(keyDefineStr);
    }
    return {};
  }

  /// 读取asset下的keydefine文件
  Future<Map> readLocalKeyDefine(BaseDeviceModel deviceBean) async {
    String localKeyDefineStr = '';
    String modelDefault = '';
    if (deviceBean.deviceType() == DeviceType.vacuum) {
      localKeyDefineStr = await rootBundle
          .loadString('assets/home_device/common_device_protocol.json');
      modelDefault = 'vacuum';
    } else if (deviceBean.deviceType() == DeviceType.hold) {
      localKeyDefineStr = await rootBundle
          .loadString('assets/home_device/common_hold_protocol.json');
      modelDefault = 'hold';
    } else if (deviceBean.deviceType() == DeviceType.mower) {
      localKeyDefineStr = await rootBundle
          .loadString('assets/home_device/common_mower_protocol.json');
      modelDefault = 'mower';
    } else if (deviceBean.deviceType() == DeviceType.feeder) {
      localKeyDefineStr = await rootBundle
          .loadString('assets/home_device/fooder_protocol.json');
      modelDefault = 'feeder';
    }
    String assetLocalFileStr = getKeyDefineFilePath(modelDefault);
    File assetLocalFile = await assetLocalFileStr.getFile();
    String assetLocalStr =
        assetLocalFile.existsSync() ? assetLocalFile.readAsStringSync() : '';
    if (localKeyDefineStr != assetLocalStr) {
      assetLocalFile.writeAsStringSync(localKeyDefineStr);
      await FeatureModule().updateWorkStatusPath(deviceBean.model,
          Platform.isIOS ? assetLocalFileStr : assetLocalFile.path);
    }
    return localKeyDefineStr.isNotEmpty
        ? json.decode(localKeyDefineStr) as Map
        : {};
  }

  String getKeyDefineFilePath(String model) {
    return '/${model}_keydefine.json';
  }

  Future<Map> getKeyDefine(BaseDeviceModel deviceBean) async {
    Map keyDefine = await readCachedKeyDefine(deviceBean);
    if (keyDefine.isEmpty || deviceBean.keyDefine == null) {
      keyDefine = await readLocalKeyDefine(deviceBean);
    }
    return keyDefine;
  }

  Future<void> updateKeyDefine(List<BaseDeviceModel> list) async {
    for (var deviceBean in list) {
      try {
        if (deviceBean.keyDefine != null &&
            deviceBean.keyDefine!.url.isNotEmpty) {
          String version = await ref
              .read(keyDefineProvider.notifier)
              .getLatestVersion(deviceBean.model);
          if (deviceBean.keyDefine!.ver.toString() != version) {
            Response response =
                await ref.watch(dioProvider).get(deviceBean.keyDefine!.url);
            if (response.data != null && response.statusCode == 200) {
              unawaited(ref
                  .read(keyDefineProvider.notifier)
                  .batch(jsonEncode(response.data), model: deviceBean.model)
                  .catchError((e) {
                LogUtils.e('[HomeLocalRepository] updateKeyDefine.batch: error:$e');
              }));
            }
          }
        }
      } catch (e) {
        LogUtils.e('[HomeLocalRepository] updateKeyDefine: error:$e');
      }
    }
  }

  /// 获取上次打开的tab
  Future<String?> getLastTabDid() async {
    final account = await AccountModule().getAuthBean();
    final region = await LocalModule().getCountryCode();
    return await LocalStorage().getString('${account.uid}_${region}_lastDid');
  }

  /// 更新上次打开的tab
  Future<void> updateLastTabDid(String did) async {
    final account = await AccountModule().getAuthBean();
    final region = await LocalModule().getCountryCode();
    await LocalStorage().putString('${account.uid}_${region}_lastDid', did);
  }

  /// 缓存的设备
  Future<List<DeviceModel>> readCachedDevice() async {
    final account = await AccountModule().getAuthBean();
    final region = await LocalModule().getCountryCode();
    String json =
        await LocalStorage().getString('${account.uid}_${region}_devices_v1') ??
            '';
    if (json.isNotEmpty) {
      return (jsonDecode(json) as List).map((e) {
        final device = DeviceModel.fromJson(e);
        device.isLocalCache = true;
        device.online = false;
        device.latestStatus = -1;
        device.latestStatusStr = '';
        device.battery = -1;
        device.lastWill = '';
        return device;
      }).toList();
    }
    return [];
  }

  /// 更新缓存的设备
  Future<void> updateCacheDevice(List<BaseDeviceModel> list) async {
    final account = await AccountModule().getAuthBean();
    final region = await LocalModule().getCountryCode();
    await LocalStorage().putString(
        '${account.uid}_${region}_devices_v1',
        jsonEncode(list.map((e) {
          final device = DeviceModel(
            did: e.did,
            model: e.model,
            ver: e.ver,
            customName: e.customName,
            property: e.property ?? '',
            master: e.master,
            masterUid: e.masterUid,
            masterName: e.masterName,
            latestStatusStr: '',
            latestStatus: e.latestStatus,
            permissions: e.permissions,
            bindDomain: e.bindDomain,
            sharedStatus: e.sharedStatus,
            lang: e.lang,
            deviceInfo: e.deviceInfo,
            online: e.online,
            battery: e.battery,
            lastWill: e.lastWill,
            keyDefine: e.keyDefine,
            btnMode: e.btnMode,
            commonBtnProtol: e.commonBtnProtol,
          );
          device.isLocalCache = true;
          if (e is VacuumDeviceModel) {
            device.monitorStatus = e.monitorStatus;
            device.cleanArea = e.cleanArea;
            device.cleanTime = e.cleanTime;
            device.fastCommandList = e.fastCommandList;
            device.featureCode = e.featureCode;
            device.featureCode2 = e.featureCode2;
          }
          return device.toJson();
        }).toList()));
  }
}

@riverpod
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository(ref);
}
