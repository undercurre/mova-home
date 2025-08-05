import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/account/privacy_res.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef _CallBack = void Function(int code, String? msg);

String get iosSdk {
  return 'AJezoqIsaWyxrLV7TGU6apjADp4fWyfv5O/kcoK2LXexi3y1+BbcL0l4x1ERoKf6TwEZ7vfaq+GABCRNo1YGLCAO23v7EL0W/CUoZZlFPoDmMUk0fAkrRND4DO0ulKOkUfYt3X3Kc5NI2QlXbXC5begfleBrMfO219Yg4W9tfiU9SniQNrP5LyHkdrLnLHM6Zjq8PSa31t04Ctk0ruUHiUJxc0/nOqPixiTRHtL5ZHXde05helTJ2hUpsALt8yXF1HSJu5T/Sp4=';
}

String get androidSdk {
  return 'nIMdJ2lp0Mt6omfrGRdksii6x7N2RKuIVDXEUhIPW2IH1PLPf6jaovajumpmfj8oddMpE9NRsABvMPQ1tIaPwAMOrdi+7s/bBlTK459l6Cwh1QKCJTnMSPBKnVF41MjTZIX3p0cL7kPVbuQ8v5j74H4105cN3fzL0JfVi6ZEIeqs7IbfCv9Qi8VzJFi62PE5x6ELUO6Gwj4CYeYTEt2XbOfjtFbNTx5nVyQ2hlOvzNlZS0mngssE01l1akQkzYZrWKzhdVDWcPzhQ/EdNurdctqFSJqg6dRjEsPU7fOo0hOX/OA4Dz68VA==';
}

String get androidSdkGp {
  return 'nIMdJ2lp0Mt6omfrGRdksii6x7N2RKuIVDXEUhIPW2IH1PLPf6jaovajumpmfj8oddMpE9NRsABvMPQ1tIaPwAMOrdi+7s/bBlTK459l6Cwh1QKCJTnMSPBKnVF41MjTZIX3p0cL7kPVbuQ8v5j74H4105cN3fzL0JfVi6ZEIeqs7IbfCv9Qi8VzJFi62PE5x6ELUO6Gwj4CYeYTEt2XbOfjtFbNTx5nVyQ2hlOvzNlZS0mngssE01l1akQkzYZrWKzhdVDWcPzhQ/EdNurdctqFSJqg6dRjEsPU7fOo0hOX/OA4Dz68VA==';
}

class OnekeyLoginWidget extends ConsumerStatefulWidget {
  final _CallBack callback;
  final Future<PrivacyInfoBean> function;
  final bool isCnInit;

  OnekeyLoginWidget(
      {Key? key,
      required this.function,
      required this.callback,
      required this.isCnInit})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return OnekeyLoginWidgetState();
  }
}

