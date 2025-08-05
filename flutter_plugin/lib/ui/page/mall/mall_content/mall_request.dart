import 'package:flutter_plugin/utils/logutils.dart';

class MallRequest {
  static MallRequest parse(String? path) {
    path = path ?? '';
    Map<String, String> queryParameters = {};
    try {
      Uri ur = Uri.parse(path.trim());
      queryParameters = ur.queryParameters;
    } catch (e) {
      LogUtils.e('parse mall request error: $e');
    }
    return MallRequest(
        path: path, queryParameters: queryParameters);
  }

  MallRequest({required this.path, this.queryParameters});
  String path;
  Map<String, String>? queryParameters;
}
