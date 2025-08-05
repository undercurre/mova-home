// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smscode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SmsCodeSocialReq _$SmsCodeSocialReqFromJson(Map<String, dynamic> json) {
  return _SmsCodeSocialReq.fromJson(json);
}

/// @nodoc
mixin _$SmsCodeSocialReq {
  String get phone => throw _privateConstructorUsedError;
  String get phoneCode => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get sig => throw _privateConstructorUsedError;
  String get socialUUid => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmsCodeSocialReqCopyWith<SmsCodeSocialReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsCodeSocialReqCopyWith<$Res> {
  factory $SmsCodeSocialReqCopyWith(
          SmsCodeSocialReq value, $Res Function(SmsCodeSocialReq) then) =
      _$SmsCodeSocialReqCopyWithImpl<$Res, SmsCodeSocialReq>;
  @useResult
  $Res call(
      {String phone,
      String phoneCode,
      String lang,
      String token,
      String sessionId,
      String sig,
      String socialUUid,
      String source});
}

/// @nodoc
class _$SmsCodeSocialReqCopyWithImpl<$Res, $Val extends SmsCodeSocialReq>
    implements $SmsCodeSocialReqCopyWith<$Res> {
  _$SmsCodeSocialReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? phoneCode = null,
    Object? lang = null,
    Object? token = null,
    Object? sessionId = null,
    Object? sig = null,
    Object? socialUUid = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: null == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sig: null == sig
          ? _value.sig
          : sig // ignore: cast_nullable_to_non_nullable
              as String,
      socialUUid: null == socialUUid
          ? _value.socialUUid
          : socialUUid // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmsCodeSocialReqImplCopyWith<$Res>
    implements $SmsCodeSocialReqCopyWith<$Res> {
  factory _$$SmsCodeSocialReqImplCopyWith(_$SmsCodeSocialReqImpl value,
          $Res Function(_$SmsCodeSocialReqImpl) then) =
      __$$SmsCodeSocialReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String phone,
      String phoneCode,
      String lang,
      String token,
      String sessionId,
      String sig,
      String socialUUid,
      String source});
}

/// @nodoc
class __$$SmsCodeSocialReqImplCopyWithImpl<$Res>
    extends _$SmsCodeSocialReqCopyWithImpl<$Res, _$SmsCodeSocialReqImpl>
    implements _$$SmsCodeSocialReqImplCopyWith<$Res> {
  __$$SmsCodeSocialReqImplCopyWithImpl(_$SmsCodeSocialReqImpl _value,
      $Res Function(_$SmsCodeSocialReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? phoneCode = null,
    Object? lang = null,
    Object? token = null,
    Object? sessionId = null,
    Object? sig = null,
    Object? socialUUid = null,
    Object? source = null,
  }) {
    return _then(_$SmsCodeSocialReqImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: null == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sig: null == sig
          ? _value.sig
          : sig // ignore: cast_nullable_to_non_nullable
              as String,
      socialUUid: null == socialUUid
          ? _value.socialUUid
          : socialUUid // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmsCodeSocialReqImpl
    with DiagnosticableTreeMixin
    implements _SmsCodeSocialReq {
  const _$SmsCodeSocialReqImpl(
      {required this.phone,
      required this.phoneCode,
      required this.lang,
      required this.token,
      required this.sessionId,
      required this.sig,
      required this.socialUUid,
      required this.source});

  factory _$SmsCodeSocialReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsCodeSocialReqImplFromJson(json);

  @override
  final String phone;
  @override
  final String phoneCode;
  @override
  final String lang;
  @override
  final String token;
  @override
  final String sessionId;
  @override
  final String sig;
  @override
  final String socialUUid;
  @override
  final String source;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SmsCodeSocialReq(phone: $phone, phoneCode: $phoneCode, lang: $lang, token: $token, sessionId: $sessionId, sig: $sig, socialUUid: $socialUUid, source: $source)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SmsCodeSocialReq'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('phoneCode', phoneCode))
      ..add(DiagnosticsProperty('lang', lang))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('sessionId', sessionId))
      ..add(DiagnosticsProperty('sig', sig))
      ..add(DiagnosticsProperty('socialUUid', socialUUid))
      ..add(DiagnosticsProperty('source', source));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsCodeSocialReqImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sig, sig) || other.sig == sig) &&
            (identical(other.socialUUid, socialUUid) ||
                other.socialUUid == socialUUid) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, phone, phoneCode, lang, token,
      sessionId, sig, socialUUid, source);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsCodeSocialReqImplCopyWith<_$SmsCodeSocialReqImpl> get copyWith =>
      __$$SmsCodeSocialReqImplCopyWithImpl<_$SmsCodeSocialReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsCodeSocialReqImplToJson(
      this,
    );
  }
}

abstract class _SmsCodeSocialReq implements SmsCodeSocialReq {
  const factory _SmsCodeSocialReq(
      {required final String phone,
      required final String phoneCode,
      required final String lang,
      required final String token,
      required final String sessionId,
      required final String sig,
      required final String socialUUid,
      required final String source}) = _$SmsCodeSocialReqImpl;

  factory _SmsCodeSocialReq.fromJson(Map<String, dynamic> json) =
      _$SmsCodeSocialReqImpl.fromJson;

