import 'dart:typed_data';

import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/base_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/protocol/bt_mcu_send_data_protocol.dart';

class McuSendDataParam extends BaseSendDataParam {
  late final BtMcuSendDataProtocol _mcuProtocol = BtMcuSendDataProtocol();
  late final String _randomString = _mcuProtocol.getRandomString(6);

  String randomString() {
    return _randomString;
  }

  Future<Uint8List> packageRandomCode() async {
    String uid =
        await AccountModule().getAuthBean().then((value) => value.uid ?? '');
    return _mcuProtocol.packageRandomCode(uid, randomString());
  }

  /// return {
  //       'code': '0',
  //       'encryptContent': encryptContent,
  //       'did': did,
  //       'ver': ver
  //     };
  Map<String, String> parseRandomCode(Uint8List content) {
    return _mcuProtocol.parseRandomCode(content);
  }

  Uint8List packageConfigNet(bool success) {
    return _mcuProtocol.packageConfigNet(success);
  }

  Map<String, String> parseConfigNet(Uint8List content) {
    return _mcuProtocol.parseConfigNet(content);
  }
}
