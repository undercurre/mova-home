import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/voice/alexa/alexa_auth_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlexaAuthPage extends BasePage {
  static const String routePath = '/alexa_auth_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AlexaAuthPageState();
  }
}

class AlexaAuthPageState extends BasePageState<AlexaAuthPage>
    with ResponseForeUiEvent {
  @override
  bool get showTitle => false;

  @override
  void initData() {
    super.initData();
    final extra =
        AppRoutes().getGoRouterStateExtra<Map<String, dynamic>>(context) ?? {};
    ref.read(alexaAuthStateNotifierProvider.notifier).initData(extra);
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(alexaAuthStateNotifierProvider.select((value) => value.uiEvent),
        (pre, next) {
      if (next != null) {
        responseFor(next);
      }
    });
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: top + 40,
          ),
          Text(
            'alexa_auth_request_title'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                color: style.textMain,
                fontWeight: FontWeight.w600),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Image.asset(
                resource.getResource('icon_alexa_auth_logo'),
                width: 119,
                height: 100,
              ),
            ),
          ),
          Text(
            textAlign: TextAlign.center,
            'alexa_auth_content_title'.tr(),
            style: TextStyle(
                fontSize: 16,
                color: style.textMain,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 32),
            child: Image.asset(
              resource.getResource('icon_alexa_auth_large'),
              width: 80,
              height: 80,
            ),
          ),
          DMCommonClickButton(
              borderRadius: style.buttonBorder,
              backgroundGradient: style.confirmBtnGradient,
              disableBackgroundGradient: style.disableBtnGradient,
              textColor: style.confirmBtnTextColor,
              disableTextColor: style.disableBtnTextColor,
              pressedColor: style.confirmBtnTextColor.withAlpha(99),
              text: 'text_alexa_bind_agree'.tr(),
              onClickCallback: () async {
                showLoading();
                await ref
                    .read(alexaAuthStateNotifierProvider.notifier)
                    .alexaAuth();
              }),
          DMCommonClickButton(
              margin: const EdgeInsets.only(top: 16),
              borderRadius: style.buttonBorder,
              textColor: style.cancelBtnTextColor,
              pressedColor: style.lightBlack2.withAlpha(80),
              backgroundGradient: style.cancelBtnGradient,
              text: 'text_alexa_bind_reject'.tr(),
              onClickCallback: () async {
                await ref
                    .read(alexaAuthStateNotifierProvider.notifier)
                    .alexaCancel();
              }),
        ],
      ),
    );
  }
}
