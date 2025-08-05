import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/home/plugin/rn_plugin_update_model.dart';
import 'package:flutter_plugin/ui/page/message/message_repository.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_ui_state.dart';
import 'package:flutter_plugin/utils/exception/dreame_nothing_exception.dart';
import 'package:flutter_plugin/ui/widget/home/home_download_widget.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_message_list_notifier.g.dart';

@riverpod
class ShareMessageListNotifier extends _$ShareMessageListNotifier {
  List<ShareMessageModel> _cachedList = [];
  @override
  ShareMessageListUiState build() {
    return ShareMessageListUiState();
  }

  Future<void> refreshShareMessage({bool forceRead = false}) async {
    try {
      bool afterSaleEnable = await ref
          .read(developerMenuPageStateNotifierProvider.notifier)
          .getAfterSaleEnable();
      state = state.copyWith(offset: 0, limit: afterSaleEnable ? 1000 : 10);
      List<ShareMessageModel> shareMessageList = await ref
          .watch(messageRepositoryProvider)
          .getShareMessageList(state.limit, state.offset, forceRead: forceRead);
      state =
          state.copyWith(shareMessageList: await convertList(shareMessageList));
      _cachedList = state.shareMessageList;
      int offset = state.offset + shareMessageList.length;
      state = state.copyWith(offset: offset);
    } catch (error) {
      LogUtils.d(error);
    }
  }

  void filterLocalData(String text) {
    List<ShareMessageModel> shareMessageList = [];
    if (text.isEmpty) {
      shareMessageList = _cachedList;
    } else {
      shareMessageList = _cachedList.where((e) {
        return e.deviceId.toString().contains(text) ||
            (e.ownUid != null &&
                e.ownUid!.toLowerCase().contains(text.toLowerCase()));
      }).toList();
    }
    state = state.copyWith(shareMessageList: shareMessageList, searchKey: text);
  }

  Future<List<ShareMessageModel>> convertList(
      List<ShareMessageModel> shareMessageList) async {
    String langTag = await LocalModule().getLangTag();
    bool isChina = (await LocalModule().getCountryCode()).toLowerCase() == 'cn';
    List<ShareMessageModel> msgList = [];
    for (var shareMsg in shareMessageList) {
      String messageContent = '';
      String? owner =
          (shareMsg.ownUsername != null && shareMsg.ownUsername!.isNotEmpty)
              ? shareMsg.ownUsername
              : shareMsg.ownUid;
      if (shareMsg.needAck == true) {
        messageContent = 'someone_invited_you_to_share'.tr(args: [owner ?? '']);
      } else {
        String? share = (shareMsg.shareUsername != null &&
                shareMsg.shareUsername!.isNotEmpty)
            ? shareMsg.shareUsername
            : shareMsg.shareUid;
        if (shareMsg.ackResult == 1) {
          //已接收
          messageContent =
              'someone_accepted_your_share'.tr(args: [share ?? '']);
        } else if (shareMsg.ackResult == 2) {
          //已拒绝
          messageContent =
              'someone_rejected_your_share'.tr(args: [share ?? '']);
        } else if (shareMsg.ackResult == 4) {
          //主人撤销共享
          messageContent = 'text_master_cancel_share'.tr(args: [owner ?? '']);
        } else if (shareMsg.ackResult == 5) {
          //被分享者删除设备
          messageContent =
              'text_others_removed_shared_device'.tr(args: [share ?? '']);
        } else if (shareMsg.ackResult == 6) {
          //更新权限
          messageContent =
              'text_device_permission_changed'.tr(args: [owner ?? '']);
        }
      }
      msgList.add(shareMsg.copyWith(
          langTagContent: messageContent,
          langTagDeviceName: _getContentByLangTag(
              shareMsg.localizationDeviceNames, langTag, isChina),
          langTagMsg: _getContentByLangTag(
              shareMsg.localizationContents, langTag, isChina)));
    }
    return Future.value(msgList);
  }

