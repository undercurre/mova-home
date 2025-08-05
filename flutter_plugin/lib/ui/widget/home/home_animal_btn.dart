import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/home/home_action_btn.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

class AnimationHomeActionButton extends StatefulWidget {
  final Function(ButtonState)? clickCallback;
  final double width;
  final double height;
  final ButtonState state;
  final ActionBtnResModel actionBtnRes;
  final Offset? sourcePosition;
  final Offset? destionPosition;

  const AnimationHomeActionButton({
    super.key,
    required this.actionBtnRes,
    this.clickCallback,
    this.width = 64,
    this.height = 64,
    this.state = ButtonState.none,
    this.sourcePosition = const Offset(0, 0),
    this.destionPosition = const Offset(0, 0),
  });

  @override
  AnimationHomeActionButtonState createState() =>
      AnimationHomeActionButtonState();
}

class AnimationHomeActionButtonState extends State<AnimationHomeActionButton> {
  bool _isAnimated = false;
  double _scale = 1.0;
  Offset _position = const Offset(0, 0);

  String _parseState() {
    var btnRes = widget.actionBtnRes;
    if (widget.state == ButtonState.active) {
      return btnRes.activeImage;
    } else if (widget.state == ButtonState.disable) {
      return btnRes.disableImage;
    }
    return btnRes.normalImage;
  }

  void startAnimate() {
    Offset newPosition = Offset(
        widget.destionPosition!.dx - widget.sourcePosition!.dx,
        widget.destionPosition!.dy - widget.sourcePosition!.dy);
    setState(() {
      _isAnimated = !_isAnimated;
      _scale = _isAnimated ? 1.5 : 1.0; // 缩放比例
      _position = _isAnimated ? newPosition : const Offset(0, 0); // 平移位置
    });
  }

  @override
  void didUpdateWidget(AnimationHomeActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 检查参数是否发生变化，并更新属性
    if (widget.sourcePosition != oldWidget.sourcePosition ||
        widget.destionPosition != oldWidget.destionPosition) {
      startAnimate();
    }
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
