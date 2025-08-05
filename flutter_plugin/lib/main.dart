import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dreame_flutter_plugin_open_setting/dreame_flutter_plugin_open_setting.dart';
import 'package:dreame_flutter_widget_dialog/dreame_flutter_widget_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_refresh/easy_refresh.dart';

// import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/configure/app_dynamic_res_config_provider.dart';
import 'package:flutter_plugin/common/network/http/network_util.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/common/theme/app_theme_manager.dart';
import 'package:flutter_plugin/res/theme_widget.dart';
import 'package:flutter_plugin/ui/page/home/device_status/key_define_provider.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/main/open_install_mixin.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_handle_notifier.dart';
import 'package:flutter_plugin/ui/widget/animated_rotation_box.dart';
import 'package:flutter_plugin/ui/widget/custom_toast.dart';
import 'package:flutter_plugin/ui/widget/gradient_circular_progress_indicator.dart';
import 'package:flutter_plugin/ui/widget/refresh/custom_header.dart';
import 'package:flutter_plugin/utils/burial_point_util.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/theme/app_theme_notifier.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    LogUtils.d(('didChangeAppLifecycleState: $state'));
    if (state == AppLifecycleState.detached) {
      BurialPointUtil().destroy();
    }
  }
}

void main(List<String> args) {
  if (!kDebugMode) {
    debugPrint = (message, {wrapWidth}) {};
  }

  void reportErrorAndLog(FlutterErrorDetails details) {
    final errorMsg = {
      'exception': details.exceptionAsString(),
      'stackTrace': details.stack.toString(),
    };
    LogUtils.e('reportErrorAndLog : $errorMsg');
  }

  FlutterErrorDetails makeDetails(Object error, StackTrace stackTrace) {
    // 构建错误信息
    return FlutterErrorDetails(stack: stackTrace, exception: error);
  }

  FlutterError.onError = (details) {
    LogUtils.e('-----onError------: $details');
    //获取 widget build 过程中出现的异常错误
    reportErrorAndLog(details);
  };

  // debug版本需要手动注释以下代码
  // debugPrint = (message, {wrapWidth}) {};

  _init(() {

    runZonedGuarded(
      () async {
        await NetworkUtil().init();
        WidgetsFlutterBinding.ensureInitialized();
        await EasyLocalization.ensureInitialized();
        await LanguageStore().register();
        await RegionStore().register();
        const Color defaultStokeColor = Color(0x80000000);
        SmartDialog.config.custom = SmartConfigCustom(
          maskWidget: const ModalBarrier(
            dismissible: false,
            barrierSemanticsDismissible: false,
            color: defaultStokeColor,
          ),
        );
        // await Firebase.initializeApp(
        //   options: DefaultFirebaseOptions.currentPlatform,
        // );
        // await FirebasePerformance.instance
        //     .setPerformanceCollectionEnabled(true);
        DreameFlutterPluginOpenSetting().register();

        var supportedLocales = LanguageStore().supportLocales();

        if (kDebugMode && Platform.isAndroid) {
          // H5 调试用,审查页面元素, 线上不能带
          await InAppWebViewController.setWebContentsDebuggingEnabled(true);
        }

        runApp(ProviderScope(
          // observers: const [StateNotifierProviderObserver()],
          child: EasyLocalization(
              supportedLocales: supportedLocales,
              fallbackLocale: const Locale('en'),// 缺省语言为英文
              startLocale:
                  LanguageStore().getCurrentLanguage().toLanguageLocal(),
              path: 'assets/translations',
              saveLocale: false,
              useFallbackTranslations: true,
              child: MyApp(args: args)),
        ));
      },
      (error, stackTrace) {
        //没被我们catch的异常
        reportErrorAndLog(makeDetails(error, stackTrace));
      },
    );
  });
}

void _init(Function() callback) {
  callback();
}

class MyApp extends ConsumerStatefulWidget {
  final List<String> args;

  const MyApp({super.key, required this.args});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Object? initialExtra;

  @override
  void initState() {
    super.initState();
    debugPrint('----------- MyApp initState ------------------widget.args:${widget.args}');
    if (widget.args.isNotEmpty) {
      initWithExtra(widget.args.first);
    }
    BurialPointUtil().init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(schemeHandleNotifierProvider.notifier).init(widget.args);
      ref.read(pluginProvider.notifier).unzipLocalMall();
      ref.read(keyDefineProvider.notifier).init();
      ref.read(appDynamicResConfigProviderProvider.notifier).initData();
      ref.read(appDynamicResConfigProviderProvider.notifier).performPendingCleanup();
      // 更改状态栏
      immersionSystemBar();
    });
  }

  Future<void> immersionSystemBar() async {
    // 根据暗黑模式状态设置状态栏样式
    final themeMode = await ref.read(appThemeStateNotifierProvider.notifier).loadTheme();
    final style = ref.read(styleModelProvider);
    AppThemeManager().updateAppThemeMode(themeMode, systemNavigationBarColor: style.bgBlack);
  }

  void initWithExtra(String? extra) {
    try {
      if (extra == null || extra.isEmpty) {
        return;
      }
      if (!extra.contains('initialExtra')) {
        return;
      }
      debugPrint('----------- MyApp initState ------------------widget.args:error: $extra');
      Map<String, dynamic> extraMap = jsonDecode(extra);
      debugPrint('----------- MyApp initState ------------------widget.args:extraMap: $extraMap');
      if (extraMap.containsKey('initialExtra')) {
        initialExtra = extraMap['initialExtra'];
      }
    } catch (e) {
      LogUtils.e('initWithExtra___error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    LifeCycleManager().attach(ref);
    var style = ref.read(styleModelProvider);
    var resource = ref.read(resourceModelProvider);
    EasyRefresh.defaultHeaderBuilder = () {
      return CustomHeader(
          processedDuration: const Duration(milliseconds: 500),
          iconTheme: IconThemeData(color: style.click),
          succeededIcon: Image.asset(resource.getResource('ic_refresh_success')),
          textStyle: TextStyle(color: style.textSecond, fontSize: style.middleText));
    };
    EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
        pullIconBuilder: (context, state, animation) => const SizedBox.shrink(),
        showText: false,
        showMessage: false,
        noMoreIcon: const SizedBox.shrink());
    return MaterialApp.router(
      title: 'MOVAhome',
// showPerformanceOverlay: true,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // 自动适配系统语言，若不在支持列表则回退到 fallbackLocale
      builder: FlutterSmartDialog.init(
        loadingBuilder: (msg) {
          return ThemeWidget(builder: (context, style, resource) {
            return Container(
                width: 200,
                constraints: const BoxConstraints(minHeight: 100),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                    color: style.bgWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedRotationBox(
                      child: GradientCircularProgressIndicator(
                        stokeWidth: 5,
                        strokeCapRound: true,
                        colors: [
                          Color(0x00DDBCA1),
                          Color(0x60DDBCA1),
                          Color(0x80DDBCA1),
                          Color(0xFFDDBCA1),
                          Color(0xFFDDBCA1),
                        ],
                        radius: 20,
                        value: 1,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ));
          });
        },
        toastBuilder: (msg) {
          SemanticsService.announce(msg, ui.TextDirection.ltr);
          return CustomToast(msg);
        },
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1), boldText: false),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
      routerConfig: AppRoutes.initRouter(initialExtra: initialExtra),
    );
  }
}
