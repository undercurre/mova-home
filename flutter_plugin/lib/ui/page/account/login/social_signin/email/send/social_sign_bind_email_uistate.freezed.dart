// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_sign_bind_email_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SocailSignBindEmailUiState {
  bool get enableSend => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get showSkip => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SocailSignBindEmailUiStateCopyWith<SocailSignBindEmailUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocailSignBindEmailUiStateCopyWith<$Res> {
  factory $SocailSignBindEmailUiStateCopyWith(SocailSignBindEmailUiState value,
          $Res Function(SocailSignBindEmailUiState) then) =
      _$SocailSignBindEmailUiStateCopyWithImpl<$Res,
          SocailSignBindEmailUiState>;
  @useResult
  $Res call({bool enableSend, CommonUIEvent event, bool showSkip});
}

/// @nodoc
class _$SocailSignBindEmailUiStateCopyWithImpl<$Res,
        $Val extends SocailSignBindEmailUiState>
    implements $SocailSignBindEmailUiStateCopyWith<$Res> {
  _$SocailSignBindEmailUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? event = null,
    Object? showSkip = null,
  }) {
    return _then(_value.copyWith(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      showSkip: null == showSkip
          ? _value.showSkip
          : showSkip // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocailSignBindEmailUiStateImplCopyWith<$Res>
    implements $SocailSignBindEmailUiStateCopyWith<$Res> {
  factory _$$SocailSignBindEmailUiStateImplCopyWith(
          _$SocailSignBindEmailUiStateImpl value,
          $Res Function(_$SocailSignBindEmailUiStateImpl) then) =
      __$$SocailSignBindEmailUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enableSend, CommonUIEvent event, bool showSkip});
}

/// @nodoc
class __$$SocailSignBindEmailUiStateImplCopyWithImpl<$Res>
    extends _$SocailSignBindEmailUiStateCopyWithImpl<$Res,
        _$SocailSignBindEmailUiStateImpl>
    implements _$$SocailSignBindEmailUiStateImplCopyWith<$Res> {
  __$$SocailSignBindEmailUiStateImplCopyWithImpl(
      _$SocailSignBindEmailUiStateImpl _value,
      $Res Function(_$SocailSignBindEmailUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableSend = null,
    Object? event = null,
    Object? showSkip = null,
  }) {
    return _then(_$SocailSignBindEmailUiStateImpl(
      enableSend: null == enableSend
          ? _value.enableSend
          : enableSend // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      showSkip: null == showSkip
          ? _value.showSkip
          : showSkip // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SocailSignBindEmailUiStateImpl implements _SocailSignBindEmailUiState {
  const _$SocailSignBindEmailUiStateImpl(
      {this.enableSend = false,
      this.event = const EmptyEvent(),
      this.showSkip = false});

  @override
  @JsonKey()
  final bool enableSend;
  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool showSkip;

  @override
  String toString() {
    return 'SocailSignBindEmailUiState(enableSend: $enableSend, event: $event, showSkip: $showSkip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocailSignBindEmailUiStateImpl &&
            (identical(other.enableSend, enableSend) ||
                other.enableSend == enableSend) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.showSkip, showSkip) ||
                other.showSkip == showSkip));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enableSend, event, showSkip);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocailSignBindEmailUiStateImplCopyWith<_$SocailSignBindEmailUiStateImpl>
      get copyWith => __$$SocailSignBindEmailUiStateImplCopyWithImpl<
          _$SocailSignBindEmailUiStateImpl>(this, _$identity);
}

abstract class _SocailSignBindEmailUiState
    implements SocailSignBindEmailUiState {
  const factory _SocailSignBindEmailUiState(
      {final bool enableSend,
      final CommonUIEvent event,
      final bool showSkip}) = _$SocailSignBindEmailUiStateImpl;

  @override
  bool get enableSend;
  @override
  CommonUIEvent get event;
  @override
  bool get showSkip;
  @override
  @JsonKey(ignore: true)
  _$$SocailSignBindEmailUiStateImplCopyWith<_$SocailSignBindEmailUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
