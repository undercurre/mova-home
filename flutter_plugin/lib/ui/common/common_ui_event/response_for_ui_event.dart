import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin/able/dm_router.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:go_router/go_router.dart';

mixin ResponseForeUiEvent<T extends StatefulWidget> on State<T>, CommonDialog {
  CommonEventAction? responseFor(CommonUIEvent event) {
    switch (event) {
      case ToastEvent toast:
        if (toast.text.isNotEmpty) {
          // if (Platform.isIOS) {
          //   final currentFocus = FocusScope.of(context);
          //   if (!currentFocus.hasPrimaryFocus) {
          //     currentFocus.unfocus();
          //   }
          // }
          SmartDialog.showToast(toast.text);
        }
        break;
      case LoadingEvent event:
        if (event.isLoading) {
          SmartDialog.showLoading();
        } else {
          SmartDialog.dismiss(status: SmartStatus.loading);
        }
        break;
      case AlertEvent alert:
        showAlertDialog(
            title: alert.title ?? '',
            content: alert.content ?? '',
            contentAlign: alert.contentAlign,
            cancelContent: alert.cancelContent ?? '',
            cancelCallback: () {
              alert.cancelCallback?.call();
            },
            confirmContent: alert.confirmContent ?? '',
            confirmCallback: () {
              alert.confirmCallback?.call();
            });
        break;
      case AlertConfirmEvent alert:
        showConfirmDialog(
            title: alert.title ?? '',
            content: alert.content ?? '',
            contentAlign: alert.contentAlign,
            confirmContent: alert.confirmContent ?? '',
            confirmCallback: () {
              alert.confirmCallback?.call();
            });
        break;
      case CustomAlertEvent alert:
        showCustomCommonDialog(
            topWidget: alert.topWidget,
            content: alert.content ?? '',
            contentAlign: alert.contentAlign,
            confirmContent: alert.confirmContent ?? '',
            cancelContent: alert.cancelContent ?? '',
            cancelCallback: () {
              alert.cancelCallback?.call();
            },
            confirmCallback: () {
              alert.confirmCallback?.call();
            });
        break;
      case AlertInputEvent alert:
        showInputDialog(
            title: alert.title ?? '',
            hint: alert.hint ?? '',
            maxLength: alert.maxLength,
            cancelText: alert.cancelContent ?? '',
            confirmText: alert.confirmContent ?? '',
            confirmCallback: (text) {
              alert.confirmCallback?.call(text);
            },
            maxLengthCallback: () => alert.maxLengthCallback?.call(),
            content: alert.content ?? '');
        break;
      case PushEvent push:
        if (push.func == RouterFunc.push) {
          checkPush(push);
        } else {
          checkWithOutPush(push);
        }

        break;
      case ResetLocalEvent _:
        resetLocal();
        break;
      case ActionEvent action:
        return action.action;
      case SuccessEvent success:
        return success.action;
      default:
        break;
    }
    return null;
  }

  void resetLocal() {
    context.setLocale(LanguageStore().getCurrentLanguage().toLanguageLocal());
  }

  Future<void> checkPush(PushEvent push) async {
    if (push.func == RouterFunc.push) {
      if (push.path != null) {
        if (push.pushCallback != null) {
          Object? value =
              await GoRouter.of(context).push(push.path!, extra: push.extra);
          push.pushCallback!(value);
        } else {
          await GoRouter.of(context).push(push.path!, extra: push.extra);
        }
      }
    }
  }

  void checkWithOutPush(PushEvent push) {
    switch (push.func) {
      case RouterFunc.push:
        break;
      case RouterFunc.go:
        if (push.path != null) {
          try {
            Page<dynamic> toPage = Navigator.of(context)
                .widget
                .pages
                .firstWhere((element) => ('${element.name}' == push.path));
            Navigator.popUntil(context, (route) {
              if (route.isFirst) return true;
              print('objedasdssct${route.settings.name}');
              return route.settings.name == toPage.name;
            });
          } catch (_) {
            GoRouter.of(context).push(push.path!);
          }
        }
        break;
      case RouterFunc.pop:
        if (push.path == null) {
          GoRouter.of(context).checkPop();
        } else {
          Navigator.of(context).popUntil((route) {
            if (route.isFirst) return true;
            return '${route.settings.name}' == push.path!;
          });
        }
        break;
      case RouterFunc.reset:
        if (push.path != null) {
          GoRouter.of(context).replace(push.path!);
        }
        break;
      default:
    }
  }
}

// mixin requestForUiEvent<T> on AutoDisposeNotifier<T> {

// }
