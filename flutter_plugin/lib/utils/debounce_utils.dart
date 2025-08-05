import 'dart:async';
import 'dart:ui';

class DebounceUtils {
  static final Map<String, Timer> _timers = {};
  static final Map<String, bool> _throttleFlags = {};

  /// 防抖方法
  /// [key] 用于区分不同的防抖操作
  /// [duration] 防抖时间，默认 300ms
  /// [callback] 要执行的回调函数
  static void debounce({
    required String key,
    Duration duration = const Duration(milliseconds: 300),
    required VoidCallback callback,
  }) {
    // 如果已经存在定时器，先取消
    if (_timers.containsKey(key)) {
      _timers[key]?.cancel();
    }

    // 创建新的定时器
    _timers[key] = Timer(duration, () {
      callback();
      _timers.remove(key);
    });
  }

  /// 节流方法 - 只执行第一次操作
  /// [key] 用于区分不同的节流操作
  /// [duration] 节流时间，默认 300ms
  /// [callback] 要执行的回调函数
  static void throttle({
    required String key,
    Duration duration = const Duration(milliseconds: 300),
    required VoidCallback callback,
  }) {
    // 如果已经存在节流标志，直接返回
    if (_throttleFlags.containsKey(key)) {
      return;
    }

    // 设置节流标志
    _throttleFlags[key] = true;

    // 执行回调
    callback();

    // 在指定时间后重置节流标志
    Timer(duration, () {
      _throttleFlags.remove(key);
    });
  }

  /// 取消指定 key 的防抖操作
  static void cancel(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }

  /// 取消所有防抖操作
  static void cancelAll() {
    _timers.forEach((key, timer) {
      timer.cancel();
    });
    _timers.clear();
  }
}
