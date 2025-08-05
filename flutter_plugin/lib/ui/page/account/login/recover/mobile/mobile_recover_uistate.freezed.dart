// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_recover_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MobileRecoverUiState {
  bool get enableSend => throw _privateConstructorUsedError;
  RegionItem? get phoneCodeRegion => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get initPhone => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get prepared => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MobileRecoverUiStateCopyWith<MobileRecoverUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileRecoverUiStateCopyWith<$Res> {
  factory $MobileRecoverUiStateCopyWith(MobileRecoverUiState value,
          $Res Function(MobileRecoverUiState) then) =
      _$MobileRecoverUiStateCopyWithImpl<$Res, MobileRecoverUiState>;
  @useResult
  $Res call(
      {bool enableSend,
      RegionItem? phoneCodeRegion,
      String? phone,
      String? initPhone,
      CommonUIEvent event,
      bool prepared});
}

/// @nodoc
class _$MobileRecoverUiStateCopyWithImpl<$Res,
        $Val extends MobileRecoverUiState>
    implements $MobileRecoverUiStateCopyWith<$Res> {
  _$MobileRecoverUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? phoneCodeRegion = freezed,
    Object? phone = freezed,
    Object? initPhone = freezed,
    Object? event = null,
    Object? prepared = null,
  }) {
    return _then(_value.copyWith(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneCodeRegion: freezed == phoneCodeRegion
          ? _value.phoneCodeRegion
          : phoneCodeRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      initPhone: freezed == initPhone
          ? _value.initPhone
          : initPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      prepared: null == prepared
          ? _value.prepared
          : prepared // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MobileRecoverUiStateImplCopyWith<$Res>
    implements $MobileRecoverUiStateCopyWith<$Res> {
  factory _$$MobileRecoverUiStateImplCopyWith(_$MobileRecoverUiStateImpl value,
          $Res Function(_$MobileRecoverUiStateImpl) then) =
      __$$MobileRecoverUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableSend,
      RegionItem? phoneCodeRegion,
      String? phone,
      String? initPhone,
      CommonUIEvent event,
      bool prepared});
}

/// @nodoc
class __$$MobileRecoverUiStateImplCopyWithImpl<$Res>
    extends _$MobileRecoverUiStateCopyWithImpl<$Res, _$MobileRecoverUiStateImpl>
    implements _$$MobileRecoverUiStateImplCopyWith<$Res> {
  __$$MobileRecoverUiStateImplCopyWithImpl(_$MobileRecoverUiStateImpl _value,
      $Res Function(_$MobileRecoverUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? phoneCodeRegion = freezed,
    Object? phone = freezed,
    Object? initPhone = freezed,
    Object? event = null,
    Object? prepared = null,
  }) {
    return _then(_$MobileRecoverUiStateImpl(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneCodeRegion: freezed == phoneCodeRegion
          ? _value.phoneCodeRegion
          : phoneCodeRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      initPhone: freezed == initPhone
          ? _value.initPhone
          : initPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      prepared: null == prepared
          ? _value.prepared
          : prepared // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MobileRecoverUiStateImpl implements _MobileRecoverUiState {
  _$MobileRecoverUiStateImpl(
      {this.enableSend = false,
      this.phoneCodeRegion,
      this.phone,
      this.initPhone,
      this.event = const EmptyEvent(),
      this.prepared = false});

  @override
  @JsonKey()
  final bool enableSend;
  @override
  final RegionItem? phoneCodeRegion;
  @override
  final String? phone;
  @override
  final String? initPhone;
  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool prepared;

  @override
  String toString() {
    return 'MobileRecoverUiState(enableSend: $enableSend, phoneCodeRegion: $phoneCodeRegion, phone: $phone, initPhone: $initPhone, event: $event, prepared: $prepared)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileRecoverUiStateImpl &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.phoneCodeRegion, phoneCodeRegion) ||
                other.phoneCodeRegion == phoneCodeRegion) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.initPhone, initPhone) ||
                other.initPhone == initPhone) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.prepared, prepared) ||
                other.prepared == prepared));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enableSend, phoneCodeRegion,
      phone, initPhone, event, prepared);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileRecoverUiStateImplCopyWith<_$MobileRecoverUiStateImpl>
      get copyWith =>
          __$$MobileRecoverUiStateImplCopyWithImpl<_$MobileRecoverUiStateImpl>(
              this, _$identity);
}

abstract class _MobileRecoverUiState implements MobileRecoverUiState {
  factory _MobileRecoverUiState(
      {final bool enableSend,
      final RegionItem? phoneCodeRegion,
      final String? phone,
      final String? initPhone,
      final CommonUIEvent event,
      final bool prepared}) = _$MobileRecoverUiStateImpl;

  @override
  bool get enableSend;
  @override
  RegionItem? get phoneCodeRegion;
  @override
  String? get phone;
  @override
  String? get initPhone;
  @override
  CommonUIEvent get event;
  @override
  bool get prepared;
  @override
  @JsonKey(ignore: true)
  _$$MobileRecoverUiStateImplCopyWith<_$MobileRecoverUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
