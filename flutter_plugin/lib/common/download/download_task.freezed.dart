// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DownloadTask {
  String? get url => throw _privateConstructorUsedError;
  set url(String? value) => throw _privateConstructorUsedError;
  String? get targetPath => throw _privateConstructorUsedError;
  set targetPath(String? value) => throw _privateConstructorUsedError;
  String? get tmpPath => throw _privateConstructorUsedError;
  set tmpPath(String? value) => throw _privateConstructorUsedError; //缓存目录，非必填
  String? get md5 => throw _privateConstructorUsedError; //缓存目录，非必填
  set md5(String? value) => throw _privateConstructorUsedError; // 文件md5
  bool get immediate => throw _privateConstructorUsedError; // 文件md5
  set immediate(bool value) => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  set type(String? value) => throw _privateConstructorUsedError;
  String? get checkFileName => throw _privateConstructorUsedError;
  set checkFileName(String? value) =>
      throw _privateConstructorUsedError; //如果包含checkFileName，则使用md5检测该文件，否则检测zip包
  TaskStatus get taskStatus =>
      throw _privateConstructorUsedError; //如果包含checkFileName，则使用md5检测该文件，否则检测zip包
  set taskStatus(TaskStatus value) => throw _privateConstructorUsedError;
  DownloadCallback? get downloadCallback => throw _privateConstructorUsedError;
  set downloadCallback(DownloadCallback? value) =>
      throw _privateConstructorUsedError;
  CancelToken? get cancelToken => throw _privateConstructorUsedError;
  set cancelToken(CancelToken? value) => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DownloadTaskCopyWith<DownloadTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadTaskCopyWith<$Res> {
  factory $DownloadTaskCopyWith(
          DownloadTask value, $Res Function(DownloadTask) then) =
      _$DownloadTaskCopyWithImpl<$Res, DownloadTask>;
  @useResult
  $Res call(
      {String? url,
      String? targetPath,
      String? tmpPath,
      String? md5,
      bool immediate,
      String? type,
      String? checkFileName,
      TaskStatus taskStatus,
      DownloadCallback? downloadCallback,
      CancelToken? cancelToken});
}

/// @nodoc
class _$DownloadTaskCopyWithImpl<$Res, $Val extends DownloadTask>
    implements $DownloadTaskCopyWith<$Res> {
  _$DownloadTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? targetPath = freezed,
    Object? tmpPath = freezed,
    Object? md5 = freezed,
    Object? immediate = null,
    Object? type = freezed,
    Object? checkFileName = freezed,
    Object? taskStatus = null,
    Object? downloadCallback = freezed,
    Object? cancelToken = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      targetPath: freezed == targetPath
          ? _value.targetPath
          : targetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      tmpPath: freezed == tmpPath
          ? _value.tmpPath
          : tmpPath // ignore: cast_nullable_to_non_nullable
              as String?,
      md5: freezed == md5
          ? _value.md5
          : md5 // ignore: cast_nullable_to_non_nullable
              as String?,
      immediate: null == immediate
          ? _value.immediate
          : immediate // ignore: cast_nullable_to_non_nullable
              as bool,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      checkFileName: freezed == checkFileName
          ? _value.checkFileName
          : checkFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      taskStatus: null == taskStatus
          ? _value.taskStatus
          : taskStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      downloadCallback: freezed == downloadCallback
          ? _value.downloadCallback
          : downloadCallback // ignore: cast_nullable_to_non_nullable
              as DownloadCallback?,
      cancelToken: freezed == cancelToken
          ? _value.cancelToken
          : cancelToken // ignore: cast_nullable_to_non_nullable
              as CancelToken?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DownloadTaskImplCopyWith<$Res>
    implements $DownloadTaskCopyWith<$Res> {
  factory _$$DownloadTaskImplCopyWith(
          _$DownloadTaskImpl value, $Res Function(_$DownloadTaskImpl) then) =
      __$$DownloadTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? url,
      String? targetPath,
      String? tmpPath,
      String? md5,
      bool immediate,
      String? type,
      String? checkFileName,
      TaskStatus taskStatus,
      DownloadCallback? downloadCallback,
      CancelToken? cancelToken});
}

