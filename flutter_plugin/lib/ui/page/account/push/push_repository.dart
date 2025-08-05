import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'push_repository.g.dart';

class PushRepository {
  final ApiClient apiClient;

  PushRepository(this.apiClient);

  Future<bool> registerPushToken(Map<String, dynamic> req) async {
    return apiClient.registerPushToken(req).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<bool> removePushToken(Map<String, dynamic> req) async {
    return apiClient.removePushToken(req).then((value) {
      if (value.successed()) {
        return Future.value(true);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
PushRepository pushRepository(PushRepositoryRef ref) {
  return PushRepository(ref.watch(apiClientProvider));
}
