// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_sharing_add_contacts_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceSharingAddContactsUiState {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  List<MineRecentUser> get userList => throw _privateConstructorUsedError;
  SharedDeviceThumbEntity? get sharedEntity =>
      throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceSharingAddContactsUiStateCopyWith<DeviceSharingAddContactsUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceSharingAddContactsUiStateCopyWith<$Res> {
  factory $DeviceSharingAddContactsUiStateCopyWith(
          DeviceSharingAddContactsUiState value,
          $Res Function(DeviceSharingAddContactsUiState) then) =
      _$DeviceSharingAddContactsUiStateCopyWithImpl<$Res,
          DeviceSharingAddContactsUiState>;
  @useResult
  $Res call(
      {int page,
      int size,
      List<MineRecentUser> userList,
      SharedDeviceThumbEntity? sharedEntity,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$DeviceSharingAddContactsUiStateCopyWithImpl<$Res,
        $Val extends DeviceSharingAddContactsUiState>
    implements $DeviceSharingAddContactsUiStateCopyWith<$Res> {
  _$DeviceSharingAddContactsUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? userList = null,
    Object? sharedEntity = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      userList: null == userList
          ? _value.userList
          : userList // ignore: cast_nullable_to_non_nullable
              as List<MineRecentUser>,
      sharedEntity: freezed == sharedEntity
          ? _value.sharedEntity
          : sharedEntity // ignore: cast_nullable_to_non_nullable
              as SharedDeviceThumbEntity?,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceSharingAddContactsUiStateImplCopyWith<$Res>
    implements $DeviceSharingAddContactsUiStateCopyWith<$Res> {
  factory _$$DeviceSharingAddContactsUiStateImplCopyWith(
          _$DeviceSharingAddContactsUiStateImpl value,
          $Res Function(_$DeviceSharingAddContactsUiStateImpl) then) =
      __$$DeviceSharingAddContactsUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int size,
      List<MineRecentUser> userList,
      SharedDeviceThumbEntity? sharedEntity,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$DeviceSharingAddContactsUiStateImplCopyWithImpl<$Res>
    extends _$DeviceSharingAddContactsUiStateCopyWithImpl<$Res,
        _$DeviceSharingAddContactsUiStateImpl>
    implements _$$DeviceSharingAddContactsUiStateImplCopyWith<$Res> {
  __$$DeviceSharingAddContactsUiStateImplCopyWithImpl(
      _$DeviceSharingAddContactsUiStateImpl _value,
      $Res Function(_$DeviceSharingAddContactsUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? userList = null,
    Object? sharedEntity = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_$DeviceSharingAddContactsUiStateImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      userList: null == userList
          ? _value._userList
          : userList // ignore: cast_nullable_to_non_nullable
              as List<MineRecentUser>,
      sharedEntity: freezed == sharedEntity
          ? _value.sharedEntity
          : sharedEntity // ignore: cast_nullable_to_non_nullable
              as SharedDeviceThumbEntity?,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$DeviceSharingAddContactsUiStateImpl
    implements _DeviceSharingAddContactsUiState {
  _$DeviceSharingAddContactsUiStateImpl(
      {this.page = 1,
      this.size = 20,
      final List<MineRecentUser> userList = const [],
      this.sharedEntity = null,
      this.uiEvent})
      : _userList = userList;

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  final List<MineRecentUser> _userList;
  @override
  @JsonKey()
  List<MineRecentUser> get userList {
    if (_userList is EqualUnmodifiableListView) return _userList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userList);
  }

  @override
  @JsonKey()
  final SharedDeviceThumbEntity? sharedEntity;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'DeviceSharingAddContactsUiState(page: $page, size: $size, userList: $userList, sharedEntity: $sharedEntity, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceSharingAddContactsUiStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            const DeepCollectionEquality().equals(other._userList, _userList) &&
            (identical(other.sharedEntity, sharedEntity) ||
                other.sharedEntity == sharedEntity) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, size,
      const DeepCollectionEquality().hash(_userList), sharedEntity, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceSharingAddContactsUiStateImplCopyWith<
          _$DeviceSharingAddContactsUiStateImpl>
      get copyWith => __$$DeviceSharingAddContactsUiStateImplCopyWithImpl<
          _$DeviceSharingAddContactsUiStateImpl>(this, _$identity);
}

abstract class _DeviceSharingAddContactsUiState
    implements DeviceSharingAddContactsUiState {
  factory _DeviceSharingAddContactsUiState(
      {final int page,
      final int size,
      final List<MineRecentUser> userList,
      final SharedDeviceThumbEntity? sharedEntity,
      final CommonUIEvent? uiEvent}) = _$DeviceSharingAddContactsUiStateImpl;

  @override
  int get page;
  @override
  int get size;
  @override
  List<MineRecentUser> get userList;
  @override
  SharedDeviceThumbEntity? get sharedEntity;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$DeviceSharingAddContactsUiStateImplCopyWith<
          _$DeviceSharingAddContactsUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
