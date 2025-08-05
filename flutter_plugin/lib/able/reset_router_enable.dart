import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/email/signup_email_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:go_router/go_router.dart';

mixin ResetRouterEnbale on BasePageState {
  Future pushToLogin() async {
    String path = await _getLoginPath();
    _pushToPath(path);
  }

  Future pushToRegister() async {
    String path = await _getRegisterPath();
    _pushToPath(path);
  }

  bool _isCN() {
    String short = RegionStore().currentRegion.countryCode.toLowerCase();
    return short.toLowerCase() == 'cn';
  }

  void _pushToPath(String path) {
    GoRouter.of(context).push(path);
  }

  Future<String> _getLoginPath() async {
    if (_isCN()) {
      return MobileLoginPage.routePath;
    } else {
      return PasswordLoginPage.routePath;
    }
  }

  Future<String> _getRegisterPath() async {
    // if (_isCN()) {
    return MobileSignUpPage.routePath;
    // } else {
    //   return SignUpEmailPage.routePath;
    // }
  }
}

mixin ResetRouterEnbaleForStatelessWidget on StatelessWidget {
  Future<String> getLoginPath() async {
    String short = await LocalModule().getCountryCode();
    if (short.toLowerCase() == 'cn') {
      return MobileLoginPage.routePath;
    } else {
      return PasswordLoginPage.routePath;
    }
  }
}
