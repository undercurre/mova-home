// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_stat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageStat _$MessageStatFromJson(Map<String, dynamic> json) {
  return _MessageStat.fromJson(json);
}

/// @nodoc
mixin _$MessageStat {
  int get shareUnread => throw _privateConstructorUsedError;
  int get systemMsgUnread => throw _privateConstructorUsedError;
  int get serviceMsgUnread => throw _privateConstructorUsedError;
  List<MsgUnreadBean>? get msgUnreads => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageStatCopyWith<MessageStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageStatCopyWith<$Res> {
  factory $MessageStatCopyWith(
          MessageStat value, $Res Function(MessageStat) then) =
      _$MessageStatCopyWithImpl<$Res, MessageStat>;
  @useResult
  $Res call(
      {int shareUnread,
      int systemMsgUnread,
      int serviceMsgUnread,
      List<MsgUnreadBean>? msgUnreads});
}

/// @nodoc
class _$MessageStatCopyWithImpl<$Res, $Val extends MessageStat>
    implements $MessageStatCopyWith<$Res> {
  _$MessageStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shareUnread = null,
    Object? systemMsgUnread = null,
    Object? serviceMsgUnread = null,
    Object? msgUnreads = freezed,
  }) {
    return _then(_value.copyWith(
      shareUnread: null == shareUnread
          ? _value.shareUnread
          : shareUnread // ignore: cast_nullable_to_non_nullable
              as int,
      systemMsgUnread: null == systemMsgUnread
          ? _value.systemMsgUnread
          : systemMsgUnread // ignore: cast_nullable_to_non_nullable
              as int,
      serviceMsgUnread: null == serviceMsgUnread
          ? _value.serviceMsgUnread
          : serviceMsgUnread // ignore: cast_nullable_to_non_nullable
              as int,
      msgUnreads: freezed == msgUnreads
          ? _value.msgUnreads
          : msgUnreads // ignore: cast_nullable_to_non_nullable
              as List<MsgUnreadBean>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageStatImplCopyWith<$Res>
    implements $MessageStatCopyWith<$Res> {
  factory _$$MessageStatImplCopyWith(
          _$MessageStatImpl value, $Res Function(_$MessageStatImpl) then) =
      __$$MessageStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int shareUnread,
      int systemMsgUnread,
      int serviceMsgUnread,
      List<MsgUnreadBean>? msgUnreads});
}

/// @nodoc
class __$$MessageStatImplCopyWithImpl<$Res>
    extends _$MessageStatCopyWithImpl<$Res, _$MessageStatImpl>
    implements _$$MessageStatImplCopyWith<$Res> {
  __$$MessageStatImplCopyWithImpl(
      _$MessageStatImpl _value, $Res Function(_$MessageStatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shareUnread = null,
    Object? systemMsgUnread = null,
    Object? serviceMsgUnread = null,
    Object? msgUnreads = freezed,
  }) {
    return _then(_$MessageStatImpl(
      shareUnread: null == shareUnread
          ? _value.shareUnread
          : shareUnread // ignore: cast_nullable_to_non_nullable
              as int,
      systemMsgUnread: null == systemMsgUnread
          ? _value.systemMsgUnread
          : systemMsgUnread // ignore: cast_nullable_to_non_nullable
              as int,
      serviceMsgUnread: null == serviceMsgUnread
          ? _value.serviceMsgUnread
          : serviceMsgUnread // ignore: cast_nullable_to_non_nullable
              as int,
      msgUnreads: freezed == msgUnreads
          ? _value._msgUnreads
          : msgUnreads // ignore: cast_nullable_to_non_nullable
              as List<MsgUnreadBean>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageStatImpl extends _MessageStat {
  _$MessageStatImpl(
      {this.shareUnread = 0,
      this.systemMsgUnread = 0,
      this.serviceMsgUnread = 0,
      final List<MsgUnreadBean>? msgUnreads})
      : _msgUnreads = msgUnreads,
        super._();

  factory _$MessageStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageStatImplFromJson(json);

  @override
  @JsonKey()
  final int shareUnread;
  @override
  @JsonKey()
  final int systemMsgUnread;
  @override
  @JsonKey()
  final int serviceMsgUnread;
  final List<MsgUnreadBean>? _msgUnreads;
  @override
  List<MsgUnreadBean>? get msgUnreads {
    final value = _msgUnreads;
    if (value == null) return null;
    if (_msgUnreads is EqualUnmodifiableListView) return _msgUnreads;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'MessageStat(shareUnread: $shareUnread, systemMsgUnread: $systemMsgUnread, serviceMsgUnread: $serviceMsgUnread, msgUnreads: $msgUnreads)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageStatImpl &&
            (identical(other.shareUnread, shareUnread) ||
                other.shareUnread == shareUnread) &&
            (identical(other.systemMsgUnread, systemMsgUnread) ||
                other.systemMsgUnread == systemMsgUnread) &&
            (identical(other.serviceMsgUnread, serviceMsgUnread) ||
                other.serviceMsgUnread == serviceMsgUnread) &&
            const DeepCollectionEquality()
                .equals(other._msgUnreads, _msgUnreads));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, shareUnread, systemMsgUnread,
      serviceMsgUnread, const DeepCollectionEquality().hash(_msgUnreads));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageStatImplCopyWith<_$MessageStatImpl> get copyWith =>
      __$$MessageStatImplCopyWithImpl<_$MessageStatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageStatImplToJson(
      this,
    );
  }
}

abstract class _MessageStat extends MessageStat {
  factory _MessageStat(
      {final int shareUnread,
      final int systemMsgUnread,
      final int serviceMsgUnread,
      final List<MsgUnreadBean>? msgUnreads}) = _$MessageStatImpl;
  _MessageStat._() : super._();

  factory _MessageStat.fromJson(Map<String, dynamic> json) =
      _$MessageStatImpl.fromJson;

  @override
  int get shareUnread;
  @override
  int get systemMsgUnread;
  @override
  int get serviceMsgUnread;
  @override
  List<MsgUnreadBean>? get msgUnreads;
  @override
  @JsonKey(ignore: true)
  _$$MessageStatImplCopyWith<_$MessageStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MsgUnreadBean _$MsgUnreadBeanFromJson(Map<String, dynamic> json) {
  return _MsgUnreadBean.fromJson(json);
}

/// @nodoc
mixin _$MsgUnreadBean {
  String? get did => throw _privateConstructorUsedError;
  int get msgUnread => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MsgUnreadBeanCopyWith<MsgUnreadBean> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MsgUnreadBeanCopyWith<$Res> {
  factory $MsgUnreadBeanCopyWith(
          MsgUnreadBean value, $Res Function(MsgUnreadBean) then) =
      _$MsgUnreadBeanCopyWithImpl<$Res, MsgUnreadBean>;
  @useResult
  $Res call({String? did, int msgUnread});
}

/// @nodoc
class _$MsgUnreadBeanCopyWithImpl<$Res, $Val extends MsgUnreadBean>
    implements $MsgUnreadBeanCopyWith<$Res> {
  _$MsgUnreadBeanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? did = freezed,
    Object? msgUnread = null,
  }) {
    return _then(_value.copyWith(
      did: freezed == did
          ? _value.did
          : did // ignore: cast_nullable_to_non_nullable
              as String?,
      msgUnread: null == msgUnread
          ? _value.msgUnread
          : msgUnread // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MsgUnreadBeanImplCopyWith<$Res>
    implements $MsgUnreadBeanCopyWith<$Res> {
  factory _$$MsgUnreadBeanImplCopyWith(
          _$MsgUnreadBeanImpl value, $Res Function(_$MsgUnreadBeanImpl) then) =
      __$$MsgUnreadBeanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? did, int msgUnread});
}

/// @nodoc
class __$$MsgUnreadBeanImplCopyWithImpl<$Res>
    extends _$MsgUnreadBeanCopyWithImpl<$Res, _$MsgUnreadBeanImpl>
    implements _$$MsgUnreadBeanImplCopyWith<$Res> {
  __$$MsgUnreadBeanImplCopyWithImpl(
      _$MsgUnreadBeanImpl _value, $Res Function(_$MsgUnreadBeanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? did = freezed,
    Object? msgUnread = null,
  }) {
    return _then(_$MsgUnreadBeanImpl(
      freezed == did
          ? _value.did
          : did // ignore: cast_nullable_to_non_nullable
              as String?,
      null == msgUnread
          ? _value.msgUnread
          : msgUnread // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MsgUnreadBeanImpl implements _MsgUnreadBean {
  _$MsgUnreadBeanImpl(this.did, this.msgUnread);

  factory _$MsgUnreadBeanImpl.fromJson(Map<String, dynamic> json) =>
      _$$MsgUnreadBeanImplFromJson(json);

  @override
  final String? did;
  @override
  final int msgUnread;

  @override
  String toString() {
    return 'MsgUnreadBean(did: $did, msgUnread: $msgUnread)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MsgUnreadBeanImpl &&
            (identical(other.did, did) || other.did == did) &&
            (identical(other.msgUnread, msgUnread) ||
                other.msgUnread == msgUnread));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, did, msgUnread);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MsgUnreadBeanImplCopyWith<_$MsgUnreadBeanImpl> get copyWith =>
      __$$MsgUnreadBeanImplCopyWithImpl<_$MsgUnreadBeanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MsgUnreadBeanImplToJson(
      this,
    );
  }
}

abstract class _MsgUnreadBean implements MsgUnreadBean {
  factory _MsgUnreadBean(final String? did, final int msgUnread) =
      _$MsgUnreadBeanImpl;

  factory _MsgUnreadBean.fromJson(Map<String, dynamic> json) =
      _$MsgUnreadBeanImpl.fromJson;

  @override
  String? get did;
  @override
  int get msgUnread;
  @override
  @JsonKey(ignore: true)
  _$$MsgUnreadBeanImplCopyWith<_$MsgUnreadBeanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
