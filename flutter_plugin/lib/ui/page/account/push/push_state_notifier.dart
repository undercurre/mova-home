import 'dart:io';

import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/ui/page/account/push/push_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'push_state_notifier.g.dart';

@riverpod
class PushStateNotifier extends _$PushStateNotifier {
  String deviceUUID = 'DEVICEUUID';

  @override
  String build() {
    return '';
  }

  /// 注册推送token
  Future<void> registerPushToken() async {
    final result = await AccountModule().getPushToken();
    if (Platform.isIOS) {
      if (result != null) {
        String token = result['token'] ?? '';
        String tokenType = result['tokenType'] ?? '';
        String deviceUUID = result['deviceUUID'] ?? '';
        await updatePushToken(token, deviceUUID, tokenType);
      }
    }
  }

  Future<bool> updatePushToken(
      String token, String deviceUUID, String tokenType) async {
    LogUtils.i(
        'updatePushToken token: $token, deviceUUID:$deviceUUID, tokenType:$tokenType');
    if (token.isEmpty) {
      return false;
    }
    if (deviceUUID.isEmpty) {
      deviceUUID = token;
    }
    state = deviceUUID;
    await LocalStorage().putString('deviceUUID', deviceUUID);
    LogUtils.i('getAuthBean---for----push_state_notifier.updatePushToken');
    final authBean = await AccountModule().getAuthBean();
    final req = {
      'key': deviceUUID,
      'os': Platform.isAndroid ? 'ANDROID' : 'IOS',
      'lang': await LocalModule().getLangTag(),
      'region': await LocalModule().serverSite(),
      'uid': authBean.uid,
      'loginStatus': LifeCycleManager().checkFirstLogin() ? 'login' : ''
    };
    LifeCycleManager().setFirstLogin(false);
    if (Platform.isAndroid) {
      if ('FCM'.toLowerCase() == tokenType.toLowerCase() ||
          'Umeng'.toLowerCase() == tokenType.toLowerCase()) {
        req['deviceToken'] = token;
      } else {
        req['manufacturer'] = tokenType;
        req['manuDeviceToken'] = token;
      }
    } else {
      req['deviceToken'] = token;
    }
    try {
      return await ref.watch(pushRepositoryProvider).registerPushToken(req);
    } catch (e) {
      return false;
    }
  }

  Future<bool> removePushToken() async {
    try {
      String uuid = await LocalStorage().getString('deviceUUID') ?? '';
      if (uuid.isEmpty) {
        return false;
      }
      final req = {'key': uuid};
      await ref.watch(pushRepositoryProvider).removePushToken(req);
      return true;
    } catch (e) {
      LogUtils.e('------------------ $e');
      return true;
    }
  }
}
