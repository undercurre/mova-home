import 'package:flutter/material.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_type.dart';

sealed class CommonUIEvent {
  const CommonUIEvent();
}

class EmptyEvent extends CommonUIEvent {
  const EmptyEvent();
}

class ToastEvent extends CommonUIEvent {
  const ToastEvent({required this.text});
  final String text;
}

class LoadingEvent extends CommonUIEvent {
  const LoadingEvent({this.isLoading = true});
  final bool isLoading;
}

class AlertEvent extends CommonUIEvent {
  AlertEvent({
    this.title,
    this.content,
    this.cancelContent,
    this.confirmContent,
    this.confirmCallback,
    this.cancelCallback,
    this.contentAlign = TextAlign.center,
  });
  String? title;
  String? content;
  String? cancelContent;
  String? confirmContent;
  TextAlign contentAlign;
  Function()? cancelCallback;
  Function()? confirmCallback;
}

class SocialAlertTipEvent extends CommonUIEvent {}

class AlertConfirmEvent extends CommonUIEvent {
  AlertConfirmEvent({
    this.title,
    this.content,
    this.confirmContent,
    this.confirmCallback,
    this.contentAlign = TextAlign.center,
  });
  String? title;
  String? content;
  String? confirmContent;
  TextAlign contentAlign;
  Function()? confirmCallback;
}

class CustomAlertEvent extends CommonUIEvent {
  CustomAlertEvent({
    this.topWidget,
    this.content,
    this.confirmContent,
    this.confirmCallback,
    this.cancelContent,
    this.cancelCallback,
    this.contentAlign = TextAlign.center,
  });
  Widget? topWidget;
  String? content;
  String? confirmContent;
  String? cancelContent;
  TextAlign contentAlign;
  Function()? confirmCallback;
  Function()? cancelCallback;
}

class AlertInputEvent extends CommonUIEvent {
  AlertInputEvent(
      {this.title,
      this.content,
      this.hint,
      this.maxLength = TextField.noMaxLength,
      this.cancelContent,
      this.maxLengthCallback,
      this.confirmContent,
      this.confirmCallback});
  String? title;
  String? hint;
  String? content;
  int maxLength;
  String? cancelContent;
  String? confirmContent;
  Function(String)? confirmCallback;
  VoidCallback? maxLengthCallback;
}

class SchemeEvent extends CommonUIEvent {
  SchemeEvent(this.type, {this.ext});
  SchemeType type;
  dynamic ext;
}

class PushEvent extends CommonUIEvent {
  PushEvent({
    this.path,
    this.extra,
    this.func = RouterFunc.push,
    this.pushCallback,
    this.popUntilPath,
  });
  String? path;
  Object? extra;
  String? popUntilPath;
  Function(Object? value)? pushCallback;
  RouterFunc func = RouterFunc.push;
}

enum RouterFunc { push, reset, pop, go }

class ResetLocalEvent extends CommonUIEvent {}

/// CommonUIEvent 扩展
/// SuccessEvent
class SuccessEvent<T> extends CommonUIEvent {
  final T data;
  final CommonEventAction? action;
  SuccessEvent({required this.data, this.action});
}

/// CommonUIEvent 扩展
/// ActionEvent
class ActionEvent extends CommonUIEvent {
  ActionEvent({required this.action});
  CommonEventAction action;
}

/// CommonUIEvent 扩展
/// ActionEvent
/// 事件action定义
class CommonEventAction {}
