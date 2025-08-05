import 'dart:async';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dialog_job_manager.g.dart';

@Riverpod(keepAlive: true)
class DialogJobManager extends _$DialogJobManager {
  final List<DialogJob> _jobList = [];
  List<DialogJob> get jobList => _jobList;
  int _currentIndex = 0;
  bool _isReady = false;

  @override
  DialogJob? build() {
    return null;
  }

  Future<bool> areUReady() {
    if (_isReady) {
      LogUtils.d('DialogJob ready, but already ready');
    } else {
      _isReady = true;
      _loop();
    }
    return Future.value(_isReady);
  }

  void sendJobMessage(DialogJob job) {
    if (_jobList.isNotEmpty) {
      List<DialogJob> doneList = [];
      for (var i = 0; i < _currentIndex + 1; i++) {
        doneList.add(_jobList[i]);
      }
      List<DialogJob> newList = [];
      if (_currentIndex + 1 <= _jobList.length) {
        newList = _jobList.sublist(_currentIndex + 1);
      }

      newList.add(job);
      newList.sort((a, b) => b.jobType.priority.compareTo(a.jobType.priority));

      doneList.addAll(newList);
      _jobList.clear();
      _jobList.addAll(doneList);
    } else {
      _jobList.add(job);
    }
    _loop();
  }

  void _loop() {
    if (!_isReady) return;
    if (_jobList.isEmpty) return;
    LogUtils.d(
        'DialogJob loop, _currentIndex: $_currentIndex, _jobList: $_jobList, state: $state');
    if (state == null) {
      _jobList.sort((a, b) => b.jobType.priority.compareTo(a.jobType.priority));
      _currentIndex = 0;
      state = _jobList[_currentIndex];
    } else {
      if (_jobList[_currentIndex].finish) {
        int next = _currentIndex + 1;
        if (next < _jobList.length) {
          _currentIndex = next;
          state = _jobList[_currentIndex];
        }
      }
    }
  }

  /// 下一个任务
  void nextJob() {
    try {
      _jobList[_currentIndex].finish = true;
      _loop();
    } catch (e) {
      LogUtils.e('DialogJob nextJob error: $e');
    }
  }

  /// 跳过当前任务，直接执行下一个任务
  void skip2Next(DialogType type) {
    _jobList.removeWhere((element) => element.jobType == type);
    _loop();
  }

  /// 重置状态
  Future<void> reset() async {
    Completer<void> completer = Completer<void>();
    LogUtils.d('DialogJob finish all job _jobList: $_jobList');
    _jobList.clear();
    _currentIndex = 0;
    _isReady = false;
    state = null;
    completer.complete();
    return completer.future;
  }

  /// 当前任务
  DialogJob? currentJob() {
    return state;
  }
}

class DialogJob {
  final DialogType jobType;
  final String name;
  bool finish;
  dynamic bundle;

  static const int ad = 1;

  DialogJob(this.jobType, {this.name = '', this.bundle, this.finish = false});

  @override
  int get hashCode => Object.hash(runtimeType, jobType, name);

  @override
  bool operator ==(Object other) {
    return other is DialogJob &&
        name == other.name &&
        jobType == other.jobType &&
        finish == other.finish &&
        bundle == other.bundle;
  }

  @override
  String toString() {
    return 'name: $jobType priority: ${jobType.priority} finish: $finish}';
  }
}

//用户评分<-引导<-广告<-邮箱收集<-绑定手机<-app更新<-隐私更新
// 数字越大，优先级越高
enum DialogType {
  userMark(3),
  guide(4),
  ad(5),
  personalizedAd(6),
  uxPlan(7),
  emailCollect(8),
  bindPhone(9),
  upgrade(10),
  privacy(11),
  // 不要改这个值，用于所有对话框
  all(99999999);

  final int priority;

  const DialogType(this.priority);
}
