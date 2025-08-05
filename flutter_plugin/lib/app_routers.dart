import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_plugin/ui/page/help_center/wiget/video_player_page.dart';
import 'package:flutter_plugin/ui/page/home/home_page.dart';
import 'package:flutter_plugin/ui/page/theme/app_theme_set_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/pdf/pdf_viewer_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_plugin/model/device_share/mine_recent_user.dart';
import 'package:flutter_plugin/model/voice/ai_sound_model.dart';
import 'package:flutter_plugin/model/webview_request.dart';
import 'package:flutter_plugin/root_page.dart';
import 'package:flutter_plugin/ui/page/account/bind/bind_page/mobile_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/bind/check_code/mobile_bind_check_code_page.dart';
import 'package:flutter_plugin/ui/page/account/bind_email/mine_email_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/code/mobile_login_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/mobile_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/change/recover_change_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/inputcode/recover_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/code/social_signin_bind_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/code/social_sign_bind_email_code_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/send/social_sign_bind_email_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/mobile/social_signin_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/regionPicker/region_picker_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/email/signup_email_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/email_standby/email_signup_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/password/mobile_signup_password_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_menu_page.dart';
import 'package:flutter_plugin/ui/page/developer/developer_mode_page.dart';
import 'package:flutter_plugin/ui/page/developer/discuz_debug/discuz_debug_page.dart';
import 'package:flutter_plugin/ui/page/developer/gps_debug/gps_debug_page.dart';
import 'package:flutter_plugin/ui/page/developer/mall_debug/mall_debug_page.dart';
import 'package:flutter_plugin/ui/page/developer/warranty_debug/warranty_debug_page.dart';
import 'package:flutter_plugin/ui/page/help_center/center/help_center_page.dart';
import 'package:flutter_plugin/ui/page/help_center/help_question_search/help_question_search_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual/product_manual_page.dart';
import 'package:flutter_plugin/ui/page/help_center/manual_viewer/product_manual_viewer_page.dart';
import 'package:flutter_plugin/ui/page/help_center/model/app_faq.dart';
import 'package:flutter_plugin/ui/page/help_center/model/help_center_product.dart';
import 'package:flutter_plugin/ui/page/help_center/model/suggest_history_box.dart';
import 'package:flutter_plugin/ui/page/help_center/product_list/help_center_product_list_page.dart';
import 'package:flutter_plugin/ui/page/help_center/question_report/question_report_page.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest/product_suggest_page.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history/suggest_history_page.dart';
import 'package:flutter_plugin/ui/page/help_center/suggest_history_detail/suggest_history_detail_page.dart';
import 'package:flutter_plugin/ui/page/home/device_offline_tips_page.dart';
import 'package:flutter_plugin/ui/page/home/feature/network_diagnostics/network_diagnostics_page.dart';
import 'package:flutter_plugin/ui/page/language/language_picker_page.dart';
import 'package:flutter_plugin/ui/page/main/main_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/discuz_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/mall_page.dart';
import 'package:flutter_plugin/ui/page/mall/mall/web_page.dart';
import 'package:flutter_plugin/ui/page/mall/wechat/wechat_page.dart';
import 'package:flutter_plugin/ui/page/message/device/device_message_page.dart';
import 'package:flutter_plugin/ui/page/message/message_main_page.dart';
import 'package:flutter_plugin/ui/page/message/service/service_message_page.dart';
import 'package:flutter_plugin/ui/page/message/setting/message_setting_page.dart';
import 'package:flutter_plugin/ui/page/message/share/share_message_list_page.dart';
import 'package:flutter_plugin/ui/page/message/system/system_message_list_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/accepted/device_accepted_detail_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/device_share_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_add_contacts_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_contacts_detail_page.dart';
import 'package:flutter_plugin/ui/page/mine/device_share/sharing_contacts/device_sharing_search_list_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/custom_guide/custome_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/nearby_connect/nearby_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_connect/pair_connect_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/guidance/pair_mobile_hotspot_guidance_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/hotspot/pair_set_hotspot_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/pair_type_selection_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_dental_plaque/search_guide/pair_search_guide_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_code/pair_qr_code_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_qr_tips/pair_qr_tips_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/pair_solution/pair_solution_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/product_list/product_list_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/qr_scan/qr_scan_page.dart';
import 'package:flutter_plugin/ui/page/pair_network/router_password/router_password_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_page.dart';
import 'package:flutter_plugin/ui/page/qrscan/qr_scan_bussiness_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/about_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_page.dart';
import 'package:flutter_plugin/ui/page/settings/about/config/user_config_type.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/changeMail/change_mail_page.dart';
import 'package:flutter_plugin/ui/page/settings/changePhone/change_phone_setting_page.dart';
import 'package:flutter_plugin/ui/page/settings/changepassword/user_change_password_page.dart';
import 'package:flutter_plugin/ui/page/settings/common/common_settings_page.dart';
import 'package:flutter_plugin/ui/page/settings/logoff/user_logoff_page.dart';
import 'package:flutter_plugin/ui/page/settings/settingpassword/user_setting_password_page.dart';
import 'package:flutter_plugin/ui/page/settings/settings_page.dart';
import 'package:flutter_plugin/ui/page/settings/thirdAccount/user_third_account_page.dart';
import 'package:flutter_plugin/ui/page/settings/unbindMail/unbind_mail_page.dart';
import 'package:flutter_plugin/ui/page/settings/unbindPhone/unbind_phone_page.dart';
import 'package:flutter_plugin/ui/page/settings/usermail/user_mail_page.dart';
import 'package:flutter_plugin/ui/page/settings/username/user_name_page.dart';
import 'package:flutter_plugin/ui/page/settings/userphone/user_phone_page.dart';
import 'package:flutter_plugin/ui/page/splash_page.dart';
import 'package:flutter_plugin/ui/page/voice/alexa/alexa_auth_page.dart';
import 'package:flutter_plugin/ui/page/webview/webview_page.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/page_route_nav_observer.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';

