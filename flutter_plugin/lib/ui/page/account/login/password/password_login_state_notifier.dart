// ignore_for_file: avoid_public_notifier_properties

import 'dart:ffi';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/bridge/local_module.dart';
import 'package:flutter_plugin/common/bridge/local_storage.dart';
import 'package:flutter_plugin/common/bridge/log_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/life_cycle_manager.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/model/account/sendcode/send_code_model.dart';
import 'package:flutter_plugin/model/region_item.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/page/account/login/mobile/social_auth_usecase.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_page.dart';
import 'package:flutter_plugin/ui/page/account/login/password/password_login_uistate.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mail/mail_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/recover/mobile/mobile_recover_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/email/send/social_sign_bind_email_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/mobile/social_signin_bind_page.dart';
import 'package:flutter_plugin/ui/page/account/login/social_signin/usecase/social_signin_bind_usecase.dart';
import 'package:flutter_plugin/ui/page/account/signup/mobile/mobile_signup_page.dart';
import 'package:flutter_plugin/ui/page/privacy/privacy_policy_state_notifier.dart';
import 'package:flutter_plugin/ui/widget/account/region_select_menu/region_select_menu_controller.dart';
import 'package:flutter_plugin/utils/language_store.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_plugin/utils/rule_verification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_login_state_notifier.g.dart';

@riverpod
class PasswordLoginStateNotifier extends _$PasswordLoginStateNotifier {
  static const _kSecAttrAccount = 'kSecAttrAccount';
  static const _kSecAttrPassword = 'kSecAttrPassword';

  late SocialAuthUsecase _socialAuthUsecase;
  final _storage = const FlutterSecureStorage();
  String _account = '';
  String _password = '';
  final bool isChinese = LanguageStore().getCurrentLanguage().isChinese();

  @override
  PasswordLoginUiState build() {
    return init();
  }

  PasswordLoginUiState init() {
    _socialAuthUsecase =
        SocialAuthUsecase(ref.watch(accountRepositoryProvider));

    RegionItem? currentItem =
        ref.read(regionSelectMenuControllerProvider)?.currentRegion;
    PasswordLoginUiState st = PasswordLoginUiState(currentItem: currentItem);
    ref.listen(regionSelectMenuControllerProvider, (previous, next) async {
      RegionItem? item = next?.currentRegion;
      if (item == null) return;
      await updateRegion(item);
    });

    return st;
  }

  Future<void> _addNewItem(String key, String value) async {
    try {
      await _storage.write(
          key: key, value: value, aOptions: _getAndroidOptions());
    } catch (e) {
      LogUtils.d('------_addNewItem --------$e');
    }
  }

  Future<void> _saveAccountAndPassword(String account, String password) async {
    await _addNewItem(_kSecAttrAccount, account);
    await _addNewItem(_kSecAttrPassword, password);
  }

