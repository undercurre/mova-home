import 'dart:async';

class SchemeHandleUtils {
  SchemeHandleUtils._internal();

  factory SchemeHandleUtils() => _instance;
  static final SchemeHandleUtils _instance = SchemeHandleUtils._internal();

  Completer<bool>? _completer = null;

  Future<bool> getFuture() {
    if (_completer != null) {
      _completer = Completer<bool>();
    }
    return _completer?.future ?? Future(() => true);
  }

  void complete() {
    if (_completer?.isCompleted == true) {
    } else {
      _completer?.complete(true);
    }
    _completer = null;
  }
}