import 'app_routers_mixin.dart';
import 'ui/page/voice/detail/voice_detail_page.dart';
import 'ui/page/voice/voice_control_page.dart';

class AppRoutes with AppRoutersMinin {
  static final AppRoutes _singleton = AppRoutes._internal();

  factory AppRoutes() {
    return _singleton;
  }

  AppRoutes._internal();

  /// 清理栈，跳转到登录页/首页 在rootpage中有判断，此处不需要判断
  static Future<void> resetStacks() async {
    LogUtils.i(
        '----------- gotoLogin ----------- $getNavigatorKey()  ${getNavigatorKey().hashCode}');
    try {
      /// 为了解决登录成功，可能存在loading不消失的问题
      SmartDialog.dismiss(status: SmartStatus.loading);
    } catch (e) {
      LogUtils.e('--------resetStacks SmartDialog.dismiss ---------$e');
    }
    if (getNavigatorKey()?.currentContext != null &&
        getNavigatorKey()?.currentContext?.mounted == true) {
      try {
        Navigator.popUntil(getNavigatorKey()!.currentContext!, (route) {
          LogUtils.d(
              '--------resetStacks---------${route.settings.name}  ${route.isFirst}');
          return route.isFirst;
        });
      } catch (e) {
        LogUtils.i('--------resetStacks---------$e');
      }
    }
  }

  /// 判断当前页面是否是在登录/注册页
  static bool isLoginOrSignOn() {
    List<Page<dynamic>> list =
        getNavigatorKey()?.currentState?.widget.pages ?? List.empty();
    if (list.isNotEmpty) {
      Page<dynamic> page = list.first;
      return MobileLoginPage.routePath == page.name ||
          MobileLoginCodePage.routePath == page.name ||
          PasswordLoginPage.routePath == page.name ||
          MobileSignUpPage.routePath == page.name ||
          EmailSignUpPage.routePath == page.name;
    }
    return false;
  }

