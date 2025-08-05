// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_res_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppResModel {
  Map<String, String> get iconMap => throw _privateConstructorUsedError;
  int get startDate => throw _privateConstructorUsedError;
  int get endDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppResModelCopyWith<AppResModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppResModelCopyWith<$Res> {
  factory $AppResModelCopyWith(
          AppResModel value, $Res Function(AppResModel) then) =
      _$AppResModelCopyWithImpl<$Res, AppResModel>;
  @useResult
  $Res call({Map<String, String> iconMap, int startDate, int endDate});
}

/// @nodoc
class _$AppResModelCopyWithImpl<$Res, $Val extends AppResModel>
    implements $AppResModelCopyWith<$Res> {
  _$AppResModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconMap = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_value.copyWith(
      iconMap: null == iconMap
          ? _value.iconMap
          : iconMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as int,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppResModelImplCopyWith<$Res>
    implements $AppResModelCopyWith<$Res> {
  factory _$$AppResModelImplCopyWith(
          _$AppResModelImpl value, $Res Function(_$AppResModelImpl) then) =
      __$$AppResModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> iconMap, int startDate, int endDate});
}

/// @nodoc
class __$$AppResModelImplCopyWithImpl<$Res>
    extends _$AppResModelCopyWithImpl<$Res, _$AppResModelImpl>
    implements _$$AppResModelImplCopyWith<$Res> {
  __$$AppResModelImplCopyWithImpl(
      _$AppResModelImpl _value, $Res Function(_$AppResModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iconMap = null,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_$AppResModelImpl(
      iconMap: null == iconMap
          ? _value._iconMap
          : iconMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as int,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AppResModelImpl implements _AppResModel {
  const _$AppResModelImpl(
      {final Map<String, String> iconMap = const {},
      this.startDate = 0,
      this.endDate = 0})
      : _iconMap = iconMap;

  final Map<String, String> _iconMap;
  @override
  @JsonKey()
  Map<String, String> get iconMap {
    if (_iconMap is EqualUnmodifiableMapView) return _iconMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_iconMap);
  }

  @override
  @JsonKey()
  final int startDate;
  @override
  @JsonKey()
  final int endDate;

  @override
  String toString() {
    return 'AppResModel(iconMap: $iconMap, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppResModelImpl &&
            const DeepCollectionEquality().equals(other._iconMap, _iconMap) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_iconMap), startDate, endDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppResModelImplCopyWith<_$AppResModelImpl> get copyWith =>
      __$$AppResModelImplCopyWithImpl<_$AppResModelImpl>(this, _$identity);
}

abstract class _AppResModel implements AppResModel {
  const factory _AppResModel(
      {final Map<String, String> iconMap,
      final int startDate,
      final int endDate}) = _$AppResModelImpl;

  @override
  Map<String, String> get iconMap;
  @override
  int get startDate;
  @override
  int get endDate;
  @override
  @JsonKey(ignore: true)
  _$$AppResModelImplCopyWith<_$AppResModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
