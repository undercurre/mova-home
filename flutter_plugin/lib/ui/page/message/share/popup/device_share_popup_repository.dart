import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'device_share_popup_repository.g.dart';

class DeviceSharePopupRepository {
  final ApiClient apiClient;

  DeviceSharePopupRepository(this.apiClient);

  Future<bool> ackShareFromMessage(String messageId, bool accept) async {
    return apiClient
        .ackShareFromMessage(messageId, {'accept': accept}).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> ackShareFromDevice(
      bool accept, String deviceId, String model, String ownUid) async {
    return apiClient.ackShareFromDevice({
      'accept': accept,
      'deviceId': deviceId,
      'model': model,
      'ownUid': ownUid
    }).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> readMessageById(String messageId) async {
    return apiClient.readShareMessageByIds({'msgIds': messageId}).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
DeviceSharePopupRepository deviceSharePopupRepositoryProvider(
    DeviceSharePopupRepositoryProviderRef ref) {
  return DeviceSharePopupRepository(ref.watch(apiClientProvider));
}
