import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/CustomTextSelectiontoolbar.dart';
import 'package:flutter_plugin/utils/widget_extension.dart';

// ignore: must_be_immutable
class DMTextFieldItem extends StatefulWidget {
  final double? width; //宽度
  final double? height; //高度
  final TextEditingController? controller; //控制器
  final String? text; //默认TextField的内容
  final TextStyle? inputStyle; //文字样式
  final String? placeText; //占位字符串
  final TextStyle? placeTextStyle;
  final FocusNode? focusNode;
  final bool? showClear; //是否展示一键清除
  final bool? obscureText; //文字是否加密
  final bool? showPrivate; //是否展示隐私按钮
  final bool? showBottomDivider; //是否展示下边分割线
  final bool? autofocus;
  final EdgeInsetsGeometry? margin; //textField的margin
  final EdgeInsetsGeometry? padding; //textField的pading
  Color? backgroundColor; //背景颜色
  Color? tinkColor;
  double? borderRadius; //圆角半径
  TextInputType? keyboardType;
  final int? maxLength;
  final ValueChanged<String>? onChanged; //状态发生改变回调
  final ValueChanged<String>? onEditingComplete; //占位字符串样式
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onDismiss;

  final Widget? leftWidget; //TextField左侧自定义组件
  final Widget? rightWidget; //TextField右侧自定义组件
  final Widget? clearWidget; //自定义清除的widget
  final Widget? privateOpenImage; //自定义打开隐私的widget
  final Widget? privateCloseImage; //自定义关闭隐私的widget

  DMTextFieldItem({
    super.key,
    required this.width,
    required this.height,
    this.controller,
    this.leftWidget,
    this.placeText,
    this.placeTextStyle,
    this.focusNode,
    this.text,
    this.inputStyle,
    this.showClear = false,
    this.obscureText = false,
    this.showPrivate = false,
    this.showBottomDivider = true,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onDismiss,
    this.autofocus,
    this.margin,
    this.padding,
    this.clearWidget,
    this.borderRadius,
    this.keyboardType,
    this.maxLength,
    this.privateOpenImage,
    this.privateCloseImage,
    this.rightWidget,
  });

  @override
  State<DMTextFieldItem> createState() => DMTextFieldItemState();
}

class DMTextFieldItemState extends State<DMTextFieldItem> {
  FocusNode _focusNode = FocusNode();
  bool insideShowClear = false; //显示清除按钮
  bool _obscureText = false; //隐藏TextField
  final GlobalKey _clearButtonKey = GlobalKey(); // GlobalKey 用于清除按钮
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? _focusNode;
    _obscureText = widget.obscureText!;

