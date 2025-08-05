import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/common/network/http/network_util.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/model/key_value_model.dart';
import 'package:flutter_plugin/ui/page/account/push/push_state_notifier.dart';
import 'package:flutter_plugin/ui/page/help_center/zendesk/zendesk_config.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_local_repository.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/settings_repository.dart';
import 'package:flutter_plugin/utils/burial_point_util.dart';
import 'package:flutter_plugin/utils/debounce_utils.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageChannel {
  MessageChannel._internal();

  factory MessageChannel() => _instance;
  static final MessageChannel _instance = MessageChannel._internal();
  final _appMessageChannel = const BasicMessageChannel(
      'com.dreame.flutter/message_channel', StandardMessageCodec());

  void attach(WidgetRef ref) {
    _appMessageChannel.setMessageHandler((message) async {
      if (message is Map) {
        String eventName = message['eventName'];
        Map<Object?, Object?>? ext = message['ext'];
        LogUtils.i('MessageChannel eventName: $eventName, ext: $ext');
        switch (eventName) {
          case 'checkMqttConnect':
            return MqttConnector().checkConnect();
          case 'checkAndConnectMqtt':
            DebounceUtils.debounce(
                duration: const Duration(microseconds: 3),
                key: 'checkAndConnectMqtt',
                callback: () async {
                  unawaited(MqttConnector().connect());
                });
            return true;
          case 'getDeviceList':
            return jsonEncode(ref.read(homeStateNotifierProvider).deviceList);
          case 'refreshPushToken':
            if (ext != null) {
              String token = ext['token'] as String? ?? '';
              String tokenType = ext['tokenType'] as String? ?? '';
              String deviceUUID = ext['deviceUUID'] as String? ?? '';
              await ref
                  .read(pushStateNotifierProvider.notifier)
                  .updatePushToken(token, deviceUUID, tokenType);
            }
            break;
          case 'updateDeviceName':
            if (ext != null) {
              String did = ext['did'] as String? ?? '';
              String deviceName = ext['deviceName'] as String? ?? '';
              ref
                  .read(homeStateNotifierProvider.notifier)
                  .updateDeviceName(did, deviceName);
            }
            break;
          case 'refreshDeviceList':
            await ref
                .read(homeStateNotifierProvider.notifier)
                .refreshDevice(slience: true);
            break;
          case 'updateDeviceStatus':
            String did = ext?['did'] as String? ?? '';
            List status = ext?['status'] as List<dynamic>? ?? [];
            debugPrint('updateDeviceStatus did: $did, status: $status');
            break;
          case 'handleSchemeEvent':
            if (ext != null) {
              String type = ext['type'] as String;
              String extra = ext['extra'] as String;
              LogUtils.i('[Scheme] MessageChannel setMessageHandler type: $type, extra: $extra');
              ref
                  .read(schemeHandleNotifierProvider.notifier)
                  .updateSchemeData(type, extra);
            }
            break;
          case 'getCommonPlugin':
            String pluginType = ext?['pluginType'] as String? ?? '';
            String path =
                '${await (await ref.read(pluginProvider.notifier).getCommonPlugin(pluginType)).getPath()}/index.html';
            return Platform.isAndroid ? 'file:///$path' : path;
          case 'resetApp':
            await ref.read(appConfigProvider.notifier).resetApp();
            break;
          case 'proactivelyDisconnect':
            LogUtils.i('--[message_channel.dart]-- attach 接收原生连接AP网络事件 - $ref');
            NetworkUtil().cancelRequest();
            await BurialPointUtil().disableUpload();
            break;
          case 'restoreNetworkConnectivity':
            LogUtils.i(
                '--[message_channel.dart]-- attach 接收原生断开连接AP网络事件 - $ref');
            await BurialPointUtil().enableUpload();
            break;
          case 'devicePairSuccess':
            await ref
                .read(homeStateNotifierProvider.notifier)
                .pairOrDeleteDevice();
            LogUtils.i('--[message_channel.dart]-- attach 接收原生配网成功事件 - $ref');
            break;
          case 'openPlugin':
            // App 打开插件
            final entranceType = ext?['entranceType'] as String? ?? 'main';
            final did = ext?['did'] as String? ?? '';
            final model = ext?['model'] as String? ?? '';
            final selectTargetItem = ext?['selectTargetItem'] as String? ?? '';
            if (ref.exists(homeStateNotifierProvider)) {
              final isDidExist = ref
                  .read(homeStateNotifierProvider.notifier)
                  .getDeviceByDid(did, model);
              if (isDidExist == true) {
                await _openPluginByDid(ref, did, model, entranceType);
                _jump2TargetDevice(ref, did, model, selectTargetItem);
              } else {
                // 先查询,再打开插件
                await ref
                    .read(homeStateNotifierProvider.notifier)
                    .pairOrDeleteDevice()
                    .then((_) async {
                  await _openPluginByDid(ref, did, model, entranceType);
                  _jump2TargetDevice(ref, did, model, selectTargetItem);
                });
              }
            }
            LogUtils.i(
                '--[message_channel.dart]-- attach 接收原生打开插件事件 - did:$did ,model:$model ,ref:$ref');
            break;
          case 'deleteDevice':
            String did = ext?['did'] as String? ?? '';
            debugPrint('deleteDevice did: $did');
            await ref
                .read(homeStateNotifierProvider.notifier)
                .pairOrDeleteDevice();
            break;
          case 'readShareMessage':
            ref.read(homeStateNotifierProvider.notifier).refreshMsgCount();
          case 'tokenExpired':
            AccountModule().clearAuthBean();
            AccountModule().clearUserInfo();
            break;
          case 'refreshTokenSuccess':
            await AccountModule().getAuthBean(forceSync: true);
            await MqttConnector().connect();
            break;

          case 'getZendeskKey':
            return getZendeskConfig(ref);
          case 'dnsRequest':

            ///FIXME: 未实现
            ///FIXME: 未实现
            ///FIXME: 未实现
            // String host = ext?['host'] as String? ?? '';
            // return await NetworkUtil().dnsRequest(host);
            throw Exception("未实现");
          case 'getCachedDns':

            ///FIXME: 未实现
            ///FIXME: 未实现
            ///FIXME: 未实现
            // String host = ext?['host'] as String? ?? '';
            // return NetworkUtil().getCachedDns(host);
            throw Exception("未实现");
          case 'cleanCachedDns':
            // String host = ext?['host'] as String? ?? '';
            // NetworkUtil().cleanCachedDns(host);
            throw Exception("未实现");
          case 'onAppEnterBackground':
            EventBusUtil.getInstance().fire(AppEnterBackgroundEvent());
            break;
          case 'onAppEnterForeground':
            EventBusUtil.getInstance().fire(AppEnterForegroundEvent());
            break;
          case 'onBackHome':
            unawaited(
                ref.read(homeStateNotifierProvider.notifier).onAppResume());
            break;
          case 'getAppSourceConfig':
            String type = CommonPluginType.appSource.value;
            try {
              List<KVModel> data = await ref
                  .read(settingsRepositoryProvider)
                  .getUserConfigSetting([type]);
              for (var element in data) {
                if (element.key == type) {
                  return element.value as bool;
                }
              }
            } catch (error) {
              LogUtils.e('getUserConfig error: $error');
              return false;
            }
            break;
          case 'appDestory':
            EventBusUtil.getInstance().fire(AppDestoryEvent());
            break;
          // 深色模式和亮色模式切换
          case 'changeAppTheme':
            //
            if (ext != null) {
              String themeMode = ext['themeMode'] as String? ?? '';
              await ref
                  .read(appThemeStateNotifierProvider.notifier)
                  .changeAppTheme(themeMode);
            }
            break;
          case 'getCachedProtocolData':
            String did = ext?['did'] as String? ?? '';
            return ref
                .read(homeStateNotifierProvider.notifier)
                .getCachedProtocolData(did);
          case 'oniOSBackground15s':
            MqttConnector().disconnect();
            break;
          default:
        }
      } else {
        debugPrint('MessageChannel message error: $message');
      }
      return true;
    });
  }

  Future<void> _openPluginByDid(
          WidgetRef ref, String did, String model, String entranceType) =>
      ref
          .read(homeStateNotifierProvider.notifier)
          .openPluginByDid(did, model, entranceType);

  /// 发送事件->原生
  Future<void> _sendMessage(String eventName, {dynamic ext}) async {
    try {
      await _appMessageChannel.send({'eventName': eventName, 'ext': ext});
    } catch (e) {
      LogUtils.e(
          '[MessageChannel] _sendMessage eventName:$eventName ,ext:$ext');
    }
  }

  /// 电话接听弹窗
  void showVideoCall(String deviceJson) {
    _sendMessage('showVideoCall', ext: deviceJson);
  }

  /// 多设备登录校验
  void checkAppLogin(String key) {
    _sendMessage('checkAppLogin', ext: {'key': key});
  }

  /// 获取Zendesk配置 (key,params)
  Future<Map<String, dynamic>> getZendeskConfig(WidgetRef ref) async {
    final deviceList =
        ref.read(homeStateNotifierProvider.select((value) => value.deviceList));
    final paramMaps = await ZendeskConfigManager.instance
        .getZendeskConfigWithList(deviceList);
    return paramMaps;
  }

  /// 显示设备分享弹窗
  void showShareDialog(
      String deviceName,
      String title,
      String img,
      String messageId,
      int ackResult,
      String did,
      String model,
      String ownUid) {
    _sendMessage('showShareDialog', ext: {
      'deviceName': deviceName,
      'content': title,
      'imageUrl': img,
      'messageId': messageId,
      'ackResult': ackResult,
      'did': did,
      'model': model,
      'ownUid': ownUid
    });
  }

  /// mqtt收到消息
  void mqttMsgArrived(String topic, String payload) {
    _sendMessage('mqttMsgArrived', ext: {'topic': topic, 'payload': payload});
  }

  /// mqtt收到遗嘱消息
  void mqttWillMsgArrived(String topic, String payload) {
    _sendMessage('mqttWillMsgArrived',
        ext: {'topic': topic, 'payload': payload});
  }

  /// 更新所有小组件状态
  void updateAllAppWidget(String deviceListJson) {
    _sendMessage('updateAllAppWidget', ext: deviceListJson);
  }

  /// 更新小组件状态
  void updateAppWidget(String deviceJson) {
    _sendMessage('updateAppWidget', ext: deviceJson);
  }

  /// 删除设备,小组件解除关联
  void deleteDevice(String did) {
    _sendMessage('deleteDevice', ext: did);
  }

  /// 切换语言
  Future<void> changeLanguage(String languageTag) async {
    await _sendMessage('changeLanguage', ext: {'languageTag': languageTag});
  }

  /// 切换地区
  void changeCountry(String countryCode) {
    _sendMessage('changeCountry', ext: {'countryCode': countryCode});
  }

  /// 路由是否可以返回变化
  void navCanBack(bool canBack) {
    _sendMessage('navCanBack', ext: canBack);
  }

  void updateAppSourceConfig(bool isOn) {
    _sendMessage('updateAppSourceConfig', ext: isOn);
  }

  void _jump2TargetDevice(
      WidgetRef ref, String did, String model, String selectTargetItem) {
    if (selectTargetItem == 'true') {
      ref.read(homeStateNotifierProvider.notifier).jumpToDeviceTab(did, model);
    }
  }
  
}
