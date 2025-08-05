import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pair_net_pincode_ui_state.dart';

part 'pair_net_pincode_state_notifier.g.dart';

@riverpod
class PairNetPinCodeStateNotifier extends _$PairNetPinCodeStateNotifier {
  Timer? _timer;

  @override
  PairNetPinCodeUIState build() {
    ref.onDispose(() {
      cancelTimer();
    });
    return PairNetPinCodeUIState();
  }

  void initData() {
    state = state.copyWith(pincode: '', enableBtn: false, remainingTime: 0);
  }

  void updatePinCode(String text) {
    state = state.copyWith(pincode: text, enableBtn: text.length == 4);
  }

  void updateRemainingTime(int remain) {
    state = state.copyWith(remainingTime: remain);
    startCountDown();
  }

  void cancelTimer() {
    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void startCountDown() {
    if (state.remainingTime <= 0) {
      return;
    }
    cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingTime > 0) {
        var showTime = '';
        var remainingTime = state.remainingTime - 1;
        if (remainingTime > 60) {
          showTime = '${remainingTime ~/ 60}min';
        } else {
          showTime = '${remainingTime}s';
        }
        state =
            state.copyWith(remainingTime: remainingTime, showTime: showTime);
      } else {
        state = state.copyWith(remainingTime: 0, showTime: '');
        timer.cancel();
      }
    });
  }
}
