// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otc_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtcInfoResImpl _$$OtcInfoResImplFromJson(Map<String, dynamic> json) =>
    _$OtcInfoResImpl(
      otcInfo: json['otcInfo'] == null
          ? null
          : OtcInfo.fromJson(json['otcInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OtcInfoResImplToJson(_$OtcInfoResImpl instance) =>
    <String, dynamic>{
      'otcInfo': instance.otcInfo,
    };

_$OtcInfoImpl _$$OtcInfoImplFromJson(Map<String, dynamic> json) =>
    _$OtcInfoImpl(
      partner_id: json['partner_id'] as String?,
      params: json['params'] == null
          ? null
          : Params.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OtcInfoImplToJson(_$OtcInfoImpl instance) =>
    <String, dynamic>{
      'partner_id': instance.partner_id,
      'params': instance.params,
    };

_$ParamsImpl _$$ParamsImplFromJson(Map<String, dynamic> json) => _$ParamsImpl(
      hw_ver: json['hw_ver'] as String?,
      fw_ver: json['fw_ver'] as String?,
      model: json['model'] as String?,
      ap: json['ap'] == null
          ? null
          : Ap.fromJson(json['ap'] as Map<String, dynamic>),
      netif: json['netif'] == null
          ? null
          : NetIf.fromJson(json['netif'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ParamsImplToJson(_$ParamsImpl instance) =>
    <String, dynamic>{
      'hw_ver': instance.hw_ver,
      'fw_ver': instance.fw_ver,
      'model': instance.model,
      'ap': instance.ap,
      'netif': instance.netif,
    };

_$ApImpl _$$ApImplFromJson(Map<String, dynamic> json) => _$ApImpl(
      siid: json['siid'] as String?,
      bssid: json['bssid'] as String?,
      rssi: (json['rssi'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApImplToJson(_$ApImpl instance) => <String, dynamic>{
      'siid': instance.siid,
      'bssid': instance.bssid,
      'rssi': instance.rssi,
    };

_$NetIfImpl _$$NetIfImplFromJson(Map<String, dynamic> json) => _$NetIfImpl(
      localIp: json['localIp'] as String?,
      mask: json['mask'] as String?,
      gw: json['gw'] as String?,
    );

Map<String, dynamic> _$$NetIfImplToJson(_$NetIfImpl instance) =>
    <String, dynamic>{
      'localIp': instance.localIp,
      'mask': instance.mask,
      'gw': instance.gw,
    };