  @override
  String get phone;
  @override
  String get phoneCode;
  @override
  String get lang;
  @override
  String get token;
  @override
  String get sessionId;
  @override
  String get sig;
  @override
  String get socialUUid;
  @override
  String get source;
  @override
  @JsonKey(ignore: true)
  _$$SmsCodeSocialReqImplCopyWith<_$SmsCodeSocialReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmsCodeRes _$SmsCodeResFromJson(Map<String, dynamic> json) {
  return _SmsCodeRes.fromJson(json);
}

/// @nodoc
mixin _$SmsCodeRes {
  String? get codeKey => throw _privateConstructorUsedError;
  int? get maxSends => throw _privateConstructorUsedError;
  int? get resetIn => throw _privateConstructorUsedError;
  int? get interval => throw _privateConstructorUsedError;
  int? get expireIn => throw _privateConstructorUsedError;
  int? get remains => throw _privateConstructorUsedError;
  bool? get unregistered => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmsCodeResCopyWith<SmsCodeRes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsCodeResCopyWith<$Res> {
  factory $SmsCodeResCopyWith(
          SmsCodeRes value, $Res Function(SmsCodeRes) then) =
      _$SmsCodeResCopyWithImpl<$Res, SmsCodeRes>;
  @useResult
  $Res call(
      {String? codeKey,
      int? maxSends,
      int? resetIn,
      int? interval,
      int? expireIn,
      int? remains,
      bool? unregistered});
}

/// @nodoc
class _$SmsCodeResCopyWithImpl<$Res, $Val extends SmsCodeRes>
    implements $SmsCodeResCopyWith<$Res> {
  _$SmsCodeResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = freezed,
    Object? maxSends = freezed,
    Object? resetIn = freezed,
    Object? interval = freezed,
    Object? expireIn = freezed,
    Object? remains = freezed,
    Object? unregistered = freezed,
  }) {
    return _then(_value.copyWith(
      codeKey: freezed == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSends: freezed == maxSends
          ? _value.maxSends
          : maxSends // ignore: cast_nullable_to_non_nullable
              as int?,
      resetIn: freezed == resetIn
          ? _value.resetIn
          : resetIn // ignore: cast_nullable_to_non_nullable
              as int?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int?,
      expireIn: freezed == expireIn
          ? _value.expireIn
          : expireIn // ignore: cast_nullable_to_non_nullable
              as int?,
      remains: freezed == remains
          ? _value.remains
          : remains // ignore: cast_nullable_to_non_nullable
              as int?,
      unregistered: freezed == unregistered
          ? _value.unregistered
          : unregistered // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmsCodeResImplCopyWith<$Res>
    implements $SmsCodeResCopyWith<$Res> {
  factory _$$SmsCodeResImplCopyWith(
          _$SmsCodeResImpl value, $Res Function(_$SmsCodeResImpl) then) =
      __$$SmsCodeResImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? codeKey,
      int? maxSends,
      int? resetIn,
      int? interval,
      int? expireIn,
      int? remains,
      bool? unregistered});
}

/// @nodoc
class __$$SmsCodeResImplCopyWithImpl<$Res>
    extends _$SmsCodeResCopyWithImpl<$Res, _$SmsCodeResImpl>
    implements _$$SmsCodeResImplCopyWith<$Res> {
  __$$SmsCodeResImplCopyWithImpl(
      _$SmsCodeResImpl _value, $Res Function(_$SmsCodeResImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = freezed,
    Object? maxSends = freezed,
    Object? resetIn = freezed,
    Object? interval = freezed,
    Object? expireIn = freezed,
    Object? remains = freezed,
    Object? unregistered = freezed,
  }) {
    return _then(_$SmsCodeResImpl(
      codeKey: freezed == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSends: freezed == maxSends
          ? _value.maxSends
          : maxSends // ignore: cast_nullable_to_non_nullable
              as int?,
      resetIn: freezed == resetIn
          ? _value.resetIn
          : resetIn // ignore: cast_nullable_to_non_nullable
              as int?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int?,
      expireIn: freezed == expireIn
          ? _value.expireIn
          : expireIn // ignore: cast_nullable_to_non_nullable
              as int?,
      remains: freezed == remains
          ? _value.remains
          : remains // ignore: cast_nullable_to_non_nullable
              as int?,
      unregistered: freezed == unregistered
          ? _value.unregistered
          : unregistered // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmsCodeResImpl with DiagnosticableTreeMixin implements _SmsCodeRes {
  const _$SmsCodeResImpl(
      {this.codeKey,
      this.maxSends,
      this.resetIn,
      this.interval,
      this.expireIn,
      this.remains,
      this.unregistered});

  factory _$SmsCodeResImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsCodeResImplFromJson(json);

  @override
  final String? codeKey;
  @override
  final int? maxSends;
  @override
  final int? resetIn;
  @override
  final int? interval;
  @override
  final int? expireIn;
  @override
  final int? remains;
  @override
  final bool? unregistered;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SmsCodeRes(codeKey: $codeKey, maxSends: $maxSends, resetIn: $resetIn, interval: $interval, expireIn: $expireIn, remains: $remains, unregistered: $unregistered)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SmsCodeRes'))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('maxSends', maxSends))
      ..add(DiagnosticsProperty('resetIn', resetIn))
      ..add(DiagnosticsProperty('interval', interval))
      ..add(DiagnosticsProperty('expireIn', expireIn))
      ..add(DiagnosticsProperty('remains', remains))
      ..add(DiagnosticsProperty('unregistered', unregistered));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsCodeResImpl &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.maxSends, maxSends) ||
                other.maxSends == maxSends) &&
            (identical(other.resetIn, resetIn) || other.resetIn == resetIn) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.expireIn, expireIn) ||
                other.expireIn == expireIn) &&
            (identical(other.remains, remains) || other.remains == remains) &&
            (identical(other.unregistered, unregistered) ||
                other.unregistered == unregistered));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, codeKey, maxSends, resetIn,
      interval, expireIn, remains, unregistered);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsCodeResImplCopyWith<_$SmsCodeResImpl> get copyWith =>
      __$$SmsCodeResImplCopyWithImpl<_$SmsCodeResImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsCodeResImplToJson(
      this,
    );
  }
}

abstract class _SmsCodeRes implements SmsCodeRes {
  const factory _SmsCodeRes(
      {final String? codeKey,
      final int? maxSends,
      final int? resetIn,
      final int? interval,
      final int? expireIn,
      final int? remains,
      final bool? unregistered}) = _$SmsCodeResImpl;

  factory _SmsCodeRes.fromJson(Map<String, dynamic> json) =
      _$SmsCodeResImpl.fromJson;

