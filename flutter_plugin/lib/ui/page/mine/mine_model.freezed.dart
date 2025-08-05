// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mine_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MineModel {
  String get tag => throw _privateConstructorUsedError;
  set tag(String value) => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  set icon(String value) => throw _privateConstructorUsedError;
  String get leftText => throw _privateConstructorUsedError;
  set leftText(String value) => throw _privateConstructorUsedError;
  String get rightText => throw _privateConstructorUsedError;
  set rightText(String value) => throw _privateConstructorUsedError;
  bool get showRightArrow => throw _privateConstructorUsedError;
  set showRightArrow(bool value) => throw _privateConstructorUsedError;
  Function? get onTouchUp => throw _privateConstructorUsedError;
  set onTouchUp(Function? value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MineModelCopyWith<MineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MineModelCopyWith<$Res> {
  factory $MineModelCopyWith(MineModel value, $Res Function(MineModel) then) =
      _$MineModelCopyWithImpl<$Res, MineModel>;
  @useResult
  $Res call(
      {String tag,
      String icon,
      String leftText,
      String rightText,
      bool showRightArrow,
      Function? onTouchUp});
}

/// @nodoc
class _$MineModelCopyWithImpl<$Res, $Val extends MineModel>
    implements $MineModelCopyWith<$Res> {
  _$MineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? icon = null,
    Object? leftText = null,
    Object? rightText = null,
    Object? showRightArrow = null,
    Object? onTouchUp = freezed,
  }) {
    return _then(_value.copyWith(
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      leftText: null == leftText
          ? _value.leftText
          : leftText // ignore: cast_nullable_to_non_nullable
              as String,
      rightText: null == rightText
          ? _value.rightText
          : rightText // ignore: cast_nullable_to_non_nullable
              as String,
      showRightArrow: null == showRightArrow
          ? _value.showRightArrow
          : showRightArrow // ignore: cast_nullable_to_non_nullable
              as bool,
      onTouchUp: freezed == onTouchUp
          ? _value.onTouchUp
          : onTouchUp // ignore: cast_nullable_to_non_nullable
              as Function?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MineModelImplCopyWith<$Res>
    implements $MineModelCopyWith<$Res> {
  factory _$$MineModelImplCopyWith(
          _$MineModelImpl value, $Res Function(_$MineModelImpl) then) =
      __$$MineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tag,
      String icon,
      String leftText,
      String rightText,
      bool showRightArrow,
      Function? onTouchUp});
}

/// @nodoc
class __$$MineModelImplCopyWithImpl<$Res>
    extends _$MineModelCopyWithImpl<$Res, _$MineModelImpl>
    implements _$$MineModelImplCopyWith<$Res> {
  __$$MineModelImplCopyWithImpl(
      _$MineModelImpl _value, $Res Function(_$MineModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? icon = null,
    Object? leftText = null,
    Object? rightText = null,
    Object? showRightArrow = null,
    Object? onTouchUp = freezed,
  }) {
    return _then(_$MineModelImpl(
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      leftText: null == leftText
          ? _value.leftText
          : leftText // ignore: cast_nullable_to_non_nullable
              as String,
      rightText: null == rightText
          ? _value.rightText
          : rightText // ignore: cast_nullable_to_non_nullable
              as String,
      showRightArrow: null == showRightArrow
          ? _value.showRightArrow
          : showRightArrow // ignore: cast_nullable_to_non_nullable
              as bool,
      onTouchUp: freezed == onTouchUp
          ? _value.onTouchUp
          : onTouchUp // ignore: cast_nullable_to_non_nullable
              as Function?,
    ));
  }
}

/// @nodoc

class _$MineModelImpl implements _MineModel {
  _$MineModelImpl(
      {this.tag = '',
      this.icon = '',
      this.leftText = '',
      this.rightText = '',
      this.showRightArrow = true,
      this.onTouchUp});

  @override
  @JsonKey()
  String tag;
  @override
  @JsonKey()
  String icon;
  @override
  @JsonKey()
  String leftText;
  @override
  @JsonKey()
  String rightText;
  @override
  @JsonKey()
  bool showRightArrow;
  @override
  Function? onTouchUp;

  @override
  String toString() {
    return 'MineModel(tag: $tag, icon: $icon, leftText: $leftText, rightText: $rightText, showRightArrow: $showRightArrow, onTouchUp: $onTouchUp)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MineModelImplCopyWith<_$MineModelImpl> get copyWith =>
      __$$MineModelImplCopyWithImpl<_$MineModelImpl>(this, _$identity);
}

abstract class _MineModel implements MineModel {
  factory _MineModel(
      {String tag,
      String icon,
      String leftText,
      String rightText,
      bool showRightArrow,
      Function? onTouchUp}) = _$MineModelImpl;

  @override
  String get tag;
  set tag(String value);
  @override
  String get icon;
  set icon(String value);
  @override
  String get leftText;
  set leftText(String value);
  @override
  String get rightText;
  set rightText(String value);
  @override
  bool get showRightArrow;
  set showRightArrow(bool value);
  @override
  Function? get onTouchUp;
  set onTouchUp(Function? value);
  @override
  @JsonKey(ignore: true)
  _$$MineModelImplCopyWith<_$MineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
