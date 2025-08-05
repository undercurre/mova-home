// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter/material.dart' as view_direction;
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

const Color defaultBackgroundColor = Colors.white;

enum buttonType { primary, secondary, third }

class DMSpecialButton extends StatefulWidget {
  String text; // 文字
  buttonType type; // 按钮类型
  Widget? topIconWidget; // 顶部图标
  ButtonState state;
  ActionBtnResourceModel? actionBtnRes;
  Widget? rightIconWidget; // 右侧图标
  BoxShadow? boxShadow; //按钮阴影
  Color? backgroundColor; //按钮背景颜色
  Gradient? backgroundGradient; //按钮背景渐变色
  Gradient? pressedGradient; //按钮点击渐变色
  ImageProvider? backgroundImage; //按钮背景图片
  Color textColor; //按钮文字颜色
  Color disableTextColor; //按钮禁用文字颜色
  double fontsize; //按钮文字大小
  FontWeight fontWidget; //按钮文字粗细
  double borderRadius; //按钮边框角度
  double borderWidth; //按钮边框宽度
  Color borderColor; //按钮边框颜色

  EdgeInsetsGeometry padding; //按钮内部padding
  EdgeInsetsGeometry margin; //按钮外部margin
  double? width; //按钮宽度 默认不传是自适应宽度 double.infinity为横向撑满
  double? height; //按钮高度 默认不传是自适应高度
  final void Function(ButtonState state) onClickCallback;
  Alignment childAligment;

  /// 支持 autoSizeText
  bool autoSizeTextEnable = true;
  int maxLines = 1;
  double minFontSize = 8;
  double stepGranularity = 1;
  List<double>? presetFontSizes = null;

  DMSpecialButton.primary(
      {super.key,
      this.text = '',
      this.state = ButtonState.none,
      this.type = buttonType.primary,
      this.topIconWidget,
      this.rightIconWidget,
      this.boxShadow,
      this.textColor = Colors.black,
      this.disableTextColor = Colors.white,
      this.backgroundGradient,
      this.backgroundColor,
      this.backgroundImage,
      this.pressedGradient,
      this.borderWidth = 0,
      this.borderColor = Colors.transparent,
      this.borderRadius = 0,
      this.fontsize = 14,
      this.fontWidget = FontWeight.normal,
      this.width,
      this.height,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
      this.margin = EdgeInsets.zero,
      this.childAligment = Alignment.center,
      this.autoSizeTextEnable = false,
      this.maxLines = 1,
      this.minFontSize = 8,
      this.stepGranularity = 1,
      this.presetFontSizes = null,
      required this.onClickCallback});

  DMSpecialButton.mutablePrefx(
      {super.key,
      this.text = '',
      this.state = ButtonState.none,
      this.type = buttonType.secondary,
      this.rightIconWidget,
      this.topIconWidget,
      this.textColor = Colors.white,
      this.disableTextColor = Colors.white,
      this.backgroundImage,
      this.backgroundColor,
      this.backgroundGradient,
      this.pressedGradient,
      this.borderWidth = 0,
      this.borderRadius = 0,
      this.borderColor = Colors.transparent,
      this.fontsize = 16,
      this.fontWidget = FontWeight.normal,
      this.width,
      this.height,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
      this.margin = EdgeInsets.zero,
      this.childAligment = Alignment.center,
      this.autoSizeTextEnable = false,
      this.maxLines = 1,
      this.minFontSize = 8,
      this.stepGranularity = 1,
      this.presetFontSizes = null,
      required this.onClickCallback});

  DMSpecialButton.third(
      {super.key,
      this.text = '',
      this.type = buttonType.third,
      this.topIconWidget,
      this.rightIconWidget,
      this.textColor = const Color(0xFF353535),
      this.disableTextColor = const Color(0xFF959595),
      required this.state,
      this.backgroundGradient,
      this.backgroundColor,
      this.backgroundImage,
      this.actionBtnRes,
      this.pressedGradient,
      this.borderWidth = 0,
      this.borderColor = Colors.transparent,
      this.borderRadius = 0,
      this.fontsize = 16,
      this.fontWidget = FontWeight.normal,
      this.width,
      this.height,
      this.padding = const EdgeInsets.symmetric(horizontal: 4),
      this.margin = EdgeInsets.zero,
      this.childAligment = Alignment.center,
      this.autoSizeTextEnable = false,
      this.maxLines = 1,
      this.minFontSize = 8,
      this.stepGranularity = 1,
      this.presetFontSizes = null,
      required this.onClickCallback});

  @override
  State<DMSpecialButton> createState() => _DMSpecialButtonState();
}