  Future<void> onLoad({Map<String, dynamic>? extra = null}) async {
    /// 有默认参数传进来
    if (extra != null && extra.containsKey(param_account)) {
      _account = extra[param_account] ?? '';
      _password = extra[param_pwd] ?? '';
      state = state.copyWith(
        initAccount: _account,
        initPassword: _password,
        prepared: true,
      );
    } else {
      String? account = await _storage.read(
          key: _kSecAttrAccount, aOptions: _getAndroidOptions());
      String? password = await _storage.read(
          key: _kSecAttrPassword, aOptions: _getAndroidOptions());
      // 兼容之前版本，后续版本看情况可以去掉
      account ??= await LocalStorage()
          .getString('mobile_login_account', fileName: 'saveNotLogin');

      _account = account ?? '';
      _password = password ?? '';
      state = state.copyWith(
        initAccount: _account,
        initPassword: _password,
        prepared: true,
      );
    }
    checkEnbale();
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  void pushToRecover(BuildContext context) {
    // MobileRecoverPage
    // GoRouter.of(context).push(MobileRecoverPage.routePath);

    _goToRecover();
  }

  void passwordChanged(String text) {
    _password = text;
    checkEnbale();
  }

  void accountChanged(String text) {
    _account = text;
    checkEnbale();
  }

  void agreementStatusUpdate(bool agreed) {
    state = state.copyWith(agreed: agreed);
    checkEnbale();
  }

  void checkEnbale() {
    bool vial = _account.isNotEmpty && _password.isNotEmpty && state.agreed;
    state = state.copyWith(submitEnable: vial);
  }

  Future<void> updateRegion(RegionItem item) async {
    state = state.copyWith(
      currentItem: item,
    );
  }

  /// 三方登录
  Future<bool> socialSignIn(String authType, dynamic token) async {
    try {
      showLoading(true);

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      var event = await _socialAuthUsecase.socialSignIn(
        authType: authType,
        token: token,
        emailCheck: 1,
      );
      showLoading(false);
      if (event is SuccessEvent) {
        await LifeCycleManager().gotoMainPage();
        showToast('login_success'.tr());
        return true;
      } else if (event is ToastEvent) {
        showToast(event.text);
      } else if (event is ActionEvent) {
        if (event.action is ActionSocialAccountBind) {
          //原来的也是国内的逻辑，报10017
          RegionItem? regionItem = state.currentItem;
          if (regionItem == null) return false;

          if (regionItem.countryCode.toLowerCase() == 'cn') {
            var action = event.action as ActionSocialAccountBind;
            var model = SocialCodeModel(
                currentPhone: regionItem,
                currentRegion: regionItem,
                oauthSource: action.source ?? '',
                uuid: action.uuid ?? '');
            action.model = model;
            event.action = action;

            _goToAcctionBind(model);
            // toRegisterApple(model);
          } else {
            state = state.copyWith(
              event: PushEvent(
                path: SocialSignBindEmailPage.routePath,
                extra: {
                  'authType': authType,
                  'token': token,
                },
              ),
            );
          }
        } else if (event.action is ActionSocialAccountBindT) {
          //跳转到新绑定页面，这一版新加的错误逻辑，social user no email，表示本身没有邮箱，且第三方授权获取不到邮箱，按照目前的流程图，都是跳转到新绑定页面,
          // 不能有跳过按钮
          // var action = event.action as ActionSocialAccountBindT;
          state = state.copyWith(
              event: PushEvent(path: SocialSignBindEmailPage.routePath, extra: {
            'authType': authType,
            'token': token,
            "socialNoEmail": true,
          }));
        } else if (event.action is ActionSocialAccountBindRepeat) {
          //跳转到新绑定页面，这一版新加的错误逻辑，email has bind other account，按照目前的流程图，只有已经存在的账号，原本账号无邮箱，但是第三方账号有邮箱，且该邮箱已经绑定另外一个账号；
          //跳转到新绑定页面
          // var action = event.action as ActionSocialAccountBindRepeat;
          state = state.copyWith(
            event: PushEvent(
              path: SocialSignBindEmailPage.routePath,
              extra: {
                'authType': authType,
                'token': token,
              },
            ),
          );
          // showAlert(
          //   text: 'text_mine_phone_email_cover'.tr(),
          //   confirmCallBack: () {
          //     socialSignIn(authType, token, true);
          //   },
          // );
        }
      }
    } catch (e) {
      SmartDialog.dismiss(status: SmartStatus.loading);
      LogUtils.d('------socialSignIn --------$e');
    }
    return false;
  }

  void passwordHidenChange(bool hide) {
    state = state.copyWith(hidePassword: hide);
  }

  Future<bool> passWordSignIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!state.agreed) {
      showToast('terms_uncheck'.tr());
      return Future.value(false);
    }
    try {
      LogUtils.d('----- mobileSignIn  ------------- ');
      // DMLoading.show();
      showLoading(true);
      String password = await InfoModule().signPassword(_password);
      var lang = await LocalModule().getLangTag();
      var req = PasswordLoginReq(
        username: _account,
        password: password,
        country: state.currentItem?.countryCode ?? '',
        lang: lang,
      );

      /// 默认同意隐私
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();
      var data =
          await ref.read(accountRepositoryProvider).loginWithPassWord(req);
      LogUtils.d('----- passWordSignIn ------++++++ $data');
      await _saveAccountAndPassword(_account, _password);
      showLoading(false);
      await LifeCycleManager().gotoMainPage();
      SmartDialog.showToast('login_success'.tr());
      LogModule().eventReport(3, 24, int2: 1);

      /// 重置路由
      await AppRoutes.resetStacks();
      return Future.value(true);
    } on DreameAuthException catch (e) {
      LogModule().eventReport(3, 24, int2: 2);
      showLoading(false);

      LogUtils.d(
          '----- passWordSignIn DreameException ------------- ${e.code}  ${e.message}');
      var code = e.code;
      switch (code) {
        case 20101:
          //忘记密码输入多次
          // await SmartDialog.showToast(msg: 'sms_code_invalid_expired'.tr());
          if ((e.remains ?? '0') == '0') {
            showAlert(
              text: 'password_error_exceeded_the_maximum'.tr(),
              confirmString: 'text_retrieve_password'.tr(),
              confirmCallBack: () {
                LogModule().eventReport(3, 23, int1: 1);
                _goToRecover();
              },
              cancelCallback: () {
                LogModule().eventReport(3, 23, int2: 1);
              },
            );
          } else {
            showToast('text_login_fail'.tr());
          }

          break;
        case 20100:
        case 20104:
          //用户不存在
          showAlert(
            text: 'text_account_unregister'.tr(),
            confirmCallBack: _goToRegister,
            cancelCallback: () {
              LogModule().eventReport(3, 21, int2: 1);
            },
          );
          break;
        case 20102:
          //登录太多次
          showToast('login_request_too_much'.tr());
          break;
        case BadResultCode.NET_ERROR:
          showToast('toast_net_error'.tr());
          break;
        case BadResultCode.CANCEL:
          break;
        default:
          showToast('login_failed'.tr());
      }
      return Future.value(false);
    } catch (e) {
      showLoading(false);

      LogUtils.d('----- mobileSignIn ------------- $e');
      showToast('login_failed'.tr());
      return Future.value(false);
    }
  }

  Future<bool> toRegisterApple(SocialCodeModel model) async {
    try {
      showLoading(true);
      await ref.watch(privacyPolicyProvider.notifier).agreePrivacy();

      var ret =
          await SocialSignInBindUseCase(ref.watch(accountRepositoryProvider))
              .socialbBindSkipTwo(
                  source: model.oauthSource,
                  socialUUid: model.uuid,
                  countryCode: state.currentItem?.countryCode ?? '');
      showLoading(false);

      if (ret.first) {
        // success
        await LifeCycleManager().gotoMainPage();
        SmartDialog.showToast('login_success'.tr());
        return Future.value(true);
      } else {
        showToast(ret.second ?? '');
        return Future.value(false);
      }
    } catch (e) {
      showLoading(false);
      showToast('login_failed'.tr());
      LogUtils.d('------sendVerifyCode --------$e');
    }
    return Future.value(false);
  }

  void showToast(String text) {
    state = state.copyWith(event: ToastEvent(text: text));
    state = state.copyWith(event: EmptyEvent());
  }

