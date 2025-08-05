import 'dart:collection';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/message/common_message_record_model.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_repository.g.dart';

class MessageRepository {
  final ApiClient apiClient;
  final MessageRepositoryRef ref;
  MessageRepository(this.ref, this.apiClient);

  Future<MessageMainModel> getMessageHomeRecord(String version) async {
    return apiClient.getMessageHomeRecord(version).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<dynamic> markAllMessageRead() async {
    return apiClient.markAllMessageRead().then((value) {
      return Future.value(value.data);
    });
  }

  Future<List<ShareMessageModel>> getShareMessageList(int limit, int offset,
      {bool forceRead = false}) {
    return apiClient.getShareMessageList(limit, offset, 'v1').then((value) {
      if (value.successed()) {
        if (offset == 0 &&
            value.data?.content?.isNotEmpty == true &&
            forceRead) {
          apiClient.readAllShareMessage();
        }
        return Future.value(value.data?.content);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  void readShareMessageByIds(String? msgIds) {
    Map<String, String>? param = HashMap();
    if (msgIds?.isNotEmpty == false) {
      param['msgIds'] = msgIds!;
    }
    apiClient.readShareMessageByIds(param);
  }

  Future<dynamic> deleteShareMessage(String? msgIds) {
    return apiClient.deleteShareMessage(msgIds).then((value) {
      try {
        LogUtils.i(
            '[message] MessageRepository deleteShareMessage value: ${value.toString()}');
        if (value.successed()) {
          return Future.value(value.data);
        } else {
          return Future.error(DreameException(value.code, value.msg));
        }
      } catch (e) {
        LogUtils.e('[message] MessageRepository deleteShareMessage error: $e');
      }
    });
  }

  Future<bool> deleteMessages(Map<String, String> req) async {
    return apiClient.deleteMessages(req).then((value) {
      try {
        LogUtils.i(
            '[message] MessageRepository deleteMessages value: ${value.toString()}');
        return Future.value(value.successed());
      } catch (e) {
        LogUtils.e('[message] MessageRepository deleteMessages error: $e');
        return Future.value(false);
      }
    });
  }

  Future<DeviceMessageModel> getDeviceMessageList(
      String did, String language, int offset,
      {int limit = 20, bool forceRead = false}) async {
    LogUtils.i(
        '[message] MessageRepository getDeviceMessageList did: $did, language: $language, offset: $offset, limit: $limit, forceRead: $forceRead');
    return apiClient
        .getDeviceMessageList(did, language, offset, limit)
        .then((value) {
      if (value.successed()) {
        LogUtils.i(
            '[message] MessageRepository getDeviceMessageList offset: $offset, forceRead: $forceRead');
        if (offset == 0 && forceRead) {
          apiClient.setMessagesReadByDid(did);
        }
        return Future.value(value.data);
      } else {
        LogUtils.i(
            '[message] MessageRepository getDeviceMessageList response: failed');
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<List<CommonMsgRecord>> getCommonMessageRecord(
      String msgCategory, int currentTimeStamp, int page, int size,
      {bool forceRead = false, Function(bool)? readCallback}) {
    return apiClient
        .getCommonMessageRecord(msgCategory, currentTimeStamp, page, size)
        .then((value) {
      if (value.successed()) {
        if (page == 1 && value.data?.records?.isNotEmpty == true && forceRead) {
          apiClient
              .readMessageByCategory(msgCategory)
              .then((value) => readCallback?.call(value.successed()));
        }
        return Future.value(value.data?.records ?? []);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<dynamic> deleteCommonMessage(String msgIds) {
    return apiClient.deleteCommonMessageRecord(msgIds).then((value) {
      try {
        LogUtils.i(
            '[message] MessageRepository deleteShareMessage value: ${value.toString()}');
        return Future.value(value.data);
      } catch (e) {
        LogUtils.e('[message] MessageRepository deleteShareMessage error: $e');
      }
    });
  }

  Future<dynamic> clearCommonMessageRecord(String msgCategory) async {
    return apiClient.clearCommonMessageRecord(msgCategory).then((value) {
      return Future.value(value.data);
    });
  }

  Future<BaseDeviceModel> queryDeviceInfoById(String did, String lang) {
    var deviceList = ref.read(homeStateNotifierProvider).deviceList;
    var device = deviceList.firstWhereOrNull((element) => element.did == did);
    if (device != null) {
      return Future.value(device);
    }
    return apiClient
        .queryDeviceInfoByDid({'did': did, 'lang': lang}).then((value) {
      if (value.successed()) {
        return Future.value(BaseDeviceModel.fromDevice(value.data!));
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
MessageRepository messageRepository(MessageRepositoryRef ref) {
  return MessageRepository(ref, ref.watch(apiClientProvider));
}
