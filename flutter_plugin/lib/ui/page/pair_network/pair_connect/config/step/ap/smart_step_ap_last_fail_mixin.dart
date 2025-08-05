import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:path_provider/path_provider.dart';

mixin class SmartStepApLastFailMixin {
  final int ap_port = 44321;
  final String ap_host = '192.168.5.1';
  final int error_socket_max = 10;
  RawDatagramSocket? _failLogSocket;
  StreamSubscription? _logSubscription;
  File? _logFile;
  late Uint8List buffer = Uint8List(64 * 1024);

  Future<Pair<String, String>> getLastFailCode() async {
    final lastFailCode = await _fetchLastFailCode();
    if (lastFailCode == null || lastFailCode == '0') {
      return Pair('0', '');
    }
    final lastFailLog = await _fetchLastFailLog();
    if (lastFailLog != null) {
      /// 有日志
      return Pair(lastFailCode, lastFailLog);
    } else {
      return Pair(lastFailCode, '');
    }
  }

  /// 请求机器上一次lastFailCode
  ///
  //   获取 last_fail_code
  //
  //   0 未记录错误
  //   1 前次配网成功, 适用于机器报配网成功，但app提示失败
  //   2 未烧号
  //   3 did 未加入白名单
  //   4 本机已有IP，但无法访问服务器
  //   404_xx 其它连接服务器异常，xx为MQTT定义错误码
  //   101 密码错误，用户输入错误
  //   102 Wi-Fi名称不存在
  //   103 连上路由器，但未分配到IP地址
  //   120_xx 其它连接路由器失败 xx 为wpa 返回的status_code
  // {"method":"last_fail_code","code":"120_4"}
  Future<String?> _fetchLastFailCode() async {
    _failLogSocket = await createUDPSocket();
    if (_failLogSocket == null) {
      return null;
    }
    final completer = Completer<String?>();
    _failLogSocket?.timeout(Duration(seconds: 2 * 1000), onTimeout: (sink) {
      LogUtils.e('_fetchLastFailCode timeout');
      sink.close();
      closeLostFail();
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }).listen(onError: (e) {
      closeLostFail();
      LogUtils.e('_fetchLastFailCode onError $e');
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }, (event) {
      switch (event) {
        case RawSocketEvent.write:
          LogUtils.i('_fetchLastFailCode write ${event}');
          break;
        case RawSocketEvent.read:
          final recvData = _failLogSocket?.receive()?.data;
          LogUtils.i(
              '_fetchLastFailCode read ${recvData?.length} ${utf8.decode(recvData ?? [])}');
          final lastFailCode = _receiveLastFailCode(recvData);
          if (!completer.isCompleted) {
            completer.complete(lastFailCode);
          }
          break;
        default:
          break;
      }
    });
    final ret = await sendLastFailCode();
    if (!ret) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
      closeLostFail();
    }
    return completer.future;
  }

  /// 请求机器上一次配网失败日志
  /// 获取配网的日志内容
  // HEAD: 8Byte， 固定"DREAMEEE"
  // MD5SUM: 32Byte，日志文件md5值
  // PAYLOAD_LEN: 4Byte，int32，日志文件长度
  // PAYLOAD: 日志文件主体内容 压缩包
  Future<String?> _fetchLastFailLog() async {
    _failLogSocket = await createUDPSocket();
    if (_failLogSocket == null) {
      return null;
    }
    final completer = Completer<String?>();
    List<int> byteList = [];
    _logSubscription = _failLogSocket?.timeout(
        const Duration(milliseconds: 2 * 1000), onTimeout: (sink) async {
      LogUtils.e('fetchLastFailLog timeout');
      sink.close();
      await closeLostFail();
      completer.complete(null);
    }).listen(onError: (e) async {
      await closeLostFail();
      LogUtils.e('fetchLastFailLog onError $e');
      completer.complete(null);
    }, (event) async {
      switch (event) {
        case RawSocketEvent.write:
          LogUtils.i('fetchLastFailLog write ${event} ');
          break;
        case RawSocketEvent.read:
          var recvData = _failLogSocket?.receive()?.data;
          LogUtils.i('-----UDP fetchLastFailLog ------ ${recvData?.length} ');
          await receiveLastFailLog(recvData, byteList, completer);
          break;
        default:
          break;
      }
    });
    var ret = await sendLastFailLog();
    if (!ret) {
      await closeLostFail();
    }
    return completer.future;
  }

  String? _receiveLastFailCode(Uint8List? recvData) {
    if (recvData == null || recvData.isEmpty) {
      return null;
    }
    // 获取last_fail_code
    var resultStr = utf8.decode(recvData);
    var recvJson = jsonDecode(resultStr);
    if (recvJson['method'] == 'last_fail_code') {
      var lastFailCode = recvJson['code'] ?? '0';
      return lastFailCode;
    }
    return null;
  }

  Future<void> receiveLastFailLog(Uint8List? recvData, List<int> byteList,
      Completer<String?> completer) async {
    if (recvData == null) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
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
        if (!completer.isCompleted) {
          completer.complete(_logFile?.path ?? '');
        }
      } else {
        if (!completer.isCompleted) {
          completer.complete('');
        }
      }
      closeLostFail();
    } else if (recvData.length < buffer.length) {
      closeLostFail();
      if (!completer.isCompleted) {
        completer.complete('');
      }
    }
  }

  Future<RawDatagramSocket?> createUDPSocket() async {
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
      LogUtils.e('createUDPSocket SocketException: $e');
    } catch (e) {
      LogUtils.e('createUDPSocket error: $e');
    }
    return null;
  }

  Future<void> closeLostFail() async {
    await _logSubscription?.cancel();
    _logSubscription = null;
    _failLogSocket?.close();
    _failLogSocket = null;
  }

  Future<bool> sendLastFailLog() async {
    var params = {'method': 'last_fail_log'};
    return await _sendMessage(jsonEncode(params));
  }

  Future<bool> sendLastFailCode() async {
    var params = {'method': 'last_fail_code'};
    return await _sendMessage(jsonEncode(params));
  }

  Future<bool> _sendMessage(String message) async {
    if (_failLogSocket == null) {
      return false;
    } else {
      int isSent = _failLogSocket?.send(
              utf8.encode(message),
              InternetAddress(ap_host, type: InternetAddressType.IPv4),
              ap_port) ??
          0;
      LogUtils.i(
          '_sendMessage  socket.send: ${isSent} ,cotent: $message ,ap_host: ${ap_host} ,ap_port: ${ap_port}');
      return isSent != 0;
    }
  }
}
