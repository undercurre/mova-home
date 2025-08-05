import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/account/smscode.dart';
import 'package:flutter_plugin/model/home/tab_config.dart';
import 'package:flutter_plugin/ui/page/ads/home_ads_model.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'home_rule_app_model.dart';

part 'main_repository.g.dart';

class MainRepository {
  final ApiClient apiClient;

  MainRepository(this.apiClient);

  // 获取tab配置
  Future<HomeRuleAppModel?> getHomeOnlineConfig() async {
    try {
      return apiClient.getHomeRuleAppList({
        'ruleList': ['appButtomRule_mova'],
      }).then((value) {
        if (value.successed()) {
          if (value.data != null) {
            unawaited(_saveAppRuleList(value.data!));
          }
          return Future.value(value.data);
        } else {
          return Future.error(DreameException(value.code, value.msg));
        }
      });
    } catch (e) {
      LogUtils.d('getTabConfig error $e');
      return Future.value(null);
    }
  }

  Future<bool> saveAdInfo(Map<String, dynamic>? models,
      {OAuthModel? account, String? countryCode}) async {
    account ??= await AccountModule().getAuthBean();
    countryCode ??= await LocalModule().getCountryCode();
    if (models == null) {
      LogUtils.i(
          'loadHomeAd saveAdInfo ------  $countryCode ${account.uid}  ++++++ null');
      return await LocalStorage().putString(
          fileName: 'ad_show', '${account.uid}-$countryCode-adShow', '');
    } else {
      var value = jsonEncode(models);
      LogUtils.i(
          'loadHomeAd saveAdInfo ------ $countryCode ${account.uid}  ++++++ $value');
      return await LocalStorage().putString(
          fileName: 'ad_show', '${account.uid}-$countryCode-adShow', value);
    }
  }

  /// 保存广告点击信息, 目前仅处理下次不再弹的广告
  Future<bool> saveClickAdInfo(ADModel? model,
      {OAuthModel? account, String? countryCode}) async {
    account ??= await AccountModule().getAuthBean();
    countryCode ??= await LocalModule().getCountryCode();
    if (model == null) {
      return true;
    }
    LogUtils.i('------- saveClickAdInfo ------- $model');
    var needHandle = model.showAgain == 0;
    if (needHandle) {
      var adInfomap =
          await getAdInfo(account: account, countryCode: countryCode);
      adInfomap[model.id] = -1;
      return await saveAdInfo(adInfomap,
          account: account, countryCode: countryCode);
    }
    return true;
  }

  /// 保存广告展示信息
  /// key:id  value:下次需要展示时间
  Future<Map<String, dynamic>> getAdInfo(
      {OAuthModel? account, String? countryCode}) async {
    account ??= await AccountModule().getAuthBean();
    countryCode ??= await LocalModule().getCountryCode();
    var value = await LocalStorage()
        .getString(fileName: 'ad_show', '${account.uid}-$countryCode-adShow');
    if (value == null || value == '' || value == '{}') {
      return <String, int>{};
    }
    var map = jsonDecode(value);
    LogUtils.i(
        'loadHomeAd getAdInfo ------ $countryCode ${account.uid} ++++++ $value');
    return map;
  }

