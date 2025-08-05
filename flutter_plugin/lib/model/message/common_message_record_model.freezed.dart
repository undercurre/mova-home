// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_message_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommonMsgRecordExt _$CommonMsgRecordExtFromJson(Map<String, dynamic> json) {
  return _CommonMsgRecordExt.fromJson(json);
}

/// @nodoc
mixin _$CommonMsgRecordExt {
  String? get goods_name => throw _privateConstructorUsedError;
  String? get goods_num => throw _privateConstructorUsedError;
  String? get link_url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommonMsgRecordExtCopyWith<CommonMsgRecordExt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonMsgRecordExtCopyWith<$Res> {
  factory $CommonMsgRecordExtCopyWith(
          CommonMsgRecordExt value, $Res Function(CommonMsgRecordExt) then) =
      _$CommonMsgRecordExtCopyWithImpl<$Res, CommonMsgRecordExt>;
  @useResult
  $Res call({String? goods_name, String? goods_num, String? link_url});
}

/// @nodoc
class _$CommonMsgRecordExtCopyWithImpl<$Res, $Val extends CommonMsgRecordExt>
    implements $CommonMsgRecordExtCopyWith<$Res> {
  _$CommonMsgRecordExtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goods_name = freezed,
    Object? goods_num = freezed,
    Object? link_url = freezed,
  }) {
    return _then(_value.copyWith(
      goods_name: freezed == goods_name
          ? _value.goods_name
          : goods_name // ignore: cast_nullable_to_non_nullable
              as String?,
      goods_num: freezed == goods_num
          ? _value.goods_num
          : goods_num // ignore: cast_nullable_to_non_nullable
              as String?,
      link_url: freezed == link_url
          ? _value.link_url
          : link_url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonMsgRecordExtImplCopyWith<$Res>
    implements $CommonMsgRecordExtCopyWith<$Res> {
  factory _$$CommonMsgRecordExtImplCopyWith(_$CommonMsgRecordExtImpl value,
          $Res Function(_$CommonMsgRecordExtImpl) then) =
      __$$CommonMsgRecordExtImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? goods_name, String? goods_num, String? link_url});
}

/// @nodoc
class __$$CommonMsgRecordExtImplCopyWithImpl<$Res>
    extends _$CommonMsgRecordExtCopyWithImpl<$Res, _$CommonMsgRecordExtImpl>
    implements _$$CommonMsgRecordExtImplCopyWith<$Res> {
  __$$CommonMsgRecordExtImplCopyWithImpl(_$CommonMsgRecordExtImpl _value,
      $Res Function(_$CommonMsgRecordExtImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? goods_name = freezed,
    Object? goods_num = freezed,
    Object? link_url = freezed,
  }) {
    return _then(_$CommonMsgRecordExtImpl(
      goods_name: freezed == goods_name
          ? _value.goods_name
          : goods_name // ignore: cast_nullable_to_non_nullable
              as String?,
      goods_num: freezed == goods_num
          ? _value.goods_num
          : goods_num // ignore: cast_nullable_to_non_nullable
              as String?,
      link_url: freezed == link_url
          ? _value.link_url
          : link_url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonMsgRecordExtImpl implements _CommonMsgRecordExt {
  _$CommonMsgRecordExtImpl({this.goods_name, this.goods_num, this.link_url});

  factory _$CommonMsgRecordExtImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonMsgRecordExtImplFromJson(json);

  @override
  final String? goods_name;
  @override
  final String? goods_num;
  @override
  final String? link_url;

  @override
  String toString() {
    return 'CommonMsgRecordExt(goods_name: $goods_name, goods_num: $goods_num, link_url: $link_url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonMsgRecordExtImpl &&
            (identical(other.goods_name, goods_name) ||
                other.goods_name == goods_name) &&
            (identical(other.goods_num, goods_num) ||
                other.goods_num == goods_num) &&
            (identical(other.link_url, link_url) ||
                other.link_url == link_url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, goods_name, goods_num, link_url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonMsgRecordExtImplCopyWith<_$CommonMsgRecordExtImpl> get copyWith =>
      __$$CommonMsgRecordExtImplCopyWithImpl<_$CommonMsgRecordExtImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonMsgRecordExtImplToJson(
      this,
    );
  }
}

abstract class _CommonMsgRecordExt implements CommonMsgRecordExt {
  factory _CommonMsgRecordExt(
      {final String? goods_name,
      final String? goods_num,
      final String? link_url}) = _$CommonMsgRecordExtImpl;

  factory _CommonMsgRecordExt.fromJson(Map<String, dynamic> json) =
      _$CommonMsgRecordExtImpl.fromJson;

  @override
  String? get goods_name;
  @override
  String? get goods_num;
  @override
  String? get link_url;
  @override
  @JsonKey(ignore: true)
  _$$CommonMsgRecordExtImplCopyWith<_$CommonMsgRecordExtImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommonMsgRecordDisplay _$CommonMsgRecordDisplayFromJson(
    Map<String, dynamic> json) {
  return _CommonMsgRecordDisplay.fromJson(json);
}

/// @nodoc
mixin _$CommonMsgRecordDisplay {
  String? get lang => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommonMsgRecordDisplayCopyWith<CommonMsgRecordDisplay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonMsgRecordDisplayCopyWith<$Res> {
  factory $CommonMsgRecordDisplayCopyWith(CommonMsgRecordDisplay value,
          $Res Function(CommonMsgRecordDisplay) then) =
      _$CommonMsgRecordDisplayCopyWithImpl<$Res, CommonMsgRecordDisplay>;
  @useResult
  $Res call({String? lang, String? content, String? link, String? name});
}

/// @nodoc
class _$CommonMsgRecordDisplayCopyWithImpl<$Res,
        $Val extends CommonMsgRecordDisplay>
    implements $CommonMsgRecordDisplayCopyWith<$Res> {
  _$CommonMsgRecordDisplayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lang = freezed,
    Object? content = freezed,
    Object? link = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonMsgRecordDisplayImplCopyWith<$Res>
    implements $CommonMsgRecordDisplayCopyWith<$Res> {
  factory _$$CommonMsgRecordDisplayImplCopyWith(
          _$CommonMsgRecordDisplayImpl value,
          $Res Function(_$CommonMsgRecordDisplayImpl) then) =
      __$$CommonMsgRecordDisplayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? lang, String? content, String? link, String? name});
}

/// @nodoc
class __$$CommonMsgRecordDisplayImplCopyWithImpl<$Res>
    extends _$CommonMsgRecordDisplayCopyWithImpl<$Res,
        _$CommonMsgRecordDisplayImpl>
    implements _$$CommonMsgRecordDisplayImplCopyWith<$Res> {
  __$$CommonMsgRecordDisplayImplCopyWithImpl(
      _$CommonMsgRecordDisplayImpl _value,
      $Res Function(_$CommonMsgRecordDisplayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lang = freezed,
    Object? content = freezed,
    Object? link = freezed,
    Object? name = freezed,
  }) {
    return _then(_$CommonMsgRecordDisplayImpl(
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonMsgRecordDisplayImpl implements _CommonMsgRecordDisplay {
  _$CommonMsgRecordDisplayImpl({this.lang, this.content, this.link, this.name});

  factory _$CommonMsgRecordDisplayImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonMsgRecordDisplayImplFromJson(json);

  @override
  final String? lang;
  @override
  final String? content;
  @override
  final String? link;
  @override
  final String? name;

  @override
  String toString() {
    return 'CommonMsgRecordDisplay(lang: $lang, content: $content, link: $link, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonMsgRecordDisplayImpl &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, lang, content, link, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonMsgRecordDisplayImplCopyWith<_$CommonMsgRecordDisplayImpl>
      get copyWith => __$$CommonMsgRecordDisplayImplCopyWithImpl<
          _$CommonMsgRecordDisplayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonMsgRecordDisplayImplToJson(
      this,
    );
  }
}

abstract class _CommonMsgRecordDisplay implements CommonMsgRecordDisplay {
  factory _CommonMsgRecordDisplay(
      {final String? lang,
      final String? content,
      final String? link,
      final String? name}) = _$CommonMsgRecordDisplayImpl;

  factory _CommonMsgRecordDisplay.fromJson(Map<String, dynamic> json) =
      _$CommonMsgRecordDisplayImpl.fromJson;

  @override
  String? get lang;
  @override
  String? get content;
  @override
  String? get link;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$CommonMsgRecordDisplayImplCopyWith<_$CommonMsgRecordDisplayImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CommonMsgRecord _$CommonMsgRecordFromJson(Map<String, dynamic> json) {
  return _CommonMsgRecord.fromJson(json);
}

/// @nodoc
mixin _$CommonMsgRecord {
  String? get id => throw _privateConstructorUsedError;
  String? get multiLangDisplay => throw _privateConstructorUsedError;
  String? get msgCategory => throw _privateConstructorUsedError;
  String? get jumpType => throw _privateConstructorUsedError;
  int? get readStatus => throw _privateConstructorUsedError;
  String? get readTime => throw _privateConstructorUsedError;
  String? get createTime => throw _privateConstructorUsedError;
  String? get updateTime => throw _privateConstructorUsedError;
  String? get ext => throw _privateConstructorUsedError;
  CommonMsgRecordExt? get extBean => throw _privateConstructorUsedError;
  CommonMsgRecordDisplay? get display => throw _privateConstructorUsedError;
  String? get imgUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommonMsgRecordCopyWith<CommonMsgRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonMsgRecordCopyWith<$Res> {
  factory $CommonMsgRecordCopyWith(
          CommonMsgRecord value, $Res Function(CommonMsgRecord) then) =
      _$CommonMsgRecordCopyWithImpl<$Res, CommonMsgRecord>;
  @useResult
  $Res call(
      {String? id,
      String? multiLangDisplay,
      String? msgCategory,
      String? jumpType,
      int? readStatus,
      String? readTime,
      String? createTime,
      String? updateTime,
      String? ext,
      CommonMsgRecordExt? extBean,
      CommonMsgRecordDisplay? display,
      String? imgUrl});

  $CommonMsgRecordExtCopyWith<$Res>? get extBean;
  $CommonMsgRecordDisplayCopyWith<$Res>? get display;
}

/// @nodoc
class _$CommonMsgRecordCopyWithImpl<$Res, $Val extends CommonMsgRecord>
    implements $CommonMsgRecordCopyWith<$Res> {
  _$CommonMsgRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? multiLangDisplay = freezed,
    Object? msgCategory = freezed,
    Object? jumpType = freezed,
    Object? readStatus = freezed,
    Object? readTime = freezed,
    Object? createTime = freezed,
    Object? updateTime = freezed,
    Object? ext = freezed,
    Object? extBean = freezed,
    Object? display = freezed,
    Object? imgUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      multiLangDisplay: freezed == multiLangDisplay
          ? _value.multiLangDisplay
          : multiLangDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      msgCategory: freezed == msgCategory
          ? _value.msgCategory
          : msgCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      jumpType: freezed == jumpType
          ? _value.jumpType
          : jumpType // ignore: cast_nullable_to_non_nullable
              as String?,
      readStatus: freezed == readStatus
          ? _value.readStatus
          : readStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      readTime: freezed == readTime
          ? _value.readTime
          : readTime // ignore: cast_nullable_to_non_nullable
              as String?,
      createTime: freezed == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as String?,
      updateTime: freezed == updateTime
          ? _value.updateTime
          : updateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      ext: freezed == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String?,
      extBean: freezed == extBean
          ? _value.extBean
          : extBean // ignore: cast_nullable_to_non_nullable
              as CommonMsgRecordExt?,
      display: freezed == display
          ? _value.display
          : display // ignore: cast_nullable_to_non_nullable
              as CommonMsgRecordDisplay?,
      imgUrl: freezed == imgUrl
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CommonMsgRecordExtCopyWith<$Res>? get extBean {
    if (_value.extBean == null) {
      return null;
    }

    return $CommonMsgRecordExtCopyWith<$Res>(_value.extBean!, (value) {
      return _then(_value.copyWith(extBean: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $CommonMsgRecordDisplayCopyWith<$Res>? get display {
    if (_value.display == null) {
      return null;
    }

    return $CommonMsgRecordDisplayCopyWith<$Res>(_value.display!, (value) {
      return _then(_value.copyWith(display: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommonMsgRecordImplCopyWith<$Res>
    implements $CommonMsgRecordCopyWith<$Res> {
  factory _$$CommonMsgRecordImplCopyWith(_$CommonMsgRecordImpl value,
          $Res Function(_$CommonMsgRecordImpl) then) =
      __$$CommonMsgRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? multiLangDisplay,
      String? msgCategory,
      String? jumpType,
      int? readStatus,
      String? readTime,
      String? createTime,
      String? updateTime,
      String? ext,
      CommonMsgRecordExt? extBean,
      CommonMsgRecordDisplay? display,
      String? imgUrl});

  @override
  $CommonMsgRecordExtCopyWith<$Res>? get extBean;
  @override
  $CommonMsgRecordDisplayCopyWith<$Res>? get display;
}

/// @nodoc
class __$$CommonMsgRecordImplCopyWithImpl<$Res>
    extends _$CommonMsgRecordCopyWithImpl<$Res, _$CommonMsgRecordImpl>
    implements _$$CommonMsgRecordImplCopyWith<$Res> {
  __$$CommonMsgRecordImplCopyWithImpl(
      _$CommonMsgRecordImpl _value, $Res Function(_$CommonMsgRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? multiLangDisplay = freezed,
    Object? msgCategory = freezed,
    Object? jumpType = freezed,
    Object? readStatus = freezed,
    Object? readTime = freezed,
    Object? createTime = freezed,
    Object? updateTime = freezed,
    Object? ext = freezed,
    Object? extBean = freezed,
    Object? display = freezed,
    Object? imgUrl = freezed,
  }) {
    return _then(_$CommonMsgRecordImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      multiLangDisplay: freezed == multiLangDisplay
          ? _value.multiLangDisplay
          : multiLangDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      msgCategory: freezed == msgCategory
          ? _value.msgCategory
          : msgCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      jumpType: freezed == jumpType
          ? _value.jumpType
          : jumpType // ignore: cast_nullable_to_non_nullable
              as String?,
      readStatus: freezed == readStatus
          ? _value.readStatus
          : readStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      readTime: freezed == readTime
          ? _value.readTime
          : readTime // ignore: cast_nullable_to_non_nullable
              as String?,
      createTime: freezed == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as String?,
      updateTime: freezed == updateTime
          ? _value.updateTime
          : updateTime // ignore: cast_nullable_to_non_nullable
              as String?,
      ext: freezed == ext
          ? _value.ext
          : ext // ignore: cast_nullable_to_non_nullable
              as String?,
      extBean: freezed == extBean
          ? _value.extBean
          : extBean // ignore: cast_nullable_to_non_nullable
              as CommonMsgRecordExt?,
      display: freezed == display
          ? _value.display
          : display // ignore: cast_nullable_to_non_nullable
              as CommonMsgRecordDisplay?,
      imgUrl: freezed == imgUrl
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonMsgRecordImpl implements _CommonMsgRecord {
  _$CommonMsgRecordImpl(
      {this.id,
      this.multiLangDisplay,
      this.msgCategory,
      this.jumpType,
      this.readStatus,
      this.readTime,
      this.createTime,
      this.updateTime,
      this.ext,
      this.extBean,
      this.display,
      this.imgUrl});

  factory _$CommonMsgRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonMsgRecordImplFromJson(json);

  @override
  final String? id;
  @override
  final String? multiLangDisplay;
  @override
  final String? msgCategory;
  @override
  final String? jumpType;
  @override
  final int? readStatus;
  @override
  final String? readTime;
  @override
  final String? createTime;
  @override
  final String? updateTime;
  @override
  final String? ext;
  @override
  final CommonMsgRecordExt? extBean;
  @override
  final CommonMsgRecordDisplay? display;
  @override
  final String? imgUrl;

  @override
  String toString() {
    return 'CommonMsgRecord(id: $id, multiLangDisplay: $multiLangDisplay, msgCategory: $msgCategory, jumpType: $jumpType, readStatus: $readStatus, readTime: $readTime, createTime: $createTime, updateTime: $updateTime, ext: $ext, extBean: $extBean, display: $display, imgUrl: $imgUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonMsgRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.multiLangDisplay, multiLangDisplay) ||
                other.multiLangDisplay == multiLangDisplay) &&
            (identical(other.msgCategory, msgCategory) ||
                other.msgCategory == msgCategory) &&
            (identical(other.jumpType, jumpType) ||
                other.jumpType == jumpType) &&
            (identical(other.readStatus, readStatus) ||
                other.readStatus == readStatus) &&
            (identical(other.readTime, readTime) ||
                other.readTime == readTime) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.updateTime, updateTime) ||
                other.updateTime == updateTime) &&
            (identical(other.ext, ext) || other.ext == ext) &&
            (identical(other.extBean, extBean) || other.extBean == extBean) &&
            (identical(other.display, display) || other.display == display) &&
            (identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      multiLangDisplay,
      msgCategory,
      jumpType,
      readStatus,
      readTime,
      createTime,
      updateTime,
      ext,
      extBean,
      display,
      imgUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonMsgRecordImplCopyWith<_$CommonMsgRecordImpl> get copyWith =>
      __$$CommonMsgRecordImplCopyWithImpl<_$CommonMsgRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonMsgRecordImplToJson(
      this,
    );
  }
}

abstract class _CommonMsgRecord implements CommonMsgRecord {
  factory _CommonMsgRecord(
      {final String? id,
      final String? multiLangDisplay,
      final String? msgCategory,
      final String? jumpType,
      final int? readStatus,
      final String? readTime,
      final String? createTime,
      final String? updateTime,
      final String? ext,
      final CommonMsgRecordExt? extBean,
      final CommonMsgRecordDisplay? display,
      final String? imgUrl}) = _$CommonMsgRecordImpl;

  factory _CommonMsgRecord.fromJson(Map<String, dynamic> json) =
      _$CommonMsgRecordImpl.fromJson;

  @override
  String? get id;
  @override
  String? get multiLangDisplay;
  @override
  String? get msgCategory;
  @override
  String? get jumpType;
  @override
  int? get readStatus;
  @override
  String? get readTime;
  @override
  String? get createTime;
  @override
  String? get updateTime;
  @override
  String? get ext;
  @override
  CommonMsgRecordExt? get extBean;
  @override
  CommonMsgRecordDisplay? get display;
  @override
  String? get imgUrl;
  @override
  @JsonKey(ignore: true)
  _$$CommonMsgRecordImplCopyWith<_$CommonMsgRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommonMsgRecordRes _$CommonMsgRecordResFromJson(Map<String, dynamic> json) {
  return _CommonMsgRecordRes.fromJson(json);
}

/// @nodoc
mixin _$CommonMsgRecordRes {
  List<CommonMsgRecord>? get records => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommonMsgRecordResCopyWith<CommonMsgRecordRes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonMsgRecordResCopyWith<$Res> {
  factory $CommonMsgRecordResCopyWith(
          CommonMsgRecordRes value, $Res Function(CommonMsgRecordRes) then) =
      _$CommonMsgRecordResCopyWithImpl<$Res, CommonMsgRecordRes>;
  @useResult
  $Res call({List<CommonMsgRecord>? records});
}

/// @nodoc
class _$CommonMsgRecordResCopyWithImpl<$Res, $Val extends CommonMsgRecordRes>
    implements $CommonMsgRecordResCopyWith<$Res> {
  _$CommonMsgRecordResCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = freezed,
  }) {
    return _then(_value.copyWith(
      records: freezed == records
          ? _value.records
          : records // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonMsgRecordResImplCopyWith<$Res>
    implements $CommonMsgRecordResCopyWith<$Res> {
  factory _$$CommonMsgRecordResImplCopyWith(_$CommonMsgRecordResImpl value,
          $Res Function(_$CommonMsgRecordResImpl) then) =
      __$$CommonMsgRecordResImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CommonMsgRecord>? records});
}

/// @nodoc
class __$$CommonMsgRecordResImplCopyWithImpl<$Res>
    extends _$CommonMsgRecordResCopyWithImpl<$Res, _$CommonMsgRecordResImpl>
    implements _$$CommonMsgRecordResImplCopyWith<$Res> {
  __$$CommonMsgRecordResImplCopyWithImpl(_$CommonMsgRecordResImpl _value,
      $Res Function(_$CommonMsgRecordResImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? records = freezed,
  }) {
    return _then(_$CommonMsgRecordResImpl(
      freezed == records
          ? _value._records
          : records // ignore: cast_nullable_to_non_nullable
              as List<CommonMsgRecord>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonMsgRecordResImpl implements _CommonMsgRecordRes {
  _$CommonMsgRecordResImpl(final List<CommonMsgRecord>? records)
      : _records = records;

  factory _$CommonMsgRecordResImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonMsgRecordResImplFromJson(json);

  final List<CommonMsgRecord>? _records;
  @override
  List<CommonMsgRecord>? get records {
    final value = _records;
    if (value == null) return null;
    if (_records is EqualUnmodifiableListView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CommonMsgRecordRes(records: $records)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonMsgRecordResImpl &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_records));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonMsgRecordResImplCopyWith<_$CommonMsgRecordResImpl> get copyWith =>
      __$$CommonMsgRecordResImplCopyWithImpl<_$CommonMsgRecordResImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonMsgRecordResImplToJson(
      this,
    );
  }
}

abstract class _CommonMsgRecordRes implements CommonMsgRecordRes {
  factory _CommonMsgRecordRes(final List<CommonMsgRecord>? records) =
      _$CommonMsgRecordResImpl;

  factory _CommonMsgRecordRes.fromJson(Map<String, dynamic> json) =
      _$CommonMsgRecordResImpl.fromJson;

  @override
  List<CommonMsgRecord>? get records;
  @override
  @JsonKey(ignore: true)
  _$$CommonMsgRecordResImplCopyWith<_$CommonMsgRecordResImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
