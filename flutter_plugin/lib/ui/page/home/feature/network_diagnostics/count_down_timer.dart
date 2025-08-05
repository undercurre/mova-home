import 'dart:async';

import 'package:flutter_plugin/utils/logutils.dart';

mixin CountDownTimer {
  Timer? timer;
  int _count = 2 * 60;
  int totalCount = 2 * 60;
  bool isTimerEnable = false;

  void startTimer({int count = 2 * 60}) {
    if (isTimerEnable) {
      return;
    }
    LogUtils.d('--------- startTimer -------- ');
    cancelTimer();
    isTimerEnable = true;
    totalCount = count;
    _count = count - 1;
    countDown(_count, 0);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _count--;
      if (_count < 0) {
        countDown(-1, 100);
        cancelTimer();
      } else {
        countDown(_count, (count - _count) * 100 ~/ count);
      }
    });
  }

  void cancelTimer({bool force = false}) {
    if (timer != null) {
      timer?.cancel();
      timer = null;
      if (!force) {
        countDown(-1, 100);
      }
      isTimerEnable = false;
    }
  }

  void countDown(int value, int progress) {}
}
