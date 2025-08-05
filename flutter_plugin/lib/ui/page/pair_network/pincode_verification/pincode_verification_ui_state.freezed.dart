// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pincode_verification_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PincodeVerificationUIState {
  bool get enableBtn => throw _privateConstructorUsedError;
  String get pincode => throw _privateConstructorUsedError;
  int get remainingTime => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PincodeVerificationUIStateCopyWith<PincodeVerificationUIState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PincodeVerificationUIStateCopyWith<$Res> {
  factory $PincodeVerificationUIStateCopyWith(PincodeVerificationUIState value,
          $Res Function(PincodeVerificationUIState) then) =
      _$PincodeVerificationUIStateCopyWithImpl<$Res,
          PincodeVerificationUIState>;
  @useResult
  $Res call(
      {bool enableBtn, String pincode, int remainingTime, CommonUIEvent event});
}

/// @nodoc
class _$PincodeVerificationUIStateCopyWithImpl<$Res,
        $Val extends PincodeVerificationUIState>
    implements $PincodeVerificationUIStateCopyWith<$Res> {
  _$PincodeVerificationUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBtn = null,
    Object? pincode = null,
    Object? remainingTime = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      pincode: null == pincode
          ? _value.pincode
          : pincode // ignore: cast_nullable_to_non_nullable
              as String,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PincodeVerificationUIStateImplCopyWith<$Res>
    implements $PincodeVerificationUIStateCopyWith<$Res> {
  factory _$$PincodeVerificationUIStateImplCopyWith(
          _$PincodeVerificationUIStateImpl value,
          $Res Function(_$PincodeVerificationUIStateImpl) then) =
      __$$PincodeVerificationUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableBtn, String pincode, int remainingTime, CommonUIEvent event});
}

/// @nodoc
class __$$PincodeVerificationUIStateImplCopyWithImpl<$Res>
    extends _$PincodeVerificationUIStateCopyWithImpl<$Res,
        _$PincodeVerificationUIStateImpl>
    implements _$$PincodeVerificationUIStateImplCopyWith<$Res> {
  __$$PincodeVerificationUIStateImplCopyWithImpl(
      _$PincodeVerificationUIStateImpl _value,
      $Res Function(_$PincodeVerificationUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBtn = null,
    Object? pincode = null,
    Object? remainingTime = null,
    Object? event = null,
  }) {
    return _then(_$PincodeVerificationUIStateImpl(
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
      pincode: null == pincode
          ? _value.pincode
          : pincode // ignore: cast_nullable_to_non_nullable
              as String,
      remainingTime: null == remainingTime
          ? _value.remainingTime
          : remainingTime // ignore: cast_nullable_to_non_nullable
              as int,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$PincodeVerificationUIStateImpl implements _PincodeVerificationUIState {
  _$PincodeVerificationUIStateImpl(
      {this.enableBtn = false,
      this.pincode = '',
      this.remainingTime = 0,
      this.event = const EmptyEvent()});

  @override
  @JsonKey()
  final bool enableBtn;
  @override
  @JsonKey()
  final String pincode;
  @override
  @JsonKey()
  final int remainingTime;
  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'PincodeVerificationUIState(enableBtn: $enableBtn, pincode: $pincode, remainingTime: $remainingTime, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PincodeVerificationUIStateImpl &&
            (identical(other.enableBtn, enableBtn) ||
                other.enableBtn == enableBtn) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, enableBtn, pincode, remainingTime, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PincodeVerificationUIStateImplCopyWith<_$PincodeVerificationUIStateImpl>
      get copyWith => __$$PincodeVerificationUIStateImplCopyWithImpl<
          _$PincodeVerificationUIStateImpl>(this, _$identity);
}

abstract class _PincodeVerificationUIState
    implements PincodeVerificationUIState {
  factory _PincodeVerificationUIState(
      {final bool enableBtn,
      final String pincode,
      final int remainingTime,
      final CommonUIEvent event}) = _$PincodeVerificationUIStateImpl;

  @override
  bool get enableBtn;
  @override
  String get pincode;
  @override
  int get remainingTime;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$PincodeVerificationUIStateImplCopyWith<_$PincodeVerificationUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
