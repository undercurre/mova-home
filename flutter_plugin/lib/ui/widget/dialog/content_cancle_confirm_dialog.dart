import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 内容，取消按钮，登录按钮
/// 使用SmartDialog.show()展示
class ContentCancelConfirmDialog extends StatelessWidget {
  final String? title;
  final String? smartDialogTag;
  final String content;
  final String cancelContent;
  final String confirmContent;
  final TextAlign contentAlign;
  final VoidCallback? cancelCallback;
  final VoidCallback confirmCallback;

  const ContentCancelConfirmDialog({
    super.key,
    required this.content,
    required this.cancelContent,
    required this.confirmContent,
    required this.confirmCallback,
    this.cancelCallback,
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
                    margin: const EdgeInsets.only(bottom: 16).withRTL(context),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: style.carbonBlack,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
            Container(
              constraints: const BoxConstraints(minHeight: 44),
              child: Text(
                content,
                textAlign: contentAlign,
                style: TextStyle(
                  fontSize: 16,
                  color: style.carbonBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20).withRTL(context),
              child: Row(
                children: [
                  Expanded(
                    child: FocusableActionDetector(
                      autofocus: true,
                      child: Semantics(
                        explicitChildNodes: true,
                        child: DMButton(
                            height: 48,
                            borderRadius: style.buttonBorder,
                            width: double.infinity,
                            textColor: style.cancelBtnTextColor,
                            backgroundGradient: style.grayGradient,
                            text: cancelContent,
                            onClickCallback: (_) {
                              dismiss();
                              cancelCallback?.call();
                            }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: DMButton(
                        height: 48,
                        borderColor: Colors.transparent,
                        borderRadius: style.buttonBorder,
                        textColor: style.confirmBtnTextColor,
                        backgroundGradient: style.brandColorGradient,
                        text: confirmContent,
                        width: double.infinity,
                        onClickCallback: (_) {
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
