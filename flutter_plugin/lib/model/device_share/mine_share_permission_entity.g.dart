// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mine_share_permission_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MineSharePermissionEntityImpl _$$MineSharePermissionEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$MineSharePermissionEntityImpl(
      permitKey: json['permitKey'] as String?,
      permitInfo: json['permitInfo'] == null
          ? null
          : SharePermitInfo.fromJson(
              json['permitInfo'] as Map<String, dynamic>),
      isOn: json['isOn'] as bool?,
    );

Map<String, dynamic> _$$MineSharePermissionEntityImplToJson(
        _$MineSharePermissionEntityImpl instance) =>
    <String, dynamic>{
      'permitKey': instance.permitKey,
      'permitInfo': instance.permitInfo,
      'isOn': instance.isOn,
    };

_$SharePermitInfoImpl _$$SharePermitInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$SharePermitInfoImpl(
      permitImage: json['permitImage'] == null
          ? null
          : SharePermitImage.fromJson(
              json['permitImage'] as Map<String, dynamic>),
      permitInfoDisplays:
          (json['permitInfoDisplays'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, SharePermitDesc.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$$SharePermitInfoImplToJson(
        _$SharePermitInfoImpl instance) =>
    <String, dynamic>{
      'permitImage': instance.permitImage,
      'permitInfoDisplays': instance.permitInfoDisplays,
    };

_$SharePermitImageImpl _$$SharePermitImageImplFromJson(
        Map<String, dynamic> json) =>
    _$SharePermitImageImpl(
      caption: json['caption'] as String?,
      height: (json['height'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      smallImageUrl: json['smallImageUrl'] as String?,
    );

Map<String, dynamic> _$$SharePermitImageImplToJson(
        _$SharePermitImageImpl instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'height': instance.height,
      'width': instance.width,
      'imageUrl': instance.imageUrl,
      'smallImageUrl': instance.smallImageUrl,
    };

_$SharePermitDescImpl _$$SharePermitDescImplFromJson(
        Map<String, dynamic> json) =>
    _$SharePermitDescImpl(
      permitTitle: json['permitTitle'] as String?,
      permitExplain: json['permitExplain'] as String?,
    );

Map<String, dynamic> _$$SharePermitDescImplToJson(
        _$SharePermitDescImpl instance) =>
    <String, dynamic>{
      'permitTitle': instance.permitTitle,
      'permitExplain': instance.permitExplain,
    };
