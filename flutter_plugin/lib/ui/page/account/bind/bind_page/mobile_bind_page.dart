import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/bind_page/mobile_bind_state_notifier.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu.dart';
import 'package:flutter_plugin/ui/widget/animated_input_text.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

class MobileBindPage extends BasePage {
  static const String routePath = '/mobile_bind_page';

  const MobileBindPage({super.key});

  @override
  MobileBindPageState createState() {
    return MobileBindPageState();
  }
}

class MobileBindPageState extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  late MobileBindStateNotifier notifier =
      ref.read(mobileBindStateNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    notifier.onLoad();
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(mobileBindStateNotifierProvider.select((value) => value.event),
        (previous, next) {
      responseFor(next);
    });
  }

  @override
  String get centerTitle => 'mine_phone_number'.tr();

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20).withRTL(context),
      child: Column(
        children: [
          Text(
            'bind_signin_phone_code'.tr(),
            style: style.secondStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40).withRTL(context),
            child: const RegionSelectMeun(
              canTap: false,
            ),
          ),
          AnimatedInputText(
            onTextChanged: (value) {
              notifier.phoneNumberChange(value);
            },
            textHint: 'please_input_mobile'.tr(),
            showCountryCode: false,
            showGetDynamicCode: false,
            textInputType: TextInputType.number,
            changeCountryCode: () {},
          ),
          DMCommonClickButton(
            borderRadius: style.buttonBorder,
            enable: ref.watch(mobileBindStateNotifierProvider
                .select((value) => value.enableSend)),
            text: 'send_sms_code'.tr(),
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColor,
            textColor: style.enableBtnTextColor,
            backgroundGradient: style.confirmBtnGradient,
            margin: const EdgeInsets.only(top: 51).withRTL(context),
            onClickCallback: () {
              // GoRouter.of(context).push(AppRoutes.MOBILE_BIND_CHECK_CODE_PAGE);
              notifier.sendMessage(context);
            },
          )
        ],
      ),
    );
  }
}
