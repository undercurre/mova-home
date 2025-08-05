// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_manual_viewer_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProductManualViewerUIState {
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get requestFaild => throw _privateConstructorUsedError;
  String? get pdfUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProductManualViewerUIStateCopyWith<ProductManualViewerUIState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductManualViewerUIStateCopyWith<$Res> {
  factory $ProductManualViewerUIStateCopyWith(ProductManualViewerUIState value,
          $Res Function(ProductManualViewerUIState) then) =
      _$ProductManualViewerUIStateCopyWithImpl<$Res,
          ProductManualViewerUIState>;
  @useResult
  $Res call({CommonUIEvent event, bool requestFaild, String? pdfUrl});
}

/// @nodoc
class _$ProductManualViewerUIStateCopyWithImpl<$Res,
        $Val extends ProductManualViewerUIState>
    implements $ProductManualViewerUIStateCopyWith<$Res> {
  _$ProductManualViewerUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? requestFaild = null,
    Object? pdfUrl = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      requestFaild: null == requestFaild
          ? _value.requestFaild
          : requestFaild // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductManualViewerUIStateImplCopyWith<$Res>
    implements $ProductManualViewerUIStateCopyWith<$Res> {
  factory _$$ProductManualViewerUIStateImplCopyWith(
          _$ProductManualViewerUIStateImpl value,
          $Res Function(_$ProductManualViewerUIStateImpl) then) =
      __$$ProductManualViewerUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommonUIEvent event, bool requestFaild, String? pdfUrl});
}

/// @nodoc
class __$$ProductManualViewerUIStateImplCopyWithImpl<$Res>
    extends _$ProductManualViewerUIStateCopyWithImpl<$Res,
        _$ProductManualViewerUIStateImpl>
    implements _$$ProductManualViewerUIStateImplCopyWith<$Res> {
  __$$ProductManualViewerUIStateImplCopyWithImpl(
      _$ProductManualViewerUIStateImpl _value,
      $Res Function(_$ProductManualViewerUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? requestFaild = null,
    Object? pdfUrl = freezed,
  }) {
    return _then(_$ProductManualViewerUIStateImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      requestFaild: null == requestFaild
          ? _value.requestFaild
          : requestFaild // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ProductManualViewerUIStateImpl implements _ProductManualViewerUIState {
  const _$ProductManualViewerUIStateImpl(
      {this.event = const EmptyEvent(),
      this.requestFaild = false,
      this.pdfUrl});

  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool requestFaild;
  @override
  final String? pdfUrl;

  @override
  String toString() {
    return 'ProductManualViewerUIState(event: $event, requestFaild: $requestFaild, pdfUrl: $pdfUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductManualViewerUIStateImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.requestFaild, requestFaild) ||
                other.requestFaild == requestFaild) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event, requestFaild, pdfUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductManualViewerUIStateImplCopyWith<_$ProductManualViewerUIStateImpl>
      get copyWith => __$$ProductManualViewerUIStateImplCopyWithImpl<
          _$ProductManualViewerUIStateImpl>(this, _$identity);
}

abstract class _ProductManualViewerUIState
    implements ProductManualViewerUIState {
  const factory _ProductManualViewerUIState(
      {final CommonUIEvent event,
      final bool requestFaild,
      final String? pdfUrl}) = _$ProductManualViewerUIStateImpl;

  @override
  CommonUIEvent get event;
  @override
  bool get requestFaild;
  @override
  String? get pdfUrl;
  @override
  @JsonKey(ignore: true)
  _$$ProductManualViewerUIStateImplCopyWith<_$ProductManualViewerUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
