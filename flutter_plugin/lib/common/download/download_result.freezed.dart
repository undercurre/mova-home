// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DownloadResult {
  int get total => throw _privateConstructorUsedError;
  set total(int value) => throw _privateConstructorUsedError;
  int get current => throw _privateConstructorUsedError;
  set current(int value) => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  set type(String? value) => throw _privateConstructorUsedError;
  String? get finalPath => throw _privateConstructorUsedError;
  set finalPath(String? value) => throw _privateConstructorUsedError;
  String? get tmpPath => throw _privateConstructorUsedError;
  set tmpPath(String? value) => throw _privateConstructorUsedError;
  TaskResultStatus? get taskResultStatus => throw _privateConstructorUsedError;
  set taskResultStatus(TaskResultStatus? value) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DownloadResultCopyWith<DownloadResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadResultCopyWith<$Res> {
  factory $DownloadResultCopyWith(
          DownloadResult value, $Res Function(DownloadResult) then) =
      _$DownloadResultCopyWithImpl<$Res, DownloadResult>;
  @useResult
  $Res call(
      {int total,
      int current,
      String? type,
      String? finalPath,
      String? tmpPath,
      TaskResultStatus? taskResultStatus});
}

/// @nodoc
class _$DownloadResultCopyWithImpl<$Res, $Val extends DownloadResult>
    implements $DownloadResultCopyWith<$Res> {
  _$DownloadResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? current = null,
    Object? type = freezed,
    Object? finalPath = freezed,
    Object? tmpPath = freezed,
    Object? taskResultStatus = freezed,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      finalPath: freezed == finalPath
          ? _value.finalPath
          : finalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      tmpPath: freezed == tmpPath
          ? _value.tmpPath
          : tmpPath // ignore: cast_nullable_to_non_nullable
              as String?,
      taskResultStatus: freezed == taskResultStatus
          ? _value.taskResultStatus
          : taskResultStatus // ignore: cast_nullable_to_non_nullable
              as TaskResultStatus?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadResultImplCopyWith<$Res>
    implements $DownloadResultCopyWith<$Res> {
  factory _$$DownloadResultImplCopyWith(_$DownloadResultImpl value,
          $Res Function(_$DownloadResultImpl) then) =
      __$$DownloadResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int current,
      String? type,
      String? finalPath,
      String? tmpPath,
      TaskResultStatus? taskResultStatus});
}

/// @nodoc
class __$$DownloadResultImplCopyWithImpl<$Res>
    extends _$DownloadResultCopyWithImpl<$Res, _$DownloadResultImpl>
    implements _$$DownloadResultImplCopyWith<$Res> {
  __$$DownloadResultImplCopyWithImpl(
      _$DownloadResultImpl _value, $Res Function(_$DownloadResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? current = null,
    Object? type = freezed,
    Object? finalPath = freezed,
    Object? tmpPath = freezed,
    Object? taskResultStatus = freezed,
  }) {
    return _then(_$DownloadResultImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      finalPath: freezed == finalPath
          ? _value.finalPath
          : finalPath // ignore: cast_nullable_to_non_nullable
              as String?,
      tmpPath: freezed == tmpPath
          ? _value.tmpPath
          : tmpPath // ignore: cast_nullable_to_non_nullable
              as String?,
      taskResultStatus: freezed == taskResultStatus
          ? _value.taskResultStatus
          : taskResultStatus // ignore: cast_nullable_to_non_nullable
              as TaskResultStatus?,
    ));
  }
}

/// @nodoc

class _$DownloadResultImpl extends _DownloadResult {
  _$DownloadResultImpl(
      {this.total = 0,
      this.current = 0,
      this.type,
      this.finalPath,
      this.tmpPath,
      this.taskResultStatus})
      : super._();

  @override
  @JsonKey()
  int total;
  @override
  @JsonKey()
  int current;
  @override
  String? type;
  @override
  String? finalPath;
  @override
  String? tmpPath;
  @override
  TaskResultStatus? taskResultStatus;

  @override
  String toString() {
    return 'DownloadResult(total: $total, current: $current, type: $type, finalPath: $finalPath, tmpPath: $tmpPath, taskResultStatus: $taskResultStatus)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadResultImplCopyWith<_$DownloadResultImpl> get copyWith =>
      __$$DownloadResultImplCopyWithImpl<_$DownloadResultImpl>(
          this, _$identity);
}

abstract class _DownloadResult extends DownloadResult {
  factory _DownloadResult(
      {int total,
      int current,
      String? type,
      String? finalPath,
      String? tmpPath,
      TaskResultStatus? taskResultStatus}) = _$DownloadResultImpl;
  _DownloadResult._() : super._();

  @override
  int get total;
  set total(int value);
  @override
  int get current;
  set current(int value);
  @override
  String? get type;
  set type(String? value);
  @override
  String? get finalPath;
  set finalPath(String? value);
  @override
  String? get tmpPath;
  set tmpPath(String? value);
  @override
  TaskResultStatus? get taskResultStatus;
  set taskResultStatus(TaskResultStatus? value);
  @override
  @JsonKey(ignore: true)
  _$$DownloadResultImplCopyWith<_$DownloadResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