  @override
  String? get codeKey;
  @override
  int? get maxSends;
  @override
  int? get resetIn;
  @override
  int? get interval;
  @override
  int? get expireIn;
  @override
  int? get remains;
  @override
  bool? get unregistered;
  @override
  @JsonKey(ignore: true)
  _$$SmsCodeResImplCopyWith<_$SmsCodeResImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmsGetCodeRes _$SmsGetCodeResFromJson(Map<String, dynamic> json) {
  return _SmsGetCodeRes.fromJson(json);
}

/// @nodoc
mixin _$SmsGetCodeRes {
  String? get codeKey => throw _privateConstructorUsedError;
  int? get expireIn => throw _privateConstructorUsedError;
  int? get interval => throw _privateConstructorUsedError;
  int? get maximum => throw _privateConstructorUsedError;
  int? get remains => throw _privateConstructorUsedError;
  int? get resetIn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmsGetCodeResCopyWith<SmsGetCodeRes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsGetCodeResCopyWith<$Res> {
  factory $SmsGetCodeResCopyWith(
          SmsGetCodeRes value, $Res Function(SmsGetCodeRes) then) =
      _$SmsGetCodeResCopyWithImpl<$Res, SmsGetCodeRes>;
  @useResult
  $Res call(
      {String? codeKey,
      int? expireIn,
      int? interval,
      int? maximum,
      int? remains,
      int? resetIn});
}

/// @nodoc
class _$SmsGetCodeResCopyWithImpl<$Res, $Val extends SmsGetCodeRes>
    implements $SmsGetCodeResCopyWith<$Res> {
  _$SmsGetCodeResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = freezed,
    Object? expireIn = freezed,
    Object? interval = freezed,
    Object? maximum = freezed,
    Object? remains = freezed,
    Object? resetIn = freezed,
  }) {
    return _then(_value.copyWith(
      codeKey: freezed == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String?,
      expireIn: freezed == expireIn
          ? _value.expireIn
          : expireIn // ignore: cast_nullable_to_non_nullable
              as int?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int?,
      maximum: freezed == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as int?,
      remains: freezed == remains
          ? _value.remains
          : remains // ignore: cast_nullable_to_non_nullable
              as int?,
      resetIn: freezed == resetIn
          ? _value.resetIn
          : resetIn // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmsGetCodeResImplCopyWith<$Res>
    implements $SmsGetCodeResCopyWith<$Res> {
  factory _$$SmsGetCodeResImplCopyWith(
          _$SmsGetCodeResImpl value, $Res Function(_$SmsGetCodeResImpl) then) =
      __$$SmsGetCodeResImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? codeKey,
      int? expireIn,
      int? interval,
      int? maximum,
      int? remains,
      int? resetIn});
}

/// @nodoc
class __$$SmsGetCodeResImplCopyWithImpl<$Res>
    extends _$SmsGetCodeResCopyWithImpl<$Res, _$SmsGetCodeResImpl>
    implements _$$SmsGetCodeResImplCopyWith<$Res> {
  __$$SmsGetCodeResImplCopyWithImpl(
      _$SmsGetCodeResImpl _value, $Res Function(_$SmsGetCodeResImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = freezed,
    Object? expireIn = freezed,
    Object? interval = freezed,
    Object? maximum = freezed,
    Object? remains = freezed,
    Object? resetIn = freezed,
  }) {
    return _then(_$SmsGetCodeResImpl(
      codeKey: freezed == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String?,
      expireIn: freezed == expireIn
          ? _value.expireIn
          : expireIn // ignore: cast_nullable_to_non_nullable
              as int?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int?,
      maximum: freezed == maximum
          ? _value.maximum
          : maximum // ignore: cast_nullable_to_non_nullable
              as int?,
      remains: freezed == remains
          ? _value.remains
          : remains // ignore: cast_nullable_to_non_nullable
              as int?,
      resetIn: freezed == resetIn
          ? _value.resetIn
          : resetIn // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmsGetCodeResImpl
    with DiagnosticableTreeMixin
    implements _SmsGetCodeRes {
  const _$SmsGetCodeResImpl(
      {this.codeKey,
      this.expireIn,
      this.interval,
      this.maximum,
      this.remains,
      this.resetIn});

  factory _$SmsGetCodeResImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsGetCodeResImplFromJson(json);

  @override
  final String? codeKey;
  @override
  final int? expireIn;
  @override
  final int? interval;
  @override
  final int? maximum;
  @override
  final int? remains;
  @override
  final int? resetIn;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SmsGetCodeRes(codeKey: $codeKey, expireIn: $expireIn, interval: $interval, maximum: $maximum, remains: $remains, resetIn: $resetIn)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SmsGetCodeRes'))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('expireIn', expireIn))
      ..add(DiagnosticsProperty('interval', interval))
      ..add(DiagnosticsProperty('maximum', maximum))
      ..add(DiagnosticsProperty('remains', remains))
      ..add(DiagnosticsProperty('resetIn', resetIn));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsGetCodeResImpl &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.expireIn, expireIn) ||
                other.expireIn == expireIn) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.maximum, maximum) || other.maximum == maximum) &&
            (identical(other.remains, remains) || other.remains == remains) &&
            (identical(other.resetIn, resetIn) || other.resetIn == resetIn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, codeKey, expireIn, interval, maximum, remains, resetIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsGetCodeResImplCopyWith<_$SmsGetCodeResImpl> get copyWith =>
      __$$SmsGetCodeResImplCopyWithImpl<_$SmsGetCodeResImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsGetCodeResImplToJson(
      this,
    );
  }
}

abstract class _SmsGetCodeRes implements SmsGetCodeRes {
  const factory _SmsGetCodeRes(
      {final String? codeKey,
      final int? expireIn,
      final int? interval,
      final int? maximum,
      final int? remains,
      final int? resetIn}) = _$SmsGetCodeResImpl;

  factory _SmsGetCodeRes.fromJson(Map<String, dynamic> json) =
      _$SmsGetCodeResImpl.fromJson;

  @override
  String? get codeKey;
  @override
  int? get expireIn;
  @override
  int? get interval;
  @override
  int? get maximum;
  @override
  int? get remains;
  @override
  int? get resetIn;
  @override
  @JsonKey(ignore: true)
  _$$SmsGetCodeResImplCopyWith<_$SmsGetCodeResImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmsTrCodeRes _$SmsTrCodeResFromJson(Map<String, dynamic> json) {
  return _SmsTrCodeRes.fromJson(json);
}

/// @nodoc
mixin _$SmsTrCodeRes {
  String? get codeKey => throw _privateConstructorUsedError;
  String? get maxSends => throw _privateConstructorUsedError;
  String? get resetIn => throw _privateConstructorUsedError;
  String? get interval => throw _privateConstructorUsedError;
  String? get expireIn => throw _privateConstructorUsedError;
  String? get remains => throw _privateConstructorUsedError;
  bool? get unregistered => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SmsTrCodeResCopyWith<SmsTrCodeRes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsTrCodeResCopyWith<$Res> {
  factory $SmsTrCodeResCopyWith(
          SmsTrCodeRes value, $Res Function(SmsTrCodeRes) then) =
      _$SmsTrCodeResCopyWithImpl<$Res, SmsTrCodeRes>;
  @useResult
  $Res call(
      {String? codeKey,
      String? maxSends,
      String? resetIn,
      String? interval,
      String? expireIn,
      String? remains,
      bool? unregistered});
}

/// @nodoc
class _$SmsTrCodeResCopyWithImpl<$Res, $Val extends SmsTrCodeRes>
    implements $SmsTrCodeResCopyWith<$Res> {
  _$SmsTrCodeResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = freezed,
    Object? maxSends = freezed,
    Object? resetIn = freezed,
    Object? interval = freezed,
    Object? expireIn = freezed,
    Object? remains = freezed,
    Object? unregistered = freezed,
  }) {
    return _then(_value.copyWith(
      codeKey: freezed == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSends: freezed == maxSends
          ? _value.maxSends
          : maxSends // ignore: cast_nullable_to_non_nullable
              as String?,
      resetIn: freezed == resetIn
          ? _value.resetIn
          : resetIn // ignore: cast_nullable_to_non_nullable
              as String?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String?,
      expireIn: freezed == expireIn
          ? _value.expireIn
          : expireIn // ignore: cast_nullable_to_non_nullable
              as String?,
      remains: freezed == remains
          ? _value.remains
          : remains // ignore: cast_nullable_to_non_nullable
              as String?,
      unregistered: freezed == unregistered
          ? _value.unregistered
          : unregistered // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SmsTrCodeResImplCopyWith<$Res>
    implements $SmsTrCodeResCopyWith<$Res> {
  factory _$$SmsTrCodeResImplCopyWith(
          _$SmsTrCodeResImpl value, $Res Function(_$SmsTrCodeResImpl) then) =
      __$$SmsTrCodeResImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? codeKey,
      String? maxSends,
      String? resetIn,
      String? interval,
      String? expireIn,
      String? remains,
      bool? unregistered});
}

/// @nodoc
class __$$SmsTrCodeResImplCopyWithImpl<$Res>
    extends _$SmsTrCodeResCopyWithImpl<$Res, _$SmsTrCodeResImpl>
    implements _$$SmsTrCodeResImplCopyWith<$Res> {
  __$$SmsTrCodeResImplCopyWithImpl(
      _$SmsTrCodeResImpl _value, $Res Function(_$SmsTrCodeResImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = freezed,
    Object? maxSends = freezed,
    Object? resetIn = freezed,
    Object? interval = freezed,
    Object? expireIn = freezed,
    Object? remains = freezed,
    Object? unregistered = freezed,
  }) {
    return _then(_$SmsTrCodeResImpl(
      codeKey: freezed == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String?,
      maxSends: freezed == maxSends
          ? _value.maxSends
          : maxSends // ignore: cast_nullable_to_non_nullable
              as String?,
      resetIn: freezed == resetIn
          ? _value.resetIn
          : resetIn // ignore: cast_nullable_to_non_nullable
              as String?,
      interval: freezed == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as String?,
      expireIn: freezed == expireIn
          ? _value.expireIn
          : expireIn // ignore: cast_nullable_to_non_nullable
              as String?,
      remains: freezed == remains
          ? _value.remains
          : remains // ignore: cast_nullable_to_non_nullable
              as String?,
      unregistered: freezed == unregistered
          ? _value.unregistered
          : unregistered // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SmsTrCodeResImpl extends _SmsTrCodeRes with DiagnosticableTreeMixin {
  const _$SmsTrCodeResImpl(
      {this.codeKey,
      this.maxSends,
      this.resetIn,
      this.interval,
      this.expireIn,
      this.remains,
      this.unregistered})
      : super._();

  factory _$SmsTrCodeResImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsTrCodeResImplFromJson(json);

  @override
  final String? codeKey;
  @override
  final String? maxSends;
  @override
  final String? resetIn;
  @override
  final String? interval;
  @override
  final String? expireIn;
  @override
  final String? remains;
  @override
  final bool? unregistered;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SmsTrCodeRes(codeKey: $codeKey, maxSends: $maxSends, resetIn: $resetIn, interval: $interval, expireIn: $expireIn, remains: $remains, unregistered: $unregistered)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SmsTrCodeRes'))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('maxSends', maxSends))
      ..add(DiagnosticsProperty('resetIn', resetIn))
      ..add(DiagnosticsProperty('interval', interval))
      ..add(DiagnosticsProperty('expireIn', expireIn))
      ..add(DiagnosticsProperty('remains', remains))
      ..add(DiagnosticsProperty('unregistered', unregistered));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmsTrCodeResImpl &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.maxSends, maxSends) ||
                other.maxSends == maxSends) &&
            (identical(other.resetIn, resetIn) || other.resetIn == resetIn) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.expireIn, expireIn) ||
                other.expireIn == expireIn) &&
            (identical(other.remains, remains) || other.remains == remains) &&
            (identical(other.unregistered, unregistered) ||
                other.unregistered == unregistered));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, codeKey, maxSends, resetIn,
      interval, expireIn, remains, unregistered);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SmsTrCodeResImplCopyWith<_$SmsTrCodeResImpl> get copyWith =>
      __$$SmsTrCodeResImplCopyWithImpl<_$SmsTrCodeResImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsTrCodeResImplToJson(
      this,
    );
  }
}

