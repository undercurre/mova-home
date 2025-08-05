// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest_history_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestHistoryBoxImpl _$$SuggestHistoryBoxImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestHistoryBoxImpl(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => SuggestHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SuggestHistoryBoxImplToJson(
        _$SuggestHistoryBoxImpl instance) =>
    <String, dynamic>{
      'records': instance.records,
    };

_$SuggestHistoryImpl _$$SuggestHistoryImplFromJson(Map<String, dynamic> json) =>
    _$SuggestHistoryImpl(
      id: json['id'] as String? ?? '',
      status: (json['status'] as num?)?.toInt() ?? 0,
      createTime: (json['createTime'] as num?)?.toDouble() ?? 0,
      content: json['content'] as String? ?? '',
      deviceIconUrl: json['deviceIconUrl'] as String? ?? '',
      modelName: json['modelName'] as String? ?? '',
      type: (json['type'] as num?)?.toInt() ?? 0,
      adviseTagNames: (json['adviseTagNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      videos:
          (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SuggestHistoryImplToJson(
        _$SuggestHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'createTime': instance.createTime,
      'content': instance.content,
      'deviceIconUrl': instance.deviceIconUrl,
      'modelName': instance.modelName,
      'type': instance.type,
      'adviseTagNames': instance.adviseTagNames,
      'images': instance.images,
      'videos': instance.videos,
    };
