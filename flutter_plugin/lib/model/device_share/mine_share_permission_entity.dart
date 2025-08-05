import 'package:freezed_annotation/freezed_annotation.dart';

part 'mine_share_permission_entity.freezed.dart';
part 'mine_share_permission_entity.g.dart';

@freezed
class MineSharePermissionEntity with _$MineSharePermissionEntity {
  const factory MineSharePermissionEntity({
    String? permitKey,
    SharePermitInfo? permitInfo,
    bool? isOn,
  }) = _MineSharePermissionEntity;

  factory MineSharePermissionEntity.fromJson(Map<String, dynamic> json) =>
      _$MineSharePermissionEntityFromJson(json);
}

@freezed
class SharePermitInfo with _$SharePermitInfo {
  const factory SharePermitInfo({
    SharePermitImage? permitImage,
    Map<String, SharePermitDesc>? permitInfoDisplays,
  }) = _SharePermitInfo;

  factory SharePermitInfo.fromJson(Map<String, dynamic> json) =>
      _$SharePermitInfoFromJson(json);
}

@freezed
class SharePermitImage with _$SharePermitImage {
  const factory SharePermitImage({
    String? caption,
    int? height,
    int? width,
    String? imageUrl,
    String? smallImageUrl,
  }) = _SharePermitImage;

  factory SharePermitImage.fromJson(Map<String, dynamic> json) =>
      _$SharePermitImageFromJson(json);
}

@freezed
class SharePermitDesc with _$SharePermitDesc {
  const factory SharePermitDesc({
    String? permitTitle,
    String? permitExplain,
  }) = _SharePermitDesc;

  factory SharePermitDesc.fromJson(Map<String, dynamic> json) =>
      _$SharePermitDescFromJson(json);
}
