import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/account/input_text_field.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key});
  @override
  PasswordTextFielState createState() {
    return PasswordTextFielState();
  }
}

class PasswordTextFielState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return InputTextField(
        tailChild: Text("data"),
      );
    });
  }
}
