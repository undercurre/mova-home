import 'dart:convert';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/home/plugin/rn_plugin_update_model.dart';
import 'package:flutter_plugin/ui/page/message/device/device_message_ui_state.dart';
import 'package:flutter_plugin/ui/page/message/message_repository.dart';
import 'package:flutter_plugin/utils/dateformat_utils.dart';
import 'package:flutter_plugin/utils/exception/dreame_nothing_exception.dart';
import 'package:flutter_plugin/ui/widget/home/home_download_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_message_state_notifier.g.dart';

@riverpod
class DeviceMessageStateNotifier extends _$DeviceMessageStateNotifier {
  @override
  DeviceMessageUIState build() {
    return DeviceMessageUIState();
  }

  Future<void> initDeviceData(String did) async {
    state = state.copyWith(did: did);
    String langTag = await LocalModule().getLangTag();
    try {
      BaseDeviceModel deviceBean = await ref
          .watch(messageRepositoryProvider)
          .queryDeviceInfoById(did, langTag);
      state = state.copyWith(currentDevice: deviceBean);
    } catch (error) {
      LogUtils.e(error);
    }
  }

  Future<void> refreshMessageList({bool forceRead = false}) async {
    try {
      String langTag = await LocalModule().getLangTag();
      bool isChina =
          (await LocalModule().getCountryCode()).toLowerCase() == 'cn';
      state = state.copyWith(offset: 0);
      DeviceMessageModel deviceMessageModel = await ref
          .watch(messageRepositoryProvider)
          .getDeviceMessageList(state.did ?? '', langTag, state.offset,
              forceRead: forceRead);
      bool isSelectAll = state.isSelectAll;
      Map<String, List<Content>> messageList =
          _convertMessage(deviceMessageModel, langTag, isChina, isSelectAll);
      state = state.copyWith(
          messageList: messageList,
          offset: state.offset + deviceMessageModel.content!.length);
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  Future<bool> loadMoreMessageList() async {
    try {
      String langTag = await LocalModule().getLangTag();
      bool isChina =
          (await LocalModule().getCountryCode()).toLowerCase() == 'cn';

      DeviceMessageModel deviceMessageModel = await ref
          .watch(messageRepositoryProvider)
          .getDeviceMessageList(state.did ?? '', langTag, state.offset);
      bool isSelectAll = state.isSelectAll;
      Map<String, List<Content>> moreMessageList =
          _convertMessage(deviceMessageModel, langTag, isChina, isSelectAll);
      Map<String, List<Content>> messageList = state.messageList ?? {};
      for (var element in moreMessageList.keys) {
        List<Content>? list = messageList[element];
        if (list != null) {
          list.addAll(moreMessageList[element] ?? []);
        } else {
          messageList[element] = moreMessageList[element]!;
        }
      }
      state = state.copyWith(
          messageList: messageList,
          offset: state.offset + deviceMessageModel.content!.length);

      if (deviceMessageModel.content != null &&
          deviceMessageModel.content!.length >= 20) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
    return Future.value(false);
  }

  Map<String, List<Content>> _convertMessage(DeviceMessageModel messageModel,
      String langTag, bool isChina, bool isSelectAll) {
    String defaultLangTag = '';
    if (isChina) {
      defaultLangTag = 'zh';
    } else {
      defaultLangTag = 'en';
    }

    Map<String, List<Content>> messageList = {};
    messageModel.content?.forEach((item) {
      String time =
          DateFormatUtils.formatLocal(item.sendTime!, format: 'yyyy-MM-dd');

      String symbol = '';
      if (item.type == 1) {
        if (langTag.contains('zh')) {
          symbol = '，';
        } else {
          symbol = ',';
        }
      }
      item.localizationTitle =
          '${item.localizationContents?[langTag] ?? item.localizationContents?[defaultLangTag] ?? ''}$symbol';
      if (isSelectAll) {
        item.isSelect = true;
      }
      List<Content> list = messageList[time] ?? [];
      list.add(item);
      messageList[time] = list;
    });
    return messageList;
  }

  void setEdit(bool edit) {
    state.messageList?.values.forEach((list) {
      list.forEach((element) {
        element.isSelect = false;
      });
    });

    state = state.copyWith(
        isEdit: edit, isSelectAll: false, messageList: state.messageList);
  }

  void setSelectAll(bool selectAll) {
    state.messageList?.values.forEach((list) {
      list.forEach((element) {
        element.isSelect = selectAll;
      });
    });

    state =
        state.copyWith(isSelectAll: selectAll, messageList: state.messageList);
  }

  void setItemSelectStatus(Content? content) {
    if (content != null) {
      int currentMessageTotal = 0;
      int count = 0;
      state.messageList?.values.forEach((list) {
        currentMessageTotal += list.length;
        list.forEach((element) {
          if (element.messageId == content.messageId) {
            element.isSelect = !element.isSelect;
          }
          if (element.isSelect) {
            count += 1;
          }
        });
      });

      state = state.copyWith(
          isSelectAll: currentMessageTotal == count,
          messageList: state.messageList);
    }
  }

  void checkoutSelectMessage() {
    List<String> msgIds = [];
    state.messageList?.entries.forEach((entry) {
      entry.value.forEach((element) {
        if (element.isSelect) {
          msgIds.add(element.messageId ?? '');
        }
      });
    });
    if (msgIds.isEmpty) {
      state = state.copyWith(
          uiEvent: ToastEvent(text: 'prompt_select_delete_msg'.tr()));
    } else {
      state = state.copyWith(
          uiEvent: AlertEvent(
        content: 'prompt_delete_select_msg'.tr(),
        confirmContent: 'confirm'.tr(),
        cancelContent: 'cancel'.tr(),
        confirmCallback: () {
          deleteMessage();
        },
      ));
    }
  }

  Future<void> deleteMessage() async {
    try {
      List<String> msgIds = [];

      Map<String, List<Content>> newMessageList = {};
      state.messageList?.entries.forEach((entry) {
        List<Content> contentList = [];
        entry.value.forEach((element) {
          if (element.isSelect) {
            msgIds.add(element.messageId ?? '');
          } else {
            contentList.add(element);
          }
        });
        if (contentList.isNotEmpty) {
          newMessageList[entry.key] = contentList;
        }
      });
      Map<String, String> params = {"msgIds": msgIds.join(",")};
      var ret =
          await ref.watch(messageRepositoryProvider).deleteMessages(params);
      if (ret) {
        state = state.copyWith(
            messageList: newMessageList,
            uiEvent: ToastEvent(text: 'delete_success'.tr()));
        setEdit(false);
      }
    } catch (error) {
      LogUtils.e(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  /// 打开插件
  void openPlugin(bool showWarn, SourceModel? source) {
    String entranceType = showWarn ? 'warn' : 'main';
    var warnCode = source?.value ?? '';
    var sourceStr = '';
    if (source != null) {
      sourceStr = json.encode(source);
    }
    if (state.currentDevice == null) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    } else {
      ref
          .read(pluginProvider.notifier)
          .updateRNPlugin(state.currentDevice!.model,
        tag: state.currentDevice!.did,
        updateCallback: (showLoading) {
          if (showLoading) {
            SmartDialog.show(
                keepSingle: true,
                clickMaskDismiss: false,
                animationType: SmartAnimationType.fade,
                builder: (context) {
                  return HomeDownloadWidget(
                    deviceBean: state.currentDevice!,
                  );
                },
                onDismiss: () {
                  ref
                      .read(pluginProvider.notifier)
                      .hideUpdatePlugin(state.currentDevice!.did);
                });
          }
        },
      )
          .then((pluginInfo) async {
        if (pluginInfo != null) {
          if (!pluginInfo.hide) {
            SmartDialog.dismiss();
            if (pluginInfo.code == incompatible) {
              state = state.copyWith(
                  uiEvent: AlertEvent(
                content: 'Popup_DevicePage_PluginRequest_Failed'.tr(),
                confirmContent: 'upgrade'.tr(),
                cancelContent: 'cancel'.tr(),
                confirmCallback: () {
                  UIModule().openAppStore();
                },
              ));
            } else if (pluginInfo.code == downloadFail) {
              state = state.copyWith(
                  uiEvent: AlertEvent(
                content: 'Popup_DevicePage_PluginLoading_Failed'.tr(),
                confirmContent: 'retry'.tr(),
                cancelContent: 'cancel'.tr(),
                confirmCallback: () {
                  openPlugin(showWarn, source);
                },
              ));
            } else if (pluginInfo.code == netError) {
              state = state.copyWith(
                  uiEvent: AlertEvent(
                content: 'Popup_DevicePage_PluginDownloading_Failed'.tr(),
                confirmContent: 'retry'.tr(),
                cancelContent: 'cancel'.tr(),
                confirmCallback: () {
                  openPlugin(showWarn, source);
                },
              ));
            } else {
              await UIModule().openPlugin(
                  entranceType, state.currentDevice!, pluginInfo,
                  warnCode: warnCode, showWarn: showWarn, source: sourceStr);
            }
          }
        } else {
          state =
              state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
        }
      }).catchError((err) {
        if (err is DreameCancelException) {
        } else {
          SmartDialog.dismiss();
        }
      });
    }
  }
}
