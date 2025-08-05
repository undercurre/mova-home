import 'dart:async';

import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_down_widget.g.dart';

/// 倒计时控件
mixin CountDownWidget<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Timer? timer;
  int _count = 60;
  bool isTimerEnable = false;

  void startTimer({int count = 60}) {
    if (isTimerEnable) {
      return;
    }
    LogUtils.d('--------- startTimer -------- ');
    cancelTimer();
    isTimerEnable = true;
    _count = count - 1;
    _countDown(_count);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count < 0) {
        _countDown(-1);
        cancelTimer();
      } else {
        _countDown(_count);
      }
      _count--;
    });
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  void cancelTimer() {
    if (timer != null) {
      timer?.cancel();
      isTimerEnable = false;
    }
  }

  void countReset() {
    _count = 60;
    _countDown(-1);
    cancelTimer();
    timer = null;
  }

  void _countDown(int value) {
    ref.read(countDownProvider.notifier).countDown(value);
  }
}

@riverpod
class CountDown extends _$CountDown {
  @override
  int build() {
    return -1;
  }

  void countDown(int value) {
    state = value;
  }

  /// 判断是否可以下次点击
  bool isEnable() {
    return state < 0;
  }
}
