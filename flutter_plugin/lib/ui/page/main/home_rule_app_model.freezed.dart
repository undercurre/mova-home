// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_rule_app_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomeRuleAppModel _$HomeRuleAppModelFromJson(Map<String, dynamic> json) {
  return _HomeRuleAppModel.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppModel {
  @JsonKey(name: 'appButtomRule_mova')
  HomeRuleAppButtomRuleMova? get appButtomRuleMova =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppModelCopyWith<HomeRuleAppModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppModelCopyWith<$Res> {
  factory $HomeRuleAppModelCopyWith(
          HomeRuleAppModel value, $Res Function(HomeRuleAppModel) then) =
      _$HomeRuleAppModelCopyWithImpl<$Res, HomeRuleAppModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'appButtomRule_mova')
      HomeRuleAppButtomRuleMova? appButtomRuleMova});

  $HomeRuleAppButtomRuleMovaCopyWith<$Res>? get appButtomRuleMova;
}

/// @nodoc
class _$HomeRuleAppModelCopyWithImpl<$Res, $Val extends HomeRuleAppModel>
    implements $HomeRuleAppModelCopyWith<$Res> {
  _$HomeRuleAppModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appButtomRuleMova = freezed,
  }) {
    return _then(_value.copyWith(
      appButtomRuleMova: freezed == appButtomRuleMova
          ? _value.appButtomRuleMova
          : appButtomRuleMova // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppButtomRuleMova?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeRuleAppButtomRuleMovaCopyWith<$Res>? get appButtomRuleMova {
    if (_value.appButtomRuleMova == null) {
      return null;
    }

    return $HomeRuleAppButtomRuleMovaCopyWith<$Res>(_value.appButtomRuleMova!,
        (value) {
      return _then(_value.copyWith(appButtomRuleMova: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeRuleAppModelImplCopyWith<$Res>
    implements $HomeRuleAppModelCopyWith<$Res> {
  factory _$$HomeRuleAppModelImplCopyWith(_$HomeRuleAppModelImpl value,
          $Res Function(_$HomeRuleAppModelImpl) then) =
      __$$HomeRuleAppModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'appButtomRule_mova')
      HomeRuleAppButtomRuleMova? appButtomRuleMova});

  @override
  $HomeRuleAppButtomRuleMovaCopyWith<$Res>? get appButtomRuleMova;
}

/// @nodoc
class __$$HomeRuleAppModelImplCopyWithImpl<$Res>
    extends _$HomeRuleAppModelCopyWithImpl<$Res, _$HomeRuleAppModelImpl>
    implements _$$HomeRuleAppModelImplCopyWith<$Res> {
  __$$HomeRuleAppModelImplCopyWithImpl(_$HomeRuleAppModelImpl _value,
      $Res Function(_$HomeRuleAppModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appButtomRuleMova = freezed,
  }) {
    return _then(_$HomeRuleAppModelImpl(
      appButtomRuleMova: freezed == appButtomRuleMova
          ? _value.appButtomRuleMova
          : appButtomRuleMova // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppButtomRuleMova?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppModelImpl implements _HomeRuleAppModel {
  const _$HomeRuleAppModelImpl(
      {@JsonKey(name: 'appButtomRule_mova') this.appButtomRuleMova});

  factory _$HomeRuleAppModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppModelImplFromJson(json);

  @override
  @JsonKey(name: 'appButtomRule_mova')
  final HomeRuleAppButtomRuleMova? appButtomRuleMova;

  @override
  String toString() {
    return 'HomeRuleAppModel(appButtomRuleMova: $appButtomRuleMova)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppModelImpl &&
            (identical(other.appButtomRuleMova, appButtomRuleMova) ||
                other.appButtomRuleMova == appButtomRuleMova));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, appButtomRuleMova);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppModelImplCopyWith<_$HomeRuleAppModelImpl> get copyWith =>
      __$$HomeRuleAppModelImplCopyWithImpl<_$HomeRuleAppModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppModelImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppModel implements HomeRuleAppModel {
  const factory _HomeRuleAppModel(
          {@JsonKey(name: 'appButtomRule_mova')
          final HomeRuleAppButtomRuleMova? appButtomRuleMova}) =
      _$HomeRuleAppModelImpl;

  factory _HomeRuleAppModel.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppModelImpl.fromJson;

  @override
  @JsonKey(name: 'appButtomRule_mova')
  HomeRuleAppButtomRuleMova? get appButtomRuleMova;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppModelImplCopyWith<_$HomeRuleAppModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeRuleAppButtomRuleMova _$HomeRuleAppButtomRuleMovaFromJson(
    Map<String, dynamic> json) {
  return _HomeRuleAppButtomRuleMova.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppButtomRuleMova {
  List<HomeRuleAppTabItem> get tabList => throw _privateConstructorUsedError;
  int get defaultIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppButtomRuleMovaCopyWith<HomeRuleAppButtomRuleMova> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppButtomRuleMovaCopyWith<$Res> {
  factory $HomeRuleAppButtomRuleMovaCopyWith(HomeRuleAppButtomRuleMova value,
          $Res Function(HomeRuleAppButtomRuleMova) then) =
      _$HomeRuleAppButtomRuleMovaCopyWithImpl<$Res, HomeRuleAppButtomRuleMova>;
  @useResult
  $Res call({List<HomeRuleAppTabItem> tabList, int defaultIndex});
}

/// @nodoc
class _$HomeRuleAppButtomRuleMovaCopyWithImpl<$Res,
        $Val extends HomeRuleAppButtomRuleMova>
    implements $HomeRuleAppButtomRuleMovaCopyWith<$Res> {
  _$HomeRuleAppButtomRuleMovaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabList = null,
    Object? defaultIndex = null,
  }) {
    return _then(_value.copyWith(
      tabList: null == tabList
          ? _value.tabList
          : tabList // ignore: cast_nullable_to_non_nullable
              as List<HomeRuleAppTabItem>,
      defaultIndex: null == defaultIndex
          ? _value.defaultIndex
          : defaultIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeRuleAppButtomRuleMovaImplCopyWith<$Res>
    implements $HomeRuleAppButtomRuleMovaCopyWith<$Res> {
  factory _$$HomeRuleAppButtomRuleMovaImplCopyWith(
          _$HomeRuleAppButtomRuleMovaImpl value,
          $Res Function(_$HomeRuleAppButtomRuleMovaImpl) then) =
      __$$HomeRuleAppButtomRuleMovaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<HomeRuleAppTabItem> tabList, int defaultIndex});
}

/// @nodoc
class __$$HomeRuleAppButtomRuleMovaImplCopyWithImpl<$Res>
    extends _$HomeRuleAppButtomRuleMovaCopyWithImpl<$Res,
        _$HomeRuleAppButtomRuleMovaImpl>
    implements _$$HomeRuleAppButtomRuleMovaImplCopyWith<$Res> {
  __$$HomeRuleAppButtomRuleMovaImplCopyWithImpl(
      _$HomeRuleAppButtomRuleMovaImpl _value,
      $Res Function(_$HomeRuleAppButtomRuleMovaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tabList = null,
    Object? defaultIndex = null,
  }) {
    return _then(_$HomeRuleAppButtomRuleMovaImpl(
      tabList: null == tabList
          ? _value._tabList
          : tabList // ignore: cast_nullable_to_non_nullable
              as List<HomeRuleAppTabItem>,
      defaultIndex: null == defaultIndex
          ? _value.defaultIndex
          : defaultIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppButtomRuleMovaImpl implements _HomeRuleAppButtomRuleMova {
  const _$HomeRuleAppButtomRuleMovaImpl(
      {final List<HomeRuleAppTabItem> tabList = const [],
      this.defaultIndex = 0})
      : _tabList = tabList;

  factory _$HomeRuleAppButtomRuleMovaImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppButtomRuleMovaImplFromJson(json);

  final List<HomeRuleAppTabItem> _tabList;
  @override
  @JsonKey()
  List<HomeRuleAppTabItem> get tabList {
    if (_tabList is EqualUnmodifiableListView) return _tabList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tabList);
  }

  @override
  @JsonKey()
  final int defaultIndex;

  @override
  String toString() {
    return 'HomeRuleAppButtomRuleMova(tabList: $tabList, defaultIndex: $defaultIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppButtomRuleMovaImpl &&
            const DeepCollectionEquality().equals(other._tabList, _tabList) &&
            (identical(other.defaultIndex, defaultIndex) ||
                other.defaultIndex == defaultIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_tabList), defaultIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppButtomRuleMovaImplCopyWith<_$HomeRuleAppButtomRuleMovaImpl>
      get copyWith => __$$HomeRuleAppButtomRuleMovaImplCopyWithImpl<
          _$HomeRuleAppButtomRuleMovaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppButtomRuleMovaImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppButtomRuleMova implements HomeRuleAppButtomRuleMova {
  const factory _HomeRuleAppButtomRuleMova(
      {final List<HomeRuleAppTabItem> tabList,
      final int defaultIndex}) = _$HomeRuleAppButtomRuleMovaImpl;

  factory _HomeRuleAppButtomRuleMova.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppButtomRuleMovaImpl.fromJson;

  @override
  List<HomeRuleAppTabItem> get tabList;
  @override
  int get defaultIndex;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppButtomRuleMovaImplCopyWith<_$HomeRuleAppButtomRuleMovaImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HomeRuleAppTabItem _$HomeRuleAppTabItemFromJson(Map<String, dynamic> json) {
  return _HomeRuleAppTabItem.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppTabItem {
  String get path => throw _privateConstructorUsedError;
  HomeRuleAppBadge? get badge => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  String get tabType => throw _privateConstructorUsedError;
  HomeRuleAppStyle get style => throw _privateConstructorUsedError;
  HomeRuleAppParams? get params => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppTabItemCopyWith<HomeRuleAppTabItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppTabItemCopyWith<$Res> {
  factory $HomeRuleAppTabItemCopyWith(
          HomeRuleAppTabItem value, $Res Function(HomeRuleAppTabItem) then) =
      _$HomeRuleAppTabItemCopyWithImpl<$Res, HomeRuleAppTabItem>;
  @useResult
  $Res call(
      {String path,
      HomeRuleAppBadge? badge,
      int index,
      String tabType,
      HomeRuleAppStyle style,
      HomeRuleAppParams? params});

  $HomeRuleAppBadgeCopyWith<$Res>? get badge;
  $HomeRuleAppStyleCopyWith<$Res> get style;
  $HomeRuleAppParamsCopyWith<$Res>? get params;
}

/// @nodoc
class _$HomeRuleAppTabItemCopyWithImpl<$Res, $Val extends HomeRuleAppTabItem>
    implements $HomeRuleAppTabItemCopyWith<$Res> {
  _$HomeRuleAppTabItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? badge = freezed,
    Object? index = null,
    Object? tabType = null,
    Object? style = null,
    Object? params = freezed,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      badge: freezed == badge
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppBadge?,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      tabType: null == tabType
          ? _value.tabType
          : tabType // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppStyle,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppParams?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeRuleAppBadgeCopyWith<$Res>? get badge {
    if (_value.badge == null) {
      return null;
    }

    return $HomeRuleAppBadgeCopyWith<$Res>(_value.badge!, (value) {
      return _then(_value.copyWith(badge: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeRuleAppStyleCopyWith<$Res> get style {
    return $HomeRuleAppStyleCopyWith<$Res>(_value.style, (value) {
      return _then(_value.copyWith(style: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeRuleAppParamsCopyWith<$Res>? get params {
    if (_value.params == null) {
      return null;
    }

    return $HomeRuleAppParamsCopyWith<$Res>(_value.params!, (value) {
      return _then(_value.copyWith(params: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeRuleAppTabItemImplCopyWith<$Res>
    implements $HomeRuleAppTabItemCopyWith<$Res> {
  factory _$$HomeRuleAppTabItemImplCopyWith(_$HomeRuleAppTabItemImpl value,
          $Res Function(_$HomeRuleAppTabItemImpl) then) =
      __$$HomeRuleAppTabItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String path,
      HomeRuleAppBadge? badge,
      int index,
      String tabType,
      HomeRuleAppStyle style,
      HomeRuleAppParams? params});

  @override
  $HomeRuleAppBadgeCopyWith<$Res>? get badge;
  @override
  $HomeRuleAppStyleCopyWith<$Res> get style;
  @override
  $HomeRuleAppParamsCopyWith<$Res>? get params;
}

/// @nodoc
class __$$HomeRuleAppTabItemImplCopyWithImpl<$Res>
    extends _$HomeRuleAppTabItemCopyWithImpl<$Res, _$HomeRuleAppTabItemImpl>
    implements _$$HomeRuleAppTabItemImplCopyWith<$Res> {
  __$$HomeRuleAppTabItemImplCopyWithImpl(_$HomeRuleAppTabItemImpl _value,
      $Res Function(_$HomeRuleAppTabItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? badge = freezed,
    Object? index = null,
    Object? tabType = null,
    Object? style = null,
    Object? params = freezed,
  }) {
    return _then(_$HomeRuleAppTabItemImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      badge: freezed == badge
          ? _value.badge
          : badge // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppBadge?,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      tabType: null == tabType
          ? _value.tabType
          : tabType // ignore: cast_nullable_to_non_nullable
              as String,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppStyle,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppParams?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppTabItemImpl implements _HomeRuleAppTabItem {
  const _$HomeRuleAppTabItemImpl(
      {this.path = '',
      this.badge,
      this.index = 0,
      this.tabType = '',
      required this.style,
      this.params});

  factory _$HomeRuleAppTabItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppTabItemImplFromJson(json);

  @override
  @JsonKey()
  final String path;
  @override
  final HomeRuleAppBadge? badge;
  @override
  @JsonKey()
  final int index;
  @override
  @JsonKey()
  final String tabType;
  @override
  final HomeRuleAppStyle style;
  @override
  final HomeRuleAppParams? params;

  @override
  String toString() {
    return 'HomeRuleAppTabItem(path: $path, badge: $badge, index: $index, tabType: $tabType, style: $style, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppTabItemImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.badge, badge) || other.badge == badge) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.tabType, tabType) || other.tabType == tabType) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.params, params) || other.params == params));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, path, badge, index, tabType, style, params);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppTabItemImplCopyWith<_$HomeRuleAppTabItemImpl> get copyWith =>
      __$$HomeRuleAppTabItemImplCopyWithImpl<_$HomeRuleAppTabItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppTabItemImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppTabItem implements HomeRuleAppTabItem {
  const factory _HomeRuleAppTabItem(
      {final String path,
      final HomeRuleAppBadge? badge,
      final int index,
      final String tabType,
      required final HomeRuleAppStyle style,
      final HomeRuleAppParams? params}) = _$HomeRuleAppTabItemImpl;

  factory _HomeRuleAppTabItem.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppTabItemImpl.fromJson;

  @override
  String get path;
  @override
  HomeRuleAppBadge? get badge;
  @override
  int get index;
  @override
  String get tabType;
  @override
  HomeRuleAppStyle get style;
  @override
  HomeRuleAppParams? get params;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppTabItemImplCopyWith<_$HomeRuleAppTabItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeRuleAppBadge _$HomeRuleAppBadgeFromJson(Map<String, dynamic> json) {
  return _HomeRuleAppBadge.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppBadge {
  String? get bgColor => throw _privateConstructorUsedError;
  bool? get dot => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  String? get textColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppBadgeCopyWith<HomeRuleAppBadge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppBadgeCopyWith<$Res> {
  factory $HomeRuleAppBadgeCopyWith(
          HomeRuleAppBadge value, $Res Function(HomeRuleAppBadge) then) =
      _$HomeRuleAppBadgeCopyWithImpl<$Res, HomeRuleAppBadge>;
  @useResult
  $Res call({String? bgColor, bool? dot, String? text, String? textColor});
}

/// @nodoc
class _$HomeRuleAppBadgeCopyWithImpl<$Res, $Val extends HomeRuleAppBadge>
    implements $HomeRuleAppBadgeCopyWith<$Res> {
  _$HomeRuleAppBadgeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bgColor = freezed,
    Object? dot = freezed,
    Object? text = freezed,
    Object? textColor = freezed,
  }) {
    return _then(_value.copyWith(
      bgColor: freezed == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String?,
      dot: freezed == dot
          ? _value.dot
          : dot // ignore: cast_nullable_to_non_nullable
              as bool?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      textColor: freezed == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeRuleAppBadgeImplCopyWith<$Res>
    implements $HomeRuleAppBadgeCopyWith<$Res> {
  factory _$$HomeRuleAppBadgeImplCopyWith(_$HomeRuleAppBadgeImpl value,
          $Res Function(_$HomeRuleAppBadgeImpl) then) =
      __$$HomeRuleAppBadgeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? bgColor, bool? dot, String? text, String? textColor});
}

/// @nodoc
class __$$HomeRuleAppBadgeImplCopyWithImpl<$Res>
    extends _$HomeRuleAppBadgeCopyWithImpl<$Res, _$HomeRuleAppBadgeImpl>
    implements _$$HomeRuleAppBadgeImplCopyWith<$Res> {
  __$$HomeRuleAppBadgeImplCopyWithImpl(_$HomeRuleAppBadgeImpl _value,
      $Res Function(_$HomeRuleAppBadgeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bgColor = freezed,
    Object? dot = freezed,
    Object? text = freezed,
    Object? textColor = freezed,
  }) {
    return _then(_$HomeRuleAppBadgeImpl(
      bgColor: freezed == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String?,
      dot: freezed == dot
          ? _value.dot
          : dot // ignore: cast_nullable_to_non_nullable
              as bool?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      textColor: freezed == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppBadgeImpl implements _HomeRuleAppBadge {
  const _$HomeRuleAppBadgeImpl(
      {this.bgColor, this.dot, this.text, this.textColor});

  factory _$HomeRuleAppBadgeImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppBadgeImplFromJson(json);

  @override
  final String? bgColor;
  @override
  final bool? dot;
  @override
  final String? text;
  @override
  final String? textColor;

  @override
  String toString() {
    return 'HomeRuleAppBadge(bgColor: $bgColor, dot: $dot, text: $text, textColor: $textColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppBadgeImpl &&
            (identical(other.bgColor, bgColor) || other.bgColor == bgColor) &&
            (identical(other.dot, dot) || other.dot == dot) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, bgColor, dot, text, textColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppBadgeImplCopyWith<_$HomeRuleAppBadgeImpl> get copyWith =>
      __$$HomeRuleAppBadgeImplCopyWithImpl<_$HomeRuleAppBadgeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppBadgeImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppBadge implements HomeRuleAppBadge {
  const factory _HomeRuleAppBadge(
      {final String? bgColor,
      final bool? dot,
      final String? text,
      final String? textColor}) = _$HomeRuleAppBadgeImpl;

  factory _HomeRuleAppBadge.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppBadgeImpl.fromJson;

  @override
  String? get bgColor;
  @override
  bool? get dot;
  @override
  String? get text;
  @override
  String? get textColor;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppBadgeImplCopyWith<_$HomeRuleAppBadgeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeRuleAppStyle _$HomeRuleAppStyleFromJson(Map<String, dynamic> json) {
  return _HomeRuleAppStyle.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppStyle {
  HomeRuleAppStyleItem? get normal => throw _privateConstructorUsedError;
  String? get lottie => throw _privateConstructorUsedError;
  HomeRuleAppStyleItem? get selected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppStyleCopyWith<HomeRuleAppStyle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppStyleCopyWith<$Res> {
  factory $HomeRuleAppStyleCopyWith(
          HomeRuleAppStyle value, $Res Function(HomeRuleAppStyle) then) =
      _$HomeRuleAppStyleCopyWithImpl<$Res, HomeRuleAppStyle>;
  @useResult
  $Res call(
      {HomeRuleAppStyleItem? normal,
      String? lottie,
      HomeRuleAppStyleItem? selected});

  $HomeRuleAppStyleItemCopyWith<$Res>? get normal;
  $HomeRuleAppStyleItemCopyWith<$Res>? get selected;
}

/// @nodoc
class _$HomeRuleAppStyleCopyWithImpl<$Res, $Val extends HomeRuleAppStyle>
    implements $HomeRuleAppStyleCopyWith<$Res> {
  _$HomeRuleAppStyleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? normal = freezed,
    Object? lottie = freezed,
    Object? selected = freezed,
  }) {
    return _then(_value.copyWith(
      normal: freezed == normal
          ? _value.normal
          : normal // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppStyleItem?,
      lottie: freezed == lottie
          ? _value.lottie
          : lottie // ignore: cast_nullable_to_non_nullable
              as String?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppStyleItem?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeRuleAppStyleItemCopyWith<$Res>? get normal {
    if (_value.normal == null) {
      return null;
    }

    return $HomeRuleAppStyleItemCopyWith<$Res>(_value.normal!, (value) {
      return _then(_value.copyWith(normal: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HomeRuleAppStyleItemCopyWith<$Res>? get selected {
    if (_value.selected == null) {
      return null;
    }

    return $HomeRuleAppStyleItemCopyWith<$Res>(_value.selected!, (value) {
      return _then(_value.copyWith(selected: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeRuleAppStyleImplCopyWith<$Res>
    implements $HomeRuleAppStyleCopyWith<$Res> {
  factory _$$HomeRuleAppStyleImplCopyWith(_$HomeRuleAppStyleImpl value,
          $Res Function(_$HomeRuleAppStyleImpl) then) =
      __$$HomeRuleAppStyleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HomeRuleAppStyleItem? normal,
      String? lottie,
      HomeRuleAppStyleItem? selected});

  @override
  $HomeRuleAppStyleItemCopyWith<$Res>? get normal;
  @override
  $HomeRuleAppStyleItemCopyWith<$Res>? get selected;
}

/// @nodoc
class __$$HomeRuleAppStyleImplCopyWithImpl<$Res>
    extends _$HomeRuleAppStyleCopyWithImpl<$Res, _$HomeRuleAppStyleImpl>
    implements _$$HomeRuleAppStyleImplCopyWith<$Res> {
  __$$HomeRuleAppStyleImplCopyWithImpl(_$HomeRuleAppStyleImpl _value,
      $Res Function(_$HomeRuleAppStyleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? normal = freezed,
    Object? lottie = freezed,
    Object? selected = freezed,
  }) {
    return _then(_$HomeRuleAppStyleImpl(
      normal: freezed == normal
          ? _value.normal
          : normal // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppStyleItem?,
      lottie: freezed == lottie
          ? _value.lottie
          : lottie // ignore: cast_nullable_to_non_nullable
              as String?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as HomeRuleAppStyleItem?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppStyleImpl implements _HomeRuleAppStyle {
  const _$HomeRuleAppStyleImpl({this.normal, this.lottie, this.selected});

  factory _$HomeRuleAppStyleImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppStyleImplFromJson(json);

  @override
  final HomeRuleAppStyleItem? normal;
  @override
  final String? lottie;
  @override
  final HomeRuleAppStyleItem? selected;

  @override
  String toString() {
    return 'HomeRuleAppStyle(normal: $normal, lottie: $lottie, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppStyleImpl &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.lottie, lottie) || other.lottie == lottie) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, normal, lottie, selected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppStyleImplCopyWith<_$HomeRuleAppStyleImpl> get copyWith =>
      __$$HomeRuleAppStyleImplCopyWithImpl<_$HomeRuleAppStyleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppStyleImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppStyle implements HomeRuleAppStyle {
  const factory _HomeRuleAppStyle(
      {final HomeRuleAppStyleItem? normal,
      final String? lottie,
      final HomeRuleAppStyleItem? selected}) = _$HomeRuleAppStyleImpl;

  factory _HomeRuleAppStyle.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppStyleImpl.fromJson;

  @override
  HomeRuleAppStyleItem? get normal;
  @override
  String? get lottie;
  @override
  HomeRuleAppStyleItem? get selected;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppStyleImplCopyWith<_$HomeRuleAppStyleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeRuleAppParams _$HomeRuleAppParamsFromJson(Map<String, dynamic> json) {
  return _HomeRuleAppParams.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppParams {
  String? get params2 => throw _privateConstructorUsedError;
  String? get params1 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppParamsCopyWith<HomeRuleAppParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppParamsCopyWith<$Res> {
  factory $HomeRuleAppParamsCopyWith(
          HomeRuleAppParams value, $Res Function(HomeRuleAppParams) then) =
      _$HomeRuleAppParamsCopyWithImpl<$Res, HomeRuleAppParams>;
  @useResult
  $Res call({String? params2, String? params1});
}

/// @nodoc
class _$HomeRuleAppParamsCopyWithImpl<$Res, $Val extends HomeRuleAppParams>
    implements $HomeRuleAppParamsCopyWith<$Res> {
  _$HomeRuleAppParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? params2 = freezed,
    Object? params1 = freezed,
  }) {
    return _then(_value.copyWith(
      params2: freezed == params2
          ? _value.params2
          : params2 // ignore: cast_nullable_to_non_nullable
              as String?,
      params1: freezed == params1
          ? _value.params1
          : params1 // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeRuleAppParamsImplCopyWith<$Res>
    implements $HomeRuleAppParamsCopyWith<$Res> {
  factory _$$HomeRuleAppParamsImplCopyWith(_$HomeRuleAppParamsImpl value,
          $Res Function(_$HomeRuleAppParamsImpl) then) =
      __$$HomeRuleAppParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? params2, String? params1});
}

/// @nodoc
class __$$HomeRuleAppParamsImplCopyWithImpl<$Res>
    extends _$HomeRuleAppParamsCopyWithImpl<$Res, _$HomeRuleAppParamsImpl>
    implements _$$HomeRuleAppParamsImplCopyWith<$Res> {
  __$$HomeRuleAppParamsImplCopyWithImpl(_$HomeRuleAppParamsImpl _value,
      $Res Function(_$HomeRuleAppParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? params2 = freezed,
    Object? params1 = freezed,
  }) {
    return _then(_$HomeRuleAppParamsImpl(
      params2: freezed == params2
          ? _value.params2
          : params2 // ignore: cast_nullable_to_non_nullable
              as String?,
      params1: freezed == params1
          ? _value.params1
          : params1 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppParamsImpl implements _HomeRuleAppParams {
  const _$HomeRuleAppParamsImpl({this.params2, this.params1});

  factory _$HomeRuleAppParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppParamsImplFromJson(json);

  @override
  final String? params2;
  @override
  final String? params1;

  @override
  String toString() {
    return 'HomeRuleAppParams(params2: $params2, params1: $params1)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppParamsImpl &&
            (identical(other.params2, params2) || other.params2 == params2) &&
            (identical(other.params1, params1) || other.params1 == params1));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, params2, params1);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppParamsImplCopyWith<_$HomeRuleAppParamsImpl> get copyWith =>
      __$$HomeRuleAppParamsImplCopyWithImpl<_$HomeRuleAppParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppParamsImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppParams implements HomeRuleAppParams {
  const factory _HomeRuleAppParams(
      {final String? params2, final String? params1}) = _$HomeRuleAppParamsImpl;

  factory _HomeRuleAppParams.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppParamsImpl.fromJson;

  @override
  String? get params2;
  @override
  String? get params1;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppParamsImplCopyWith<_$HomeRuleAppParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeRuleAppStyleItem _$HomeRuleAppStyleItemFromJson(Map<String, dynamic> json) {
  return _HomeRuleAppStyleItem.fromJson(json);
}

/// @nodoc
mixin _$HomeRuleAppStyleItem {
  String? get icon => throw _privateConstructorUsedError;
  String? get dark_icon => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get textColor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomeRuleAppStyleItemCopyWith<HomeRuleAppStyleItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeRuleAppStyleItemCopyWith<$Res> {
  factory $HomeRuleAppStyleItemCopyWith(HomeRuleAppStyleItem value,
          $Res Function(HomeRuleAppStyleItem) then) =
      _$HomeRuleAppStyleItemCopyWithImpl<$Res, HomeRuleAppStyleItem>;
  @useResult
  $Res call({String? icon, String? dark_icon, String text, String textColor});
}

/// @nodoc
class _$HomeRuleAppStyleItemCopyWithImpl<$Res,
        $Val extends HomeRuleAppStyleItem>
    implements $HomeRuleAppStyleItemCopyWith<$Res> {
  _$HomeRuleAppStyleItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = freezed,
    Object? dark_icon = freezed,
    Object? text = null,
    Object? textColor = null,
  }) {
    return _then(_value.copyWith(
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      dark_icon: freezed == dark_icon
          ? _value.dark_icon
          : dark_icon // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      textColor: null == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeRuleAppStyleItemImplCopyWith<$Res>
    implements $HomeRuleAppStyleItemCopyWith<$Res> {
  factory _$$HomeRuleAppStyleItemImplCopyWith(_$HomeRuleAppStyleItemImpl value,
          $Res Function(_$HomeRuleAppStyleItemImpl) then) =
      __$$HomeRuleAppStyleItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? icon, String? dark_icon, String text, String textColor});
}

/// @nodoc
class __$$HomeRuleAppStyleItemImplCopyWithImpl<$Res>
    extends _$HomeRuleAppStyleItemCopyWithImpl<$Res, _$HomeRuleAppStyleItemImpl>
    implements _$$HomeRuleAppStyleItemImplCopyWith<$Res> {
  __$$HomeRuleAppStyleItemImplCopyWithImpl(_$HomeRuleAppStyleItemImpl _value,
      $Res Function(_$HomeRuleAppStyleItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = freezed,
    Object? dark_icon = freezed,
    Object? text = null,
    Object? textColor = null,
  }) {
    return _then(_$HomeRuleAppStyleItemImpl(
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      dark_icon: freezed == dark_icon
          ? _value.dark_icon
          : dark_icon // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      textColor: null == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeRuleAppStyleItemImpl implements _HomeRuleAppStyleItem {
  const _$HomeRuleAppStyleItemImpl(
      {this.icon, this.dark_icon, this.text = '', this.textColor = '#000000'});

  factory _$HomeRuleAppStyleItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeRuleAppStyleItemImplFromJson(json);

  @override
  final String? icon;
  @override
  final String? dark_icon;
  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String textColor;

  @override
  String toString() {
    return 'HomeRuleAppStyleItem(icon: $icon, dark_icon: $dark_icon, text: $text, textColor: $textColor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeRuleAppStyleItemImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.dark_icon, dark_icon) ||
                other.dark_icon == dark_icon) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, icon, dark_icon, text, textColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeRuleAppStyleItemImplCopyWith<_$HomeRuleAppStyleItemImpl>
      get copyWith =>
          __$$HomeRuleAppStyleItemImplCopyWithImpl<_$HomeRuleAppStyleItemImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeRuleAppStyleItemImplToJson(
      this,
    );
  }
}

abstract class _HomeRuleAppStyleItem implements HomeRuleAppStyleItem {
  const factory _HomeRuleAppStyleItem(
      {final String? icon,
      final String? dark_icon,
      final String text,
      final String textColor}) = _$HomeRuleAppStyleItemImpl;

  factory _HomeRuleAppStyleItem.fromJson(Map<String, dynamic> json) =
      _$HomeRuleAppStyleItemImpl.fromJson;

  @override
  String? get icon;
  @override
  String? get dark_icon;
  @override
  String get text;
  @override
  String get textColor;
  @override
  @JsonKey(ignore: true)
  _$$HomeRuleAppStyleItemImplCopyWith<_$HomeRuleAppStyleItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}
