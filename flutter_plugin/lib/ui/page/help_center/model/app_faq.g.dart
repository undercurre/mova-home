// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_faq.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalizationDisplayMedia _$LocalizationDisplayMediaFromJson(
        Map<String, dynamic> json) =>
    LocalizationDisplayMedia(
      id: json['id'] as String?,
      filePath: json['filePath'] as String?,
      fileName: json['fileName'] as String?,
      etag: json['etag'] as String?,
      mediaOrder: (json['mediaOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LocalizationDisplayMediaToJson(
    LocalizationDisplayMedia instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('filePath', instance.filePath);
  writeNotNull('fileName', instance.fileName);
  writeNotNull('etag', instance.etag);
  writeNotNull('mediaOrder', instance.mediaOrder);
  return val;
}
