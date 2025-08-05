import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/bridge/account_moudle.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';

class RecaptchaController {
  BuildContext context;
  final void Function(RecaptchaModel recaptchaModel) recaptchaCallback;

  RecaptchaController(this.context, this.recaptchaCallback);

  Future<void> check() async {
    bool isChina =
        (await LocalModule().getCurrentCountry()).countryCode.toLowerCase() ==
            'cn';
    SmartDialog.showLoading();
    if (isChina) {
      await checkFor(true);
    } else {
      try {
        await checkFor(false);
        SmartDialog.dismiss(status: SmartStatus.loading);
      } catch (e) {
        LogUtils.e('RecaptchaEnterprise error: $e');
        await checkFor(true);
      }
    }
  }

  Future<void> checkFor(bool isChina) async {
    if (isChina) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      await showDialog(
          barrierDismissible: false,
          barrierColor: const Color.fromARGB(60, 28, 28, 28),
          context: context,
          builder: (context) {
            return RecaptchaDialog(recaptchaCallback);
          });
    } else {
      await RecaptchaEnterprise.initClient(Platform.isAndroid
          ? Constant.googleRecaptchaAndroid
          : Constant.googleRecaptchaIos);
      String token = await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN());
      recaptchaCallback(RecaptchaModel(
          result: 0,
          token: token,
          sig: Platform.isIOS ? 'google-ios-login' : 'google-android-login',
          csessionid: 'google'));
    }
  }
}

class RecaptchaDialog extends Dialog {
  final void Function(RecaptchaModel recaptchaModel) recaptchaCallback;

  RecaptchaDialog(this.recaptchaCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(style.circular20)),
              color: style.bgWhite),
          margin: const EdgeInsets.only(left: 35, right: 35),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'text_sldie_verify'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: style.textMain,
                  fontSize: style.head,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none),
            ),
            Container(
                margin:
                    const EdgeInsets.fromLTRB(17, 25, 17, 43).withRTL(context),
                height: 50,
                color: style.bgWhite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26.0), // 设置圆角
                  child: FocusableActionDetector(
                    autofocus: true,
                    child: Semantics(
                      label: 'please_swipe_right_verify'.tr(),
                      enabled: true,
                      child: InAppWebView(
                        onLoadStop: (controller, url) async {},
                        onConsoleMessage: (controller, consoleMessage) {},
                        onWebViewCreated: (controller) async {
                          controller.addJavaScriptHandler(
                              handlerName: 'messageChannel',
                              callback: (args) {
                                recaptchaCallback(
                                    RecaptchaModel.fromJson(jsonDecode(args[0])));
                                Navigator.pop(context);
                                // SmartDialog.showToast(msg: args.toString());
                              });

                          String webHost = await InfoModule().getWebUriHost();
                            bool isChina = (await LocalModule().getCurrentCountry())
                                    .countryCode
                                    .toLowerCase() ==
                              'cn';
                            String htmlName = isChina ? 'aliawscZh' : 'aliawscEn';
                            String isForeign = isChina ? 'false' : 'true';
                            String lang = await LocalModule().getLangTag();
                            String tenantId = await AccountModule().getTenantId();
                            String htmlString =
                              '$webHost/$htmlName.html?lang=$lang&foreign=$isForeign&tenantId=$tenantId';
                            await controller.loadUrl(
                              urlRequest: URLRequest(url: WebUri(htmlString)));

                        },
                      ),
                    ),
                  ),
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 13)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(style.buttonBorder))),
                    backgroundColor:
                        MaterialStateProperty.all(style.cancelBtnBg),
                    overlayColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.transparent)),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'cancel'.tr(),
                    style: TextStyle(
                        color: style.lightDartBlack,
                        fontSize: style.largeText,
                        fontWeight: FontWeight.w600,
                        height: 1),
                  ),
                ),
              ),
            )
          ]),
        ),
      );
    });
  }
}
