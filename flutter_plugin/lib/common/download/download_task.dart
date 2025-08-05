import 'package:dio/dio.dart';
import 'package:flutter_plugin/common/download/download_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_task.freezed.dart';

enum TaskStatus { watting, downloading, paused, resume, cancel }

@unfreezed
class DownloadTask with _$DownloadTask {
  factory DownloadTask(
      {@required String? url,
      @required String? targetPath,
      String? tmpPath, //缓存目录，非必填
      String? md5, // 文件md5
      @Default(false) bool immediate,
      @required String? type,
      String? checkFileName, //如果包含checkFileName，则使用md5检测该文件，否则检测zip包
      @Default(TaskStatus.watting) TaskStatus taskStatus,
      DownloadCallback? downloadCallback,
      CancelToken? cancelToken}) = _DownloadTask;
}
