import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_plugin/common/download/download_result.dart';
import 'package:flutter_plugin/common/download/download_state.dart';
import 'package:flutter_plugin/common/download/download_task.dart';
import 'package:flutter_plugin/utils/LogUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_provider.g.dart';

@riverpod
class DownLoad extends _$DownLoad {
  final int _limit = 4;
  LinkedHashMap<String, DownloadTask> _cachedTasks = LinkedHashMap();
  final Set<DownloadTask> _downloadingTasks = {}; // 已经进入下载流程的队列
  @override
  DownloadState build() {
    return DownloadState(downloadStates: <String, DownloadResult>{});
  }

  void checkDownloadQueue() {
    int total = 0;
    if (_cachedTasks.isEmpty) {
      return;
    }
    for (int i = 0; i < _cachedTasks.length; i++) {
      final item = _cachedTasks.entries.elementAt(i);
      if (item.value.taskStatus == TaskStatus.downloading ||
          item.value.taskStatus == TaskStatus.paused) {
        continue;
      }
      if (total > _limit && item.value.immediate != true) {
        continue;
      }
      total++;
      // 防止调用多次checkDownloadQueue，多次加入相同的task，导致出错
      if (_downloadingTasks.add(item.value)) {
        startDownload(item.value).then((value) {
          _downloadingTasks.remove(value);
        }).catchError((error) {
          _downloadingTasks.remove(item.value);
          debugPrint('Download failed: $error');
        });
      }
    }
  }

  Future<void> addDownloadTask(DownloadTask newTask) async {
    DownloadResult downloadResult = DownloadResult();
    DownloadTask? downloadTask = _cachedTasks[newTask.url];
    if (newTask.url == null || newTask.targetPath == null) {
      newTask.downloadCallback
          ?.call(downloadResult..taskResultStatus = TaskResultStatus.argsError);
      return;
    }
    if (downloadTask != null && downloadTask.url != null) {
      newTask.downloadCallback?.call(
          downloadResult..taskResultStatus = TaskResultStatus.downloading);
      return;
    }
    newTask.cancelToken ??= CancelToken();

    if (newTask.tmpPath == null || newTask.tmpPath?.isEmpty == true) {
      Directory? appDocumentsDir = await getApplicationDocumentsDirectory();
      newTask.tmpPath =
          '${appDocumentsDir.path}/tmp/${md5.convert(utf8.encode(newTask.url!))}${DateTime.now().millisecondsSinceEpoch}.zip';
    }
    final cachedTask = <String, DownloadTask>{newTask.url!: newTask};
    LinkedHashMap<String, DownloadTask> map = LinkedHashMap();
    map.addAll(_cachedTasks..addEntries(cachedTask.entries));
    _cachedTasks = map;
    checkDownloadQueue();
    newTask.downloadCallback
        ?.call(downloadResult..taskResultStatus = TaskResultStatus.watting);
  }

  Future<String> calculateFileMd5Stream(String filePath,
      {int bufferSize = 128 * 1024}) async {
    RandomAccessFile? raf;

    try {
      // 直接打开文件，避免额外的文件系统调用
      raf = await File(filePath).open();

      // 通过已打开的文件句柄获取文件大小，避免重复访问
      final fileSize = await raf.length();
      if (fileSize == 0) return '';

      final digestSink = AccumulatorSink<Digest>();
      final md5Sink = md5.startChunkedConversion(digestSink);

      int offset = 0;
      while (offset < fileSize) {
        final remaining = fileSize - offset;
        final toRead = remaining < bufferSize ? remaining : bufferSize;

        final bytes = await raf.read(toRead);
        if (bytes.isEmpty) break;

        md5Sink.add(bytes);
        offset += toRead;
      }

      md5Sink.close();
      return digestSink.events.single.toString();
    } on FileSystemException catch (e) {
      throw Exception('File access error: $filePath - ${e.message}');
    } catch (e) {
      LogUtils.e('MD5计算错误: $e');
      rethrow;
    } finally {
      await raf?.close();
    }
  }

