// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rn_plugin_update_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RNPluginUpdateModel {
  String? get model => throw _privateConstructorUsedError;
  set model(String? value) => throw _privateConstructorUsedError;
  bool get hide => throw _privateConstructorUsedError;
  set hide(bool value) => throw _privateConstructorUsedError;
  bool? get hasLocal => throw _privateConstructorUsedError;
  set hasLocal(bool? value) => throw _privateConstructorUsedError;
  PluginLocalModel? get sdkModel => throw _privateConstructorUsedError;
  set sdkModel(PluginLocalModel? value) => throw _privateConstructorUsedError;
  PluginLocalModel? get pluginModel => throw _privateConstructorUsedError;
  set pluginModel(PluginLocalModel? value) =>
      throw _privateConstructorUsedError;
  PluginLocalModel? get resModel => throw _privateConstructorUsedError;
  set resModel(PluginLocalModel? value) => throw _privateConstructorUsedError;
  bool get isDebug => throw _privateConstructorUsedError;
  set isDebug(bool value) => throw _privateConstructorUsedError;
  String? get ip => throw _privateConstructorUsedError;
  set ip(String? value) => throw _privateConstructorUsedError;
  String? get debugUrl => throw _privateConstructorUsedError;
  set debugUrl(String? value) => throw _privateConstructorUsedError;
  int? get code => throw _privateConstructorUsedError;
  set code(int? value) => throw _privateConstructorUsedError;
  int? get progress => throw _privateConstructorUsedError;
  set progress(int? value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RNPluginUpdateModelCopyWith<RNPluginUpdateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RNPluginUpdateModelCopyWith<$Res> {
  factory $RNPluginUpdateModelCopyWith(
          RNPluginUpdateModel value, $Res Function(RNPluginUpdateModel) then) =
      _$RNPluginUpdateModelCopyWithImpl<$Res, RNPluginUpdateModel>;
  @useResult
  $Res call(
      {String? model,
      bool hide,
      bool? hasLocal,
      PluginLocalModel? sdkModel,
      PluginLocalModel? pluginModel,
      PluginLocalModel? resModel,
      bool isDebug,
      String? ip,
      String? debugUrl,
      int? code,
      int? progress});

  $PluginLocalModelCopyWith<$Res>? get sdkModel;
  $PluginLocalModelCopyWith<$Res>? get pluginModel;
  $PluginLocalModelCopyWith<$Res>? get resModel;
}

/// @nodoc
class _$RNPluginUpdateModelCopyWithImpl<$Res, $Val extends RNPluginUpdateModel>
    implements $RNPluginUpdateModelCopyWith<$Res> {
  _$RNPluginUpdateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
    Object? hide = null,
    Object? hasLocal = freezed,
    Object? sdkModel = freezed,
    Object? pluginModel = freezed,
    Object? resModel = freezed,
    Object? isDebug = null,
    Object? ip = freezed,
    Object? debugUrl = freezed,
    Object? code = freezed,
    Object? progress = freezed,
  }) {
    return _then(_value.copyWith(
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      hide: null == hide
          ? _value.hide
          : hide // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocal: freezed == hasLocal
          ? _value.hasLocal
          : hasLocal // ignore: cast_nullable_to_non_nullable
              as bool?,
      sdkModel: freezed == sdkModel
          ? _value.sdkModel
          : sdkModel // ignore: cast_nullable_to_non_nullable
              as PluginLocalModel?,
      pluginModel: freezed == pluginModel
          ? _value.pluginModel
          : pluginModel // ignore: cast_nullable_to_non_nullable
              as PluginLocalModel?,
      resModel: freezed == resModel
          ? _value.resModel
          : resModel // ignore: cast_nullable_to_non_nullable
              as PluginLocalModel?,
      isDebug: null == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool,
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
      debugUrl: freezed == debugUrl
          ? _value.debugUrl
          : debugUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PluginLocalModelCopyWith<$Res>? get sdkModel {
    if (_value.sdkModel == null) {
      return null;
    }

    return $PluginLocalModelCopyWith<$Res>(_value.sdkModel!, (value) {
      return _then(_value.copyWith(sdkModel: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PluginLocalModelCopyWith<$Res>? get pluginModel {
    if (_value.pluginModel == null) {
      return null;
    }

    return $PluginLocalModelCopyWith<$Res>(_value.pluginModel!, (value) {
      return _then(_value.copyWith(pluginModel: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PluginLocalModelCopyWith<$Res>? get resModel {
    if (_value.resModel == null) {
      return null;
    }

    return $PluginLocalModelCopyWith<$Res>(_value.resModel!, (value) {
      return _then(_value.copyWith(resModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RNPluginUpdateModelImplCopyWith<$Res>
    implements $RNPluginUpdateModelCopyWith<$Res> {
  factory _$$RNPluginUpdateModelImplCopyWith(_$RNPluginUpdateModelImpl value,
          $Res Function(_$RNPluginUpdateModelImpl) then) =
      __$$RNPluginUpdateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? model,
      bool hide,
      bool? hasLocal,
      PluginLocalModel? sdkModel,
      PluginLocalModel? pluginModel,
      PluginLocalModel? resModel,
      bool isDebug,
      String? ip,
      String? debugUrl,
      int? code,
      int? progress});

  @override
  $PluginLocalModelCopyWith<$Res>? get sdkModel;
  @override
  $PluginLocalModelCopyWith<$Res>? get pluginModel;
  @override
  $PluginLocalModelCopyWith<$Res>? get resModel;
}

/// @nodoc
class __$$RNPluginUpdateModelImplCopyWithImpl<$Res>
    extends _$RNPluginUpdateModelCopyWithImpl<$Res, _$RNPluginUpdateModelImpl>
    implements _$$RNPluginUpdateModelImplCopyWith<$Res> {
  __$$RNPluginUpdateModelImplCopyWithImpl(_$RNPluginUpdateModelImpl _value,
      $Res Function(_$RNPluginUpdateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
    Object? hide = null,
    Object? hasLocal = freezed,
    Object? sdkModel = freezed,
    Object? pluginModel = freezed,
    Object? resModel = freezed,
    Object? isDebug = null,
    Object? ip = freezed,
    Object? debugUrl = freezed,
    Object? code = freezed,
    Object? progress = freezed,
  }) {
    return _then(_$RNPluginUpdateModelImpl(
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      hide: null == hide
          ? _value.hide
          : hide // ignore: cast_nullable_to_non_nullable
              as bool,
      hasLocal: freezed == hasLocal
          ? _value.hasLocal
          : hasLocal // ignore: cast_nullable_to_non_nullable
              as bool?,
      sdkModel: freezed == sdkModel
          ? _value.sdkModel
          : sdkModel // ignore: cast_nullable_to_non_nullable
              as PluginLocalModel?,
      pluginModel: freezed == pluginModel
          ? _value.pluginModel
          : pluginModel // ignore: cast_nullable_to_non_nullable
              as PluginLocalModel?,
      resModel: freezed == resModel
          ? _value.resModel
          : resModel // ignore: cast_nullable_to_non_nullable
              as PluginLocalModel?,
      isDebug: null == isDebug
          ? _value.isDebug
          : isDebug // ignore: cast_nullable_to_non_nullable
              as bool,
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
      debugUrl: freezed == debugUrl
          ? _value.debugUrl
          : debugUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      progress: freezed == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$RNPluginUpdateModelImpl implements _RNPluginUpdateModel {
  _$RNPluginUpdateModelImpl(
      {this.model,
      this.hide = false,
      this.hasLocal,
      this.sdkModel,
      this.pluginModel,
      this.resModel,
      this.isDebug = false,
      this.ip,
      this.debugUrl,
      this.code,
      this.progress});

  @override
  String? model;
  @override
  @JsonKey()
  bool hide;
  @override
  bool? hasLocal;
  @override
  PluginLocalModel? sdkModel;
  @override
  PluginLocalModel? pluginModel;
  @override
  PluginLocalModel? resModel;
  @override
  @JsonKey()
  bool isDebug;
  @override
  String? ip;
  @override
  String? debugUrl;
  @override
  int? code;
  @override
  int? progress;

  @override
  String toString() {
    return 'RNPluginUpdateModel(model: $model, hide: $hide, hasLocal: $hasLocal, sdkModel: $sdkModel, pluginModel: $pluginModel, resModel: $resModel, isDebug: $isDebug, ip: $ip, debugUrl: $debugUrl, code: $code, progress: $progress)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RNPluginUpdateModelImplCopyWith<_$RNPluginUpdateModelImpl> get copyWith =>
      __$$RNPluginUpdateModelImplCopyWithImpl<_$RNPluginUpdateModelImpl>(
          this, _$identity);
}

abstract class _RNPluginUpdateModel implements RNPluginUpdateModel {
  factory _RNPluginUpdateModel(
      {String? model,
      bool hide,
      bool? hasLocal,
      PluginLocalModel? sdkModel,
      PluginLocalModel? pluginModel,
      PluginLocalModel? resModel,
      bool isDebug,
      String? ip,
      String? debugUrl,
      int? code,
      int? progress}) = _$RNPluginUpdateModelImpl;

  @override
  String? get model;
  set model(String? value);
  @override
  bool get hide;
  set hide(bool value);
  @override
  bool? get hasLocal;
  set hasLocal(bool? value);
  @override
  PluginLocalModel? get sdkModel;
  set sdkModel(PluginLocalModel? value);
  @override
  PluginLocalModel? get pluginModel;
  set pluginModel(PluginLocalModel? value);
  @override
  PluginLocalModel? get resModel;
  set resModel(PluginLocalModel? value);
  @override
  bool get isDebug;
  set isDebug(bool value);
  @override
  String? get ip;
  set ip(String? value);
  @override
  String? get debugUrl;
  set debugUrl(String? value);
  @override
  int? get code;
  set code(int? value);
  @override
  int? get progress;
  set progress(int? value);
  @override
  @JsonKey(ignore: true)
  _$$RNPluginUpdateModelImplCopyWith<_$RNPluginUpdateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
