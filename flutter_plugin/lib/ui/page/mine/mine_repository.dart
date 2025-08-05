import 'dart:async';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/network/http/api_client.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/account/mall_login_res.dart';
import 'package:flutter_plugin/model/account/mall_my_info_res.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mine_repository.g.dart';

class MineRepository {
  final ApiClient apiClient;

  MineRepository(this.apiClient);

  Future<MemberModel> getMemberInfo() async {
    return apiClient.getMemberInfo().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<UserInfoModel> getUserInfo() async {
    return apiClient.getUserInfo().then((value) async {
      if (value.successed()) {
        UserInfoModel? info = value.data;
        if (info != null) {
          await AccountModule().saveUserInfo(info);
          return Future.value(value.data);
        } else {
          return Future.error(DreameException(-1, 'get empty userInfo'));
        }
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<List<MallBannerRes>> getMallBanner() async {
    final req = MallBannerReq(drop_position: 4, banner_version: 1);
    var ret = await processMallApiResponse(apiClient.getMallBanner(req));
    for (var item in ret) {
      switch (item.jump_type) {
        case '1': // 外部H5
          item.jump_type = 'WEB_EXTERNAL';
          break;
        case '2': // 商品详情
          item.jump_type = 'MALL';
          item.jump_url = 'pagesA/goodsDetail/goodsDetail?gid=${item.jump_url}';
          break;
        case '3': // 商城其他页面
          item.jump_type = 'MALL';
          break;
        case '4': // 小程序
          item.jump_type = 'WX_APPLET';
          break;
      }
    }
    return ret;
  }

  Future<MallLoginRes> loginForMall() async {
    OAuthModel? authRes = await AccountModule().getAuthBean();
    String? jwtToken = authRes.accessToken;
    final req = MallLoginReq(jwtToken: jwtToken ?? '');
    final res = await processMallApiResponse(apiClient.loginForMall(req));
    return res;
  }

  Future<MallMyInfoRes> mallMyInfo(String userId) async {
    final req = MallMyInfoReq(user_id: userId);
    return await processMallApiResponse(apiClient.mallMyInfo(req));
  }

  Future<EmailCollectionRes> getEmailCollectionInfo() async {
    return apiClient.getSeaEmailCollectInfo().then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }

  Future<String> getShopifyOrderUrl(
      String email, String countryCode, String path) async {
    Map<String, dynamic> params = {
      'email': email,
      'country': countryCode,
      'returnTo': path,
    };
    return apiClient.getShopifyUrl(params).then((value) {
      if (value.successed()) {
        return Future.value(value.data);
      } else {
        LogUtils.d('main sssss ${value.msg}');
        return Future.error(DreameException(value.code, value.msg));
      }
    });
  }
}

@riverpod
MineRepository mineRepository(MineRepositoryRef ref) {
  return MineRepository(ref.watch(apiClientProvider));
}
