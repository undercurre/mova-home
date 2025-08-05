// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_logoff_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeleteAccountUiState {
  bool get enableBindButton => throw _privateConstructorUsedError;
  String get tipStr => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeleteAccountUiStateCopyWith<DeleteAccountUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteAccountUiStateCopyWith<$Res> {
  factory $DeleteAccountUiStateCopyWith(DeleteAccountUiState value,
          $Res Function(DeleteAccountUiState) then) =
      _$DeleteAccountUiStateCopyWithImpl<$Res, DeleteAccountUiState>;
  @useResult
  $Res call({bool enableBindButton, String tipStr});
}

/// @nodoc
class _$DeleteAccountUiStateCopyWithImpl<$Res,
        $Val extends DeleteAccountUiState>
    implements $DeleteAccountUiStateCopyWith<$Res> {
  _$DeleteAccountUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBindButton = null,
    Object? tipStr = null,
  }) {
    return _then(_value.copyWith(
      enableBindButton: null == enableBindButton
          ? _value.enableBindButton
          : enableBindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      tipStr: null == tipStr
          ? _value.tipStr
          : tipStr // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeleteAccountUiStateImplCopyWith<$Res>
    implements $DeleteAccountUiStateCopyWith<$Res> {
  factory _$$DeleteAccountUiStateImplCopyWith(_$DeleteAccountUiStateImpl value,
          $Res Function(_$DeleteAccountUiStateImpl) then) =
      __$$DeleteAccountUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool enableBindButton, String tipStr});
}

/// @nodoc
class __$$DeleteAccountUiStateImplCopyWithImpl<$Res>
    extends _$DeleteAccountUiStateCopyWithImpl<$Res, _$DeleteAccountUiStateImpl>
    implements _$$DeleteAccountUiStateImplCopyWith<$Res> {
  __$$DeleteAccountUiStateImplCopyWithImpl(_$DeleteAccountUiStateImpl _value,
      $Res Function(_$DeleteAccountUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enableBindButton = null,
    Object? tipStr = null,
  }) {
    return _then(_$DeleteAccountUiStateImpl(
      enableBindButton: null == enableBindButton
          ? _value.enableBindButton
          : enableBindButton // ignore: cast_nullable_to_non_nullable
              as bool,
      tipStr: null == tipStr
          ? _value.tipStr
          : tipStr // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteAccountUiStateImpl implements _DeleteAccountUiState {
  _$DeleteAccountUiStateImpl({this.enableBindButton = false, this.tipStr = ''});

  @override
  @JsonKey()
  final bool enableBindButton;
  @override
  @JsonKey()
  final String tipStr;

  @override
  String toString() {
    return 'DeleteAccountUiState(enableBindButton: $enableBindButton, tipStr: $tipStr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteAccountUiStateImpl &&
            (identical(other.enableBindButton, enableBindButton) ||
                other.enableBindButton == enableBindButton) &&
            (identical(other.tipStr, tipStr) || other.tipStr == tipStr));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enableBindButton, tipStr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteAccountUiStateImplCopyWith<_$DeleteAccountUiStateImpl>
      get copyWith =>
          __$$DeleteAccountUiStateImplCopyWithImpl<_$DeleteAccountUiStateImpl>(
              this, _$identity);
}

abstract class _DeleteAccountUiState implements DeleteAccountUiState {
  factory _DeleteAccountUiState(
      {final bool enableBindButton,
      final String tipStr}) = _$DeleteAccountUiStateImpl;

  @override
  bool get enableBindButton;
  @override
  String get tipStr;
  @override
  @JsonKey(ignore: true)
  _$$DeleteAccountUiStateImplCopyWith<_$DeleteAccountUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
