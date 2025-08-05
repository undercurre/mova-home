import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/adapter/cert_verify_adapter.dart';
import 'package:flutter_plugin/common/network/http/mall_url_interceptor.dart';
import 'package:flutter_plugin/common/network/mqtt/mqtt_connector.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/model/event/token_refresh_event.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class NetworkUtil {
  NetworkUtil._internal();

  factory NetworkUtil() => _instance;
  static final NetworkUtil _instance = NetworkUtil._internal();

  Future<void> init() async {
    // Uri.parse("").host.isEmpty
    DMHttpManager().initConfig(NetworkConfig(
        tenantId: () async {
          return await AccountModule().getTenantId();
        },
        baseUrl: () async {
          return await InfoModule().getUriHost();
        },
        authConfig: () async {
          var authBean = await AccountModule().getAuthBean();
          return AuthConfig(
            accessToken: authBean.accessToken ?? '',
            refreshToken: authBean.refreshToken ?? '',
            tokenExpiredTime: (authBean.t ?? 0) + (authBean.expires_in ?? 0),
          );
        },
        httpClientAdapter: CertVerifyAdapter(),
        tokenRefresh: (newAuth) async {
          if (newAuth != null) {
            AccountModule().refreshAuthBean(OAuthModel.fromJson(newAuth));
          }
          await MqttConnector().connect();
          unawaited(AccountModule().doAlifyAuth());
          EventBusUtil.getInstance().fire(TokenRefreshEvent());
        },
        tokenExpired: (reason) async {
          LogModule().eventReport(100, 9, rawStr: reason);
          await LifeCycleManager().logOut();
        },
        hostChanged: (targetHost, host) async {},
        paramsSignConfig: ParamsSignConfig(
          paramSignUrls: [
            '/dreame-user/v2/forgotpass/sms/code',
            '/dreame-user/v2/secure-info/sms/code',
            '/dreame-user/v2/secure-info/sms/code-new',
            '/dreame-user/v2/register/sms',
            '/dreame-auth/v2/oauth/social/register/sms',
            '/dreame-auth/v2/oauth/sms',
            '/dreame-auth/v2/oauth/social/sms',
            '/dreame-auth/v2/oauth/social/register/sms',
            '/dreame-auth/v3/oauth/social/autoregisterbind/sms',
          ],
          encrptyKey: 'gigxlmqwZ]7oWZUF',
        ),
        customHeaders: {
          'Authorization': 'Basic bW92YV9hcHA6VjdLb0NoTFc4dkhBQ3FHYg==',
        },
        interceptors: [
          MallUrlInterceptor()
        ])
      ..logPrinter = DreameLogPrinter()
      ..rlcHeaderConfig = () async {
        var serverSite = await LocalModule().serverSite();
        var languageTag = await LocalModule().getLangTag();
        var countryCode = await LocalModule().getCountryCode();
        return RlcHeaderConfig(
            serverSite: serverSite,
            languageTag: languageTag,
            countryCode: countryCode,
            encrptyKey: 'gigxlmqwZ]7oWZUF');
      }
      ..tokenLastRefreshTime = () async {
        final lastRefreshTime = await AccountModule().lastRefreshTime();
        return lastRefreshTime;
      });
  }

  // / 获取host缓存中DNS解析地址
  String getCachedDns(String host) => DMHttpManager().hostMap[host] ?? '';

  /// 获取host对应的DNS解析地址
  Future<String> dnsRequest(String host) async {
    return DMHttpManager().dnsRequest(host);
  }

  /// 清除DNS缓存
  void cleanCachedDns(String host) {
    if (host.isEmpty) {
      DMHttpManager().hostMap.clear();
    } else {
      DMHttpManager().hostMap.remove(host);
    }
  }

  void cancelRequest() {
    DMHttpManager().cancelRequest();
  }
}

class DreameLogPrinter extends LogPrinter {
  @override
  void debug(String message) {
    LogUtils.d(message);
  }

  @override
  void error(String message) {
    LogUtils.e(message);
  }

  @override
  void info(String message) {
    LogUtils.i(message);
  }
}
