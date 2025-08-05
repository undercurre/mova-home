import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/ui/widget/dm_switch.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:go_router/go_router.dart';

class UserConfigPage extends BasePage {
  static const String routePath = '/settings/about/userConfig';

  final UserConfigType userConfigType;
  const UserConfigPage({super.key, required this.userConfigType});

  @override
  UserConfigPageState createState() => UserConfigPageState();
}

class UserConfigPageState extends BasePageState<UserConfigPage>
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle {
    switch (widget.userConfigType) {
      case UserConfigType.uxPlan:
        return 'text_user_experience_plan'.tr();
      case UserConfigType.adManage:
        return 'personalized_ads_management'.tr();
      case UserConfigType.appRes:
        return 'app_res_change'.tr();
      default:
        return '';
    }
  }

  @override
  void initData() {
    ref
        .read(userConfigPageStateNotifierProvider
            .call(widget.userConfigType)
            .notifier)
        .initData();
  }

  @override
  void addObserver() {
    ref.listen(
        userConfigPageStateNotifierProvider
            .call(widget.userConfigType)
            .select((value) => value.uiEvent), (previous, next) {
      if (next != null) {
        responseFor(next);
      }
    });

    ref.listen(
        userConfigPageStateNotifierProvider
            .call(widget.userConfigType)
            .select((value) => value.loading), (previous, next) {
      if (next == true) {
        SmartDialog.showLoading();
      }else{
        Future.delayed(const Duration(milliseconds: 300), () {
          SmartDialog.dismiss();
        });
      }
    });
  }

  String _parseTitle() {
    switch (widget.userConfigType) {
      case UserConfigType.uxPlan:
        return 'text_user_experience_plan'.tr();
      case UserConfigType.adManage:
        return 'personalized_ads_management'.tr();
      case UserConfigType.appRes:
        return 'app_res_change'.tr();
      default:
        return '';
    }
  }

  Widget _buildDesc(StyleModel style, ResourceModel resource) {
    if (widget.userConfigType == UserConfigType.uxPlan) {
      return DMFormatRichText(
          content: 'text_user_experience_plan_desc'.tr(),
          richCallback: (index, key, content) {
            GoRouter.of(context).push(WebPage.routePath,
                extra: WebViewRequest(
                    uri: WebUri(ref
                        .read(userConfigPageStateNotifierProvider
                        .call(UserConfigType.uxPlan))
                        .privacyUrl),
                    defaultTitle: 'user_privacy_pri_index'.tr()));
          });
    }
    return Text(
        widget.userConfigType == UserConfigType.adManage
            ? 'personalized_ads_management_desc2'.tr()
            : 'app_res_change_desc'.tr(),
        style: style.secondStyle());
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      color: style.bgGray,
      padding: const EdgeInsets.only(top: 20).withRTL(context),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12).withRTL(context),
            decoration: BoxDecoration(
                color: style.bgWhite,
                borderRadius:
                    BorderRadius.all(Radius.circular(style.circular8))),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0).withRTL(context),
            height: 68,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 2).withRTL(context),
                          child: Text(
                            _parseTitle(),
                            style: TextStyle(
                                fontSize: style.largeText,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                color: style.textMain),
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                    width: 46,
                    height: 24,
                    child: DMSwitch(
                      width: 46,
                      height: 24,
                      activeImage:
                          AssetImage(resource.getResource('btn_switch_on')),
                      inActiveImage:
                          AssetImage(resource.getResource('btn_switch_off')),
                      value: ref.watch(userConfigPageStateNotifierProvider
                          .call(widget.userConfigType)
                          .select((value) => value.isOn)),
                      onChanged: (value) {
                        ref
                            .read(userConfigPageStateNotifierProvider
                                .call(widget.userConfigType)
                                .notifier)
                            .operate(value);
                      },
                    )),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 16, bottom: 0)),
          Container(
              margin:
                  const EdgeInsets.only(left: 16, right: 16).withRTL(context),
              child: _buildDesc(style, resource)),
        ],
      ),
    );
  }
}
