// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_list_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProdcutListUiState _$ProdcutListUiStateFromJson(Map<String, dynamic> json) {
  return _ProdcutListUiState.fromJson(json);
}

/// @nodoc
mixin _$ProdcutListUiState {
  bool get loading => throw _privateConstructorUsedError;
  List<KindOfProduct> get menuList => throw _privateConstructorUsedError;
  List<SeriesOfProduct> get productList => throw _privateConstructorUsedError;
  Map<String, dynamic> get menuIndexPath => throw _privateConstructorUsedError;
  List<IotDevice> get scannedList => throw _privateConstructorUsedError;
  DMIndexPath? get selectedIdx => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProdcutListUiStateCopyWith<ProdcutListUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProdcutListUiStateCopyWith<$Res> {
  factory $ProdcutListUiStateCopyWith(
          ProdcutListUiState value, $Res Function(ProdcutListUiState) then) =
      _$ProdcutListUiStateCopyWithImpl<$Res, ProdcutListUiState>;
  @useResult
  $Res call(
      {bool loading,
      List<KindOfProduct> menuList,
      List<SeriesOfProduct> productList,
      Map<String, dynamic> menuIndexPath,
      List<IotDevice> scannedList,
      DMIndexPath? selectedIdx});

  $DMIndexPathCopyWith<$Res>? get selectedIdx;
}

/// @nodoc
class _$ProdcutListUiStateCopyWithImpl<$Res, $Val extends ProdcutListUiState>
    implements $ProdcutListUiStateCopyWith<$Res> {
  _$ProdcutListUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? menuList = null,
    Object? productList = null,
    Object? menuIndexPath = null,
    Object? scannedList = null,
    Object? selectedIdx = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      menuList: null == menuList
          ? _value.menuList
          : menuList // ignore: cast_nullable_to_non_nullable
              as List<KindOfProduct>,
      productList: null == productList
          ? _value.productList
          : productList // ignore: cast_nullable_to_non_nullable
              as List<SeriesOfProduct>,
      menuIndexPath: null == menuIndexPath
          ? _value.menuIndexPath
          : menuIndexPath // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      scannedList: null == scannedList
          ? _value.scannedList
          : scannedList // ignore: cast_nullable_to_non_nullable
              as List<IotDevice>,
      selectedIdx: freezed == selectedIdx
          ? _value.selectedIdx
          : selectedIdx // ignore: cast_nullable_to_non_nullable
              as DMIndexPath?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DMIndexPathCopyWith<$Res>? get selectedIdx {
    if (_value.selectedIdx == null) {
      return null;
    }

    return $DMIndexPathCopyWith<$Res>(_value.selectedIdx!, (value) {
      return _then(_value.copyWith(selectedIdx: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProdcutListUiStateImplCopyWith<$Res>
    implements $ProdcutListUiStateCopyWith<$Res> {
  factory _$$ProdcutListUiStateImplCopyWith(_$ProdcutListUiStateImpl value,
          $Res Function(_$ProdcutListUiStateImpl) then) =
      __$$ProdcutListUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      List<KindOfProduct> menuList,
      List<SeriesOfProduct> productList,
      Map<String, dynamic> menuIndexPath,
      List<IotDevice> scannedList,
      DMIndexPath? selectedIdx});

  @override
  $DMIndexPathCopyWith<$Res>? get selectedIdx;
}

/// @nodoc
class __$$ProdcutListUiStateImplCopyWithImpl<$Res>
    extends _$ProdcutListUiStateCopyWithImpl<$Res, _$ProdcutListUiStateImpl>
    implements _$$ProdcutListUiStateImplCopyWith<$Res> {
  __$$ProdcutListUiStateImplCopyWithImpl(_$ProdcutListUiStateImpl _value,
      $Res Function(_$ProdcutListUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? menuList = null,
    Object? productList = null,
    Object? menuIndexPath = null,
    Object? scannedList = null,
    Object? selectedIdx = freezed,
  }) {
    return _then(_$ProdcutListUiStateImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      menuList: null == menuList
          ? _value._menuList
          : menuList // ignore: cast_nullable_to_non_nullable
              as List<KindOfProduct>,
      productList: null == productList
          ? _value._productList
          : productList // ignore: cast_nullable_to_non_nullable
              as List<SeriesOfProduct>,
      menuIndexPath: null == menuIndexPath
          ? _value._menuIndexPath
          : menuIndexPath // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      scannedList: null == scannedList
          ? _value._scannedList
          : scannedList // ignore: cast_nullable_to_non_nullable
              as List<IotDevice>,
      selectedIdx: freezed == selectedIdx
          ? _value.selectedIdx
          : selectedIdx // ignore: cast_nullable_to_non_nullable
              as DMIndexPath?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProdcutListUiStateImpl implements _ProdcutListUiState {
  _$ProdcutListUiStateImpl(
      {this.loading = false,
      final List<KindOfProduct> menuList = const [],
      final List<SeriesOfProduct> productList = const [],
      final Map<String, dynamic> menuIndexPath = const {},
      final List<IotDevice> scannedList = const [],
      this.selectedIdx})
      : _menuList = menuList,
        _productList = productList,
        _menuIndexPath = menuIndexPath,
        _scannedList = scannedList;

  factory _$ProdcutListUiStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProdcutListUiStateImplFromJson(json);

  @override
  @JsonKey()
  final bool loading;
  final List<KindOfProduct> _menuList;
  @override
  @JsonKey()
  List<KindOfProduct> get menuList {
    if (_menuList is EqualUnmodifiableListView) return _menuList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_menuList);
  }

  final List<SeriesOfProduct> _productList;
  @override
  @JsonKey()
  List<SeriesOfProduct> get productList {
    if (_productList is EqualUnmodifiableListView) return _productList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productList);
  }

  final Map<String, dynamic> _menuIndexPath;
  @override
  @JsonKey()
  Map<String, dynamic> get menuIndexPath {
    if (_menuIndexPath is EqualUnmodifiableMapView) return _menuIndexPath;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_menuIndexPath);
  }

  final List<IotDevice> _scannedList;
  @override
  @JsonKey()
  List<IotDevice> get scannedList {
    if (_scannedList is EqualUnmodifiableListView) return _scannedList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scannedList);
  }

  @override
  final DMIndexPath? selectedIdx;

  @override
  String toString() {
    return 'ProdcutListUiState(loading: $loading, menuList: $menuList, productList: $productList, menuIndexPath: $menuIndexPath, scannedList: $scannedList, selectedIdx: $selectedIdx)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProdcutListUiStateImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._menuList, _menuList) &&
            const DeepCollectionEquality()
                .equals(other._productList, _productList) &&
            const DeepCollectionEquality()
                .equals(other._menuIndexPath, _menuIndexPath) &&
            const DeepCollectionEquality()
                .equals(other._scannedList, _scannedList) &&
            (identical(other.selectedIdx, selectedIdx) ||
                other.selectedIdx == selectedIdx));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      const DeepCollectionEquality().hash(_menuList),
      const DeepCollectionEquality().hash(_productList),
      const DeepCollectionEquality().hash(_menuIndexPath),
      const DeepCollectionEquality().hash(_scannedList),
      selectedIdx);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProdcutListUiStateImplCopyWith<_$ProdcutListUiStateImpl> get copyWith =>
      __$$ProdcutListUiStateImplCopyWithImpl<_$ProdcutListUiStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProdcutListUiStateImplToJson(
      this,
    );
  }
}

abstract class _ProdcutListUiState implements ProdcutListUiState {
  factory _ProdcutListUiState(
      {final bool loading,
      final List<KindOfProduct> menuList,
      final List<SeriesOfProduct> productList,
      final Map<String, dynamic> menuIndexPath,
      final List<IotDevice> scannedList,
      final DMIndexPath? selectedIdx}) = _$ProdcutListUiStateImpl;

  factory _ProdcutListUiState.fromJson(Map<String, dynamic> json) =
      _$ProdcutListUiStateImpl.fromJson;

  @override
  bool get loading;
  @override
  List<KindOfProduct> get menuList;
  @override
  List<SeriesOfProduct> get productList;
  @override
  Map<String, dynamic> get menuIndexPath;
  @override
  List<IotDevice> get scannedList;
  @override
  DMIndexPath? get selectedIdx;
  @override
  @JsonKey(ignore: true)
  _$$ProdcutListUiStateImplCopyWith<_$ProdcutListUiStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DMIndexPath _$DMIndexPathFromJson(Map<String, dynamic> json) {
  return _DMIndexPath.fromJson(json);
}

/// @nodoc
mixin _$DMIndexPath {
  int get section => throw _privateConstructorUsedError;
  set section(int value) => throw _privateConstructorUsedError;
  int get row => throw _privateConstructorUsedError;
  set row(int value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DMIndexPathCopyWith<DMIndexPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DMIndexPathCopyWith<$Res> {
  factory $DMIndexPathCopyWith(
          DMIndexPath value, $Res Function(DMIndexPath) then) =
      _$DMIndexPathCopyWithImpl<$Res, DMIndexPath>;
  @useResult
  $Res call({int section, int row});
}

/// @nodoc
class _$DMIndexPathCopyWithImpl<$Res, $Val extends DMIndexPath>
    implements $DMIndexPathCopyWith<$Res> {
  _$DMIndexPathCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? section = null,
    Object? row = null,
  }) {
    return _then(_value.copyWith(
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DMIndexPathImplCopyWith<$Res>
    implements $DMIndexPathCopyWith<$Res> {
  factory _$$DMIndexPathImplCopyWith(
          _$DMIndexPathImpl value, $Res Function(_$DMIndexPathImpl) then) =
      __$$DMIndexPathImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int section, int row});
}

/// @nodoc
class __$$DMIndexPathImplCopyWithImpl<$Res>
    extends _$DMIndexPathCopyWithImpl<$Res, _$DMIndexPathImpl>
    implements _$$DMIndexPathImplCopyWith<$Res> {
  __$$DMIndexPathImplCopyWithImpl(
      _$DMIndexPathImpl _value, $Res Function(_$DMIndexPathImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? section = null,
    Object? row = null,
  }) {
    return _then(_$DMIndexPathImpl(
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DMIndexPathImpl extends _DMIndexPath {
  _$DMIndexPathImpl({this.section = 0, this.row = 0}) : super._();

  factory _$DMIndexPathImpl.fromJson(Map<String, dynamic> json) =>
      _$$DMIndexPathImplFromJson(json);

  @override
  @JsonKey()
  int section;
  @override
  @JsonKey()
  int row;

  @override
  String toString() {
    return 'DMIndexPath(section: $section, row: $row)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DMIndexPathImplCopyWith<_$DMIndexPathImpl> get copyWith =>
      __$$DMIndexPathImplCopyWithImpl<_$DMIndexPathImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DMIndexPathImplToJson(
      this,
    );
  }
}

abstract class _DMIndexPath extends DMIndexPath {
  factory _DMIndexPath({int section, int row}) = _$DMIndexPathImpl;
  _DMIndexPath._() : super._();

  factory _DMIndexPath.fromJson(Map<String, dynamic> json) =
      _$DMIndexPathImpl.fromJson;

  @override
  int get section;
  set section(int value);
  @override
  int get row;
  set row(int value);
  @override
  @JsonKey(ignore: true)
  _$$DMIndexPathImplCopyWith<_$DMIndexPathImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
