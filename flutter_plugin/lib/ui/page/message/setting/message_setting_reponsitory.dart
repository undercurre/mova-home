import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_setting_reponsitory.g.dart';

class MessageSettingRepository {
  final ApiClient apiClient;
  MessageSettingRepository(this.apiClient);

  Future<MessageSettingModel> getMessageSetting() async {
    return apiClient.messageSettingGet().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<MessageSettingModel> setMessageSetting(
      MessageSettingModel model) async {
    return apiClient.messageSettingSet(model.toJson()).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<MessageGetModel> messageGet() async {
    return apiClient.messageGet().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<MessageGetModel> messageSet(MessageSetModel model) async {
    return apiClient.messageSet(model.toJson()).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
MessageSettingRepository messageSettingRepository(
    MessageSettingRepositoryRef ref) {
  return MessageSettingRepository(ref.watch(apiClientProvider));
}
