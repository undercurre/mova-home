// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_message_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ActivityMessageListUiState {
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  List<CommonMsgRecord> get activityMessageList =>
      throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActivityMessageListUiStateCopyWith<ActivityMessageListUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityMessageListUiStateCopyWith<$Res> {
  factory $ActivityMessageListUiStateCopyWith(ActivityMessageListUiState value,
          $Res Function(ActivityMessageListUiState) then) =
      _$ActivityMessageListUiStateCopyWithImpl<$Res,
          ActivityMessageListUiState>;
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      List<CommonMsgRecord> activityMessageList,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class _$ActivityMessageListUiStateCopyWithImpl<$Res,
        $Val extends ActivityMessageListUiState>
    implements $ActivityMessageListUiStateCopyWith<$Res> {
  _$ActivityMessageListUiStateCopyWithImpl(this._value, this._then);

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
    Object? activityMessageList = null,
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
      activityMessageList: null == activityMessageList
          ? _value.activityMessageList
          : activityMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityMessageListUiStateImplCopyWith<$Res>
    implements $ActivityMessageListUiStateCopyWith<$Res> {
  factory _$$ActivityMessageListUiStateImplCopyWith(
          _$ActivityMessageListUiStateImpl value,
          $Res Function(_$ActivityMessageListUiStateImpl) then) =
      __$$ActivityMessageListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int page,
      int size,
      bool hasMore,
      List<CommonMsgRecord> activityMessageList,
      CommonUIEvent? uiEvent});
}

/// @nodoc
class __$$ActivityMessageListUiStateImplCopyWithImpl<$Res>
    extends _$ActivityMessageListUiStateCopyWithImpl<$Res,
        _$ActivityMessageListUiStateImpl>
    implements _$$ActivityMessageListUiStateImplCopyWith<$Res> {
  __$$ActivityMessageListUiStateImplCopyWithImpl(
      _$ActivityMessageListUiStateImpl _value,
      $Res Function(_$ActivityMessageListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
    Object? activityMessageList = null,
    Object? uiEvent = freezed,
  }) {
    return _then(_$ActivityMessageListUiStateImpl(
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
      activityMessageList: null == activityMessageList
          ? _value._activityMessageList
          : activityMessageList // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
    ));
  }
}

/// @nodoc

class _$ActivityMessageListUiStateImpl implements _ActivityMessageListUiState {
  _$ActivityMessageListUiStateImpl(
      {this.page = 1,
      this.size = 20,
      this.hasMore = false,
      final List<CommonMsgRecord> activityMessageList = const [],
      this.uiEvent})
      : _activityMessageList = activityMessageList;

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final bool hasMore;
  final List<CommonMsgRecord> _activityMessageList;
  @override
  @JsonKey()
  List<CommonMsgRecord> get activityMessageList {
    if (_activityMessageList is EqualUnmodifiableListView)
      return _activityMessageList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activityMessageList);
  }

  @override
  final CommonUIEvent? uiEvent;

  @override
  String toString() {
    return 'ActivityMessageListUiState(page: $page, size: $size, hasMore: $hasMore, activityMessageList: $activityMessageList, uiEvent: $uiEvent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityMessageListUiStateImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            const DeepCollectionEquality()
                .equals(other._activityMessageList, _activityMessageList) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, page, size, hasMore,
      const DeepCollectionEquality().hash(_activityMessageList), uiEvent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityMessageListUiStateImplCopyWith<_$ActivityMessageListUiStateImpl>
      get copyWith => __$$ActivityMessageListUiStateImplCopyWithImpl<
          _$ActivityMessageListUiStateImpl>(this, _$identity);
}

abstract class _ActivityMessageListUiState
    implements ActivityMessageListUiState {
  factory _ActivityMessageListUiState(
      {final int page,
      final int size,
      final bool hasMore,
      final List<CommonMsgRecord> activityMessageList,
      final CommonUIEvent? uiEvent}) = _$ActivityMessageListUiStateImpl;

  @override
  int get page;
  @override
  int get size;
  @override
  bool get hasMore;
  @override
  List<CommonMsgRecord> get activityMessageList;
  @override
  CommonUIEvent? get uiEvent;
  @override
  @JsonKey(ignore: true)
  _$$ActivityMessageListUiStateImplCopyWith<_$ActivityMessageListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
