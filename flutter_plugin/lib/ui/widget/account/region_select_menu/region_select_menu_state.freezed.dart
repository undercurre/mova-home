// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_select_menu_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegionSelectMenuState {
  RegionItem? get currentRegion => throw _privateConstructorUsedError;
  String? get regionName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegionSelectMenuStateCopyWith<RegionSelectMenuState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegionSelectMenuStateCopyWith<$Res> {
  factory $RegionSelectMenuStateCopyWith(RegionSelectMenuState value,
          $Res Function(RegionSelectMenuState) then) =
      _$RegionSelectMenuStateCopyWithImpl<$Res, RegionSelectMenuState>;
  @useResult
  $Res call({RegionItem? currentRegion, String? regionName});
}

/// @nodoc
class _$RegionSelectMenuStateCopyWithImpl<$Res,
        $Val extends RegionSelectMenuState>
    implements $RegionSelectMenuStateCopyWith<$Res> {
  _$RegionSelectMenuStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRegion = freezed,
    Object? regionName = freezed,
  }) {
    return _then(_value.copyWith(
      currentRegion: freezed == currentRegion
          ? _value.currentRegion
          : currentRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      regionName: freezed == regionName
          ? _value.regionName
          : regionName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegionSelectMenuStateImplCopyWith<$Res>
    implements $RegionSelectMenuStateCopyWith<$Res> {
  factory _$$RegionSelectMenuStateImplCopyWith(
          _$RegionSelectMenuStateImpl value,
          $Res Function(_$RegionSelectMenuStateImpl) then) =
      __$$RegionSelectMenuStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RegionItem? currentRegion, String? regionName});
}

/// @nodoc
class __$$RegionSelectMenuStateImplCopyWithImpl<$Res>
    extends _$RegionSelectMenuStateCopyWithImpl<$Res,
        _$RegionSelectMenuStateImpl>
    implements _$$RegionSelectMenuStateImplCopyWith<$Res> {
  __$$RegionSelectMenuStateImplCopyWithImpl(_$RegionSelectMenuStateImpl _value,
      $Res Function(_$RegionSelectMenuStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentRegion = freezed,
    Object? regionName = freezed,
  }) {
    return _then(_$RegionSelectMenuStateImpl(
      currentRegion: freezed == currentRegion
          ? _value.currentRegion
          : currentRegion // ignore: cast_nullable_to_non_nullable
              as RegionItem?,
      regionName: freezed == regionName
          ? _value.regionName
          : regionName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RegionSelectMenuStateImpl implements _RegionSelectMenuState {
  _$RegionSelectMenuStateImpl({this.currentRegion, this.regionName});

  @override
  final RegionItem? currentRegion;
  @override
  final String? regionName;

  @override
  String toString() {
    return 'RegionSelectMenuState(currentRegion: $currentRegion, regionName: $regionName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegionSelectMenuStateImpl &&
            (identical(other.currentRegion, currentRegion) ||
                other.currentRegion == currentRegion) &&
            (identical(other.regionName, regionName) ||
                other.regionName == regionName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentRegion, regionName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegionSelectMenuStateImplCopyWith<_$RegionSelectMenuStateImpl>
      get copyWith => __$$RegionSelectMenuStateImplCopyWithImpl<
          _$RegionSelectMenuStateImpl>(this, _$identity);
}

abstract class _RegionSelectMenuState implements RegionSelectMenuState {
  factory _RegionSelectMenuState(
      {final RegionItem? currentRegion,
      final String? regionName}) = _$RegionSelectMenuStateImpl;

  @override
  RegionItem? get currentRegion;
  @override
  String? get regionName;
  @override
  @JsonKey(ignore: true)
  _$$RegionSelectMenuStateImplCopyWith<_$RegionSelectMenuStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