  static GlobalKey<NavigatorState>? _navigatorKey;

  static GlobalKey<NavigatorState>? getNavigatorKey({bool force = false}) {
    if (force) {
      _navigatorKey = GlobalKey<NavigatorState>();
    } else {
      _navigatorKey ??= GlobalKey<NavigatorState>();
    }
    return _navigatorKey;
  }

  static GoRouter initRouter({
    String initRoute = '',
    Object? initialExtra,
  }) {
    var navigatorKey = getNavigatorKey();
    LogUtils.i(
        '----------- initRouter ----------- $navigatorKey  ${navigatorKey.hashCode}');
    return GoRouter(
      observers: [
        FlutterSmartDialog.observer,
        defaultLifecycleObserver,
        PageRouteNavObserver(),
      ],
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: initRoute,
      initialExtra: initialExtra,
      routes: [
        GoRoute(
          path: RootPage.routePath,
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          path: SplashPage.routePath,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: PrivacyPage.routePath,
          builder: (context, state) => const PrivacyPage(),
        ),
        GoRoute(
          path: MobileLoginPage.routePath,
          builder: (context, state) => const MobileLoginPage(),
        ),
        GoRoute(
          name: MobileLoginCodePage.routePath,
          path: MobileLoginCodePage.routePath,
          builder: (context, state) => const MobileLoginCodePage(),
        ),
        GoRoute(
          path: PasswordLoginPage.routePath,
          builder: (context, state) => const PasswordLoginPage(),
        ),
        GoRoute(
          path: RegionPickerPage.routePath,
          builder: (context, state) => const RegionPickerPage(),
        ),
        GoRoute(
          path: MobileRecoverPage.routePath,
          builder: (context, state) => const MobileRecoverPage(),
        ),
        GoRoute(
          path: MailRecoverPage.routePath,
          builder: (context, state) => const MailRecoverPage(),
        ),
        GoRoute(
          path: RecoverCodePage.routePath,
          builder: (context, state) => const RecoverCodePage(),
        ),
        GoRoute(
          path: RecoverChangePage.routePath,
          builder: (context, state) => const RecoverChangePage(),
        ),
        GoRoute(
          path: SocialSignInBindPage.routePath,
          builder: (context, state) => const SocialSignInBindPage(),
        ),
        GoRoute(
          path: SocialSignInBindCodePage.routePath,
          builder: (context, state) => const SocialSignInBindCodePage(),
        ),
        GoRoute(
          path: MobileSignUpPage.routePath,
          builder: (context, state) => const MobileSignUpPage(),
        ),
        GoRoute(
          path: MobileSignUpPasswordPage.routePath,
          builder: (context, state) => const MobileSignUpPasswordPage(),
        ),
        GoRoute(
          path: EmailSignUpPage.routePath,
          builder: (context, state) => const EmailSignUpPage(),
        ),
        GoRoute(
          path: MainPage.routePath,
          builder: (context, state) => MainPage(),
        ),
        GoRoute(
          path: HomePage.routePath,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: WebviewPage.routePath,
          builder: (context, state) => const WebviewPage(),
        ),
        GoRoute(
          path: MobileBindPage.routePath,
          builder: (context, state) => const MobileBindPage(),
        ),
        GoRoute(
          path: MobileBindCheckCodePage.routePath,
          builder: (context, state) => const MobileBindCheckCodePage(),
        ),
        GoRoute(
          path: MallPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            String? path;
            if (obj is String?) {
              path = obj;
            }
            return MallPage.parse(path ?? '');
          },
        ),
        GoRoute(
          path: DisCuzPage.routePath,
          pageBuilder: ((context, state) {
            Object? obj = state.extra;
            String? path;
            if (obj is String?) {
              path = obj;
            }
            return CustomTransitionPage(
              child: DisCuzPage.parse(path ?? ''),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                final slideTransition = SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );

                if (Platform.isIOS) {
                  return CupertinoPageTransition(
                    primaryRouteAnimation: animation,
                    secondaryRouteAnimation: secondaryAnimation,
                    linearTransition: true,
                    child: child,
                  );
                }
                return slideTransition;
              },
            );
          }),
        ),
        GoRoute(
          path: WebPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            WebViewRequest? request;
            if (obj is WebViewRequest?) {
              request = obj;
            }
            return WebPage(request: request);
          },
        ),
        GoRoute(
          path: WeChatPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            WebViewRequest? request;
            if (obj is WebViewRequest?) {
              request = obj;
            }
            return WeChatPage(
              request: request,
            );
          },
        ),
        GoRoute(
          path: DeviceOfflineTipsPage.routePath,
          builder: (context, state) => const DeviceOfflineTipsPage(),
        ),
        GoRoute(
          path: LanguagePickerPage.routePath,
          builder: (context, state) {
            return const LanguagePickerPage();
          },
        ),
        GoRoute(
          path: AppThemeSetPage.routePath,
          builder: (context, state) {
            return const AppThemeSetPage();
          },
        ),
        GoRoute(
          path: AccountSettingPage.routePath,
          builder: (context, state) => const AccountSettingPage(),
        ),
        GoRoute(
          path: SettingsPage.routePath,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: CommonSettingsPage.routePath,
          builder: (context, state) => const CommonSettingsPage(),
        ),
        GoRoute(
          path: AboutPage.routePath,
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: UserConfigPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            UserConfigType configType = UserConfigType.uxPlan;
            if (obj != null && obj is UserConfigType) {
              configType = obj;
            }
            return UserConfigPage(userConfigType: configType);
          },
        ),
        GoRoute(
          path: MessageMainPage.routePath,
          builder: (context, state) => const MessageMainPage(),
        ),
        GoRoute(
          path: ShareMessageListPage.routePath,
          builder: (context, state) => const ShareMessageListPage(),
        ),
        GoRoute(
          path: SystemMessageListPage.routePath,
          builder: (context, state) => const SystemMessageListPage(),
        ),
        GoRoute(
          path: DeviceMessagePage.routePath,
          builder: (context, state) => const DeviceMessagePage(),
        ),
        GoRoute(
          path: ServiceMessagePage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            if (obj != null && obj is CategoryUnread?) {
              CategoryUnread? categoryUnread =
                  GoRouterState.of(context).extra != null
                      ? GoRouterState.of(context).extra as CategoryUnread
                      : null;
              return ServiceMessagePage(
                  initialIndex: categoryUnread?.initialIndex ?? 0);
            }
            return ServiceMessagePage();
          },
        ),
        GoRoute(
          path: MessageSettingPage.routePath,
          builder: (context, state) => const MessageSettingPage(),
        ),
        GoRoute(
          path: MineEmailBindPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            String? title;
            if (obj is String?) {
              title = obj;
            }
            return MineEmailBindPage(
              centerTitle: title ?? '',
            );
          },
        ),
        GoRoute(
          path: DeveloperModePage.routePath,
          builder: (context, state) => const DeveloperModePage(),
        ),
        GoRoute(
          path: DeveloperMenuPage.routePath,
          builder: (context, state) => const DeveloperMenuPage(),
        ),
        GoRoute(
          path: UserNameSettingPage.routePath,
          builder: (context, state) => const UserNameSettingPage(),
        ),
        GoRoute(
          path: UserSettingPasswordPage.routePath,
          builder: (context, state) => const UserSettingPasswordPage(),
        ),
        GoRoute(
          path: UserChangePasswordPage.routePath,
          builder: (context, state) => const UserChangePasswordPage(),
        ),
        GoRoute(
          path: UserPhoneSettingPage.routePath,
          builder: (context, state) => const UserPhoneSettingPage(),
        ),
        GoRoute(
          path: UserMailSettingPage.routePath,
          builder: (context, state) => const UserMailSettingPage(),
        ),
        GoRoute(
          path: UserLogoffPage.routePath,
          builder: (context, state) => const UserLogoffPage(),
        ),
        GoRoute(
          path: UserThirdAccountSettingPage.routePath,
          builder: (context, state) => const UserThirdAccountSettingPage(),
        ),
        GoRoute(
          path: UnbindPhoneSettingPage.routePath,
          builder: (context, state) => const UnbindPhoneSettingPage(),
        ),
        GoRoute(
          path: ChangePhonePage.routePath,
          builder: (context, state) => const ChangePhonePage(),
        ),
        GoRoute(
          path: ChangeMailSettingPage.routePath,
          builder: (context, state) => const ChangeMailSettingPage(),
        ),
        GoRoute(
          path: UnbindMailSettingPage.routePath,
          builder: (context, state) => const UnbindMailSettingPage(),
        ),
        GoRoute(
          path: SocialSignBindEmailPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            String? authType;
            dynamic token;
            bool socialNoEmail = false;
            if (obj is Map<String, dynamic>) {
              authType = obj['authType'];
              token = obj['token'];
              socialNoEmail = obj['socialNoEmail'] ?? false;
            }
            return SocialSignBindEmailPage(
              authType: authType ?? '',
              token: token ?? '',
              socialNoEmail: socialNoEmail,
            );
          },
        ),
        GoRoute(
          path: SocialSignBindEmailCodePage.routePath,
          builder: (context, state) => const SocialSignBindEmailCodePage(),
        ),
        GoRoute(
          path: SignUpEmailPage.routePath,
          builder: (context, state) => const SignUpEmailPage(),
        ),
        GoRoute(
          path: ProductListPage.routePath,
          builder: (context, state) {
            return const ProductListPage();
          },
        ),
        GoRoute(
          path: PairTypeSelectionPage.routePath,
          builder: (context, state) => const PairTypeSelectionPage(),
        ),
        GoRoute(
          path: PairMobileHotspotGuidancePage.routePath,
          builder: (context, state) => const PairMobileHotspotGuidancePage(),
        ),
        GoRoute(
          path: PairSetHotspotPage.routePath,
          builder: (context, state) => const PairSetHotspotPage(),
        ),
        GoRoute(
          path: PairSearchGuidePage.routePath,
          builder: (context, state) => const PairSearchGuidePage(),
        ),
        GoRoute(
          path: QrScanPage.routePath,
          builder: (context, state) => const QrScanPage(),
        ),
        GoRoute(
          path: RouterPasswordPage.routePath,
          builder: (context, state) => const RouterPasswordPage(),
        ),
        GoRoute(
          path: CustomGuidePage.routePath,
          builder: (context, state) => const CustomGuidePage(),
        ),
        GoRoute(
          path: NearbyConnectPage.routePath,
          builder: (context, state) => const NearbyConnectPage(),
        ),
        GoRoute(
          path: PairConnectPage.routePath,
          builder: (context, state) => const PairConnectPage(),
        ),
        GoRoute(
          path: PairSolutionPage.routePath,
          builder: (context, state) => const PairSolutionPage(),
        ),
        GoRoute(
          path: PairQrCodePage.routePath,
          builder: (context, state) => const PairQrCodePage(),
        ),
        GoRoute(
          path: NetworkDiagnosticsPage.routePath,
          builder: (context, state) => const NetworkDiagnosticsPage(),
        ),
        GoRoute(
          path: HelpCenterPage.routePath,
          builder: (context, state) => const HelpCenterPage(),
        ),
        GoRoute(
          path: ProductManualPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            HelpCenterProduct product;
            if (obj is Map<String, dynamic>) {
              product = HelpCenterProduct.fromJson(obj);
            } else if (obj is HelpCenterProduct) {
              product = obj;
            } else {
              return Container();
            }
            return ProductManualPage(product: product);
          },
        ),
        GoRoute(
          path: QuestionReportPage.routePath,
          builder: (context, state) => const QuestionReportPage(),
        ),
        GoRoute(
          path: ProductSuggestPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            String? did;
            if (obj is String) {
              did = obj;
            }
            return ProductSuggestPage(did: did);
          },
        ),
        GoRoute(
          path: HelpQuestionSearchPage.routePath,
          builder: (context, state) {
            List<AppFaq>? faqs;
            Object? obj = state.extra;
            if (obj is List<AppFaq>?) {
              faqs = obj;
            }
            return HelpQuestionSearchPage(faqs: faqs);
          },
        ),
        GoRoute(
          path: ProductManualViewerPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            if (obj is HelpCenterProduct) {
              return ProductManualViewerPage(product: obj);
            }
            return Container();
          },
        ),
        GoRoute(
          path: HelpCenterProductListPage.routePath,
          builder: (context, state) {
            return const HelpCenterProductListPage();
          },
        ),
        GoRoute(
          path: DeviceSharePage.routePath,
          builder: (context, state) {
            return DeviceSharePage(
              initialIndex: 0,
            );
          },
        ),
        GoRoute(
          path: DeviceSharingAddContactsPage.routePath,
          builder: (context, state) {
            return const DeviceSharingAddContactsPage();
          },
        ),
        GoRoute(
          path: DeviceSharingSearchListPage.routePath,
          builder: (context, state) {
            return const DeviceSharingSearchListPage();
          },
        ),
        GoRoute(
          path: DeviceSharingContactsDetailPage.routePath,
          builder: (context, state) {
            return const DeviceSharingContactsDetailPage();
          },
        ),
        GoRoute(
          path: DeviceAcceptedDetailPage.routePath,
          builder: (context, state) {
            return const DeviceAcceptedDetailPage();
          },
        ),
        GoRoute(
          path: SuggestHistoryPage.routePath,
          builder: (context, state) => const SuggestHistoryPage(),
        ),
        GoRoute(
          path: SuggestHistoryDetailPage.routePath,
          builder: (context, state) {
            Object? obj = state.extra;
            SuggestHistoryItem? item;
            if (obj is SuggestHistoryItem) {
              item = obj;
            }
            return SuggestHistoryDetailPage(history: item!);
          },
        ),
        GoRoute(
          path: MallDebugPage.routePath,
          builder: (context, state) => MallDebugPage(),
        ),
        GoRoute(
          path: DiscuzDebugPage.routePath,
          builder: (context, state) => DiscuzDebugPage(),
        ),
        GoRoute(
          path: GPSDebugPage.routePath,
          builder: (context, state) => const GPSDebugPage(),
        ),
        GoRoute(
          path: WarrantyDebugPage.routePath,
          builder: (context, state) => const WarrantyDebugPage(),
        ),
        GoRoute(
          path: QRScanBusinessPage.routePath,
          builder: (context, state) => const QRScanBusinessPage(),
        ),
        GoRoute(
          path: PairQrTipsPage.routePath,
          builder: (context, state) => const PairQrTipsPage(),
        ),
        GoRoute(
          path: VoiceControlPage.routePath,
          builder: (context, state) => const VoiceControlPage(),
        ),
        GoRoute(
          path: VoiceDetailPage.routePath,
          builder: (context, state) =>
              VoiceDetailPage(soundModel: state.extra as AiSoundModel),
        ),
        GoRoute(
          path: AlexaAuthPage.routePath,
          builder: (context, state) => AlexaAuthPage(),
        ),
        GoRoute(
          path: PdfViewerPage.routePath,
          builder: (context, state) {
            Pair<String,String>? p = state.extra as Pair<String, String>;
            String title = p.first??'';
            String url = p.second??'';
          return PdfViewerPage(title: title, url: url);

          },
        ),
        GoRoute(
          path: VideoPlayerPage.routePath,
          builder: (context, state) {
            String url = state.extra as String;
            return VideoPlayerPage(url: url);
          },
        ),
      ],
    );
  }
}
