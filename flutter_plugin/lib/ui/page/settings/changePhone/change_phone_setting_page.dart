import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/changePhone/change_phone_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/changePhone/change_phone_ui_state.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePhonePage extends BasePage {
  static const String routePath = '/change_setting_phone_page';

  const ChangePhonePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ChangePhonePageState();
  }
}

class ChangePhonePageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'mine_phone_number'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    ref.watch(changePhoneStateNotifierProvider.notifier).getUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(changePhoneUiEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Widget _changePhoneNumberCell(BuildContext context, StyleModel style,
      ResourceModel resource, ChangePhoneUiState uiState) {
    String countryCode = uiState.currentRegion.code;
    return DMTextFieldItem(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 52,
      borderRadius: style.cellBorder,
      text: ref.watch(changePhoneStateNotifierProvider).phoneNumber,
      keyboardType: TextInputType.number,
      inputStyle: TextStyle(
        color: style.textMainBlack,
        fontSize: 16,
      ),
      placeText: 'please_input_mobile'.tr(),
      onChanged: (value) {
        ref
            .watch(changePhoneStateNotifierProvider.notifier)
            .changePhoneNumber(value);
      },
    );
  }

  Widget _changePhoneCodeCell(BuildContext context, StyleModel style,
      ResourceModel resource, ChangePhoneUiState uiState) {
    bool enableStatus = ref.watch(changePhoneStateNotifierProvider
        .select((value) => (value.enableValidCodeButton)));

    bool timerRunning = ref.watch(changePhoneStateNotifierProvider
        .select((value) => (value.timerRunning)));
    bool buttonEnableStyle = enableStatus || timerRunning;

    Widget clickButton = GestureDetector(
      onTap: () async {
        bool enable = ref.watch(changePhoneStateNotifierProvider
            .select((value) => value.enableValidCodeButton));
        if (enable && uiState.enableSend) {
          await clickBindGetPhoneCodeAction();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ref.watch(changePhoneStateNotifierProvider
                .select((value) => value.sendMailCodeStr)),
            style:
                buttonEnableStyle ? style.clickStyle() : style.disableStyle(),
          )
        ],
      ),
    );

    return DMTextFieldItem(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      keyboardType: TextInputType.number,
      placeText: 'input_verify_code'.tr(),
      maxLength: 6,
      borderRadius: style.cellBorder,
      text: ref.watch(changePhoneStateNotifierProvider).phoneCode,
      rightWidget: clickButton,
      inputStyle: TextStyle(
        color: style.textMainBlack,
        fontSize: 16,
      ),
      onChanged: (value) {
        ref
            .read(changePhoneStateNotifierProvider.notifier)
            .changeBindPhoneCodeNumber(value);
      },
      onEditingComplete: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _changePhoneComfirmBindCell(BuildContext context, StyleModel style,
      ResourceModel resource, ChangePhoneUiState uiState) {
    return Container(
      // color: Colors.red,
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
          enable: ref.watch(changePhoneStateNotifierProvider
              .select((value) => value.enableBindButton)),
          text: 'bind'.tr(),
          margin: const EdgeInsets.only(top: 51).withRTL(context),
          onClickCallback: () async {
            bool success = await ref
                .watch(changePhoneStateNotifierProvider.notifier)
                .bindPhoneAction();
            if (success) {
              ref
                  .read(changePhoneUiEventProvider.notifier)
                  .sendEvent(ToastEvent(text: 'bind_success'.tr()));
              await Future.delayed(const Duration(milliseconds: 200));
              ref.watch(changePhoneUiEventProvider.notifier).sendEvent(
                  PushEvent(
                      path: AccountSettingPage.routePath,
                      func: RouterFunc.pop));
            }
          },
        ),
      ),
    );
  }

  // 更换绑定手机号
  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, ChangePhoneUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: RegionSelectMeun(canTap: false),
    ));
    widgetList.add(_changePhoneNumberCell(context, style, resource, uiState));
    widgetList.add(_changePhoneCodeCell(context, style, resource, uiState));
    widgetList
        .add(_changePhoneComfirmBindCell(context, style, resource, uiState));

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
    ChangePhoneUiState uiState = ref.watch(changePhoneStateNotifierProvider);

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

extension ChangePhonePageAction on ChangePhonePageState {
  Future<void> clickBindGetPhoneCodeAction() async {
    if (ref
        .read(changePhoneStateNotifierProvider.notifier)
        .checkPhoneNumber()) {
      await RecaptchaController(context, (recaptchaModel) {
        getBindVerifyCode(recaptchaModel);
      }).check();
    }
  }

  // 发送验证码
  Future<void> getBindVerifyCode(RecaptchaModel recaptchaModel) async {
    var ret = await ref
        .read(changePhoneStateNotifierProvider.notifier)
        .getPhoneCodeAction(recaptchaModel)
        .then((value) => value.second);
    if (ret != null) {
      ref
          .read(changePhoneUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_success'.tr()));
    }
  }

  void _clickRegionItem() {
    RegionItem currentItem = RegionStore().currentRegion;
    if (currentItem.countryCode.toLowerCase() == 'cn') return;
    Future<RegionItem?> selectItem = GoRouter.of(context).push(
        RegionPickerPage.routePath,
        extra: RegionPickerPage.createExtra(
            ref.read(changePhoneStateNotifierProvider).currentRegion));
    ref
        .read(changePhoneStateNotifierProvider.notifier)
        .changeRegion(selectItem);
  }
}
