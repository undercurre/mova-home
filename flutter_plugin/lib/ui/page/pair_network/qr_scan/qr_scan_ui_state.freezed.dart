// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_scan_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QrScanUiState {
  bool get loading => throw _privateConstructorUsedError;
  set loading(bool value) => throw _privateConstructorUsedError;
  bool get isTorchOn => throw _privateConstructorUsedError;
  set isTorchOn(bool value) => throw _privateConstructorUsedError;
  bool get isOverSea => throw _privateConstructorUsedError;
  set isOverSea(bool value) => throw _privateConstructorUsedError;
  List<IotDevice> get scannedDevice => throw _privateConstructorUsedError;
  set scannedDevice(List<IotDevice> value) =>
      throw _privateConstructorUsedError;
  List<dynamic> get dreameBarcode => throw _privateConstructorUsedError;
  set dreameBarcode(List<dynamic> value) => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  set event(CommonUIEvent value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QrScanUiStateCopyWith<QrScanUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrScanUiStateCopyWith<$Res> {
  factory $QrScanUiStateCopyWith(
          QrScanUiState value, $Res Function(QrScanUiState) then) =
      _$QrScanUiStateCopyWithImpl<$Res, QrScanUiState>;
  @useResult
  $Res call(
      {bool loading,
      bool isTorchOn,
      bool isOverSea,
      List<IotDevice> scannedDevice,
      List<dynamic> dreameBarcode,
      CommonUIEvent event});
}

/// @nodoc
class _$QrScanUiStateCopyWithImpl<$Res, $Val extends QrScanUiState>
    implements $QrScanUiStateCopyWith<$Res> {
  _$QrScanUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isTorchOn = null,
    Object? isOverSea = null,
    Object? scannedDevice = null,
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
      isOverSea: null == isOverSea
          ? _value.isOverSea
          : isOverSea // ignore: cast_nullable_to_non_nullable
              as bool,
      scannedDevice: null == scannedDevice
          ? _value.scannedDevice
          : scannedDevice // ignore: cast_nullable_to_non_nullable
              as List<IotDevice>,
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
abstract class _$$QrScanUiStateImplCopyWith<$Res>
    implements $QrScanUiStateCopyWith<$Res> {
  factory _$$QrScanUiStateImplCopyWith(
          _$QrScanUiStateImpl value, $Res Function(_$QrScanUiStateImpl) then) =
      __$$QrScanUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool isTorchOn,
      bool isOverSea,
      List<IotDevice> scannedDevice,
      List<dynamic> dreameBarcode,
      CommonUIEvent event});
}

