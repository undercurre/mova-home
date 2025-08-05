import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_device_connect/repository/pair_net_repository.dart';
import 'base_send_data.dart';

/// 配网文档 [https://wiki.dreame.tech/pages/viewpage.action?pageId=186387545]
class BaseSendDataBt extends BaseSendData {
  String? iotPublicKey;
  String? deviceId;

  BluetoothDevice? bleDevice;
  late PairNetRepository repository = PairNetRepository();

  @override
  Future<Uint8List> packageDataFrame({Map<String, dynamic>? arguments}) async {
    if (stepIndex == 0) {
      return await packageAskDataFrame(arguments: arguments);
    } else if (stepIndex == 1) {
      return await packageSettingDataFrame(arguments: arguments);
    }
    return Uint8List(0);
  }

  @override
  Future<ParseData> parseDataFrame(Uint8List data) async {
    var parseData = ParseData(-1, {});
    if (stepIndex == 0) {
      parseData = await parseAskDataFrame(data);
    } else if (stepIndex == 1) {
      parseData = await parseSettingDataFrame(data);
    }
    if (parseData.code == 0) {
      stepIndex++;
    }
    return parseData;
  }

  /// 常用的两步发数据
  Future<Uint8List> packageAskDataFrame(
      {Map<String, dynamic>? arguments}) async {
    return Uint8List(0);
  }

  Future<ParseData> parseAskDataFrame(Uint8List data) async {
    return ParseData(-1, {});
  }

  Future<Uint8List> packageSettingDataFrame(
      {Map<String, dynamic>? arguments}) async {
    return Uint8List(0);
  }

  Future<ParseData> parseSettingDataFrame(Uint8List data) async {
    return ParseData(-1, {});
  }
}
