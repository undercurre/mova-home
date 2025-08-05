// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share_message_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShareMessageListUiState {
  int get offset => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  List<ShareMessageModel> get shareMessageList =>
      throw _privateConstructorUsedError;
  String get searchKey => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShareMessageListUiStateCopyWith<ShareMessageListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareMessageListUiStateCopyWith<$Res> {
  factory $ShareMessageListUiStateCopyWith(ShareMessageListUiState value,
          $Res Function(ShareMessageListUiState) then) =
      _$ShareMessageListUiStateCopyWithImpl<$Res, ShareMessageListUiState>;
  @useResult
  $Res call(
      {int offset,
      int limit,
      List<ShareMessageModel> shareMessageList,
      String searchKey,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$ShareMessageListUiStateCopyWithImpl<$Res,
        $Val extends ShareMessageListUiState>
    implements $ShareMessageListUiStateCopyWith<$Res> {
  _$ShareMessageListUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? shareMessageList = null,
    Object? searchKey = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_value.copyWith(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      shareMessageList: null == shareMessageList
          ? _value.shareMessageList
          : shareMessageList // ignore: cast_nullable_to_non_nullable
              as List<ShareMessageModel>,
      searchKey: null == searchKey
          ? _value.searchKey
          : searchKey // ignore: cast_nullable_to_non_nullable
              as String,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShareMessageListUiStateImplCopyWith<$Res>
    implements $ShareMessageListUiStateCopyWith<$Res> {
  factory _$$ShareMessageListUiStateImplCopyWith(
          _$ShareMessageListUiStateImpl value,
          $Res Function(_$ShareMessageListUiStateImpl) then) =
      __$$ShareMessageListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int offset,
      int limit,
      List<ShareMessageModel> shareMessageList,
      String searchKey,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$ShareMessageListUiStateImplCopyWithImpl<$Res>
    extends _$ShareMessageListUiStateCopyWithImpl<$Res,
        _$ShareMessageListUiStateImpl>
    implements _$$ShareMessageListUiStateImplCopyWith<$Res> {
  __$$ShareMessageListUiStateImplCopyWithImpl(
      _$ShareMessageListUiStateImpl _value,
      $Res Function(_$ShareMessageListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? limit = null,
    Object? shareMessageList = null,
    Object? searchKey = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$ShareMessageListUiStateImpl(
      offset: null == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      shareMessageList: null == shareMessageList
          ? _value._shareMessageList
          : shareMessageList // ignore: cast_nullable_to_non_nullable
              as List<ShareMessageModel>,
      searchKey: null == searchKey
          ? _value.searchKey
          : searchKey // ignore: cast_nullable_to_non_nullable
              as String,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$ShareMessageListUiStateImpl implements _ShareMessageListUiState {
  _$ShareMessageListUiStateImpl(
      {this.offset = 0,
      this.limit = 10,
      final List<ShareMessageModel> shareMessageList = const [],
      this.searchKey = '',
      this.uiEvent})
      : _shareMessageList = shareMessageList;

  @override
  @JsonKey()
  final int offset;
  @override
  @JsonKey()
  final int limit;
  final List<ShareMessageModel> _shareMessageList;
  @override
  @JsonKey()
  List<ShareMessageModel> get shareMessageList {
    if (_shareMessageList is EqualUnmodifiableListView)
      return _shareMessageList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shareMessageList);
  }

  @override
  @JsonKey()
  final String searchKey;
  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'ShareMessageListUiState(offset: $offset, limit: $limit, shareMessageList: $shareMessageList, searchKey: $searchKey, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareMessageListUiStateImpl &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality()
                .equals(other._shareMessageList, _shareMessageList) &&
            (identical(other.searchKey, searchKey) ||
                other.searchKey == searchKey) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      offset,
      limit,
      const DeepCollectionEquality().hash(_shareMessageList),
      searchKey,
      uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareMessageListUiStateImplCopyWith<_$ShareMessageListUiStateImpl>
      get copyWith => __$$ShareMessageListUiStateImplCopyWithImpl<
          _$ShareMessageListUiStateImpl>(this, _$identity);
}

abstract class _ShareMessageListUiState implements ShareMessageListUiState {
  factory _ShareMessageListUiState(
      {final int offset,
      final int limit,
      final List<ShareMessageModel> shareMessageList,
      final String searchKey,
      final CommonUIEvent? uiEvent}) = _$ShareMessageListUiStateImpl;

  @override
  int get offset;
  @override
  int get limit;
  @override
  List<ShareMessageModel> get shareMessageList;
  @override
  String get searchKey;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$ShareMessageListUiStateImplCopyWith<_$ShareMessageListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
