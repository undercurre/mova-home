import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:go_router/go_router.dart';

extension DMRouter on GoRouter {
  void checkPop<T extends Object?>([T? result]) {
    if (canPop()) {
      pop(result);
    } else {
      print('pop: can not pop');
      UIModule().exitEnginer();
    }
  }
}

extension DMNavigatorState on NavigatorState {
  void checkPopUntil(RoutePredicate predicate) {
    if (canPop()) {
      popUntil(predicate);
    } else {
      print('popUntil: can not pop');
      UIModule().exitEnginer();
    }
  }
}
