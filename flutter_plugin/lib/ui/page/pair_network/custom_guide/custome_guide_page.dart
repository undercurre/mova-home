import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/custom_guide/custom_guide_state_notifier.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info.dart';
import 'package:flutter_plugin/ui/page/pair_network/iot_pair_net_info_step_mixin.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/ui/widget/pair_net/pair_net_indicate_widget.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/url/common_url_utils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

enum PairGuideType {
  html,
  lottie,
  image;
}

class CustomGuidePage extends BasePage {
  static const routePath = '/custom_guide';

  const CustomGuidePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CustomGuidePageState();
  }
}

class _CustomGuidePageState extends BasePageState with IotPairNetInfoStepMixin {
  InAppWebViewController? currentController;

  void updateController(InAppWebViewController controller) async {
    currentController = controller;
    var originalUriPath = ref
            .watch(customGuideStateNotifierProvider.call(getProviderId()))
            .guideModel
            ?.guideUrl ??
        '';
    final themeMode = ref.read(appThemeStateNotifierProvider);
    String themePath = themeMode == ThemeMode.dark ? 'dark' : 'light';
    final queryParameters = {'themeMode': themePath};
    final newWebUri =
        CommonUrlUtils().appendRawQueryParam2(originalUriPath, queryParameters);
    await currentController?.loadUrl(
      urlRequest: URLRequest(
        url: newWebUri,
      ),
    );
  }

  String getProviderId() {
    var extra = AppRoutes()
            .getGoRouterStateExtra<Pair<int, List<PairGuideModel>>>(context) ??
        Pair(1, IotPairNetworkInfo().guideSteps);
    return 'custom_guide_${extra?.first}';
  }

  @override
  void initData() {
    var extra = AppRoutes()
            .getGoRouterStateExtra<Pair<int, List<PairGuideModel>>>(context) ??
        Pair(1, IotPairNetworkInfo().guideSteps);
    ref
        .read(customGuideStateNotifierProvider.call(getProviderId()).notifier)
        .parseAppRouterExtra(extra);
  }

