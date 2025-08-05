// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const Color defaultBackgroundColor = Colors.white;

class DMButton extends StatefulWidget {
  String text; // 文字
  Gradient? backgroundGradient; //按钮背景渐变色
  Gradient? pressedGradient; //按钮点击渐变色
  Color? backgroundColor; //按钮背景颜色
  Color? pressedColor; //按钮点击颜色
  Color? borderColor; //按钮边框颜色
  Color textColor; //按钮文字颜色
  double fontsize; //按钮文字大小
  FontWeight fontWidget; //按钮文字粗细
  double borderRadius; //按钮边框角度
  double borderWidth; //按钮边框宽度
  bool horizontal; //按钮文字和前后控件排布方向，true为横向，false为竖向
  Widget prefixWidget; //按钮前（上）控件
  Widget surffixWidget; //按钮后（下）控件
  EdgeInsetsGeometry padding; //按钮内部padding
  EdgeInsetsGeometry margin; //按钮外部margin
  double? width; //按钮宽度 默认不传是自适应宽度 double.infinity为横向撑满
  double? height; //按钮高度 默认不传是自适应高度
  final void Function(BuildContext context) onClickCallback;
  MainAxisAlignment mainAxisAlignment; //按钮中控件方向
  CrossAxisAlignment crossAxisAlignment; //按钮中控件方向
  Alignment childAligment;

  /// 支持 autoSizeText
  bool autoSizeTextEnable = true;
  int maxLines = 2;
  double minFontSize = 10;
  double stepGranularity = 1;
  List<double>? presetFontSizes = null;

  DMButton(
      {super.key,
      this.text = '',
      this.textColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.backgroundGradient,
      this.pressedGradient,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.borderRadius = 0,
      this.pressedColor,
      this.fontsize = 16,
      this.fontWidget = FontWeight.w600,
      this.width,
      this.height,
      this.prefixWidget = const SizedBox.shrink(),
      this.surffixWidget = const SizedBox.shrink(),
      this.horizontal = true,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
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
  State<DMButton> createState() => _DMButtonState();
}

class _DMButtonState extends State<DMButton> {
  late Color backgroundColor;
  late Gradient backgroundGradient;
  bool clickable = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
      backgroundGradient = widget.backgroundGradient ??
          const LinearGradient(colors: [defaultBackgroundColor]);
    });
  }

  @override
  void didUpdateWidget(covariant DMButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
      backgroundGradient = widget.backgroundGradient ??
          const LinearGradient(colors: [defaultBackgroundColor]);
    });
  }

  List<Widget> childWidgets() {
    return [
      widget.prefixWidget,
      widget.text.isNotEmpty
          ? Flexible(
              child: widget.autoSizeTextEnable
                  ? AutoSizeText(widget.text,
                      maxLines: widget.maxLines,
                      minFontSize: widget.minFontSize,
                      maxFontSize: widget.fontsize,
                      stepGranularity: widget.stepGranularity,
                      presetFontSizes: widget.presetFontSizes,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1,
                          color: widget.textColor,
                          fontSize: widget.fontsize,
                          fontWeight: widget.fontWidget,
                          decoration: TextDecoration.none))
                  : Text(widget.text,
                      maxLines: widget.maxLines,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1,
                          color: widget.textColor,
                          fontSize: widget.fontsize,
                          fontWeight: widget.fontWidget,
                          decoration: TextDecoration.none)))
          : const SizedBox.shrink(),
      widget.surffixWidget
    ];
  }

  Widget buildButton() {
    return Container(
        decoration: BoxDecoration(
            color: widget.backgroundGradient == null
                ? (backgroundColor ?? defaultBackgroundColor)
                : null,
            gradient: widget.backgroundGradient,
            border: Border.all(
                color: widget.borderColor ?? Colors.transparent,
                width: widget.borderWidth),
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius))),
        alignment: widget.childAligment,
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: widget.padding,
        child: widget.horizontal
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: childWidgets(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: widget.crossAxisAlignment,
                children: childWidgets()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (clickable) {
            clickable = false;
            widget.onClickCallback(context);
            Future.delayed(const Duration(milliseconds: 800), () {
              clickable = true;
            });
          }
        },
        onTapDown: (details) {
          if (widget.pressedColor != null) {
            setState(() {
              backgroundColor = widget.pressedColor!;
              backgroundGradient = widget.backgroundGradient ??
                  const LinearGradient(colors: [defaultBackgroundColor]);
            });
          }
        },
        onTapCancel: () {
          setState(() {
            backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
            backgroundGradient = widget.backgroundGradient ??
                const LinearGradient(colors: [defaultBackgroundColor]);
          });
        },
        onTapUp: (details) {
          setState(() {
            backgroundColor = widget.backgroundColor ?? defaultBackgroundColor;
          });
        },
        child: widget.width == double.infinity
            ? buildButton()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [buildButton()],
              ));
  }
}
