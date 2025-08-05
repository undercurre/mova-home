import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/ui/widget/dm_format_rich_text.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UxPlanDialog extends ConsumerStatefulWidget {
  final VoidCallback clickClose;
  final VoidCallback clickPrivacy;
  final VoidCallback clickConfirm;

  const UxPlanDialog(
      {super.key,
      required this.clickClose,
      required this.clickPrivacy,
      required this.clickConfirm});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UxPlanDialogState();
}

class UxPlanDialogState extends ConsumerState<UxPlanDialog> {
  @override
  Widget build(BuildContext context) {
    bool rtl = (Directionality.of(context) == view_direction.TextDirection.rtl);
    return Semantics(
      explicitChildNodes:  true,
      child: ThemeWidget(
        builder: (context, style, resource) {
          return Container(
            height: 380,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: style.bgWhite,
              borderRadius: BorderRadius.circular(style.circular20), // 圆角半径
            ),
            child: Column(
              children: [
                Align(
                  alignment: rtl ? Alignment.centerLeft : Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10)
                        .withRTL(context),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Semantics(
                        label: 'close_popup'.tr(),
                        child: Image.asset(
                          resource.getResource('ic_ux_plan_close'),
                          width: 13,
                          height: 13,
                        ),
                      ),
                    ),
                  ).onClick(widget.clickClose),
                ),
                Text('MOVAhome App',
                    style: TextStyle(
                        fontSize: 18,
                        color: style.textMain,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 24, left: 24, right: 24),
                  child: Text('text_user_experience_plan'.tr(),
                      style: TextStyle(
                          fontSize: 18,
                          color: style.textMain,
                          fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          DMFormatRichText(
                              normalTextStyle: TextStyle(
                                  fontSize: 14,
                                  color: style.textMain,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400),
                              content: 'text_user_experience_plan_desc'.tr(),
                              richCallback: (index, key, content) {
                                widget.clickPrivacy.call();
                              }),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'text_ux_plan_position'.tr(),
                              style: TextStyle(
                                  fontSize: 12, color: style.textSecond),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
                DMButton(
                    width: double.infinity,
                    text: 'dialog_determine'.tr(),
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 20, bottom: 27),
                    borderRadius: style.buttonBorder,
                    height: 42,
                    backgroundGradient: style.confirmBtnGradient,
                    textColor: style.enableBtnTextColor,
                    fontsize: 16,
                    onClickCallback: (_) {
                      widget.clickConfirm.call();
                    })
              ],
            ),
          );
        },
      ),
    );
  }
}
