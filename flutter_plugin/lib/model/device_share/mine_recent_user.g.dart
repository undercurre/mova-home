// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_recent_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MineRecentUserImpl _$$MineRecentUserImplFromJson(Map<String, dynamic> json) =>
    _$MineRecentUserImpl(
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      uid: json['uid'] as String?,
      sharedStatus: (json['sharedStatus'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MineRecentUserImplToJson(
        _$MineRecentUserImpl instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'name': instance.name,
      'uid': instance.uid,
      'sharedStatus': instance.sharedStatus,
    };
