import 'package:flutter_plugin/common/download/download_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_state.freezed.dart';

@unfreezed
class DownloadState with _$DownloadState {
  factory DownloadState(
          {@Default({}) Map<String, DownloadResult> downloadStates}) =
      _DownloadState;
  DownloadState._();
}
