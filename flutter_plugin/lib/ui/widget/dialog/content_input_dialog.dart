import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 使用SmartDialog.show()展示
// ignore: must_be_immutable
class ContentInputDialog extends StatelessWidget {
  final String title;
  final String? content;
  final String hint;
  final String cancelText;
  final String confirmText;
  final int maxLength;
  final VoidCallback? cancelCallback;
  final VoidCallback? maxLengthCallback;
  final Function(String) confirmCallback;
  late TextEditingController _controller;

  ContentInputDialog(this.title, this.hint, this.confirmCallback,
      {super.key,
      this.content,
      required this.cancelText,
      required this.confirmText,
      this.cancelCallback,
      this.maxLengthCallback,
      this.maxLength = TextField.noMaxLength}) {
    _controller = TextEditingController(text: content);
  }

  void dismiss() {
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      explicitChildNodes: true,
      child: ThemeWidget(
        builder: (context, style, resource) {
          return AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutQuart,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(style.circular20),
                  color: style.bgWhite),
              margin: const EdgeInsets.symmetric(horizontal: 35),
              padding:
                  const EdgeInsets.only(top: 28, left: 24, right: 24, bottom: 20)
                      .withRTL(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: style.mainStyle(),
                  ),
                  FocusableActionDetector(
                    autofocus: true,
                    child: Semantics(
                      explicitChildNodes: true,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 16).withRTL(context),
                          child: TextField(
                            controller: _controller,
                            cursorColor: style.textMainBlack,
                            maxLength: maxLength,
                            magnifierConfiguration:
                                TextMagnifierConfiguration.disabled,
                            maxLengthEnforcement:
                                MaxLengthEnforcement.truncateAfterCompositionEnds,
                            onChanged: (value) {
                              if (value.length >= maxLength) {
                                maxLengthCallback?.call();
                              }
                            },
                            style:style.thirdStyle(),
                            decoration: InputDecoration(
                                fillColor: style.lightBlack2,
                                filled: true,
                                counterText: '',
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(style.circular8),
                                    borderSide: BorderSide.none),
                                hintText: hint,
                                hintStyle:
                                    TextStyle(fontSize: 14, color: style.textSecond)),
                          )),
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
                              text: cancelText,
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
                              text: confirmText,
                              width: double.infinity,
                              onClickCallback: (_) {
                                dismiss();
                                if (_controller.text.length > maxLength) {
                                  return;
                                }
                                confirmCallback.call(_controller.text);
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
