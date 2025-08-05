import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/unbindMail/unbind_mail_page.dart';
import 'package:flutter_plugin/ui/page/settings/usermail/user_mail_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/usermail/user_mail_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/utils/alignment_extension.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserMailSettingPage extends BasePage {
  static const String routePath = '/user_mail_seting';

  const UserMailSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserMailSettingPageState();
  }
}

class UserMailSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'mine_email'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    var extras = GoRouterState.of(context).extra;
    if (extras is Map<String, dynamic>) {
      String? emailAddress = extras['emailAddress'];
      if (emailAddress != null && emailAddress.isNotEmpty) {
        ref
            .read(userMailStateNotifierProvider.notifier)
            .changeEmailAddress(emailAddress);
        ref
            .read(userMailStateNotifierProvider.notifier)
            .changePageType(BindMailEnum.containMailType);
      }
    }
  }

  @override
  void addObserver() {
    ref.listen(userMailUiEventProvider, (previous, next) {
      responseFor(next);
    });
    ref.listen(userMailStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Widget _emailCell1(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    return DMTextFieldItem(
        inputStyle: style.fourthStyle(),
        width: double.infinity,
        height: 52,
        padding: EdgeInsets.zero,
        showClear: true,
        text: ref.read(userMailStateNotifierProvider).emailAddress,
        placeText: 'please_input_email'.tr(),
        onChanged: (value) {
          ref
              .watch(userMailStateNotifierProvider.notifier)
              .changeEmailAddress(value);
        });
  }

  Widget _mailCodeCell1(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    bool enableStatus = ref.watch(userMailStateNotifierProvider
        .select((value) => (value.enableMailCodeButton)));
    bool timerRunning = ref.watch(
        userMailStateNotifierProvider.select((value) => (value.timerRunning)));
    bool buttonEnableStyle = enableStatus || timerRunning;

    Widget clickButton = GestureDetector(
      onTap: () async {
        bool enable = ref.watch(userMailStateNotifierProvider
            .select((value) => value.enableMailCodeButton));
        if (enable && uiState.enableSend) {
          await tapGetVaildCodeNumber();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ref.watch(userMailStateNotifierProvider
                .select((value) => value.sendMailCodeStr)),
            style:
                buttonEnableStyle ? style.clickStyle() : style.disableStyle(),
          )
        ],
      ),
    );

    return DMTextFieldItem(
        inputStyle: style.fourthStyle(),
        width: double.infinity,
        height: 52,
        padding: EdgeInsets.zero,
        keyboardType: TextInputType.number,
      maxLength: 6,
        placeText: 'input_verify_code'.tr(),
        text: ref.read(userMailStateNotifierProvider).emailAddressCode,
        rightWidget: clickButton,
        onChanged: (value) {
          ref
              .watch(userMailStateNotifierProvider.notifier)
              .changeEmailAddressCode(value);
      },
      onEditingComplete: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _mailAgreeLicenceCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    return Align(
      alignment: Alignment.centerLeft.withRTL(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 29, bottom: 29)
            .withRTL(context),
        child: GestureDetector(
          onTap:
              ref.read(userMailStateNotifierProvider.notifier).agreementChange,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8).withRTL(context),
                    child: Image(
                      image: AssetImage(resource.getResource(ref.watch(
                              userMailStateNotifierProvider
                                  .select((value) => value.agreed))
                          ? 'ic_agreement_selected'
                          : 'ic_agreement_unselect')),
                      width: 14,
                      height: 14,
                    ).flipWithRTL(context),
                  ),
                ),
                TextSpan(
                  text: 'email_collection_subscribe_alert'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: style.textSecondGray,
                  ),
                ),
              ],
            ),
          ).flipWithRTL(context),
        ),
      ),
    );
  }

  Widget _comfirmCell1(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          height: 52,
          borderRadius: style.buttonBorder,
          disableBackgroundGradient: style.disableBtnGradient,
          disableTextColor: style.disableBtnTextColor,
          backgroundGradient: style.confirmBtnGradient,
          textColor: style.enableBtnTextColor,
          enable: ref.watch(userMailStateNotifierProvider
              .select((value) => value.enableBindButton)),
          text: 'bind'.tr(),
          margin: const EdgeInsets.only(top: 51).withRTL(context),
          onClickCallback: () async {
            bool success = await ref
                .watch(userMailStateNotifierProvider.notifier)
                .bindEmailAction(false);
            if (success) {
              ref
                  .watch(userMailUiEventProvider.notifier)
                  .sendEvent(ToastEvent(text: 'bind_success'.tr()));
              GoRouter.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  Widget _tipsCell2(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    return Container(
      margin: const EdgeInsets.fromLTRB(4, 18, 4, 18),
      width: double.infinity,
      child: Text(
        'current_email'.tr(args: [uiState.emailAddress ?? '']),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style.textMain,
          fontSize: style.largeText,
        ),
      ),
    );
  }

  Widget _changeMailCell3(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      child: DmSettingItem(
        paddingStart: 4,
        paddingEnd: 4,
        leadingTitle: 'change_email'.tr(),
        showEndIcon: true,
        onTap: (_) {
          ref
              .watch(userMailStateNotifierProvider.notifier)
              .pushChangeMailPage();
        },
      ),
    );
  }

  Widget _changeUnbindCell3(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          width: double.infinity,
          height: 52,
          backgroundGradient: style.confirmBtnGradient,
          borderRadius: style.buttonBorder,
          textColor: style.largeGold,
          backgroundColor: style.bgGray,
          pressedColor: style.lightBlack1,
          enable: true,
          text: 'unbind'.tr(),
          onClickCallback: () async {
            //解除绑定
            //解除绑定
            bool containPhone = await ref
                .read(userMailStateNotifierProvider.notifier)
                .checkContainPhone();
            //解除绑定
            bool containPassword = await ref
                .read(userMailStateNotifierProvider.notifier)
                .checkContainPassword();

            if (!containPhone) {
              ref
                  .read(userMailUiEventProvider.notifier)
                  .sendEvent(ToastEvent(text: 'not_allow_unbind_phone'.tr()));
            } else if (!containPassword) {
              showCommonDialog(
                  content: 'Popup_Me_Account_AddEmail_Unbundle'.tr(),
                  cancelContent: 'cancel'.tr(),
                  confirmContent: 'set_password'.tr(),
                  confirmCallback: () {
                    ref
                        .read(userMailStateNotifierProvider.notifier)
                        .pushUserPasswordSettingPage();
                  });
            } else {
              GoRouter.of(context).push(UnbindMailSettingPage.routePath,
                  extra: {'emailAddress': uiState.emailAddress});
            }
          },
        ),
      ),
    );
  }

  // 未注册邮箱逻辑
  List<Widget> _notBindMailContent(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    bool isOverSea = (uiState.currentRegion.countryCode.toLowerCase() != 'cn')
        ? true
        : false;
    List<Widget> widgetList = [];
    widgetList.add(_emailCell1(context, style, resource, uiState));
    widgetList.add(_mailCodeCell1(context, style, resource, uiState));
    // if (isOverSea) {
    //   widgetList.add(_mailAgreeLicenceCell(context, style, resource, uiState));
    // }
    widgetList.add(_comfirmCell1(context, style, resource, uiState));
    return widgetList;
  }

  // 更换邮箱逻辑
  List<Widget> _containMailContent(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_tipsCell2(context, style, resource, uiState));
    widgetList.add(_changeMailCell3(context, style, resource, uiState));
    widgetList.add(_changeUnbindCell3(context, style, resource, uiState));
    return widgetList;
  }

  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UserMailUiState uiState) {
    List<Widget> widgetList = [];
    if (uiState.pageType == BindMailEnum.notBindMailType) {
      widgetList = _notBindMailContent(context, style, resource, uiState);
    } else if (uiState.pageType == BindMailEnum.containMailType) {
      widgetList = _containMailContent(context, style, resource, uiState);
    }

    return Container(
      color: style.bgGray,
      child: Container(
        padding: const EdgeInsets.all(20),
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
    UserMailUiState uiState = ref.watch(userMailStateNotifierProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
      child: buildContenteBody(context, style, resource, uiState),
      ),
    );
  }
}

extension UserMailSettingPageAction on UserMailSettingPageState {
  Future<void> tapGetVaildCodeNumber() async {
    if (ref.read(userMailStateNotifierProvider.notifier).verifyMailFormat()) {
      await RecaptchaController(context, (recaptchaModel) {
        ref
            .read(userMailStateNotifierProvider.notifier)
            .getEmailCodeAction(recaptchaModel);
      }).check();
    }
  }
}
