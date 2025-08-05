import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({super.key, this.tailChild});
  final Widget? tailChild;
  @override
  State<StatefulWidget> createState() => InputTextFieldState();
}

class InputTextFieldState extends State<InputTextField> {
  List<Widget> buildContext() {
    List<Widget> widgets = [];
    CupertinoTextField mainTextField = CupertinoTextField(
      placeholder: 'login_user_hint'.tr(),
      placeholderStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Color(0xffA6A6A6),
      ),
      decoration: BoxDecoration(),
    );
    widgets.add(Expanded(child: mainTextField));
    if (widget.tailChild != null) {
      widgets.add(widget.tailChild!);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top: 22),
      height: 60,
      // color: Colors.red,
      child: Row(
        children: buildContext(),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xffE2E2E2),
          ),
        ),
      ),
    );
  }
}
