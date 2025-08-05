/// 去绑定邮箱事件
class EmailRecordDialogEvent {}

enum EmailRecordDialogResult {
  success,
  fail,
  cancel,
}

/// 邮箱返回结果
class EmailRecordDialogResultEvent {
  final EmailRecordDialogResult result;
  EmailRecordDialogResultEvent({required this.result});
}

class RefreshOverseasMalldEvent {
  final String url;
  RefreshOverseasMalldEvent({required this.url});
}
