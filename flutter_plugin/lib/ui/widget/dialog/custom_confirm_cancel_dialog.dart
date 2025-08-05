import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';

/// 内容，取消按钮，登录按钮
/// 使用SmartDialog.show()展示
typedef ConfirmPreDismissCallback = void Function(VoidCallback dismiss);

class CustomConfirmCancelDialog extends StatelessWidget {
  final Widget? topWidget;
  final bool showLogo;
  final String? smartDialogTag;
  final String? content;
  final String? title;
  final String cancelContent;
  final String confirmContent;
  final TextAlign contentAlign;
  final VoidCallback? cancelCallback;
  final VoidCallback confirmCallback;
  final ConfirmPreDismissCallback? confirmPreDismissCallback;

  const CustomConfirmCancelDialog({
    super.key,
    this.content,
    this.title,
    required this.cancelContent,
    required this.confirmContent,
    required this.confirmCallback,
    this.confirmPreDismissCallback,
    this.cancelCallback,
    this.topWidget,
    this.showLogo = false,
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
            if (title != null)
              Container(
                constraints: const BoxConstraints(minHeight: 44),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: style.textNormal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            topWidget ??
                (showLogo
                    ? Container(
                        margin:
                            const EdgeInsets.only(bottom: 40).withRTL(context),
                        child: Image.asset(
                          resource.getResource('ic_app_logo'),
                          width: 72,
                          height: 72,
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      )),
            if (content != null)
              Container(
                constraints: const BoxConstraints(minHeight: 44),
                child: Text(
                  content!,
                  textAlign: contentAlign,
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
                    child: DMButton(
                        height: 48,
                        borderRadius: style.buttonBorder,
                        width: double.infinity,
                        textColor: style.cancelBtnTextColor,
                        backgroundGradient: style.cancelBtnGradient,
                        text: cancelContent,
                        onClickCallback: (_) {
                          dismiss();
                          cancelCallback?.call();
                        }),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: DMButton(
                        height: 48,
                        borderRadius: style.buttonBorder,
                        textColor: style.btnText,
                        backgroundGradient: style.confirmBtnGradient,
                        text: confirmContent,
                        width: double.infinity,
                        onClickCallback: (_) {
                          if (confirmPreDismissCallback != null) {
                            confirmPreDismissCallback?.call(() {
                              dismiss();
                              confirmCallback.call();
                            });
                          } else {
                            dismiss();
                            confirmCallback.call();
                          }
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