  Future<List<ADModel>> getADList({AdType adType = AdType.homePage}) async {
    String? timeZone = await LocalModule().getTimeZone() ?? 'Asia/Shanghai';
    return apiClient
        .getADList(Platform.isIOS ? 0 : 1, adType.typeName, timeZone)
        .then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  /// 获取缓存tab配置
  Future<List<TabConfig>> readCacheTabConfig() async {
    List<TabConfig> tabConfigs = [];
    String region = RegionStore().getCountryCode();
    String tabConfigJson = await LocalStorage().getString(
            'overseas_tab_config_${region.toLowerCase()}',
            fileName: 'overseas_tab_config') ??
        '';
    if (tabConfigJson.isNotEmpty) {
      tabConfigs = jsonDecode(tabConfigJson)
          .map<TabConfig>((e) => TabConfig.fromJson(e))
          .toList();
    }
    return tabConfigs;
  }

  /// 保存tab配置
  Future<void> _saveTabConfig(List<TabConfig> tabConfigs) async {
    String region = RegionStore().getCountryCode();
    await LocalStorage().putString(
        'overseas_tab_config_${region.toLowerCase()}', jsonEncode(tabConfigs),
        fileName: 'overseas_tab_config');
  }

  Future<List<TabConfig>> checkTabConfig() async {
    String country = RegionStore().getCountryCode();
    try {
      return apiClient.getTabConfig({
        'country': country,
        'type': 'app_discard,overseas_shopping_mall',
      }).then((value) async {
        if (value.successed()) {
          List<TabConfig> list = value.data ?? [];
          final result = await _fixOverseaMallConfig(list);
          unawaited(_saveTabConfig(result));
          return result;
        } else {
          return [];
        }
      });
    } catch (e) {
      LogUtils.d('getTabConfig error $e');
      return Future.value([]);
    }
  }

  Future<List<TabConfig>> _fixOverseaMallConfig(
      List<TabConfig> originList) async {
    TabConfig? overseasMall = originList.firstWhereOrNull(
        (element) => element.type == 'overseas_shopping_mall');
    if (overseasMall != null) {
      try {
        UserInfoModel? userInfo = await AccountModule().getUserInfo();
        if (userInfo?.mailChecked == 1) {
          String email = userInfo?.email ?? '';
          String country = RegionStore().getCountryCode().toLowerCase();
          String? url = await getShopifyUrl(email, country) ?? '';
          if (url.isNotEmpty) {
            overseasMall.url = url;
          }
        }
      } catch (e) {
        LogUtils.d('getTabConfig error $e');
      }
    }
    return originList;
  }

  Future<String?> getShopifyUrl(String email, String country) {
    return apiClient
        .getShopifyUrl({'email': email, 'country': country}).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<SmsTrCodeRes> sendEmailCheckVerificationCode(
      String email, String lang) {
    return apiClient
        .sendEmailCheckVerificationCode(EmailCodeReq(email: email, lang: lang))
        .then((value) {
      if (value.success) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<dynamic> verificationEmailCheckCode(
      String email, String codeKey, String codeValue, String lang) async {
    return apiClient
        .verificationEmailCheckCode(EmailCheckCodeReq(
            email: email, codeKey: codeKey, codeValue: codeValue, lang: lang))
        .then((value) {
      if (value.success) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  // 获取用户信息
  Future<UserInfoModel> getUserInfo() async {
    return apiClient.getUserInfo().then((value) async {
      UserInfoModel? info = value.data;
      if (info != null) {
        await AccountModule().saveUserInfo(info);
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  /// 查询用户评价状态
  Future<bool> queryUserMarkStatus() {
    return apiClient.queryUserMarkStatus().then((value) {
      if (value.successed()) {
        return Future.value(value.data?.needDialog ?? false);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  /// 保存用户评价状态
  Future<void> updateUserMark(int markType) {
    return apiClient.updateUserMark({'evaluateType': markType}).then((value) {
      if (value.successed()) {
        return Future.value();
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  /// 获取缓存App配置
  Future<HomeRuleAppModel?> readCacheAppRuleList() async {
    HomeRuleAppModel? config;
    String userID = (await AccountModule().getUserInfo())?.uid ?? '';
    String tabConfigJson = await LocalStorage()
            .getString('app_config_$userID', fileName: 'app_config') ??
        '';
    if (tabConfigJson.isNotEmpty) {
      config = HomeRuleAppModel.fromJson(jsonDecode(tabConfigJson));
    }
    return config;
  }

  /// 保存tab配置
  Future<void> _saveAppRuleList(HomeRuleAppModel config) async {
    String userID = (await AccountModule().getUserInfo())?.uid ?? '';
    await LocalStorage().putString(
        'app_config_$userID', jsonEncode(config.toJson()),
        fileName: 'app_config');
  }

  Future<void> reportChannelData(String value) {
    return apiClient.reportChannelData(value, Constant.tenantId, 'userInvite', '').then((value) {
      return Future.value();
    });
  }

  Future<bool> putAppMessageWithParams(String userId, String extra) async {
    LogUtils.i('[openinstallSDK] putAppMessageWithParams $userId, $extra');
    String base64Str = base64Encode(utf8.encode(extra));
    LogUtils.i('[openinstallSDK] putAppMessageWithParams $userId, base64Str: $base64Str');
    final params = MallOpenInstallReq(ext: base64Str, userId: userId);
    final ret = await processMallApiResponse(apiClient.putAppMessageWithParams(params));
    return true;
  }
}

@riverpod
MainRepository mainRepository(MainRepositoryRef ref) {
  return MainRepository(ref.watch(apiClientProvider));
}
