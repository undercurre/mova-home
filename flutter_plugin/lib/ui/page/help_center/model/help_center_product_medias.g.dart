// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_center_product_medias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpCenterProductMedias _$HelpCenterProductMediasFromJson(
        Map<String, dynamic> json) =>
    HelpCenterProductMedias(
      productDesc: json['productDesc'] as String?,
      displayMediaList: (json['displayMediaList'] as List<dynamic>?)
          ?.map((e) => DisplayMediaList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HelpCenterProductMediasToJson(
    HelpCenterProductMedias instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('productDesc', instance.productDesc);
  writeNotNull('displayMediaList', instance.displayMediaList);
  return val;
}

DisplayMediaList _$DisplayMediaListFromJson(Map<String, dynamic> json) =>
    DisplayMediaList(
      id: json['id'] as String?,
      filePath: json['filePath'] as String?,
      fileName: json['fileName'] as String?,
      etag: json['etag'] as String?,
      mediaOrder: (json['mediaOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DisplayMediaListToJson(DisplayMediaList instance) {
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
