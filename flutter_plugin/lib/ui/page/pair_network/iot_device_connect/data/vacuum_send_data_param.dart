import 'dart:convert';
import 'dart:typed_data';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter_curve25519/flutter_curve25519.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/utils/keypair_curve25519.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class VacuumSendDataParam extends BaseSendDataParam {
  late Curve25519KeypairGenerator _keyPairGenerator;
  late Curve25519KeyPair _keyPair;

  VacuumSendDataParam() {
    _keyPairGenerator = Curve25519KeypairGenerator();
    _keyPair = _keyPairGenerator.generateKeyPair();
  }

  /// 如果支持pincode，则在第一步校验pincode
  String requestConnectionParam({Map<String, dynamic>? arguments}) {
    // 获取公钥
    final publicKey = _keyPair.publicKey;
    LogUtils.i('---- publickey: $publicKey');
    final connectReq = <String, dynamic>{
      'method': 'request_connection',
      'value': base64Encode(publicKey),
      'length': publicKey.length,
    };
    if (arguments != null && arguments.isNotEmpty) {
      connectReq.addAll(arguments);
    }
    return jsonEncode(connectReq);
  }

  /// 解析请求连接参数
  Map<String, dynamic> parseParam(Uint8List? data) {
    if (data == null || data.isEmpty) {
      return const {};
    }
    var recvMsg = utf8.decode(data);
    return parseParamStr(recvMsg);
  }

  /// 解析请求连接参数, 协议交互文档
  /// 相关文档[https://dreametech.feishu.cn/wiki/SkwFwCke7igII2kimQmcKZQSnic?from=from_copylink]
  Map<String, dynamic> parseParamStr(String? recvMsg, {String? methodName}) {
    if (recvMsg != null) {
      if (recvMsg.startsWith('{') || recvMsg.startsWith('[')) {
        var recvJson = jsonDecode(recvMsg);
        final method = recvJson['method'];
        String code = recvJson['code']?.toString() ?? '0';
        recvJson['code'] = code;
        if (method == 'response_connection') {
          // String did = recvJson['did']?.toString() ?? '';
          // String value = recvJson['value']?.toString() ?? '';
          // String remain = recvJson['remain']?.toString() ?? '';
          // return {
          //   'method': method,
          //   'did': did,
          //   'value': value,
          //   'code': code,
          //   'remain': remain,
          // };
        } else if (method == 'response_router') {
          // return {
          //   'method': method,
          //   'code': code,
          // };
        } else if (method == 'response_binding') {
          // return {
          //   'method': method,
          //   'code': code,
          // };
        }
        return recvJson;
      }
    }
    return const {};
  }

  Future<String> configRouterParam(String deviceId, {String? value}) async {
    UserInfoModel? user = await AccountModule().getUserInfo();
    String timezone = await FlutterTimezone.getLocalTimezone();

    /// 此处有网络请求
    IotPairNetworkInfo().regionUrl ??
        await IotPairNetworkInfo().getMqttDomainV2();
    var routerReq = {
      'domain': IotPairNetworkInfo().regionUrl,
      'notClearLogFile': 0,
      'passwd': IotPairNetworkInfo().routerWifiPwd,
      'region': IotPairNetworkInfo().region,
      'ssid': IotPairNetworkInfo().routerWifiName,
      'timestamp': (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
      'timezone': timezone,
      'uid': user?.uid
    };
    if (IotPairNetworkInfo().isAfterSale == true) {
      routerReq["notClearLogFile"] = 1;
    }
    LogUtils.i('----------- configRouterParam: $routerReq  $deviceId  $value');
    // json加密
    if (value == null) {
      routerReq['method'] = 'config_router';
      return jsonEncode(routerReq);
    } else {
      var iotPublicKey = base64Decode(value);
      var sharedKey = _keyPairGenerator.getSharedKey(iotPublicKey);
      final sharedSecretKey = encrypt.Key.fromBase64(sharedKey);

      LogUtils.i('---- sharedKey: $sharedKey');
      final iv =
          encrypt.IV.fromUtf8(('${deviceId}1111111111111111').substring(0, 16));
      final encrypter = encrypt.Encrypter(
        encrypt.AES(sharedSecretKey, mode: encrypt.AESMode.cbc),
      );
      final encrypted =
          encrypter.encryptBytes(utf8.encode(jsonEncode(routerReq)), iv: iv);
      final encryptJson = {
        'method': 'config_router',
        'value': base64Encode(encrypted.bytes),
        'length': encrypted.bytes.length
      };
      return jsonEncode(encryptJson);
    }
  }

  Map<String, dynamic> decodeECDHContent(
      {required String deviceId,
      required String pubKey,
      required String encryptContent}) {
    try {
      var iotPublicKey = base64Decode(pubKey);
      var sharedKey = _keyPairGenerator.getSharedKey(iotPublicKey);
      final sharedSecretKey = encrypt.Key.fromBase64(sharedKey);
      // 解密
      LogUtils.i(
          '---- content:$encryptContent, deviceId:$deviceId ,sharedKey: $sharedKey');
      final iv =
          encrypt.IV.fromUtf8(('${deviceId}1111111111111111').substring(0, 16));
      final encrypter =
          Encrypter(AES(sharedSecretKey, mode: AESMode.cbc, padding: 'PKCS7'));
      ///
      final encrypted = encrypter.decryptBytes(Encrypted.fromBase64(encryptContent), iv: iv);
      return jsonDecode(utf8.decode((encrypted)));
    } catch (e) {
      LogUtils.e('decodeECDHContent error: $e');
    }
    return {};
  }
}
