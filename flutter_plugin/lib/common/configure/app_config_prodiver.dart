import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/account_info_provider.dart';
import 'package:flutter_plugin/model/local_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_prodiver.g.dart';

@Riverpod(keepAlive: true)
class AppConfig extends _$AppConfig {
  @override
  Future<LocalModel> build() async {
    return getConfig();
  }

  Future<LocalModel> getConfig() async {
    OAuthModel oAuthBean =
        await ref.watch(accountInfoProvider.notifier).initAuthBean();
    return LocalModel(
      oAuthBean: oAuthBean,
      region: await LocalModule().getCountryCode(),
      timeZone: await LocalModule().getTimeZone(),
      regionItem: await LocalModule().getCurrentCountry(),
      isAgreedProtocal: await AccountModule().isAgreedProtocol(),
      userInfo: await AccountModule().getUserInfo(),
    );
  }

  Future<void> refresh() async {
    state = AsyncValue<LocalModel>.data(LocalModel(
      oAuthBean: await AccountModule().getAuthBean(),
      region: await LocalModule().getCountryCode(),
      timeZone: await LocalModule().getTimeZone(),
      regionItem: await LocalModule().getCurrentCountry(),
      isAgreedProtocal: await AccountModule().isAgreedProtocol(),
      userInfo: await AccountModule().getUserInfo(),
    ));
  }

  /// 重置配置、App栈
  Future<LocalModel?> resetApp() async {
    await refresh();
    await AppRoutes.resetStacks();
    return state.value;
  }
}
