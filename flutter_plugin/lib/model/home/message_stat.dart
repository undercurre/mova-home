/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-20 17:39:14
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-07-20 18:00:08
 * @FilePath: /flutter_plugin/lib/model/home/message_stat.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:freezed_annotation/freezed_annotation.dart';
part 'message_stat.freezed.dart';
part 'message_stat.g.dart';

@freezed
class MessageStat with _$MessageStat {
  factory MessageStat(
      {@Default(0) int shareUnread,
      @Default(0) int systemMsgUnread,
      @Default(0) int serviceMsgUnread,
      List<MsgUnreadBean>? msgUnreads}) = _MessageStat;

  MessageStat._();

  factory MessageStat.fromJson(Map<String, dynamic> json) =>
      _$MessageStatFromJson(json);

  int getUnreadCount() {
    var count = shareUnread + systemMsgUnread + serviceMsgUnread;
    msgUnreads?.forEach((element) {
      count += element.msgUnread;
    });
    return count;
  }
}

@freezed
class MsgUnreadBean with _$MsgUnreadBean {
  factory MsgUnreadBean(String? did, int msgUnread) = _MsgUnreadBean;

  factory MsgUnreadBean.fromJson(Map<String, dynamic> json) =>
      _$MsgUnreadBeanFromJson(json);
}
