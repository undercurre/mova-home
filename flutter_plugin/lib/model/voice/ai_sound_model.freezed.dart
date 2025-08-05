// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_sound_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiSoundModel _$AiSoundModelFromJson(Map<String, dynamic> json) {
  return _AiSoundModel.fromJson(json);
}

/// @nodoc
mixin _$AiSoundModel {
  String get name => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get linkUrl => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get button => throw _privateConstructorUsedError;
  SoundDetailModel? get android => throw _privateConstructorUsedError;
  SoundDetailModel? get ios => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AiSoundModelCopyWith<AiSoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiSoundModelCopyWith<$Res> {
  factory $AiSoundModelCopyWith(
          AiSoundModel value, $Res Function(AiSoundModel) then) =
      _$AiSoundModelCopyWithImpl<$Res, AiSoundModel>;
  @useResult
  $Res call(
      {String name,
      String imageUrl,
      String linkUrl,
      String title,
      String? button,
      SoundDetailModel? android,
      SoundDetailModel? ios});

  $SoundDetailModelCopyWith<$Res>? get android;
  $SoundDetailModelCopyWith<$Res>? get ios;
}

/// @nodoc
class _$AiSoundModelCopyWithImpl<$Res, $Val extends AiSoundModel>
    implements $AiSoundModelCopyWith<$Res> {
  _$AiSoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? imageUrl = null,
    Object? linkUrl = null,
    Object? title = null,
    Object? button = freezed,
    Object? android = freezed,
    Object? ios = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      linkUrl: null == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      button: freezed == button
          ? _value.button
          : button // ignore: cast_nullable_to_non_nullable
              as String?,
      android: freezed == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as SoundDetailModel?,
      ios: freezed == ios
          ? _value.ios
          : ios // ignore: cast_nullable_to_non_nullable
              as SoundDetailModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SoundDetailModelCopyWith<$Res>? get android {
    if (_value.android == null) {
      return null;
    }

    return $SoundDetailModelCopyWith<$Res>(_value.android!, (value) {
      return _then(_value.copyWith(android: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SoundDetailModelCopyWith<$Res>? get ios {
    if (_value.ios == null) {
      return null;
    }

    return $SoundDetailModelCopyWith<$Res>(_value.ios!, (value) {
      return _then(_value.copyWith(ios: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AiSoundModelImplCopyWith<$Res>
    implements $AiSoundModelCopyWith<$Res> {
  factory _$$AiSoundModelImplCopyWith(
          _$AiSoundModelImpl value, $Res Function(_$AiSoundModelImpl) then) =
      __$$AiSoundModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String imageUrl,
      String linkUrl,
      String title,
      String? button,
      SoundDetailModel? android,
      SoundDetailModel? ios});

  @override
  $SoundDetailModelCopyWith<$Res>? get android;
  @override
  $SoundDetailModelCopyWith<$Res>? get ios;
}

/// @nodoc
class __$$AiSoundModelImplCopyWithImpl<$Res>
    extends _$AiSoundModelCopyWithImpl<$Res, _$AiSoundModelImpl>
    implements _$$AiSoundModelImplCopyWith<$Res> {
  __$$AiSoundModelImplCopyWithImpl(
      _$AiSoundModelImpl _value, $Res Function(_$AiSoundModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? imageUrl = null,
    Object? linkUrl = null,
    Object? title = null,
    Object? button = freezed,
    Object? android = freezed,
    Object? ios = freezed,
  }) {
    return _then(_$AiSoundModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      linkUrl: null == linkUrl
          ? _value.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      button: freezed == button
          ? _value.button
          : button // ignore: cast_nullable_to_non_nullable
              as String?,
      android: freezed == android
          ? _value.android
          : android // ignore: cast_nullable_to_non_nullable
              as SoundDetailModel?,
      ios: freezed == ios
          ? _value.ios
          : ios // ignore: cast_nullable_to_non_nullable
              as SoundDetailModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiSoundModelImpl implements _AiSoundModel {
  _$AiSoundModelImpl(
      {required this.name,
      required this.imageUrl,
      required this.linkUrl,
      required this.title,
      this.button = '',
      this.android,
      this.ios});

  factory _$AiSoundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiSoundModelImplFromJson(json);

  @override
  final String name;
  @override
  final String imageUrl;
  @override
  final String linkUrl;
  @override
  final String title;
  @override
  @JsonKey()
  final String? button;
  @override
  final SoundDetailModel? android;
  @override
  final SoundDetailModel? ios;

  @override
  String toString() {
    return 'AiSoundModel(name: $name, imageUrl: $imageUrl, linkUrl: $linkUrl, title: $title, button: $button, android: $android, ios: $ios)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiSoundModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.button, button) || other.button == button) &&
            (identical(other.android, android) || other.android == android) &&
            (identical(other.ios, ios) || other.ios == ios));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, imageUrl, linkUrl, title, button, android, ios);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AiSoundModelImplCopyWith<_$AiSoundModelImpl> get copyWith =>
      __$$AiSoundModelImplCopyWithImpl<_$AiSoundModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiSoundModelImplToJson(
      this,
    );
  }
}

abstract class _AiSoundModel implements AiSoundModel {
  factory _AiSoundModel(
      {required final String name,
      required final String imageUrl,
      required final String linkUrl,
      required final String title,
      final String? button,
      final SoundDetailModel? android,
      final SoundDetailModel? ios}) = _$AiSoundModelImpl;

  factory _AiSoundModel.fromJson(Map<String, dynamic> json) =
      _$AiSoundModelImpl.fromJson;

  @override
  String get name;
  @override
  String get imageUrl;
  @override
  String get linkUrl;
  @override
  String get title;
  @override
  String? get button;
  @override
  SoundDetailModel? get android;
  @override
  SoundDetailModel? get ios;
  @override
  @JsonKey(ignore: true)
  _$$AiSoundModelImplCopyWith<_$AiSoundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SoundDetailModel _$SoundDetailModelFromJson(Map<String, dynamic> json) {
  return _SoundDetailModel.fromJson(json);
}

/// @nodoc
mixin _$SoundDetailModel {
  String get packageName => throw _privateConstructorUsedError;
  String get downloadUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoundDetailModelCopyWith<SoundDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoundDetailModelCopyWith<$Res> {
  factory $SoundDetailModelCopyWith(
          SoundDetailModel value, $Res Function(SoundDetailModel) then) =
      _$SoundDetailModelCopyWithImpl<$Res, SoundDetailModel>;
  @useResult
  $Res call({String packageName, String downloadUrl});
}

/// @nodoc
class _$SoundDetailModelCopyWithImpl<$Res, $Val extends SoundDetailModel>
    implements $SoundDetailModelCopyWith<$Res> {
  _$SoundDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? downloadUrl = null,
  }) {
    return _then(_value.copyWith(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoundDetailModelImplCopyWith<$Res>
    implements $SoundDetailModelCopyWith<$Res> {
  factory _$$SoundDetailModelImplCopyWith(_$SoundDetailModelImpl value,
          $Res Function(_$SoundDetailModelImpl) then) =
      __$$SoundDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String packageName, String downloadUrl});
}

/// @nodoc
class __$$SoundDetailModelImplCopyWithImpl<$Res>
    extends _$SoundDetailModelCopyWithImpl<$Res, _$SoundDetailModelImpl>
    implements _$$SoundDetailModelImplCopyWith<$Res> {
  __$$SoundDetailModelImplCopyWithImpl(_$SoundDetailModelImpl _value,
      $Res Function(_$SoundDetailModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? downloadUrl = null,
  }) {
    return _then(_$SoundDetailModelImpl(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoundDetailModelImpl implements _SoundDetailModel {
  _$SoundDetailModelImpl({this.packageName = '', this.downloadUrl = ''});

  factory _$SoundDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoundDetailModelImplFromJson(json);

  @override
  @JsonKey()
  final String packageName;
  @override
  @JsonKey()
  final String downloadUrl;

  @override
  String toString() {
    return 'SoundDetailModel(packageName: $packageName, downloadUrl: $downloadUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoundDetailModelImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, packageName, downloadUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoundDetailModelImplCopyWith<_$SoundDetailModelImpl> get copyWith =>
      __$$SoundDetailModelImplCopyWithImpl<_$SoundDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoundDetailModelImplToJson(
      this,
    );
  }
}

abstract class _SoundDetailModel implements SoundDetailModel {
  factory _SoundDetailModel(
      {final String packageName,
      final String downloadUrl}) = _$SoundDetailModelImpl;

  factory _SoundDetailModel.fromJson(Map<String, dynamic> json) =
      _$SoundDetailModelImpl.fromJson;

  @override
  String get packageName;
  @override
  String get downloadUrl;
  @override
  @JsonKey(ignore: true)
  _$$SoundDetailModelImplCopyWith<_$SoundDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
