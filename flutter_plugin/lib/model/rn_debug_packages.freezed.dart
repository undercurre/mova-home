// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rn_debug_packages.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RNDebugPackages _$RNDebugPackagesFromJson(Map<String, dynamic> json) {
  return _RNDebugPackages.fromJson(json);
}

/// @nodoc
mixin _$RNDebugPackages {
  String get ip => throw _privateConstructorUsedError;
  set ip(String value) => throw _privateConstructorUsedError;
  bool get enable => throw _privateConstructorUsedError;
  set enable(bool value) => throw _privateConstructorUsedError;
  List<Projects>? get projects => throw _privateConstructorUsedError;
  set projects(List<Projects>? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RNDebugPackagesCopyWith<RNDebugPackages> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RNDebugPackagesCopyWith<$Res> {
  factory $RNDebugPackagesCopyWith(
          RNDebugPackages value, $Res Function(RNDebugPackages) then) =
      _$RNDebugPackagesCopyWithImpl<$Res, RNDebugPackages>;
  @useResult
  $Res call({String ip, bool enable, List<Projects>? projects});
}

/// @nodoc
class _$RNDebugPackagesCopyWithImpl<$Res, $Val extends RNDebugPackages>
    implements $RNDebugPackagesCopyWith<$Res> {
  _$RNDebugPackagesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? enable = null,
    Object? projects = freezed,
  }) {
    return _then(_value.copyWith(
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      enable: null == enable
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
      projects: freezed == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Projects>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RNDebugPackagesImplCopyWith<$Res>
    implements $RNDebugPackagesCopyWith<$Res> {
  factory _$$RNDebugPackagesImplCopyWith(_$RNDebugPackagesImpl value,
          $Res Function(_$RNDebugPackagesImpl) then) =
      __$$RNDebugPackagesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String ip, bool enable, List<Projects>? projects});
}

/// @nodoc
class __$$RNDebugPackagesImplCopyWithImpl<$Res>
    extends _$RNDebugPackagesCopyWithImpl<$Res, _$RNDebugPackagesImpl>
    implements _$$RNDebugPackagesImplCopyWith<$Res> {
  __$$RNDebugPackagesImplCopyWithImpl(
      _$RNDebugPackagesImpl _value, $Res Function(_$RNDebugPackagesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? enable = null,
    Object? projects = freezed,
  }) {
    return _then(_$RNDebugPackagesImpl(
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      enable: null == enable
          ? _value.enable
          : enable // ignore: cast_nullable_to_non_nullable
              as bool,
      projects: freezed == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Projects>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RNDebugPackagesImpl implements _RNDebugPackages {
  _$RNDebugPackagesImpl({this.ip = '', this.enable = false, this.projects});

  factory _$RNDebugPackagesImpl.fromJson(Map<String, dynamic> json) =>
      _$$RNDebugPackagesImplFromJson(json);

  @override
  @JsonKey()
  String ip;
  @override
  @JsonKey()
  bool enable;
  @override
  List<Projects>? projects;

  @override
  String toString() {
    return 'RNDebugPackages(ip: $ip, enable: $enable, projects: $projects)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RNDebugPackagesImplCopyWith<_$RNDebugPackagesImpl> get copyWith =>
      __$$RNDebugPackagesImplCopyWithImpl<_$RNDebugPackagesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RNDebugPackagesImplToJson(
      this,
    );
  }
}

abstract class _RNDebugPackages implements RNDebugPackages {
  factory _RNDebugPackages({String ip, bool enable, List<Projects>? projects}) =
      _$RNDebugPackagesImpl;

  factory _RNDebugPackages.fromJson(Map<String, dynamic> json) =
      _$RNDebugPackagesImpl.fromJson;

  @override
  String get ip;
  set ip(String value);
  @override
  bool get enable;
  set enable(bool value);
  @override
  List<Projects>? get projects;
  set projects(List<Projects>? value);
  @override
  @JsonKey(ignore: true)
  _$$RNDebugPackagesImplCopyWith<_$RNDebugPackagesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Projects _$ProjectsFromJson(Map<String, dynamic> json) {
  return _Projects.fromJson(json);
}

/// @nodoc
mixin _$Projects {
  String? get packageName => throw _privateConstructorUsedError;
  set packageName(String? value) => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  set model(String? value) => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  set id(int? value) => throw _privateConstructorUsedError;
  bool? get selected => throw _privateConstructorUsedError;
  set selected(bool? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectsCopyWith<Projects> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectsCopyWith<$Res> {
  factory $ProjectsCopyWith(Projects value, $Res Function(Projects) then) =
      _$ProjectsCopyWithImpl<$Res, Projects>;
  @useResult
  $Res call({String? packageName, String? model, int? id, bool? selected});
}

/// @nodoc
class _$ProjectsCopyWithImpl<$Res, $Val extends Projects>
    implements $ProjectsCopyWith<$Res> {
  _$ProjectsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = freezed,
    Object? model = freezed,
    Object? id = freezed,
    Object? selected = freezed,
  }) {
    return _then(_value.copyWith(
      packageName: freezed == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectsImplCopyWith<$Res>
    implements $ProjectsCopyWith<$Res> {
  factory _$$ProjectsImplCopyWith(
          _$ProjectsImpl value, $Res Function(_$ProjectsImpl) then) =
      __$$ProjectsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? packageName, String? model, int? id, bool? selected});
}

/// @nodoc
class __$$ProjectsImplCopyWithImpl<$Res>
    extends _$ProjectsCopyWithImpl<$Res, _$ProjectsImpl>
    implements _$$ProjectsImplCopyWith<$Res> {
  __$$ProjectsImplCopyWithImpl(
      _$ProjectsImpl _value, $Res Function(_$ProjectsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = freezed,
    Object? model = freezed,
    Object? id = freezed,
    Object? selected = freezed,
  }) {
    return _then(_$ProjectsImpl(
      packageName: freezed == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectsImpl implements _Projects {
  _$ProjectsImpl(
      {this.packageName, this.model, this.id, this.selected = false});

  factory _$ProjectsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectsImplFromJson(json);

  @override
  String? packageName;
  @override
  String? model;
  @override
  int? id;
  @override
  @JsonKey()
  bool? selected;

  @override
  String toString() {
    return 'Projects(packageName: $packageName, model: $model, id: $id, selected: $selected)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectsImplCopyWith<_$ProjectsImpl> get copyWith =>
      __$$ProjectsImplCopyWithImpl<_$ProjectsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectsImplToJson(
      this,
    );
  }
}

abstract class _Projects implements Projects {
  factory _Projects(
      {String? packageName,
      String? model,
      int? id,
      bool? selected}) = _$ProjectsImpl;

  factory _Projects.fromJson(Map<String, dynamic> json) =
      _$ProjectsImpl.fromJson;

  @override
  String? get packageName;
  set packageName(String? value);
  @override
  String? get model;
  set model(String? value);
  @override
  int? get id;
  set id(int? value);
  @override
  bool? get selected;
  set selected(bool? value);
  @override
  @JsonKey(ignore: true)
  _$$ProjectsImplCopyWith<_$ProjectsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
