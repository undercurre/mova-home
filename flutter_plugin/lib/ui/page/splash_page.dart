import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/countdown/count_down_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash 页面
class SplashPage extends BasePage {
  static const String routePath = '/splash_page';
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends BasePageState with CountDownWidget {
  @override
  void initData() {
    super.initData();
    startTimer(count: 2);
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(countDownProvider, (previous, next) async {
      // 跳转下一个界面
      // 跳转到首页
      // var isFirst = await LocalStorage().getBool('isFirst') ?? true;
      // LogUtils.d('goto homepage ----------  $isFirst');
      // if (isFirst) {
      //   if (context.mounted) {
      //     unawaited(context.push(AppRoutes.MAIN_PAGE));
      //   }
      // } else {
      //   if (context.mounted) {
      //     unawaited(context.push(AppRoutes.PATH_PRIVACY_PAGE));
      //   }
      // }
      unawaited(GoRouter.of(context).push(MobileLoginPage.routePath));
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
        decoration: BoxDecoration(color: style.textWhite),
        child: Center(
          child: Image.asset(
            resource.getResource('splash_logo'),
            width: 129,
            height: 28,
          ),
        ));
  }
}
