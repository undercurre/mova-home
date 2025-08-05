// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_net_pincode_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PairNetPinCodeUIState {
  bool get enableBtn => throw _privateConstructorUsedError;
  String get pincode => throw _privateConstructorUsedError;
  int get remainingTime => throw _privateConstructorUsedError;
  String get showTime => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PairNetPinCodeUIStateCopyWith<PairNetPinCodeUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairNetPinCodeUIStateCopyWith<$Res> {
  factory $PairNetPinCodeUIStateCopyWith(PairNetPinCodeUIState value,
          $Res Function(PairNetPinCodeUIState) then) =
      _$PairNetPinCodeUIStateCopyWithImpl<$Res, PairNetPinCodeUIState>;
  @useResult
  $Res call(
      {bool enableBtn,
      String pincode,
      int remainingTime,
      String showTime,
      CommonUIEvent event});
}

/// @nodoc
class _$PairNetPinCodeUIStateCopyWithImpl<$Res,
        $Val extends PairNetPinCodeUIState>
    implements $PairNetPinCodeUIStateCopyWith<$Res> {
  _$PairNetPinCodeUIStateCopyWithImpl(this._value, this._then);

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
    Object? showTime = null,
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
      showTime: null == showTime
          ? _value.showTime
          : showTime // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PairNetPinCodeUIStateImplCopyWith<$Res>
    implements $PairNetPinCodeUIStateCopyWith<$Res> {
  factory _$$PairNetPinCodeUIStateImplCopyWith(
          _$PairNetPinCodeUIStateImpl value,
          $Res Function(_$PairNetPinCodeUIStateImpl) then) =
      __$$PairNetPinCodeUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enableBtn,
      String pincode,
      int remainingTime,
      String showTime,
      CommonUIEvent event});
}

/// @nodoc
class __$$PairNetPinCodeUIStateImplCopyWithImpl<$Res>
    extends _$PairNetPinCodeUIStateCopyWithImpl<$Res,
        _$PairNetPinCodeUIStateImpl>
    implements _$$PairNetPinCodeUIStateImplCopyWith<$Res> {
  __$$PairNetPinCodeUIStateImplCopyWithImpl(_$PairNetPinCodeUIStateImpl _value,
      $Res Function(_$PairNetPinCodeUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBtn = null,
    Object? pincode = null,
    Object? remainingTime = null,
    Object? showTime = null,
    Object? event = null,
  }) {
    return _then(_$PairNetPinCodeUIStateImpl(
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
      showTime: null == showTime
          ? _value.showTime
          : showTime // ignore: cast_nullable_to_non_nullable
              as String,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$PairNetPinCodeUIStateImpl implements _PairNetPinCodeUIState {
  _$PairNetPinCodeUIStateImpl(
      {this.enableBtn = false,
      this.pincode = '',
      this.remainingTime = 0,
      this.showTime = '',
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
  final String showTime;
  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'PairNetPinCodeUIState(enableBtn: $enableBtn, pincode: $pincode, remainingTime: $remainingTime, showTime: $showTime, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairNetPinCodeUIStateImpl &&
            (identical(other.enableBtn, enableBtn) ||
                other.enableBtn == enableBtn) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.remainingTime, remainingTime) ||
                other.remainingTime == remainingTime) &&
            (identical(other.showTime, showTime) ||
                other.showTime == showTime) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, enableBtn, pincode, remainingTime, showTime, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairNetPinCodeUIStateImplCopyWith<_$PairNetPinCodeUIStateImpl>
      get copyWith => __$$PairNetPinCodeUIStateImplCopyWithImpl<
          _$PairNetPinCodeUIStateImpl>(this, _$identity);
}

abstract class _PairNetPinCodeUIState implements PairNetPinCodeUIState {
  factory _PairNetPinCodeUIState(
      {final bool enableBtn,
      final String pincode,
      final int remainingTime,
      final String showTime,
      final CommonUIEvent event}) = _$PairNetPinCodeUIStateImpl;

  @override
  bool get enableBtn;
  @override
  String get pincode;
  @override
  int get remainingTime;
  @override
  String get showTime;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$PairNetPinCodeUIStateImplCopyWith<_$PairNetPinCodeUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
