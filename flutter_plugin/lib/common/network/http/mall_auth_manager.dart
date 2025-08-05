import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/configure/user_info_store.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/account/mall_my_info_res.dart';
import 'package:flutter_plugin/ui/page/mine/mine_repository.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mall_auth_manager.g.dart';

@Riverpod(keepAlive: true)
class MallAuthManager extends _$MallAuthManager {
  // 用于管理正在执行的请求
  Completer<MallLoginRes?>? _pendingRequest;

  DateTime? _lastSuccessTime = DateTime.now();
  static const Duration _cacheTimeout = Duration(milliseconds: 300);

  @override
  MallLoginRes? build() {
    return null;
  }

  Future<MallLoginRes?> getMallAuthInfo() async {
    // 检查缓存是否有效
    if (state != null &&
        _lastSuccessTime != null &&
        DateTime.now().difference(_lastSuccessTime!) < _cacheTimeout) {
      return state;
    }

    // 如果已经有请求在执行，则等待其完成
    if (_pendingRequest != null) {
      return await _pendingRequest?.future;
    }

    // 创建新的Completer来管理这次请求
    _pendingRequest = Completer<MallLoginRes?>();

    try {
      OAuthModel? authRes = await AccountModule().getAuthBean();
      int tokenExpiredTime = (authRes.t ?? 0) + (authRes.expires_in ?? 0);
      String jwtToken = authRes.accessToken ?? '';
      LogUtils.i(
          '[MallAuthManager] getMallAuthInfo jwtToken:${jwtToken} ,tokenExpiredTime:${tokenExpiredTime}');
      final res = await ref.read(mineRepositoryProvider).loginForMall();
      await UserInfoStore(localStorage: LocalStorage()).saveMallInfo(res);
      // 更新状态和缓存
      state = res;
      _lastSuccessTime = DateTime.now();

      // 请求成功，释放所有等待的调用
      _pendingRequest!.complete(res);
      return res;
    } catch (error) {
      // 请求失败，释放所有等待的调用并传播错误
      _pendingRequest!.completeError(error);
      rethrow;
    } finally {
      // 清理Completer，允许后续新的请求
      _pendingRequest = null;
    }
  }

  /// 获取商城个人信息，null 代表不获取，因为海外用户不需要
  Future<MallMyInfoRes?> getMallMyInfo() async {
    final country = await LocalModule().getCurrentCountry();
    final userInfo = await AccountModule().getUserInfo();
    final region = country.countryCode;
    if (region.toLowerCase() == 'cn' &&
        userInfo?.phoneCode == '86' &&
        userInfo?.phone?.length == 11) {
      return _getMallMyInfo();
    }
    return null;
  }

  Future<MallMyInfoRes?> _getMallMyInfo() async {
    final mallLoginInfo =
        await UserInfoStore(localStorage: LocalStorage()).getMallInfo();
    var userId = mallLoginInfo?.user_id;
    if (userId == null) {
      // 登录
      final res = await getMallAuthInfo();
      userId = res?.user_id;
    }
    try {
      if (userId != null) {
        return await ref.read(mineRepositoryProvider).mallMyInfo(userId);
      }
    } on DreameAuthException catch (e) {
      if (e.code == -100) {
        /// 需重新登录， 清理信息
        await UserInfoStore(localStorage: LocalStorage()).saveMallInfo(null);
        // 登录
        final ret = await getMallAuthInfo();
        // 重新请求
        if (userId != null) {
          return await ref.read(mineRepositoryProvider).mallMyInfo(userId);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
