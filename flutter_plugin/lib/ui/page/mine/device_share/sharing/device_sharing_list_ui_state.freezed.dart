// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_sharing_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceSharingListUiState {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  List<DeviceModel> get deviceList => throw _privateConstructorUsedError;
  SharedDeviceThumbEntity? get sharedEntity =>
      throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeviceSharingListUiStateCopyWith<DeviceSharingListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceSharingListUiStateCopyWith<$Res> {
  factory $DeviceSharingListUiStateCopyWith(DeviceSharingListUiState value,
          $Res Function(DeviceSharingListUiState) then) =
      _$DeviceSharingListUiStateCopyWithImpl<$Res, DeviceSharingListUiState>;
  @useResult
  $Res call(
      {int page,
      int size,
      List<DeviceModel> deviceList,
      SharedDeviceThumbEntity? sharedEntity,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$DeviceSharingListUiStateCopyWithImpl<$Res,
        $Val extends DeviceSharingListUiState>
    implements $DeviceSharingListUiStateCopyWith<$Res> {
  _$DeviceSharingListUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? deviceList = null,
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
      deviceList: null == deviceList
          ? _value.deviceList
          : deviceList // ignore: cast_nullable_to_non_nullable
              as List<DeviceModel>,
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
abstract class _$$DeviceSharingListUiStateImplCopyWith<$Res>
    implements $DeviceSharingListUiStateCopyWith<$Res> {
  factory _$$DeviceSharingListUiStateImplCopyWith(
          _$DeviceSharingListUiStateImpl value,
          $Res Function(_$DeviceSharingListUiStateImpl) then) =
      __$$DeviceSharingListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int size,
      List<DeviceModel> deviceList,
      SharedDeviceThumbEntity? sharedEntity,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$DeviceSharingListUiStateImplCopyWithImpl<$Res>
    extends _$DeviceSharingListUiStateCopyWithImpl<$Res,
        _$DeviceSharingListUiStateImpl>
    implements _$$DeviceSharingListUiStateImplCopyWith<$Res> {
  __$$DeviceSharingListUiStateImplCopyWithImpl(
      _$DeviceSharingListUiStateImpl _value,
      $Res Function(_$DeviceSharingListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? deviceList = null,
    Object? sharedEntity = freezed,
    Object? uiEvent = freezed,
  }) {
    return _then(_$DeviceSharingListUiStateImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      deviceList: null == deviceList
          ? _value._deviceList
          : deviceList // ignore: cast_nullable_to_non_nullable
              as List<DeviceModel>,
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

class _$DeviceSharingListUiStateImpl implements _DeviceSharingListUiState {
  _$DeviceSharingListUiStateImpl(
      {this.page = 1,
      this.size = 20,
      final List<DeviceModel> deviceList = const [],
      this.sharedEntity = null,
      this.uiEvent})
      : _deviceList = deviceList;

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  final List<DeviceModel> _deviceList;
  @override
  @JsonKey()
  List<DeviceModel> get deviceList {
    if (_deviceList is EqualUnmodifiableListView) return _deviceList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deviceList);
  }

  @override
  @JsonKey()
  final SharedDeviceThumbEntity? sharedEntity;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'DeviceSharingListUiState(page: $page, size: $size, deviceList: $deviceList, sharedEntity: $sharedEntity, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceSharingListUiStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            const DeepCollectionEquality()
                .equals(other._deviceList, _deviceList) &&
            (identical(other.sharedEntity, sharedEntity) ||
                other.sharedEntity == sharedEntity) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, size,
      const DeepCollectionEquality().hash(_deviceList), sharedEntity, uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceSharingListUiStateImplCopyWith<_$DeviceSharingListUiStateImpl>
      get copyWith => __$$DeviceSharingListUiStateImplCopyWithImpl<
          _$DeviceSharingListUiStateImpl>(this, _$identity);
}

abstract class _DeviceSharingListUiState implements DeviceSharingListUiState {
  factory _DeviceSharingListUiState(
      {final int page,
      final int size,
      final List<DeviceModel> deviceList,
      final SharedDeviceThumbEntity? sharedEntity,
      final CommonUIEvent? uiEvent}) = _$DeviceSharingListUiStateImpl;

  @override
  int get page;
  @override
  int get size;
  @override
  List<DeviceModel> get deviceList;
  @override
  SharedDeviceThumbEntity? get sharedEntity;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$DeviceSharingListUiStateImplCopyWith<_$DeviceSharingListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
