// ignore_for_file: avoid_public_notifier_properties
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_model.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_reponsitory.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_setting_state_notifier.g.dart';

@riverpod
class MessageSettingNotifier extends _$MessageSettingNotifier {
  @override
  MessageSettingUiState build() {
    return const MessageSettingUiState();
  }

  bool showServiceItem = false;

  Future<void> initData() async {
    final country = await LocalModule().getCurrentCountry();
    final userInfo = await AccountModule().getUserInfo();
    final region = country.countryCode;
    if (region.toLowerCase() == 'cn' &&
        userInfo?.phoneCode == '86' &&
        userInfo?.phone?.length == 11) {
      showServiceItem = false;
    }
  }

  Future<void> getMessageSet() async {
    try {
      MessageGetModel messageGetModel =
          await ref.watch(messageSettingRepositoryProvider).messageGet();
      _udpateTopState(messageGetModel);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  Future<void> putMessageSet(MessageSetModel model) async {
    try {
      MessageGetModel messageGetModel =
          await ref.watch(messageSettingRepositoryProvider).messageSet(model);
      _udpateTopState(messageGetModel);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  Future<void> getDefaultServerData() async {
    try {
      MessageSettingModel messageSetingModel =
          await ref.watch(messageSettingRepositoryProvider).getMessageSetting();
      _updateBottomState(messageSetingModel);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  Future<void> putMessageSettingWithServiceModel(
      ServiceSetingModel model) async {
    bool? notify = model.value == true ? false : true;
    ServiceSetingModel newServiceModel = model.copyWith(value: notify);

    /// 先更新UI
    switch (model.type) {
      case MessageSettingType.MessageSettingTypeSystem:
        {
          //特殊
          state = state.copyWith(systemMessage: newServiceModel);
          MessageSetModel newSetModel =
              MessageSetModel(msgSwitch: notify, msgType: 'system_msg_switch');
          _updateStateWithServiceModel(newServiceModel, newSetModel);
        }
      case MessageSettingType.MessageSettingTypeShare:
        {
          MessageSettingModel? currentModel =
              state.currentModel?.copyWith(devShare: newServiceModel.value);

          state = state.copyWith(shareMessage: newServiceModel);
          _updateStateWithServiceShareModel(newServiceModel, currentModel);
        }
      case MessageSettingType.MessageSettingTypeService:
        {
          //特殊
          state = state.copyWith(serviceMessage: newServiceModel);
          MessageSetModel newSetModel =
              MessageSetModel(msgSwitch: notify, msgType: 'service_msg_switch');
          _updateStateWithServiceModel(newServiceModel, newSetModel);
        }
      default:
        {}
    }
  }

  Future<void> putMessageSettingWithDeviceModel(
      final DeviceItemModel device) async {
    /// 先更新UI
    MessageSettingModel? currentModel = state.currentModel?.copyWith();
    List<DeviceItemModel> deviceList = [];
    for (var element in currentModel!.devices!) {
      DeviceItemModel newModel = element.copyWith();
      if (element.hashCode == device.hashCode) {
        newModel =
            element.copyWith(notify: (element.notify == true ? false : true));
      }
      deviceList.add(newModel);
    }
    state = state.copyWith(devieList: deviceList);

    /// 后更新接口
    MessageSettingModel? newCurrentModel =
        state.currentModel?.copyWith(devices: deviceList);
    try {
      var messageSetingModel = await ref
          .watch(messageSettingRepositoryProvider)
          .setMessageSetting(newCurrentModel!);
      _updateBottomState(messageSetingModel);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  /// 更新 系统消息/服务消息
  void _updateStateWithServiceModel(
      ServiceSetingModel newServiceModel, MessageSetModel newSetModel) async {
    try {
      await putMessageSet(newSetModel);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  /// 更新 共享消息
  void _updateStateWithServiceShareModel(ServiceSetingModel newServiceModel,
      MessageSettingModel? newCurrentModel) async {
    try {
      var messageSetingModel = await ref
          .watch(messageSettingRepositoryProvider)
          .setMessageSetting(newCurrentModel!);
      _updateBottomState(messageSetingModel);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  void _udpateTopState(MessageGetModel getModel) {
    ServiceSetingModel systemMessage = ServiceSetingModel(
        title: 'text_system_message'.tr(),
        subTitle: 'text_notification_status_tip'.tr(),
        value: getModel.systemMsgSwitch ?? false,
        type: MessageSettingType.MessageSettingTypeSystem);

    ServiceSetingModel? serviceMessage;
    if (showServiceItem) {
      serviceMessage = ServiceSetingModel(
          title: 'text_service_message'.tr(),
          subTitle: 'text_notification_server_tips'.tr(),
          value: getModel.serviceMsgSwitch ?? false,
          type: MessageSettingType.MessageSettingTypeService);
    }
    state = state.copyWith(
      systemMessage: systemMessage,
      serviceMessage: serviceMessage,
    );
  }

  void _updateBottomState(MessageSettingModel messageSetingModel) {
    ServiceSetingModel shareMessage = ServiceSetingModel(
        title: 'text_share_message'.tr(),
        subTitle: 'text_receive_device_sharing'.tr(),
        value: messageSetingModel.devShare ?? false,
        type: MessageSettingType.MessageSettingTypeShare);

    List<DeviceItemModel> devicelis = [];
    messageSetingModel.devices?.forEach((device) {
      devicelis.add(device);
    });

    state = state.copyWith(
      currentModel: messageSetingModel,
      devieList: devicelis,
      shareMessage: shareMessage,
    );
  }
}
