// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rn_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RNVersionModelImpl _$$RNVersionModelImplFromJson(Map<String, dynamic> json) =>
    _$RNVersionModelImpl(
      url: json['url'] as String?,
      version: (json['version'] as num?)?.toInt(),
      extensionId: json['extensionId'] as String?,
      md5: json['md5'] as String?,
      resPackageId: json['resPackageId'] as String?,
      resPackageVersion: (json['resPackageVersion'] as num?)?.toInt(),
      resPackageUrl: json['resPackageUrl'] as String?,
      resPackageZipMd5: json['resPackageZipMd5'] as String?,
      sourceCommonExtensionId: json['sourceCommonExtensionId'] as String?,
      sourceCommonPluginId: json['sourceCommonPluginId'] as String?,
      sourceCommonPluginVer: (json['sourceCommonPluginVer'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RNVersionModelImplToJson(
        _$RNVersionModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'version': instance.version,
      'extensionId': instance.extensionId,
      'md5': instance.md5,
      'resPackageId': instance.resPackageId,
      'resPackageVersion': instance.resPackageVersion,
      'resPackageUrl': instance.resPackageUrl,
      'resPackageZipMd5': instance.resPackageZipMd5,
      'sourceCommonExtensionId': instance.sourceCommonExtensionId,
      'sourceCommonPluginId': instance.sourceCommonPluginId,
      'sourceCommonPluginVer': instance.sourceCommonPluginVer,
    };
