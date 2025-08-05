// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest_report_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestReportParamImpl _$$SuggestReportParamImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestReportParamImpl(
      appVersion: json['appVersion'] as String? ?? '',
      appVersionName: json['appVersionName'] as String? ?? '',
      title: json['title'] as String?,
      content: json['content'] as String?,
      contact: json['contact'] as String?,
      type: (json['type'] as num?)?.toInt() ?? 0,
      os: (json['os'] as num?)?.toInt() ?? 0,
      adviseType: (json['adviseType'] as num?)?.toInt() ?? 0,
      did: json['did'] as String? ?? '',
      model: json['model'] as String? ?? '',
      plugin: json['plugin'] as String? ?? '',
      adviseTagIds: json['adviseTagIds'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      videos:
          (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$SuggestReportParamImplToJson(
        _$SuggestReportParamImpl instance) =>
    <String, dynamic>{
      'appVersion': instance.appVersion,
      'appVersionName': instance.appVersionName,
      'title': instance.title,
      'content': instance.content,
      'contact': instance.contact,
      'type': instance.type,
      'os': instance.os,
      'adviseType': instance.adviseType,
      'did': instance.did,
      'model': instance.model,
      'plugin': instance.plugin,
      'adviseTagIds': instance.adviseTagIds,
      'images': instance.images,
      'videos': instance.videos,
    };
