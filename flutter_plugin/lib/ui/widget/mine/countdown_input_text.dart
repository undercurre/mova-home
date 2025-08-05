import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/mine/normal_input_text.dart';

class CountDownInputText extends StatefulWidget {
  CountDownInputText({
    super.key,
    this.placeholder,
    this.maxSecond = 60,
    this.clickCountForResponseCallBack,
    this.onChanged,
    this.keyboardType,
    required this.canSend,
  });
  final String? placeholder;
  final int maxSecond;
  final Future<bool> Function()? clickCountForResponseCallBack;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  bool canSend = false;
  @override
  CountDownInputTextState createState() {
    return CountDownInputTextState();
  }
}

class CountDownInputTextState extends State<CountDownInputText> {
  Timer? _timer;
  int currentCount = 0;
  String tarString = 'send_sms_code'.tr();
  bool counting = false;

  Future<void> startResponse() async {
    if (counting || widget.canSend == false) {
      return;
    }
    if (_timer?.isActive == true) return;
    Future<bool>? response = widget.clickCountForResponseCallBack?.call();
    if (response != null) {
      bool canResponse = await response;
      if (canResponse) {
        startCount();
      }
    }
  }

  void startCount() {
    currentCount = widget.maxSecond;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkCount();
    });
  }

  void checkCount() {
    bool _counting = false;
    String tar = '';
    if (currentCount < 1) {
      tar = 'send_sms_code'.tr();
      _timer?.cancel();
      _counting = false;
    } else {
      currentCount = currentCount - 1;
      tar = '${currentCount}s';
      _counting = true;
    }
    setState(() {
      if (tar != tarString) {
        tarString = tar;
      }
      if (counting != _counting) {
        counting = _counting;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return NormalInputText(
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          placeholder: widget.placeholder,
          tailChild: GestureDetector(
            child: Text(
              tarString,
              style: (widget.canSend || counting)
                  ? style.clickStyle()
                  : style.disableStyle(),
            ),
            onTap: () {
              startResponse();
            },
          ),
        );
      },
    );
  }
}
