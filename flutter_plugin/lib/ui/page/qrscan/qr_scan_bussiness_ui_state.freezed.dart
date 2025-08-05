// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_scan_bussiness_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QrScanBussinessUiState {
  bool get loading => throw _privateConstructorUsedError;
  bool get isTorchOn => throw _privateConstructorUsedError;
  List<dynamic> get dreameBarcode => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QrScanBussinessUiStateCopyWith<QrScanBussinessUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrScanBussinessUiStateCopyWith<$Res> {
  factory $QrScanBussinessUiStateCopyWith(QrScanBussinessUiState value,
          $Res Function(QrScanBussinessUiState) then) =
      _$QrScanBussinessUiStateCopyWithImpl<$Res, QrScanBussinessUiState>;
  @useResult
  $Res call(
      {bool loading,
      bool isTorchOn,
      List<dynamic> dreameBarcode,
      CommonUIEvent event});
}

/// @nodoc
class _$QrScanBussinessUiStateCopyWithImpl<$Res,
        $Val extends QrScanBussinessUiState>
    implements $QrScanBussinessUiStateCopyWith<$Res> {
  _$QrScanBussinessUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isTorchOn = null,
    Object? dreameBarcode = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTorchOn: null == isTorchOn
          ? _value.isTorchOn
          : isTorchOn // ignore: cast_nullable_to_non_nullable
              as bool,
      dreameBarcode: null == dreameBarcode
          ? _value.dreameBarcode
          : dreameBarcode // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrScanBussinessUiStateImplCopyWith<$Res>
    implements $QrScanBussinessUiStateCopyWith<$Res> {
  factory _$$QrScanBussinessUiStateImplCopyWith(
          _$QrScanBussinessUiStateImpl value,
          $Res Function(_$QrScanBussinessUiStateImpl) then) =
      __$$QrScanBussinessUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool isTorchOn,
      List<dynamic> dreameBarcode,
      CommonUIEvent event});
}

/// @nodoc
class __$$QrScanBussinessUiStateImplCopyWithImpl<$Res>
    extends _$QrScanBussinessUiStateCopyWithImpl<$Res,
        _$QrScanBussinessUiStateImpl>
    implements _$$QrScanBussinessUiStateImplCopyWith<$Res> {
  __$$QrScanBussinessUiStateImplCopyWithImpl(
      _$QrScanBussinessUiStateImpl _value,
      $Res Function(_$QrScanBussinessUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isTorchOn = null,
    Object? dreameBarcode = null,
    Object? event = null,
  }) {
    return _then(_$QrScanBussinessUiStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTorchOn: null == isTorchOn
          ? _value.isTorchOn
          : isTorchOn // ignore: cast_nullable_to_non_nullable
              as bool,
      dreameBarcode: null == dreameBarcode
          ? _value._dreameBarcode
          : dreameBarcode // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$QrScanBussinessUiStateImpl implements _QrScanBussinessUiState {
  _$QrScanBussinessUiStateImpl(
      {this.loading = false,
      this.isTorchOn = false,
      final List<dynamic> dreameBarcode = const [],
      this.event = const EmptyEvent()})
      : _dreameBarcode = dreameBarcode;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool isTorchOn;
  final List<dynamic> _dreameBarcode;
  @override
  @JsonKey()
  List<dynamic> get dreameBarcode {
    if (_dreameBarcode is EqualUnmodifiableListView) return _dreameBarcode;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dreameBarcode);
  }

  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'QrScanBussinessUiState(loading: $loading, isTorchOn: $isTorchOn, dreameBarcode: $dreameBarcode, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrScanBussinessUiStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isTorchOn, isTorchOn) ||
                other.isTorchOn == isTorchOn) &&
            const DeepCollectionEquality()
                .equals(other._dreameBarcode, _dreameBarcode) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, isTorchOn,
      const DeepCollectionEquality().hash(_dreameBarcode), event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QrScanBussinessUiStateImplCopyWith<_$QrScanBussinessUiStateImpl>
      get copyWith => __$$QrScanBussinessUiStateImplCopyWithImpl<
          _$QrScanBussinessUiStateImpl>(this, _$identity);
}

abstract class _QrScanBussinessUiState implements QrScanBussinessUiState {
  factory _QrScanBussinessUiState(
      {final bool loading,
      final bool isTorchOn,
      final List<dynamic> dreameBarcode,
      final CommonUIEvent event}) = _$QrScanBussinessUiStateImpl;

  @override
  bool get loading;
  @override
  bool get isTorchOn;
  @override
  List<dynamic> get dreameBarcode;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$QrScanBussinessUiStateImplCopyWith<_$QrScanBussinessUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