void showLoading(bool isLoading) {
    state = state.copyWith(event: LoadingEvent(isLoading: isLoading));
  }
  void showAlert({
    required String text,
    String? cancelString,
    String? confirmString,
    Function()? confirmCallBack,
    Function()? cancelCallback,
  }) {
    AlertEvent alert = AlertEvent(
      content: text,
      cancelContent: cancelString ?? 'cancel'.tr(),
      confirmContent: confirmString ?? 'confirm'.tr(),
      confirmCallback: confirmCallBack,
      cancelCallback: cancelCallback,
    );
    state = state.copyWith(event: alert);
  }

  Future<void> _goToRegister() async {
    LogModule().eventReport(3, 22, int2: 1);
    state = state.copyWith(event: PushEvent(path: MobileSignUpPage.routePath));
  }

  Future<void> _goToRecover() async {
    bool isChina =
        (await LocalModule().getCurrentCountry()).countryCode.toLowerCase() ==
            'cn';
    bool isContainer = _account.contains('@');
    if (isContainer) {
      state = state.copyWith(
        event: PushEvent(
          path: MailRecoverPage.routePath,
        ),
      );
    } else {
      String? phone;

      if (isChina && isValidPhoneForCN(_account)) {
        phone = _account;
      }

      state = state.copyWith(
        event: PushEvent(
          path: MobileRecoverPage.routePath,
          extra: phone,
        ),
      );
    }
  }

  void _goToAcctionBind(Object? extra) {
    state = state.copyWith(
        event: PushEvent(path: SocialSignInBindPage.routePath, extra: extra));
  }
}
