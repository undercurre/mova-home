import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_mqtt/dreame_flutter_base_mqtt.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/network/http/network_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';

// ignore: depend_on_referenced_packages
import 'package:synchronized/synchronized.dart';

class MqttConnector {
  factory MqttConnector() => _instance;

  static final MqttConnector _instance = MqttConnector._internal();

  final Lock _lock = Lock();

  MqttConnector._internal();

  void init() {
    DMMqttManager().addMqttStateChangeCallback((state) {
      LogUtils.i('MqttConnector addMqttStateChangeCallback ,hashCode:${hashCode} 连接状态: $state');
    });
    DMMqttManager().setWillRawMessageCallback((topic, payload) {
      MessageChannel().mqttWillMsgArrived(topic, payload);
    });
    DMMqttManager().setDeviceRawMessageCallback((topic, payload) {
      MessageChannel().mqttMsgArrived(topic, payload);
    });
    DMMqttManager().addConnectErrorCallback((exception) async {
      LogUtils.e('MqttConnector addConnectErrorCallback ,hashCode:${hashCode} 连接异常: $exception');
      if (exception.toString().isNotEmpty) {
        LogModule().eventReport(100, 8, rawStr: exception.toString());
      }
      if (exception is DMMqttDnsException) {
        changeMqttHost();
      } else if (exception is DMMqttMaxAttemptsException) {
        // 连接失败次数过多，断开连接并重新创建连接
        disconnect();
        // 重新创建连接
        await reCreateClient();
        // 重新连接
        await connect();
      } else if (exception is DMMqttCreateException) {
        // 基本不会报错
        Future.delayed(const Duration(seconds: 5), () async {
          await connect();
        });
      }
    });
    DMMqttManager().setUploadLogCallback((id) {
      unawaited(LogModule().uploadLog(id));
    });
    DMMqttManager().setMultiLoginCallback((key) {
      MessageChannel().checkAppLogin(key);
      LogUtils.i('[MqttConnector] setMultiLoginCallback key: $key ,hashCode:${hashCode}');
    });
  }

  // 连接状态
  MqttConnectionState get connectionState => DMMqttManager().connectionState;

  void setPropChangeCallback(MqttDevicePropChangeCallback callback) {
    DMMqttManager().setDevicePropChangeCallback(callback);
  }

  void setWillMessageCallback(MqttWillMessageCallback callback) {
    DMMqttManager().setWillMessageCallback(callback);
  }

  void setVideoCallCallback(MqttVideoCallCallback callback) {
    DMMqttManager().setVideoCallCallback(callback);
  }

  void setAppMessageCallback(MqttAppMessageCallback callback) {
    DMMqttManager().setAppMessageCallback(callback);
  }

  void addConnectErrorCallback(MqttConnectErrorCallback callback) {
    DMMqttManager().addConnectErrorCallback(callback);
  }

  /// 初始化mqtt客户端
  Future<void> initMqttClient() async {
    return await _lock.synchronized(() => _initMqttClient());
  }

  bool isMqttInit() {
    return DMMqttManager().mqttClient != null;
  }

  Future<void> _initMqttClient() async {
    final account = await AccountModule().getAuthBean();
    if (account == OAuthModel.EMPTY_BEAN) return;
    final clientId = await DMMqttUtil.createMqttClientId(account.uid!);
    LogUtils.i(
        '[MqttConnector] _initMqttClient clientId：$clientId ,hashCode:${hashCode}');
    await DMMqttManager().initMqttClient(DMMqttConfig(
      clientConfig: MqttClientConfig(
        serverConfig: () async {
          var config = await getServerUri();
          return ServerConfig(host: config.first, port: config.second);
        },
        clientId: clientId,
        authConfig: () async {
          final account = await AccountModule().getAuthBean();
          return AuthConfig(
            username: account.uid ?? '',
            password: account.accessToken ?? '',
            tokenExpiredTime: (account.t ?? 0) + (account.expires_in ?? 0),
          );
        },
      ),
      accountVerify: () async {
        final account = await AccountModule().getAuthBean();
        return account.accessToken != null && account.accessToken!.isNotEmpty;
      },
      appTopic: () async {
        final account = await AccountModule().getAuthBean();
        return DMMqttUtil.createAppTopic(account.uid ?? '');
      },
    )..logPrinter = MqttLogPrinter());
  }

