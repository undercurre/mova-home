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
import 'package:flutter_plugin/ui/page/settings/changePhone/change_phone_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/unbindPhone/unbind_phone_page.dart';
import 'package:flutter_plugin/ui/page/settings/userphone/user_phone_state_notifier.dart';
import 'package:flutter_plugin/ui/page/settings/userphone/user_phone_ui_state.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/dm_setting_item.dart';
import 'package:flutter_plugin/ui/widget/dm_textfield_item.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserPhoneSettingPage extends BasePage {
  static const String routePath = '/user_phone_seting';

  const UserPhoneSettingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return UserPhoneSettingPageState();
  }
}

class UserPhoneSettingPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  @override
  String get centerTitle => 'mine_phone_number'.tr();

  @override
  void initPageState() {}

  @override
  void initData() {
    super.initData();
    var extras = GoRouterState.of(context).extra;
    if (extras is Map<String, dynamic>) {
      String? phoneNumber = extras['phone'];
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        ref
            .read(userPhoneStateNotifierProvider.notifier)
            .changePageType(BindPhoneType.containPhoneType);
      }
    }

    ref.read(userPhoneStateNotifierProvider.notifier).getUserInfo();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(userPhoneEventProvider, (previous, next) {
      responseFor(next);
    });
  }

  Widget _containPhoneTipsCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    String phone = uiState.userInfo?.phone ?? '';
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: Text('current_phone'.tr(args: [phone]),
              style: TextStyle(
                  fontSize: style.largeText,
                  color: style.textMain,
                  fontWeight: FontWeight.w500)),
        ));
  }

  Widget _containPhoneCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(style.circular8))),
      child: DmSettingItem(
        paddingStart: 4,
        paddingEnd: 4,
        leadingTitle: 'set_new_phone'.tr(),
        showEndIcon: true,
        onTap: (_) {
          //更换手机号
          GoRouter.of(context).push(ChangePhonePage.routePath);
        },
      ),
    );
  }

  Widget _containPhoneConfirmUnbindCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 30),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          height: 52,
          borderRadius: style.buttonBorder,
          disableTextColor: style.textDisable,
          disableBorderColor: style.textDisable,
          textColor: style.largeGold,
          backgroundGradient: style.confirmBtnGradient,
          pressedColor: style.lightBlack1,
          disablePressedColor: style.bgGray,
          enable: ref.watch(userPhoneStateNotifierProvider
              .select((value) => value.enableUnbindButton)),
          text: ref.watch(userPhoneStateNotifierProvider).unbindButtonText,
          margin: const EdgeInsets.only(top: 51).withRTL(context),
          onClickCallback: () async {
            //解除绑定
            bool containMail = await ref
                .read(userPhoneStateNotifierProvider.notifier)
                .checkContainEMail();

            if (!containMail) {
              ref
                  .read(userPhoneEventProvider.notifier)
                  .sendEvent(ToastEvent(text: 'not_allow_unbind_phone'.tr()));
            } else {
              GoRouter.of(context).push(UnbindPhoneSettingPage.routePath);
            }
          },
        ),
      ),
    );
  }

  Widget _notBindPhonetipsCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 18, 10, 18),
      width: double.infinity,
      child: Text(
        'bind_signin_phone_code'.tr(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: style.textMain,
          fontSize: style.largeText,
        ),
      ),
    );
  }

  Widget _notBindPhoneNumberCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    return DMTextFieldItem(
      inputStyle: style.mainStyle(fontSize:16),
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      text: ref.watch(userPhoneStateNotifierProvider).phoneNumber,
      keyboardType: TextInputType.number,
      placeText: 'please_input_mobile'.tr(),
      onChanged: (value) {
        ref
            .read(userPhoneStateNotifierProvider.notifier)
            .changePhoneNumber(value);
      },
    );
  }

  Widget _notBindPhoneCodeCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    bool enableStatus = ref.watch(userPhoneStateNotifierProvider
        .select((value) => (value.enableValidCodeButton)));

    bool timerRunning = ref.watch(
        userPhoneStateNotifierProvider.select((value) => (value.timerRunning)));
    bool buttonEnableStyle = enableStatus || timerRunning;
    Widget clickButton = GestureDetector(
      onTap: () async {
        bool enable = ref.watch(userPhoneStateNotifierProvider
            .select((value) => value.enableValidCodeButton));
        if (enable && uiState.enableSend) {
          await clickBindGetPhoneCodeAction();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ref.watch(userPhoneStateNotifierProvider
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
      keyboardType: TextInputType.number,
      maxLength: 6,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      placeText: 'input_verify_code'.tr(),
      text: ref.watch(userPhoneStateNotifierProvider).phoneCode,
      inputStyle: style.mainStyle(fontSize:16),
      rightWidget: clickButton,
      onChanged: (value) {
        ref
            .read(userPhoneStateNotifierProvider.notifier)
            .changeBindPhoneCodeNumber(value);
      },
      onEditingComplete: (value) {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _notBindPhoneComfirmBindCell(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 56),
      child: SizedBox(
        width: double.infinity,
        child: DMCommonClickButton(
          height: 52,
          borderRadius: style.buttonBorder,
          disableBackgroundGradient: style.disableBtnGradient,
          disableTextColor: style.disableBtnTextColor,
          textColor: style.enableBtnTextColor,
          backgroundGradient: style.confirmBtnGradient,
          enable: ref.watch(userPhoneStateNotifierProvider
              .select((value) => value.enableBindButton)),
          text: 'bind'.tr(),
          margin: const EdgeInsets.only(top: 51).withRTL(context),
          onClickCallback: () async {
            bool success = await ref
                .read(userPhoneStateNotifierProvider.notifier)
                .bindPhoneAction();
            if (success) {
              ref
                  .read(userPhoneEventProvider.notifier)
                  .sendEvent(ToastEvent(text: 'bind_success'.tr()));
              await Future.delayed(const Duration(milliseconds: 200));
              GoRouter.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  // 已有手机号
  List<Widget> _containPhoneNumber(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    List<Widget> widgetList = [];
    bool isOverSea = (uiState.currentRegion.countryCode.toLowerCase() != 'cn')
        ? true
        : false;
    widgetList.add(_containPhoneTipsCell(context, style, resource, uiState));
    widgetList.add(_containPhoneCell(context, style, resource, uiState));
    if (isOverSea) {
      widgetList.add(
          _containPhoneConfirmUnbindCell(context, style, resource, uiState));
    }
    return widgetList;
  }

  // 没有绑定手机号
  List<Widget> _noContainPhoneNumber(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    List<Widget> widgetList = [];
    widgetList.add(_notBindPhonetipsCell(context, style, resource, uiState));
    widgetList.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: RegionSelectMeun(canTap: false),
    ));
    widgetList.add(_notBindPhoneNumberCell(context, style, resource, uiState));
    widgetList.add(_notBindPhoneCodeCell(context, style, resource, uiState));
    widgetList
        .add(_notBindPhoneComfirmBindCell(context, style, resource, uiState));
    return widgetList;
  }

  Widget buildContenteBody(BuildContext context, StyleModel style,
      ResourceModel resource, UserPhoneUiState uiState) {
    List<Widget> widgetList = [];

    if (uiState.bindPhoneType == BindPhoneType.containPhoneType) {
      widgetList.addAll(_containPhoneNumber(context, style, resource, uiState));
    } else {
      widgetList
          .addAll(_noContainPhoneNumber(context, style, resource, uiState));
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
    UserPhoneUiState uiState = ref.watch(userPhoneStateNotifierProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
      width: double.infinity,
      height: double.infinity,
      color: style.bgGray,
        child: SingleChildScrollView(
          child: buildContenteBody(context, style, resource, uiState),
        ),
      ),
    );
  }
}

extension UserPhoneSettingPageAction on UserPhoneSettingPageState {
  Future<void> clickBindGetPhoneCodeAction() async {
    if (ref.read(userPhoneStateNotifierProvider.notifier).checkPhoneNumber()) {
      await RecaptchaController(context, (recaptchaModel) {
        getBindVerifyCode(recaptchaModel);
      }).check();
    }
  }

  // 发送验证码
  Future<void> getBindVerifyCode(RecaptchaModel recaptchaModel) async {
    var ret = await ref
        .read(userPhoneStateNotifierProvider.notifier)
        .getPhoneCodeAction(recaptchaModel)
        .then((value) => value.second);
    if (ret != null) {
      ref
          .read(userPhoneEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'send_success'.tr()));
    }
  }

  void _clickRegionItem() {
    RegionItem currentItem = RegionStore().currentRegion;
    if (currentItem.countryCode.toLowerCase() == 'cn') return;
    Future<RegionItem?> selectItem = GoRouter.of(context).push(
        RegionPickerPage.routePath,
        extra: RegionPickerPage.createExtra(
            ref.read(userPhoneStateNotifierProvider).currentRegion));
    ref.read(userPhoneStateNotifierProvider.notifier).changeRegion(selectItem);
  }
}
