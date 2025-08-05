import 'dart:typed_data';

import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_step/step_event.dart';

/// 发送配网数据步骤
abstract class BaseSendData {
  int stepIndex = 0;
  String? deviceId;

  Future<Uint8List> packageDataFrame({Map<String, dynamic>? arguments}) async {
    return Uint8List(0);
  }

  Future<ParseData> parseDataFrame(Uint8List data) async {
    return ParseData(-1, {});
  }

  StepEvent nextEvent() {
    return PairStateStepEvent(StepId.STEP_BLE_SEND_DATA, deviceId ?? '');
  }
}

class ParseData {
  final int code;
  final bool finish;
  final Map<String, dynamic> content;

  ParseData(this.code, this.content, {this.finish = false});

  @override
  String toString() {
    return 'ParseData{code: $code, finish: $finish, content: $content}';
  }
}