  /// 添加设备topic
  Future<void> addDeviceTopics(List<BaseDeviceModel> deviceList) async {
    try {
      await _addDeviceTopics(deviceList);
    } catch (e) {
      LogUtils.e('MqttConnector addDeviceTopics ,hashCode:${hashCode} ,error: $e');
    }
  }

  Future<void> _addDeviceTopics(List<BaseDeviceModel> deviceList) async {
    List<String> topicList = [];
    String region = await LocalModule().serverSite();
    for (var device in deviceList) {
      var deviceTopic = DMMqttUtil.createDeviceTopic(
          device.did, device.masterUid ?? '', device.model, region);
      topicList.add(deviceTopic);
      if (device.supportLastWill()) {
        final willsTopic = DMMqttUtil.createDeviceWillsTopic(device.did);
        topicList.add(willsTopic);
      }
    }
    return DMMqttManager().addTopic(topicList);
  }

  FutureOr<void> changeMqttHost() async {
    if (!MqttConnector().checkConnect()) {
      var serverConfig =
          await DMMqttManager().config.clientConfig.serverConfig();
      final mqttHost = serverConfig.host;
      var newHost = await NetworkUtil().dnsRequest(mqttHost);
      if (newHost.isNotEmpty) {
        DMMqttManager().config.clientConfig.serverConfig = () async {
          return ServerConfig(host: newHost, port: serverConfig.port);
        };
        await reCreateClient();
        await connect();
      }
    }
  }

  /// 重新创建mqtt连接
  Future<void> reCreateClient() => DMMqttManager().reCreateClient();

  /// 连接mqtt
  Future<void> connect() async {
    if (isMqttInit()) {
      try {
        return DMMqttManager().connect();
      } catch (e) {
        LogUtils.e('[MqttConnector] connect ,hashCode:${hashCode} ,error:$e');
      }
    }
  }

  /// 断开mqtt连接
  void disconnect() => DMMqttManager().disconnect();

  void dispose() => DMMqttManager().dispose();

  /// 移除设备topic
  Future<void> removeDevice(BaseDeviceModel device) async {
    List<String> topicList = [];
    final deviceTopic = DMMqttUtil.createDeviceTopic(device.did,
        device.masterUid ?? '', device.model, await LocalModule().serverSite());
    topicList.add(deviceTopic);
    if (device.supportLastWill()) {
      final willsTopic = DMMqttUtil.createDeviceWillsTopic(device.did);
      topicList.add(willsTopic);
    }
    return DMMqttManager().removeTopic(topicList);
  }

  /// 获取mqtt连接状态
  bool checkConnect() => DMMqttManager().checkConnect();

  /// 获取mqtt服务器地址
  Future<Pair<String, int>> getServerUri() async {
    String region = await LocalModule().serverSite();
    String host = await InfoModule().getUriHost();
    if (host.contains('uat.iot.mova-tech.com')) {
      return Pair('uatapp.mt.$region.iot.mova-tech.com', 31883);
    } else if (host.contains('dev.iot.mova-tech.com')) {
      return Pair('devapp.mt.$region.iot.mova-tech.com', 31883);
    } else if (host.contains('cn-pre.iot.mova-tech.com')) {
      return Pair('preapp.mt.cn.iot.mova-tech.com', 19974);
    } else {
      return Pair('app.mt.$region.iot.mova-tech.com', 19974);
    }
  }
}

class MqttLogPrinter extends LogPrinter {
  @override
  void debug(String message) {
    LogUtils.d(message);
  }

  @override
  void error(String message) {
    LogUtils.e(message);
  }

  @override
  void info(String message) {
    LogUtils.i(message);
  }
}
