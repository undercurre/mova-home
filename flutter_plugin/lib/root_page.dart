import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_plugin/common/configure/app_config_prodiver.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/model/local_model.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/main/main_page.dart';
import 'package:flutter_plugin/ui/page/main/open_install_mixin.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_page.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootPage extends ConsumerWidget {
  static String routePath = '/root';
  static String _pageRoutePath = '/root';

  const RootPage({super.key});

  Widget getRootPage(LocalModel localModel) {
    bool agreed = localModel.isAgreedProtocal;
    if (agreed == false) {
      var page = const PrivacyPage();
      _pageRoutePath = PrivacyPage.routePath;
      return page;
    }
    var authBean = localModel.oAuthBean;
    var region = localModel.region ?? '';
    bool isValiad =
        authBean == null ? false : OAuthModel.isOAuthModelValiad(authBean);
    Widget page;
    if (isValiad == true) {
      String phoneCode = localModel.userInfo?.phoneCode ?? '';
      bool showMall =
          localModel.regionItem?.countryCode.toLowerCase() == 'cn' &&
              (phoneCode.isEmpty || phoneCode == '86');
      page = MainPage(
        key: Key('$region$showMall'),
        defaultPage: 0,
      );
      _pageRoutePath = MainPage.routePath;
    } else {
      FlutterAppBadger.removeBadge();
      page = localModel.regionItem!.countryCode.toLowerCase() == 'cn'
          ? const MobileLoginPage()
          : const PasswordLoginPage();
      _pageRoutePath = localModel.regionItem!.countryCode.toLowerCase() == 'cn'
          ? MobileLoginPage.routePath
          : PasswordLoginPage.routePath;
    }
    return page;
  }

  static String getPageRoutePath() {
    return _pageRoutePath;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(appConfigProvider).when(
        data: (localModel) {
          // return const DemoPage();
          // return DeveloperMenuPage();
          return getRootPage(localModel);
        },
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
        loading: () => Container(
              color: Colors.white,
            ));
  }
}
