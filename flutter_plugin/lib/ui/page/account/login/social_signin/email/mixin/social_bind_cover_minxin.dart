import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

enum SocialBindAlertType { changeEmail, login, skip }

typedef SocialBindAlertCallback = void Function(SocialBindAlertType type);

mixin SocialBindeCoverMinxin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late SmartDialogController dialogController = SmartDialogController();

  Future<void> dismiss() async {
    return await SmartDialog.dismiss(tag: 'tag_social_bind_cover_dialog');
  }

  void showSocialAlert(SocialBindAlertCallback callBack) {
    if (!context.mounted) {
      return;
    }
    SmartDialog.show(
      tag: 'tag_social_bind_cover_dialog',
      controller: dialogController,
      alignment: Alignment.center,
      backDismiss: false,
      clickMaskDismiss: false,
      builder: (context) {
        return ThemeWidget(
          builder: (context, style, resource) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    padding: EdgeInsets.only(
                        left: 24, right: 24, top: 28, bottom: 12),
                    decoration: BoxDecoration(
                      color: style.bgBlack, // 背景色
                      borderRadius:
                          BorderRadius.circular(style.circular20), // 圆角半径
                    ),
                    child: Column(
                      children: [
                        Text(
                          'kind_tip'.tr(),
                          style: style.mainStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 26),
                          child: Text(
                            'social_bind_tip_email'.tr(),
                            textAlign: TextAlign.start,
                            style: style.textNormalStyle(fontSize: 16),
                          ),
                        ),
                        DMCommonClickButton(
                          borderRadius: style.buttonBorder,
                          disableBackgroundGradient: style.disableBtnGradient,
                          disableTextColor: style.disableBtnTextColor,
                          textColor: style.enableBtnTextColor,
                          backgroundGradient: style.confirmBtnGradient,
                          text: 'direct_login'.tr(),
                          onClickCallback: () {
                            dismiss();
                            callBack.call(SocialBindAlertType.login);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DMCommonClickButton(
                          width: double.infinity,
                          height: 48,
                          borderRadius: style.buttonBorder,
                          backgroundGradient: style.cancelBtnGradient,
                          textColor: style.lightDartBlack,
                          borderWidth: 0,
                          text: 'email_change'.tr(),
                          onClickCallback: () {
                            dismiss();
                            callBack.call(SocialBindAlertType.changeEmail);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 27),
                          child: GestureDetector(
                            onTap: () {
                              dismiss();
                              callBack.call(SocialBindAlertType.skip);
                            },
                            child: Text(
                              'skip_this_bind'.tr(),
                              style: TextStyle(
                                color: style.largeGold,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: style.largeGold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
