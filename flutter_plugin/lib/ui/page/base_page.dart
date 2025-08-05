import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/ui/page/main/open_install_mixin.dart';
import 'package:flutter_plugin/common/theme/app_theme_manager.dart';
import 'package:flutter_plugin/common/theme/app_theme_notifier.dart';
import 'package:flutter_plugin/model/event/app_lifecycle_event.dart';
import 'package:flutter_plugin/res/resource_model.dart';
import 'package:flutter_plugin/res/style_model.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/widget/common/nav_bar.dart';
import 'package:flutter_plugin/ui/widget/dialog/common_popup.dart';
import 'package:flutter_plugin/utils/burial_point_util.dart';
import 'package:flutter_plugin/utils/event_bus_util.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:flutter/scheduler.dart';

class BasePage extends ConsumerStatefulWidget {
  const BasePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return BasePageState();
  }
}

class BasePageState<T extends ConsumerStatefulWidget> extends ConsumerState<T>
    with
        WidgetsBindingObserver /*此处注册略微晚于lifecycle的回调*/,
        LifecycleAware,
        LifecycleMixin,
        OpenInstallMixin,
        CommonDialog {
  bool showTitle = true;
  var  keepOnlyStatusBar = false;
  String centerTitle = '';
  bool _canPanBack = Platform.isIOS;
  Color? navBackgroundColor;
  Color? backgroundColor;
  Widget? titleWidget;
  Widget? rightItemWidget;
  Widget? leftItemWidget;
  bool showNavbarSeparator = false;
  ThemeStyle? navBarTheme;

  LifecycleEvent _lifecycleEvent = LifecycleEvent.push;

  bool get resizeToAvoidBottomInset => false;

  @override
  void initState() {
    super.initState();
    LogUtils.d('----onApp initState ---- $this $centerTitle $showTitle');
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    EventBusUtil.getInstance().register<AppEnterBackgroundEvent>(this, (event) {
      onAppPaused();
    });
    EventBusUtil.getInstance().register<AppEnterForegroundEvent>(this, (event) {
      onAppResume();
    });
    EventBusUtil.getInstance().register<AppDestoryEvent>(this, (event) {
      dispose();
      // 原生触发子引擎销毁
      if (Platform.isIOS) {
        BurialPointUtil().destroy();
      }
    });
    EventBusUtil.getInstance().register<ReportRegisterEvent>(this, (event) {
      reportRegister();
    });
    initPageState();
  }

  @override
  void dispose() {
    EventBusUtil.getInstance().unRegister(this);
    super.dispose();
    LogUtils.d('----onApp dispose ---- $this $centerTitle');
  }

  @override
  void activate() {
    super.activate();
    LogUtils.d('----onApp activate ---- $this $centerTitle');
  }

  @override
  void deactivate() {
    super.deactivate();
    LogUtils.d('----onApp deactivate ---- $this $centerTitle');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onAppResume();
    } else if (state == AppLifecycleState.paused) {
      onAppPaused();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  /// App onResume
  void onAppResume() {
    LogUtils.d(
        '----onApp onAppResume ---- $this $centerTitle $_lifecycleEvent');
    if (_lifecycleEvent == LifecycleEvent.active) {
      onAppResumeAndActive();
    }
    onBecomeActive();
  }

  /// 页面激活 - application级别，各页面实现
  void onBecomeActive() {}

  /// App onResume并且 页面在前台
  void onAppResumeAndActive() {}

  /// App onResume并且 页面在前台
  void onAppResumeAndInactive() {}

  /// App onPaused，此处注册略微晚于lifecycle的回调,导致页面先inactive,再onAppPaused，
  /// 暂时无法区分前台页面
  void onAppPaused() {
    LogUtils.d(
        '----onApp onAppPaused ---- $this $centerTitle $_lifecycleEvent');
  }

  /// 初始化页面状态
  void initPageState() {}

  /// 初始化数据
  void initData() {}

  /// 添加观察者, eg: ref.listen()
  void addObserver() {}

  void addBaseObserver() {
    // 根据暗黑模式状态设置状态栏样式
    ref.listen(appThemeStateNotifierProvider, (previous, next) {
      final themeMode = next;
      AppThemeManager().updateAppThemeMode(themeMode);
    });
    addObserver();
  }

  /// 标题返回点击
  void onTitleLeftClick() {
    AppRoutes().pop();
  }

  Widget buildBody(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return const Spacer();
  }

  PreferredSizeWidget? buildNavBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return showTitle
        ? NavBar(
            isShowSeparator: showNavbarSeparator,
            backHidden: leftItemWidget != null ? true : false,
            leftWidget: leftItemWidget,
            rightWidget: rightItemWidget,
            itemAction: (tag) {
              if (tag == BarButtonTag.left) {
                onTitleLeftClick();
              }
            },
            title: centerTitle,
            bgColor: navBackgroundColor ?? style.bgColor,
            theme: navBarTheme ?? ThemeStyle.dark,
            titleWidget: titleWidget,
          )
        : null;
  }

  Widget? buildBottomNavigationBar(
      BuildContext context, StyleModel style, ResourceModel resource) {
    return null;
  }

  /// 返回点击
  Future<bool> onBackClick() async {
    LogUtils.i('base_page --------- onBackClick $this');
    // 隐藏键盘
    if (Platform.isIOS) {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    return true;
  }

  void updateCanPan(bool enable) {
    if (_canPanBack != enable) {
      setState(() {
        _canPanBack = enable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    addBaseObserver();
    return ThemeWidget(
      builder: (context, style, resource) {
        return WillPopScope(
          onWillPop: _canPanBack ? null : onBackClick,
          child: Scaffold(
            backgroundColor: backgroundColor ?? style.bgColor,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            appBar: buildNavBar(context, style, resource),
            body: buildBody(context, style, resource),
            extendBodyBehindAppBar: navBackgroundColor == Colors.transparent,
            bottomNavigationBar:
                buildBottomNavigationBar(context, style, resource),
          ),
        );
      },
    );
  }

  @mustCallSuper
  @override
  void onLifecycleEvent(LifecycleEvent event) {
    this._lifecycleEvent = event;
    LogUtils.d('onLifecycleEvent: $this  ,event: $event');
    if (event == LifecycleEvent.push || event == LifecycleEvent.pop) {}
  }

  bool isVisible() => _lifecycleEvent == LifecycleEvent.visible;

  bool isInvisible() => _lifecycleEvent == LifecycleEvent.invisible;
}
