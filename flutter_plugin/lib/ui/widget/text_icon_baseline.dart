import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// icon text
class TextIconBaselineWidget extends StatefulWidget {
  final String text;
  final Widget? icon;
  final TextStyle style;
  final EdgeInsetsGeometry padding;
  TextIconBaselineWidget({
    super.key,
    required this.text,
    required this.style,
    required this.padding,
    this.icon,
  }) {}

  @override
  State<StatefulWidget> createState() {
    return TextIconBaselineWidgetState();
  }
}

class TextIconBaselineWidgetState extends State<TextIconBaselineWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: widget
                .padding, // This line will cause a runtime error if widget.padding is nul,
            child: Text(
              widget.text,
              style: widget.style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: widget.icon ?? const SizedBox.shrink(),
        ),
      ],
    );
  }
}
