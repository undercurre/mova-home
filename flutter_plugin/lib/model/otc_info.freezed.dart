// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otc_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtcInfoRes _$OtcInfoResFromJson(Map<String, dynamic> json) {
  return _OtcInfoRes.fromJson(json);
}

/// @nodoc
mixin _$OtcInfoRes {
  OtcInfo? get otcInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtcInfoResCopyWith<OtcInfoRes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtcInfoResCopyWith<$Res> {
  factory $OtcInfoResCopyWith(
          OtcInfoRes value, $Res Function(OtcInfoRes) then) =
      _$OtcInfoResCopyWithImpl<$Res, OtcInfoRes>;
  @useResult
  $Res call({OtcInfo? otcInfo});

  $OtcInfoCopyWith<$Res>? get otcInfo;
}

/// @nodoc
class _$OtcInfoResCopyWithImpl<$Res, $Val extends OtcInfoRes>
    implements $OtcInfoResCopyWith<$Res> {
  _$OtcInfoResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otcInfo = freezed,
  }) {
    return _then(_value.copyWith(
      otcInfo: freezed == otcInfo
          ? _value.otcInfo
          : otcInfo // ignore: cast_nullable_to_non_nullable
              as OtcInfo?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OtcInfoCopyWith<$Res>? get otcInfo {
    if (_value.otcInfo == null) {
      return null;
    }

    return $OtcInfoCopyWith<$Res>(_value.otcInfo!, (value) {
      return _then(_value.copyWith(otcInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OtcInfoResImplCopyWith<$Res>
    implements $OtcInfoResCopyWith<$Res> {
  factory _$$OtcInfoResImplCopyWith(
          _$OtcInfoResImpl value, $Res Function(_$OtcInfoResImpl) then) =
      __$$OtcInfoResImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({OtcInfo? otcInfo});

  @override
  $OtcInfoCopyWith<$Res>? get otcInfo;
}

/// @nodoc
class __$$OtcInfoResImplCopyWithImpl<$Res>
    extends _$OtcInfoResCopyWithImpl<$Res, _$OtcInfoResImpl>
    implements _$$OtcInfoResImplCopyWith<$Res> {
  __$$OtcInfoResImplCopyWithImpl(
      _$OtcInfoResImpl _value, $Res Function(_$OtcInfoResImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otcInfo = freezed,
  }) {
    return _then(_$OtcInfoResImpl(
      otcInfo: freezed == otcInfo
          ? _value.otcInfo
          : otcInfo // ignore: cast_nullable_to_non_nullable
              as OtcInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtcInfoResImpl with DiagnosticableTreeMixin implements _OtcInfoRes {
  const _$OtcInfoResImpl({this.otcInfo});

  factory _$OtcInfoResImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtcInfoResImplFromJson(json);

  @override
  final OtcInfo? otcInfo;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OtcInfoRes(otcInfo: $otcInfo)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OtcInfoRes'))
      ..add(DiagnosticsProperty('otcInfo', otcInfo));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtcInfoResImpl &&
            (identical(other.otcInfo, otcInfo) || other.otcInfo == otcInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, otcInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtcInfoResImplCopyWith<_$OtcInfoResImpl> get copyWith =>
      __$$OtcInfoResImplCopyWithImpl<_$OtcInfoResImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtcInfoResImplToJson(
      this,
    );
  }
}

abstract class _OtcInfoRes implements OtcInfoRes {
  const factory _OtcInfoRes({final OtcInfo? otcInfo}) = _$OtcInfoResImpl;

  factory _OtcInfoRes.fromJson(Map<String, dynamic> json) =
      _$OtcInfoResImpl.fromJson;

  @override
  OtcInfo? get otcInfo;
  @override
  @JsonKey(ignore: true)
  _$$OtcInfoResImplCopyWith<_$OtcInfoResImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtcInfo _$OtcInfoFromJson(Map<String, dynamic> json) {
  return _OtcInfo.fromJson(json);
}

/// @nodoc
mixin _$OtcInfo {
  String? get partner_id => throw _privateConstructorUsedError;
  Params? get params => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtcInfoCopyWith<OtcInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtcInfoCopyWith<$Res> {
  factory $OtcInfoCopyWith(OtcInfo value, $Res Function(OtcInfo) then) =
      _$OtcInfoCopyWithImpl<$Res, OtcInfo>;
  @useResult
  $Res call({String? partner_id, Params? params});

  $ParamsCopyWith<$Res>? get params;
}

/// @nodoc
class _$OtcInfoCopyWithImpl<$Res, $Val extends OtcInfo>
    implements $OtcInfoCopyWith<$Res> {
  _$OtcInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partner_id = freezed,
    Object? params = freezed,
  }) {
    return _then(_value.copyWith(
      partner_id: freezed == partner_id
          ? _value.partner_id
          : partner_id // ignore: cast_nullable_to_non_nullable
              as String?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Params?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ParamsCopyWith<$Res>? get params {
    if (_value.params == null) {
      return null;
    }

    return $ParamsCopyWith<$Res>(_value.params!, (value) {
      return _then(_value.copyWith(params: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OtcInfoImplCopyWith<$Res> implements $OtcInfoCopyWith<$Res> {
  factory _$$OtcInfoImplCopyWith(
          _$OtcInfoImpl value, $Res Function(_$OtcInfoImpl) then) =
      __$$OtcInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? partner_id, Params? params});

  @override
  $ParamsCopyWith<$Res>? get params;
}

/// @nodoc
class __$$OtcInfoImplCopyWithImpl<$Res>
    extends _$OtcInfoCopyWithImpl<$Res, _$OtcInfoImpl>
    implements _$$OtcInfoImplCopyWith<$Res> {
  __$$OtcInfoImplCopyWithImpl(
      _$OtcInfoImpl _value, $Res Function(_$OtcInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? partner_id = freezed,
    Object? params = freezed,
  }) {
    return _then(_$OtcInfoImpl(
      partner_id: freezed == partner_id
          ? _value.partner_id
          : partner_id // ignore: cast_nullable_to_non_nullable
              as String?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Params?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtcInfoImpl with DiagnosticableTreeMixin implements _OtcInfo {
  const _$OtcInfoImpl({this.partner_id, this.params});

  factory _$OtcInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtcInfoImplFromJson(json);

  @override
  final String? partner_id;
  @override
  final Params? params;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OtcInfo(partner_id: $partner_id, params: $params)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OtcInfo'))
      ..add(DiagnosticsProperty('partner_id', partner_id))
      ..add(DiagnosticsProperty('params', params));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtcInfoImpl &&
            (identical(other.partner_id, partner_id) ||
                other.partner_id == partner_id) &&
            (identical(other.params, params) || other.params == params));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, partner_id, params);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtcInfoImplCopyWith<_$OtcInfoImpl> get copyWith =>
      __$$OtcInfoImplCopyWithImpl<_$OtcInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtcInfoImplToJson(
      this,
    );
  }
}

abstract class _OtcInfo implements OtcInfo {
  const factory _OtcInfo({final String? partner_id, final Params? params}) =
      _$OtcInfoImpl;

  factory _OtcInfo.fromJson(Map<String, dynamic> json) = _$OtcInfoImpl.fromJson;

  @override
  String? get partner_id;
  @override
  Params? get params;
  @override
  @JsonKey(ignore: true)
  _$$OtcInfoImplCopyWith<_$OtcInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Params _$ParamsFromJson(Map<String, dynamic> json) {
  return _Params.fromJson(json);
}

/// @nodoc
mixin _$Params {
  String? get hw_ver => throw _privateConstructorUsedError;
  String? get fw_ver => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  Ap? get ap => throw _privateConstructorUsedError;
  NetIf? get netif => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParamsCopyWith<Params> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParamsCopyWith<$Res> {
  factory $ParamsCopyWith(Params value, $Res Function(Params) then) =
      _$ParamsCopyWithImpl<$Res, Params>;
  @useResult
  $Res call(
      {String? hw_ver, String? fw_ver, String? model, Ap? ap, NetIf? netif});

  $ApCopyWith<$Res>? get ap;
  $NetIfCopyWith<$Res>? get netif;
}

/// @nodoc
class _$ParamsCopyWithImpl<$Res, $Val extends Params>
    implements $ParamsCopyWith<$Res> {
  _$ParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hw_ver = freezed,
    Object? fw_ver = freezed,
    Object? model = freezed,
    Object? ap = freezed,
    Object? netif = freezed,
  }) {
    return _then(_value.copyWith(
      hw_ver: freezed == hw_ver
          ? _value.hw_ver
          : hw_ver // ignore: cast_nullable_to_non_nullable
              as String?,
      fw_ver: freezed == fw_ver
          ? _value.fw_ver
          : fw_ver // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      ap: freezed == ap
          ? _value.ap
          : ap // ignore: cast_nullable_to_non_nullable
              as Ap?,
      netif: freezed == netif
          ? _value.netif
          : netif // ignore: cast_nullable_to_non_nullable
              as NetIf?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApCopyWith<$Res>? get ap {
    if (_value.ap == null) {
      return null;
    }

    return $ApCopyWith<$Res>(_value.ap!, (value) {
      return _then(_value.copyWith(ap: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NetIfCopyWith<$Res>? get netif {
    if (_value.netif == null) {
      return null;
    }

    return $NetIfCopyWith<$Res>(_value.netif!, (value) {
      return _then(_value.copyWith(netif: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ParamsImplCopyWith<$Res> implements $ParamsCopyWith<$Res> {
  factory _$$ParamsImplCopyWith(
          _$ParamsImpl value, $Res Function(_$ParamsImpl) then) =
      __$$ParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? hw_ver, String? fw_ver, String? model, Ap? ap, NetIf? netif});

  @override
  $ApCopyWith<$Res>? get ap;
  @override
  $NetIfCopyWith<$Res>? get netif;
}

/// @nodoc
class __$$ParamsImplCopyWithImpl<$Res>
    extends _$ParamsCopyWithImpl<$Res, _$ParamsImpl>
    implements _$$ParamsImplCopyWith<$Res> {
  __$$ParamsImplCopyWithImpl(
      _$ParamsImpl _value, $Res Function(_$ParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hw_ver = freezed,
    Object? fw_ver = freezed,
    Object? model = freezed,
    Object? ap = freezed,
    Object? netif = freezed,
  }) {
    return _then(_$ParamsImpl(
      hw_ver: freezed == hw_ver
          ? _value.hw_ver
          : hw_ver // ignore: cast_nullable_to_non_nullable
              as String?,
      fw_ver: freezed == fw_ver
          ? _value.fw_ver
          : fw_ver // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      ap: freezed == ap
          ? _value.ap
          : ap // ignore: cast_nullable_to_non_nullable
              as Ap?,
      netif: freezed == netif
          ? _value.netif
          : netif // ignore: cast_nullable_to_non_nullable
              as NetIf?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParamsImpl with DiagnosticableTreeMixin implements _Params {
  const _$ParamsImpl(
      {this.hw_ver, this.fw_ver, this.model, this.ap, this.netif});

  factory _$ParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParamsImplFromJson(json);

  @override
  final String? hw_ver;
  @override
  final String? fw_ver;
  @override
  final String? model;
  @override
  final Ap? ap;
  @override
  final NetIf? netif;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Params(hw_ver: $hw_ver, fw_ver: $fw_ver, model: $model, ap: $ap, netif: $netif)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Params'))
      ..add(DiagnosticsProperty('hw_ver', hw_ver))
      ..add(DiagnosticsProperty('fw_ver', fw_ver))
      ..add(DiagnosticsProperty('model', model))
      ..add(DiagnosticsProperty('ap', ap))
      ..add(DiagnosticsProperty('netif', netif));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParamsImpl &&
            (identical(other.hw_ver, hw_ver) || other.hw_ver == hw_ver) &&
            (identical(other.fw_ver, fw_ver) || other.fw_ver == fw_ver) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.ap, ap) || other.ap == ap) &&
            (identical(other.netif, netif) || other.netif == netif));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, hw_ver, fw_ver, model, ap, netif);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParamsImplCopyWith<_$ParamsImpl> get copyWith =>
      __$$ParamsImplCopyWithImpl<_$ParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParamsImplToJson(
      this,
    );
  }
}

abstract class _Params implements Params {
  const factory _Params(
      {final String? hw_ver,
      final String? fw_ver,
      final String? model,
      final Ap? ap,
      final NetIf? netif}) = _$ParamsImpl;

  factory _Params.fromJson(Map<String, dynamic> json) = _$ParamsImpl.fromJson;

  @override
  String? get hw_ver;
  @override
  String? get fw_ver;
  @override
  String? get model;
  @override
  Ap? get ap;
  @override
  NetIf? get netif;
  @override
  @JsonKey(ignore: true)
  _$$ParamsImplCopyWith<_$ParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ap _$ApFromJson(Map<String, dynamic> json) {
  return _Ap.fromJson(json);
}

/// @nodoc
mixin _$Ap {
  String? get siid => throw _privateConstructorUsedError;
  String? get bssid => throw _privateConstructorUsedError;
  int? get rssi => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApCopyWith<Ap> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApCopyWith<$Res> {
  factory $ApCopyWith(Ap value, $Res Function(Ap) then) =
      _$ApCopyWithImpl<$Res, Ap>;
  @useResult
  $Res call({String? siid, String? bssid, int? rssi});
}

/// @nodoc
class _$ApCopyWithImpl<$Res, $Val extends Ap> implements $ApCopyWith<$Res> {
  _$ApCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siid = freezed,
    Object? bssid = freezed,
    Object? rssi = freezed,
  }) {
    return _then(_value.copyWith(
      siid: freezed == siid
          ? _value.siid
          : siid // ignore: cast_nullable_to_non_nullable
              as String?,
      bssid: freezed == bssid
          ? _value.bssid
          : bssid // ignore: cast_nullable_to_non_nullable
              as String?,
      rssi: freezed == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApImplCopyWith<$Res> implements $ApCopyWith<$Res> {
  factory _$$ApImplCopyWith(_$ApImpl value, $Res Function(_$ApImpl) then) =
      __$$ApImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? siid, String? bssid, int? rssi});
}

/// @nodoc
class __$$ApImplCopyWithImpl<$Res> extends _$ApCopyWithImpl<$Res, _$ApImpl>
    implements _$$ApImplCopyWith<$Res> {
  __$$ApImplCopyWithImpl(_$ApImpl _value, $Res Function(_$ApImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? siid = freezed,
    Object? bssid = freezed,
    Object? rssi = freezed,
  }) {
    return _then(_$ApImpl(
      siid: freezed == siid
          ? _value.siid
          : siid // ignore: cast_nullable_to_non_nullable
              as String?,
      bssid: freezed == bssid
          ? _value.bssid
          : bssid // ignore: cast_nullable_to_non_nullable
              as String?,
      rssi: freezed == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApImpl with DiagnosticableTreeMixin implements _Ap {
  const _$ApImpl({this.siid, this.bssid, this.rssi});

  factory _$ApImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApImplFromJson(json);

  @override
  final String? siid;
  @override
  final String? bssid;
  @override
  final int? rssi;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Ap(siid: $siid, bssid: $bssid, rssi: $rssi)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Ap'))
      ..add(DiagnosticsProperty('siid', siid))
      ..add(DiagnosticsProperty('bssid', bssid))
      ..add(DiagnosticsProperty('rssi', rssi));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApImpl &&
            (identical(other.siid, siid) || other.siid == siid) &&
            (identical(other.bssid, bssid) || other.bssid == bssid) &&
            (identical(other.rssi, rssi) || other.rssi == rssi));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, siid, bssid, rssi);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApImplCopyWith<_$ApImpl> get copyWith =>
      __$$ApImplCopyWithImpl<_$ApImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApImplToJson(
      this,
    );
  }
}

abstract class _Ap implements Ap {
  const factory _Ap(
      {final String? siid, final String? bssid, final int? rssi}) = _$ApImpl;

  factory _Ap.fromJson(Map<String, dynamic> json) = _$ApImpl.fromJson;

  @override
  String? get siid;
  @override
  String? get bssid;
  @override
  int? get rssi;
  @override
  @JsonKey(ignore: true)
  _$$ApImplCopyWith<_$ApImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetIf _$NetIfFromJson(Map<String, dynamic> json) {
  return _NetIf.fromJson(json);
}

/// @nodoc
mixin _$NetIf {
  String? get localIp => throw _privateConstructorUsedError;
  String? get mask => throw _privateConstructorUsedError;
  String? get gw => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetIfCopyWith<NetIf> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetIfCopyWith<$Res> {
  factory $NetIfCopyWith(NetIf value, $Res Function(NetIf) then) =
      _$NetIfCopyWithImpl<$Res, NetIf>;
  @useResult
  $Res call({String? localIp, String? mask, String? gw});
}

/// @nodoc
class _$NetIfCopyWithImpl<$Res, $Val extends NetIf>
    implements $NetIfCopyWith<$Res> {
  _$NetIfCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localIp = freezed,
    Object? mask = freezed,
    Object? gw = freezed,
  }) {
    return _then(_value.copyWith(
      localIp: freezed == localIp
          ? _value.localIp
          : localIp // ignore: cast_nullable_to_non_nullable
              as String?,
      mask: freezed == mask
          ? _value.mask
          : mask // ignore: cast_nullable_to_non_nullable
              as String?,
      gw: freezed == gw
          ? _value.gw
          : gw // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetIfImplCopyWith<$Res> implements $NetIfCopyWith<$Res> {
  factory _$$NetIfImplCopyWith(
          _$NetIfImpl value, $Res Function(_$NetIfImpl) then) =
      __$$NetIfImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? localIp, String? mask, String? gw});
}

/// @nodoc
class __$$NetIfImplCopyWithImpl<$Res>
    extends _$NetIfCopyWithImpl<$Res, _$NetIfImpl>
    implements _$$NetIfImplCopyWith<$Res> {
  __$$NetIfImplCopyWithImpl(
      _$NetIfImpl _value, $Res Function(_$NetIfImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localIp = freezed,
    Object? mask = freezed,
    Object? gw = freezed,
  }) {
    return _then(_$NetIfImpl(
      localIp: freezed == localIp
          ? _value.localIp
          : localIp // ignore: cast_nullable_to_non_nullable
              as String?,
      mask: freezed == mask
          ? _value.mask
          : mask // ignore: cast_nullable_to_non_nullable
              as String?,
      gw: freezed == gw
          ? _value.gw
          : gw // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetIfImpl with DiagnosticableTreeMixin implements _NetIf {
  const _$NetIfImpl({this.localIp, this.mask, this.gw});

  factory _$NetIfImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetIfImplFromJson(json);

  @override
  final String? localIp;
  @override
  final String? mask;
  @override
  final String? gw;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NetIf(localIp: $localIp, mask: $mask, gw: $gw)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NetIf'))
      ..add(DiagnosticsProperty('localIp', localIp))
      ..add(DiagnosticsProperty('mask', mask))
      ..add(DiagnosticsProperty('gw', gw));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetIfImpl &&
            (identical(other.localIp, localIp) || other.localIp == localIp) &&
            (identical(other.mask, mask) || other.mask == mask) &&
            (identical(other.gw, gw) || other.gw == gw));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, localIp, mask, gw);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetIfImplCopyWith<_$NetIfImpl> get copyWith =>
      __$$NetIfImplCopyWithImpl<_$NetIfImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetIfImplToJson(
      this,
    );
  }
}

abstract class _NetIf implements NetIf {
  const factory _NetIf(
      {final String? localIp,
      final String? mask,
      final String? gw}) = _$NetIfImpl;

  factory _NetIf.fromJson(Map<String, dynamic> json) = _$NetIfImpl.fromJson;

  @override
  String? get localIp;
  @override
  String? get mask;
  @override
  String? get gw;
  @override
  @JsonKey(ignore: true)
  _$$NetIfImplCopyWith<_$NetIfImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
