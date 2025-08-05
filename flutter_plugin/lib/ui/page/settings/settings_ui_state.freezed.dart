// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsPageUiState {
  bool get hasNewAppVersion => throw _privateConstructorUsedError;
  bool get devOption => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsPageUiStateCopyWith<SettingsPageUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsPageUiStateCopyWith<$Res> {
  factory $SettingsPageUiStateCopyWith(
          SettingsPageUiState value, $Res Function(SettingsPageUiState) then) =
      _$SettingsPageUiStateCopyWithImpl<$Res, SettingsPageUiState>;
  @useResult
  $Res call({bool hasNewAppVersion, bool devOption});
}

/// @nodoc
class _$SettingsPageUiStateCopyWithImpl<$Res, $Val extends SettingsPageUiState>
    implements $SettingsPageUiStateCopyWith<$Res> {
  _$SettingsPageUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNewAppVersion = null,
    Object? devOption = null,
  }) {
    return _then(_value.copyWith(
      hasNewAppVersion: null == hasNewAppVersion
          ? _value.hasNewAppVersion
          : hasNewAppVersion // ignore: cast_nullable_to_non_nullable
              as bool,
      devOption: null == devOption
          ? _value.devOption
          : devOption // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsPageUiStateImplCopyWith<$Res>
    implements $SettingsPageUiStateCopyWith<$Res> {
  factory _$$SettingsPageUiStateImplCopyWith(_$SettingsPageUiStateImpl value,
          $Res Function(_$SettingsPageUiStateImpl) then) =
      __$$SettingsPageUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasNewAppVersion, bool devOption});
}

/// @nodoc
class __$$SettingsPageUiStateImplCopyWithImpl<$Res>
    extends _$SettingsPageUiStateCopyWithImpl<$Res, _$SettingsPageUiStateImpl>
    implements _$$SettingsPageUiStateImplCopyWith<$Res> {
  __$$SettingsPageUiStateImplCopyWithImpl(_$SettingsPageUiStateImpl _value,
      $Res Function(_$SettingsPageUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNewAppVersion = null,
    Object? devOption = null,
  }) {
    return _then(_$SettingsPageUiStateImpl(
      hasNewAppVersion: null == hasNewAppVersion
          ? _value.hasNewAppVersion
          : hasNewAppVersion // ignore: cast_nullable_to_non_nullable
              as bool,
      devOption: null == devOption
          ? _value.devOption
          : devOption // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SettingsPageUiStateImpl implements _SettingsPageUiState {
  _$SettingsPageUiStateImpl(
      {this.hasNewAppVersion = false, this.devOption = false});

  @override
  @JsonKey()
  final bool hasNewAppVersion;
  @override
  @JsonKey()
  final bool devOption;

  @override
  String toString() {
    return 'SettingsPageUiState(hasNewAppVersion: $hasNewAppVersion, devOption: $devOption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsPageUiStateImpl &&
            (identical(other.hasNewAppVersion, hasNewAppVersion) ||
                other.hasNewAppVersion == hasNewAppVersion) &&
            (identical(other.devOption, devOption) ||
                other.devOption == devOption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasNewAppVersion, devOption);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsPageUiStateImplCopyWith<_$SettingsPageUiStateImpl> get copyWith =>
      __$$SettingsPageUiStateImplCopyWithImpl<_$SettingsPageUiStateImpl>(
          this, _$identity);
}

abstract class _SettingsPageUiState implements SettingsPageUiState {
  factory _SettingsPageUiState(
      {final bool hasNewAppVersion,
      final bool devOption}) = _$SettingsPageUiStateImpl;

  @override
  bool get hasNewAppVersion;
  @override
  bool get devOption;
  @override
  @JsonKey(ignore: true)
  _$$SettingsPageUiStateImplCopyWith<_$SettingsPageUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
