import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// 路由变化Observer
class PageRouteNavObserver extends NavigatorObserver {
  void log(value) => LogUtils.d('MyNavObserver: $value');
  bool canPop = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('widget.pages didPush +++++++++++ : ${navigator?.widget.pages.map((e) => e.name).join(",")} ');
    log('didPush: ${route.settings.name}, previousRoute= ${previousRoute?.settings.name} ');
    bool currentCanPop = route.navigator?.canPop() ?? false;
    if (currentCanPop != canPop) {
      canPop = currentCanPop;
      MessageChannel().navCanBack(canPop);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('widget.pages didPop -------- : ${navigator?.widget.pages.map((e) => e.name).join(",")} ');
    log('didPop: ${route.settings.name}, previousRoute= ${previousRoute?.settings.name} ');
    bool currentCanPop = route.navigator?.canPop() ?? false;
    if (currentCanPop != canPop) {
      canPop = currentCanPop;
      MessageChannel().navCanBack(canPop);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('widget.pages didRemove ************** : ${navigator?.widget.pages.map((e) => e.name).join(",")} ');
    log('didRemove: ${route.settings.name}, previousRoute= ${previousRoute?.settings.name} ');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log('widget.pages didReplace ************** : ${navigator?.widget.pages.map((e) => e.name).join(",")} ');
    log('didReplace: new= ${newRoute?.toString()}, old= ${oldRoute?.toString()} ');
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    var pages = navigator?.widget.pages;
    log('didStartUserGesture: ${route.settings.name}, '
        'previousRoute= ${previousRoute?.settings.name}');
  }

  @override
  void didStopUserGesture() => log('didStopUserGesture');
}
