import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'command_state_notifier.g.dart';

@riverpod
class FastCommandStateNotifier extends _$FastCommandStateNotifier {
  Completer<bool>? _completer;

  @override
  CommonUIEvent? build() {
    return null;
  }

  Future<bool> onFastCommandClick(FastCommandModel command) {
    if (_completer == null || _completer!.isCompleted) {
      _completer = Completer<bool>();
    }
    final device =
        ref.read(homeStateNotifierProvider).currentDevice as VacuumDeviceModel?;
    if (device == null) {
      state = ToastEvent(text: 'operate_failed'.tr());
      _completer?.complete(false);
    } else {
      int latestStatus = device.latestStatus;
      if (latestStatus == 16) {
        state = ToastEvent(text: 'text_dock_self_test_tip'.tr());
        _completer?.complete(false);
      } else if (latestStatus == 19) {
        state = ToastEvent(text: 'text_shangxiashui_check_tip'.tr());
        _completer?.complete(false);
      } else {
        var executingFastCommand = device.getExecutingFastCommand();
        if (executingFastCommand == null) {
          if (device.isCanStopFastCMD()) {
            _interceptTask(() {
              ref.read(homeStateNotifierProvider.notifier).stopTask(device,
                  delayNext: true,
                  nextTask: () => executeCommand(device, command.id));
            });
          } else {
            executeCommand(device, command.id);
          }
        } else {
          if (executingFastCommand.id == command.id) {
            if (executingFastCommand.state == '1') {
              pauseOrResume(device, 2);
            } else if (executingFastCommand.state == '0') {
              pauseOrResume(device, 1);
            } else {
              executeCommand(device, command.id);
            }
          } else {
            //其他快捷指令正在执行或者暂停状态
            if (executingFastCommand.state == '1' ||
                executingFastCommand.state == '0') {
              _interceptTask(() {
                ref.read(homeStateNotifierProvider.notifier).stopTask(device,
                    delayNext: true,
                    nextTask: () => executeCommand(device, command.id));
              });
            } else {
              executeCommand(device, command.id);
            }
          }
        }
      }
    }
    return _completer!.future;
  }

  void _interceptTask(Function nextTask) {
    state = state = AlertEvent(
      content: 'text_operation_interrupt_task_continue'.tr(),
      confirmContent: 'confirm'.tr(),
      cancelContent: 'cancel'.tr(),
      confirmCallback: () => nextTask.call(),
    );
  }

  Future<void> executeCommand(
      VacuumDeviceModel currentDevice, int commandId) async {
    final iotParams =
        IotParams(did: currentDevice.did, siid: 4, aiid: 1, inList: [
      const InDTO(piid: 1, value: 25),
      InDTO(piid: 10, value: '$commandId'),
      InDTO(piid: 100, value: '25,{"task_id":$commandId}'),
    ]);
    IotActionData? value = await ref
        .read(homeStateNotifierProvider.notifier)
        .sendAction(currentDevice, iotParams);
    if (value != null) {
      _completer?.complete(true);
    } else {
      _completer?.complete(false);
    }
  }

  Future<void> pauseOrResume(VacuumDeviceModel currentDevice, int aiid) async {
    final iotParams =
        IotParams(did: currentDevice.did, siid: 2, aiid: aiid, inList: [
      InDTO(
          piid: 100,
          value: aiid == 1 ? '2,1,{"app_auto_clean":1}' : '1,{"app_pause":1}')
    ]);
    IotActionData? value = await ref
        .read(homeStateNotifierProvider.notifier)
        .sendAction(currentDevice, iotParams);
    if (value != null) {
      _completer?.complete(true);
    } else {
      _completer?.complete(false);
    }
  }
}
