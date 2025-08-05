import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dialog/content_cancle_confirm_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/content_confirm_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/content_input_dialog.dart';
import 'package:flutter_plugin/ui/widget/dialog/custom_confirm_cancel_dialog.dart';

mixin CommonDialog {
  /// toast
  ///
  /// [msg] 内容
  void showToast(String msg) {
    if (msg.isEmpty) return;
    SmartDialog.showToast(msg);
  }

  /// 显示loading
  ///
  /// [content] 内容
  /// [backDismiss] 是否点击返回键消失
  /// [showClose] 是否显示关闭按钮
  /// [delayTime] 延迟消失时间
  void showLoading(
      {String content = '',
      bool backDismiss = false,
      bool showClose = false,
      Duration delayTime = Duration.zero}) {
    SmartDialog.show(
      tag: 'loading_dialog',
      clickMaskDismiss: backDismiss,
      backDismiss: backDismiss,
      builder: (context) {
        return ThemeWidget(
          builder: (context, style, resource) {
            return DMLoadingDialog(
              colors: const [
                Color(0x00DDBCA1),
                Color(0x60DDBCA1),
                Color(0x80DDBCA1),
                Color(0xFFDDBCA1),
                Color(0xFFDDBCA1),
              ],
              content: content,
              showClose: showClose,
              delayTime: delayTime,
              contentStyle: DMDFontStyle(
                  fontColor: style.textSecond, fontSize: style.middleText),
              backgroundStyle: DMDBackgroundStyle.color(
                  color: style.bgWhite, borderRadius: style.circular12),
            );
          },
        );
      },
    );
  }

  /// 隐藏loading
  void dismissLoading() {
    SmartDialog.dismiss(tag: 'loading_dialog');
  }

  void showCommonDialog(
      {required String content,
      required String cancelContent,
      required String confirmContent,
      required VoidCallback confirmCallback,
      VoidCallback? cancelCallback,
      String? title,
      String? tag,
      bool backDismiss = false,
      TextAlign contentAlign = TextAlign.center}) {
    final finaltag = tag ?? content;
    SmartDialog.show(
        tag: finaltag,
        backDismiss: backDismiss,
        animationType: SmartAnimationType.fade,
        maskColor: Colors.black.withOpacity(0.5),
        clickMaskDismiss: false,
        builder: (_) {
          return Semantics(
            explicitChildNodes: true,
            child: ContentCancelConfirmDialog(
              smartDialogTag: finaltag,
              title: title,
              content: content,
              contentAlign: contentAlign,
              cancelContent: cancelContent,
              confirmContent: confirmContent,
              confirmCallback: confirmCallback,
              cancelCallback: cancelCallback,
            ),
          );
        });
  }

  void showConfirmDialog(
      {required String content,
      required String confirmContent,
      required VoidCallback confirmCallback,
      String? title,
      String? tag,
      bool backDismiss = false,
      TextAlign contentAlign = TextAlign.center}) {
    final finaltag = tag ?? content;
    SmartDialog.show(
        tag: finaltag,
        backDismiss: backDismiss,
        animationType: SmartAnimationType.fade,
        maskColor: Colors.black.withOpacity(0.5),
        clickMaskDismiss: false,
        builder: (_) {
          return Semantics(
            explicitChildNodes: true,
            child: ContentConfirmDialog(
              smartDialogTag: finaltag,
              title: title,
              content: content,
              contentAlign: contentAlign,
              confirmContent: confirmContent,
              confirmCallback: confirmCallback,
            ),
          );
        });
  }

  void showInputDialog(
      {required String title,
      required String hint,
      required String cancelText,
      required String confirmText,
      required Function(String) confirmCallback,
      VoidCallback? cancelCallback,
      VoidCallback? maxLengthCallback,
      int maxLength = TextField.noMaxLength,
      String? content}) {
    SmartDialog.show(
        backDismiss: false,
        animationType: SmartAnimationType.fade,
        maskColor: Colors.black.withOpacity(0.5),
        clickMaskDismiss: false,
        builder: (_) {
          return Semantics(
            explicitChildNodes: true,
            child: ContentInputDialog(
              title,
              hint,
              (text) => confirmCallback(text),
              content: content,
              confirmText: confirmText,
              cancelText: cancelText,
              cancelCallback: () => cancelCallback?.call(),
              maxLength: maxLength,
              maxLengthCallback: () => maxLengthCallback?.call(),
            ),
          );
        });
  }

  void showCustomCommonDialog(
      {Widget? topWidget,
      String? content,
      required String cancelContent,
      required String confirmContent,
      required VoidCallback confirmCallback,
      ConfirmPreDismissCallback? confirmPreDismissCallback,
      VoidCallback? cancelCallback,
      String? title,
      String? tag,
      bool backDismiss = false,
      bool showLogo = false,
      TextAlign contentAlign = TextAlign.center}) {
    final finaltag = tag ?? content;
    SmartDialog.show(
        tag: finaltag,
        backDismiss: backDismiss,
        animationType: SmartAnimationType.fade,
        maskColor: Colors.black.withOpacity(0.5),
        clickMaskDismiss: false,
        builder: (_) {
          return Semantics(
            explicitChildNodes: true,
            child: CustomConfirmCancelDialog(
              smartDialogTag: finaltag,
              topWidget: topWidget,
              showLogo: showLogo,
              title: title,
              content: content,
              contentAlign: contentAlign,
              cancelContent: cancelContent,
              confirmContent: confirmContent,
              confirmCallback: confirmCallback,
              confirmPreDismissCallback: confirmPreDismissCallback,
              cancelCallback: cancelCallback,
            ),
          );
        });
  }

  /// 提示弹窗
  ///
  /// [content] 内容, [title] 标题，可空,
  /// [tag] dialog tag标签,可空, [backDismiss] 是否点击返回键消失, [contentAlign] 内容对齐方式,
  /// [cancelContent] 取消按钮内容, [confirmContent] 确认按钮内容, [confirmCallback] 确认按钮回调
  void showAlertDialog(
      {required String content,
      required String cancelContent,
      required String confirmContent,
      required VoidCallback confirmCallback,
      VoidCallback? cancelCallback,
      String? title,
      String? tag,
      bool backDismiss = false,
      TextAlign contentAlign = TextAlign.center}) {
    final finaltag = tag ?? content;
    SmartDialog.show(
        tag: finaltag,
        backDismiss: backDismiss,
        animationType: SmartAnimationType.fade,
        maskColor: Colors.black.withOpacity(0.5),
        clickMaskDismiss: false,
        builder: (_) {
          return ThemeWidget(builder: (context, style, resource) {
            return Semantics(
              explicitChildNodes: true,
              child: DMCancelConfirmDialog(
                title: title,
                titleStyle: DMDFontStyle(
                    fontSize: 18,
                    fontColor: style.textMain,
                    fontWeight: FontWeight.w600),
                content: content,
                contentStyle: DMDFontStyle(
                    fontSize: 16,
                    textAlign: contentAlign,
                    fontColor: style.textNormal,
                    fontWeight: FontWeight.w400),
                backgroundStyle: DMDBackgroundStyle.color(
                    borderRadius: style.circular20, color: style.white),
                leftContent: cancelContent,
                leftButtonStyle: DMDButtonStyle(
                  backgroundStyle: DMDBackgroundStyle.color(
                      height: 48,
                      borderRadius: style.buttonBorder,
                      gradient: style.cancelBtnGradient),
                  fontStyle: DMDFontStyle(
                      fontSize: 16,
                      fontColor: style.cancelBtnTextColor,
                      fontWeight: FontWeight.w600),
                ),
                leftCallback: () {
                  SmartDialog.dismiss(tag: finaltag);
                  cancelCallback?.call();
                },
                rightContent: confirmContent,
                rightCallback: () {
                  SmartDialog.dismiss(tag: finaltag);
                  confirmCallback();
                },
                rightButtonStyle: DMDButtonStyle(
                  backgroundStyle: DMDBackgroundStyle.color(
                      height: 48,
                      borderRadius: style.buttonBorder,
                      gradient: style.confirmBtnGradient),
                  fontStyle: DMDFontStyle(
                      fontSize: 16,
                      fontColor: style.confirmBtnTextColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            );
          });
        });
  }

  void showMixableTextImageDialog(
      String? content, String? imageUrl, String confirmContent,
      {bool clickMaskDismiss = true}) {
    double calculateLineHeight({
      double lineHeight = 18.0,
      double maxHeight = 100.0,
      int charsPerLine = 30,
      required String textContent,
    }) {
      int numLines = (textContent.length / charsPerLine).ceil(); // 计算行数
      double computedHeight = numLines * lineHeight; // 计算文本实际高度
      double scrollableHeight =
          computedHeight > maxHeight ? maxHeight : computedHeight; // 计算可滚动区域高度
      return scrollableHeight;
    }

    double scrollableHeight =
        calculateLineHeight(textContent: content ?? ''); // 使用计算的可滚动高度

    SmartDialog.show(
      tag: 'mixable_text_image_dialog',
      clickMaskDismiss: clickMaskDismiss,
      builder: (_) {
        return ThemeWidget(
          builder: (context, style, resource) {
            return Semantics(
              explicitChildNodes: true,
              child: DMConfirmDialog(
                content: content ?? '',
                confirmContent: confirmContent,
                confirmCallback: () {
                  SmartDialog.dismiss();
                },
                contentWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 图片
                    Visibility(
                      visible: imageUrl?.isNotEmpty == true,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.only(top: 16, bottom: 12),
                          child: (imageUrl ?? '').isEmpty == true
                              ? Container()
                              : CachedNetworkImage(
                                  imageUrl: imageUrl ?? '',
                                ),
                        ),
                      ),
                    ),
                    // 内容
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      child: SizedBox(
                        height: scrollableHeight, // 使用计算的可滚动高度
                        child: SingleChildScrollView(
                          child: Text(
                            content ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: style.textMain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundStyle: DMDBackgroundStyle.color(
                  borderRadius: style.circular20,
                  color: style.white,
                ),
                titleStyle: DMDFontStyle(
                  fontSize: 18,
                  fontColor: style.textMain,
                  fontWeight: FontWeight.bold,
                ),
                contentStyle: DMDFontStyle(
                  fontSize: 16,
                  fontColor: style.textMain,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                ),
                buttonStyle: DMDButtonStyle(
                  backgroundStyle: DMDBackgroundStyle.gradient(
                    borderRadius: style.buttonBorder,
                    height: 48,
                    gradient: style.confirmBtnGradient,
                  ),
                  fontStyle: DMDFontStyle(
                      fontColor: style.confirmBtnTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
