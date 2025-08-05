class RefreshMessageEvent {}

/// 分享者，收到消息处理的结果事件，比如说分享成功，分享失败
class ShareMessageEvent {
  final String deviceId;
  const ShareMessageEvent(this.deviceId);
}
