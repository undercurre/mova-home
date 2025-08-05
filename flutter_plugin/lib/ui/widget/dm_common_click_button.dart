// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';

/// 默认按钮样式，通过enable控制按钮状态
class DMCommonClickButton extends StatefulWidget {
  bool enable;
  bool clickable;
  String text; // 文字
  Color? backgroundColor; // enable 按钮背景颜色
  Color? pressedColor; //enable 按钮点击颜色
  Color? borderColor; //enable 按钮边框颜色
  Color? textColor; //enable 按钮文字颜色

  Color? disableBackgroundColor; //disable 按钮背景颜色
  Color? disablePressedColor; //disable 按钮点击颜色
  Color? disableBorderColor; //disable 按钮边框颜色
  Color? disableTextColor; //disable 按钮文字颜色

  Gradient? backgroundGradient; // enable Gradient
  Gradient? disableBackgroundGradient; // enable Gradient

  double fontsize; //按钮文字大小
  FontWeight? fontWidget; //按钮文字粗细
  double borderRadius; //按钮边框角度
  double borderWidth; //按钮边框宽度
  bool horizontal; //按钮文字和前后控件排布方向，true为横向，false为竖向
  Widget prefixWidget; //按钮前（上）控件
  Widget surffixWidget; //按钮后（下）控件
  EdgeInsetsGeometry padding; //按钮内部padding
  EdgeInsetsGeometry margin; //按钮外部margin
  double? width; //按钮宽度 默认不传是自适应宽度 double.infinity为横向撑满
  double? height; //按钮高度 默认不传是自适应高度
  VoidCallback onClickCallback;
  MainAxisAlignment mainAxisAlignment; //按钮中控件方向
  CrossAxisAlignment crossAxisAlignment; //按钮中控件方向
  Alignment childAligment;

  /// 支持 autoSizeText
  bool autoSizeTextEnable = true;
  int maxLines = 2;
  double minFontSize = 10;
  double stepGranularity = 1;
  List<double>? presetFontSizes = null;

  DMCommonClickButton(
      {super.key,
      this.enable = true,
      this.clickable = true,
      this.text = '',
      this.textColor,
      this.backgroundColor,
      this.borderColor,
      this.pressedColor,
      this.disableTextColor,
      this.disablePressedColor,
      this.disableBackgroundColor,
      this.disableBorderColor,
      this.backgroundGradient,
      this.disableBackgroundGradient,
      this.borderWidth = 0,
      this.borderRadius = 0,
      this.fontsize = 16,
      this.fontWidget,
      this.width = double.infinity,
      this.height = 48,
      this.prefixWidget = const SizedBox.shrink(),
      this.surffixWidget = const SizedBox.shrink(),
      this.horizontal = true,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.childAligment = Alignment.center,
      this.autoSizeTextEnable = true,
      this.maxLines = 2,
      this.minFontSize = 10,
      this.stepGranularity = 1,
      this.presetFontSizes = null,
      required this.onClickCallback});

  DMCommonClickButton.gradient(
      {super.key,
      this.enable = true,
      this.clickable = true,
      this.text = '',
      this.textColor,
      this.disableTextColor,
      this.disablePressedColor,
      this.disableBackgroundColor,
      this.disableBorderColor,
      this.backgroundGradient,
      this.disableBackgroundGradient,
      this.borderWidth = 0,
      this.borderRadius = 0,
      this.fontsize = 16,
      this.fontWidget,
      this.width = double.infinity,
      this.height = 48,
      this.prefixWidget = const SizedBox.shrink(),
      this.surffixWidget = const SizedBox.shrink(),
      this.horizontal = true,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.childAligment = Alignment.center,
      this.autoSizeTextEnable = true,
      this.maxLines = 2,
      this.minFontSize = 10,
      this.stepGranularity = 1,
      this.presetFontSizes = null,
      required this.onClickCallback});

  @override
  State<StatefulWidget> createState() {
    return _DMCommonClickButtonStatte();
  }
}

class _DMCommonClickButtonStatte extends State<DMCommonClickButton> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant DMCommonClickButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return DMButton(
          text: widget.text,
          textColor: widget.enable
              ? widget.textColor ?? style.enableBtnTextColor
              : widget.disableTextColor ?? style.disableBtnTextColor,
          backgroundColor: widget.enable
              ? widget.backgroundColor
              : widget.disableBackgroundColor,
          borderColor:
              widget.enable ? widget.borderColor : widget.disableBorderColor,
          borderWidth: widget.borderWidth,
          borderRadius: widget.borderRadius,
          backgroundGradient: widget.enable
              ? widget.backgroundGradient
              : widget.disableBackgroundGradient,
          pressedColor: widget.enable
              ? widget.pressedColor ?? style.normal
              : widget.disablePressedColor ?? style.lightBlack1,
          fontsize: widget.fontsize,
          fontWidget: widget.fontWidget ??
              (Platform.isAndroid ? FontWeight.w500 : FontWeight.w700),
          width: widget.width,
          height: widget.height,
          prefixWidget: widget.prefixWidget,
          surffixWidget: widget.surffixWidget,
          horizontal: widget.horizontal,
          padding: widget.padding,
          margin: widget.margin,
          maxLines: widget.maxLines,
          minFontSize: widget.minFontSize,
          stepGranularity: widget.stepGranularity,
          presetFontSizes: widget.presetFontSizes,
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: widget.crossAxisAlignment,
          childAligment: widget.childAligment,
          onClickCallback: (_) {
            if (widget.clickable && widget.enable) {
              widget.onClickCallback.call();
            }
          });
    });
  }
}
