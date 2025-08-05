// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webview_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WebviewUistate {
  String get title => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  bool get isHideTitle => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WebviewUistateCopyWith<WebviewUistate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebviewUistateCopyWith<$Res> {
  factory $WebviewUistateCopyWith(
          WebviewUistate value, $Res Function(WebviewUistate) then) =
      _$WebviewUistateCopyWithImpl<$Res, WebviewUistate>;
  @useResult
  $Res call({String title, String url, bool isHideTitle});
}

/// @nodoc
class _$WebviewUistateCopyWithImpl<$Res, $Val extends WebviewUistate>
    implements $WebviewUistateCopyWith<$Res> {
  _$WebviewUistateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? isHideTitle = null,
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
      isHideTitle: null == isHideTitle
          ? _value.isHideTitle
          : isHideTitle // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WebviewUistateImplCopyWith<$Res>
    implements $WebviewUistateCopyWith<$Res> {
  factory _$$WebviewUistateImplCopyWith(_$WebviewUistateImpl value,
          $Res Function(_$WebviewUistateImpl) then) =
      __$$WebviewUistateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String url, bool isHideTitle});
}

/// @nodoc
class __$$WebviewUistateImplCopyWithImpl<$Res>
    extends _$WebviewUistateCopyWithImpl<$Res, _$WebviewUistateImpl>
    implements _$$WebviewUistateImplCopyWith<$Res> {
  __$$WebviewUistateImplCopyWithImpl(
      _$WebviewUistateImpl _value, $Res Function(_$WebviewUistateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? isHideTitle = null,
  }) {
    return _then(_$WebviewUistateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      isHideTitle: null == isHideTitle
          ? _value.isHideTitle
          : isHideTitle // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$WebviewUistateImpl
    with DiagnosticableTreeMixin
    implements _WebviewUistate {
  const _$WebviewUistateImpl(
      {required this.title, required this.url, required this.isHideTitle});

  @override
  final String title;
  @override
  final String url;
  @override
  final bool isHideTitle;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WebviewUistate(title: $title, url: $url, isHideTitle: $isHideTitle)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WebviewUistate'))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('isHideTitle', isHideTitle));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebviewUistateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.isHideTitle, isHideTitle) ||
                other.isHideTitle == isHideTitle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, url, isHideTitle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WebviewUistateImplCopyWith<_$WebviewUistateImpl> get copyWith =>
      __$$WebviewUistateImplCopyWithImpl<_$WebviewUistateImpl>(
          this, _$identity);
}

abstract class _WebviewUistate implements WebviewUistate {
  const factory _WebviewUistate(
      {required final String title,
      required final String url,
      required final bool isHideTitle}) = _$WebviewUistateImpl;

  @override
  String get title;
  @override
  String get url;
  @override
  bool get isHideTitle;
  @override
  @JsonKey(ignore: true)
  _$$WebviewUistateImplCopyWith<_$WebviewUistateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