  Future<bool> checkFileWithMD5(String path, String md5Str) async {
    try {
      final calculatedMd5 = await calculateFileMd5Stream(path);
      return calculatedMd5.isNotEmpty && md5Str == calculatedMd5;
    } catch (e) {
      LogUtils.e('MD5校验失败: $e');
      return false;
    }
  }

  Future<String> extractFile(String sourcePath, String targetPath,
      {String? foldName}) async {
    Directory? appDocumentsDir = await getApplicationDocumentsDirectory();
    final zipFile = File(sourcePath); // 使用传入的 sourcePath
    Directory targetDir = Directory('${appDocumentsDir.path}/$targetPath');

    if (targetDir.existsSync()) {
      targetDir.deleteSync(recursive: true);
    }
    LogUtils.i('最终解压路径：${targetDir.path}');

    // 解压主压缩文件 文件格式不对, 可能会抛出异常
    await ZipFile.extractToDirectory(
        zipFile: zipFile, destinationDir: targetDir);
    if (foldName != null && foldName.isNotEmpty) {
      List<FileSystemEntity> folds = targetDir.listSync();
      if (folds.isNotEmpty && folds.length == 1) {
        folds[0].renameSync('${targetDir.path}/$foldName');
        return '$targetPath/$foldName';
      }
    }
    return targetPath;
  }

  Future<DownloadResult> startDownload(DownloadTask downloadTask) async {
    Directory? appDocumentsDir = await getApplicationDocumentsDirectory();
    downloadTask.tmpPath ??=
        '${appDocumentsDir.path}/tmp/${md5.convert(utf8.encode(downloadTask.url!))}${DateTime.now().millisecondsSinceEpoch}.zip';

    ///如果有checkFileName且没有md5返回参数异常，停止下载
    DownloadResult downloadResult =
        DownloadResult(type: downloadTask.type, tmpPath: downloadTask.tmpPath);
    if (downloadTask.checkFileName != null && downloadTask.md5 == null) {
      downloadTask.downloadCallback
          ?.call(downloadResult..taskResultStatus = TaskResultStatus.argsError);
    }
    // int partialFileLength = 0;
    // if (downloadTask.tmpPath != null &&
    //     downloadTask.tmpPath?.isNotEmpty == true) {
    //   File file = File(downloadTask.tmpPath!);
    //   if (file.existsSync()) {
    //     partialFileLength = file.lengthSync();
    //   }
    // }
    downloadTask.taskStatus = TaskStatus.downloading;
    final map = _cachedTasks..[downloadTask.url!] = downloadTask;
    _cachedTasks = map;
    // checkDownloadQueue();
    state = state.copyWith(
        downloadStates: state.downloadStates
          ..[downloadTask.type!] = downloadResult);
    return DMHttpManager().create(
        receiveTimeout: const Duration(seconds: 300),
        connectTimeout: const Duration(seconds: 300),
        interceptorTypes: [InterceptorType.none]).download(
      downloadTask.url!,
      downloadTask.tmpPath,
      cancelToken: downloadTask.cancelToken,
      onReceiveProgress: ((count, total) {
        downloadTask.downloadCallback?.call(downloadResult
          ..total = total
          ..current = count
          ..taskResultStatus = TaskResultStatus.downloading);
        state = state.copyWith(
            downloadStates: state.downloadStates
              ..[downloadTask.type!] = downloadResult);
      }),
    ).then((val) async {
      ///如果包含checkFileName则先解压，再使用md5检测该文件
      ///如果没有md5直接解压并返回成功
      downloadTask.downloadCallback
          ?.call(downloadResult..taskResultStatus = TaskResultStatus.checking);
      if (downloadTask.checkFileName == null &&
          downloadTask.md5 != null &&
          downloadTask.md5?.isNotEmpty == true) {
        if (await checkFileWithMD5(downloadTask.tmpPath!, downloadTask.md5!)) {
          downloadResult.taskResultStatus = TaskResultStatus.wattingforunzip;
        } else {
          downloadResult.taskResultStatus = TaskResultStatus.checkError;
        }
      } else {
        downloadResult.taskResultStatus = TaskResultStatus.wattingforunzip;
      }
      downloadTask.downloadCallback?.call(downloadResult);
      if (downloadResult.taskResultStatus == TaskResultStatus.wattingforunzip) {
        return extractFile(downloadTask.tmpPath!, downloadTask.targetPath!,
            foldName: downloadTask.type);
      }
    }).then((value) async {
      downloadResult.finalPath = value;
      if (downloadTask.checkFileName != null && downloadTask.md5 != null) {
        final bundleFilePath =
            '${appDocumentsDir.path}/${downloadTask.targetPath}/${downloadTask.type}/${downloadTask.checkFileName}';
        if (await checkFileWithMD5(bundleFilePath, downloadTask.md5!)) {
          downloadResult.taskResultStatus = TaskResultStatus.success;
        } else {
          downloadResult.taskResultStatus = TaskResultStatus.checkError;
        }
      } else {
        downloadResult.taskResultStatus = TaskResultStatus.success;
      }
      _cachedTasks = _cachedTasks..remove(downloadTask.url);
      checkDownloadQueue();
      downloadTask.downloadCallback?.call(downloadResult);
      state = state.copyWith(
          downloadStates: state.downloadStates..remove(downloadTask.type!));
      return downloadResult;
    }).catchError((error) {
      LogUtils.e('start download task error === $error');
      if (error.error == TaskStatus.paused) {
        downloadTask.downloadCallback
            ?.call(downloadResult..taskResultStatus = TaskResultStatus.pause);
      } else if (error.error == TaskStatus.cancel) {
        _cachedTasks = _cachedTasks..remove(downloadTask.url);
        checkDownloadQueue();
        downloadTask.downloadCallback?.call(downloadResult
          ..current = 0
          ..taskResultStatus = TaskResultStatus.cancel);
        throw error;
      } else {
        _cachedTasks = _cachedTasks..remove(downloadTask.url);
        checkDownloadQueue();
        downloadTask.downloadCallback?.call(downloadResult
          ..current = 0
          ..taskResultStatus = TaskResultStatus.downloadError);
        state = state.copyWith(
            downloadStates: state.downloadStates
              ..[downloadTask.type!] = downloadResult);
        throw error;
      }
      state = state.copyWith(
          downloadStates: state.downloadStates
            ..[downloadTask.type!] = downloadResult);
      return downloadResult;
    });
  }

