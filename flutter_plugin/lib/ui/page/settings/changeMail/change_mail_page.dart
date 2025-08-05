import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/changeMail/change_mail_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/changeMail/change_mail_ui_state.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/utils/alignment_extension.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangeMailSettingPage extends BasePage {
  static const String routePath = '/change_mail_seting';

  const ChangeMailSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChangeMailSettingPageState();
  }
}

class ChangeMailSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'change_email'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    super.initData();
    var extras = GoRouterState.of(context).extra;
    if (extras is Map<String, dynamic>) {
      String? emailAddress = extras['emailAddress'];
      if (emailAddress != null && emailAddress.isNotEmpty) {
        ref
            .watch(changeMailStateNotifierProvider.notifier)
            .changeEmailAddress(emailAddress);
      }
    }

    ref.watch(changeMailStateNotifierProvider.notifier).getUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(changeMailUiEventProvider, (previous, next) {
      responseFor(next);
    });
    ref.listen(changeMailStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  Widget _emailCell1(BuildContext context, StyleModel style,
      ResourceModel resource, ChangeMailUiState uiState) {
    return DMTextFieldItem(
        padding: EdgeInsets.zero,
        width: double.infinity,
        height: 52,
        showClear: true,
        borderRadius: style.cellBorder,
        inputStyle: TextStyle(
          color: style.textMainBlack,
          fontSize: 16,
        ),
        text: ref.read(changeMailStateNotifierProvider).emailAddress,
        placeText: 'please_input_email'.tr(),
        onChanged: (value) {
          ref
              .watch(changeMailStateNotifierProvider.notifier)
              .changeEmailAddress(value);
        });
  }

  Widget _emailCodeCell1(BuildContext context, StyleModel style,
      ResourceModel resource, ChangeMailUiState uiState) {
    bool enableStatus = ref.watch(changeMailStateNotifierProvider
        .select((value) => (value.enableMailCodeButton)));

    bool timerRunning = ref.watch(changeMailStateNotifierProvider
        .select((value) => (value.timerRunning)));
    bool buttonEnableStyle = enableStatus || timerRunning;

    Widget clickButton = GestureDetector(
      onTap: () async {
        bool enable = ref.watch(changeMailStateNotifierProvider
            .select((value) => value.enableMailCodeButton));
        if (enable && uiState.enableSend) {
          await tapGetVaildCodeNumber();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ref.watch(changeMailStateNotifierProvider
                .select((value) => value.sendMailCodeStr)),
            style:
                buttonEnableStyle ? style.clickStyle() : style.disableStyle(),
          )
        ],
      ),
    );

    return DMTextFieldItem(
        inputStyle: TextStyle(
          color: style.textMainBlack,
          fontSize: 16,
        ),
        width: double.infinity,
        height: 52,
      maxLength: 6,
        padding: EdgeInsets.zero,
        borderRadius: style.cellBorder,
        keyboardType: TextInputType.number,
        placeText: 'input_verify_code'.tr(),
        text: ref.read(changeMailStateNotifierProvider).emailAddressCode,
        rightWidget: clickButton,
    
        onChanged: (value) {
          ref
              .watch(changeMailStateNotifierProvider.notifier)
              .changeEmailAddressCode(value);
      },
      onEditingComplete: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _comfirmCell1(BuildContext context, StyleModel style,
      ResourceModel resource, ChangeMailUiState uiState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          height: 52,
          disableBackgroundGradient: style.disableBtnGradient,
          disableTextColor: style.disableBtnTextColor,
          textColor: style.enableBtnTextColor,
          backgroundGradient: style.confirmBtnGradient,
          borderRadius: style.buttonBorder,
          enable: ref.watch(changeMailStateNotifierProvider
              .select((value) => value.enableBindButton)),
          text: 'bind'.tr(),
          margin: const EdgeInsets.only(top: 51).withRTL(context),
          onClickCallback: tapBindAction,
        ),
      ),
    );
  }

  Widget _mailAgreeLicenceCell(BuildContext context, StyleModel style,
      ResourceModel resource, ChangeMailUiState uiState) {
    return Align(
      alignment: Alignment.centerLeft.withRTL(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 29, bottom: 29)
            .withRTL(context),
        child: GestureDetector(
          onTap: ref
              .read(changeMailStateNotifierProvider.notifier)
              .agreementChange,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8).withRTL(context),
                    child: Image(
                      image: AssetImage(resource.getResource(ref.watch(
                              changeMailStateNotifierProvider
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
          ),
        ),
      ),
    );
  }

  // 更换邮箱逻辑
  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, ChangeMailUiState uiState) {
    List<Widget> widgetList = [];
    bool isOverSea = (uiState.currentRegion.countryCode.toLowerCase() != 'cn')
        ? true
        : false;

    widgetList.add(_emailCell1(context, style, resource, uiState));
    widgetList.add(_emailCodeCell1(context, style, resource, uiState));
    // if (isOverSea) {
    //   widgetList.add(_mailAgreeLicenceCell(context, style, resource, uiState));
    // }
    widgetList.add(_comfirmCell1(context, style, resource, uiState));

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
    ChangeMailUiState uiState = ref.watch(changeMailStateNotifierProvider);

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

extension ChangeMailSettingPageAction on ChangeMailSettingPageState {
  Future<void> tapGetVaildCodeNumber() async {
    LogUtils.i('changemailPage tapGetVaildCodeNumber');
    if (ref.read(changeMailStateNotifierProvider.notifier).verifyMailFormat()) {
      await RecaptchaController(context, (recaptchaModel) {
        ref
            .watch(changeMailStateNotifierProvider.notifier)
            .getEmailCodeAction(recaptchaModel);
      }).check();
    }
  }

  Future<void> tapBindAction() async {
    bool success = await ref
        .watch(changeMailStateNotifierProvider.notifier)
        .bindEmailAction(false);
    if (success) {
      ref
          .watch(changeMailUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'bind_success'.tr()));
      ref.watch(changeMailUiEventProvider.notifier).sendEvent(
          PushEvent(path: AccountSettingPage.routePath, func: RouterFunc.pop));
    }
  }
}
