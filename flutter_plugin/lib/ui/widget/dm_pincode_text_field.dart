import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class DmPincodeTextField extends StatefulWidget {
  final int length;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? defaultTextColor;
  final Color? defaultBorderColor;
  final Color? focusedTextColor;
  final Color? focusedBorderColor;
  final Color? cursorColor;
  final bool enable;

  final ValueChanged<String>? onChanged;

  const DmPincodeTextField(
      {super.key,
      required this.length,
      this.width,
      this.height,
      this.fontSize,
      this.fontWeight,
      this.defaultTextColor,
      this.defaultBorderColor,
      this.focusedTextColor,
      this.focusedBorderColor,
      this.cursorColor,
      this.enable = true,
      this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return DmPincodeTextFieldState();
  }
}

class DmPincodeTextFieldState extends State<DmPincodeTextField> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Pinput(
        length: widget.length,
        pinAnimationType: PinAnimationType.none,
        isCursorAnimationEnabled: true,
        controller: pinController,
        focusNode: focusNode,
        autofocus: true,
        enabled: widget.enable,
        defaultPinTheme: PinTheme(
            width: widget.width,
            height: widget.height,
            textStyle: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: style.carbonBlack),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: style.lightBlack1,
                        width: 2,
                        style: BorderStyle.solid)))),
        focusedPinTheme: PinTheme(
            width: widget.width,
            height: widget.height,
            textStyle: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: style.carbonBlack),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: style.linkGold,
                        width: 2,
                        style: BorderStyle.solid)))),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
        showCursor: true,
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 2,
              height: 18,
              decoration: BoxDecoration(
                color: widget.cursorColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        onChanged: widget.onChanged,
      );
    });
  }
}
