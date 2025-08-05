import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// 使用生成 HTTP 204 响应的方法 检测网络联通性
class Generate204Test {
  final httpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 3);

  Generate204Test._internal();

  factory Generate204Test() => _instance;
  static final Generate204Test _instance = Generate204Test._internal();
  final successText =
      '<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>';

  Future<bool> generate204Test() async {
    /// 测试苹果服务
    var ret = await _generate204Test(GenerateServerResponse204.appleSuccess);
    if (ret.first == HttpStatus.ok && ret.second == successText) {
      return true;
    }

    /// 测试Cloudflare服务
    ret = await _generate204Test(GenerateServerResponse204.cloudflare);
    if (ret.first == HttpStatus.noContent) {
      return true;
    }

   /* /// 测试微软服务
    ret = await _generate204Test(GenerateServerResponse204.microSoft);
    if (ret.first == HttpStatus.ok && ret.second == 'Microsoft Connect Test') {
      return true;
    }

    /// 测试Firefox服务
    ret = await _generate204Test(GenerateServerResponse204.firefox);
    if (ret.first == HttpStatus.ok && ret.second == 'success\n') {
      return true;
    }
*/
    return false;
  }

  Future<Pair<int, String>> _generate204Test(String generateServer) async {
    try {
      var request = await httpClient.getUrl(Uri.parse(generateServer));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      return Pair(response.statusCode, body);
    } catch (e) {
      if (e is SocketException) {
        return Pair(-1, '');
      }
      LogUtils.e('Generate204Test error: $generateServer $e');
    }
    return Pair(-1, '');
  }
}

/// 生成 HTTP 204 响应的服务端响应
/// https://imldy.cn/posts/99d42f85/
/// https://blog.shadowrocketsub.com/post/shadowrocket-204-test-url/
// 服务提供者	      链接	                                                  大陆体验	境外体验	http/https	IP Version
// Google	      http://www.gstatic.com/generate_204	                        5	    10	    204/204	    4+6
// Google	      http://www.google-analytics.com/generate_204	              6	    10	    204/204	    4+6
// Google	      http://www.google.com/generate_204	                        0	    10	    204/204	    4+6
// Google	      http://connectivitycheck.gstatic.com/generate_204         	4	    10	    204/204	    4+6
// Apple	      http://captive.apple.com	                                  3	    10	    200/200	    4+6
// Apple🔥	    http://www.apple.com/library/test/success.html	            7	    10	    200/200	    4+6
// MicroSoft	  http://www.msftconnecttest.com/connecttest.txt	            5	    10	    200/error	  4
// Cloudflare	  http://cp.cloudflare.com/	                                  4	    10	    204/204	    4+6
// Firefox	    http://detectportal.firefox.com/success.txt	                5	    10	    200/200	    4+6
// V2ex	        http://www.v2ex.com/generate_204	                          0	    10	    204/301	    4+6
// 小米	        http://connect.rom.miui.com/generate_204	                  10	  4	      204/204	    4
// 华为	        http://connectivitycheck.platform.hicloud.com/generate_204	10	  5	      204/204	    4
// Vivo	        http://wifi.vivo.com.cn/generate_204	                      10	  5	      204/204	    4
class GenerateServerResponse204 {
  static const String google = 'http://www.gstatic.com/generate_204';
  static const String googleMaps =
      'http://maps.googleapis.com/maps/api/mapsjs/gen_204';
  static const String googleClients3 =
      'https://clients3.google.com/generate_204';

  static const String googleAnalytics =
      'http://www.google-analytics.com/generate_204';
  static const String googleCom = 'http://www.google.com/generate_204';
  static const String connectivityCheckGstatic =
      'http://connectivitycheck.gstatic.com/generate_204';
  static const String apple = 'http://captive.apple.com';
  static const String appleSuccess =
      'http://www.apple.com/library/test/success.html';
  static const String microSoft =
      'http://www.msftconnecttest.com/connecttest.txt';
  static const String cloudflare = 'http://cp.cloudflare.com/';
  static const String firefox = 'http://detectportal.firefox.com/success.txt';
  static const String v2ex = 'http://www.v2ex.com/generate_204';
  static const String xiaomi = 'http://connect.rom.miui.com/generate_204';
  static const String huawei =
      'http://connectivitycheck.platform.hicloud.com/generate_204';
  static const String vivo = 'http://wifi.vivo.com.cn/generate_204';
}
