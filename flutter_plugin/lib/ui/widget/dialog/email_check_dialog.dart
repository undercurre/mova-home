import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/dm_button.dart';
import 'package:flutter_plugin/utils/edge_insets_extension.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

/// 使用SmartDialog.show()展示
// ignore: must_be_immutable

typedef CheckNowCallback = void Function(String, String);
typedef SendClickCallback = Future<bool> Function(String);

class EmailCheckDialogWidget extends StatefulWidget {
  final String? email;
  final VoidCallback? cancelCallback;
  final VoidCallback? maxLengthCallback;
  final CheckNowCallback confirmCallback;
  final SendClickCallback? onSendClickCallback;

  const EmailCheckDialogWidget(this.confirmCallback,
      {super.key,
      this.email,
      this.cancelCallback,
      this.maxLengthCallback,
      this.onSendClickCallback});

  @override
  _EmailCheckDialogWidgetState createState() {
    return _EmailCheckDialogWidgetState();
  }
}

class _EmailCheckDialogWidgetState extends State<EmailCheckDialogWidget> {
  late TextEditingController _emailController;
  late TextEditingController _codeController;
  final FocusNode _emailFocusNode = FocusNode();

  Timer? _countdownTimer;
  bool _sendEnable = true;
  bool _checkEnable = false;
  int _countdown = 0;
  String _sendButtonText = 'send_sms_code'.tr();
  bool _isSent = false;

  @override
  void initState() {
    super.initState();
    // _email = (AccountModule().getUserInfo())?.email;
    _emailFocusNode.requestFocus();

    _emailController = TextEditingController(text: widget.email);
    _emailController.addListener(() {
      var email = _emailController.text;
      var code = _codeController.text;
      if (email.isNotEmpty && isVaildEmail(email)) {
        setState(() {
          _sendEnable = true;
          _checkEnable = code.isNotEmpty && code.length == 6 && _isSent;
        });
      } else {
        setState(() {
          _sendEnable = false;
          _checkEnable = false;
        });
      }
    });
    _codeController = TextEditingController();
    _codeController.addListener(() {
      var code = _codeController.text;
      var email = _emailController.text;
      if (code.isNotEmpty && code.length == 6 && isVaildEmail(email)) {
        setState(() {
          _checkEnable = true;
          _checkEnable = _isSent;
        });
      } else {
        setState(() {
          _checkEnable = false;
          _checkEnable = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      builder: (context, style, resource) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(style.circular20),
              color: style.bgWhite),
          margin: const EdgeInsets.symmetric(horizontal: 35),
          padding:
              const EdgeInsets.only(top: 22, left: 12, right: 12, bottom: 22)
                  .withRTL(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'account_security_verification'.tr(),
                style: TextStyle(
                    color: style.normal,
                    fontSize: style.head,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 8)
                    .withRTL(context),
                child: Text(
                  'account_security_verification_des'.tr(),
                  style: style.secondStyle(),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                height: 48,
                margin: const EdgeInsets.only(top: 6).withRTL(context),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8).withRTL(context),
                decoration: BoxDecoration(
                    border: Border.all(color: style.lightBlack1, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        resource.getResource('email_collect_email'),
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: TextField(
                          style: style.fourthStyle(),
                          cursorColor: style.textMainBlack,
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          magnifierConfiguration:
                              TextMagnifierConfiguration.disabled,
                          decoration: const InputDecoration(
                            // label:Text('请设置您的密码',style: TextStyle(color:style.textDisable, fontSize: style.largeText,) ,),
                            counterText: '',
                            hintStyle: (TextStyle(
                                color: Color(0xFFA6A6A6),
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                    ]),
              ),
              Container(
                height: 48,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8).withRTL(context),
                margin: const EdgeInsets.only(top: 6).withRTL(context),
                decoration: BoxDecoration(
                    border: Border.all(color: style.lightBlack1, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        style: style.fourthStyle(),
                        cursorColor: style.textMainBlack,
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        magnifierConfiguration:
                            TextMagnifierConfiguration.disabled,
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: (''),
                          hintStyle: (TextStyle(
                              color: Color(0xFFA6A6A6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      _sendButtonText,
                      style: _sendEnable || _countdown > 0
                          ? style.clickStyle()
                          : style.disableStyle(),
                    ).onClick(() async {
                      if (!_sendEnable) return;

                      var send = await widget.onSendClickCallback
                          ?.call(_emailController.text);
                      if (send == true) {
                        setState(() {
                          _isSent = true;
                        });
                        startTime();
                      }
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 12, right: 12)
                    .withRTL(context),
                child: Row(
                  children: [
                    Expanded(
                      child: DMButton(
                          height: 48,
                          borderRadius: style.buttonBorder,
                          width: double.infinity,
                          textColor: style.cancelBtnTextColor,
                          backgroundGradient: style.cancelBtnGradient,
                          text: 'account_security_verification_later'.tr(),
                          onClickCallback: (_) {
                            widget.cancelCallback?.call();
                          }),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: DMButton(
                          height: 48,
                          borderRadius: style.buttonBorder,
                          fontsize: 16,
                          fontWidget: FontWeight.bold,
                          textColor:
                              _checkEnable ? style.enableBtnTextColor : style.disableBtnTextColor,
                           backgroundGradient: _checkEnable ? style.confirmBtnGradient : style.disableBtnGradient,
                          text: 'account_security_verification_now'.tr(),
                          width: double.infinity,
                          onClickCallback: (_) {
                            if (!_checkEnable) return;
                            widget.confirmCallback.call(
                                _emailController.text, _codeController.text);
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void startTime() {
    setState(() {
      _sendEnable = false;
      _countdown = 60;
    });
    const period = Duration(seconds: 1);
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _countdownTimer = Timer.periodic(period, (timer) {
      _countdown--;
      _checkTimeInterval();
    });
    _checkTimeInterval();
  }

  void _checkTimeInterval() {
    String sendButtonText = '';
    bool sendEnable = false;
    if (_countdown > 0) {
      sendButtonText = '${_countdown.toString()}s';
      sendEnable = false;
    } else {
      sendButtonText = 'send_sms_code'.tr();
      sendEnable = true;
      _countdownTimer?.cancel();
      _countdownTimer = null;
    }

    setState(() {
      _sendEnable = sendEnable &&
          _emailController.text.isNotEmpty &&
          isVaildEmail(_emailController.text);
      _sendButtonText = sendButtonText;
      _checkEnable = _isSent &&
          _codeController.text.length == 6 &&
          _emailController.text.isNotEmpty &&
          isVaildEmail(_emailController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }
}
