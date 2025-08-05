import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/utils/logutils.dart';

/// 账号相关
class AccountModule {
  AccountModule._internal();

  factory AccountModule() => _instance;
  static final AccountModule _instance = AccountModule._internal();
  final _plugin = const MethodChannel('com.dreame.flutter/module_account');
  OAuthModel? _oAuthModel;
  UserInfoModel? _userInfoModel;

  /// 获取用户登录信息、token
  Future<OAuthModel> getAuthBean({bool forceSync = false}) async {
    if (_oAuthModel == null || forceSync) {
      String accountJson = await _plugin.invokeMethod('getAuthBean');
      LogUtils.d('------------- getAuthBean ----------------- $accountJson');
      var oAuthBean = OAuthModel.fromJson(json.decode(accountJson));
      if (!OAuthModel.isOAuthModelValiad(oAuthBean)) {
        oAuthBean = OAuthModel.EMPTY_BEAN;
      }
      _oAuthModel = oAuthBean;
    }
    return _oAuthModel!;
  }

  /// 手动过期token
  Future<void> invalidToken() {
    if (_oAuthModel != null) {
      _oAuthModel!.accessToken = '12345678_test';
    }
    return _plugin.invokeMethod('invalidToken');
  }

  /// 更新用户登录信息、token
  Future<bool?> refreshAuthBean(OAuthModel authBean) {
    LogUtils.d('------------- refreshAuthBean -----------------');
    _oAuthModel = authBean;
    return _plugin.invokeMethod<bool>(
        'refreshAuthBean', {'authBean': json.encode(authBean)});
  }
  
  void clearAuthBean() {
    _oAuthModel = null;
  }


  Future<int> lastRefreshTime() async {
    int time = await _plugin.invokeMethod('lastRefreshTime');
    return time;
  }

  Future<String> getTenantId() async {
    String tenantId = await _plugin.invokeMethod('getTenantId') ?? '000002';
    return Future.value(tenantId);
  }

// 主要用于原神清除个人信息，登录信息，deviceToken等解绑，第三方退出登录
  Future<void> prepareLogout() async {
    try {
      _oAuthModel = null;
      _userInfoModel = null;
      await _plugin.invokeMethod('prepareLogout');
    } catch (e) {
      LogUtils.e('------- prepareLogout ------, $e');
    }
  }

  Future<void> accountClear() async {
    try {
      _oAuthModel = null;
      _userInfoModel = null;
      await _plugin.invokeMethod('accountClear');
    } catch (e) {
      LogUtils.e('accountClear error, $e');
    }
  }

  /// 读取已保存的用户信息
  Future<UserInfoModel?> getUserInfo() async {
    _userInfoModel ??= await _getUserInfo();
    return _userInfoModel;
  }

  Future<UserInfoModel?> _getUserInfo() async {
    try {
      String userInfoJson = await _plugin.invokeMethod('getUserInfo');
      LogUtils.i('getUserInfo: $userInfoJson');
      if (userInfoJson.isEmpty) {
        LogUtils.e('getUserInfo is empty');
        return null;
      }
      dynamic jd = json.decode(userInfoJson);
      if (jd is Map<String, dynamic>) {
        dynamic birty = jd['birthday'];
        if (birty is String) {
          jd['birthday'] = int.tryParse(birty);
        }
      }
      LogUtils.i('getUserInfo: $jd');
      return UserInfoModel.fromJson(jd);
    } catch (e) {
      LogUtils.e(' methond: getUserInfo isn\'t implement , $e');
      // rethrow;
      return null;
    }
  }

  /// 保存用户信息
  Future<bool?> saveUserInfo(UserInfoModel userInfo) {
    try {
      _userInfoModel = userInfo;
      LogUtils.i('saveUserInfo: ${userInfo.toJson()}');
      return _plugin.invokeMethod<bool>(
          'saveUserInfo', {'params': json.encode(userInfo)});
    } on MissingPluginException catch (e) {
      LogUtils.e(' methond: saveUserInfo isn\'t implement , $e');
      rethrow;
    }
  }

  void clearUserInfo() {
    _userInfoModel = null;
  }


  Future<void> loginSuccess() {
    if (Platform.isIOS) {
      return _plugin.invokeMethod('loginSuccess');
    }
    return Future.value();
  }

  ///
  Future<bool> isAgreedProtocol() async {
    return await _plugin.invokeMethod('isAgreedProtocol');
  }

  /// 同意隐私协议
  Future<bool?> agreeProtocol() {
    try {
      return _plugin.invokeMethod<bool>('agreeProtocol');
    } on MissingPluginException catch (e) {
      LogUtils.e(' methond: saveUserInfo isn\'t implement , $e');
      rethrow;
    }
  }

  /// 读取保存的隐私信息
  Future<PrivacyInfoBean?> getPrivacyInfo() async {
    try {
      var jsonStr = await _plugin.invokeMethod('getPrivacyInfo');
      if (jsonStr == null) {
        return null;
      } else {
        LogUtils.d('-------- getPrivacyInfo ---------$jsonStr');
        var bean = PrivacyInfoBean.fromJson(json.decode(jsonStr));
        return bean;
      }
    } on MissingPluginException catch (e) {
      LogUtils.e(' methond: getPrivacyInfo isn\'t implement , $e');
      rethrow;
    }
  }

  /// 保存隐私信息
  Future<bool?> savePrivacyInfo(PrivacyInfoBean bean) {
    try {
      LogUtils.d('-------- savePrivacyInfo --------- ${bean.toJson()}');
      return _plugin.invokeMethod<bool>(
          'savePrivacyInfo', {'params': json.encode(bean.toJson())});
    } on MissingPluginException catch (e) {
      LogUtils.e(' methond: saveUserInfo isn\'t implement , $e');
      rethrow;
    }
  }

  /// 获取push token
  Future<Map<String, String>?> getPushToken() async {
    var map = await _plugin.invokeMapMethod('getPushToken');
    if (map == null) {
      return null;
    } else {
      return Map<String, String>.from(map);
    }
  }

  ///获取原生的缓存大小
  Future<int> getLocalCacheSize() async {
    return await _plugin.invokeMethod('getLocalCacheSize');
  }

  /// 阿里飞燕账号授权
  Future<void> doAlifyAuth() {
    return _plugin.invokeMethod('doAlifyAuth');
  }
}