    _editController =
        widget.controller ?? TextEditingController(text: widget.text ?? '');
    addListening();
  }

  void addListening() {
    _editController.addListener(() {
      if (_editController.text.isNotEmpty &&
          _focusNode.hasFocus &&
          widget.showClear == true) {
        setState(() {
          insideShowClear = true;
        });
      } else {
        setState(() {
          insideShowClear = false;
        });
      }
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          insideShowClear = false;
        });
      }
    });
  }

  Widget _clearButtonWidget() {
    return ThemeWidget(builder: (_, style, resource) {
      return GestureDetector(
          onTapDown: (details) {
            _editController.text = '';
            if (widget.onChanged != null) {
              widget.onChanged!('');
            }
            _focusNode.unfocus();
          },
          child: widget.clearWidget ??
              Image.asset(
                resource.getResource('btn_input_clearBtn'),
                width: 24,
                height: 24,
              ).withDynamic());
    });
  }

  Widget _secretButtonWidget() {
    return ThemeWidget(builder: (_, style, resource) {
      return Semantics(
        label: _obscureText ?  'hide_password'.tr() : 'show_password'.tr(),
        child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Image.asset(
              resource.getResource(
                  _obscureText ? 'ic_eye_hide' : 'ic_eye_show'),
              width: 20,
              height: 21,
            ).withDynamic()),
      );
    });
  }

  void onTapOutside(PointerDownEvent event) {
    FocusNode node = widget.focusNode ?? _focusNode;

    // 获取清除按钮的 RenderBox
    RenderBox? clearButtonRenderBox =
        _clearButtonKey.currentContext?.findRenderObject() as RenderBox?;

    if (clearButtonRenderBox != null) {
      // 获取清除按钮的尺寸和位置
      Offset clearButtonPosition =
          clearButtonRenderBox.localToGlobal(Offset.zero);
      Size clearButtonSize = clearButtonRenderBox.size;

      // 检查点击位置是否在清除按钮内
      bool isClickOnClearButton = event.position.dx >= clearButtonPosition.dx &&
          event.position.dx <= clearButtonPosition.dx + clearButtonSize.width &&
          event.position.dy >= clearButtonPosition.dy &&
          event.position.dy <= clearButtonPosition.dy + clearButtonSize.height;

      if (!isClickOnClearButton) {
        // 如果点击不在清除按钮内，释放焦点
        node.unfocus();

        if (widget.onDismiss != null) {
          widget.onDismiss!();
        }

        setState(() {
          insideShowClear = false;
        });
      } else {
        // 如果点击在清除按钮内，清空输入框
        _editController.text = '';
        if (widget.onChanged != null) {
          widget.onChanged!('');
        }
      }
    }
  }

  void onTapTextField() {
    if (_editController.text.isNotEmpty) {
      setState(() {
        insideShowClear = true;
      });
    }
  }

  void onTextChanged(value) {
    if (widget.keyboardType == TextInputType.number &&
        value.length == widget.maxLength) {
      // 如果是数字键盘，确保输入的值是数字
      if (widget.onEditingComplete != null) {
        widget.onEditingComplete!(value);
      }
    }

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  void onEditingComplete() {
    _focusNode.unfocus();
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete!(_editController.text);
    }
  }

  void onSubmitted(value) {
    _focusNode.unfocus();
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return CustomTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWidget(builder: (context, style, resource) {
      return Container(
        padding: (widget.padding ?? const EdgeInsets.symmetric(horizontal: 16)),
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius ?? 0))),
        margin: (widget.margin ?? const EdgeInsets.symmetric(vertical: 10)),
        width: widget.width,
        height: widget.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: widget.leftWidget != null,
                  child: Container(
                    child: widget.leftWidget,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      maxLength: widget.maxLength,
                      style: widget.inputStyle,
                      keyboardType: widget.keyboardType ?? TextInputType.text,
                      autofocus: false,
                      obscureText: _obscureText,
                      magnifierConfiguration:
                          TextMagnifierConfiguration.disabled,
                      cursorColor: style.textMainBlack,
                      controller: _editController,
                      focusNode: widget.focusNode ?? _focusNode,
                      decoration: InputDecoration(
                        // label:Text('请设置您的密码',style: TextStyle(color:style.textDisable, fontSize: style.largeText,) ,),
                        counterText: '',
                        hintText: (widget.placeText ?? ''),
                        hintStyle: (widget.placeTextStyle ??
                            TextStyle(
                                color: style.textDisable,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onTapOutside: onTapOutside,
                      onTap: onTapTextField,
                      onChanged: onTextChanged,
                      onEditingComplete: onEditingComplete,
                      onSubmitted: onSubmitted,
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      (insideShowClear != false && widget.showClear == true),
                  child: Container(
                    key: _clearButtonKey,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _clearButtonWidget(),
                  ),
                ),
                Visibility(
                  visible: widget.showPrivate != false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _secretButtonWidget(),
                  ),
                ),
                Visibility(
                  visible: widget.rightWidget != null,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    widget.rightWidget ?? const SizedBox.shrink()
                  ]),
                )
              ],
            ),
            Visibility(
              visible: widget.showBottomDivider == true,
              child: Container(
                height: 1,
                decoration: BoxDecoration(color: style.lightBlack1),
              ),
            )
          ],
        ),
      );
    });
  }
}
