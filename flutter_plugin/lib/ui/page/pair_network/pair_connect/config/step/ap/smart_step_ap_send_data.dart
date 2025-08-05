import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/vacuum_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_config.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/smart_step_event.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/ap/smart_step_ap_manual_connect.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/config/step/smart_step_check_pair.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wifi_iot/wifi_iot.dart';

///  需求：https://jira.dreame.tech/browse/VERR2338-59
///  [https://dreametech.feishu.cn/docx/Gxuld1sHBoUzt6xu8P2cbNBFn0c?from=from_copylink]
///  enum PAIR_FAIL_CODE {
///     CODE_NONE      = 0,    // 未记录原因
///     CODE_PAIRED    = 1,    // 已配网成功
///     CODE_UNBURN    = 2,    // 未烧号
///     CODE_WHITELIST = 3,    // 未加白名单
///     CODE_NETWORK   = 4,    // 外网不通而访问不到服务器
///     CODE_EMQ_LINE  = 5,    // 外网通但访问不到服务器
///     CODE_MQTT_404  = 404,  // 其他MQTT原因
///
///     CODE_WRONG_PASSWD = 101,  // 密码错误
///     CODE_SSID_UNFOUND = 102,  // 未扫描到SSID
///     CODE_NO_IP        = 103,  // 未分配到IP
///     CODE_WIFI_404     = 120,  // 其他无法连接路由器情况
/// };
///

enum ApSendDataStep {
  idle,
  lastFailCode,
  lastFailLog,
  connecting,
  querySuccess,
  settingSuccess,
  finish,
}

typedef FailCodeCallBack = void Function(int code, {String? logPath});

class SmartStepApSendData extends SmartStepConfig {
  @override
  StepId get stepId => StepId.STEP_AP_SEND_DATA;

  final int ap_port = 44321;
  final String ap_host = '192.168.5.1';
  final int re_create_socket_max = 5;
  RawDatagramSocket? _socket;
  RawDatagramSocket? _failLogSocket;
  StreamSubscription? _logSubscription;
  StreamSubscription? _pairSubscription;
  ApSendDataStep _sendStep = ApSendDataStep.idle;
  File? _logFile;
  Timer? _timer;
  late Uint8List buffer = Uint8List(64 * 1024);
  late final VacuumSendDataParam _sendDataParam = VacuumSendDataParam();
  String? deviceId;
  late int _retryCount = 0;

  @override
  Future<void> handleMessage(msg) async {
    if (msg.what == WHAT_PINCODE_INPUT) {
      final pinCode = msg.obj as String?;
      if (pinCode != null) {
        await sendBleData(arguments: {'pcode': pinCode});
      }
    }
  }

  @override
  Future<void> stepCreate() async {
    _retryCount = 0;
    postEvent(
        SmartStepEvent(StepName.STEP_TRANSFORM, status: SmartStepStatus.start));

    /// 读取last_fail_code, 判断是否需要读取last_fail_log
    try {
      final lastFailLog = await fetchLastFailLog();
      final code = lastFailLog.first;
      final logPath = lastFailLog.second;
      LogUtils.i('-----UDP------ latFailCode: $code - logPath: $logPath -');
    } catch (e) {
      LogUtils.i('-----UDP------ fetchLastFailLog: $e');
    } finally {
      await closeLostFail();
    }

    /// 发送配网数据
    _sendStep = ApSendDataStep.connecting;

    /// 如果 pincode 则跳转输入页面，等输入后写，否则直接写
    final inputPinCode = IotPairNetworkInfo()
        .selectIotDevice
        ?.product
        ?.extendScType
        .contains(IotDeviceExtendScType.PINCODE.extendSctype) ==
        true;
    if (inputPinCode) {
      postEvent(
          SmartStepEvent(StepName.STEP_TRANSFORM, what: WHAT_PINCODE_INPUT));
    } else {
      // 写入request_connction
      await sendBleData();
    }
  }