/// @nodoc
class __$$QrScanUiStateImplCopyWithImpl<$Res>
    extends _$QrScanUiStateCopyWithImpl<$Res, _$QrScanUiStateImpl>
    implements _$$QrScanUiStateImplCopyWith<$Res> {
  __$$QrScanUiStateImplCopyWithImpl(
      _$QrScanUiStateImpl _value, $Res Function(_$QrScanUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isTorchOn = null,
    Object? isOverSea = null,
    Object? scannedDevice = null,
    Object? dreameBarcode = null,
    Object? event = null,
  }) {
    return _then(_$QrScanUiStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isTorchOn: null == isTorchOn
          ? _value.isTorchOn
          : isTorchOn // ignore: cast_nullable_to_non_nullable
              as bool,
      isOverSea: null == isOverSea
          ? _value.isOverSea
          : isOverSea // ignore: cast_nullable_to_non_nullable
              as bool,
      scannedDevice: null == scannedDevice
          ? _value.scannedDevice
          : scannedDevice // ignore: cast_nullable_to_non_nullable
              as List<IotDevice>,
      dreameBarcode: null == dreameBarcode
          ? _value.dreameBarcode
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

class _$QrScanUiStateImpl implements _QrScanUiState {
  _$QrScanUiStateImpl(
      {this.loading = false,
      this.isTorchOn = false,
      this.isOverSea = false,
      this.scannedDevice = const [],
      this.dreameBarcode = const [],
      this.event = const EmptyEvent()});

  @override
  @JsonKey()
  bool loading;
  @override
  @JsonKey()
  bool isTorchOn;
  @override
  @JsonKey()
  bool isOverSea;
  @override
  @JsonKey()
  List<IotDevice> scannedDevice;
  @override
  @JsonKey()
  List<dynamic> dreameBarcode;
  @override
  @JsonKey()
  CommonUIEvent event;

  @override
  String toString() {
    return 'QrScanUiState(loading: $loading, isTorchOn: $isTorchOn, isOverSea: $isOverSea, scannedDevice: $scannedDevice, dreameBarcode: $dreameBarcode, event: $event)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QrScanUiStateImplCopyWith<_$QrScanUiStateImpl> get copyWith =>
      __$$QrScanUiStateImplCopyWithImpl<_$QrScanUiStateImpl>(this, _$identity);
}

abstract class _QrScanUiState implements QrScanUiState {
  factory _QrScanUiState(
      {bool loading,
      bool isTorchOn,
      bool isOverSea,
      List<IotDevice> scannedDevice,
      List<dynamic> dreameBarcode,
      CommonUIEvent event}) = _$QrScanUiStateImpl;

  @override
  bool get loading;
  set loading(bool value);
  @override
  bool get isTorchOn;
  set isTorchOn(bool value);
  @override
  bool get isOverSea;
  set isOverSea(bool value);
  @override
  List<IotDevice> get scannedDevice;
  set scannedDevice(List<IotDevice> value);
  @override
  List<dynamic> get dreameBarcode;
  set dreameBarcode(List<dynamic> value);
  @override
  CommonUIEvent get event;
  set event(CommonUIEvent value);
  @override
  @JsonKey(ignore: true)
  _$$QrScanUiStateImplCopyWith<_$QrScanUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QrCodeContent _$QrCodeContentFromJson(Map<String, dynamic> json) {
  return _QrCodeContent.fromJson(json);
}

/// @nodoc
mixin _$QrCodeContent {
  String get model => throw _privateConstructorUsedError;
  String get ap => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QrCodeContentCopyWith<QrCodeContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QrCodeContentCopyWith<$Res> {
  factory $QrCodeContentCopyWith(
          QrCodeContent value, $Res Function(QrCodeContent) then) =
      _$QrCodeContentCopyWithImpl<$Res, QrCodeContent>;
  @useResult
  $Res call({String model, String ap});
}

/// @nodoc
class _$QrCodeContentCopyWithImpl<$Res, $Val extends QrCodeContent>
    implements $QrCodeContentCopyWith<$Res> {
  _$QrCodeContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? ap = null,
  }) {
    return _then(_value.copyWith(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      ap: null == ap
          ? _value.ap
          : ap // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QrCodeContentImplCopyWith<$Res>
    implements $QrCodeContentCopyWith<$Res> {
  factory _$$QrCodeContentImplCopyWith(
          _$QrCodeContentImpl value, $Res Function(_$QrCodeContentImpl) then) =
      __$$QrCodeContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String model, String ap});
}

/// @nodoc
class __$$QrCodeContentImplCopyWithImpl<$Res>
    extends _$QrCodeContentCopyWithImpl<$Res, _$QrCodeContentImpl>
    implements _$$QrCodeContentImplCopyWith<$Res> {
  __$$QrCodeContentImplCopyWithImpl(
      _$QrCodeContentImpl _value, $Res Function(_$QrCodeContentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? ap = null,
  }) {
    return _then(_$QrCodeContentImpl(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      ap: null == ap
          ? _value.ap
          : ap // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QrCodeContentImpl implements _QrCodeContent {
  _$QrCodeContentImpl({this.model = '', this.ap = ''});

  factory _$QrCodeContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$QrCodeContentImplFromJson(json);

  @override
  @JsonKey()
  final String model;
  @override
  @JsonKey()
  final String ap;

  @override
  String toString() {
    return 'QrCodeContent(model: $model, ap: $ap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QrCodeContentImpl &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.ap, ap) || other.ap == ap));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, model, ap);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QrCodeContentImplCopyWith<_$QrCodeContentImpl> get copyWith =>
      __$$QrCodeContentImplCopyWithImpl<_$QrCodeContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QrCodeContentImplToJson(
      this,
    );
  }
}

abstract class _QrCodeContent implements QrCodeContent {
  factory _QrCodeContent({final String model, final String ap}) =
      _$QrCodeContentImpl;

  factory _QrCodeContent.fromJson(Map<String, dynamic> json) =
      _$QrCodeContentImpl.fromJson;

  @override
  String get model;
  @override
  String get ap;
  @override
  @JsonKey(ignore: true)
  _$$QrCodeContentImplCopyWith<_$QrCodeContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
