// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_main_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MessageMainUIState {
  bool get loading => throw _privateConstructorUsedError;
  int get unreadTotal => throw _privateConstructorUsedError;
  CommonUIEvent? get uiEvent => throw _privateConstructorUsedError;
  bool get showNoticePermission => throw _privateConstructorUsedError;
  List<MessageItemModel> get headMsgs => throw _privateConstructorUsedError;
  List<MessageItemModel> get deviceMsgs => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageMainUIStateCopyWith<MessageMainUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageMainUIStateCopyWith<$Res> {
  factory $MessageMainUIStateCopyWith(
          MessageMainUIState value, $Res Function(MessageMainUIState) then) =
      _$MessageMainUIStateCopyWithImpl<$Res, MessageMainUIState>;
  @useResult
  $Res call(
      {bool loading,
      int unreadTotal,
      CommonUIEvent? uiEvent,
      bool showNoticePermission,
      List<MessageItemModel> headMsgs,
      List<MessageItemModel> deviceMsgs});
}

/// @nodoc
class _$MessageMainUIStateCopyWithImpl<$Res, $Val extends MessageMainUIState>
    implements $MessageMainUIStateCopyWith<$Res> {
  _$MessageMainUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? unreadTotal = null,
    Object? uiEvent = freezed,
    Object? showNoticePermission = null,
    Object? headMsgs = null,
    Object? deviceMsgs = null,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadTotal: null == unreadTotal
          ? _value.unreadTotal
          : unreadTotal // ignore: cast_nullable_to_non_nullable
              as int,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
      showNoticePermission: null == showNoticePermission
          ? _value.showNoticePermission
          : showNoticePermission // ignore: cast_nullable_to_non_nullable
              as bool,
      headMsgs: null == headMsgs
          ? _value.headMsgs
          : headMsgs // ignore: cast_nullable_to_non_nullable
              as List<MessageItemModel>,
      deviceMsgs: null == deviceMsgs
          ? _value.deviceMsgs
          : deviceMsgs // ignore: cast_nullable_to_non_nullable
              as List<MessageItemModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageMainUIStateImplCopyWith<$Res>
    implements $MessageMainUIStateCopyWith<$Res> {
  factory _$$MessageMainUIStateImplCopyWith(_$MessageMainUIStateImpl value,
          $Res Function(_$MessageMainUIStateImpl) then) =
      __$$MessageMainUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      int unreadTotal,
      CommonUIEvent? uiEvent,
      bool showNoticePermission,
      List<MessageItemModel> headMsgs,
      List<MessageItemModel> deviceMsgs});
}

/// @nodoc
class __$$MessageMainUIStateImplCopyWithImpl<$Res>
    extends _$MessageMainUIStateCopyWithImpl<$Res, _$MessageMainUIStateImpl>
    implements _$$MessageMainUIStateImplCopyWith<$Res> {
  __$$MessageMainUIStateImplCopyWithImpl(_$MessageMainUIStateImpl _value,
      $Res Function(_$MessageMainUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? unreadTotal = null,
    Object? uiEvent = freezed,
    Object? showNoticePermission = null,
    Object? headMsgs = null,
    Object? deviceMsgs = null,
  }) {
    return _then(_$MessageMainUIStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      unreadTotal: null == unreadTotal
          ? _value.unreadTotal
          : unreadTotal // ignore: cast_nullable_to_non_nullable
              as int,
      uiEvent: freezed == uiEvent
          ? _value.uiEvent
          : uiEvent // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent?,
      showNoticePermission: null == showNoticePermission
          ? _value.showNoticePermission
          : showNoticePermission // ignore: cast_nullable_to_non_nullable
              as bool,
      headMsgs: null == headMsgs
          ? _value._headMsgs
          : headMsgs // ignore: cast_nullable_to_non_nullable
              as List<MessageItemModel>,
      deviceMsgs: null == deviceMsgs
          ? _value._deviceMsgs
          : deviceMsgs // ignore: cast_nullable_to_non_nullable
              as List<MessageItemModel>,
    ));
  }
}

/// @nodoc

