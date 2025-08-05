import 'package:dreame_flutter_plugin_tx_video/dreame_flutter_plugin_tx_video.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class TxEventReportImpl extends TxEventReport {
  @override
  void eventReport(int modelCode, int eventCode,
      {int? offset = 0,
      int? pageId = 0,
      int int1 = 0,
      int int2 = 0,
      int int3 = 0,
      int int4 = 0,
      int int5 = 0,
      int pluginVer = 0,
      String str1 = '',
      String str2 = '',
      String str3 = '',
      String rawStr = '',
      String did = '',
      String model = ''}) {
    LogUtils.e('tx接口异常: $rawStr');
    LogModule().eventReport(modelCode, eventCode,
        int1: int1,
        int2: int2,
        int3: int3,
        int4: int4,
        int5: int5,
        pluginVer: pluginVer,
        str1: str1,
        str2: str2,
        str3: str3,
        rawStr: rawStr,
        did: did,
        model: model,
        stayTime: offset);
  }
}