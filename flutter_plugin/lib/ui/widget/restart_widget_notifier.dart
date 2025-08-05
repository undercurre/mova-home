import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restart_widget_notifier.g.dart';

@riverpod
class RestartWidgetNotifier extends _$RestartWidgetNotifier {
  @override
  Key build() {
    return UniqueKey();
  }

  void restartApp() {
    state = UniqueKey();
  }
}