class _$MessageMainUIStateImpl implements _MessageMainUIState {
  const _$MessageMainUIStateImpl(
      {this.loading = true,
      this.unreadTotal = 0,
      this.uiEvent,
      this.showNoticePermission = false,
      final List<MessageItemModel> headMsgs = const [],
      final List<MessageItemModel> deviceMsgs = const []})
      : _headMsgs = headMsgs,
        _deviceMsgs = deviceMsgs;

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final int unreadTotal;
  @override
  final CommonUIEvent? uiEvent;
  @override
  @JsonKey()
  final bool showNoticePermission;
  final List<MessageItemModel> _headMsgs;
  @override
  @JsonKey()
  List<MessageItemModel> get headMsgs {
    if (_headMsgs is EqualUnmodifiableListView) return _headMsgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_headMsgs);
  }

  final List<MessageItemModel> _deviceMsgs;
  @override
  @JsonKey()
  List<MessageItemModel> get deviceMsgs {
    if (_deviceMsgs is EqualUnmodifiableListView) return _deviceMsgs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deviceMsgs);
  }

  @override
  String toString() {
    return 'MessageMainUIState(loading: $loading, unreadTotal: $unreadTotal, uiEvent: $uiEvent, showNoticePermission: $showNoticePermission, headMsgs: $headMsgs, deviceMsgs: $deviceMsgs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageMainUIStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.unreadTotal, unreadTotal) ||
                other.unreadTotal == unreadTotal) &&
            (identical(other.uiEvent, uiEvent) || other.uiEvent == uiEvent) &&
            (identical(other.showNoticePermission, showNoticePermission) ||
                other.showNoticePermission == showNoticePermission) &&
            const DeepCollectionEquality().equals(other._headMsgs, _headMsgs) &&
            const DeepCollectionEquality()
                .equals(other._deviceMsgs, _deviceMsgs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      unreadTotal,
      uiEvent,
      showNoticePermission,
      const DeepCollectionEquality().hash(_headMsgs),
      const DeepCollectionEquality().hash(_deviceMsgs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageMainUIStateImplCopyWith<_$MessageMainUIStateImpl> get copyWith =>
      __$$MessageMainUIStateImplCopyWithImpl<_$MessageMainUIStateImpl>(
          this, _$identity);
}

abstract class _MessageMainUIState implements MessageMainUIState {
  const factory _MessageMainUIState(
      {final bool loading,
      final int unreadTotal,
      final CommonUIEvent? uiEvent,
      final bool showNoticePermission,
      final List<MessageItemModel> headMsgs,
      final List<MessageItemModel> deviceMsgs}) = _$MessageMainUIStateImpl;

  @override
  bool get loading;
  @override
  int get unreadTotal;
  @override
  CommonUIEvent? get uiEvent;
  @override
  bool get showNoticePermission;
  @override
  List<MessageItemModel> get headMsgs;
  @override
  List<MessageItemModel> get deviceMsgs;
  @override
  @JsonKey(ignore: true)
  _$$MessageMainUIStateImplCopyWith<_$MessageMainUIStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MessageItemModel {
  String? get type => throw _privateConstructorUsedError;
  set type(String? value) => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  set title(String value) => throw _privateConstructorUsedError;
  String get subTitle => throw _privateConstructorUsedError;
  set subTitle(String value) => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  set date(String value) => throw _privateConstructorUsedError;
  String get img => throw _privateConstructorUsedError;
  set img(String value) => throw _privateConstructorUsedError;
  String get defaultImg => throw _privateConstructorUsedError;
  set defaultImg(String value) => throw _privateConstructorUsedError;
  int get unread => throw _privateConstructorUsedError;
  set unread(int value) => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  set link(String? value) => throw _privateConstructorUsedError;
  dynamic get showShared => throw _privateConstructorUsedError;
  set showShared(dynamic value) => throw _privateConstructorUsedError;
  dynamic get rawData => throw _privateConstructorUsedError;
  set rawData(dynamic value) => throw _privateConstructorUsedError;
  dynamic get categoryUnread => throw _privateConstructorUsedError;
  set categoryUnread(dynamic value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageItemModelCopyWith<MessageItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageItemModelCopyWith<$Res> {
  factory $MessageItemModelCopyWith(
          MessageItemModel value, $Res Function(MessageItemModel) then) =
      _$MessageItemModelCopyWithImpl<$Res, MessageItemModel>;
  @useResult
  $Res call(
      {String? type,
      String title,
      String subTitle,
      String date,
      String img,
      String defaultImg,
      int unread,
      String? link,
      dynamic showShared,
      dynamic rawData,
      dynamic categoryUnread});
}

/// @nodoc
class _$MessageItemModelCopyWithImpl<$Res, $Val extends MessageItemModel>
    implements $MessageItemModelCopyWith<$Res> {
  _$MessageItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? title = null,
    Object? subTitle = null,
    Object? date = null,
    Object? img = null,
    Object? defaultImg = null,
    Object? unread = null,
    Object? link = freezed,
    Object? showShared = freezed,
    Object? rawData = freezed,
    Object? categoryUnread = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subTitle: null == subTitle
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      defaultImg: null == defaultImg
          ? _value.defaultImg
          : defaultImg // ignore: cast_nullable_to_non_nullable
              as String,
      unread: null == unread
          ? _value.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as int,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      showShared: freezed == showShared
          ? _value.showShared
          : showShared // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rawData: freezed == rawData
          ? _value.rawData
          : rawData // ignore: cast_nullable_to_non_nullable
              as dynamic,
      categoryUnread: freezed == categoryUnread
          ? _value.categoryUnread
          : categoryUnread // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageItemModelImplCopyWith<$Res>
    implements $MessageItemModelCopyWith<$Res> {
  factory _$$MessageItemModelImplCopyWith(_$MessageItemModelImpl value,
          $Res Function(_$MessageItemModelImpl) then) =
      __$$MessageItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String title,
      String subTitle,
      String date,
      String img,
      String defaultImg,
      int unread,
      String? link,
      dynamic showShared,
      dynamic rawData,
      dynamic categoryUnread});
}

/// @nodoc
class __$$MessageItemModelImplCopyWithImpl<$Res>
    extends _$MessageItemModelCopyWithImpl<$Res, _$MessageItemModelImpl>
    implements _$$MessageItemModelImplCopyWith<$Res> {
  __$$MessageItemModelImplCopyWithImpl(_$MessageItemModelImpl _value,
      $Res Function(_$MessageItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? title = null,
    Object? subTitle = null,
    Object? date = null,
    Object? img = null,
    Object? defaultImg = null,
    Object? unread = null,
    Object? link = freezed,
    Object? showShared = freezed,
    Object? rawData = freezed,
    Object? categoryUnread = freezed,
  }) {
    return _then(_$MessageItemModelImpl(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subTitle: null == subTitle
          ? _value.subTitle
          : subTitle // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      img: null == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String,
      defaultImg: null == defaultImg
          ? _value.defaultImg
          : defaultImg // ignore: cast_nullable_to_non_nullable
              as String,
      unread: null == unread
          ? _value.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as int,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      showShared: freezed == showShared ? _value.showShared! : showShared,
      rawData: freezed == rawData
          ? _value.rawData
          : rawData // ignore: cast_nullable_to_non_nullable
              as dynamic,
      categoryUnread: freezed == categoryUnread
          ? _value.categoryUnread
          : categoryUnread // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$MessageItemModelImpl implements _MessageItemModel {
  _$MessageItemModelImpl(
      {this.type,
      this.title = '',
      this.subTitle = '',
      this.date = '',
      this.img = '',
      this.defaultImg = '',
      this.unread = 0,
      this.link,
      this.showShared = false,
      this.rawData,
      this.categoryUnread});

  @override
  String? type;
  @override
  @JsonKey()
  String title;
  @override
  @JsonKey()
  String subTitle;
  @override
  @JsonKey()
  String date;
  @override
  @JsonKey()
  String img;
  @override
  @JsonKey()
  String defaultImg;
  @override
  @JsonKey()
  int unread;
  @override
  String? link;
  @override
  @JsonKey()
  dynamic showShared;
  @override
  dynamic rawData;
  @override
  dynamic categoryUnread;

  @override
  String toString() {
    return 'MessageItemModel(type: $type, title: $title, subTitle: $subTitle, date: $date, img: $img, defaultImg: $defaultImg, unread: $unread, link: $link, showShared: $showShared, rawData: $rawData, categoryUnread: $categoryUnread)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageItemModelImplCopyWith<_$MessageItemModelImpl> get copyWith =>
      __$$MessageItemModelImplCopyWithImpl<_$MessageItemModelImpl>(
          this, _$identity);
}

abstract class _MessageItemModel implements MessageItemModel {
  factory _MessageItemModel(
      {String? type,
      String title,
      String subTitle,
      String date,
      String img,
      String defaultImg,
      int unread,
      String? link,
      dynamic showShared,
      dynamic rawData,
      dynamic categoryUnread}) = _$MessageItemModelImpl;

  @override
  String? get type;
  set type(String? value);
  @override
  String get title;
  set title(String value);
  @override
  String get subTitle;
  set subTitle(String value);
  @override
  String get date;
  set date(String value);
  @override
  String get img;
  set img(String value);
  @override
  String get defaultImg;
  set defaultImg(String value);
  @override
  int get unread;
  set unread(int value);
  @override
  String? get link;
  set link(String? value);
  @override
  dynamic get showShared;
  set showShared(dynamic value);
  @override
  dynamic get rawData;
  set rawData(dynamic value);
  @override
  dynamic get categoryUnread;
  set categoryUnread(dynamic value);
  @override
  @JsonKey(ignore: true)
  _$$MessageItemModelImplCopyWith<_$MessageItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