  Future<void> sendBleData({Map<String, dynamic>? arguments}) async {
    try {
      await readPairSocketMessage();
    } catch (e) {
      LogUtils.e('-----UDP------ readPairSocketMessage error: $e');
      postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
          status: SmartStepStatus.failed));
      nextStep(SmartStepApManualConnect());
    }
    LogUtils.d('-----UDP------ readPairSocketMessage');
    await runSendConnection(arguments: arguments);
  }

  Future<void> readPairSocketMessage() async {
    try {
      final serverAddress = (await InternetAddress.lookup(ap_host)).first;
      final clientSocket = await RawDatagramSocket.bind(
          serverAddress.type == InternetAddressType.IPv6
              ? InternetAddress.anyIPv6
              : InternetAddress.anyIPv4,
          0);
      _socket = clientSocket;
    } catch (e) {
      LogUtils.e('readPairSocketMessage error: $e ');
      postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
          status: SmartStepStatus.failed));
      nextStep(SmartStepApManualConnect());
      return;
    }
    _pairSubscription =
        _socket?.timeout(const Duration(seconds: 10), onTimeout: (sink) async {
          sink.close();
          closePairSendData();
          postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
              status: SmartStepStatus.failed));
          nextStep(SmartStepApManualConnect());
        }).listen(onError: (e) async {
          LogUtils.e('readPairSocketMessage onError $e');
          closePairSendData();
          _timer?.cancel();
          _timer = null;
          if (e is SocketException) {
            /// errorCode: 65 原因iOS 需要本地网络权限（用户点击授权也会报65），暂时走重试的逻辑 
            if (e.osError?.errorCode == 51 || e.osError?.errorCode == 65) {
              if (_retryCount <= re_create_socket_max) {
                Future.delayed(const Duration(seconds: 2), () async {
                  await readPairSocketMessage();
                  await runSendConnection();
                });
                _retryCount++;
                return;
              } else {
                postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                status: SmartStepStatus.failed));
                nextStep(SmartStepApManualConnect());
              }
            } else {
              postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
              status: SmartStepStatus.failed));
              nextStep(SmartStepApManualConnect());
            }
          } else {
            postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                status: SmartStepStatus.failed));
            nextStep(SmartStepApManualConnect());
          }
        }, (event) async {
          switch (event) {
            case RawSocketEvent.write:
              break;
            case RawSocketEvent.read:
              final data = _socket!.receive();
              LogUtils.i(
                  '-----UDP readPairSocketMessage ------ ${data?.data.length} ${utf8.decode(data?.data ?? [])}');
              if (data != null) {
                var recvJson = _sendDataParam.parseParam(data.data);
                if (recvJson['method'] == 'response_connection') {
                  /// 校验PinCode结果
                  var code = recvJson['code'];
                  final remain = recvJson['remain'];
                  if (code == null || code == '0' || remain == null) {
                    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                        what: WHAT_PINCODE_HIDE, obj: 0));

                    deviceId = recvJson['did']?.toString();
                    _timer?.cancel();
                    _timer = null;
                    _sendStep = ApSendDataStep.querySuccess;
                    final routerParam = await _sendDataParam.configRouterParam(
                        recvJson['did']?.toString() ?? '',
                        value: recvJson['value']?.toString());
                    await sendSettingMessage(routerParam);
                  } else {
                    /// 重试
                    ///  code -1 pcode 错误 -2 被锁定 remain 剩余次数或时间
                    ///  code：-2 时,remain 剩余锁定时间
                    //   code：-1 时,remain 剩余输入次数
                    if (recvJson.containsKey('remain')) {
                      if (code == -1) {
                        /// 发送pincode 错误
                        postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                            what: WHAT_PINCODE_ERROR, obj: remain, args: recvJson));
                      } else if (code == -2) {
                        /// 发送pincode 被锁，remain 表示被锁时间
                        postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                            what: WHAT_PINCODE_LOCK, obj: remain, args: recvJson));
                      }
                    }
                  }
                } else if (recvJson['method'] == 'response_router') {
                  _sendStep = ApSendDataStep.settingSuccess;
                  final code = recvJson['code'];
                  if (code == null || code == '0') {
                    closePairSendData();
                    await WiFiForIoTPlugin.forceWifiUsage(false);
                    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                        status: SmartStepStatus.success));
                    nextStep(SmartStepCheckPair(deviceId!));
                  } else {
                    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                        status: SmartStepStatus.success));
                    postEvent(SmartStepEvent(StepName.STEP_CHECK_PAIR,
                        status: SmartStepStatus.failed));
                  }
                }
              } else {
                postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
                    status: SmartStepStatus.failed));
              }
            case RawSocketEvent.closed:
              break;
            case RawSocketEvent.readClosed:
              break;
          }
        });
  }

  Future<void> runSendConnection({Map<String, dynamic>? arguments}) async {
    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (timer.tick > 10) {
        timer.cancel();
        await sendDataError();
      } else {
        await sendRequestConnect(arguments: arguments);
      }
    });
  }

  Future<bool> sendLastFailLog() async {
    var params = {'method': 'last_fail_log'};
    return await sendMessage(jsonEncode(params), isFailLog: true);
  }

  Future<bool> sendLastFailCode() async {
    var params = {'method': 'last_fail_code'};
    return await sendMessage(jsonEncode(params), isFailLog: true);
  }

  Future<void> sendRequestConnect({Map<String, dynamic>? arguments}) async {
    var params = _sendDataParam.requestConnectionParam(arguments: arguments);
    await sendMessage(params);
  }

  Future<void> sendSettingMessage(String msg) async {
    await sendMessage(msg);
  }

  Future<bool> sendMessage(String message, {bool isFailLog = false}) async {
    RawDatagramSocket? socket;
    socket = isFailLog ? _failLogSocket : _socket;
    if (socket == null) {
      return false;
    } else {
      int isSent = socket.send(utf8.encode(message),
          InternetAddress(ap_host, type: InternetAddressType.IPv4), ap_port);
      LogUtils.i(
          'sendMessage  socket.send: ${isSent} ,cotent: $message ,ap_host: ${ap_host} ,ap_port: ${ap_port}');
      return isSent != 0;
    }
  }

  Future<void> sendDataError() async {
    _socket?.close();
    await _pairSubscription?.cancel();
    postEvent(SmartStepEvent(StepName.STEP_TRANSFORM,
        status: SmartStepStatus.failed));
    nextStep(SmartStepApManualConnect());
  }

  /// 请求机器上一次配网失败日志
  /// [Pair<int, String>] first: code second: logPath
  Future<Pair<int, String>> fetchLastFailLog() async {
    _sendStep = ApSendDataStep.lastFailCode;
    RawDatagramSocket? socket = await createFailLogSocket();
    if (socket == null) {
      return Pair(0, '');
    }
    final completer = Completer<Pair<int, String>>();
    List<int> byteList = [];

    /// only use on [receiveLastFailLog]
    var lastFailCode = 0;
    _logSubscription = socket.timeout(const Duration(milliseconds: 3 * 1000),
        onTimeout: (sink) async {
          LogUtils.e('fetchLastFailLog timeout');
          sink.close();
          await closeLostFail();
          completer.complete(Pair(0, ''));
        }).listen(onError: (e) async {
      await closeLostFail();
      LogUtils.e('fetchLastFailLog onError $e');
      completer.complete(Pair(0, ''));
    }, (event) async {
      switch (event) {
        case RawSocketEvent.write:
          LogUtils.i('fetchLastFailLog write ${event} ');
          break;
        case RawSocketEvent.read:
          var recvData = socket.receive()?.data;
          LogUtils.i(
              '-----UDP fetchLastFailLog ------ ${recvData?.length}  $_sendStep');
          if (_sendStep == ApSendDataStep.lastFailCode) {
            final lastFailCode = receiveLastFailCode(recvData);
            if (lastFailCode != 0) {
              final ret = await sendLastFailLog();
              if (ret) {
                _sendStep = ApSendDataStep.lastFailLog;
              } else {
                _sendStep = ApSendDataStep.connecting;
                await closeLostFail();
                completer.complete(Pair(0, ''));
              }
            }
          } else if (_sendStep == ApSendDataStep.lastFailLog) {
            await receiveLastFailLog(
                recvData, byteList, completer, lastFailCode);
          }
          break;
        default:
          break;
      }
    });
    var ret = await sendLastFailCode();
    if (!ret) {
      await closeLostFail();
    }

    return completer.future;
  }

  void closePairSendData() {
    _pairSubscription?.cancel();
    _pairSubscription = null;
    _socket?.close();
    _socket = null;
  }

  Future<void> closeLostFail() async {
    await _logSubscription?.cancel();
    _logSubscription = null;
    _failLogSocket?.close();
    _failLogSocket = null;
  }

  int receiveLastFailCode(Uint8List? recvData) {
    if (recvData == null || recvData.isEmpty) {
      return 0;
    }
    // 获取last_fail_code
    var resultStr = utf8.decode(recvData);
    var recvJson = jsonDecode(resultStr);
    if (recvJson['method'] == 'last_fail_code') {
      var lastFailCode = int.tryParse(recvJson['code']) ?? 0;
      return lastFailCode;
    }
    return 0;
  }

  Future<void> receiveLastFailLog(Uint8List? recvData, List<int> byteList,
      Completer<Pair<int, String>> completer, int lastFailCode) async {
    if (recvData == null) {
      completer.complete(Pair(lastFailCode, ''));
      return;
    }
    var hData = recvData.sublist(0, 8);
    bool isHeader = utf8.decode(hData) == 'DREAMEE';
    String payloadMd5 = '';
    int payloadLen = 0;
    if (isHeader) {
      byteList.clear();
      var md5Data = recvData.sublist(8, 40);
      var lengthData = recvData.sublist(40, 44);
      payloadMd5 = utf8.decode(md5Data);
      Uint8List uint8Data = Uint8List.fromList(lengthData);
      ByteData byteData = ByteData.view(uint8Data.buffer);
      payloadLen = byteData.getUint32(0);
      if (payloadLen != 0) {
        Directory? appDocumentsDir = await getApplicationDocumentsDirectory();
        File logFile = File('${appDocumentsDir.path}/last_fail_log.tar.gz');
        if (await logFile.exists()) {
          await logFile.delete();
        } else {
          await logFile.create();
        }
        _logFile = logFile;
      }
    } else {
      await _logFile?.writeAsBytes(recvData);
      byteList.addAll(recvData);
    }
    if (byteList.length == payloadLen) {
      List<int> bytes = byteList;
      Digest digest = md5.convert(bytes);
      String encryptMD5 = digest.toString().toUpperCase();
      if (encryptMD5 == payloadMd5) {
        completer.complete(Pair(lastFailCode, _logFile?.path ?? ''));
      } else {
        completer.complete(Pair(lastFailCode, ''));
      }
      await _logSubscription?.cancel();
      _failLogSocket = null;
    } else if (recvData.length < buffer.length) {
      await _logSubscription?.cancel();
      _failLogSocket = null;
      completer.complete(Pair(lastFailCode, ''));
    }
  }

  Future<RawDatagramSocket?> createFailLogSocket() async {
    if (_failLogSocket == null) {
      try {
        final serverAddress = (await InternetAddress.lookup(ap_host)).first;
        final clientSocket = await RawDatagramSocket.bind(
            serverAddress.type == InternetAddressType.IPv6
                ? InternetAddress.anyIPv6
                : InternetAddress.anyIPv4,
            0);
        clientSocket.broadcastEnabled = true;
        _failLogSocket = clientSocket;
        return clientSocket;
      } on SocketException catch (e) {
        LogUtils.e('createFailLogSocket SocketException: $e');
      } catch (e) {
        LogUtils.e('createFailLogSocket error: $e');
      }
    }
    return _failLogSocket!;
  }

  @override
  Future<void> stepDestroy() async {
    await forceDisconnectDeviceAP();
    await closeLostFail();
    closePairSendData();
    _timer?.cancel();
    _timer = null;
    _retryCount = 0;
  }
}
