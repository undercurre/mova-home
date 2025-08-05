// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_sound_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiSoundModelImpl _$$AiSoundModelImplFromJson(Map<String, dynamic> json) =>
    _$AiSoundModelImpl(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      linkUrl: json['linkUrl'] as String,
      title: json['title'] as String,
      button: json['button'] as String? ?? '',
      android: json['android'] == null
          ? null
          : SoundDetailModel.fromJson(json['android'] as Map<String, dynamic>),
      ios: json['ios'] == null
          ? null
          : SoundDetailModel.fromJson(json['ios'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AiSoundModelImplToJson(_$AiSoundModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'linkUrl': instance.linkUrl,
      'title': instance.title,
      'button': instance.button,
      'android': instance.android,
      'ios': instance.ios,
    };

_$SoundDetailModelImpl _$$SoundDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SoundDetailModelImpl(
      packageName: json['packageName'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$SoundDetailModelImplToJson(
        _$SoundDetailModelImpl instance) =>
    <String, dynamic>{
      'packageName': instance.packageName,
      'downloadUrl': instance.downloadUrl,
    };
