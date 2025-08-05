// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_login_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PasswordLoginUiState {
  RegionItem? get currentItem => throw _privateConstructorUsedError;
  String? get initAccount => throw _privateConstructorUsedError;
  String? get initPassword => throw _privateConstructorUsedError;
  bool get hidePassword => throw _privateConstructorUsedError;
  bool get submitEnable => throw _privateConstructorUsedError;
  bool get agreed => throw _privateConstructorUsedError;
  bool get prepared => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PasswordLoginUiStateCopyWith<PasswordLoginUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PasswordLoginUiStateCopyWith<$Res> {
  factory $PasswordLoginUiStateCopyWith(PasswordLoginUiState value,
          $Res Function(PasswordLoginUiState) then) =
      _$PasswordLoginUiStateCopyWithImpl<$Res, PasswordLoginUiState>;
  @useResult
  $Res call(
      {RegionItem? currentItem,
      String? initAccount,
      String? initPassword,
      bool hidePassword,
      bool submitEnable,
      bool agreed,
      bool prepared,
      CommonUIEvent event});
}

/// @nodoc
class _$PasswordLoginUiStateCopyWithImpl<$Res,
        $Val extends PasswordLoginUiState>
    implements $PasswordLoginUiStateCopyWith<$Res> {
  _$PasswordLoginUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentItem = freezed,
    Object? initAccount = freezed,
    Object? initPassword = freezed,
    Object? hidePassword = null,
    Object? submitEnable = null,
    Object? agreed = null,
    Object? prepared = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      currentItem: freezed == currentItem
          ? _value.currentItem
          : currentItem // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      initAccount: freezed == initAccount
          ? _value.initAccount
          : initAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      initPassword: freezed == initPassword
          ? _value.initPassword
          : initPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      hidePassword: null == hidePassword
          ? _value.hidePassword
          : hidePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      submitEnable: null == submitEnable
          ? _value.submitEnable
          : submitEnable // ignore: cast_nullable_to_non_nullable
              as bool,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      prepared: null == prepared
          ? _value.prepared
          : prepared // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PasswordLoginUiStateImplCopyWith<$Res>
    implements $PasswordLoginUiStateCopyWith<$Res> {
  factory _$$PasswordLoginUiStateImplCopyWith(_$PasswordLoginUiStateImpl value,
          $Res Function(_$PasswordLoginUiStateImpl) then) =
      __$$PasswordLoginUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RegionItem? currentItem,
      String? initAccount,
      String? initPassword,
      bool hidePassword,
      bool submitEnable,
      bool agreed,
      bool prepared,
      CommonUIEvent event});
}

/// @nodoc
class __$$PasswordLoginUiStateImplCopyWithImpl<$Res>
    extends _$PasswordLoginUiStateCopyWithImpl<$Res, _$PasswordLoginUiStateImpl>
    implements _$$PasswordLoginUiStateImplCopyWith<$Res> {
  __$$PasswordLoginUiStateImplCopyWithImpl(_$PasswordLoginUiStateImpl _value,
      $Res Function(_$PasswordLoginUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentItem = freezed,
    Object? initAccount = freezed,
    Object? initPassword = freezed,
    Object? hidePassword = null,
    Object? submitEnable = null,
    Object? agreed = null,
    Object? prepared = null,
    Object? event = null,
  }) {
    return _then(_$PasswordLoginUiStateImpl(
      currentItem: freezed == currentItem
          ? _value.currentItem
          : currentItem // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      initAccount: freezed == initAccount
          ? _value.initAccount
          : initAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      initPassword: freezed == initPassword
          ? _value.initPassword
          : initPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      hidePassword: null == hidePassword
          ? _value.hidePassword
          : hidePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      submitEnable: null == submitEnable
          ? _value.submitEnable
          : submitEnable // ignore: cast_nullable_to_non_nullable
              as bool,
      agreed: null == agreed
          ? _value.agreed
          : agreed // ignore: cast_nullable_to_non_nullable
              as bool,
      prepared: null == prepared
          ? _value.prepared
          : prepared // ignore: cast_nullable_to_non_nullable
              as bool,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$PasswordLoginUiStateImpl implements _PasswordLoginUiState {
  const _$PasswordLoginUiStateImpl(
      {this.currentItem,
      this.initAccount = null,
      this.initPassword = null,
      this.hidePassword = true,
      this.submitEnable = false,
      this.agreed = false,
      this.prepared = false,
      this.event = const EmptyEvent()});

  @override
  final RegionItem? currentItem;
  @override
  @JsonKey()
  final String? initAccount;
  @override
  @JsonKey()
  final String? initPassword;
  @override
  @JsonKey()
  final bool hidePassword;
  @override
  @JsonKey()
  final bool submitEnable;
  @override
  @JsonKey()
  final bool agreed;
  @override
  @JsonKey()
  final bool prepared;
  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'PasswordLoginUiState(currentItem: $currentItem, initAccount: $initAccount, initPassword: $initPassword, hidePassword: $hidePassword, submitEnable: $submitEnable, agreed: $agreed, prepared: $prepared, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordLoginUiStateImpl &&
            (identical(other.currentItem, currentItem) ||
                other.currentItem == currentItem) &&
            (identical(other.initAccount, initAccount) ||
                other.initAccount == initAccount) &&
            (identical(other.initPassword, initPassword) ||
                other.initPassword == initPassword) &&
            (identical(other.hidePassword, hidePassword) ||
                other.hidePassword == hidePassword) &&
            (identical(other.submitEnable, submitEnable) ||
                other.submitEnable == submitEnable) &&
            (identical(other.agreed, agreed) || other.agreed == agreed) &&
            (identical(other.prepared, prepared) ||
                other.prepared == prepared) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentItem, initAccount,
      initPassword, hidePassword, submitEnable, agreed, prepared, event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordLoginUiStateImplCopyWith<_$PasswordLoginUiStateImpl>
      get copyWith =>
          __$$PasswordLoginUiStateImplCopyWithImpl<_$PasswordLoginUiStateImpl>(
              this, _$identity);
}

abstract class _PasswordLoginUiState implements PasswordLoginUiState {
  const factory _PasswordLoginUiState(
      {final RegionItem? currentItem,
      final String? initAccount,
      final String? initPassword,
      final bool hidePassword,
      final bool submitEnable,
      final bool agreed,
      final bool prepared,
      final CommonUIEvent event}) = _$PasswordLoginUiStateImpl;

  @override
  RegionItem? get currentItem;
  @override
  String? get initAccount;
  @override
  String? get initPassword;
  @override
  bool get hidePassword;
  @override
  bool get submitEnable;
  @override
  bool get agreed;
  @override
  bool get prepared;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$PasswordLoginUiStateImplCopyWith<_$PasswordLoginUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
