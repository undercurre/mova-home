
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'otc_info.freezed.dart';

part 'otc_info.g.dart';
@freezed
class OtcInfoRes with _$OtcInfoRes {
  const factory OtcInfoRes({
    final OtcInfo? otcInfo,
  }) = _OtcInfoRes;

  factory OtcInfoRes.fromJson(Map<String, dynamic> json) =>
      _$OtcInfoResFromJson(json);
}

@freezed
class OtcInfo with _$OtcInfo {
  const factory OtcInfo({
    final String? partner_id,
    final Params? params,
  }) = _OtcInfo;

  factory OtcInfo.fromJson(Map<String, dynamic> json) =>
      _$OtcInfoFromJson(json);
}

@freezed
class Params with _$Params {
  const factory Params({
    final String? hw_ver,
    final String? fw_ver,
    final String? model,
    final Ap? ap,
    final NetIf? netif,
  }) = _Params;

  factory Params.fromJson(Map<String, dynamic> json) =>
      _$ParamsFromJson(json);
}

@freezed
class Ap with _$Ap {
  const factory Ap({
    final String? siid,
    final String? bssid,
    final int? rssi,
  }) = _Ap;
  factory Ap.fromJson(Map<String, dynamic> json) =>
      _$ApFromJson(json);
}

@freezed
class NetIf with _$NetIf {
  const factory NetIf({
    final String? localIp,
    final String? mask,
    final String? gw,
  }) = _NetIf;
  factory NetIf.fromJson(Map<String, dynamic> json) =>
      _$NetIfFromJson(json);
}
