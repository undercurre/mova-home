// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedBackTag _$FeedBackTagFromJson(Map<String, dynamic> json) {
  return _FeedBackTag.fromJson(json);
}

/// @nodoc
mixin _$FeedBackTag {
  String get tagId => throw _privateConstructorUsedError;
  String get tagName => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedBackTagCopyWith<FeedBackTag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedBackTagCopyWith<$Res> {
  factory $FeedBackTagCopyWith(
          FeedBackTag value, $Res Function(FeedBackTag) then) =
      _$FeedBackTagCopyWithImpl<$Res, FeedBackTag>;
  @useResult
  $Res call({String tagId, String tagName, bool isSelected});
}

/// @nodoc
class _$FeedBackTagCopyWithImpl<$Res, $Val extends FeedBackTag>
    implements $FeedBackTagCopyWith<$Res> {
  _$FeedBackTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagId = null,
    Object? tagName = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      tagId: null == tagId
          ? _value.tagId
          : tagId // ignore: cast_nullable_to_non_nullable
              as String,
      tagName: null == tagName
          ? _value.tagName
          : tagName // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedBackTagImplCopyWith<$Res>
    implements $FeedBackTagCopyWith<$Res> {
  factory _$$FeedBackTagImplCopyWith(
          _$FeedBackTagImpl value, $Res Function(_$FeedBackTagImpl) then) =
      __$$FeedBackTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tagId, String tagName, bool isSelected});
}

/// @nodoc
class __$$FeedBackTagImplCopyWithImpl<$Res>
    extends _$FeedBackTagCopyWithImpl<$Res, _$FeedBackTagImpl>
    implements _$$FeedBackTagImplCopyWith<$Res> {
  __$$FeedBackTagImplCopyWithImpl(
      _$FeedBackTagImpl _value, $Res Function(_$FeedBackTagImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tagId = null,
    Object? tagName = null,
    Object? isSelected = null,
  }) {
    return _then(_$FeedBackTagImpl(
      tagId: null == tagId
          ? _value.tagId
          : tagId // ignore: cast_nullable_to_non_nullable
              as String,
      tagName: null == tagName
          ? _value.tagName
          : tagName // ignore: cast_nullable_to_non_nullable
              as String,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedBackTagImpl implements _FeedBackTag {
  _$FeedBackTagImpl(
      {this.tagId = '', this.tagName = '', this.isSelected = false});

  factory _$FeedBackTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedBackTagImplFromJson(json);

  @override
  @JsonKey()
  final String tagId;
  @override
  @JsonKey()
  final String tagName;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'FeedBackTag(tagId: $tagId, tagName: $tagName, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedBackTagImpl &&
            (identical(other.tagId, tagId) || other.tagId == tagId) &&
            (identical(other.tagName, tagName) || other.tagName == tagName) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tagId, tagName, isSelected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedBackTagImplCopyWith<_$FeedBackTagImpl> get copyWith =>
      __$$FeedBackTagImplCopyWithImpl<_$FeedBackTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedBackTagImplToJson(
      this,
    );
  }
}

abstract class _FeedBackTag implements FeedBackTag {
  factory _FeedBackTag(
      {final String tagId,
      final String tagName,
      final bool isSelected}) = _$FeedBackTagImpl;

  factory _FeedBackTag.fromJson(Map<String, dynamic> json) =
      _$FeedBackTagImpl.fromJson;

  @override
  String get tagId;
  @override
  String get tagName;
  @override
  bool get isSelected;
  @override
  @JsonKey(ignore: true)
  _$$FeedBackTagImplCopyWith<_$FeedBackTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
