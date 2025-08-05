import 'dart:typed_data';

import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'base_send_data.dart';
import 'base_send_data_bt.dart';
import 'mcu_send_data_param.dart';

/// 发送配网数据步骤
class McuSendDataBt extends BaseSendDataBt {
  late McuSendDataParam mcuSendDataParam = McuSendDataParam();
  bool success = false;

  StepEvent nextEvent() {
    return StepEvent(StepId.STEP_BLE_SEND_DATA);
  }

  /// 常用的两步发数据
  @override
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    return await mcuSendDataParam.packageRandomCode();
  }

  @override
  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    final ret = mcuSendDataParam.parseRandomCode(data);
    ret['nonce'] = mcuSendDataParam.randomString();
    ret['mac'] = bleDevice?.remoteId.str ?? '';
    if (ret['code'] == '0') {
      deviceId = ret['did'];
      iotPublicKey = ret['value'];

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

      /// 绑定设备
      success = await repository.postDevicePairByNonce(ret);
      LogUtils.i('postDevicePairByNonce ret:$ret ,success: $success');
      return ParseData(success ? 0 : -1, ret);
    } else {
      return ParseData(int.parse(ret['code'] ?? '-1'), ret ?? {});
    }
  }

  @override
  Future<Uint8List> packageSettingDataFrame(
      {Map<String, dynamic>? arguments}) async {
    return mcuSendDataParam.packageConfigNet(success);
  }

  @override
  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    final ret = mcuSendDataParam.parseConfigNet(data);
    return ParseData(int.parse(ret['code'] ?? '-1'), ret);
  }
}
