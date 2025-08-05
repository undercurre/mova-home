// 运行状态
enum StepRunningStatus {
  none(0, 'none'),
  start(1, 'none'),
  running(2, 'none'),
  stop(3, 'none'),
  complete(100, 'none'),
  ;

  final int code;
  final String msg;

  const StepRunningStatus(this.code, this.msg);
}

// 结果状态
enum StepResultStatus {
  none(0, 'none'),
  success(1, 'success'),
  failed(2, 'failed'),
  ;

  final int code;
  final String msg;

  const StepResultStatus(this.code, this.msg);
}
