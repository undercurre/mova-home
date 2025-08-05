// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mine_share_permission_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MineSharePermissionEntity _$MineSharePermissionEntityFromJson(
    Map<String, dynamic> json) {
  return _MineSharePermissionEntity.fromJson(json);
}

/// @nodoc
mixin _$MineSharePermissionEntity {
  String? get permitKey => throw _privateConstructorUsedError;
  SharePermitInfo? get permitInfo => throw _privateConstructorUsedError;
  bool? get isOn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MineSharePermissionEntityCopyWith<MineSharePermissionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MineSharePermissionEntityCopyWith<$Res> {
  factory $MineSharePermissionEntityCopyWith(MineSharePermissionEntity value,
          $Res Function(MineSharePermissionEntity) then) =
      _$MineSharePermissionEntityCopyWithImpl<$Res, MineSharePermissionEntity>;
  @useResult
  $Res call({String? permitKey, SharePermitInfo? permitInfo, bool? isOn});

  $SharePermitInfoCopyWith<$Res>? get permitInfo;
}

/// @nodoc
class _$MineSharePermissionEntityCopyWithImpl<$Res,
        $Val extends MineSharePermissionEntity>
    implements $MineSharePermissionEntityCopyWith<$Res> {
  _$MineSharePermissionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permitKey = freezed,
    Object? permitInfo = freezed,
    Object? isOn = freezed,
  }) {
    return _then(_value.copyWith(
      permitKey: freezed == permitKey
          ? _value.permitKey
          : permitKey // ignore: cast_nullable_to_non_nullable
              as String?,
      permitInfo: freezed == permitInfo
          ? _value.permitInfo
          : permitInfo // ignore: cast_nullable_to_non_nullable
              as SharePermitInfo?,
      isOn: freezed == isOn
          ? _value.isOn
          : isOn // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SharePermitInfoCopyWith<$Res>? get permitInfo {
    if (_value.permitInfo == null) {
      return null;
    }

    return $SharePermitInfoCopyWith<$Res>(_value.permitInfo!, (value) {
      return _then(_value.copyWith(permitInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MineSharePermissionEntityImplCopyWith<$Res>
    implements $MineSharePermissionEntityCopyWith<$Res> {
  factory _$$MineSharePermissionEntityImplCopyWith(
          _$MineSharePermissionEntityImpl value,
          $Res Function(_$MineSharePermissionEntityImpl) then) =
      __$$MineSharePermissionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? permitKey, SharePermitInfo? permitInfo, bool? isOn});

  @override
  $SharePermitInfoCopyWith<$Res>? get permitInfo;
}

/// @nodoc
class __$$MineSharePermissionEntityImplCopyWithImpl<$Res>
    extends _$MineSharePermissionEntityCopyWithImpl<$Res,
        _$MineSharePermissionEntityImpl>
    implements _$$MineSharePermissionEntityImplCopyWith<$Res> {
  __$$MineSharePermissionEntityImplCopyWithImpl(
      _$MineSharePermissionEntityImpl _value,
      $Res Function(_$MineSharePermissionEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permitKey = freezed,
    Object? permitInfo = freezed,
    Object? isOn = freezed,
  }) {
    return _then(_$MineSharePermissionEntityImpl(
      permitKey: freezed == permitKey
          ? _value.permitKey
          : permitKey // ignore: cast_nullable_to_non_nullable
              as String?,
      permitInfo: freezed == permitInfo
          ? _value.permitInfo
          : permitInfo // ignore: cast_nullable_to_non_nullable
              as SharePermitInfo?,
      isOn: freezed == isOn
          ? _value.isOn
          : isOn // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MineSharePermissionEntityImpl implements _MineSharePermissionEntity {
  const _$MineSharePermissionEntityImpl(
      {this.permitKey, this.permitInfo, this.isOn});

  factory _$MineSharePermissionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$MineSharePermissionEntityImplFromJson(json);

  @override
  final String? permitKey;
  @override
  final SharePermitInfo? permitInfo;
  @override
  final bool? isOn;

  @override
  String toString() {
    return 'MineSharePermissionEntity(permitKey: $permitKey, permitInfo: $permitInfo, isOn: $isOn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MineSharePermissionEntityImpl &&
            (identical(other.permitKey, permitKey) ||
                other.permitKey == permitKey) &&
            (identical(other.permitInfo, permitInfo) ||
                other.permitInfo == permitInfo) &&
            (identical(other.isOn, isOn) || other.isOn == isOn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, permitKey, permitInfo, isOn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MineSharePermissionEntityImplCopyWith<_$MineSharePermissionEntityImpl>
      get copyWith => __$$MineSharePermissionEntityImplCopyWithImpl<
          _$MineSharePermissionEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MineSharePermissionEntityImplToJson(
      this,
    );
  }
}

abstract class _MineSharePermissionEntity implements MineSharePermissionEntity {
  const factory _MineSharePermissionEntity(
      {final String? permitKey,
      final SharePermitInfo? permitInfo,
      final bool? isOn}) = _$MineSharePermissionEntityImpl;

  factory _MineSharePermissionEntity.fromJson(Map<String, dynamic> json) =
      _$MineSharePermissionEntityImpl.fromJson;

  @override
  String? get permitKey;
  @override
  SharePermitInfo? get permitInfo;
  @override
  bool? get isOn;
  @override
  @JsonKey(ignore: true)
  _$$MineSharePermissionEntityImplCopyWith<_$MineSharePermissionEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SharePermitInfo _$SharePermitInfoFromJson(Map<String, dynamic> json) {
  return _SharePermitInfo.fromJson(json);
}

/// @nodoc
mixin _$SharePermitInfo {
  SharePermitImage? get permitImage => throw _privateConstructorUsedError;
  Map<String, SharePermitDesc>? get permitInfoDisplays =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharePermitInfoCopyWith<SharePermitInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharePermitInfoCopyWith<$Res> {
  factory $SharePermitInfoCopyWith(
          SharePermitInfo value, $Res Function(SharePermitInfo) then) =
      _$SharePermitInfoCopyWithImpl<$Res, SharePermitInfo>;
  @useResult
  $Res call(
      {SharePermitImage? permitImage,
      Map<String, SharePermitDesc>? permitInfoDisplays});

  $SharePermitImageCopyWith<$Res>? get permitImage;
}

/// @nodoc
class _$SharePermitInfoCopyWithImpl<$Res, $Val extends SharePermitInfo>
    implements $SharePermitInfoCopyWith<$Res> {
  _$SharePermitInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permitImage = freezed,
    Object? permitInfoDisplays = freezed,
  }) {
    return _then(_value.copyWith(
      permitImage: freezed == permitImage
          ? _value.permitImage
          : permitImage // ignore: cast_nullable_to_non_nullable
              as SharePermitImage?,
      permitInfoDisplays: freezed == permitInfoDisplays
          ? _value.permitInfoDisplays
          : permitInfoDisplays // ignore: cast_nullable_to_non_nullable
              as Map<String, SharePermitDesc>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SharePermitImageCopyWith<$Res>? get permitImage {
    if (_value.permitImage == null) {
      return null;
    }

    return $SharePermitImageCopyWith<$Res>(_value.permitImage!, (value) {
      return _then(_value.copyWith(permitImage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SharePermitInfoImplCopyWith<$Res>
    implements $SharePermitInfoCopyWith<$Res> {
  factory _$$SharePermitInfoImplCopyWith(_$SharePermitInfoImpl value,
          $Res Function(_$SharePermitInfoImpl) then) =
      __$$SharePermitInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SharePermitImage? permitImage,
      Map<String, SharePermitDesc>? permitInfoDisplays});

  @override
  $SharePermitImageCopyWith<$Res>? get permitImage;
}

/// @nodoc
class __$$SharePermitInfoImplCopyWithImpl<$Res>
    extends _$SharePermitInfoCopyWithImpl<$Res, _$SharePermitInfoImpl>
    implements _$$SharePermitInfoImplCopyWith<$Res> {
  __$$SharePermitInfoImplCopyWithImpl(
      _$SharePermitInfoImpl _value, $Res Function(_$SharePermitInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permitImage = freezed,
    Object? permitInfoDisplays = freezed,
  }) {
    return _then(_$SharePermitInfoImpl(
      permitImage: freezed == permitImage
          ? _value.permitImage
          : permitImage // ignore: cast_nullable_to_non_nullable
              as SharePermitImage?,
      permitInfoDisplays: freezed == permitInfoDisplays
          ? _value._permitInfoDisplays
          : permitInfoDisplays // ignore: cast_nullable_to_non_nullable
              as Map<String, SharePermitDesc>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharePermitInfoImpl implements _SharePermitInfo {
  const _$SharePermitInfoImpl(
      {this.permitImage,
      final Map<String, SharePermitDesc>? permitInfoDisplays})
      : _permitInfoDisplays = permitInfoDisplays;

  factory _$SharePermitInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharePermitInfoImplFromJson(json);

  @override
  final SharePermitImage? permitImage;
  final Map<String, SharePermitDesc>? _permitInfoDisplays;
  @override
  Map<String, SharePermitDesc>? get permitInfoDisplays {
    final value = _permitInfoDisplays;
    if (value == null) return null;
    if (_permitInfoDisplays is EqualUnmodifiableMapView)
      return _permitInfoDisplays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SharePermitInfo(permitImage: $permitImage, permitInfoDisplays: $permitInfoDisplays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharePermitInfoImpl &&
            (identical(other.permitImage, permitImage) ||
                other.permitImage == permitImage) &&
            const DeepCollectionEquality()
                .equals(other._permitInfoDisplays, _permitInfoDisplays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, permitImage,
      const DeepCollectionEquality().hash(_permitInfoDisplays));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharePermitInfoImplCopyWith<_$SharePermitInfoImpl> get copyWith =>
      __$$SharePermitInfoImplCopyWithImpl<_$SharePermitInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharePermitInfoImplToJson(
      this,
    );
  }
}

abstract class _SharePermitInfo implements SharePermitInfo {
  const factory _SharePermitInfo(
          {final SharePermitImage? permitImage,
          final Map<String, SharePermitDesc>? permitInfoDisplays}) =
      _$SharePermitInfoImpl;

  factory _SharePermitInfo.fromJson(Map<String, dynamic> json) =
      _$SharePermitInfoImpl.fromJson;

  @override
  SharePermitImage? get permitImage;
  @override
  Map<String, SharePermitDesc>? get permitInfoDisplays;
  @override
  @JsonKey(ignore: true)
  _$$SharePermitInfoImplCopyWith<_$SharePermitInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharePermitImage _$SharePermitImageFromJson(Map<String, dynamic> json) {
  return _SharePermitImage.fromJson(json);
}

/// @nodoc
mixin _$SharePermitImage {
  String? get caption => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get smallImageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharePermitImageCopyWith<SharePermitImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharePermitImageCopyWith<$Res> {
  factory $SharePermitImageCopyWith(
          SharePermitImage value, $Res Function(SharePermitImage) then) =
      _$SharePermitImageCopyWithImpl<$Res, SharePermitImage>;
  @useResult
  $Res call(
      {String? caption,
      int? height,
      int? width,
      String? imageUrl,
      String? smallImageUrl});
}

/// @nodoc
class _$SharePermitImageCopyWithImpl<$Res, $Val extends SharePermitImage>
    implements $SharePermitImageCopyWith<$Res> {
  _$SharePermitImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caption = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? imageUrl = freezed,
    Object? smallImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      smallImageUrl: freezed == smallImageUrl
          ? _value.smallImageUrl
          : smallImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharePermitImageImplCopyWith<$Res>
    implements $SharePermitImageCopyWith<$Res> {
  factory _$$SharePermitImageImplCopyWith(_$SharePermitImageImpl value,
          $Res Function(_$SharePermitImageImpl) then) =
      __$$SharePermitImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? caption,
      int? height,
      int? width,
      String? imageUrl,
      String? smallImageUrl});
}

/// @nodoc
class __$$SharePermitImageImplCopyWithImpl<$Res>
    extends _$SharePermitImageCopyWithImpl<$Res, _$SharePermitImageImpl>
    implements _$$SharePermitImageImplCopyWith<$Res> {
  __$$SharePermitImageImplCopyWithImpl(_$SharePermitImageImpl _value,
      $Res Function(_$SharePermitImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? caption = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? imageUrl = freezed,
    Object? smallImageUrl = freezed,
  }) {
    return _then(_$SharePermitImageImpl(
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      smallImageUrl: freezed == smallImageUrl
          ? _value.smallImageUrl
          : smallImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharePermitImageImpl implements _SharePermitImage {
  const _$SharePermitImageImpl(
      {this.caption,
      this.height,
      this.width,
      this.imageUrl,
      this.smallImageUrl});

  factory _$SharePermitImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharePermitImageImplFromJson(json);

  @override
  final String? caption;
  @override
  final int? height;
  @override
  final int? width;
  @override
  final String? imageUrl;
  @override
  final String? smallImageUrl;

  @override
  String toString() {
    return 'SharePermitImage(caption: $caption, height: $height, width: $width, imageUrl: $imageUrl, smallImageUrl: $smallImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharePermitImageImpl &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.smallImageUrl, smallImageUrl) ||
                other.smallImageUrl == smallImageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, caption, height, width, imageUrl, smallImageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharePermitImageImplCopyWith<_$SharePermitImageImpl> get copyWith =>
      __$$SharePermitImageImplCopyWithImpl<_$SharePermitImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharePermitImageImplToJson(
      this,
    );
  }
}

abstract class _SharePermitImage implements SharePermitImage {
  const factory _SharePermitImage(
      {final String? caption,
      final int? height,
      final int? width,
      final String? imageUrl,
      final String? smallImageUrl}) = _$SharePermitImageImpl;

  factory _SharePermitImage.fromJson(Map<String, dynamic> json) =
      _$SharePermitImageImpl.fromJson;

  @override
  String? get caption;
  @override
  int? get height;
  @override
  int? get width;
  @override
  String? get imageUrl;
  @override
  String? get smallImageUrl;
  @override
  @JsonKey(ignore: true)
  _$$SharePermitImageImplCopyWith<_$SharePermitImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SharePermitDesc _$SharePermitDescFromJson(Map<String, dynamic> json) {
  return _SharePermitDesc.fromJson(json);
}

/// @nodoc
mixin _$SharePermitDesc {
  String? get permitTitle => throw _privateConstructorUsedError;
  String? get permitExplain => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SharePermitDescCopyWith<SharePermitDesc> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SharePermitDescCopyWith<$Res> {
  factory $SharePermitDescCopyWith(
          SharePermitDesc value, $Res Function(SharePermitDesc) then) =
      _$SharePermitDescCopyWithImpl<$Res, SharePermitDesc>;
  @useResult
  $Res call({String? permitTitle, String? permitExplain});
}

/// @nodoc
class _$SharePermitDescCopyWithImpl<$Res, $Val extends SharePermitDesc>
    implements $SharePermitDescCopyWith<$Res> {
  _$SharePermitDescCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permitTitle = freezed,
    Object? permitExplain = freezed,
  }) {
    return _then(_value.copyWith(
      permitTitle: freezed == permitTitle
          ? _value.permitTitle
          : permitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      permitExplain: freezed == permitExplain
          ? _value.permitExplain
          : permitExplain // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SharePermitDescImplCopyWith<$Res>
    implements $SharePermitDescCopyWith<$Res> {
  factory _$$SharePermitDescImplCopyWith(_$SharePermitDescImpl value,
          $Res Function(_$SharePermitDescImpl) then) =
      __$$SharePermitDescImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? permitTitle, String? permitExplain});
}

/// @nodoc
class __$$SharePermitDescImplCopyWithImpl<$Res>
    extends _$SharePermitDescCopyWithImpl<$Res, _$SharePermitDescImpl>
    implements _$$SharePermitDescImplCopyWith<$Res> {
  __$$SharePermitDescImplCopyWithImpl(
      _$SharePermitDescImpl _value, $Res Function(_$SharePermitDescImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permitTitle = freezed,
    Object? permitExplain = freezed,
  }) {
    return _then(_$SharePermitDescImpl(
      permitTitle: freezed == permitTitle
          ? _value.permitTitle
          : permitTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      permitExplain: freezed == permitExplain
          ? _value.permitExplain
          : permitExplain // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SharePermitDescImpl implements _SharePermitDesc {
  const _$SharePermitDescImpl({this.permitTitle, this.permitExplain});

  factory _$SharePermitDescImpl.fromJson(Map<String, dynamic> json) =>
      _$$SharePermitDescImplFromJson(json);

  @override
  final String? permitTitle;
  @override
  final String? permitExplain;

  @override
  String toString() {
    return 'SharePermitDesc(permitTitle: $permitTitle, permitExplain: $permitExplain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SharePermitDescImpl &&
            (identical(other.permitTitle, permitTitle) ||
                other.permitTitle == permitTitle) &&
            (identical(other.permitExplain, permitExplain) ||
                other.permitExplain == permitExplain));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, permitTitle, permitExplain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SharePermitDescImplCopyWith<_$SharePermitDescImpl> get copyWith =>
      __$$SharePermitDescImplCopyWithImpl<_$SharePermitDescImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SharePermitDescImplToJson(
      this,
    );
  }
}

abstract class _SharePermitDesc implements SharePermitDesc {
  const factory _SharePermitDesc(
      {final String? permitTitle,
      final String? permitExplain}) = _$SharePermitDescImpl;

  factory _SharePermitDesc.fromJson(Map<String, dynamic> json) =
      _$SharePermitDescImpl.fromJson;

  @override
  String? get permitTitle;
  @override
  String? get permitExplain;
  @override
  @JsonKey(ignore: true)
  _$$SharePermitDescImplCopyWith<_$SharePermitDescImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
