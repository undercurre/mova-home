import 'dart:convert';
import 'dart:math';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/call/video_call_repository.dart';
import 'package:flutter_plugin/ui/page/home/call/video_call_state.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'video_call_state_notifier.g.dart';

@riverpod
class VideoCallStateNotifier extends _$VideoCallStateNotifier {
  bool _isCheckingCallStatus = false;

  @override
  VideoCallState build() {
    return VideoCallState();
  }

  Future<void> showVideoCall(String did,
      {bool timeout = false, bool fromPush = false}) async {
    if (timeout) {
      return;
    }
    if (_isCheckingCallStatus) {
      return;
    }
    try {
      final device = ref
          .watch(homeStateNotifierProvider)
          .deviceList
          .firstWhere((element) => element.did == did);
      if (!device.master) {
        return;
      }
      state = state.copyWith(currentDevice: device);
      final status = await checkCallStatus();
      // 0:无通话任务，1:等待服务器转播，2: 等待APP接听, 3:已接听
      if (status == '2') {
        MessageChannel().showVideoCall(json.encode(device));
      } else {
        if (fromPush) {
          // to-do
          await ref
              .watch(homeStateNotifierProvider.notifier)
              .onMonitroClick(device as VacuumDeviceModel);
        }
      }
    } catch (e) {
      debugPrint('find device error: not find device');
    }
  }

  void setDevice(BaseDeviceModel device) {
    state =
        state.copyWith(currentDevice: device, deviceName: device.getShowName());
  }

  Future<String> checkCallStatus() async {
    try {
      if (state.currentDevice == null) {
        return '';
      }
      _isCheckingCallStatus = true;
      var iotParams = IotParams(
          did: state.currentDevice!.did,
          siid: 10001,
          aiid: 6,
          inList: [const InDTO(piid: 201, value: 'check')]);
      var data =
          await sendAction(state.currentDevice!, iotParams, showMessage: false);
      _isCheckingCallStatus = false;
      if (data != null &&
          data.result.code == 0 &&
          data.result.out?.isNotEmpty == true) {
        return data.result.out![0].value ?? '';
      }
    } catch (e) {
      _isCheckingCallStatus = false;
      debugPrint('checkCallStatus error: $e');
    }
    return '';
  }

  Future<bool> acceptOrRejectCall(bool accept) async {
    try {
      if (state.currentDevice == null) {
        return false;
      }
      var iotParams = IotParams(
          did: state.currentDevice!.did,
          siid: 10001,
          aiid: 6,
          inList: [InDTO(piid: 201, value: accept ? 'accept' : 'reject')]);
      sendAction(state.currentDevice!, iotParams);
      return true;
    } catch (e) {
      return false;
    }
  }

  FutureOr<IotActionData?> sendAction(BaseDeviceModel device, IotParams params,
      {bool showMessage = true}) async {
    try {
      final requestId = Random().nextInt(500000) + 100;
      final id = requestId;
      final req = IotCommandRequest(device.did, id,
          IotActionCommandData(id: id, params: params, method: 'action'));
      final data = await ref
          .watch(videoCallRepositoryProvider)
          .sendAction(device.host(), req);
      return Future.value(data);
    } catch (error) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: showMessage ? 'operate_failed'.tr() : ''));
    }
    return null;
  }
}
