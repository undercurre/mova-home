import 'dart:typed_data';

import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/protocol/bt_send_data_protocol.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'base_send_data.dart';
import 'base_send_data_bt.dart';
import 'special_send_data_param.dart';

/// 蓝牙特殊配置配网
class MowerSendDataBt extends BaseSendDataBt {
  late BtSendDataProtocol btSendDataProtocol = BtSendDataProtocol();
  late MowerSendDataParam sendDataParam = MowerSendDataParam();

  var propertyValue = '';

  /// 常用的两步发数据
  @override
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    LogUtils.i('-----BLE------ packageAskDataFrame arguments $arguments');
    var newArguments = arguments ?? {};
    newArguments['uid'] = IotPairNetworkInfo().uid;
    return btSendDataProtocol.packageQueryString(
        sendDataParam.requestConnectionParam(arguments: newArguments));
  }

  @override
  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    final pair = btSendDataProtocol.parseQueryAckData(data);
    if (pair.first == 0) {
      LogUtils.i('-----BLE------ packageAskDataFrame arguments ${pair.second}');
      final ret = sendDataParam.parseParamStr(pair.second);
      deviceId = ret['did'];
      int code = int.parse(ret['code'] ?? '0');
      iotPublicKey = ret['pubCer'];
      propertyValue = ret['value'];

      if (code != 0) {
        return ParseData(code, ret);
      }

      /// 检查是否支持换绑
      if (IotPairNetworkInfo()
              .selectIotDevice
              ?.product
              ?.bindType
              .contains(IotDeviceBindType.STRONG.bindType) ==
          true) {
        final ret = await repository.checkDeviceBindOther(deviceId!);
        if (ret == true) {
          return ParseData(40045, {'msg': '已有绑定其他用户，不支持换绑'});
        }
      }

      return ParseData(code, ret);
    } else {
      return ParseData(pair.first, const {});
    }
  }

  @override
  Future<Uint8List> packageSettingDataFrame(
      {Map<String, dynamic>? arguments}) async {
    var map = sendDataParam.decodeECDHContent(
        deviceId: deviceId ?? '',
        pubKey: iotPublicKey ?? '',
        encryptContent: propertyValue);
    final result = await repository.postDevicePair4Ble(map);
    var configRouterParam = await sendDataParam.requestBinding(result);
    return btSendDataProtocol.packageSettingString(configRouterParam);
  }

  @override
  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    final pair =
        btSendDataProtocol.parseSettingAckData(data, skipAckCheck: true);
    if (pair.first == 0) {
      final ret = sendDataParam.parseParamStr(pair.second);
      return ParseData(0, ret);
    } else {
      return ParseData(pair.first, const {});
    }
  }
}