  @override
  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return NavBar(
      title: ref
          .watch(customGuideStateNotifierProvider.call(getProviderId()))
          .guideModel
          ?.guideTitle,
      bgColor: style.bgGray,
      itemAction: (tag) {
        if (tag == BarButtonTag.left) {
          if (ref
              .read(customGuideStateNotifierProvider.call(getProviderId()))
              .enableBtn) {
            ref
                .read(customGuideStateNotifierProvider
                    .call(getProviderId())
                    .notifier)
                .toggleEnableBtn();
          }
          AppRoutes().pop();
        }
      },
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    var guideModel = ref
        .watch(customGuideStateNotifierProvider.call(getProviderId()))
        .guideModel;
    LogUtils.d('----- guideModel $guideModel');
    var currentStep = ref
        .watch(customGuideStateNotifierProvider.call(getProviderId()))
        .currentStep;
    var totalStep = ref
        .watch(customGuideStateNotifierProvider.call(getProviderId()))
        .totalSteps;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: _buildGuideContent(context, resource, style)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Image.asset(resource.getResource(ref.watch(
                              customGuideStateNotifierProvider
                                  .call(getProviderId())
                                  .select((value) => value.enableBtn))
                          ? 'ic_agreement_selected'
                          : 'ic_agreement_unselect')),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        guideModel?.selectText ?? '',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: style.textMain),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ).onClick(() {
                  ref
                      .read(customGuideStateNotifierProvider
                          .call(getProviderId())
                          .notifier)
                      .toggleEnableBtn();
                })),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: DMCommonClickButton(
                backgroundGradient: style.confirmBtnGradient,
                disableBackgroundGradient: style.disableBtnGradient,
                borderRadius: style.buttonBorder,
                enable: ref.watch(customGuideStateNotifierProvider
                    .call(getProviderId())
                    .select((value) => value.enableBtn)),
                text: guideModel?.buttonText ?? '',
                onClickCallback: () {
                  ref
                      .read(customGuideStateNotifierProvider
                          .call(getProviderId())
                          .notifier)
                      .gotoNextPage();
                },
              ),
            ),
            Visibility(
              visible: totalStep > 0 && currentStep > 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 32),
                child: PairNetIndicatorWidget(currentStep, totalStep),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildGuideContent(
      BuildContext context, ResourceModel resource, StyleModel style) {
    var guideModel = ref
        .watch(customGuideStateNotifierProvider.call(getProviderId()))
        .guideModel;
    var guideType = PairGuideType.values[(guideModel?.guideType ?? 1) - 1];
    switch (guideType) {
      case PairGuideType.html:
        return _buildGuideWebView(resource, style);
      case PairGuideType.lottie:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: guideModel?.guideUrl.isNotEmpty ?? false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Lottie.network(
                    guideModel?.guideUrl ?? '',
                    width: double.infinity,
                    height:
                        (MediaQuery.of(context).size.width - 40) * 240 / 350,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              _buildGuideDescription(style)
            ],
          ),
        );
      case PairGuideType.image:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: guideModel?.guideUrl.isNotEmpty ?? false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: (guideModel?.guideUrl ?? '').isEmpty == true
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl: guideModel?.guideUrl ?? '',
                          width: double.infinity,
                          height: (MediaQuery.of(context).size.width - 40) *
                              240 /
                              350,
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),
              _buildGuideDescription(style)
            ],
          ),
        );
    }
  }

  Widget _buildGuideDescription(StyleModel style) {
    var guideModel = ref
        .watch(customGuideStateNotifierProvider.call(getProviderId()))
        .guideModel;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      child: DMFormatRichText(
        content: guideModel?.guideRemark ?? '',
        align: TextAlign.center,
        normalTextStyle: TextStyle(
            fontSize: 16, color: style.textMain, fontWeight: FontWeight.w500),
        clickTextStyle: TextStyle(
            fontSize: 16, color: style.btnText, fontWeight: FontWeight.w500),
        richCallback: (index, key, content) {
          if (key.startsWith('http://') || key.startsWith('https://')) {
            GoRouter.of(context).push(
              WebPage.routePath,
              extra: WebViewRequest(uri: WebUri(key), defaultTitle: content),
            );
          }
        },
      ),
    );
  }

  bool _loadError = false;

  Widget _buildGuideWebView(ResourceModel resource, StyleModel style) {
    return Container(
        color: style.bgGray,
        child: _loadError
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image(
                    width: 200,
                    fit: BoxFit.fitWidth,
                    image: AssetImage(resource.getResource('ic_home_error')),
                  ).withDynamic(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15).withRTL(context),
                    child: Text(
                      'UserManualPage_Status_loadingException'.tr(),
                      style: TextStyle(fontSize: 14, color: style.textSecond),
                    ),
                  ),
                ]),
              )
            : InAppWebView(
                key: Key('custom_guide_page_${style.bgColor}'),
                onWebViewCreated: (controller) {
                  updateController(controller);
                },
                initialSettings: InAppWebViewSettings(
                  underPageBackgroundColor: style.bgColor,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  useHybridComposition: true,
                  allowsInlineMediaPlayback: true,
                ),
                onPermissionRequest: (controller, permissionRequest) async {
                  return PermissionResponse(
                      resources: permissionRequest.resources,
                      action: PermissionResponseAction.GRANT);
                },
                onReceivedError: (controller, request, error) async {
                  await controller.loadData(
                    data: '',
                    mimeType: 'text/html',
                    encoding: 'utf-8',
                  );
                  LogUtils.e(
                      'sunzhibin - onLoadError: $request.url, $error.code, $error.message');
                  setState(() {
                    _loadError = true;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  if (![
                    'http',
                    'https',
                    'file',
                    'chrome',
                    'data',
                    'javascript',
                    'about'
                  ].contains(uri.scheme)) {
                    if (await canLaunchUrl(uri)) {
                      // Launch the App
                      await launchUrl(
                        uri,
                      );
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
              ));
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}
