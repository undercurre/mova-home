import 'dart:convert';
import 'dart:typed_data';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_curve25519/flutter_curve25519.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/data/vacuum_send_data_param.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/utils/keypair_curve25519.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class MowerSendDataParam extends VacuumSendDataParam {
  MowerSendDataParam();

  Future<String> requestBinding(int success) async {
    var map = {
      'method': 'request_binding',
      'code': success,
    };
    return jsonEncode(map);
  }



}
