// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_message_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SystemMessageListUiState {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;
  List<CommonMsgRecord> get systemMessageList =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SystemMessageListUiStateCopyWith<SystemMessageListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemMessageListUiStateCopyWith<$Res> {
  factory $SystemMessageListUiStateCopyWith(SystemMessageListUiState value,
          $Res Function(SystemMessageListUiState) then) =
      _$SystemMessageListUiStateCopyWithImpl<$Res, SystemMessageListUiState>;
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      CommonUIEvent? uiEvent,
      List<CommonMsgRecord> systemMessageList});
}

/// @nodoc
class _$SystemMessageListUiStateCopyWithImpl<$Res,
        $Val extends SystemMessageListUiState>
    implements $SystemMessageListUiStateCopyWith<$Res> {
  _$SystemMessageListUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
    Object? uiEvent = freezed,
    Object? systemMessageList = null,
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
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
      systemMessageList: null == systemMessageList
          ? _value.systemMessageList
          : systemMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemMessageListUiStateImplCopyWith<$Res>
    implements $SystemMessageListUiStateCopyWith<$Res> {
  factory _$$SystemMessageListUiStateImplCopyWith(
          _$SystemMessageListUiStateImpl value,
          $Res Function(_$SystemMessageListUiStateImpl) then) =
      __$$SystemMessageListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      CommonUIEvent? uiEvent,
      List<CommonMsgRecord> systemMessageList});
}

/// @nodoc
class __$$SystemMessageListUiStateImplCopyWithImpl<$Res>
    extends _$SystemMessageListUiStateCopyWithImpl<$Res,
        _$SystemMessageListUiStateImpl>
    implements _$$SystemMessageListUiStateImplCopyWith<$Res> {
  __$$SystemMessageListUiStateImplCopyWithImpl(
      _$SystemMessageListUiStateImpl _value,
      $Res Function(_$SystemMessageListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
    Object? uiEvent = freezed,
    Object? systemMessageList = null,
  }) {
    return _then(_$SystemMessageListUiStateImpl(
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
      systemMessageList: null == systemMessageList
          ? _value._systemMessageList
          : systemMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
    ));
  }
}

/// @nodoc

class _$SystemMessageListUiStateImpl implements _SystemMessageListUiState {
  _$SystemMessageListUiStateImpl(
      {this.page = 1,
      this.size = 20,
      this.hasMore = false,
      this.uiEvent,
      final List<CommonMsgRecord> systemMessageList = const []})
      : _systemMessageList = systemMessageList;

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final CommonUIEvent? uiEvent;
  final List<CommonMsgRecord> _systemMessageList;
  @override
  @JsonKey()
  List<CommonMsgRecord> get systemMessageList {
    if (_systemMessageList is EqualUnmodifiableListView)
      return _systemMessageList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_systemMessageList);
  }

  @override
  String toString() {
    return 'SystemMessageListUiState(page: $page, size: $size, hasMore: $hasMore, uiEvent: $uiEvent, systemMessageList: $systemMessageList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemMessageListUiStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent) &&
            const DeepCollectionEquality()
                .equals(other._systemMessageList, _systemMessageList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, size, hasMore, uiEvent,
      const DeepCollectionEquality().hash(_systemMessageList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemMessageListUiStateImplCopyWith<_$SystemMessageListUiStateImpl>
      get copyWith => __$$SystemMessageListUiStateImplCopyWithImpl<
          _$SystemMessageListUiStateImpl>(this, _$identity);
}

abstract class _SystemMessageListUiState implements SystemMessageListUiState {
  factory _SystemMessageListUiState(
          {final int page,
          final int size,
          final bool hasMore,
          final CommonUIEvent? uiEvent,
          final List<CommonMsgRecord> systemMessageList}) =
      _$SystemMessageListUiStateImpl;

  @override
  int get page;
  @override
  int get size;
  @override
  bool get hasMore;
  @override
  CommonUIEvent? get uiEvent;
  @override
  List<CommonMsgRecord> get systemMessageList;
  @override
  @JsonKey(ignore: true)
  _$$SystemMessageListUiStateImplCopyWith<_$SystemMessageListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
