import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_info_provider.g.dart';

/// 保存登录信息的provider
@Riverpod(keepAlive: true)
class AccountInfo extends _$AccountInfo {
  // ignore: constant_identifier_names
  @override
  OAuthModel? build() {
    return null;
  }

  Future<OAuthModel> initAuthBean() async {
    OAuthModel oAuthBean = await AccountModule().getAuthBean();
    if (!OAuthModel.isOAuthModelValiad(oAuthBean) && oAuthBean != OAuthModel.EMPTY_BEAN) {
      oAuthBean = OAuthModel.EMPTY_BEAN;
    }
    state = oAuthBean;
    return oAuthBean;
  }

  void refreshOAuthBean(OAuthModel? bean) {
    if (bean == null || !OAuthModel.isOAuthModelValiad(bean)) {
      bean = OAuthModel.EMPTY_BEAN;
    }
    state = bean;
  }
}
