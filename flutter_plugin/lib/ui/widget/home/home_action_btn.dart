import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';

class HomeActionButton extends StatefulWidget {
  final Function(ButtonState)? clickCallback;
  final double width;
  final double height;
  final ButtonState state;
  final ActionBtnResModel actionBtnRes;

  const HomeActionButton({
    super.key,
    required this.actionBtnRes,
    this.clickCallback,
    this.width = 64,
    this.height = 64,
    this.state = ButtonState.none,
  });

  @override
  HomeActionButtonState createState() => HomeActionButtonState();
}

class HomeActionButtonState extends State<HomeActionButton> {
  String _parseState() {
    var btnRes = widget.actionBtnRes;
    if (widget.state == ButtonState.active) {
      return btnRes.activeImage;
    } else if (widget.state == ButtonState.disable) {
      return btnRes.disableImage;
    }
    return btnRes.normalImage;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return Image.asset(
        resource.getResource(_parseState()),
        width: widget.width,
        height: widget.height,
      ).withDynamic().onClick(() {
        widget.clickCallback?.call(widget.state);
      });
    });
  }
}

enum ButtonState { none, active, disable }

class ActionBtnResModel {
  final String normalImage;
  final String activeImage;
  final String disableImage;

  final Color? normalImageBg;

  final Color? activeImageBg;
  final Color? disableImageBg;

  final int? normalImageRadius;

  final int? activeImageRadius;

  final int? disableImageRadius;

  ActionBtnResModel({
    required this.normalImage,
    required this.activeImage,
    required this.disableImage,
    this.normalImageBg,
    this.activeImageBg,
    this.disableImageBg,
    this.normalImageRadius,
    this.activeImageRadius,
    this.disableImageRadius,
  });
}

class ActionBtnResourceModel {
  final String normalImage;
  final String activeImage;
  final String disableImage;

  final String? normalText;
  final String? activeText;
  final String? disableText;

  ActionBtnResourceModel({
    required this.normalImage,
    required this.activeImage,
    required this.disableImage,
    this.normalText,
    this.activeText,
    this.disableText,
  });
}
