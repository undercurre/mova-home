// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_report_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuestionReportUiState {
  List<QuestionReportItem> get reports => throw _privateConstructorUsedError;
  CommonUIEvent get event => throw _privateConstructorUsedError;
  bool get appFeedbackIsCheck => throw _privateConstructorUsedError;
  bool get submitEnable => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QuestionReportUiStateCopyWith<QuestionReportUiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionReportUiStateCopyWith<$Res> {
  factory $QuestionReportUiStateCopyWith(QuestionReportUiState value,
          $Res Function(QuestionReportUiState) then) =
      _$QuestionReportUiStateCopyWithImpl<$Res, QuestionReportUiState>;
  @useResult
  $Res call(
      {List<QuestionReportItem> reports,
      CommonUIEvent event,
      bool appFeedbackIsCheck,
      bool submitEnable});
}

/// @nodoc
class _$QuestionReportUiStateCopyWithImpl<$Res,
        $Val extends QuestionReportUiState>
    implements $QuestionReportUiStateCopyWith<$Res> {
  _$QuestionReportUiStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reports = null,
    Object? event = null,
    Object? appFeedbackIsCheck = null,
    Object? submitEnable = null,
  }) {
    return _then(_value.copyWith(
      reports: null == reports
          ? _value.reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<QuestionReportItem>,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      appFeedbackIsCheck: null == appFeedbackIsCheck
          ? _value.appFeedbackIsCheck
          : appFeedbackIsCheck // ignore: cast_nullable_to_non_nullable
              as bool,
      submitEnable: null == submitEnable
          ? _value.submitEnable
          : submitEnable // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionReportUiStateImplCopyWith<$Res>
    implements $QuestionReportUiStateCopyWith<$Res> {
  factory _$$QuestionReportUiStateImplCopyWith(
          _$QuestionReportUiStateImpl value,
          $Res Function(_$QuestionReportUiStateImpl) then) =
      __$$QuestionReportUiStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<QuestionReportItem> reports,
      CommonUIEvent event,
      bool appFeedbackIsCheck,
      bool submitEnable});
}

/// @nodoc
class __$$QuestionReportUiStateImplCopyWithImpl<$Res>
    extends _$QuestionReportUiStateCopyWithImpl<$Res,
        _$QuestionReportUiStateImpl>
    implements _$$QuestionReportUiStateImplCopyWith<$Res> {
  __$$QuestionReportUiStateImplCopyWithImpl(_$QuestionReportUiStateImpl _value,
      $Res Function(_$QuestionReportUiStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reports = null,
    Object? event = null,
    Object? appFeedbackIsCheck = null,
    Object? submitEnable = null,
  }) {
    return _then(_$QuestionReportUiStateImpl(
      reports: null == reports
          ? _value._reports
          : reports // ignore: cast_nullable_to_non_nullable
              as List<QuestionReportItem>,
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as CommonUIEvent,
      appFeedbackIsCheck: null == appFeedbackIsCheck
          ? _value.appFeedbackIsCheck
          : appFeedbackIsCheck // ignore: cast_nullable_to_non_nullable
              as bool,
      submitEnable: null == submitEnable
          ? _value.submitEnable
          : submitEnable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$QuestionReportUiStateImpl implements _QuestionReportUiState {
  const _$QuestionReportUiStateImpl(
      {final List<QuestionReportItem> reports = const [],
      this.event = const EmptyEvent(),
      this.appFeedbackIsCheck = true,
      this.submitEnable = false})
      : _reports = reports;

  final List<QuestionReportItem> _reports;
  @override
  @JsonKey()
  List<QuestionReportItem> get reports {
    if (_reports is EqualUnmodifiableListView) return _reports;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reports);
  }

  @override
  @JsonKey()
  final CommonUIEvent event;
  @override
  @JsonKey()
  final bool appFeedbackIsCheck;
  @override
  @JsonKey()
  final bool submitEnable;

  @override
  String toString() {
    return 'QuestionReportUiState(reports: $reports, event: $event, appFeedbackIsCheck: $appFeedbackIsCheck, submitEnable: $submitEnable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionReportUiStateImpl &&
            const DeepCollectionEquality().equals(other._reports, _reports) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.appFeedbackIsCheck, appFeedbackIsCheck) ||
                other.appFeedbackIsCheck == appFeedbackIsCheck) &&
            (identical(other.submitEnable, submitEnable) ||
                other.submitEnable == submitEnable));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_reports),
      event,
      appFeedbackIsCheck,
      submitEnable);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionReportUiStateImplCopyWith<_$QuestionReportUiStateImpl>
      get copyWith => __$$QuestionReportUiStateImplCopyWithImpl<
          _$QuestionReportUiStateImpl>(this, _$identity);
}

abstract class _QuestionReportUiState implements QuestionReportUiState {
  const factory _QuestionReportUiState(
      {final List<QuestionReportItem> reports,
      final CommonUIEvent event,
      final bool appFeedbackIsCheck,
      final bool submitEnable}) = _$QuestionReportUiStateImpl;

  @override
  List<QuestionReportItem> get reports;
  @override
  CommonUIEvent get event;
  @override
  bool get appFeedbackIsCheck;
  @override
  bool get submitEnable;
  @override
  @JsonKey(ignore: true)
  _$$QuestionReportUiStateImplCopyWith<_$QuestionReportUiStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
