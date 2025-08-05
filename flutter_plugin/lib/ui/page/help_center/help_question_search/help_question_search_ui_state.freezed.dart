// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_question_search_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HelpQuestionSearchUiState {
  CommonUIEvent get event => throw _privateConstructorUsedError;
  List<AppFaq>? get faqs => throw _privateConstructorUsedError;
  String? get searchText => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HelpQuestionSearchUiStateCopyWith<HelpQuestionSearchUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HelpQuestionSearchUiStateCopyWith<$Res> {
  factory $HelpQuestionSearchUiStateCopyWith(HelpQuestionSearchUiState value,
          $Res Function(HelpQuestionSearchUiState) then) =
      _$HelpQuestionSearchUiStateCopyWithImpl<$Res, HelpQuestionSearchUiState>;
  @useResult
  $Res call({CommonUIEvent event, List<AppFaq>? faqs, String? searchText});
}

/// @nodoc
class _$HelpQuestionSearchUiStateCopyWithImpl<$Res,
        $Val extends HelpQuestionSearchUiState>
    implements $HelpQuestionSearchUiStateCopyWith<$Res> {
  _$HelpQuestionSearchUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? faqs = freezed,
    Object? searchText = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      faqs: freezed == faqs
          ? _value.faqs
          : faqs // ignore: cast_nullable_to_non_nullable
              as List<AppFaq>?,
      searchText: freezed == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HelpQuestionSearchUiStateImplCopyWith<$Res>
    implements $HelpQuestionSearchUiStateCopyWith<$Res> {
  factory _$$HelpQuestionSearchUiStateImplCopyWith(
          _$HelpQuestionSearchUiStateImpl value,
          $Res Function(_$HelpQuestionSearchUiStateImpl) then) =
      __$$HelpQuestionSearchUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CommonUIEvent event, List<AppFaq>? faqs, String? searchText});
}

/// @nodoc
class __$$HelpQuestionSearchUiStateImplCopyWithImpl<$Res>
    extends _$HelpQuestionSearchUiStateCopyWithImpl<$Res,
        _$HelpQuestionSearchUiStateImpl>
    implements _$$HelpQuestionSearchUiStateImplCopyWith<$Res> {
  __$$HelpQuestionSearchUiStateImplCopyWithImpl(
      _$HelpQuestionSearchUiStateImpl _value,
      $Res Function(_$HelpQuestionSearchUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? faqs = freezed,
    Object? searchText = freezed,
  }) {
    return _then(_$HelpQuestionSearchUiStateImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      faqs: freezed == faqs
          ? _value._faqs
          : faqs // ignore: cast_nullable_to_non_nullable
              as List<AppFaq>?,
      searchText: freezed == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HelpQuestionSearchUiStateImpl implements _HelpQuestionSearchUiState {
  const _$HelpQuestionSearchUiStateImpl(
      {this.event = const EmptyEvent(),
      final List<AppFaq>? faqs,
      this.searchText})
      : _faqs = faqs;

  @override
  @JsonKey()
  final CommonUIEvent event;
  final List<AppFaq>? _faqs;
  @override
  List<AppFaq>? get faqs {
    final value = _faqs;
    if (value == null) return null;
    if (_faqs is EqualUnmodifiableListView) return _faqs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? searchText;

  @override
  String toString() {
    return 'HelpQuestionSearchUiState(event: $event, faqs: $faqs, searchText: $searchText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HelpQuestionSearchUiStateImpl &&
            (identical(other.event, event) || other.event == event) &&
            const DeepCollectionEquality().equals(other._faqs, _faqs) &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event,
      const DeepCollectionEquality().hash(_faqs), searchText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HelpQuestionSearchUiStateImplCopyWith<_$HelpQuestionSearchUiStateImpl>
      get copyWith => __$$HelpQuestionSearchUiStateImplCopyWithImpl<
          _$HelpQuestionSearchUiStateImpl>(this, _$identity);
}

abstract class _HelpQuestionSearchUiState implements HelpQuestionSearchUiState {
  const factory _HelpQuestionSearchUiState(
      {final CommonUIEvent event,
      final List<AppFaq>? faqs,
      final String? searchText}) = _$HelpQuestionSearchUiStateImpl;

  @override
  CommonUIEvent get event;
  @override
  List<AppFaq>? get faqs;
  @override
  String? get searchText;
  @override
  @JsonKey(ignore: true)
  _$$HelpQuestionSearchUiStateImplCopyWith<_$HelpQuestionSearchUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
