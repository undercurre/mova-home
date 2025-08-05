// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_message_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderMessageListUiState {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  List<CommonMsgRecord> get orderMessageList =>
      throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OrderMessageListUiStateCopyWith<OrderMessageListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderMessageListUiStateCopyWith<$Res> {
  factory $OrderMessageListUiStateCopyWith(OrderMessageListUiState value,
          $Res Function(OrderMessageListUiState) then) =
      _$OrderMessageListUiStateCopyWithImpl<$Res, OrderMessageListUiState>;
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      List<CommonMsgRecord> orderMessageList,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$OrderMessageListUiStateCopyWithImpl<$Res,
        $Val extends OrderMessageListUiState>
    implements $OrderMessageListUiStateCopyWith<$Res> {
  _$OrderMessageListUiStateCopyWithImpl(this._value, this._then);

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
    Object? orderMessageList = null,
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
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      orderMessageList: null == orderMessageList
          ? _value.orderMessageList
          : orderMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderMessageListUiStateImplCopyWith<$Res>
    implements $OrderMessageListUiStateCopyWith<$Res> {
  factory _$$OrderMessageListUiStateImplCopyWith(
          _$OrderMessageListUiStateImpl value,
          $Res Function(_$OrderMessageListUiStateImpl) then) =
      __$$OrderMessageListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      List<CommonMsgRecord> orderMessageList,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$OrderMessageListUiStateImplCopyWithImpl<$Res>
    extends _$OrderMessageListUiStateCopyWithImpl<$Res,
        _$OrderMessageListUiStateImpl>
    implements _$$OrderMessageListUiStateImplCopyWith<$Res> {
  __$$OrderMessageListUiStateImplCopyWithImpl(
      _$OrderMessageListUiStateImpl _value,
      $Res Function(_$OrderMessageListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
    Object? orderMessageList = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$OrderMessageListUiStateImpl(
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
      orderMessageList: null == orderMessageList
          ? _value._orderMessageList
          : orderMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$OrderMessageListUiStateImpl implements _OrderMessageListUiState {
  _$OrderMessageListUiStateImpl(
      {this.page = 1,
      this.size = 20,
      this.hasMore = false,
      final List<CommonMsgRecord> orderMessageList = const [],
      this.uiEvent})
      : _orderMessageList = orderMessageList;

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final bool hasMore;
  final List<CommonMsgRecord> _orderMessageList;
  @override
  @JsonKey()
  List<CommonMsgRecord> get orderMessageList {
    if (_orderMessageList is EqualUnmodifiableListView)
      return _orderMessageList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderMessageList);
  }

  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'OrderMessageListUiState(page: $page, size: $size, hasMore: $hasMore, orderMessageList: $orderMessageList, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderMessageListUiStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            const DeepCollectionEquality()
                .equals(other._orderMessageList, _orderMessageList) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, size, hasMore,
      const DeepCollectionEquality().hash(_orderMessageList), uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderMessageListUiStateImplCopyWith<_$OrderMessageListUiStateImpl>
      get copyWith => __$$OrderMessageListUiStateImplCopyWithImpl<
          _$OrderMessageListUiStateImpl>(this, _$identity);
}

abstract class _OrderMessageListUiState implements OrderMessageListUiState {
  factory _OrderMessageListUiState(
      {final int page,
      final int size,
      final bool hasMore,
      final List<CommonMsgRecord> orderMessageList,
      final CommonUIEvent? uiEvent}) = _$OrderMessageListUiStateImpl;

  @override
  int get page;
  @override
  int get size;
  @override
  bool get hasMore;
  @override
  List<CommonMsgRecord> get orderMessageList;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$OrderMessageListUiStateImplCopyWith<_$OrderMessageListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
