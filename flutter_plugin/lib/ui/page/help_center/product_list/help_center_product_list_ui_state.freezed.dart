// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_center_product_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HelpCenterProductListUiState {
  List<HelpCenterKindOfProduct> get products =>
      throw _privateConstructorUsedError;
  List<HelpCenterKindOfProduct> get childrenList =>
      throw _privateConstructorUsedError;
  int get kindofIndex => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HelpCenterProductListUiStateCopyWith<HelpCenterProductListUiState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpCenterProductListUiStateCopyWith<$Res> {
  factory $HelpCenterProductListUiStateCopyWith(
          HelpCenterProductListUiState value,
          $Res Function(HelpCenterProductListUiState) then) =
      _$HelpCenterProductListUiStateCopyWithImpl<$Res,
          HelpCenterProductListUiState>;
  @useResult
  $Res call(
      {List<HelpCenterKindOfProduct> products,
      List<HelpCenterKindOfProduct> childrenList,
      int kindofIndex,
      CommonUIEvent event});
}

/// @nodoc
class _$HelpCenterProductListUiStateCopyWithImpl<$Res,
        $Val extends HelpCenterProductListUiState>
    implements $HelpCenterProductListUiStateCopyWith<$Res> {
  _$HelpCenterProductListUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? childrenList = null,
    Object? kindofIndex = null,
    Object? event = null,
  }) {
    return _then(_value.copyWith(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<HelpCenterKindOfProduct>,
      childrenList: null == childrenList
          ? _value.childrenList
          : childrenList // ignore: cast_nullable_to_non_nullable
              as List<HelpCenterKindOfProduct>,
      kindofIndex: null == kindofIndex
          ? _value.kindofIndex
          : kindofIndex // ignore: cast_nullable_to_non_nullable
              as int,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpCenterProductListUiStateImplCopyWith<$Res>
    implements $HelpCenterProductListUiStateCopyWith<$Res> {
  factory _$$HelpCenterProductListUiStateImplCopyWith(
          _$HelpCenterProductListUiStateImpl value,
          $Res Function(_$HelpCenterProductListUiStateImpl) then) =
      __$$HelpCenterProductListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<HelpCenterKindOfProduct> products,
      List<HelpCenterKindOfProduct> childrenList,
      int kindofIndex,
      CommonUIEvent event});
}

/// @nodoc
class __$$HelpCenterProductListUiStateImplCopyWithImpl<$Res>
    extends _$HelpCenterProductListUiStateCopyWithImpl<$Res,
        _$HelpCenterProductListUiStateImpl>
    implements _$$HelpCenterProductListUiStateImplCopyWith<$Res> {
  __$$HelpCenterProductListUiStateImplCopyWithImpl(
      _$HelpCenterProductListUiStateImpl _value,
      $Res Function(_$HelpCenterProductListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? childrenList = null,
    Object? kindofIndex = null,
    Object? event = null,
  }) {
    return _then(_$HelpCenterProductListUiStateImpl(
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<HelpCenterKindOfProduct>,
      childrenList: null == childrenList
          ? _value._childrenList
          : childrenList // ignore: cast_nullable_to_non_nullable
              as List<HelpCenterKindOfProduct>,
      kindofIndex: null == kindofIndex
          ? _value.kindofIndex
          : kindofIndex // ignore: cast_nullable_to_non_nullable
              as int,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
    ));
  }
}

/// @nodoc

class _$HelpCenterProductListUiStateImpl
    implements _HelpCenterProductListUiState {
  const _$HelpCenterProductListUiStateImpl(
      {final List<HelpCenterKindOfProduct> products = const [],
      final List<HelpCenterKindOfProduct> childrenList = const [],
      this.kindofIndex = 0,
      this.event = const EmptyEvent()})
      : _products = products,
        _childrenList = childrenList;

  final List<HelpCenterKindOfProduct> _products;
  @override
  @JsonKey()
  List<HelpCenterKindOfProduct> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<HelpCenterKindOfProduct> _childrenList;
  @override
  @JsonKey()
  List<HelpCenterKindOfProduct> get childrenList {
    if (_childrenList is EqualUnmodifiableListView) return _childrenList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childrenList);
  }

  @override
  @JsonKey()
  final int kindofIndex;
  @override
  @JsonKey()
  final CommonUIEvent event;

  @override
  String toString() {
    return 'HelpCenterProductListUiState(products: $products, childrenList: $childrenList, kindofIndex: $kindofIndex, event: $event)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpCenterProductListUiStateImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality()
                .equals(other._childrenList, _childrenList) &&
            (identical(other.kindofIndex, kindofIndex) ||
                other.kindofIndex == kindofIndex) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_childrenList),
      kindofIndex,
      event);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpCenterProductListUiStateImplCopyWith<
          _$HelpCenterProductListUiStateImpl>
      get copyWith => __$$HelpCenterProductListUiStateImplCopyWithImpl<
          _$HelpCenterProductListUiStateImpl>(this, _$identity);
}

abstract class _HelpCenterProductListUiState
    implements HelpCenterProductListUiState {
  const factory _HelpCenterProductListUiState(
      {final List<HelpCenterKindOfProduct> products,
      final List<HelpCenterKindOfProduct> childrenList,
      final int kindofIndex,
      final CommonUIEvent event}) = _$HelpCenterProductListUiStateImpl;

  @override
  List<HelpCenterKindOfProduct> get products;
  @override
  List<HelpCenterKindOfProduct> get childrenList;
  @override
  int get kindofIndex;
  @override
  CommonUIEvent get event;
  @override
  @JsonKey(ignore: true)
  _$$HelpCenterProductListUiStateImplCopyWith<
          _$HelpCenterProductListUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
