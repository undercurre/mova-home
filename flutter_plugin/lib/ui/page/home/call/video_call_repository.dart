import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
// import 'package:flutter_plugin/model/iot_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_call_repository.g.dart';

class VideoCallRepository {
  final ApiClient apiClient;

  VideoCallRepository(this.apiClient);

  Future<IotActionData> sendAction(String host, IotCommandRequest req) async {
    return apiClient.sendAction(host, req).then((value) {
      if (value.successed()) {
        return Future.value(value.data!);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
VideoCallRepository videoCallRepository(VideoCallRepositoryRef ref) {
  return VideoCallRepository(ref.watch(apiClientProvider));
}
