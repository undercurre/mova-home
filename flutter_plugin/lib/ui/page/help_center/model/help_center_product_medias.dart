import 'package:json_annotation/json_annotation.dart';

part 'help_center_product_medias.g.dart';

@JsonSerializable(includeIfNull: false)
class HelpCenterProductMedias {
  final String? productDesc;
  final List<DisplayMediaList>? displayMediaList;

  HelpCenterProductMedias({
    this.productDesc,
    this.displayMediaList,
  });

  factory HelpCenterProductMedias.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterProductMediasFromJson(json);

  Map<String, dynamic> toJson() => _$HelpCenterProductMediasToJson(this);
}

@JsonSerializable(includeIfNull: false)
class DisplayMediaList {
  final String? id;
  final String? filePath;
  final String? fileName;
  final String? etag;
  final int? mediaOrder;

  DisplayMediaList({
    this.id,
    this.filePath,
    this.fileName,
    this.etag,
    this.mediaOrder,
  });

  factory DisplayMediaList.fromJson(Map<String, dynamic> json) =>
      _$DisplayMediaListFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayMediaListToJson(this);
}
