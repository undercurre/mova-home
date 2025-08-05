import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_call_state.freezed.dart';

@freezed
class VideoCallState with _$VideoCallState {
  factory VideoCallState(
      {BaseDeviceModel? currentDevice,
      String? deviceName,
      CommonUIEvent? uiEvent}) = _VideoCallState;
}
