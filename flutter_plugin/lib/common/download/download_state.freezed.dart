// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DownloadState {
  Map<String, DownloadResult> get downloadStates =>
      throw _privateConstructorUsedError;
  set downloadStates(Map<String, DownloadResult> value) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DownloadStateCopyWith<DownloadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadStateCopyWith<$Res> {
  factory $DownloadStateCopyWith(
          DownloadState value, $Res Function(DownloadState) then) =
      _$DownloadStateCopyWithImpl<$Res, DownloadState>;
  @useResult
  $Res call({Map<String, DownloadResult> downloadStates});
}

/// @nodoc
class _$DownloadStateCopyWithImpl<$Res, $Val extends DownloadState>
    implements $DownloadStateCopyWith<$Res> {
  _$DownloadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? downloadStates = null,
  }) {
    return _then(_value.copyWith(
      downloadStates: null == downloadStates
          ? _value.downloadStates
          : downloadStates // ignore: cast_nullable_to_non_nullable
              as Map<String, DownloadResult>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadStateImplCopyWith<$Res>
    implements $DownloadStateCopyWith<$Res> {
  factory _$$DownloadStateImplCopyWith(
          _$DownloadStateImpl value, $Res Function(_$DownloadStateImpl) then) =
      __$$DownloadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, DownloadResult> downloadStates});
}

/// @nodoc
class __$$DownloadStateImplCopyWithImpl<$Res>
    extends _$DownloadStateCopyWithImpl<$Res, _$DownloadStateImpl>
    implements _$$DownloadStateImplCopyWith<$Res> {
  __$$DownloadStateImplCopyWithImpl(
      _$DownloadStateImpl _value, $Res Function(_$DownloadStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? downloadStates = null,
  }) {
    return _then(_$DownloadStateImpl(
      downloadStates: null == downloadStates
          ? _value.downloadStates
          : downloadStates // ignore: cast_nullable_to_non_nullable
              as Map<String, DownloadResult>,
    ));
  }
}

/// @nodoc

class _$DownloadStateImpl extends _DownloadState {
  _$DownloadStateImpl({this.downloadStates = const {}}) : super._();

  @override
  @JsonKey()
  Map<String, DownloadResult> downloadStates;

  @override
  String toString() {
    return 'DownloadState(downloadStates: $downloadStates)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadStateImplCopyWith<_$DownloadStateImpl> get copyWith =>
      __$$DownloadStateImplCopyWithImpl<_$DownloadStateImpl>(this, _$identity);
}

abstract class _DownloadState extends DownloadState {
  factory _DownloadState({Map<String, DownloadResult> downloadStates}) =
      _$DownloadStateImpl;
  _DownloadState._() : super._();

  @override
  Map<String, DownloadResult> get downloadStates;
  set downloadStates(Map<String, DownloadResult> value);
  @override
  @JsonKey(ignore: true)
  _$$DownloadStateImplCopyWith<_$DownloadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