abstract class _SmsTrCodeRes extends SmsTrCodeRes {
  const factory _SmsTrCodeRes(
      {final String? codeKey,
      final String? maxSends,
      final String? resetIn,
      final String? interval,
      final String? expireIn,
      final String? remains,
      final bool? unregistered}) = _$SmsTrCodeResImpl;
  const _SmsTrCodeRes._() : super._();

  factory _SmsTrCodeRes.fromJson(Map<String, dynamic> json) =
      _$SmsTrCodeResImpl.fromJson;

  @override
  String? get codeKey;
  @override
  String? get maxSends;
  @override
  String? get resetIn;
  @override
  String? get interval;
  @override
  String? get expireIn;
  @override
  String? get remains;
  @override
  bool? get unregistered;
  @override
  @JsonKey(ignore: true)
  _$$SmsTrCodeResImplCopyWith<_$SmsTrCodeResImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmailGetCodeCheckReq _$EmailGetCodeCheckReqFromJson(Map<String, dynamic> json) {
  return _EmailGetCodeCheckReq.fromJson(json);
}

/// @nodoc
mixin _$EmailGetCodeCheckReq {
  String get email => throw _privateConstructorUsedError;
  String get lang => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  String get sig => throw _privateConstructorUsedError;
  bool get skipEmailBoundVerify => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmailGetCodeCheckReqCopyWith<EmailGetCodeCheckReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailGetCodeCheckReqCopyWith<$Res> {
  factory $EmailGetCodeCheckReqCopyWith(EmailGetCodeCheckReq value,
          $Res Function(EmailGetCodeCheckReq) then) =
      _$EmailGetCodeCheckReqCopyWithImpl<$Res, EmailGetCodeCheckReq>;
  @useResult
  $Res call(
      {String email,
      String lang,
      String sessionId,
      String token,
      String sig,
      bool skipEmailBoundVerify});
}

/// @nodoc
class _$EmailGetCodeCheckReqCopyWithImpl<$Res,
        $Val extends EmailGetCodeCheckReq>
    implements $EmailGetCodeCheckReqCopyWith<$Res> {
  _$EmailGetCodeCheckReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? lang = null,
    Object? sessionId = null,
    Object? token = null,
    Object? sig = null,
    Object? skipEmailBoundVerify = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      sig: null == sig
          ? _value.sig
          : sig // ignore: cast_nullable_to_non_nullable
              as String,
      skipEmailBoundVerify: null == skipEmailBoundVerify
          ? _value.skipEmailBoundVerify
          : skipEmailBoundVerify // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailGetCodeCheckReqImplCopyWith<$Res>
    implements $EmailGetCodeCheckReqCopyWith<$Res> {
  factory _$$EmailGetCodeCheckReqImplCopyWith(_$EmailGetCodeCheckReqImpl value,
          $Res Function(_$EmailGetCodeCheckReqImpl) then) =
      __$$EmailGetCodeCheckReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String lang,
      String sessionId,
      String token,
      String sig,
      bool skipEmailBoundVerify});
}

/// @nodoc
class __$$EmailGetCodeCheckReqImplCopyWithImpl<$Res>
    extends _$EmailGetCodeCheckReqCopyWithImpl<$Res, _$EmailGetCodeCheckReqImpl>
    implements _$$EmailGetCodeCheckReqImplCopyWith<$Res> {
  __$$EmailGetCodeCheckReqImplCopyWithImpl(_$EmailGetCodeCheckReqImpl _value,
      $Res Function(_$EmailGetCodeCheckReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? lang = null,
    Object? sessionId = null,
    Object? token = null,
    Object? sig = null,
    Object? skipEmailBoundVerify = null,
  }) {
    return _then(_$EmailGetCodeCheckReqImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      lang: null == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      sig: null == sig
          ? _value.sig
          : sig // ignore: cast_nullable_to_non_nullable
              as String,
      skipEmailBoundVerify: null == skipEmailBoundVerify
          ? _value.skipEmailBoundVerify
          : skipEmailBoundVerify // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailGetCodeCheckReqImpl
    with DiagnosticableTreeMixin
    implements _EmailGetCodeCheckReq {
  const _$EmailGetCodeCheckReqImpl(
      {required this.email,
      required this.lang,
      required this.sessionId,
      required this.token,
      required this.sig,
      required this.skipEmailBoundVerify});

  factory _$EmailGetCodeCheckReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailGetCodeCheckReqImplFromJson(json);

  @override
  final String email;
  @override
  final String lang;
  @override
  final String sessionId;
  @override
  final String token;
  @override
  final String sig;
  @override
  final bool skipEmailBoundVerify;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EmailGetCodeCheckReq(email: $email, lang: $lang, sessionId: $sessionId, token: $token, sig: $sig, skipEmailBoundVerify: $skipEmailBoundVerify)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EmailGetCodeCheckReq'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('lang', lang))
      ..add(DiagnosticsProperty('sessionId', sessionId))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('sig', sig))
      ..add(DiagnosticsProperty('skipEmailBoundVerify', skipEmailBoundVerify));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailGetCodeCheckReqImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.sig, sig) || other.sig == sig) &&
            (identical(other.skipEmailBoundVerify, skipEmailBoundVerify) ||
                other.skipEmailBoundVerify == skipEmailBoundVerify));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, email, lang, sessionId, token, sig, skipEmailBoundVerify);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailGetCodeCheckReqImplCopyWith<_$EmailGetCodeCheckReqImpl>
      get copyWith =>
          __$$EmailGetCodeCheckReqImplCopyWithImpl<_$EmailGetCodeCheckReqImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailGetCodeCheckReqImplToJson(
      this,
    );
  }
}

abstract class _EmailGetCodeCheckReq implements EmailGetCodeCheckReq {
  const factory _EmailGetCodeCheckReq(
      {required final String email,
      required final String lang,
      required final String sessionId,
      required final String token,
      required final String sig,
      required final bool skipEmailBoundVerify}) = _$EmailGetCodeCheckReqImpl;

  factory _EmailGetCodeCheckReq.fromJson(Map<String, dynamic> json) =
      _$EmailGetCodeCheckReqImpl.fromJson;

