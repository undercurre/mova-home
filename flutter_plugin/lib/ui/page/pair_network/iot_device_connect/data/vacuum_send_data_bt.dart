import 'dart:typed_data';

import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/protocol/bt_send_data_protocol.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'base_send_data.dart';
import 'base_send_data_bt.dart';
import 'vacuum_send_data_param.dart';

/// 扫地机配网数据步骤
class VacuumSendDataBt extends BaseSendDataBt {
  late VacuumSendDataParam sendDataParam = VacuumSendDataParam();
  late BtSendDataProtocol btSendDataProtocol = BtSendDataProtocol();
  bool success = false;

  StepEvent nextEvent() {
    return StepEvent(StepId.STEP_BLE_SEND_DATA);
  }

  /// 常用的两步发数据
  @override
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    LogUtils.i('-----BLE------ packageAskDataFrame arguments $arguments');
    return btSendDataProtocol.packageQueryString(
        sendDataParam.requestConnectionParam(arguments: arguments));
  }

  @override
  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    final pair = btSendDataProtocol.parseQueryAckData(data);
    if (pair.first == 0) {
      LogUtils.i('-----BLE------ packageAskDataFrame arguments ${pair.second}');
      final ret = sendDataParam.parseParamStr(pair.second);
      deviceId = ret['did'];
      int code = int.parse(ret['code'] ?? '0');
      iotPublicKey = ret['value'];
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
    var configRouterParam =
        await sendDataParam.configRouterParam(deviceId!, value: iotPublicKey);
    return btSendDataProtocol.packageSettingString(configRouterParam);
  }

  @override
  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    final pair = btSendDataProtocol.parseSettingAckData(data);
    if (pair.first == 0) {
      final ret = sendDataParam.parseParamStr(pair.second);
      return ParseData(0, ret);
    } else {
      return ParseData(pair.first, const {});
    }
  }
}