/// @nodoc
class __$$DownloadTaskImplCopyWithImpl<$Res>
    extends _$DownloadTaskCopyWithImpl<$Res, _$DownloadTaskImpl>
    implements _$$DownloadTaskImplCopyWith<$Res> {
  __$$DownloadTaskImplCopyWithImpl(
      _$DownloadTaskImpl _value, $Res Function(_$DownloadTaskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? targetPath = freezed,
    Object? tmpPath = freezed,
    Object? md5 = freezed,
    Object? immediate = null,
    Object? type = freezed,
    Object? checkFileName = freezed,
    Object? taskStatus = null,
    Object? downloadCallback = freezed,
    Object? cancelToken = freezed,
  }) {
    return _then(_$DownloadTaskImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      targetPath: freezed == targetPath
          ? _value.targetPath
          : targetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      tmpPath: freezed == tmpPath
          ? _value.tmpPath
          : tmpPath // ignore: cast_nullable_to_non_nullable
              as String?,
      md5: freezed == md5
          ? _value.md5
          : md5 // ignore: cast_nullable_to_non_nullable
              as String?,
      immediate: null == immediate
          ? _value.immediate
          : immediate // ignore: cast_nullable_to_non_nullable
              as bool,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      checkFileName: freezed == checkFileName
          ? _value.checkFileName
          : checkFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      taskStatus: null == taskStatus
          ? _value.taskStatus
          : taskStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      downloadCallback: freezed == downloadCallback
          ? _value.downloadCallback
          : downloadCallback // ignore: cast_nullable_to_non_nullable
              as DownloadCallback?,
      cancelToken: freezed == cancelToken
          ? _value.cancelToken
          : cancelToken // ignore: cast_nullable_to_non_nullable
              as CancelToken?,
    ));
  }
}

/// @nodoc

class _$DownloadTaskImpl implements _DownloadTask {
  _$DownloadTaskImpl(
      {this.url,
      this.targetPath,
      this.tmpPath,
      this.md5,
      this.immediate = false,
      this.type,
      this.checkFileName,
      this.taskStatus = TaskStatus.watting,
      this.downloadCallback,
      this.cancelToken});

  @override
  String? url;
  @override
  String? targetPath;
  @override
  String? tmpPath;
//缓存目录，非必填
  @override
  String? md5;
// 文件md5
  @override
  @JsonKey()
  bool immediate;
  @override
  String? type;
  @override
  String? checkFileName;
//如果包含checkFileName，则使用md5检测该文件，否则检测zip包
  @override
  @JsonKey()
  TaskStatus taskStatus;
  @override
  DownloadCallback? downloadCallback;
  @override
  CancelToken? cancelToken;

  @override
  String toString() {
    return 'DownloadTask(url: $url, targetPath: $targetPath, tmpPath: $tmpPath, md5: $md5, immediate: $immediate, type: $type, checkFileName: $checkFileName, taskStatus: $taskStatus, downloadCallback: $downloadCallback, cancelToken: $cancelToken)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadTaskImplCopyWith<_$DownloadTaskImpl> get copyWith =>
      __$$DownloadTaskImplCopyWithImpl<_$DownloadTaskImpl>(this, _$identity);
}

abstract class _DownloadTask implements DownloadTask {
  factory _DownloadTask(
      {String? url,
      String? targetPath,
      String? tmpPath,
      String? md5,
      bool immediate,
      String? type,
      String? checkFileName,
      TaskStatus taskStatus,
      DownloadCallback? downloadCallback,
      CancelToken? cancelToken}) = _$DownloadTaskImpl;

  @override
  String? get url;
  set url(String? value);
  @override
  String? get targetPath;
  set targetPath(String? value);
  @override
  String? get tmpPath;
  set tmpPath(String? value);
  @override //缓存目录，非必填
  String? get md5; //缓存目录，非必填
  set md5(String? value);
  @override // 文件md5
  bool get immediate; // 文件md5
  set immediate(bool value);
  @override
  String? get type;
  set type(String? value);
  @override
  String? get checkFileName;
  set checkFileName(String? value);
  @override //如果包含checkFileName，则使用md5检测该文件，否则检测zip包
  TaskStatus get taskStatus; //如果包含checkFileName，则使用md5检测该文件，否则检测zip包
  set taskStatus(TaskStatus value);
  @override
  DownloadCallback? get downloadCallback;
  set downloadCallback(DownloadCallback? value);
  @override
  CancelToken? get cancelToken;
  set cancelToken(CancelToken? value);
  @override
  @JsonKey(ignore: true)
  _$$DownloadTaskImplCopyWith<_$DownloadTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
