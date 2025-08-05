import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';

class EventBusUtil {
  static _MyEventBus? _eventBus;
  static final Map<int, List<StreamSubscription>> _subscriptions = {};

  static _MyEventBus getInstance() {
    _eventBus ??= _MyEventBus();
    return _eventBus!;
  }

  static void destory() {
    _eventBus?.destroy();
    _subscriptions.clear();
    _eventBus = null;
  }
}

class _MyEventBus extends EventBus {
  @override
  void fire(event) {
    if (!streamController.isClosed) {
      super.fire(event);
    } else {
      LogUtils.e('eventbus fire fail event:$event');
    }
  }
}

extension EventBusUtilExtension on EventBus {
  /// Register a callback to listen to the event of type T
  /// 重复注册会有未知问题，[register] 和 [unRegister] 成对出现
  void register<T>(Object key, Function(T event) callback) {
    final streamSubscription =
        EventBusUtil.getInstance().on<T>().listen((event) {
      try {
        callback.call(event);
      } catch (e) {
        LogUtils.e('eventbus on fail e:$e');
      }
    });
    final list = EventBusUtil._subscriptions[key.hashCode] ?? [];
    list.add(streamSubscription);
    EventBusUtil._subscriptions[key.hashCode] = list;
  }

  /// unRegister a callback to listen to the event of type T
  void unRegister(Object key) {
    EventBusUtil._subscriptions.remove(key.hashCode)?.forEach((element) {
      element.cancel();
    });
  }
}
