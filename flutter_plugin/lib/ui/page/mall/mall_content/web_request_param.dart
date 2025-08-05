/*
 * @Author: lijiajia lijiajia@dreame.tech
 * @Date: 2023-07-21 11:23:34
 * @LastEditors: lijiajia lijiajia@dreame.tech
 * @LastEditTime: 2023-07-21 20:40:59
 * @FilePath: /flutter_plugin/lib/ui/page/mall/mall_content/web_request_param.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
sealed class WebRequestParam {
  // LoadRequestMethod method = LoadRequestMethod.get;
  // Map<String, String> headers = const <String, String>{};
  // Uint8List? body;
}

class AssetWebRequestParam extends WebRequestParam {
  AssetWebRequestParam(
      {required this.path, this.queryParameters, this.fragment});
  String path;
  Map<String, dynamic /*String?|Iterable<String>*/ >? queryParameters;
  String? fragment;
  String finalPath() {
    return Uri(
      path: path,
      fragment: fragment,
      queryParameters: queryParameters,
    ).toFilePath();
  }
}

class UriWebRequestParam extends WebRequestParam {
  UriWebRequestParam({required this.url});
  Uri url;
}

