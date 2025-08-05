import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/bridge/message_channel.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/bind/bind_page/mobile_bind_page.dart';
import 'package:flutter_plugin/ui/page/home/call/video_call_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/home_state_notifier.dart';
import 'package:flutter_plugin/ui/page/home/plugin/plugin_provider.dart';
import 'package:flutter_plugin/ui/page/main/main_repository.dart';
import 'package:flutter_plugin/ui/page/main/main_state_notifier.dart';
import 'package:flutter_plugin/ui/page/main/scheme/scheme_state.dart';
import 'package:flutter_plugin/ui/page/main/tab_item.dart';
import 'package:flutter_plugin/ui/page/mall/mall/discuz_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/voice/alexa/alexa_auth_page.dart';
import 'package:flutter_plugin/utils/constant.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/web_launch_fromroute_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'scheme_type.dart';

part 'scheme_handle_notifier.g.dart';

@Riverpod(keepAlive: true)
class SchemeHandleNotifier extends _$SchemeHandleNotifier
    with WebLaunchFromRoute {
  static String type = 'schemeType';
  static String ext = 'ext';

  @override
  SchemeState build() {
    return SchemeState();
  }

  /// 冷启动设置数据
  void init(List<String> args) {
    if (args.isNotEmpty) {
      Map<String, dynamic> argsMap = jsonDecode(args[0]);
      LogUtils.i(
          '[Scheme] SchemeHandleNotifier init argsMap: $argsMap, 冷启动设置数据');
      final schemeType = argsMap[type] as String? ?? '';
      if (schemeType.isNotEmpty) {
        updateSchemeData(argsMap[type], argsMap[ext], fromColdBoot: true);
      }
    }
  }

  /// 分发scheme事件
  void dispatchSchemeEvent() {
    String schemeType = state.schemeType;
    String ext = state.ext;
    LogUtils.d(
        'SchemeHandleNotifier dispatchSchemeEvent type: $schemeType, extra: $ext');
    if (schemeType.isEmpty || ext.isEmpty) return;
    try {
      Map<String, dynamic> extMap = jsonDecode(ext);
      handleSchemeJump(SchemeType(schemeType), extMap);
    } catch (e) {
      LogUtils.e('handleSchemeEvent error: $e');
    }
  }

  /// App已打开
  void updateSchemeData(String schemeType, String ext,
      {bool fromColdBoot = false}) {
    LogUtils.i(
        '[Scheme] SchemeHandleNotifier updateSchemeData schemeType: $schemeType, ext: $ext, fromColdBoot: $fromColdBoot');
    state = state.copyWith(
        schemeType: schemeType, ext: ext, fromColdBoot: fromColdBoot);
  }

  Future<void> handleSchemeEvent() async {
    String schemeType = state.schemeType;
    String ext = state.ext;
    LogUtils.i(
        '[Scheme] SchemeHandleNotifier handleSchemeEvent fromColdBoot: ${state.fromColdBoot} type: $schemeType, extra: $ext');
    if (schemeType.isEmpty || ext.isEmpty) return;
    try {
      Map<String, dynamic> extMap = jsonDecode(ext);
      await handleSchemeJump(SchemeType(schemeType), extMap);
    } catch (e) {
      LogUtils.e('[Scheme] SchemeHandleNotifier handleSchemeEvent error: $e');
    }
  }

  /// 处理所有的 scheme和广告 跳转事件
  /// 包括开屏广告和NFC的跳转
  Future<void> handleSchemeJump(
      SchemeType schemeType, Map<String, dynamic> extMap,
      {String category = ''}) async {
    LogUtils.i(
        '[Scheme] SchemeHandleNotifier handleSchemeJump schemeType: ${schemeType.name}, extMap: $extMap, category: $category');
    if (schemeType.isDeviceEvent()) {
      LogUtils.i('[Scheme] : ${schemeType.isDeviceEvent()}');
      if (ref
          .read(mainStateNotifierProvider.notifier)
          .haveTargetTab(TabItemType.device)) {
        // 存在Device TAB,切到Device TAB
        ref
            .read(mainStateNotifierProvider.notifier)
            .changeTab(TabItemType.device);
        // 如果设备页未数据加载过,不处理,等给设备页数据加载完成后会自动处理
        if (!ref.read(homeStateNotifierProvider).firstLoad) {
          await _handleSchemeJumpDevice(schemeType, extMap);
        } else {
          LogUtils.i('[Scheme] waiting devicelist');
        }
      } else {
        await _handleSchemeJumpDevice(schemeType, extMap);
      }
    } else {
      await _handleSchemeJumpHome(schemeType, extMap, category: category);
    }
    LogUtils.i(
        '[Scheme] SchemeHandleNotifier handleSchemeJump schemeType: ${schemeType.name}, extMap: $extMap, category: $category ----- end');
  }

  /// 处理App首页跳转
  Future<void> _handleSchemeJumpHome(
      SchemeType schemeType, Map<String, dynamic> extMap,
      {String category = ''}) async {
    LogUtils.i('[Scheme] _handleSchemeJumpHome  schemeType: $schemeType');
    switch (schemeType) {
      case SchemeType.web:
        LogModule().eventReport(6, 12, int1: 0, int2: 1);
        String url = extMap['url'] as String;
        url = await fixUrlFromLaunchUrl(url: url);
        state = state.copyWith(
            uiEvent: PushEvent(
          path: WebPage.routePath,
          extra: WebViewRequest(uri: WebUri(url)),
        ));
        break;
      case SchemeType.webExternal:
        LogModule().eventReport(6, 12, int1: 0, int2: 2);
        String url = extMap['url'] as String;
        url = await fixUrlFromLaunchUrl(url: url);
        state = state.copyWith(uiEvent: SchemeEvent(schemeType, ext: url));
        break;
      case SchemeType.mall:
        LogModule().eventReport(6, 12, int1: 0, int2: 3);
        if (RegionStore().isChinaServer()) {
          if (category == 'social_msg') {
            ref
                .read(mainStateNotifierProvider.notifier)
                .setMallPath(Constant.mallExploreTab3);
          }
          final uiEvent = await _handleChinaMallJump(extMap);
          state = state.copyWith(uiEvent: uiEvent);
          state = state.copyWith(
              uiEvent: SchemeEvent(SchemeType.homeTab, ext: TabItemType.mall));
        } else {
          String url = extMap['url'] as String? ?? '';
          state = state.copyWith(
              uiEvent: SchemeEvent(SchemeType.overseasMall, ext: url));
        }
        break;
      case SchemeType.member:
      case SchemeType.vip:
        LogModule().eventReport(6, 12, int1: 0, int2: 8);
        final uiEvent = await _handleChinaMallJump(extMap);
        state = state.copyWith(uiEvent: uiEvent);
        break;
      case SchemeType.wxApplet:
        LogModule().eventReport(6, 12, int1: 0, int2: 5);
        String id = extMap['id'] as String;
        String path = extMap['path'] as String? ?? '';
        state = state.copyWith(
            uiEvent: SchemeEvent(schemeType, ext: {'id': id, 'path': path}));
        break;
      case SchemeType.app:
        LogModule().eventReport(6, 12, int1: 0, int2: 6);
        String page = extMap['page'] as String;
        state = state.copyWith(uiEvent: SchemeEvent(schemeType, ext: page));
        break;
      case SchemeType.homeTab:
        LogModule().eventReport(6, 12, int1: 0, int2: 9);
        String type = extMap['type'] as String? ?? '';
        TabItemType tabType = TabItemType.device;
        if (type.isNotEmpty) {
          LogUtils.i('[Scheme] _handleSchemeJumpHome  type: $type');
          switch (type) {
            case 'device':
              tabType = TabItemType.device;
              break;
            case 'explore':
              tabType = TabItemType.explore;
              break;
            case 'mall':
              tabType = TabItemType.mall;
              break;
            case 'overseasMall':
              tabType = TabItemType.overseasMall;
              break;
            case 'mine':
            case 'overseaMine':
              tabType = TabItemType.mine;
              break;
            default:
              break;
          }
        }
        state = state.copyWith(uiEvent: SchemeEvent(schemeType, ext: tabType));
        break;
      case SchemeType.appLogin:
        LogModule().eventReport(6, 12, int1: 0, int2: 10);
        String key = extMap['key'] as String? ?? '';
        MessageChannel().checkAppLogin(key);
        break;
      case SchemeType.alexaAuth:
        LogModule().eventReport(6, 12, int1: 0, int2: 7);
        // 跳转到alexa授权页面, 如果登录了,则跳转到alexa授权页面,没登录则跳转到登录页面,登录成功后再跳转
        await AppRoutes().push(AlexaAuthPage.routePath, extra: extMap);
        break;
      case SchemeType.community:
        LogModule().eventReport(6, 12, int1: 0, int2: 11);
        await _pushToCommunity(extMap);
        break;
      case SchemeType.channel:
        String rawString = extMap['rawString'] as String? ?? '';
        if (rawString.isNotEmpty) {
          _reportChannelData(rawString);
        }
        break;
      default:
        debugPrint('handleSchemeEvent default: $schemeType');
        break;
    }
    state = SchemeState();
    LogUtils.i(
        '[Scheme] SchemeHandleNotifier _handleSchemeJumpDevice state: ${state.schemeType}, ext: ${state.ext}');
  }

  /// 处理设备页面跳转
  Future<void> _handleSchemeJumpDevice(
    SchemeType schemeType,
    Map<String, dynamic> extMap,
  ) async {
    // 冷启动，deviceList 还未加载完成，直接返回。MainPage的initData里有800毫秒再次执行。
    if (ref.read(homeStateNotifierProvider).firstLoad) {
      return;
    }
    switch (schemeType) {
      case SchemeType.device:
        LogModule().eventReport(6, 12, int1: 0, int2: 4);
        String did = (extMap['did']).toString();
        String model = extMap['model'] as String? ?? '';
        Map<String, dynamic> extraMap =
            extMap['extra'] as Map<String, dynamic>? ?? {};
        if (extraMap.isEmpty) return;
        String type = extraMap['type'] as String;
        final source = extraMap['source'] as Map<String, dynamic>? ?? {};
        if (type == 'call') {
          await ref
              .read(videoCallStateNotifierProvider.notifier)
              .showVideoCall(did, fromPush: true);
        } else {
          if (Platform.isIOS &&
              ref.read(homeStateNotifierProvider).deviceList.isEmpty) {
            // fix iOS 冷启动时序问题
            return;
          }
          if (type == 'tab') {
            ref
                .read(homeStateNotifierProvider.notifier)
                .jumpToDeviceTab(did, model);
          } else if (type == 'fastCommand') {
            ref
                .read(homeStateNotifierProvider.notifier)
                .jumpToDeviceTab(did, model);
          } else {
            // plugin、video
            String sourceStr = '';
            if (source.isNotEmpty) {
              sourceStr = json.encode(source);
            }
            LogUtils.i('[Scheme] _handleSchemeJumpDevice source: $sourceStr');
            await ref
                .read(homeStateNotifierProvider.notifier)
                .openPluginByDid(did, model, type, source: sourceStr);
          }
        }
        break;
      default:
        debugPrint('handleSchemeJumpDevice default: $schemeType');
        break;
    }
    state = SchemeState();
    LogUtils.i(
        '[Scheme] SchemeHandleNotifier _handleSchemeJumpDevice state: ${state.schemeType}, ext: ${state.ext}');
  }

  /// 处理国内商城跳转
  Future<CommonUIEvent> _handleChinaMallJump(
      Map<String, dynamic> extMap) async {
    bool showBindAlert =
        await ref.read(mainStateNotifierProvider.notifier).checkBindAlert();
    if (showBindAlert) {
      var alertEvent = AlertEvent(
        title: 'set_phone'.tr(),
        content: 'bind_signin_phone_code'.tr(),
        cancelContent: 'text_bind_skip'.tr(),
        confirmContent: 'Text_3rdPartyBundle_CreateDreameBundled_Now'.tr(),
        confirmCallback: () => state = state.copyWith(
          uiEvent: PushEvent(
            path: MobileBindPage.routePath,
            func: RouterFunc.push,
          ),
        ),
      );
      return alertEvent;
    }
    await Future.any([
      ref.read(pluginProvider.notifier).updateMallForce(),
      Future.delayed(const Duration(milliseconds: 5000))
    ]);
    String url = extMap['url'] as String;
    return PushEvent(path: MallPage.routePath, extra: url);
  }

  /// 上报渠道数据
  void _reportChannelData(String value) {
    ref.read(mainStateNotifierProvider.notifier).reportChannelData(value);
  }

  // 跳转社区
  Future<void> _pushToCommunity(Map<String, dynamic> extMap) async {
    String url = extMap['url'] as String;
    state = state.copyWith(
        uiEvent: PushEvent(path: DisCuzPage.routePath, extra: url));
  }
}
