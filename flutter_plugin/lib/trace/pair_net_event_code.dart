/**
 * 埋点定义：
 * https://dreametech.feishu.cn/sheets/YEfos7BKzhM1KCtM5J6cLcN5n5c?sheet=28db1e&range=MjE4OjIxOA%3D%3D
 * 配网页面定义
 * https://wiki.dreame.tech/pages/viewpage.action?pageId=109440390
 * 配网埋点需求
 * https://dreametech.feishu.cn/docx/Gxuld1sHBoUzt6xu8P2cbNBFn0c
 *
 */
enum PairNetEventCode {
  EnterSourceType(1),
  WifiIsConnect(2),
  Is5GHz(3),
  ChangeBand(4),
  UnReachableToEMQ(5),
  TriggerApAlert(6),
  ScanApFail(7),
  ManualConnectAp(8),
  CancelConnectAp(9),
  NotConnectAp(10),
  TogglePairType(11),
  UdpTransport(12),
  PairRequest(13),
  QRPairRequest(14),
  CostTime(15),
  EnterPage(16),
  ExitPage(17),
  LastFailLog(18),
  ;

  final int code;

  const PairNetEventCode(this.code);
}

enum ExceptionStatisticsEventCode {
  SdkDownloadFail(1),
  PluginDownloadFail(2),
  PluginLoadFail(3),
  PluginCrash(4),
  AppCrash(6),

// 重新登录
  LoginAgain(7),
  MqttExceptionDisconnect(8),
  ;

  final int code;

  const ExceptionStatisticsEventCode(this.code);
}

enum DailyActiveEventCode {
  PluginDailyActive(1),
  AppDailyActive(2),
  ;

  final int code;

  const DailyActiveEventCode(this.code);
}

enum AppEventEventCode {
  Click(1),
  LifeCycle(2),
  ;

  final int code;

  const AppEventEventCode(this.code);
}

enum PluginEventEventCode {
  Click(1),
  LifeCycle(2),
  Custom(3),
  Video(3),
  ;

  final int code;

  const PluginEventEventCode(this.code);
}

enum AppWidgetEventCode {
  Add(1),
  Clean(2),
  Pause(3),
  Charge(4),
  Change(5),
  ;

  final int code;

  const AppWidgetEventCode(this.code);
}

enum AliBindEventCode {
  Bind(1),
  ;

  final int code;

  const AliBindEventCode(this.code);
}

enum PageAliveEventCode {
  Enter(1),
  Exit(2),
  ;

  final int code;

  const PageAliveEventCode(this.code);
}
