import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as TextDirection;
import 'package:flutter/services.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedInputText extends ConsumerStatefulWidget {
  static int TYPE_ACCOUNT = 0;
  static int TYPE_MOBILE = 1;
  static int TYPE_EMAIL = 2;

  static int INPUT_TYPE_TEXT = 0;
  static int INPUT_TYPE_PWD = 1;

  Color animateColor; //动画线颜色
  Color underLineColor; //下划线颜色
  double underLineHeight = 1; //下划线高度
  double animateLineHeight = 2; //动画线高度
  int animateTime = 800; //动画持续时间
  Widget? prefixChild;
  Widget? suffixChild;
  double fontSize;
  double hintFontSize;
  String? textValue;
  String? textHint;
  String countryCode;
  bool showCountryCode;
  bool showGetDynamicCode;
  bool enableGetDynamicCode;
  bool showEye;
  String? dynamicCodeText = 'send_sms_code'.tr();
  bool hidePassword;
  int inputType;
  String? initialValue;
  final GestureTapCallback? onTap;

  TextInputType? textInputType;
  List<TextInputFormatter>? inputFormatters;

  ValueChanged<String> onTextChanged;
  ValueChanged<bool>? onPassWordHideChanged;
  VoidCallback? changeCountryCode;
  Iterable<String>? autofillHints;
  TextEditingController? textEditingController;

  AnimatedInputText({
    super.key,
    this.fontSize = 20,
    this.hintFontSize = 16,
    this.textValue = '',
    this.textHint = '',
    this.showCountryCode = false,
    this.countryCode = '86',
    this.showGetDynamicCode = true,
    this.hidePassword = true,
    this.showEye = false,
    this.textInputType,
    required this.onTextChanged,
    this.underLineHeight = 1,
    this.animateLineHeight = 2,
    this.animateTime = 800,
    this.underLineColor = const Color(0xffE2E2E2),
    this.animateColor = const Color(0xFF8C4C18),
    this.prefixChild,
    this.suffixChild,
    this.onGetDynamicCodePress,
    this.enableGetDynamicCode = false,
    this.dynamicCodeText,
    this.changeCountryCode,
    this.initialValue,
    this.inputType = 0,
    this.inputFormatters = null,
    this.onPassWordHideChanged,
    this.onTap,
    this.autofillHints,
    this.textEditingController,
  });

  VoidCallback? onGetDynamicCodePress;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AnimatedInputTextState();
  }
}

class AnimatedInputTextState extends ConsumerState<AnimatedInputText>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late final TextEditingController _textEditingController =
      widget.textEditingController ?? TextEditingController();
  late Tween<double> sizeTween;
  double _width = 0.0;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey globalKey = GlobalKey();
  bool animateVisible = false;
  bool isSettingInitValue = false;

  @override
  void didUpdateWidget(covariant AnimatedInputText oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if (oldWidget.initialValue == null) {
    //   _textEditingController.text = widget.initialValue ?? '';
    // }
    if (!isSettingInitValue &&
        oldWidget.initialValue == null &&
        widget.initialValue != null) {
      isSettingInitValue = true;
      _textEditingController.text = widget.initialValue ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      isSettingInitValue = true;
      _textEditingController.text = widget.initialValue ?? '';
    }
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.animateTime),
        upperBound: 1);
    _controller.addListener(() {
      setState(() {
        _width = sizeTween.evaluate(_controller);
      });
    });
// 动画开始执行
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          animateVisible = false;
        });
        _controller.reset();
      } else {
        setState(() {
          _width = 0;
          animateVisible = true;
        });
        sizeTween =
            Tween(begin: 0.0, end: globalKey.currentContext?.size?.width);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  void onTextChange(String value) {
    widget.onTextChanged(value);
  }

  void _onShowPress() {
    setState(() {
      widget.hidePassword = !widget.hidePassword;
    });
    var onPassWordHideChanged = widget.onPassWordHideChanged;
    if (onPassWordHideChanged != null) {
      onPassWordHideChanged(widget.hidePassword);
    }
  }

  /// 清空已输入的内容
  void clearAndReInput({String? input}) {
    _textEditingController.clear();
    if (input != null) {
      _textEditingController.text = input;
    }
  }

  String? currentInputText() {
    return _textEditingController.text;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (_, style, resource) {
      return Column(
        key: globalKey,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: _textEditingController,
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
              onTap: () {
                _focusNode.requestFocus();
                widget.onTap?.call();
              },
              inputFormatters: widget.inputFormatters,
              // 控制放大镜效果不展示
              magnifierConfiguration: TextMagnifierConfiguration.disabled,
              onChanged: onTextChange,
              focusNode: _focusNode,
              textInputAction: TextInputAction.next,
              autofocus: false,
              readOnly: false,
              cursorColor: style.textMain,
              maxLines: 1,
              minLines: 1,
              autofillHints: widget.autofillHints,
              keyboardType: widget.textInputType,
              obscureText:
                  widget.inputType == AnimatedInputText.INPUT_TYPE_PWD &&
                      widget.hidePassword,
              style: TextStyle(
                  color: style.textMain,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                  fontSize: widget.fontSize),
              decoration: InputDecoration(
                hintText: widget.textHint ?? '',
                hintStyle: TextStyle(
                    color: style.textDisable,
                    fontWeight: FontWeight.w300,
                    fontSize: widget.hintFontSize),
                border: InputBorder.none,
                prefixIcon: widget.prefixChild ?? prefixIcon(style, resource),
                suffixIcon: widget.suffixChild ?? suffixIcon(style, resource),
              )),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: widget.underLineHeight,
                decoration: BoxDecoration(color: widget.underLineColor),
              ),
              Visibility(
                visible: animateVisible,
                child: SizedBox.fromSize(
                  child: Container(
                    width: _width,
                    height: widget.animateLineHeight,
                    color: widget.animateColor,
                  ),
                ),
              )
            ],
          ),
        ],
      );
    });
  }

  Widget? prefixIcon(StyleModel style, ResourceModel resourceModel) {
    return widget.showCountryCode
        ? GestureDetector(
            onTap: widget.changeCountryCode,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('+${widget.countryCode}',
                    textDirection: TextDirection.TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: style.textMain,
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
                Image.asset(
                  resourceModel.getResource('icon_arrow_right2'),
                  width: 15,
                  height: 13,
                ).flipWithRTL(context)
              ],
            ),
          )
        : null;
  }

  Widget? suffixIcon(StyleModel style, ResourceModel resourceModel) {
    return widget.showEye
        ? Semantics(
            label: widget.hidePassword ? 'hide_password'.tr() : 'show_password'.tr(),
            child: GestureDetector(
                onTapDown: (details) {
                  _onShowPress();
                },
                child: Image.asset(
                  resourceModel.getResource(
                      widget.hidePassword ? 'ic_eye_hide' : 'ic_eye_show'),
                  width: 18,
                  height: 18,
                ).withDynamic()),
          )
        : (widget.showGetDynamicCode
            ? GestureDetector(
                onTap: widget.onGetDynamicCodePress,
                child: SizedBox(
                  width: 80,
                  child: Center(
                    child: Text('${widget.dynamicCodeText}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: widget.enableGetDynamicCode
                                ? style.click
                                : style.textDisable,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              )
            : null);
  }
}
