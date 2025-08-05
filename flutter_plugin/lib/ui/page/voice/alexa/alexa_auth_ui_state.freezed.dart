// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alexa_auth_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AlexaAuthUiState {
  String? get clientId => throw _privateConstructorUsedError;
  String? get responseType => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get scope => throw _privateConstructorUsedError;
  String? get redirectUri => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AlexaAuthUiStateCopyWith<AlexaAuthUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlexaAuthUiStateCopyWith<$Res> {
  factory $AlexaAuthUiStateCopyWith(
          AlexaAuthUiState value, $Res Function(AlexaAuthUiState) then) =
      _$AlexaAuthUiStateCopyWithImpl<$Res, AlexaAuthUiState>;
  @useResult
  $Res call(
      {String? clientId,
      String? responseType,
      String? state,
      String? scope,
      String? redirectUri,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$AlexaAuthUiStateCopyWithImpl<$Res, $Val extends AlexaAuthUiState>
    implements $AlexaAuthUiStateCopyWith<$Res> {
  _$AlexaAuthUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = freezed,
    Object? responseType = freezed,
    Object? state = freezed,
    Object? scope = freezed,
    Object? redirectUri = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      responseType: freezed == responseType
          ? _value.responseType
          : responseType // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: freezed == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUri: freezed == redirectUri
          ? _value.redirectUri
          : redirectUri // ignore: cast_nullable_to_non_nullable
              as String?,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlexaAuthUiStateImplCopyWith<$Res>
    implements $AlexaAuthUiStateCopyWith<$Res> {
  factory _$$AlexaAuthUiStateImplCopyWith(_$AlexaAuthUiStateImpl value,
          $Res Function(_$AlexaAuthUiStateImpl) then) =
      __$$AlexaAuthUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? clientId,
      String? responseType,
      String? state,
      String? scope,
      String? redirectUri,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$AlexaAuthUiStateImplCopyWithImpl<$Res>
    extends _$AlexaAuthUiStateCopyWithImpl<$Res, _$AlexaAuthUiStateImpl>
    implements _$$AlexaAuthUiStateImplCopyWith<$Res> {
  __$$AlexaAuthUiStateImplCopyWithImpl(_$AlexaAuthUiStateImpl _value,
      $Res Function(_$AlexaAuthUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = freezed,
    Object? responseType = freezed,
    Object? state = freezed,
    Object? scope = freezed,
    Object? redirectUri = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_$AlexaAuthUiStateImpl(
      clientId: freezed == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String?,
      responseType: freezed == responseType
          ? _value.responseType
          : responseType // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: freezed == scope
          ? _value.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUri: freezed == redirectUri
          ? _value.redirectUri
          : redirectUri // ignore: cast_nullable_to_non_nullable
              as String?,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$AlexaAuthUiStateImpl implements _AlexaAuthUiState {
  _$AlexaAuthUiStateImpl(
      {this.clientId,
      this.responseType,
      this.state,
      this.scope,
      this.redirectUri,
      this.uiEvent});

  @override
  final String? clientId;
  @override
  final String? responseType;
  @override
  final String? state;
  @override
  final String? scope;
  @override
  final String? redirectUri;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'AlexaAuthUiState(clientId: $clientId, responseType: $responseType, state: $state, scope: $scope, redirectUri: $redirectUri, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlexaAuthUiStateImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.responseType, responseType) ||
                other.responseType == responseType) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.redirectUri, redirectUri) ||
                other.redirectUri == redirectUri) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, clientId, responseType, state, scope, redirectUri, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AlexaAuthUiStateImplCopyWith<_$AlexaAuthUiStateImpl> get copyWith =>
      __$$AlexaAuthUiStateImplCopyWithImpl<_$AlexaAuthUiStateImpl>(
          this, _$identity);
}

abstract class _AlexaAuthUiState implements AlexaAuthUiState {
  factory _AlexaAuthUiState(
      {final String? clientId,
      final String? responseType,
      final String? state,
      final String? scope,
      final String? redirectUri,
      final CommonUIEvent? uiEvent}) = _$AlexaAuthUiStateImpl;

  @override
  String? get clientId;
  @override
  String? get responseType;
  @override
  String? get state;
  @override
  String? get scope;
  @override
  String? get redirectUri;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$AlexaAuthUiStateImplCopyWith<_$AlexaAuthUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