  void cancelAll() {
    _cachedTasks.forEach((key, value) {
      value.cancelToken?.cancel(TaskStatus.cancel);
    });
    _cachedTasks.clear();
  }

  void cancelDownload(String url, {String reason = 'unknow'}) {
    DownloadTask? downloadTask = _cachedTasks[url];
    if (downloadTask != null && downloadTask.cancelToken != null) {
      downloadTask.cancelToken?.cancel(reason);
      _cachedTasks = _cachedTasks..remove(url);
      checkDownloadQueue();
    }
  }

  /// fds不支持续传
  void pauseDownload(String url) {
    DownloadTask? downloadTask = _cachedTasks[url];
    if (downloadTask != null && downloadTask.cancelToken != null) {
      downloadTask.cancelToken?.cancel(TaskStatus.paused);
      downloadTask.taskStatus = TaskStatus.paused;
      _cachedTasks = _cachedTasks..[url] = downloadTask;
      checkDownloadQueue();
    }
  }

  /// fds不支持续传
  void resumeDownload(String url) {
    DownloadTask? downloadTask = _cachedTasks[url];
    if (downloadTask != null && downloadTask.taskStatus == TaskStatus.paused) {
      downloadTask.cancelToken = CancelToken();
      downloadTask.taskStatus = TaskStatus.resume;
      _cachedTasks = _cachedTasks..[url] = downloadTask;
      checkDownloadQueue();
    }
  }
}
