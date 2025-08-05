import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:flutter_plugin/utils/debounce_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:synchronized/synchronized.dart';

/*
https://pub.dev/packages/openinstall_flutter_plugin
https://www.openinstall.io/doc/plugins.html
https://www.openinstall.io/doc/
https://developer.openinstall.io/980262668/app-android
*/
Lock _lock = Lock();
mixin OpenInstallMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  late final OpeninstallFlutterPlugin _openinstallFlutterPlugin =
      OpeninstallFlutterPlugin();
  bool isMainPage = false;

  Future<void> openInstallinitSDK() async {
    return _lock.synchronized(() => _openInstallinitSDK());
  }

  Future<void> _openInstallinitSDK() async {
    LogUtils.i('[openinstallSDK] initPlatformState ');
    _openinstallFlutterPlugin.setDebug(kDebugMode);
    _openinstallFlutterPlugin.init(wakeupHandler, true);

    // 判断APP是首次安装，才会调用
    final flag = await getInstallFlag();
    if (!flag) {
      _openinstallFlutterPlugin.install(installHandler);
    }
  }

  Future installHandler(Map<String, Object> data) async {
    LogUtils.i('[openinstallSDK] installHandler: $data');
    try {
      dynamic bindData = data['bindData'];
      if (bindData == null) {
        // 参数没渠道
        LogUtils.e('[openinstallSDK] installHandler: bindData == null');
        return;
      }
      await putInstallFlag();
      String bindDataString = '';
      if (bindData is String) {
        bindDataString = bindData;
        LogUtils.i('[openinstallSDK] [is String ]: $bindDataString');
      } else if (bindData is Map) {
        // 如果是 Map，转成 JSON 字符串
        bindDataString = jsonEncode(bindData);
        LogUtils.i('[openinstallSDK] [is Map ]: $bindDataString');
      }
      await putInstallAppInfo(bindDataString);
      await reportData();
      LogUtils.i(
          '[openinstallSDK] installHandler bindDataString: $bindDataString');

      await handleMallScheme(bindDataString);

    } catch (e) {
      LogUtils.e('[openinstallSDK] installHandler error: $e');
      return;
    }
    LogUtils.i('[openinstallSDK] installHandler success');
  }

  Future<void> wakeupHandler(Map<String, Object> data) async {
    if (isMainPage) {
      DebounceUtils.debounce(
        key: 'wakeupHandler',
        callback: () async {
          await _debounceWakeupHandler(data);
        },
        duration: const Duration(milliseconds: 200),
      );
    } else {
      LogUtils.i('[openinstallSDK] wakeupHandler: isMainPage is false');
      await putWakeupData(data);
    }
  }

  // MainPage 显示时，主动处理所有缓存
  Future<void> processPendingWakeupDataIfNeeded() async {
    Map<String, dynamic> wakeupData = await getWakeupData();
    if (wakeupData.isNotEmpty) {
      await _processWakeupData(wakeupData);
      await clearWakeupData();
    }
  }

  Future<void> _processWakeupData(Map<String, dynamic> data) async {
    DebounceUtils.debounce(
      key: 'wakeupHandler',
      callback: () async {
        await _debounceWakeupHandler(data);
      },
      duration: const Duration(milliseconds: 200),
    );
  }

  Future<void> _debounceWakeupHandler(Map<String, dynamic> data) async {
    try {
      LogUtils.i('[openinstallSDK] wakeupHandler: $data');
      final bindDataString = data['bindData'] as String?;
      if (bindDataString == null) {
        // 参数没渠道
        LogUtils.e('[openinstallSDK] wakeupHandler: bindData == null');
        return;
      }
      await uploadOpenInstallData(ref, bindDataString);
      await handleMallScheme(bindDataString);
    } catch (e) {
      LogUtils.e('[openinstallSDK] wakeupHandler error: $e');
      return;
    }
  }

  /*
   * 注册统计
   * 如需统计每个渠道的注册量（对评估渠道质量很重要），可根据自身的业务规则，在确保用户完成 APP 注册的情况下调用此接口
   */
  Future reportRegister() async {
    await reportData();
    _openinstallFlutterPlugin.reportRegister();
  }

  Future<void> reportData() async {
    return await _lock.synchronized(() => _reportData());
  }

  Future<void> _reportData() async {
    try {
      LogUtils.i('[openinstallSDK] _reportData');
      String? bindDataString = await getInstallAppInfo();
      if (bindDataString == null || bindDataString.isEmpty) {
        LogUtils.e('[openinstallSDK] _reportData installInfo is empty');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      bool success = await uploadOpenInstallData(ref, bindDataString);
      if (success) {
        await clearInstallAppInfo();
      } else {
        // 尝试重试
      }
    } catch (e) {
      LogUtils.e('[openinstallSDK] _reportData error:$e');
    }
  }

  /*
   * 效果点统计
   * 效果点明细统计
   * 效果点建立在渠道基础之上，主要用来统计终端用户对某些特殊业务的使用效果。调用此接口时，请使用后台创建的 “效果点ID” 作为 pointId
   * Map<String, String> extraMap = {
      "key1": "value1",
      "key2": "value2"
      };
   */
  Future reportEffectPoint(String pointId, int pointValue, [Map<String, String>? extraMap]) async {
    LogUtils.i("reportEffectPoint: pointId:$pointId ,pointValue:$pointValue ,extraMap=$extraMap");
    return _openinstallFlutterPlugin.reportEffectPoint(pointId, pointValue, extraMap);
  }

  /*
   * 裂变分享上报
   * 分享上报主要是统计某个具体用户在某次分享中，分享给了哪个平台，再通过JS端绑定被分享的用户信息，进一步统计到被分享用户的激活回流等情况
   */
  Future reportShare(String shareCode, String platform) async {
    LogUtils.i("reportEffectPoint: shareCode:$shareCode ,platform:$platform");
    return _openinstallFlutterPlugin.reportShare(shareCode, platform);
  }

  /*
   * 上报到商城服务端
   */
  Future reportInfo2Mall(String myuid, Map<String, Object> data) async {
    LogUtils.i("reportEffectPoint: myuid:$myuid ,data:$data");
    // TODO
  }

  static String wakeupInfoKey = 'wakeupInfo';
  static String InvitedInfokey = 'invitedInfo';
  static String InstallStatuskey = 'InstallStatuskey';
  static String InvitedInfoFileName = 'invitedInfo_file';

  Future<void> putInstallFlag() async {
    await LocalStorage().putBool(
      fileName: InvitedInfoFileName,
      InstallStatuskey,
      true,
    );
    LogUtils.i('[openinstallSDK] putInstallFlag: true');
  }

  /* 只处理bindData 的东西*/
  Future<bool> getInstallFlag() async {
    final value = await LocalStorage().getBool(
          fileName: InvitedInfoFileName,
          InstallStatuskey,
        ) ??
        false;
    LogUtils.i('[openinstallSDK] getInstallFlag: value:$value');
    return value;
  }

  Future<void> putInstallAppInfo(String jsonString) async {
    String base64String = base64Encode(utf8.encode(jsonString));
    bool writeSuccess = await LocalStorage().putString(
      InvitedInfokey,
      base64String,
      fileName: InvitedInfoFileName,
    );
    LogUtils.i(
        '[openinstallSDK] putInstallAppInfo: writeSuccess is null or empty');
  }

  Future<void> putWakeupData(Map<String, Object> data) async {
    String jsonString = jsonEncode(data);
    String base64String = base64Encode(utf8.encode(jsonString));
    try {
      bool writeSuccess = await LocalStorage().putString(
        wakeupInfoKey,
        base64String,
        fileName: InvitedInfoFileName,
      );
      LogUtils.i(
          '[openinstallSDK] putWakeupData: writeSuccess is $writeSuccess');
    } catch (e) {
      LogUtils.e('[openinstallSDK] putWakeupData error: $e');
    }
  }

  Future<Map<String, dynamic>> getWakeupData() async {
    String? base64String = await LocalStorage().getString(
      wakeupInfoKey,
      fileName: InvitedInfoFileName,
    );

    if (base64String == null || base64String.isEmpty) {
      LogUtils.i(
          '[openinstallSDK] getWakeupData: base64String is null or empty');
      return {};
    }

    String decoded = utf8.decode(base64Decode(base64String));
    LogUtils.i('[openinstallSDK] getWakeupData: decoded is $decoded');
    try {
      Map<String, dynamic> jsonMap = json.decode(decoded) as Map<String, dynamic>;
      return jsonMap;
    } catch (e) {
      LogUtils.e('[openinstallSDK] getWakeupData error: $e');
      return {};
    }
  }

  Future<void> clearWakeupData() async {
    await LocalStorage().remove(fileName: InvitedInfoFileName, wakeupInfoKey);
    LogUtils.i('[openinstallSDK] clearWakeupData');
  }

  /* 只处理bindData 的东西*/
  Future<String?> getInstallAppInfo() async {
    try {
      String? cacheOpenInstallStr = await LocalStorage().getString(
        InvitedInfokey,
        fileName: InvitedInfoFileName,
      );
      if (cacheOpenInstallStr == null || cacheOpenInstallStr.isEmpty) {
        LogUtils.i('[openinstallSDK] getInstallAppInfo: cacheOpenInstallStr is null or empty');
        return null;
      }
      String decoded = utf8.decode(base64Decode(cacheOpenInstallStr));
      LogUtils.i('[openinstallSDK] getInstallAppInfo $decoded');
      return decoded;
    } catch (e) {
      LogUtils.i('[openinstallSDK] getInstallAppInfo error $e');
      return null;
    }
  }

  Future<void> clearInstallAppInfo() async {
    await LocalStorage().remove(fileName: InvitedInfoFileName, InvitedInfokey);
  }

  Future<bool> uploadOpenInstallData(
      WidgetRef ref, String paramsJsonStr) async {
    LogUtils.i(
        '[openinstallSDK] uploadOpenInstallData  paramsJsonStr: $paramsJsonStr');
    try {
      if (paramsJsonStr.isEmpty) return false;
      final dynamic decoded = jsonDecode(paramsJsonStr);
      if (decoded is! Map) {
        LogUtils.e('[[openinstallSDK]] paramsJsonStr is not a JSON object');
        return false;
      }
      final Map<String, dynamic> stringParams =
          Map<String, dynamic>.from(decoded);
      if (stringParams.isEmpty) return false;

      String userId = (await AccountModule().getUserInfo())?.uid ?? '';
      bool value = await ref
          .read(mainRepositoryProvider)
          .putAppMessageWithParams(userId, paramsJsonStr);

      return value;
    } catch (e) {
      LogUtils.e('[openinstallSDK] uploadOpenInstallData error $e');
      return false;
    }
  }

  Future<void> handleMallScheme(String bindDataString) async {
    LogUtils.i(
        '[openinstallSDK] handleMallScheme bindDataString: $bindDataString');
    if (bindDataString.isEmpty) {
      return;
    }
    final bindData = jsonDecode(bindDataString) as Map<String, dynamic>;
    dynamic params = bindData['openKey'];
    await openMallPage(params);

  }

  // 商城跳转页面
  Future<void> openMallPage(dynamic params) async {
    if (params == null || params.isEmpty) return;
    Map<String, dynamic>? data;
    if (params is String) {
      data = jsonDecode(params) as Map<String, dynamic>;
    } else if (params is Map) {
      data = params as Map<String, dynamic>;
    }

    LogUtils.i('[openinstallSDK] openMallPage data: $data');
    if (data == null || data.isEmpty) return;

    String? mallUrl = data['url'];

    bool needUpdateMall = await ref
        .read(pluginProvider.notifier)
        .checkMallNeedUpdate();
    if (needUpdateMall) {
      await ref.read(pluginProvider.notifier).updateMallForce();
    }
    if (mallUrl == null || mallUrl.isEmpty) return;

    /**
     *  {
        "url":"pagesA/goodsDetail/goodsDetail?gid=40"
        }
     */

    String type = data['scheme_type'] ?? 'MALL';
    Map<String, String> extMap = {
      'url': mallUrl,
    };
    // 将 Map 转换为 JSON 字符串
    String jsonString = jsonEncode(extMap);
    Future.delayed(const Duration(milliseconds: 1500), () async {
      // 延迟执行，商城要下载完成后解压
      await openMallPageWithScheme(type, jsonString);
    });
  }

  Future<void> openMallPageWithScheme(String type, String jsonString) async {

    LogUtils.i('[openinstallSDK] openMallPage jsonString: $jsonString');
    ref
        .read(schemeHandleNotifierProvider.notifier)
        .updateSchemeData(type, jsonString);
  }

}
