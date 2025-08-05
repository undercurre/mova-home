// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_theme_set_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppThemeSetUiState {
  List<AppThemeModel> get dataList => throw _privateConstructorUsedError;
  set dataList(List<AppThemeModel> value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppThemeSetUiStateCopyWith<AppThemeSetUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppThemeSetUiStateCopyWith<$Res> {
  factory $AppThemeSetUiStateCopyWith(
          AppThemeSetUiState value, $Res Function(AppThemeSetUiState) then) =
      _$AppThemeSetUiStateCopyWithImpl<$Res, AppThemeSetUiState>;
  @useResult
  $Res call({List<AppThemeModel> dataList});
}

/// @nodoc
class _$AppThemeSetUiStateCopyWithImpl<$Res, $Val extends AppThemeSetUiState>
    implements $AppThemeSetUiStateCopyWith<$Res> {
  _$AppThemeSetUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = null,
  }) {
    return _then(_value.copyWith(
      dataList: null == dataList
          ? _value.dataList
          : dataList // ignore: cast_nullable_to_non_nullable
              as List<AppThemeModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppThemeSetUiStateImplCopyWith<$Res>
    implements $AppThemeSetUiStateCopyWith<$Res> {
  factory _$$AppThemeSetUiStateImplCopyWith(_$AppThemeSetUiStateImpl value,
          $Res Function(_$AppThemeSetUiStateImpl) then) =
      __$$AppThemeSetUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AppThemeModel> dataList});
}

/// @nodoc
class __$$AppThemeSetUiStateImplCopyWithImpl<$Res>
    extends _$AppThemeSetUiStateCopyWithImpl<$Res, _$AppThemeSetUiStateImpl>
    implements _$$AppThemeSetUiStateImplCopyWith<$Res> {
  __$$AppThemeSetUiStateImplCopyWithImpl(_$AppThemeSetUiStateImpl _value,
      $Res Function(_$AppThemeSetUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = null,
  }) {
    return _then(_$AppThemeSetUiStateImpl(
      dataList: null == dataList
          ? _value.dataList
          : dataList // ignore: cast_nullable_to_non_nullable
              as List<AppThemeModel>,
    ));
  }
}

/// @nodoc

class _$AppThemeSetUiStateImpl implements _AppThemeSetUiState {
  _$AppThemeSetUiStateImpl({this.dataList = const []});

  @override
  @JsonKey()
  List<AppThemeModel> dataList;

  @override
  String toString() {
    return 'AppThemeSetUiState(dataList: $dataList)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppThemeSetUiStateImplCopyWith<_$AppThemeSetUiStateImpl> get copyWith =>
      __$$AppThemeSetUiStateImplCopyWithImpl<_$AppThemeSetUiStateImpl>(
          this, _$identity);
}

abstract class _AppThemeSetUiState implements AppThemeSetUiState {
  factory _AppThemeSetUiState({List<AppThemeModel> dataList}) =
      _$AppThemeSetUiStateImpl;

  @override
  List<AppThemeModel> get dataList;
  set dataList(List<AppThemeModel> value);
  @override
  @JsonKey(ignore: true)
  _$$AppThemeSetUiStateImplCopyWith<_$AppThemeSetUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