class OnekeyLoginWidgetState extends ConsumerState<OnekeyLoginWidget>
    with WidgetsBindingObserver {
  // sdk 初始化是否成功
  bool? initSuccess = false;
  bool isActive = true;
  bool isActivityActivity = true;
  int timestamp = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LogUtils.i(
        '-------- AliAuthClient.handleEvent---------didChangeAppLifecycleState :${state}');
    if (state == AppLifecycleState.resumed) {
      isActivityActivity = true;
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      isActivityActivity = false;
    }
  }

  void cancelAuthPage() {
    LogUtils.i('-------- cancelAuthPage --------- ');
    try {
      AliAuthClient.hideLoginLoading();
      AliAuthClient.quitLoginPage();
    } catch (e) {
      LogUtils.e('-------- cancelAuthPage --------- $e');
    }
  }

  @override
  void initState() {
    super.initState();
    isActive = true;
    timestamp = DateTime.now().millisecondsSinceEpoch;
    WidgetsBinding.instance.addObserver(this);
    LogUtils.i(
        '-------- AliAuthClient.handleEvent---------initState :$isActive ${widget.isCnInit} ${hashCode}  ${_onEvent.hashCode}');
    // 注册事件处理
    AliAuthClient.handleEvent(onEvent: _onEvent);
    if (widget.isCnInit) {
      initialize();
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    isActive = false;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    LogUtils.i(
        '-------- .removeHandler dispose--------- ${hashCode}  ${_onEvent.hashCode}');
    AliAuthClient.removeHandler(onEvent: _onEvent);
    cancelAuthPage();
  }

  Future<void> initialize() async {
    var time1 = DateTime.now().millisecond;
    LogUtils.i('-------- initialize 1--------- ');
    PrivacyInfoBean bean = await widget.function;
    var time2 = DateTime.now().millisecond - time1;
    if (time2 > 3000) {
      LogUtils.e('-------- initialize 2--------- $time2 ${bean.toJson()}');
      return;
    }
    LogUtils.i('-------- initialize 2--------- ${bean.toJson()}');
    // 初始化SDK
    try {
      var isGpVersion = await InfoModule().isGpVersion();
      String androidSdkKey = androidSdk;
      if (isGpVersion == true) {
        androidSdkKey = androidSdkGp;
      } else {
        androidSdkKey = androidSdk;
      }
      var authConfig = AuthConfig(
        iosSdk: iosSdk,
        androidSdk: androidSdkKey,
        enableLog: await InfoModule().envType() != EnvType.release,
        authUIStyle: AuthUIStyle.mova_default,
        themeMode: ref.read(appThemeStateNotifierProvider).name,
        authUIConfig: DreameFullScreenUIConfig(
            /// 不需要翻译
            '用户协议',
            '${bean.agreementUrl}&curLang=zh&curRegion=cn',
            '隐私政策',
            '${bean.privacyUrl}&curLang=zh&curRegion=cn'),
      );
      initSuccess = await AliAuthClient.initSdk(authConfig: authConfig);
    } on PlatformException catch (e) {
      final AuthResultCode resultCode = AuthResultCode.fromCode(e.code);
      LogUtils.i('-------- login --------- ${resultCode.message}');
    } on MissingPluginException catch (e) {
      LogUtils.e('-------- login --------- $e');
    }
    LogUtils.i('-------- initialize 3--------- $initSuccess');
    if (initSuccess != true) {
      widget.callback(-1, 'init fail');
    } else {
      LogUtils.d('-------- login --------- $initSuccess');
    }
  }

  // 登录
  Future<void> login() async {
    try {
      if (initSuccess == true) {
        return await AliAuthClient.login();
      }
    } on PlatformException catch (e) {
      final AuthResultCode resultCode = AuthResultCode.fromCode(e.code);
      log(resultCode.message);
    }
  }

  /// 登录成功处理
  Future<void> _onEvent(AuthResponseModel responseModel) async {
    if (!isActive) {
      LogUtils.e(
          '-------- AliAuthClient.handleEvent---------_onEvent :${isActive}');
      return;
    }
    LogUtils.i('-------- handleEvent --------- ${responseModel.toJson()}');
    final AuthResultCode resultCode = AuthResultCode.fromCode(
      responseModel.resultCode!,
    );
    switch (resultCode) {
      case AuthResultCode.success:
        if (responseModel.token != null && responseModel.token!.isNotEmpty) {
          //验证成功，获取到token
          // await onToken(token: responseModel.token!);
          widget.callback(0, responseModel.token);
        }
        break;
      case AuthResultCode.envCheckSuccess:
        LogUtils.i('当前环境支持一键登录');
        break;
      case AuthResultCode.loginControllerPresentSuccess:
        LogUtils.i('一键登录 唤起授权页成功');
        break;
      case AuthResultCode.loginControllerPresentFailed:
      case AuthResultCode.loginControllerClickCancel:
        break;
      case AuthResultCode.getMaskPhoneSuccess:
        LogUtils.i('预先取号成功');
        //预先取号成功再调起授权页面
        LogUtils.i('-------- 预先取号成功 login --------- $initSuccess');
        var tmp = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (isActive && isActivityActivity && tmp < 3 * 1000) {
          LogUtils.e(
              '-------- AliAuthClient.handleEvent---------login real :${isActive} ${isActivityActivity}');
          await AliAuthClient.login(timeout: 5);
        }
        break;
      default:
        // implement your logic
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
