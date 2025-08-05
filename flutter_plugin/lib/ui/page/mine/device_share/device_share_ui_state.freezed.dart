// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_share_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceShareUiState {
  bool get showSharingListPage => throw _privateConstructorUsedError;
  bool get showAcceptedLisePage => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceShareUiStateCopyWith<DeviceShareUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceShareUiStateCopyWith<$Res> {
  factory $DeviceShareUiStateCopyWith(
          DeviceShareUiState value, $Res Function(DeviceShareUiState) then) =
      _$DeviceShareUiStateCopyWithImpl<$Res, DeviceShareUiState>;
  @useResult
  $Res call(
      {bool showSharingListPage,
      bool showAcceptedLisePage,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$DeviceShareUiStateCopyWithImpl<$Res, $Val extends DeviceShareUiState>
    implements $DeviceShareUiStateCopyWith<$Res> {
  _$DeviceShareUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showSharingListPage = null,
    Object? showAcceptedLisePage = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      showSharingListPage: null == showSharingListPage
          ? _value.showSharingListPage
          : showSharingListPage // ignore: cast_nullable_to_non_nullable
              as bool,
      showAcceptedLisePage: null == showAcceptedLisePage
          ? _value.showAcceptedLisePage
          : showAcceptedLisePage // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceShareUiStateImplCopyWith<$Res>
    implements $DeviceShareUiStateCopyWith<$Res> {
  factory _$$DeviceShareUiStateImplCopyWith(_$DeviceShareUiStateImpl value,
          $Res Function(_$DeviceShareUiStateImpl) then) =
      __$$DeviceShareUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool showSharingListPage,
      bool showAcceptedLisePage,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$DeviceShareUiStateImplCopyWithImpl<$Res>
    extends _$DeviceShareUiStateCopyWithImpl<$Res, _$DeviceShareUiStateImpl>
    implements _$$DeviceShareUiStateImplCopyWith<$Res> {
  __$$DeviceShareUiStateImplCopyWithImpl(_$DeviceShareUiStateImpl _value,
      $Res Function(_$DeviceShareUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? showSharingListPage = null,
    Object? showAcceptedLisePage = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$DeviceShareUiStateImpl(
      showSharingListPage: null == showSharingListPage
          ? _value.showSharingListPage
          : showSharingListPage // ignore: cast_nullable_to_non_nullable
              as bool,
      showAcceptedLisePage: null == showAcceptedLisePage
          ? _value.showAcceptedLisePage
          : showAcceptedLisePage // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$DeviceShareUiStateImpl implements _DeviceShareUiState {
  _$DeviceShareUiStateImpl(
      {this.showSharingListPage = false,
      this.showAcceptedLisePage = false,
      this.uiEvent});

  @override
  @JsonKey()
  final bool showSharingListPage;
  @override
  @JsonKey()
  final bool showAcceptedLisePage;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'DeviceShareUiState(showSharingListPage: $showSharingListPage, showAcceptedLisePage: $showAcceptedLisePage, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceShareUiStateImpl &&
            (identical(other.showSharingListPage, showSharingListPage) ||
                other.showSharingListPage == showSharingListPage) &&
            (identical(other.showAcceptedLisePage, showAcceptedLisePage) ||
                other.showAcceptedLisePage == showAcceptedLisePage) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, showSharingListPage, showAcceptedLisePage, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceShareUiStateImplCopyWith<_$DeviceShareUiStateImpl> get copyWith =>
      __$$DeviceShareUiStateImplCopyWithImpl<_$DeviceShareUiStateImpl>(
          this, _$identity);
}

abstract class _DeviceShareUiState implements DeviceShareUiState {
  factory _DeviceShareUiState(
      {final bool showSharingListPage,
      final bool showAcceptedLisePage,
      final CommonUIEvent? uiEvent}) = _$DeviceShareUiStateImpl;

  @override
  bool get showSharingListPage;
  @override
  bool get showAcceptedLisePage;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$DeviceShareUiStateImplCopyWith<_$DeviceShareUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
