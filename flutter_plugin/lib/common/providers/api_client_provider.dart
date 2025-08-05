import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'api_client_provider.g.dart';

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  var dio = ref.watch(dioProvider);
  return ApiClient(dio: dio);
}
