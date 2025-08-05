import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_common_click_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 内容，取消按钮，登录按钮
/// 使用SmartDialog.show()展示
class ContentConfirmDialog extends StatelessWidget {
  final String? title;
  final String? smartDialogTag;
  final String content;
  final String confirmContent;
  final TextAlign contentAlign;
  final VoidCallback confirmCallback;

  const ContentConfirmDialog({
    super.key,
    required this.content,
    required this.confirmContent,
    required this.confirmCallback,
    this.title,
    this.contentAlign = TextAlign.center,
    this.smartDialogTag,
  });

  void dismiss() {
    SmartDialog.dismiss(tag: smartDialogTag);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(style.circular20),
            color: style.bgWhite),
        margin: const EdgeInsets.symmetric(horizontal: 35),
        padding: const EdgeInsets.only(top: 28, left: 24, right: 24, bottom: 20)
            .withRTL(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (title == null || title!.isEmpty) == true
                ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 12).withRTL(context),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 18,
                        color: style.textMain,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            Container(
              constraints: const BoxConstraints(minHeight: 44),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: style.textNormal,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24).withRTL(context),
              child: Row(
                children: [
                  Expanded(
                    child: DMCommonClickButton(
                        height: 48,
                        borderRadius: style.buttonBorder,
                        textColor: style.enableBtnTextColor,
                        backgroundGradient: style.confirmBtnGradient,
                        text: confirmContent,
                        width: double.infinity,
                        onClickCallback: () {
                          dismiss();
                          confirmCallback.call();
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