class _DMSpecialButtonState extends State<DMSpecialButton> {
  late Gradient backgroundGradient;
  bool clickable = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      backgroundGradient = widget.backgroundGradient ??
          const LinearGradient(colors: [defaultBackgroundColor]);
    });
  }

  @override
  void didUpdateWidget(covariant DMSpecialButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      backgroundGradient = widget.backgroundGradient ??
          const LinearGradient(colors: [defaultBackgroundColor]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return GestureDetector(
          onTap: () {
            if (clickable) {
              clickable = false;
              widget.onClickCallback.call(widget.state);
              Future.delayed(const Duration(milliseconds: 800), () {
                clickable = true;
              });
            }
          },
          onTapDown: (details) {
            if (widget.backgroundGradient != null) {
              setState(() {
                backgroundGradient = widget.backgroundGradient ??
                    const LinearGradient(colors: [defaultBackgroundColor]);
              });
            }
          },
          onTapCancel: () {
            setState(() {
              backgroundGradient = widget.backgroundGradient ??
                  const LinearGradient(colors: [defaultBackgroundColor]);
            });
          },
          onTapUp: (details) {
            setState(() {
              backgroundGradient = widget.backgroundGradient ??
                  const LinearGradient(colors: [defaultBackgroundColor]);
            });
          },
          child: buildButton(context, style, resource));
    });
  }

  Widget primaryWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          PositionedDirectional(
            top: 12,
            start: 16,
            end: (40 + 16),
            child: Container(
              child: AutoSizeText(widget.text,
                  maxFontSize: 14,
                  minFontSize: 12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    color: widget.textColor,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          PositionedDirectional(
              bottom: 2,
              end: 2,
              child: Container(
                width: 42,
                height: 42,
                child: widget.rightIconWidget ?? const SizedBox.shrink(),
              ).flipWithRTL(context)),
        ],
      );
    });
  }

  Widget _rightIconWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    ActionBtnResourceModel btnRes = widget.actionBtnRes!;
    var imageName = btnRes.normalImage;
    if (widget.state == ButtonState.active) {
      imageName = btnRes.activeImage;
    } else if (widget.state == ButtonState.disable) {
      imageName = btnRes.disableImage;
    } else {
      imageName = btnRes.normalImage;
    }
    return Image.asset(
      resource.getResource(imageName),
      width: 40,
      height: 40,
    ).flipWithRTL(context);
  }

  String _buttonText(
      BuildContext context, StyleModel style, ResourceModel resource) {
    ActionBtnResourceModel btnRes = widget.actionBtnRes!;
    String buttontText = widget.text;
    if (widget.state == ButtonState.active) {
      buttontText = btnRes.activeText ?? widget.text;
    } else if (widget.state == ButtonState.disable) {
      buttontText = btnRes.disableText ?? widget.text;
    } else if (widget.state == ButtonState.none) {
      buttontText = btnRes.normalText ?? widget.text;
    }
    return buttontText;
  }

  Color _textColor(
      BuildContext context, StyleModel style, ResourceModel resource) {
    if (widget.state == ButtonState.disable) {
      return widget.disableTextColor;
    } else {
      return widget.textColor;
    }
  }

  Widget secondaryWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Container(child: widget.topIconWidget).flipWithRTL(context),
        const Expanded(
          flex: 1,
          child: SizedBox.shrink(),
        ),
      ]),
      const Spacer(),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.autoSizeTextEnable
                  ? AutoSizeText(
                      widget.text,
                      maxLines: widget.maxLines,
                      minFontSize: widget.minFontSize,
                      maxFontSize: widget.fontsize,
                      stepGranularity: widget.stepGranularity,
                      presetFontSizes: widget.presetFontSizes,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          height: 1,
                          color: widget.textColor,
                          fontSize: widget.fontsize,
                          fontWeight: widget.fontWidget,
                          decoration: TextDecoration.none),
                    )
                  : Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        widget.text,
                        maxLines: widget.maxLines,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            height: 1,
                            color: widget.textColor,
                            fontSize: widget.fontsize,
                            fontWeight: widget.fontWidget,
                            decoration: TextDecoration.none),
                      ))),
              Container(
                      child:
                          (widget.rightIconWidget ?? const SizedBox.shrink()))
                  .flipWithRTL(context),
              const Spacer(),
            ],
          ))
    ]);
  }

  Widget thirdWidget(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          PositionedDirectional(
            top: 12,
            start: 16,
            end: (40 + 16),
            child: Container(
              child: AutoSizeText(_buttonText(context, style, resource),
                  maxFontSize: 14,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.none,
                    color: _textColor(context, style, resource),
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          PositionedDirectional(
              bottom: 2,
              end: 2,
              child: Container(
                width: 42,
                height: 42,
                child: _rightIconWidget(context, style, resource),
              )),
        ],
      );
    });
  }

  Widget buildButton(
      BuildContext context, StyleModel style, ResourceModel resource) {
    Widget buttonWidget = const SizedBox.shrink();
    if (widget.type == buttonType.primary) {
      buttonWidget = primaryWidget(context, style, resource);
    } else if (widget.type == buttonType.secondary) {
      buttonWidget = secondaryWidget(context, style, resource);
    } else if (widget.type == buttonType.third) {
      buttonWidget = thirdWidget(context, style, resource);
    }

    return Container(
        decoration: BoxDecoration(
          color:
              widget.backgroundColor != null ? (widget.backgroundColor) : null,
          image: widget.backgroundImage != null
              ? DecorationImage(
                  image: widget.backgroundImage!,
                  fit: BoxFit.fill,
                )
              : null,
          gradient:
              widget.backgroundGradient != null ? backgroundGradient : null,
          border:
              Border.all(color: widget.borderColor, width: widget.borderWidth),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          boxShadow: widget.boxShadow != null ? [widget.boxShadow!] : null,
        ),
        alignment: widget.childAligment,
        width: widget.width,
        height: widget.height,
        child: Container(
          child: buttonWidget,
        ));
  }
}
