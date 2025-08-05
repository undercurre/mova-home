import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/configure/user_info_store.dart';

class MallUrlInterceptor extends Interceptor {
  final String mallReleaseUrl = 'https://wxmall.mova-tech.com';
  final String mallUatUrl = 'https://uat-wxmall.mova-tech.com';
  final String mallDebugUrl = 'http://dev-wxmall.mova-tech.com';

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final uriHost = await InfoModule().getUriHost();
    if (options.path.contains(mallReleaseUrl)) {
      String mallUrl = '';
      if (uriHost.contains('uat')) {
        mallUrl = mallUatUrl;
      } else if (uriHost.contains('dev')) {
        mallUrl = mallDebugUrl;
      } else {
        mallUrl = mallReleaseUrl;
      }
      options.path = options.path.replaceFirst(mallReleaseUrl, mallUrl);
      final headers = options.headers;
      final mallLoginInfo =
          await UserInfoStore(localStorage: LocalStorage()).getMallInfo();
      headers['accesstoken'] = mallLoginInfo?.accessToken ?? '';
      options.headers = headers;
    }
    handler.next(options);
  }
}