  Future<bool> loadMoreShareMessage() async {
    try {
      if (state.searchKey.isNotEmpty) {
        state = state.copyWith(shareMessageList: _cachedList);
      }
      List<ShareMessageModel> shareMessageList = await ref
          .watch(messageRepositoryProvider)
          .getShareMessageList(state.limit, state.offset);
      var moreList = await convertList(shareMessageList);
      state = state
          .copyWith(shareMessageList: [...state.shareMessageList, ...moreList]);
      _cachedList = state.shareMessageList;
      int offset = state.offset + shareMessageList.length;
      state = state.copyWith(offset: offset);
      if (shareMessageList.length >= state.limit) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (error) {
      LogUtils.d(error);
    }
    return Future.value(false);
  }

  Future<void> deleteShareMessageByMsgId(String msgId) async {
    try {
      await ref.watch(messageRepositoryProvider).deleteShareMessage(msgId);
      List<ShareMessageModel> list = [...state.shareMessageList];
      list.removeWhere((element) {
        return element.messageId == msgId;
      });
      state = state.copyWith(
          shareMessageList: list,
          uiEvent: ToastEvent(text: 'delete_success'.tr()));
    } catch (error) {
      LogUtils.d(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  Future<void> clearShareMessage() async {
    try {
      await ref.watch(messageRepositoryProvider).deleteShareMessage(null);
      state = state.copyWith(
          shareMessageList: [],
          uiEvent: ToastEvent(text: 'delete_success'.tr()));
    } catch (error) {
      LogUtils.d(error);
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    }
  }

  String _getContentByLangTag(
      Map<String, String>? displayMap, String langTag, bool isChina) {
    var langDisplay = displayMap?[langTag];
    if (langDisplay != null) {
      return langDisplay;
    }
    if (isChina) {
      return displayMap?['zh'] ?? '';
    } else {
      return displayMap?['en'] ?? '';
    }
  }

  Future<void> openPlugin(String entranceType, String? deviceId) async {
    if (deviceId == null) {
      state = state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
    } else {
      String langTag = await LocalModule().getLangTag();
      try {
        BaseDeviceModel deviceBean = await ref
            .watch(messageRepositoryProvider)
            .queryDeviceInfoById(deviceId.toString(), langTag);
        await ref
            .read(pluginProvider.notifier)
            .updateRNPlugin(deviceBean.model,
            tag: deviceBean.did, updateCallback: (showLoading) {
          SmartDialog.show(
              keepSingle: true,
              clickMaskDismiss: false,
              animationType: SmartAnimationType.fade,
              builder: (context) {
                return HomeDownloadWidget(
                  deviceBean: deviceBean,
                );
              },
              onDismiss: () {
                ref
                    .read(pluginProvider.notifier)
                    .hideUpdatePlugin(deviceBean.did);
              });
        })
            .then((pluginInfo) async {
          if (pluginInfo != null) {
            if (!pluginInfo.hide) {
              await SmartDialog.dismiss();
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
                    openPlugin(entranceType, deviceId);
                  },
                ));
              } else if (pluginInfo.code == netError) {
                state = state.copyWith(
                    uiEvent: AlertEvent(
                  content: 'Popup_DevicePage_PluginDownloading_Failed'.tr(),
                  confirmContent: 'retry'.tr(),
                  cancelContent: 'cancel'.tr(),
                  confirmCallback: () {
                    openPlugin(entranceType, deviceId);
                  },
                ));
              } else {
                await UIModule()
                    .openPlugin(entranceType, deviceBean, pluginInfo);
              }
            }
          } else {
            state = state.copyWith(
                uiEvent: ToastEvent(text: 'operate_failed'.tr()));
          }
        });
      } on DreameException catch (e) {
        if (e is DreameCancelException) {
        } else {
          state = state.copyWith(uiEvent: ToastEvent(text: e.message ?? ''));
        }
      } catch (error) {
        LogUtils.e(error);
        state =
            state.copyWith(uiEvent: ToastEvent(text: 'operate_failed'.tr()));
      }
    }
  }
}
