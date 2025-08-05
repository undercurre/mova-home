import 'package:flutter/material.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'package:flutter_plugin/able/dm_router.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:go_router/go_router.dart';

mixin AppRoutersMinin {
  /// Go 跳转到指定页面
  /// path: 路由地址
  /// extra: 传递的参数
  go(String path, {Object? extra = null}) {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      GoRouter.of(AppRoutes.getNavigatorKey()!.currentContext!)
          .go(path, extra: extra);
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  /// push 跳转到指定页面
  /// path: 路由地址
  /// extra: 传递的参数
  /// return: Future<T?>
  Future<T?> push<T extends Object?>(String path, {Object? extra}) async {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      return GoRouter.of(AppRoutes.getNavigatorKey()!.currentContext!)
          .push(path, extra: extra);
    }
    return Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
  }

  /// replace 跳转到指定页面
  /// path: 路由地址
  /// extra: 传递的参数
  /// return: Future<T?>
  void replace(String path, {Object? extra}) {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      return GoRouter.of(AppRoutes.getNavigatorKey()!.currentContext!)
          .replace(path, extra: extra);
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  /// pop 跳转到指定页面
  void pop<T extends Object?>([T? result]) {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      return GoRouter.of(AppRoutes.getNavigatorKey()!.currentContext!)
          .checkPop(result);
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  /// pop 跳转到指定页面
  /// path: 指定path
  void popUntil({String? path, String? path2}) {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      try {
        Navigator.popUntil(AppRoutes.getNavigatorKey()!.currentContext!,
                (route) {
              LogUtils.d(
                  '--------popUntil---------${route.settings.name}  ${route.isFirst}');
              return path == route.settings.name ||
                  path2 == route.settings.name ||
                  route.isFirst;
            });
      } catch (e) {
        LogUtils.e('--------popUntil---------$e');
      }
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  /// pop 跳转到指定页面
  /// path: 指定path
  void popOrPushPage(String path,
      {required String topPath, required String topPath2}) {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      try {
        /// 如果当前栈中存在 目标页面，则pop到目标页面
        /// 如果当前栈中不存在 目标页面，则在endPath前添加
        Page<dynamic>? toPage =
        Navigator.of(AppRoutes.getNavigatorKey()!.currentContext!)
            .widget
            .pages
            .firstWhereOrNull((element) => element.name == path);
        Navigator.popUntil(
            AppRoutes.getNavigatorKey()!.currentContext!,
                (route) =>
            (route.settings.name == path) ||
                route.settings.name == topPath ||
                route.settings.name == topPath2 ||
                route.isFirst);
        if (toPage != null) {
          LogUtils.d('--------popOrPushPage---------popUntil $path');
        } else {
          LogUtils.d('--------popOrPushPage---------push $path');
          push(path);
        }
      } catch (e) {
        LogUtils.e('--------popUntil---------$e');
      }
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  /// pop 跳转到指定页面
  /// path: 指定path
  void popAbove(String path,
      {required String topPath, required String topPath2}) {
    var currentContext2 = AppRoutes.getNavigatorKey()?.currentContext;
    if (currentContext2 != null) {
      try {
        /// 如果当前栈中存在 目标页面，则pop到目标页面
        /// 如果当前栈中不存在 目标页面，则在endPath前添加
        var pagesList = Navigator.of(currentContext2).widget.pages;
        Page<dynamic>? toPage =
        pagesList.firstWhereOrNull((element) => element.name == path);
        for (var element in pagesList.reversed) {
          if (element == toPage ||
              element.name == topPath ||
              element.name == topPath2) {
            break;
          }
          Navigator.pop(currentContext2);
        }
        if (toPage != null) {
          LogUtils.d('--------popOrPushPage---------popUntil $path');
        } else {
          LogUtils.d('--------popOrPushPage---------push $path');
          push(path);
        }
      } catch (e) {
        LogUtils.e('--------popUntil---------$e');
      }
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  /// pop 跳转到指定页面
  /// path: 指定path
  Future<void> popUntilAndPush({String? untilPath, String? path}) async {
    if (AppRoutes.getNavigatorKey()?.currentContext != null) {
      popUntil(path: untilPath);
      if (path != null) {
        await push(path);
      }
    } else {
      Future.error('AppRoutes.getNavigatorKey()?.currentContext == null');
    }
  }

  GoRouterState? getGoRouterState(BuildContext context) {
    var state = GoRouterState.of(context);
    return state;
  }

  T? getGoRouterStateExtra<T extends Object>(BuildContext context) {
    var state = getGoRouterState(context);
    if (state == null || state.extra == null) {
      return null;
    }
    if (state.extra is T) {
      return state.extra as T;
    }else{
      //
      LogUtils.e('[AppRoutersMinin] getGoRouterStateExtra 类型不匹配 state.extra：${state.extra} ,T: ${T.runtimeType}');
    }
    return null;
  }
}
