// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rn_debug_packages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RNDebugPackagesImpl _$$RNDebugPackagesImplFromJson(
        Map<String, dynamic> json) =>
    _$RNDebugPackagesImpl(
      ip: json['ip'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => Projects.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RNDebugPackagesImplToJson(
        _$RNDebugPackagesImpl instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'enable': instance.enable,
      'projects': instance.projects,
    };

_$ProjectsImpl _$$ProjectsImplFromJson(Map<String, dynamic> json) =>
    _$ProjectsImpl(
      packageName: json['packageName'] as String?,
      model: json['model'] as String?,
      id: (json['id'] as num?)?.toInt(),
      selected: json['selected'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProjectsImplToJson(_$ProjectsImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'model': instance.model,
      'id': instance.id,
      'selected': instance.selected,
    };
