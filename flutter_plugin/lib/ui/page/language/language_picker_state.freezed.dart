// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language_picker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LanguagePickerState {
  List<LanguageModel> get languages => throw _privateConstructorUsedError;
  LanguageModel? get selectLanguage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LanguagePickerStateCopyWith<LanguagePickerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguagePickerStateCopyWith<$Res> {
  factory $LanguagePickerStateCopyWith(
          LanguagePickerState value, $Res Function(LanguagePickerState) then) =
      _$LanguagePickerStateCopyWithImpl<$Res, LanguagePickerState>;
  @useResult
  $Res call({List<LanguageModel> languages, LanguageModel? selectLanguage});

  $LanguageModelCopyWith<$Res>? get selectLanguage;
}

/// @nodoc
class _$LanguagePickerStateCopyWithImpl<$Res, $Val extends LanguagePickerState>
    implements $LanguagePickerStateCopyWith<$Res> {
  _$LanguagePickerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languages = null,
    Object? selectLanguage = freezed,
  }) {
    return _then(_value.copyWith(
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageModel>,
      selectLanguage: freezed == selectLanguage
          ? _value.selectLanguage
          : selectLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LanguageModelCopyWith<$Res>? get selectLanguage {
    if (_value.selectLanguage == null) {
      return null;
    }

    return $LanguageModelCopyWith<$Res>(_value.selectLanguage!, (value) {
      return _then(_value.copyWith(selectLanguage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LanguagePickerStateImplCopyWith<$Res>
    implements $LanguagePickerStateCopyWith<$Res> {
  factory _$$LanguagePickerStateImplCopyWith(_$LanguagePickerStateImpl value,
          $Res Function(_$LanguagePickerStateImpl) then) =
      __$$LanguagePickerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LanguageModel> languages, LanguageModel? selectLanguage});

  @override
  $LanguageModelCopyWith<$Res>? get selectLanguage;
}

/// @nodoc
class __$$LanguagePickerStateImplCopyWithImpl<$Res>
    extends _$LanguagePickerStateCopyWithImpl<$Res, _$LanguagePickerStateImpl>
    implements _$$LanguagePickerStateImplCopyWith<$Res> {
  __$$LanguagePickerStateImplCopyWithImpl(_$LanguagePickerStateImpl _value,
      $Res Function(_$LanguagePickerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languages = null,
    Object? selectLanguage = freezed,
  }) {
    return _then(_$LanguagePickerStateImpl(
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageModel>,
      selectLanguage: freezed == selectLanguage
          ? _value.selectLanguage
          : selectLanguage // ignore: cast_nullable_to_non_nullable
              as LanguageModel?,
    ));
  }
}

/// @nodoc

class _$LanguagePickerStateImpl implements _LanguagePickerState {
  const _$LanguagePickerStateImpl(
      {final List<LanguageModel> languages = const [], this.selectLanguage})
      : _languages = languages;

  final List<LanguageModel> _languages;
  @override
  @JsonKey()
  List<LanguageModel> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  @override
  final LanguageModel? selectLanguage;

  @override
  String toString() {
    return 'LanguagePickerState(languages: $languages, selectLanguage: $selectLanguage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguagePickerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.selectLanguage, selectLanguage) ||
                other.selectLanguage == selectLanguage));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_languages), selectLanguage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguagePickerStateImplCopyWith<_$LanguagePickerStateImpl> get copyWith =>
      __$$LanguagePickerStateImplCopyWithImpl<_$LanguagePickerStateImpl>(
          this, _$identity);
}

abstract class _LanguagePickerState implements LanguagePickerState {
  const factory _LanguagePickerState(
      {final List<LanguageModel> languages,
      final LanguageModel? selectLanguage}) = _$LanguagePickerStateImpl;

  @override
  List<LanguageModel> get languages;
  @override
  LanguageModel? get selectLanguage;
  @override
  @JsonKey(ignore: true)
  _$$LanguagePickerStateImplCopyWith<_$LanguagePickerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
