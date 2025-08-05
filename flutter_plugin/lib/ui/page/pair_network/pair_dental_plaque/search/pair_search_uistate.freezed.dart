// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_search_uistate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PairSearchUiState {
  String get navTitle => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  int get currentStep => throw _privateConstructorUsedError;
  int get totalStep => throw _privateConstructorUsedError;
  bool get enableBtn => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PairSearchUiStateCopyWith<PairSearchUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairSearchUiStateCopyWith<$Res> {
  factory $PairSearchUiStateCopyWith(
          PairSearchUiState value, $Res Function(PairSearchUiState) then) =
      _$PairSearchUiStateCopyWithImpl<$Res, PairSearchUiState>;
  @useResult
  $Res call(
      {String navTitle,
      String displayName,
      String productId,
      int currentStep,
      int totalStep,
      bool enableBtn});
}

/// @nodoc
class _$PairSearchUiStateCopyWithImpl<$Res, $Val extends PairSearchUiState>
    implements $PairSearchUiStateCopyWith<$Res> {
  _$PairSearchUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navTitle = null,
    Object? displayName = null,
    Object? productId = null,
    Object? currentStep = null,
    Object? totalStep = null,
    Object? enableBtn = null,
  }) {
    return _then(_value.copyWith(
      navTitle: null == navTitle
          ? _value.navTitle
          : navTitle // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      totalStep: null == totalStep
          ? _value.totalStep
          : totalStep // ignore: cast_nullable_to_non_nullable
              as int,
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PairConnectUiStateImplCopyWith<$Res>
    implements $PairSearchUiStateCopyWith<$Res> {
  factory _$$PairConnectUiStateImplCopyWith(_$PairConnectUiStateImpl value,
          $Res Function(_$PairConnectUiStateImpl) then) =
      __$$PairConnectUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String navTitle,
      String displayName,
      String productId,
      int currentStep,
      int totalStep,
      bool enableBtn});
}

/// @nodoc
class __$$PairConnectUiStateImplCopyWithImpl<$Res>
    extends _$PairSearchUiStateCopyWithImpl<$Res, _$PairConnectUiStateImpl>
    implements _$$PairConnectUiStateImplCopyWith<$Res> {
  __$$PairConnectUiStateImplCopyWithImpl(_$PairConnectUiStateImpl _value,
      $Res Function(_$PairConnectUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navTitle = null,
    Object? displayName = null,
    Object? productId = null,
    Object? currentStep = null,
    Object? totalStep = null,
    Object? enableBtn = null,
  }) {
    return _then(_$PairConnectUiStateImpl(
      navTitle: null == navTitle
          ? _value.navTitle
          : navTitle // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      totalStep: null == totalStep
          ? _value.totalStep
          : totalStep // ignore: cast_nullable_to_non_nullable
              as int,
      enableBtn: null == enableBtn
          ? _value.enableBtn
          : enableBtn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PairConnectUiStateImpl implements _PairConnectUiState {
  const _$PairConnectUiStateImpl(
      {this.navTitle = 'search',
      this.displayName = '',
      this.productId = '',
      this.currentStep = 1,
      this.totalStep = 1,
      this.enableBtn = false});

  @override
  @JsonKey()
  final String navTitle;
  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String productId;
  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final int totalStep;
  @override
  @JsonKey()
  final bool enableBtn;

  @override
  String toString() {
    return 'PairSearchUiState(navTitle: $navTitle, displayName: $displayName, productId: $productId, currentStep: $currentStep, totalStep: $totalStep, enableBtn: $enableBtn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairConnectUiStateImpl &&
            (identical(other.navTitle, navTitle) ||
                other.navTitle == navTitle) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.totalStep, totalStep) ||
                other.totalStep == totalStep) &&
            (identical(other.enableBtn, enableBtn) ||
                other.enableBtn == enableBtn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navTitle, displayName, productId,
      currentStep, totalStep, enableBtn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairConnectUiStateImplCopyWith<_$PairConnectUiStateImpl> get copyWith =>
      __$$PairConnectUiStateImplCopyWithImpl<_$PairConnectUiStateImpl>(
          this, _$identity);
}

abstract class _PairConnectUiState implements PairSearchUiState {
  const factory _PairConnectUiState(
      {final String navTitle,
      final String displayName,
      final String productId,
      final int currentStep,
      final int totalStep,
      final bool enableBtn}) = _$PairConnectUiStateImpl;

  @override
  String get navTitle;
  @override
  String get displayName;
  @override
  String get productId;
  @override
  int get currentStep;
  @override
  int get totalStep;
  @override
  bool get enableBtn;
  @override
  @JsonKey(ignore: true)
  _$$PairConnectUiStateImplCopyWith<_$PairConnectUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
