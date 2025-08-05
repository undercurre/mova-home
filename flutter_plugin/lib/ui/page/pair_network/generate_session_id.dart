/// 生成sessionID
class GenerateSessionID {
  GenerateSessionID._internal();
  factory GenerateSessionID() => _instance;
  static final GenerateSessionID _instance = GenerateSessionID._internal();

  var _sessionID = 0;
  var enterType = 0;

  void resetSessionID() {
    _sessionID = 0;
  }

  void generateSessionID() {
    _sessionID = DateTime.timestamp().millisecondsSinceEpoch;
  }

  String currentSessionID() {
    return '$_sessionID';
  }
}
