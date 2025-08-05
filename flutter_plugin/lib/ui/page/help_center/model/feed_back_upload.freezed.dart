// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_back_upload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedBackUpload _$FeedBackUploadFromJson(Map<String, dynamic> json) {
  return _FeedBackUpload.fromJson(json);
}

/// @nodoc
mixin _$FeedBackUpload {
  String get uploadUrl => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedBackUploadCopyWith<FeedBackUpload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedBackUploadCopyWith<$Res> {
  factory $FeedBackUploadCopyWith(
          FeedBackUpload value, $Res Function(FeedBackUpload) then) =
      _$FeedBackUploadCopyWithImpl<$Res, FeedBackUpload>;
  @useResult
  $Res call({String uploadUrl, String url});
}

/// @nodoc
class _$FeedBackUploadCopyWithImpl<$Res, $Val extends FeedBackUpload>
    implements $FeedBackUploadCopyWith<$Res> {
  _$FeedBackUploadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploadUrl = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      uploadUrl: null == uploadUrl
          ? _value.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedBackUploadImplCopyWith<$Res>
    implements $FeedBackUploadCopyWith<$Res> {
  factory _$$FeedBackUploadImplCopyWith(_$FeedBackUploadImpl value,
          $Res Function(_$FeedBackUploadImpl) then) =
      __$$FeedBackUploadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uploadUrl, String url});
}

/// @nodoc
class __$$FeedBackUploadImplCopyWithImpl<$Res>
    extends _$FeedBackUploadCopyWithImpl<$Res, _$FeedBackUploadImpl>
    implements _$$FeedBackUploadImplCopyWith<$Res> {
  __$$FeedBackUploadImplCopyWithImpl(
      _$FeedBackUploadImpl _value, $Res Function(_$FeedBackUploadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uploadUrl = null,
    Object? url = null,
  }) {
    return _then(_$FeedBackUploadImpl(
      uploadUrl: null == uploadUrl
          ? _value.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedBackUploadImpl implements _FeedBackUpload {
  _$FeedBackUploadImpl({this.uploadUrl = '', this.url = ''});

  factory _$FeedBackUploadImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedBackUploadImplFromJson(json);

  @override
  @JsonKey()
  final String uploadUrl;
  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'FeedBackUpload(uploadUrl: $uploadUrl, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedBackUploadImpl &&
            (identical(other.uploadUrl, uploadUrl) ||
                other.uploadUrl == uploadUrl) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uploadUrl, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedBackUploadImplCopyWith<_$FeedBackUploadImpl> get copyWith =>
      __$$FeedBackUploadImplCopyWithImpl<_$FeedBackUploadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedBackUploadImplToJson(
      this,
    );
  }
}

abstract class _FeedBackUpload implements FeedBackUpload {
  factory _FeedBackUpload({final String uploadUrl, final String url}) =
      _$FeedBackUploadImpl;

  factory _FeedBackUpload.fromJson(Map<String, dynamic> json) =
      _$FeedBackUploadImpl.fromJson;

  @override
  String get uploadUrl;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$FeedBackUploadImplCopyWith<_$FeedBackUploadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
