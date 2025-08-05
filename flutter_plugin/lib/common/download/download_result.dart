import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_result.freezed.dart';

enum TaskResultStatus {
  ///暂停
  pause,

  ///错误状态
  downloadError,
  unzipError,
  checkError,

  fileNotExists,
  argsError,
  cancel,

  watting,
  downloading,
  downloaded,
  checking,
  wattingforunzip,
  unzipping,
  success,
  noUpdateNeeded,
}

typedef DownloadCallback = void Function(DownloadResult downloadResult);

@unfreezed
class DownloadResult with _$DownloadResult {
  factory DownloadResult({
    @Default(0) int total,
    @Default(0) int current,
    String? type,
    String? finalPath,
    String? tmpPath,
    TaskResultStatus? taskResultStatus,
  }) = _DownloadResult;

  DownloadResult._();

  bool isError() {
    return taskResultStatus == TaskResultStatus.downloadError ||
        taskResultStatus == TaskResultStatus.checkError ||
        taskResultStatus == TaskResultStatus.fileNotExists ||
        taskResultStatus == TaskResultStatus.unzipError ||
        taskResultStatus == TaskResultStatus.argsError;
  }
}
