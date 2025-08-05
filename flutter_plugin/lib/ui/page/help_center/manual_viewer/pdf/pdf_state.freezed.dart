// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pdf_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PdfState {
  String get title => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get refreshCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PdfStateCopyWith<PdfState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PdfStateCopyWith<$Res> {
  factory $PdfStateCopyWith(PdfState value, $Res Function(PdfState) then) =
      _$PdfStateCopyWithImpl<$Res, PdfState>;
  @useResult
  $Res call({String title, String url, int refreshCount});
}

/// @nodoc
class _$PdfStateCopyWithImpl<$Res, $Val extends PdfState>
    implements $PdfStateCopyWith<$Res> {
  _$PdfStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? refreshCount = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      refreshCount: null == refreshCount
          ? _value.refreshCount
          : refreshCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PdfStateImplCopyWith<$Res>
    implements $PdfStateCopyWith<$Res> {
  factory _$$PdfStateImplCopyWith(
          _$PdfStateImpl value, $Res Function(_$PdfStateImpl) then) =
      __$$PdfStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String url, int refreshCount});
}

/// @nodoc
class __$$PdfStateImplCopyWithImpl<$Res>
    extends _$PdfStateCopyWithImpl<$Res, _$PdfStateImpl>
    implements _$$PdfStateImplCopyWith<$Res> {
  __$$PdfStateImplCopyWithImpl(
      _$PdfStateImpl _value, $Res Function(_$PdfStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? refreshCount = null,
  }) {
    return _then(_$PdfStateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      refreshCount: null == refreshCount
          ? _value.refreshCount
          : refreshCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PdfStateImpl implements _PdfState {
  const _$PdfStateImpl({this.title = '', this.url = '', this.refreshCount = 0});

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final int refreshCount;

  @override
  String toString() {
    return 'PdfState(title: $title, url: $url, refreshCount: $refreshCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PdfStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.refreshCount, refreshCount) ||
                other.refreshCount == refreshCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, url, refreshCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PdfStateImplCopyWith<_$PdfStateImpl> get copyWith =>
      __$$PdfStateImplCopyWithImpl<_$PdfStateImpl>(this, _$identity);
}

abstract class _PdfState implements PdfState {
  const factory _PdfState(
      {final String title,
      final String url,
      final int refreshCount}) = _$PdfStateImpl;

  @override
  String get title;
  @override
  String get url;
  @override
  int get refreshCount;
  @override
  @JsonKey(ignore: true)
  _$$PdfStateImplCopyWith<_$PdfStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
