// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalModel {
  OAuthModel? get oAuthBean => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  String? get timeZone => throw _privateConstructorUsedError;
  RegionItem? get regionItem => throw _privateConstructorUsedError;
  UserInfoModel? get userInfo => throw _privateConstructorUsedError;
  bool get isAgreedProtocal => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocalModelCopyWith<LocalModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalModelCopyWith<$Res> {
  factory $LocalModelCopyWith(
          LocalModel value, $Res Function(LocalModel) then) =
      _$LocalModelCopyWithImpl<$Res, LocalModel>;
  @useResult
  $Res call(
      {OAuthModel? oAuthBean,
      String? region,
      String? timeZone,
      RegionItem? regionItem,
      UserInfoModel? userInfo,
      bool isAgreedProtocal});

  $OAuthModelCopyWith<$Res>? get oAuthBean;
  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class _$LocalModelCopyWithImpl<$Res, $Val extends LocalModel>
    implements $LocalModelCopyWith<$Res> {
  _$LocalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oAuthBean = freezed,
    Object? region = freezed,
    Object? timeZone = freezed,
    Object? regionItem = freezed,
    Object? userInfo = freezed,
    Object? isAgreedProtocal = null,
  }) {
    return _then(_value.copyWith(
      oAuthBean: freezed == oAuthBean
          ? _value.oAuthBean
          : oAuthBean // ignore: cast_nullable_to_non_nullable
              as OAuthModel?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      regionItem: freezed == regionItem
          ? _value.regionItem
          : regionItem // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      isAgreedProtocal: null == isAgreedProtocal
          ? _value.isAgreedProtocal
          : isAgreedProtocal // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OAuthModelCopyWith<$Res>? get oAuthBean {
    if (_value.oAuthBean == null) {
      return null;
    }

    return $OAuthModelCopyWith<$Res>(_value.oAuthBean!, (value) {
      return _then(_value.copyWith(oAuthBean: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserInfoModelCopyWith<$Res>? get userInfo {
    if (_value.userInfo == null) {
      return null;
    }

    return $UserInfoModelCopyWith<$Res>(_value.userInfo!, (value) {
      return _then(_value.copyWith(userInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LocalModelImplCopyWith<$Res>
    implements $LocalModelCopyWith<$Res> {
  factory _$$LocalModelImplCopyWith(
          _$LocalModelImpl value, $Res Function(_$LocalModelImpl) then) =
      __$$LocalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OAuthModel? oAuthBean,
      String? region,
      String? timeZone,
      RegionItem? regionItem,
      UserInfoModel? userInfo,
      bool isAgreedProtocal});

  @override
  $OAuthModelCopyWith<$Res>? get oAuthBean;
  @override
  $UserInfoModelCopyWith<$Res>? get userInfo;
}

/// @nodoc
class __$$LocalModelImplCopyWithImpl<$Res>
    extends _$LocalModelCopyWithImpl<$Res, _$LocalModelImpl>
    implements _$$LocalModelImplCopyWith<$Res> {
  __$$LocalModelImplCopyWithImpl(
      _$LocalModelImpl _value, $Res Function(_$LocalModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oAuthBean = freezed,
    Object? region = freezed,
    Object? timeZone = freezed,
    Object? regionItem = freezed,
    Object? userInfo = freezed,
    Object? isAgreedProtocal = null,
  }) {
    return _then(_$LocalModelImpl(
      oAuthBean: freezed == oAuthBean
          ? _value.oAuthBean
          : oAuthBean // ignore: cast_nullable_to_non_nullable
              as OAuthModel?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      timeZone: freezed == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String?,
      regionItem: freezed == regionItem
          ? _value.regionItem
          : regionItem // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      userInfo: freezed == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfoModel?,
      isAgreedProtocal: null == isAgreedProtocal
          ? _value.isAgreedProtocal
          : isAgreedProtocal // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LocalModelImpl implements _LocalModel {
  const _$LocalModelImpl(
      {this.oAuthBean,
      this.region,
      this.timeZone,
      this.regionItem,
      this.userInfo,
      this.isAgreedProtocal = true});

  @override
  final OAuthModel? oAuthBean;
  @override
  final String? region;
  @override
  final String? timeZone;
  @override
  final RegionItem? regionItem;
  @override
  final UserInfoModel? userInfo;
  @override
  @JsonKey()
  final bool isAgreedProtocal;

  @override
  String toString() {
    return 'LocalModel(oAuthBean: $oAuthBean, region: $region, timeZone: $timeZone, regionItem: $regionItem, userInfo: $userInfo, isAgreedProtocal: $isAgreedProtocal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalModelImpl &&
            (identical(other.oAuthBean, oAuthBean) ||
                other.oAuthBean == oAuthBean) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone) &&
            (identical(other.regionItem, regionItem) ||
                other.regionItem == regionItem) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.isAgreedProtocal, isAgreedProtocal) ||
                other.isAgreedProtocal == isAgreedProtocal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, oAuthBean, region, timeZone,
      regionItem, userInfo, isAgreedProtocal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalModelImplCopyWith<_$LocalModelImpl> get copyWith =>
      __$$LocalModelImplCopyWithImpl<_$LocalModelImpl>(this, _$identity);
}

abstract class _LocalModel implements LocalModel {
  const factory _LocalModel(
      {final OAuthModel? oAuthBean,
      final String? region,
      final String? timeZone,
      final RegionItem? regionItem,
      final UserInfoModel? userInfo,
      final bool isAgreedProtocal}) = _$LocalModelImpl;

  @override
  OAuthModel? get oAuthBean;
  @override
  String? get region;
  @override
  String? get timeZone;
  @override
  RegionItem? get regionItem;
  @override
  UserInfoModel? get userInfo;
  @override
  bool get isAgreedProtocal;
  @override
  @JsonKey(ignore: true)
  _$$LocalModelImplCopyWith<_$LocalModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
