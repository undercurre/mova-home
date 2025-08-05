import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/response_for_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/mine_email_bind_state_notifier.dart';
import 'package:flutter_plugin/ui/page/account/recaptcha_controller.dart';
import 'package:flutter_plugin/ui/page/base_page.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/ui/widget/mine/countdown_input_text.dart';
import 'package:flutter_plugin/ui/widget/mine/normal_input_text.dart';
import 'package:flutter_plugin/utils/alignment_extension.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class MineEmailBindPage extends BasePage {
  static const String routePath = '/mine_email_bind_page';

  const MineEmailBindPage({super.key, required this.centerTitle});

  // const WebPage({super.key, this.request});
  final String centerTitle;

  @override
  MineEmailBindPageState<MineEmailBindPage> createState() {
    return MineEmailBindPageState<MineEmailBindPage>(middleTitle: centerTitle);
  }
}

class MineEmailBindPageState<MineEmailBindPage> extends BasePageState
    with CommonDialog, ResponseForeUiEvent {
  MineEmailBindPageState({required this.middleTitle});
  final String middleTitle;
  @override
  String get centerTitle {
    return middleTitle;
  }

  // 发送验证码
  Future<bool> sendVerifyCode(RecaptchaModel recaptchaModel) {
    return ref
        .read(mineEmailBindStateNotifierProvider.notifier)
        .sendVerifyCode(recaptchaModel);
  }

  /// 点击获取验证码按钮
  Future<bool> getDynamicPress() async {
    late Future<bool>? result;
    await RecaptchaController(context, (recaptchaModel) {
      result = sendVerifyCode(recaptchaModel);
    }).check();
    return result ?? Future.value(false);
  }

  @override
  void addObserver() {
    super.addObserver();
    ref.listen(
        mineEmailBindStateNotifierProvider.select((value) => value.event),
        (pre, next) {
      LogUtils.d('----------screenUiShowProvider listen ------ $pre $next');
      responseFor(next);
    });
  }

  @override
  Color? get backgroundColor {
    StyleModel style = ref.read(styleModelProvider);
    return style.bgGray;
  }

  @override
  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 20).withRTL(context),
      child: Column(
        children: [
          NormalInputText(
            placeholder: 'please_input_email'.tr(),
            onChanged: (value) {
              ref
                  .read(mineEmailBindStateNotifierProvider.notifier)
                  .emailChange(value);
            },
            keyboardType: TextInputType.emailAddress,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20).withRTL(context),
            child: CountDownInputText(
              placeholder: 'input_verify_code'.tr(),
              clickCountForResponseCallBack: getDynamicPress,
              onChanged: (value) {
                ref
                    .read(mineEmailBindStateNotifierProvider.notifier)
                    .codeChange(value);
              },
              canSend: ref.watch(mineEmailBindStateNotifierProvider
                  .select((value) => value.canSendMessage)),
              keyboardType: TextInputType.number,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft.withRTL(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 29).withRTL(context),
              child: GestureDetector(
                onTap: ref
                    .read(mineEmailBindStateNotifierProvider.notifier)
                    .agreementChange,
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Container(
                          margin:
                              const EdgeInsets.only(right: 8).withRTL(context),
                          child: Image.asset(
                            resource.getResource(ref.watch(
                                    mineEmailBindStateNotifierProvider
                                        .select((value) => value.agreed))
                                ? 'ic_agreement_selected'
                                : 'ic_agreement_unselect'),
                            width: 14,
                            height: 14,
                          ).withDynamic().flipWithRTL(context),
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
          ),
          DMCommonClickButton(
            borderRadius: style.buttonBorder,
            enable: ref.watch(mineEmailBindStateNotifierProvider
                .select((value) => value.enableSend)),
            text: 'bind'.tr(),
            disableBackgroundGradient: style.disableBtnGradient,
            disableTextColor: style.disableBtnTextColor,
            textColor: style.enableBtnTextColor,
            backgroundGradient: style.confirmBtnGradient,
            margin: const EdgeInsets.only(top: 34).withRTL(context),
            onClickCallback: () {
              ref
                  .read(mineEmailBindStateNotifierProvider.notifier)
                  .submitClick();
            },
          )
        ],
      ),
    );
  }
}
