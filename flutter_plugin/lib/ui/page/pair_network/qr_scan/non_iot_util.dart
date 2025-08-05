import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/ui/dynamic_widget/string_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';

import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';

class NonIotUtil {
  NonIotUtil._internal();

  factory NonIotUtil() => _instance;
  static final NonIotUtil _instance = NonIotUtil._internal();

  static const String h5Sign = 'markH5';

  static const String secretKey = 'zMovaAppTokenKey';
  static const String collectedListUrl =
      'kitchen/offlinedevice/web/cms/markH5/list';
  static const String _prodBaseUrl = 'https://mova-common.mova-tech.com/';

  Future<void> goToH5Page(String barcode, ThemeMode themeMode,
      {String pageTitle = ''}) async {
    final (OAuthModel token, Pair language) = await (
      AccountModule().getAuthBean(),
      LocalModule().getLangTagCode()
    ).wait;

    var accessToken = token.accessToken ?? 'NO_TOKEN';

    String lang = language.first.toString().toLowerCase();
    String country = language.second.toString().toUpperCase();

    String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';

    LogUtils.i(
        'zzb  -- > language = $language themeMode = $themePath before encrypt accessToken = $accessToken');
    accessToken = accessToken.aESCBCencrypt(secrectKey: secretKey);
    String encodedAccessToken = Uri.encodeComponent(accessToken);
    LogUtils.d('zzb  -- > after encode accessToken = $encodedAccessToken');

    String url =
        '$barcode?lang=$lang-$country&themeMode=$themePath&token=$encodedAccessToken&${WebPageState.KEEP_ONLY_STATUS_BAR}';

    await AppRoutes().push(WebPage.routePath,
        extra: WebViewRequest(
            uri: WebUri(url),
            defaultTitle: pageTitle,
            headers: {'token': encodedAccessToken}));
  }

  bool hasH5Sign(String? str) {
    return str?.contains(h5Sign) == true;
  }

  String getCollectedListUrl() {
    return _prodBaseUrl + collectedListUrl;
  }
}
