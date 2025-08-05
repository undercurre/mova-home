// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vip_message_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VipMessageListUiState {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  List<CommonMsgRecord> get vipMessageList =>
      throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $VipMessageListUiStateCopyWith<VipMessageListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VipMessageListUiStateCopyWith<$Res> {
  factory $VipMessageListUiStateCopyWith(VipMessageListUiState value,
          $Res Function(VipMessageListUiState) then) =
      _$VipMessageListUiStateCopyWithImpl<$Res, VipMessageListUiState>;
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      List<CommonMsgRecord> vipMessageList,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$VipMessageListUiStateCopyWithImpl<$Res,
        $Val extends VipMessageListUiState>
    implements $VipMessageListUiStateCopyWith<$Res> {
  _$VipMessageListUiStateCopyWithImpl(this._value, this._then);

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
    Object? vipMessageList = null,
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
      vipMessageList: null == vipMessageList
          ? _value.vipMessageList
          : vipMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VipMessageListUiStateImplCopyWith<$Res>
    implements $VipMessageListUiStateCopyWith<$Res> {
  factory _$$VipMessageListUiStateImplCopyWith(
          _$VipMessageListUiStateImpl value,
          $Res Function(_$VipMessageListUiStateImpl) then) =
      __$$VipMessageListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      List<CommonMsgRecord> vipMessageList,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$VipMessageListUiStateImplCopyWithImpl<$Res>
    extends _$VipMessageListUiStateCopyWithImpl<$Res,
        _$VipMessageListUiStateImpl>
    implements _$$VipMessageListUiStateImplCopyWith<$Res> {
  __$$VipMessageListUiStateImplCopyWithImpl(_$VipMessageListUiStateImpl _value,
      $Res Function(_$VipMessageListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
    Object? vipMessageList = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$VipMessageListUiStateImpl(
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
      vipMessageList: null == vipMessageList
          ? _value._vipMessageList
          : vipMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$VipMessageListUiStateImpl implements _VipMessageListUiState {
  _$VipMessageListUiStateImpl(
      {this.page = 1,
      this.size = 20,
      this.hasMore = false,
      final List<CommonMsgRecord> vipMessageList = const [],
      this.uiEvent})
      : _vipMessageList = vipMessageList;

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final bool hasMore;
  final List<CommonMsgRecord> _vipMessageList;
  @override
  @JsonKey()
  List<CommonMsgRecord> get vipMessageList {
    if (_vipMessageList is EqualUnmodifiableListView) return _vipMessageList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vipMessageList);
  }

  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'VipMessageListUiState(page: $page, size: $size, hasMore: $hasMore, vipMessageList: $vipMessageList, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VipMessageListUiStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            const DeepCollectionEquality()
                .equals(other._vipMessageList, _vipMessageList) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, size, hasMore,
      const DeepCollectionEquality().hash(_vipMessageList), uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VipMessageListUiStateImplCopyWith<_$VipMessageListUiStateImpl>
      get copyWith => __$$VipMessageListUiStateImplCopyWithImpl<
          _$VipMessageListUiStateImpl>(this, _$identity);
}

abstract class _VipMessageListUiState implements VipMessageListUiState {
  factory _VipMessageListUiState(
      {final int page,
      final int size,
      final bool hasMore,
      final List<CommonMsgRecord> vipMessageList,
      final CommonUIEvent? uiEvent}) = _$VipMessageListUiStateImpl;

  @override
  int get page;
  @override
  int get size;
  @override
  bool get hasMore;
  @override
  List<CommonMsgRecord> get vipMessageList;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$VipMessageListUiStateImplCopyWith<_$VipMessageListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
