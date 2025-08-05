// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'developer_mode_page_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeveloperModePageUIState {
  RNDebugPackages? get rnDebugPackages => throw _privateConstructorUsedError;
  set rnDebugPackages(RNDebugPackages? value) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DeveloperModePageUIStateCopyWith<DeveloperModePageUIState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeveloperModePageUIStateCopyWith<$Res> {
  factory $DeveloperModePageUIStateCopyWith(DeveloperModePageUIState value,
          $Res Function(DeveloperModePageUIState) then) =
      _$DeveloperModePageUIStateCopyWithImpl<$Res, DeveloperModePageUIState>;
  @useResult
  $Res call({RNDebugPackages? rnDebugPackages});

  $RNDebugPackagesCopyWith<$Res>? get rnDebugPackages;
}

/// @nodoc
class _$DeveloperModePageUIStateCopyWithImpl<$Res,
        $Val extends DeveloperModePageUIState>
    implements $DeveloperModePageUIStateCopyWith<$Res> {
  _$DeveloperModePageUIStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rnDebugPackages = freezed,
  }) {
    return _then(_value.copyWith(
      rnDebugPackages: freezed == rnDebugPackages
          ? _value.rnDebugPackages
          : rnDebugPackages // ignore: cast_nullable_to_non_nullable
              as RNDebugPackages?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RNDebugPackagesCopyWith<$Res>? get rnDebugPackages {
    if (_value.rnDebugPackages == null) {
      return null;
    }

    return $RNDebugPackagesCopyWith<$Res>(_value.rnDebugPackages!, (value) {
      return _then(_value.copyWith(rnDebugPackages: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DeveloperModePageUIStateImplCopyWith<$Res>
    implements $DeveloperModePageUIStateCopyWith<$Res> {
  factory _$$DeveloperModePageUIStateImplCopyWith(
          _$DeveloperModePageUIStateImpl value,
          $Res Function(_$DeveloperModePageUIStateImpl) then) =
      __$$DeveloperModePageUIStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RNDebugPackages? rnDebugPackages});

  @override
  $RNDebugPackagesCopyWith<$Res>? get rnDebugPackages;
}

/// @nodoc
class __$$DeveloperModePageUIStateImplCopyWithImpl<$Res>
    extends _$DeveloperModePageUIStateCopyWithImpl<$Res,
        _$DeveloperModePageUIStateImpl>
    implements _$$DeveloperModePageUIStateImplCopyWith<$Res> {
  __$$DeveloperModePageUIStateImplCopyWithImpl(
      _$DeveloperModePageUIStateImpl _value,
      $Res Function(_$DeveloperModePageUIStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rnDebugPackages = freezed,
  }) {
    return _then(_$DeveloperModePageUIStateImpl(
      rnDebugPackages: freezed == rnDebugPackages
          ? _value.rnDebugPackages
          : rnDebugPackages // ignore: cast_nullable_to_non_nullable
              as RNDebugPackages?,
    ));
  }
}

/// @nodoc

class _$DeveloperModePageUIStateImpl implements _DeveloperModePageUIState {
  _$DeveloperModePageUIStateImpl({this.rnDebugPackages});

  @override
  RNDebugPackages? rnDebugPackages;

  @override
  String toString() {
    return 'DeveloperModePageUIState(rnDebugPackages: $rnDebugPackages)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeveloperModePageUIStateImplCopyWith<_$DeveloperModePageUIStateImpl>
      get copyWith => __$$DeveloperModePageUIStateImplCopyWithImpl<
          _$DeveloperModePageUIStateImpl>(this, _$identity);
}

abstract class _DeveloperModePageUIState implements DeveloperModePageUIState {
  factory _DeveloperModePageUIState({RNDebugPackages? rnDebugPackages}) =
      _$DeveloperModePageUIStateImpl;

  @override
  RNDebugPackages? get rnDebugPackages;
  set rnDebugPackages(RNDebugPackages? value);
  @override
  @JsonKey(ignore: true)
  _$$DeveloperModePageUIStateImplCopyWith<_$DeveloperModePageUIStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