  @override
  String get email;
  @override
  String get lang;
  @override
  String get sessionId;
  @override
  String get token;
  @override
  String get sig;
  @override
  bool get skipEmailBoundVerify;
  @override
  @JsonKey(ignore: true)
  _$$EmailGetCodeCheckReqImplCopyWith<_$EmailGetCodeCheckReqImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EmailCheckCodeReq _$EmailCheckCodeReqFromJson(Map<String, dynamic> json) {
  return _EmailCheckCodeReq.fromJson(json);
}

/// @nodoc
mixin _$EmailCheckCodeReq {
  String get email => throw _privateConstructorUsedError;
  String get codeKey => throw _privateConstructorUsedError;
  String get codeValue => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmailCheckCodeReqCopyWith<EmailCheckCodeReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailCheckCodeReqCopyWith<$Res> {
  factory $EmailCheckCodeReqCopyWith(
          EmailCheckCodeReq value, $Res Function(EmailCheckCodeReq) then) =
      _$EmailCheckCodeReqCopyWithImpl<$Res, EmailCheckCodeReq>;
  @useResult
  $Res call({String email, String codeKey, String codeValue, String? lang});
}

/// @nodoc
class _$EmailCheckCodeReqCopyWithImpl<$Res, $Val extends EmailCheckCodeReq>
    implements $EmailCheckCodeReqCopyWith<$Res> {
  _$EmailCheckCodeReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? codeKey = null,
    Object? codeValue = null,
    Object? lang = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      codeValue: null == codeValue
          ? _value.codeValue
          : codeValue // ignore: cast_nullable_to_non_nullable
              as String,
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailCheckCodeReqImplCopyWith<$Res>
    implements $EmailCheckCodeReqCopyWith<$Res> {
  factory _$$EmailCheckCodeReqImplCopyWith(_$EmailCheckCodeReqImpl value,
          $Res Function(_$EmailCheckCodeReqImpl) then) =
      __$$EmailCheckCodeReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String codeKey, String codeValue, String? lang});
}

/// @nodoc
class __$$EmailCheckCodeReqImplCopyWithImpl<$Res>
    extends _$EmailCheckCodeReqCopyWithImpl<$Res, _$EmailCheckCodeReqImpl>
    implements _$$EmailCheckCodeReqImplCopyWith<$Res> {
  __$$EmailCheckCodeReqImplCopyWithImpl(_$EmailCheckCodeReqImpl _value,
      $Res Function(_$EmailCheckCodeReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? codeKey = null,
    Object? codeValue = null,
    Object? lang = freezed,
  }) {
    return _then(_$EmailCheckCodeReqImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      codeValue: null == codeValue
          ? _value.codeValue
          : codeValue // ignore: cast_nullable_to_non_nullable
              as String,
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailCheckCodeReqImpl
    with DiagnosticableTreeMixin
    implements _EmailCheckCodeReq {
  const _$EmailCheckCodeReqImpl(
      {required this.email,
      required this.codeKey,
      required this.codeValue,
      this.lang = ''});

  factory _$EmailCheckCodeReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailCheckCodeReqImplFromJson(json);

  @override
  final String email;
  @override
  final String codeKey;
  @override
  final String codeValue;
  @override
  @JsonKey()
  final String? lang;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EmailCheckCodeReq(email: $email, codeKey: $codeKey, codeValue: $codeValue, lang: $lang)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EmailCheckCodeReq'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('codeValue', codeValue))
      ..add(DiagnosticsProperty('lang', lang));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailCheckCodeReqImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.codeValue, codeValue) ||
                other.codeValue == codeValue) &&
            (identical(other.lang, lang) || other.lang == lang));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, codeKey, codeValue, lang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailCheckCodeReqImplCopyWith<_$EmailCheckCodeReqImpl> get copyWith =>
      __$$EmailCheckCodeReqImplCopyWithImpl<_$EmailCheckCodeReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailCheckCodeReqImplToJson(
      this,
    );
  }
}

abstract class _EmailCheckCodeReq implements EmailCheckCodeReq {
  const factory _EmailCheckCodeReq(
      {required final String email,
      required final String codeKey,
      required final String codeValue,
      final String? lang}) = _$EmailCheckCodeReqImpl;

  factory _EmailCheckCodeReq.fromJson(Map<String, dynamic> json) =
      _$EmailCheckCodeReqImpl.fromJson;

