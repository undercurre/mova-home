// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggest_history_box.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SuggestHistoryBox _$SuggestHistoryBoxFromJson(Map<String, dynamic> json) {
  return _SuggestHistoryBox.fromJson(json);
}

/// @nodoc
mixin _$SuggestHistoryBox {
  List<SuggestHistory>? get records => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestHistoryBoxCopyWith<SuggestHistoryBox> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestHistoryBoxCopyWith<$Res> {
  factory $SuggestHistoryBoxCopyWith(
          SuggestHistoryBox value, $Res Function(SuggestHistoryBox) then) =
      _$SuggestHistoryBoxCopyWithImpl<$Res, SuggestHistoryBox>;
  @useResult
  $Res call({List<SuggestHistory>? records});
}

/// @nodoc
class _$SuggestHistoryBoxCopyWithImpl<$Res, $Val extends SuggestHistoryBox>
    implements $SuggestHistoryBoxCopyWith<$Res> {
  _$SuggestHistoryBoxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = freezed,
  }) {
    return _then(_value.copyWith(
      records: freezed == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<SuggestHistory>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestHistoryBoxImplCopyWith<$Res>
    implements $SuggestHistoryBoxCopyWith<$Res> {
  factory _$$SuggestHistoryBoxImplCopyWith(_$SuggestHistoryBoxImpl value,
          $Res Function(_$SuggestHistoryBoxImpl) then) =
      __$$SuggestHistoryBoxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SuggestHistory>? records});
}

/// @nodoc
class __$$SuggestHistoryBoxImplCopyWithImpl<$Res>
    extends _$SuggestHistoryBoxCopyWithImpl<$Res, _$SuggestHistoryBoxImpl>
    implements _$$SuggestHistoryBoxImplCopyWith<$Res> {
  __$$SuggestHistoryBoxImplCopyWithImpl(_$SuggestHistoryBoxImpl _value,
      $Res Function(_$SuggestHistoryBoxImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = freezed,
  }) {
    return _then(_$SuggestHistoryBoxImpl(
      records: freezed == records
          ? _value._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<SuggestHistory>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestHistoryBoxImpl implements _SuggestHistoryBox {
  _$SuggestHistoryBoxImpl({final List<SuggestHistory>? records})
      : _records = records;

  factory _$SuggestHistoryBoxImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestHistoryBoxImplFromJson(json);

  final List<SuggestHistory>? _records;
  @override
  List<SuggestHistory>? get records {
    final value = _records;
    if (value == null) return null;
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SuggestHistoryBox(records: $records)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestHistoryBoxImpl &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_records));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestHistoryBoxImplCopyWith<_$SuggestHistoryBoxImpl> get copyWith =>
      __$$SuggestHistoryBoxImplCopyWithImpl<_$SuggestHistoryBoxImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestHistoryBoxImplToJson(
      this,
    );
  }
}

abstract class _SuggestHistoryBox implements SuggestHistoryBox {
  factory _SuggestHistoryBox({final List<SuggestHistory>? records}) =
      _$SuggestHistoryBoxImpl;

  factory _SuggestHistoryBox.fromJson(Map<String, dynamic> json) =
      _$SuggestHistoryBoxImpl.fromJson;

  @override
  List<SuggestHistory>? get records;
  @override
  @JsonKey(ignore: true)
  _$$SuggestHistoryBoxImplCopyWith<_$SuggestHistoryBoxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestHistory _$SuggestHistoryFromJson(Map<String, dynamic> json) {
  return _SuggestHistory.fromJson(json);
}

/// @nodoc
mixin _$SuggestHistory {
  String get id => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  double get createTime => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get deviceIconUrl => throw _privateConstructorUsedError;
  String get modelName => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  List<String>? get adviseTagNames => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  List<String>? get videos => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestHistoryCopyWith<SuggestHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestHistoryCopyWith<$Res> {
  factory $SuggestHistoryCopyWith(
          SuggestHistory value, $Res Function(SuggestHistory) then) =
      _$SuggestHistoryCopyWithImpl<$Res, SuggestHistory>;
  @useResult
  $Res call(
      {String id,
      int status,
      double createTime,
      String content,
      String deviceIconUrl,
      String modelName,
      int type,
      List<String>? adviseTagNames,
      List<String>? images,
      List<String>? videos});
}

/// @nodoc
class _$SuggestHistoryCopyWithImpl<$Res, $Val extends SuggestHistory>
    implements $SuggestHistoryCopyWith<$Res> {
  _$SuggestHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? createTime = null,
    Object? content = null,
    Object? deviceIconUrl = null,
    Object? modelName = null,
    Object? type = null,
    Object? adviseTagNames = freezed,
    Object? images = freezed,
    Object? videos = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as double,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      deviceIconUrl: null == deviceIconUrl
          ? _value.deviceIconUrl
          : deviceIconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      modelName: null == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      adviseTagNames: freezed == adviseTagNames
          ? _value.adviseTagNames
          : adviseTagNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      videos: freezed == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestHistoryImplCopyWith<$Res>
    implements $SuggestHistoryCopyWith<$Res> {
  factory _$$SuggestHistoryImplCopyWith(_$SuggestHistoryImpl value,
          $Res Function(_$SuggestHistoryImpl) then) =
      __$$SuggestHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int status,
      double createTime,
      String content,
      String deviceIconUrl,
      String modelName,
      int type,
      List<String>? adviseTagNames,
      List<String>? images,
      List<String>? videos});
}

/// @nodoc
class __$$SuggestHistoryImplCopyWithImpl<$Res>
    extends _$SuggestHistoryCopyWithImpl<$Res, _$SuggestHistoryImpl>
    implements _$$SuggestHistoryImplCopyWith<$Res> {
  __$$SuggestHistoryImplCopyWithImpl(
      _$SuggestHistoryImpl _value, $Res Function(_$SuggestHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? createTime = null,
    Object? content = null,
    Object? deviceIconUrl = null,
    Object? modelName = null,
    Object? type = null,
    Object? adviseTagNames = freezed,
    Object? images = freezed,
    Object? videos = freezed,
  }) {
    return _then(_$SuggestHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as double,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      deviceIconUrl: null == deviceIconUrl
          ? _value.deviceIconUrl
          : deviceIconUrl // ignore: cast_nullable_to_non_nullable
              as String,
      modelName: null == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      adviseTagNames: freezed == adviseTagNames
          ? _value._adviseTagNames
          : adviseTagNames // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      videos: freezed == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestHistoryImpl implements _SuggestHistory {
  _$SuggestHistoryImpl(
      {this.id = '',
      this.status = 0,
      this.createTime = 0,
      this.content = '',
      this.deviceIconUrl = '',
      this.modelName = '',
      this.type = 0,
      final List<String>? adviseTagNames,
      final List<String>? images,
      final List<String>? videos})
      : _adviseTagNames = adviseTagNames,
        _images = images,
        _videos = videos;

  factory _$SuggestHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestHistoryImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final int status;
  @override
  @JsonKey()
  final double createTime;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String deviceIconUrl;
  @override
  @JsonKey()
  final String modelName;
  @override
  @JsonKey()
  final int type;
  final List<String>? _adviseTagNames;
  @override
  List<String>? get adviseTagNames {
    final value = _adviseTagNames;
    if (value == null) return null;
    if (_adviseTagNames is EqualUnmodifiableListView) return _adviseTagNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _images;
  @override
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _videos;
  @override
  List<String>? get videos {
    final value = _videos;
    if (value == null) return null;
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SuggestHistory(id: $id, status: $status, createTime: $createTime, content: $content, deviceIconUrl: $deviceIconUrl, modelName: $modelName, type: $type, adviseTagNames: $adviseTagNames, images: $images, videos: $videos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.deviceIconUrl, deviceIconUrl) ||
                other.deviceIconUrl == deviceIconUrl) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._adviseTagNames, _adviseTagNames) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._videos, _videos));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      createTime,
      content,
      deviceIconUrl,
      modelName,
      type,
      const DeepCollectionEquality().hash(_adviseTagNames),
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_videos));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestHistoryImplCopyWith<_$SuggestHistoryImpl> get copyWith =>
      __$$SuggestHistoryImplCopyWithImpl<_$SuggestHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestHistoryImplToJson(
      this,
    );
  }
}

abstract class _SuggestHistory implements SuggestHistory {
  factory _SuggestHistory(
      {final String id,
      final int status,
      final double createTime,
      final String content,
      final String deviceIconUrl,
      final String modelName,
      final int type,
      final List<String>? adviseTagNames,
      final List<String>? images,
      final List<String>? videos}) = _$SuggestHistoryImpl;

  factory _SuggestHistory.fromJson(Map<String, dynamic> json) =
      _$SuggestHistoryImpl.fromJson;

  @override
  String get id;
  @override
  int get status;
  @override
  double get createTime;
  @override
  String get content;
  @override
  String get deviceIconUrl;
  @override
  String get modelName;
  @override
  int get type;
  @override
  List<String>? get adviseTagNames;
  @override
  List<String>? get images;
  @override
  List<String>? get videos;
  @override
  @JsonKey(ignore: true)
  _$$SuggestHistoryImplCopyWith<_$SuggestHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
