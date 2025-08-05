import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';

class NormalInputText extends StatefulWidget {
  const NormalInputText(
      {super.key,
      this.tailChild,
      this.placeholder,
      this.onChanged,
      this.keyboardType});
  final Widget? tailChild;
  final String? placeholder;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  @override
  NormalInputTextState createState() {
    return NormalInputTextState();
  }
}

class NormalInputTextState extends State<NormalInputText> {
  final TextEditingController _textEditingController =
      TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    Widget? tailChild = widget.tailChild;
    return ThemeWidget(builder: (context, style, resource) {
      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(style.cellBorder),
          color: style.bgWhite,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                style: style.mainStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: style.disableStyle(fontSize: 16),
                  border: InputBorder.none,
                ),
                onChanged: widget.onChanged,
                keyboardType: widget.keyboardType,
              ),
            ),
            if (tailChild != null) tailChild
          ],
        ),
      );
    });
  }
}
