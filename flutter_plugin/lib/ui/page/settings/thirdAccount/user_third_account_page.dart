import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/model/account/social.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/thirdAccount/user_third_account_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/thirdAccount/user_third_account_ui_state.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:flutter_plugin/ui/widget/account/social/social_login_auth.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_custome_cell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserThirdAccountSettingPage extends BasePage {
  static const String routePath = '/user_third_account_seting';
  const UserThirdAccountSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserThirdAccountSettingPageState();
  }
}

class UserThirdAccountSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent, SocialLoginAuth {
  @override
  String get centerTitle => 'Me_AccountSetting_3rdPardBundle'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    super.initData();
    ref.read(userThirdAccountNotifierProvider.notifier).getBindListAction();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(userThirdAccountUiEventProvider, (previous, next) {
      responseFor(next);
    });
    ref.listen(userThirdAccountNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Widget _appleCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserThirdAccountUiState uiState) {
    var type = SocialPlatformType.apple;
    bool status = uiState.bindApple;
    Widget bindWidget = DMButton(
      text: status == true ? 'alexa_already_bind'.tr() : 'alexa_not_bind'.tr(),
      fontsize: 14,
      textColor: status == true ? style.textDisable : style.click,
      fontWidget: FontWeight.w500,
      backgroundColor: Colors.transparent,
      borderRadius: style.buttonBorder,
      padding: const EdgeInsets.symmetric(vertical: 14),
      onClickCallback: (_) {
        if (status == true) {
          _tapUnbindButtonClick(SocialPlatformType.apple.textValue,
              _getSocialInfoWithType(type, uiState));
        } else {
          _tapBindButtonClick(type, type.textValue);
        }
      },
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.buttonBorder))),
      child: DmCustomeCell(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        leadingWidge: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Semantics(
                label: 'sign_up_with_apple'.tr(),
                child: Image.asset(
                  resource.getResource('ic_bind_apple_small'),
                  width: 36,
                  height: 36,
                ),
              ),
            ),
            Text(
              type.textValue,
              style: TextStyle(color: style.textMainBlack),
            ),
          ],
        ),
        // paddingEnd: 0,
        showEndIcon: true,
        endWidget: GestureDetector(
          onTap: () async {
            // SmartDialog.showToast('copyed'.tr());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 6),
            child: bindWidget,
          ),
        ),
      ),
    );
  }

  Widget _weixinCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserThirdAccountUiState uiState) {
    var type = SocialPlatformType.wechat;

    bool status = uiState.bindWeChat;
    Widget bindWidget = DMButton(
      text: status == true ? 'alexa_already_bind'.tr() : 'alexa_not_bind'.tr(),
      fontsize: 14,
      textColor: status == true ? style.textDisable : style.click,
      fontWidget: FontWeight.w500,
      backgroundColor: Colors.transparent,
      borderRadius: style.buttonBorder,
      padding: const EdgeInsets.symmetric(vertical: 14),
      onClickCallback: (_) {
        if (status == true) {
          _tapUnbindButtonClick(SocialPlatformType.wechat.textValue,
              _getSocialInfoWithType(type, uiState));
        } else {
          _tapBindButtonClick(type, type.textValue);
        }
      },
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.cellBorder))),
      child: DmCustomeCell(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        leadingWidge: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                resource.getResource('ic_bind_wechat_small'),
                width: 36,
                height: 36,
              ),
            ),
            Text(
              'share_weixin'.tr(),
              style: TextStyle(color: style.textMainBlack),
            ),
          ],
        ),
        // paddingEnd: 0,
        showEndIcon: true,
        endWidget: GestureDetector(
          onTap: () async {
            // SmartDialog.showToast('copyed'.tr());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 6),
            child: bindWidget,
          ),
        ),
      ),
    );
  }

  Widget _googleCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserThirdAccountUiState uiState) {
    var type = SocialPlatformType.google;
    bool status = uiState.bindGoogle;
    Widget bindWidget = DMButton(
      text: status == true ? 'alexa_already_bind'.tr() : 'alexa_not_bind'.tr(),
      fontsize: 14,
      textColor: status == true ? style.textDisable : style.click,
      fontWidget: FontWeight.w500,
      backgroundColor: Colors.transparent,
      borderRadius: style.buttonBorder,
      padding: const EdgeInsets.symmetric(vertical: 14),
      onClickCallback: (_) {
        if (status == true) {
          _tapUnbindButtonClick(SocialPlatformType.google.textValue,
              _getSocialInfoWithType(type, uiState));
        } else {
          _tapBindButtonClick(type, type.textValue);
        }
      },
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.cellBorder))),
      child: DmCustomeCell(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        leadingWidge: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                resource.getResource('ic_bind_google_small'),
                width: 36,
                height: 36,
              ),
            ),
            Text(type.textValue, style: style.thirdStyle()),
          ],
        ),
        // paddingEnd: 0,
        showEndIcon: true,
        endWidget: GestureDetector(
          onTap: () async {
            // SmartDialog.showToast('copyed'.tr());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 6),
            child: bindWidget,
          ),
        ),
      ),
    );
  }

  Widget _facebookCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserThirdAccountUiState uiState) {
    var type = SocialPlatformType.facebook;
    bool status = uiState.bindFacebook;
    Widget bindWidget = DMButton(
      text: status == true ? 'alexa_already_bind'.tr() : 'alexa_not_bind'.tr(),
      fontsize: 14,
      textColor: status == true ? style.textDisable : style.click,
      fontWidget: FontWeight.w500,
      backgroundColor: Colors.transparent,
      borderRadius: style.buttonBorder,
      padding: const EdgeInsets.symmetric(vertical: 14),
      onClickCallback: (_) {
        if (status == true) {
          _tapUnbindButtonClick(SocialPlatformType.facebook.textValue,
              _getSocialInfoWithType(type, uiState));
        } else {
          _tapBindButtonClick(type, type.textValue);
        }
      },
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.cellBorder))),
      child: DmCustomeCell(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        leadingWidge: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                resource.getResource('ic_bind_facebook_small'),
                width: 36,
                height: 36,
              ),
            ),
            Text(type.textValue, style: style.thirdStyle()),
          ],
        ),
        // paddingEnd: 0,
        showEndIcon: true,
        endWidget: GestureDetector(
          onTap: () async {
            // SmartDialog.showToast('copyed'.tr());
          },
          child: Container(
            padding: const EdgeInsets.only(right: 6),
            child: bindWidget,
          ),
        ),
      ),
    );
  }

  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UserThirdAccountUiState uiState) {
    List<Widget> widgetList = [];
    if (uiState.showApple)
      widgetList.add(_appleCell(context, style, resource, uiState));
    if (uiState.showWeChat)
      widgetList.add(_weixinCell(context, style, resource, uiState));
    if (uiState.showGoogle)
      widgetList.add(_googleCell(context, style, resource, uiState));
    if (uiState.showFacebook)
      widgetList.add(_facebookCell(context, style, resource, uiState));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgetList),
      ),
    );
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    UserThirdAccountUiState uiState =
        ref.watch(userThirdAccountNotifierProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildContenteBody(context, style, resource, uiState),
    );
  }
}

