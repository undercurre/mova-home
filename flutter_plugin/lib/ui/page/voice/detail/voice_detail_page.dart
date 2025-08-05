import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/voice/ai_sound_model.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/url/common_url_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class VoiceDetailPage extends BasePage {
  static const String routePath = '/voice_detail_page';

  final AiSoundModel soundModel;

  const VoiceDetailPage({super.key, required this.soundModel});

  @override
  VoiceDetailPageState createState() => VoiceDetailPageState();
}

class VoiceDetailPageState extends BasePageState<VoiceDetailPage> {
  @override
  String get centerTitle => widget.soundModel.name;

  InAppWebViewController? currentController;

  @override
  void addObserver() {
    super.addObserver();
    ref.listen<ThemeMode>(appThemeStateNotifierProvider, (previous, next) {
      try {
        // 当 ThemeMode 发生变化时触发
        LogUtils.i(
            '[mall_page] themeProvider changed from ${previous?.name} to ${next.name}');
        // 在这里处理 ThemeMode 变化的逻辑
        LogUtils.i('[mall_page] System mode activated');
        final params = {'theme': next.name}; // 构造参数
        LogUtils.i('[mall_page]callMethodToWeb params: $params');
        // 获取 WebPageState 的实例
        callMethodToWeb('themeChange', params); // 调用方法
      } catch (e) {
        LogUtils.e('[mall_page] addObserver themeProvider Error: $e');
      }
    });
  }

  Future<void> callMethodToWeb(
      String method, Map<String, dynamic>? params) async {
    try {
      if (!context.mounted) return;
      if (currentController == null) return;
      bool isLoading = await currentController!.isLoading();
      if (isLoading == true) return;
      String paramsString = '';
      if (params != null) {
        paramsString = json.encode(params);
      }
      String jsFunction = '$method($paramsString)';
      unawaited(currentController?.evaluateJavascript(source: jsFunction));
    } catch (e) {
      LogUtils.e('mall 错误-----$e');
    }

    // currentController?.runJavaScript(jsFunction);
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(
      children: [
        Expanded(
          child: InAppWebView(
            key: ValueKey('voice_detail_${style.bgColor}'),
            initialSettings: InAppWebViewSettings(
              underPageBackgroundColor: style.bgColor,
            ),
            onReceivedError: (controller, request, error) async {
              LogUtils.e('onReceivedError: $error');
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED);
            },
            onWebViewCreated: (controller) {
              currentController = controller;
              var originalUriPath = widget.soundModel.linkUrl;
              final themeMode = ref.read(appThemeStateNotifierProvider);
              String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';
              final queryParameters = {'themeMode': themePath};
              final newWebUri = CommonUrlUtils()
                  .appendRawQueryParam2(originalUriPath, queryParameters);
              controller.loadUrl(urlRequest: URLRequest(url: newWebUri));
            },
          ),
        ),
        DMButton(
          onClickCallback: (_) {
            if (Platform.isIOS) {
              launchUrl(Uri.parse(widget.soundModel.ios?.downloadUrl ?? ''));
            } else {
              UIModule().openAiSoundApp({
                'packageName': widget.soundModel.android?.packageName ?? '',
                'downloadUrl': widget.soundModel.android?.downloadUrl ?? '',
              });
            }
          },
          text: widget.soundModel.button ?? '',
          fontsize: 16,
          textColor: style.btnText,
          backgroundGradient: style.confirmBtnGradient,
          fontWidget: FontWeight.bold,
          width: double.infinity,
          borderRadius: 8,
          height: 48,
          margin:
              const EdgeInsets.only(left: 24, right: 24, bottom: 34, top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ],
    );
  }
}
