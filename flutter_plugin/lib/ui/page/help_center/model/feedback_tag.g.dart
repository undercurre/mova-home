// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedBackTagImpl _$$FeedBackTagImplFromJson(Map<String, dynamic> json) =>
    _$FeedBackTagImpl(
      tagId: json['tagId'] as String? ?? '',
      tagName: json['tagName'] as String? ?? '',
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$$FeedBackTagImplToJson(_$FeedBackTagImpl instance) =>
    <String, dynamic>{
      'tagId': instance.tagId,
      'tagName': instance.tagName,
      'isSelected': instance.isSelected,
    };