extension UserThirdAccountSettingPageAction
    on UserThirdAccountSettingPageState {
  Future<void> _tapBindButtonClick(
      SocialPlatformType platform, String platformName) async {
    await _switchPlatform(platform, platformName);
  }

  Future<void> _switchPlatform(
      SocialPlatformType platformType, String platformName) async {
    if (platformType == SocialPlatformType.google) {
      Pair<bool, String?> pair = await googleLogin();
      // ignore: unrelated_type_equality_checks
      if (pair.first != true) {
        return;
      }
      await ref.read(userThirdAccountNotifierProvider.notifier).bindAction(
          pair.second!, SocialPlatformType.google, false, platformName);
    } else if (platformType == SocialPlatformType.apple) {
      await appleLogin((code, token) {
        // 获取参数试试看看；
        if (code != CODE_AUTH_SUCCESS) {
          ref.read(userThirdAccountUiEventProvider.notifier).sendEvent(
              ToastEvent(text: 'Toast_3rdPartyBundle_ResultFailed'.tr()));
          return;
        }
        ref.read(userThirdAccountNotifierProvider.notifier).bindAction(
            token ?? '', SocialPlatformType.apple, false, platformName);
      });
    } else if (platformType == SocialPlatformType.wechat) {
      await wechatLogin((code, token) {
        if (context.mounted) {
          if (code != CODE_AUTH_SUCCESS) {
            ref.read(userThirdAccountUiEventProvider.notifier).sendEvent(
                ToastEvent(text: 'Toast_3rdPartyBundle_ResultFailed'.tr()));
            return;
          }
          ref.read(userThirdAccountNotifierProvider.notifier).bindAction(
              token ?? '', SocialPlatformType.wechat, false, platformName);
        }
      });
    } else if (platformType == SocialPlatformType.facebook) {
      Pair<bool, SocialTruck?> pair = await facebookLogin();
      if (pair.first != true) {
        return;
      }
      await ref.read(userThirdAccountNotifierProvider.notifier).bindAction(
          pair.second!, SocialPlatformType.facebook, false, platformName);
    }
  }

  SocialInfo? _getSocialInfoWithType(
      SocialPlatformType platform, UserThirdAccountUiState uiState) {
    String type = platform.value;
    for (int i = 0; i < uiState.platformList.length; i++) {
      SocialInfo model = uiState.platformList[i];
      if (model.source == type) {
        return model;
      }
    }
    return null;
  }

  void _tapUnbindButtonClick(String platform, SocialInfo? model) {
    if (model == null) return;
    showCommonDialog(
        content: 'Toast_3rdPartyBundle_Unbundle'.tr(args: [platform]),
        cancelContent: 'cancel'.tr(),
        confirmContent: 'dialog_determine'.tr(),
        confirmCallback: () async {
          await ref
              .read(userThirdAccountNotifierProvider.notifier)
              .unbindAction(model.id ?? '', model.source ?? '');
          await ref
              .read(userThirdAccountNotifierProvider.notifier)
              .getBindListAction();
        });
  }
}
