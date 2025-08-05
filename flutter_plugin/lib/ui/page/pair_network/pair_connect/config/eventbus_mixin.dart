import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

mixin EventBusMixin<T> {
  @protected
  final eventBus = EventBus(sync: true);
  StreamSubscription? _eventBusSubscription;

  /// 订阅消息
  void subscribeMsg() {
    _eventBusSubscription = eventBus.on<T>().listen((event) {
      handleMessage(event);
    });
  }

  void unSubscribeMsg() {
    _eventBusSubscription?.cancel();
  }

  void postEvent(T event) {
    eventBus.fire(event);
  }

  void handleMessage(T event);
}