  @override
  String get email;
  @override
  String get codeKey;
  @override
  String get codeValue;
  @override
  String? get lang;
  @override
  @JsonKey(ignore: true)
  _$$EmailCheckCodeReqImplCopyWith<_$EmailCheckCodeReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SmsCodeCheckRes _$SmsCodeCheckResFromJson(Map<String, dynamic> json) {
  return _SmsCodeCheckRes.fromJson(json);
}

/// @nodoc
mixin _$SmsCodeCheckRes {
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmsCodeCheckResCopyWith<$Res> {
  factory $SmsCodeCheckResCopyWith(
          SmsCodeCheckRes value, $Res Function(SmsCodeCheckRes) then) =
      _$SmsCodeCheckResCopyWithImpl<$Res, SmsCodeCheckRes>;
}

/// @nodoc
class _$SmsCodeCheckResCopyWithImpl<$Res, $Val extends SmsCodeCheckRes>
    implements $SmsCodeCheckResCopyWith<$Res> {
  _$SmsCodeCheckResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SmsCodeCheckResImplCopyWith<$Res> {
  factory _$$SmsCodeCheckResImplCopyWith(_$SmsCodeCheckResImpl value,
          $Res Function(_$SmsCodeCheckResImpl) then) =
      __$$SmsCodeCheckResImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SmsCodeCheckResImplCopyWithImpl<$Res>
    extends _$SmsCodeCheckResCopyWithImpl<$Res, _$SmsCodeCheckResImpl>
    implements _$$SmsCodeCheckResImplCopyWith<$Res> {
  __$$SmsCodeCheckResImplCopyWithImpl(
      _$SmsCodeCheckResImpl _value, $Res Function(_$SmsCodeCheckResImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$SmsCodeCheckResImpl
    with DiagnosticableTreeMixin
    implements _SmsCodeCheckRes {
  const _$SmsCodeCheckResImpl();

  factory _$SmsCodeCheckResImpl.fromJson(Map<String, dynamic> json) =>
      _$$SmsCodeCheckResImplFromJson(json);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SmsCodeCheckRes()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'SmsCodeCheckRes'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SmsCodeCheckResImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$SmsCodeCheckResImplToJson(
      this,
    );
  }
}

abstract class _SmsCodeCheckRes implements SmsCodeCheckRes {
  const factory _SmsCodeCheckRes() = _$SmsCodeCheckResImpl;

  factory _SmsCodeCheckRes.fromJson(Map<String, dynamic> json) =
      _$SmsCodeCheckResImpl.fromJson;
}

ResetPswByMailReq _$ResetPswByMailReqFromJson(Map<String, dynamic> json) {
  return _ResetPswByMailReq.fromJson(json);
}

/// @nodoc
mixin _$ResetPswByMailReq {
  String get codeKey => throw _privateConstructorUsedError;
  String get confirmedPassword => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPswByMailReqCopyWith<ResetPswByMailReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPswByMailReqCopyWith<$Res> {
  factory $ResetPswByMailReqCopyWith(
          ResetPswByMailReq value, $Res Function(ResetPswByMailReq) then) =
      _$ResetPswByMailReqCopyWithImpl<$Res, ResetPswByMailReq>;
  @useResult
  $Res call(
      {String codeKey,
      String confirmedPassword,
      String password,
      String email});
}

/// @nodoc
class _$ResetPswByMailReqCopyWithImpl<$Res, $Val extends ResetPswByMailReq>
    implements $ResetPswByMailReqCopyWith<$Res> {
  _$ResetPswByMailReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = null,
    Object? confirmedPassword = null,
    Object? password = null,
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPswByMailReqImplCopyWith<$Res>
    implements $ResetPswByMailReqCopyWith<$Res> {
  factory _$$ResetPswByMailReqImplCopyWith(_$ResetPswByMailReqImpl value,
          $Res Function(_$ResetPswByMailReqImpl) then) =
      __$$ResetPswByMailReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String codeKey,
      String confirmedPassword,
      String password,
      String email});
}

/// @nodoc
class __$$ResetPswByMailReqImplCopyWithImpl<$Res>
    extends _$ResetPswByMailReqCopyWithImpl<$Res, _$ResetPswByMailReqImpl>
    implements _$$ResetPswByMailReqImplCopyWith<$Res> {
  __$$ResetPswByMailReqImplCopyWithImpl(_$ResetPswByMailReqImpl _value,
      $Res Function(_$ResetPswByMailReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = null,
    Object? confirmedPassword = null,
    Object? password = null,
    Object? email = null,
  }) {
    return _then(_$ResetPswByMailReqImpl(
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPswByMailReqImpl
    with DiagnosticableTreeMixin
    implements _ResetPswByMailReq {
  const _$ResetPswByMailReqImpl(
      {required this.codeKey,
      required this.confirmedPassword,
      required this.password,
      required this.email});

  factory _$ResetPswByMailReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPswByMailReqImplFromJson(json);

  @override
  final String codeKey;
  @override
  final String confirmedPassword;
  @override
  final String password;
  @override
  final String email;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResetPswByMailReq(codeKey: $codeKey, confirmedPassword: $confirmedPassword, password: $password, email: $email)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ResetPswByMailReq'))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('confirmedPassword', confirmedPassword))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('email', email));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPswByMailReqImpl &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.confirmedPassword, confirmedPassword) ||
                other.confirmedPassword == confirmedPassword) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, codeKey, confirmedPassword, password, email);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPswByMailReqImplCopyWith<_$ResetPswByMailReqImpl> get copyWith =>
      __$$ResetPswByMailReqImplCopyWithImpl<_$ResetPswByMailReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPswByMailReqImplToJson(
      this,
    );
  }
}

abstract class _ResetPswByMailReq implements ResetPswByMailReq {
  const factory _ResetPswByMailReq(
      {required final String codeKey,
      required final String confirmedPassword,
      required final String password,
      required final String email}) = _$ResetPswByMailReqImpl;

  factory _ResetPswByMailReq.fromJson(Map<String, dynamic> json) =
      _$ResetPswByMailReqImpl.fromJson;

  @override
  String get codeKey;
  @override
  String get confirmedPassword;
  @override
  String get password;
  @override
  String get email;
  @override
  @JsonKey(ignore: true)
  _$$ResetPswByMailReqImplCopyWith<_$ResetPswByMailReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResetPswByPhoneReq _$ResetPswByPhoneReqFromJson(Map<String, dynamic> json) {
  return _ResetPswByPhoneReq.fromJson(json);
}

/// @nodoc
mixin _$ResetPswByPhoneReq {
  String get codeKey => throw _privateConstructorUsedError;
  String get confirmedPassword => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get phoneCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPswByPhoneReqCopyWith<ResetPswByPhoneReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPswByPhoneReqCopyWith<$Res> {
  factory $ResetPswByPhoneReqCopyWith(
          ResetPswByPhoneReq value, $Res Function(ResetPswByPhoneReq) then) =
      _$ResetPswByPhoneReqCopyWithImpl<$Res, ResetPswByPhoneReq>;
  @useResult
  $Res call(
      {String codeKey,
      String confirmedPassword,
      String password,
      String phone,
      String phoneCode});
}

/// @nodoc
class _$ResetPswByPhoneReqCopyWithImpl<$Res, $Val extends ResetPswByPhoneReq>
    implements $ResetPswByPhoneReqCopyWith<$Res> {
  _$ResetPswByPhoneReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = null,
    Object? confirmedPassword = null,
    Object? password = null,
    Object? phone = null,
    Object? phoneCode = null,
  }) {
    return _then(_value.copyWith(
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: null == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPswByPhoneReqImplCopyWith<$Res>
    implements $ResetPswByPhoneReqCopyWith<$Res> {
  factory _$$ResetPswByPhoneReqImplCopyWith(_$ResetPswByPhoneReqImpl value,
          $Res Function(_$ResetPswByPhoneReqImpl) then) =
      __$$ResetPswByPhoneReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String codeKey,
      String confirmedPassword,
      String password,
      String phone,
      String phoneCode});
}

/// @nodoc
class __$$ResetPswByPhoneReqImplCopyWithImpl<$Res>
    extends _$ResetPswByPhoneReqCopyWithImpl<$Res, _$ResetPswByPhoneReqImpl>
    implements _$$ResetPswByPhoneReqImplCopyWith<$Res> {
  __$$ResetPswByPhoneReqImplCopyWithImpl(_$ResetPswByPhoneReqImpl _value,
      $Res Function(_$ResetPswByPhoneReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = null,
    Object? confirmedPassword = null,
    Object? password = null,
    Object? phone = null,
    Object? phoneCode = null,
  }) {
    return _then(_$ResetPswByPhoneReqImpl(
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: null == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPswByPhoneReqImpl
    with DiagnosticableTreeMixin
    implements _ResetPswByPhoneReq {
  const _$ResetPswByPhoneReqImpl(
      {required this.codeKey,
      required this.confirmedPassword,
      required this.password,
      required this.phone,
      required this.phoneCode});

  factory _$ResetPswByPhoneReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPswByPhoneReqImplFromJson(json);

  @override
  final String codeKey;
  @override
  final String confirmedPassword;
  @override
  final String password;
  @override
  final String phone;
  @override
  final String phoneCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ResetPswByPhoneReq(codeKey: $codeKey, confirmedPassword: $confirmedPassword, password: $password, phone: $phone, phoneCode: $phoneCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ResetPswByPhoneReq'))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('confirmedPassword', confirmedPassword))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('phoneCode', phoneCode));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPswByPhoneReqImpl &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.confirmedPassword, confirmedPassword) ||
                other.confirmedPassword == confirmedPassword) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, codeKey, confirmedPassword, password, phone, phoneCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPswByPhoneReqImplCopyWith<_$ResetPswByPhoneReqImpl> get copyWith =>
      __$$ResetPswByPhoneReqImplCopyWithImpl<_$ResetPswByPhoneReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPswByPhoneReqImplToJson(
      this,
    );
  }
}

abstract class _ResetPswByPhoneReq implements ResetPswByPhoneReq {
  const factory _ResetPswByPhoneReq(
      {required final String codeKey,
      required final String confirmedPassword,
      required final String password,
      required final String phone,
      required final String phoneCode}) = _$ResetPswByPhoneReqImpl;

  factory _ResetPswByPhoneReq.fromJson(Map<String, dynamic> json) =
      _$ResetPswByPhoneReqImpl.fromJson;

  @override
  String get codeKey;
  @override
  String get confirmedPassword;
  @override
  String get password;
  @override
  String get phone;
  @override
  String get phoneCode;
  @override
  @JsonKey(ignore: true)
  _$$ResetPswByPhoneReqImplCopyWith<_$ResetPswByPhoneReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MobileCheckCodeReq _$MobileCheckCodeReqFromJson(Map<String, dynamic> json) {
  return _MobileCheckCodeReq.fromJson(json);
}

/// @nodoc
mixin _$MobileCheckCodeReq {
  String get phone => throw _privateConstructorUsedError;
  String get phoneCode => throw _privateConstructorUsedError;
  String get codeKey => throw _privateConstructorUsedError;
  String get codeValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MobileCheckCodeReqCopyWith<MobileCheckCodeReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileCheckCodeReqCopyWith<$Res> {
  factory $MobileCheckCodeReqCopyWith(
          MobileCheckCodeReq value, $Res Function(MobileCheckCodeReq) then) =
      _$MobileCheckCodeReqCopyWithImpl<$Res, MobileCheckCodeReq>;
  @useResult
  $Res call({String phone, String phoneCode, String codeKey, String codeValue});
}

/// @nodoc
class _$MobileCheckCodeReqCopyWithImpl<$Res, $Val extends MobileCheckCodeReq>
    implements $MobileCheckCodeReqCopyWith<$Res> {
  _$MobileCheckCodeReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? phoneCode = null,
    Object? codeKey = null,
    Object? codeValue = null,
  }) {
    return _then(_value.copyWith(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: null == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String,
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      codeValue: null == codeValue
          ? _value.codeValue
          : codeValue // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MobileCheckCodeReqImplCopyWith<$Res>
    implements $MobileCheckCodeReqCopyWith<$Res> {
  factory _$$MobileCheckCodeReqImplCopyWith(_$MobileCheckCodeReqImpl value,
          $Res Function(_$MobileCheckCodeReqImpl) then) =
      __$$MobileCheckCodeReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phone, String phoneCode, String codeKey, String codeValue});
}

/// @nodoc
class __$$MobileCheckCodeReqImplCopyWithImpl<$Res>
    extends _$MobileCheckCodeReqCopyWithImpl<$Res, _$MobileCheckCodeReqImpl>
    implements _$$MobileCheckCodeReqImplCopyWith<$Res> {
  __$$MobileCheckCodeReqImplCopyWithImpl(_$MobileCheckCodeReqImpl _value,
      $Res Function(_$MobileCheckCodeReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
    Object? phoneCode = null,
    Object? codeKey = null,
    Object? codeValue = null,
  }) {
    return _then(_$MobileCheckCodeReqImpl(
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneCode: null == phoneCode
          ? _value.phoneCode
          : phoneCode // ignore: cast_nullable_to_non_nullable
              as String,
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
      codeValue: null == codeValue
          ? _value.codeValue
          : codeValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileCheckCodeReqImpl
    with DiagnosticableTreeMixin
    implements _MobileCheckCodeReq {
  const _$MobileCheckCodeReqImpl(
      {required this.phone,
      required this.phoneCode,
      required this.codeKey,
      required this.codeValue});

  factory _$MobileCheckCodeReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileCheckCodeReqImplFromJson(json);

  @override
  final String phone;
  @override
  final String phoneCode;
  @override
  final String codeKey;
  @override
  final String codeValue;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MobileCheckCodeReq(phone: $phone, phoneCode: $phoneCode, codeKey: $codeKey, codeValue: $codeValue)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MobileCheckCodeReq'))
      ..add(DiagnosticsProperty('phone', phone))
      ..add(DiagnosticsProperty('phoneCode', phoneCode))
      ..add(DiagnosticsProperty('codeKey', codeKey))
      ..add(DiagnosticsProperty('codeValue', codeValue));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileCheckCodeReqImpl &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneCode, phoneCode) ||
                other.phoneCode == phoneCode) &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey) &&
            (identical(other.codeValue, codeValue) ||
                other.codeValue == codeValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phone, phoneCode, codeKey, codeValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileCheckCodeReqImplCopyWith<_$MobileCheckCodeReqImpl> get copyWith =>
      __$$MobileCheckCodeReqImplCopyWithImpl<_$MobileCheckCodeReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileCheckCodeReqImplToJson(
      this,
    );
  }
}

abstract class _MobileCheckCodeReq implements MobileCheckCodeReq {
  const factory _MobileCheckCodeReq(
      {required final String phone,
      required final String phoneCode,
      required final String codeKey,
      required final String codeValue}) = _$MobileCheckCodeReqImpl;

  factory _MobileCheckCodeReq.fromJson(Map<String, dynamic> json) =
      _$MobileCheckCodeReqImpl.fromJson;

  @override
  String get phone;
  @override
  String get phoneCode;
  @override
  String get codeKey;
  @override
  String get codeValue;
  @override
  @JsonKey(ignore: true)
  _$$MobileCheckCodeReqImplCopyWith<_$MobileCheckCodeReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MobileUnbindReq _$MobileUnbindReqFromJson(Map<String, dynamic> json) {
  return _MobileUnbindReq.fromJson(json);
}

/// @nodoc
mixin _$MobileUnbindReq {
  String get codeKey => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MobileUnbindReqCopyWith<MobileUnbindReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileUnbindReqCopyWith<$Res> {
  factory $MobileUnbindReqCopyWith(
          MobileUnbindReq value, $Res Function(MobileUnbindReq) then) =
      _$MobileUnbindReqCopyWithImpl<$Res, MobileUnbindReq>;
  @useResult
  $Res call({String codeKey});
}

/// @nodoc
class _$MobileUnbindReqCopyWithImpl<$Res, $Val extends MobileUnbindReq>
    implements $MobileUnbindReqCopyWith<$Res> {
  _$MobileUnbindReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = null,
  }) {
    return _then(_value.copyWith(
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MobileUnbindReqImplCopyWith<$Res>
    implements $MobileUnbindReqCopyWith<$Res> {
  factory _$$MobileUnbindReqImplCopyWith(_$MobileUnbindReqImpl value,
          $Res Function(_$MobileUnbindReqImpl) then) =
      __$$MobileUnbindReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String codeKey});
}

/// @nodoc
class __$$MobileUnbindReqImplCopyWithImpl<$Res>
    extends _$MobileUnbindReqCopyWithImpl<$Res, _$MobileUnbindReqImpl>
    implements _$$MobileUnbindReqImplCopyWith<$Res> {
  __$$MobileUnbindReqImplCopyWithImpl(
      _$MobileUnbindReqImpl _value, $Res Function(_$MobileUnbindReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? codeKey = null,
  }) {
    return _then(_$MobileUnbindReqImpl(
      codeKey: null == codeKey
          ? _value.codeKey
          : codeKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileUnbindReqImpl
    with DiagnosticableTreeMixin
    implements _MobileUnbindReq {
  const _$MobileUnbindReqImpl({required this.codeKey});

  factory _$MobileUnbindReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileUnbindReqImplFromJson(json);

  @override
  final String codeKey;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MobileUnbindReq(codeKey: $codeKey)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MobileUnbindReq'))
      ..add(DiagnosticsProperty('codeKey', codeKey));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileUnbindReqImpl &&
            (identical(other.codeKey, codeKey) || other.codeKey == codeKey));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, codeKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileUnbindReqImplCopyWith<_$MobileUnbindReqImpl> get copyWith =>
      __$$MobileUnbindReqImplCopyWithImpl<_$MobileUnbindReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileUnbindReqImplToJson(
      this,
    );
  }
}

abstract class _MobileUnbindReq implements MobileUnbindReq {
  const factory _MobileUnbindReq({required final String codeKey}) =
      _$MobileUnbindReqImpl;

  factory _MobileUnbindReq.fromJson(Map<String, dynamic> json) =
      _$MobileUnbindReqImpl.fromJson;

  @override
  String get codeKey;
  @override
  @JsonKey(ignore: true)
  _$$MobileUnbindReqImplCopyWith<_$MobileUnbindReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChangePwdCheckReq _$ChangePwdCheckReqFromJson(Map<String, dynamic> json) {
  return _ChangePwdCheckReq.fromJson(json);
}

/// @nodoc
mixin _$ChangePwdCheckReq {
  String get confirmedPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChangePwdCheckReqCopyWith<ChangePwdCheckReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePwdCheckReqCopyWith<$Res> {
  factory $ChangePwdCheckReqCopyWith(
          ChangePwdCheckReq value, $Res Function(ChangePwdCheckReq) then) =
      _$ChangePwdCheckReqCopyWithImpl<$Res, ChangePwdCheckReq>;
  @useResult
  $Res call({String confirmedPassword, String newPassword, String password});
}

/// @nodoc
class _$ChangePwdCheckReqCopyWithImpl<$Res, $Val extends ChangePwdCheckReq>
    implements $ChangePwdCheckReqCopyWith<$Res> {
  _$ChangePwdCheckReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmedPassword = null,
    Object? newPassword = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangePwdCheckReqImplCopyWith<$Res>
    implements $ChangePwdCheckReqCopyWith<$Res> {
  factory _$$ChangePwdCheckReqImplCopyWith(_$ChangePwdCheckReqImpl value,
          $Res Function(_$ChangePwdCheckReqImpl) then) =
      __$$ChangePwdCheckReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String confirmedPassword, String newPassword, String password});
}

/// @nodoc
class __$$ChangePwdCheckReqImplCopyWithImpl<$Res>
    extends _$ChangePwdCheckReqCopyWithImpl<$Res, _$ChangePwdCheckReqImpl>
    implements _$$ChangePwdCheckReqImplCopyWith<$Res> {
  __$$ChangePwdCheckReqImplCopyWithImpl(_$ChangePwdCheckReqImpl _value,
      $Res Function(_$ChangePwdCheckReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmedPassword = null,
    Object? newPassword = null,
    Object? password = null,
  }) {
    return _then(_$ChangePwdCheckReqImpl(
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangePwdCheckReqImpl
    with DiagnosticableTreeMixin
    implements _ChangePwdCheckReq {
  const _$ChangePwdCheckReqImpl(
      {required this.confirmedPassword,
      required this.newPassword,
      required this.password});

  factory _$ChangePwdCheckReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangePwdCheckReqImplFromJson(json);

  @override
  final String confirmedPassword;
  @override
  final String newPassword;
  @override
  final String password;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ChangePwdCheckReq(confirmedPassword: $confirmedPassword, newPassword: $newPassword, password: $password)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ChangePwdCheckReq'))
      ..add(DiagnosticsProperty('confirmedPassword', confirmedPassword))
      ..add(DiagnosticsProperty('newPassword', newPassword))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePwdCheckReqImpl &&
            (identical(other.confirmedPassword, confirmedPassword) ||
                other.confirmedPassword == confirmedPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, confirmedPassword, newPassword, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePwdCheckReqImplCopyWith<_$ChangePwdCheckReqImpl> get copyWith =>
      __$$ChangePwdCheckReqImplCopyWithImpl<_$ChangePwdCheckReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangePwdCheckReqImplToJson(
      this,
    );
  }
}

abstract class _ChangePwdCheckReq implements ChangePwdCheckReq {
  const factory _ChangePwdCheckReq(
      {required final String confirmedPassword,
      required final String newPassword,
      required final String password}) = _$ChangePwdCheckReqImpl;

  factory _ChangePwdCheckReq.fromJson(Map<String, dynamic> json) =
      _$ChangePwdCheckReqImpl.fromJson;

  @override
  String get confirmedPassword;
  @override
  String get newPassword;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$ChangePwdCheckReqImplCopyWith<_$ChangePwdCheckReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SettingPwdCheckReq _$SettingPwdCheckReqFromJson(Map<String, dynamic> json) {
  return _SettingPwdCheckReq.fromJson(json);
}

/// @nodoc
mixin _$SettingPwdCheckReq {
  String get confirmedPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingPwdCheckReqCopyWith<SettingPwdCheckReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingPwdCheckReqCopyWith<$Res> {
  factory $SettingPwdCheckReqCopyWith(
          SettingPwdCheckReq value, $Res Function(SettingPwdCheckReq) then) =
      _$SettingPwdCheckReqCopyWithImpl<$Res, SettingPwdCheckReq>;
  @useResult
  $Res call({String confirmedPassword, String newPassword});
}

/// @nodoc
class _$SettingPwdCheckReqCopyWithImpl<$Res, $Val extends SettingPwdCheckReq>
    implements $SettingPwdCheckReqCopyWith<$Res> {
  _$SettingPwdCheckReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmedPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_value.copyWith(
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingPwdCheckReqImplCopyWith<$Res>
    implements $SettingPwdCheckReqCopyWith<$Res> {
  factory _$$SettingPwdCheckReqImplCopyWith(_$SettingPwdCheckReqImpl value,
          $Res Function(_$SettingPwdCheckReqImpl) then) =
      __$$SettingPwdCheckReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String confirmedPassword, String newPassword});
}

/// @nodoc
class __$$SettingPwdCheckReqImplCopyWithImpl<$Res>
    extends _$SettingPwdCheckReqCopyWithImpl<$Res, _$SettingPwdCheckReqImpl>
    implements _$$SettingPwdCheckReqImplCopyWith<$Res> {
  __$$SettingPwdCheckReqImplCopyWithImpl(_$SettingPwdCheckReqImpl _value,
      $Res Function(_$SettingPwdCheckReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confirmedPassword = null,
    Object? newPassword = null,
  }) {
    return _then(_$SettingPwdCheckReqImpl(
      confirmedPassword: null == confirmedPassword
          ? _value.confirmedPassword
          : confirmedPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingPwdCheckReqImpl
    with DiagnosticableTreeMixin
    implements _SettingPwdCheckReq {
  const _$SettingPwdCheckReqImpl(
      {required this.confirmedPassword, required this.newPassword});

  factory _$SettingPwdCheckReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingPwdCheckReqImplFromJson(json);

  @override
  final String confirmedPassword;
  @override
  final String newPassword;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SettingPwdCheckReq(confirmedPassword: $confirmedPassword, newPassword: $newPassword)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SettingPwdCheckReq'))
      ..add(DiagnosticsProperty('confirmedPassword', confirmedPassword))
      ..add(DiagnosticsProperty('newPassword', newPassword));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingPwdCheckReqImpl &&
            (identical(other.confirmedPassword, confirmedPassword) ||
                other.confirmedPassword == confirmedPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, confirmedPassword, newPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingPwdCheckReqImplCopyWith<_$SettingPwdCheckReqImpl> get copyWith =>
      __$$SettingPwdCheckReqImplCopyWithImpl<_$SettingPwdCheckReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingPwdCheckReqImplToJson(
      this,
    );
  }
}

abstract class _SettingPwdCheckReq implements SettingPwdCheckReq {
  const factory _SettingPwdCheckReq(
      {required final String confirmedPassword,
      required final String newPassword}) = _$SettingPwdCheckReqImpl;

  factory _SettingPwdCheckReq.fromJson(Map<String, dynamic> json) =
      _$SettingPwdCheckReqImpl.fromJson;

  @override
  String get confirmedPassword;
  @override
  String get newPassword;
  @override
  @JsonKey(ignore: true)
  _$$SettingPwdCheckReqImplCopyWith<_$SettingPwdCheckReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnbindEmailReq _$UnbindEmailReqFromJson(Map<String, dynamic> json) {
  return _UnbindEmailReq.fromJson(json);
}

/// @nodoc
mixin _$UnbindEmailReq {
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UnbindEmailReqCopyWith<UnbindEmailReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnbindEmailReqCopyWith<$Res> {
  factory $UnbindEmailReqCopyWith(
          UnbindEmailReq value, $Res Function(UnbindEmailReq) then) =
      _$UnbindEmailReqCopyWithImpl<$Res, UnbindEmailReq>;
  @useResult
  $Res call({String password});
}

/// @nodoc
class _$UnbindEmailReqCopyWithImpl<$Res, $Val extends UnbindEmailReq>
    implements $UnbindEmailReqCopyWith<$Res> {
  _$UnbindEmailReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UnbindEmailReqImplCopyWith<$Res>
    implements $UnbindEmailReqCopyWith<$Res> {
  factory _$$UnbindEmailReqImplCopyWith(_$UnbindEmailReqImpl value,
          $Res Function(_$UnbindEmailReqImpl) then) =
      __$$UnbindEmailReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String password});
}

/// @nodoc
class __$$UnbindEmailReqImplCopyWithImpl<$Res>
    extends _$UnbindEmailReqCopyWithImpl<$Res, _$UnbindEmailReqImpl>
    implements _$$UnbindEmailReqImplCopyWith<$Res> {
  __$$UnbindEmailReqImplCopyWithImpl(
      _$UnbindEmailReqImpl _value, $Res Function(_$UnbindEmailReqImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
  }) {
    return _then(_$UnbindEmailReqImpl(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UnbindEmailReqImpl
    with DiagnosticableTreeMixin
    implements _UnbindEmailReq {
  const _$UnbindEmailReqImpl({required this.password});

  factory _$UnbindEmailReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnbindEmailReqImplFromJson(json);

  @override
  final String password;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UnbindEmailReq(password: $password)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UnbindEmailReq'))
      ..add(DiagnosticsProperty('password', password));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnbindEmailReqImpl &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnbindEmailReqImplCopyWith<_$UnbindEmailReqImpl> get copyWith =>
      __$$UnbindEmailReqImplCopyWithImpl<_$UnbindEmailReqImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UnbindEmailReqImplToJson(
      this,
    );
  }
}

abstract class _UnbindEmailReq implements UnbindEmailReq {
  const factory _UnbindEmailReq({required final String password}) =
      _$UnbindEmailReqImpl;

  factory _UnbindEmailReq.fromJson(Map<String, dynamic> json) =
      _$UnbindEmailReqImpl.fromJson;

  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$UnbindEmailReqImplCopyWith<_$UnbindEmailReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
