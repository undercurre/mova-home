// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageStatImpl _$$MessageStatImplFromJson(Map<String, dynamic> json) =>
    _$MessageStatImpl(
      shareUnread: (json['shareUnread'] as num?)?.toInt() ?? 0,
      systemMsgUnread: (json['systemMsgUnread'] as num?)?.toInt() ?? 0,
      serviceMsgUnread: (json['serviceMsgUnread'] as num?)?.toInt() ?? 0,
      msgUnreads: (json['msgUnreads'] as List<dynamic>?)
          ?.map((e) => MsgUnreadBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MessageStatImplToJson(_$MessageStatImpl instance) =>
    <String, dynamic>{
      'shareUnread': instance.shareUnread,
      'systemMsgUnread': instance.systemMsgUnread,
      'serviceMsgUnread': instance.serviceMsgUnread,
      'msgUnreads': instance.msgUnreads,
    };

_$MsgUnreadBeanImpl _$$MsgUnreadBeanImplFromJson(Map<String, dynamic> json) =>
    _$MsgUnreadBeanImpl(
      json['did'] as String?,
      (json['msgUnread'] as num).toInt(),
    );

Map<String, dynamic> _$$MsgUnreadBeanImplToJson(_$MsgUnreadBeanImpl instance) =>
    <String, dynamic>{
      'did': instance.did,
      'msgUnread': instance.msgUnread,
    };
