import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/bridge/info_module.dart';
import 'package:flutter_plugin/common/providers/region_store.dart';
import 'package:flutter_plugin/model/account/social.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/settings/account/account_setting_repository.dart';
import 'package:flutter_plugin/ui/page/settings/thirdAccount/user_third_account_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_third_account_state_notifier.g.dart';

@riverpod
class UserThirdAccountNotifier extends _$UserThirdAccountNotifier {
  @override
  UserThirdAccountUiState build() {
    return UserThirdAccountUiState();
  }

  Future<void> getBindListAction() async {
    try {
      List<SocialInfo> platformList = await ref
          .watch(accountSettingRepositoryProvider)
          .getThirdSociaPlatformlBindList();

      var isGpVersion = await InfoModule().isGpVersion();
      String short = RegionStore().currentRegion.countryCode.toLowerCase();
      bool isChina = (short.toLowerCase() == 'cn') ? true : false;
      bool bindWeChat = false;
      bool bindGoogleID = false;
      bool bindAppleID = false;
      bool bindFackBookID = false;
      bool showApple = false;
      bool showWeChat = false;
      bool showGoogle = false;
      bool showFacebook = false;

      for (int i = 0; i < platformList.length; i++) {
        SocialInfo item = platformList[i];
        if (item.source == SocialPlatformType.apple.value) {
          bindAppleID = true;
        } else if (item.source == SocialPlatformType.google.value) {
          bindGoogleID = true;
        } else if (item.source == SocialPlatformType.wechat.value) {
          bindWeChat = true;
        } else if (item.source == SocialPlatformType.facebook.value) {
          bindFackBookID = true;
        }
      }

      /// 1.苹果账号
      if (bindAppleID == true) {
        //绑定状态展示；（安卓、iOS 均展示）
        showApple = true;
      } else {
        // 未绑定状态（安卓不展示）
        if (Platform.isIOS) {
          var iosInfo = await DeviceInfoPlugin().iosInfo;
          if (iosInfo.systemVersion.compareTo('13.0') >= 0) {
            showApple = true;
          }
        }
      }

      /// 2.Google账号
      if (bindGoogleID) {
        showGoogle = true;
      } else {
        if (((Platform.isAndroid && isGpVersion) || Platform.isIOS) &&
            !isChina) {
          showGoogle = true;
        }
      }

      /// 3.微信账号
      if (bindWeChat) {
        showWeChat = true;
      } else {
        if (isChina) {
          showWeChat = true;
        }
      }

      /// 4.FaceBook账号
      if (bindFackBookID) {
        showFacebook = true;
      } else {
        if (((Platform.isAndroid && isGpVersion) || Platform.isIOS) &&
            !isChina) {
          showFacebook = true;
        }
      }

      state = state.copyWith(
          platformList: platformList,
          //绑定状态
          bindApple: bindAppleID,
          bindGoogle: bindGoogleID,
          bindWeChat: bindWeChat,
          bindFacebook: bindFackBookID,
          //展示状态
          showWeChat: showWeChat,
          showFacebook: showFacebook,
          showGoogle: showGoogle,
          showApple: showApple,
          //国内还是国外
          isChina: isChina);
    } catch (error) {
      LogUtils.e(error);
    }
  }

  Future<void> bindAction(dynamic token, SocialPlatformType platform,
      bool cover,
      String platformShowName) async {
    state = state.copyWith(
      token: token,
      platform: platform,
      platformName: platformShowName,
    );

    try {
      await ref
          .watch(accountSettingRepositoryProvider)
          .bindThirdSocialPlatform(token, platform.value, cover: cover);
      ref
          .read(userThirdAccountUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'bind_success'.tr()));
      await ref
          .watch(userThirdAccountNotifierProvider.notifier)
          .getBindListAction();
    } on DreameException catch (e) {
      var code = e.code;
      var message = e.message ?? '';
      switch (code) {
        case 10015:
          ref.read(userThirdAccountUiEventProvider.notifier).sendEvent(
              ToastEvent(
                  text: 'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr()));
        case 30513:
          showAletCoverTips(platformShowName, message);
        default:
          ref
              .read(userThirdAccountUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'bind_failure'.tr()));
      }
    } catch (error) {
      ref
          .read(userThirdAccountUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'bind_failure'.tr()));
      LogUtils.e(error);
    }
  }

  Future<void> unbindAction(String id, String platformName) async {
    try {
      await ref
          .watch(accountSettingRepositoryProvider)
          .unbindThirdSocialPlatform(id, platformName);
      ref
          .read(userThirdAccountUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'unbind_success'.tr()));
    } on DreameException catch (e) {
      var code = e.code;
      switch (code) {
        case 30512:
          ref.read(userThirdAccountUiEventProvider.notifier).sendEvent(
              ToastEvent(
                  text: 'Toast_3rdPartyBundle_BundleSetting_UnbundleAll_Tip'
                      .tr()));
        default:
          ref
              .read(userThirdAccountUiEventProvider.notifier)
              .sendEvent(ToastEvent(text: 'unbind_failed'.tr()));
      }
    } catch (error) {
      ref
          .read(userThirdAccountUiEventProvider.notifier)
          .sendEvent(ToastEvent(text: 'unbind_failed'.tr()));
      LogUtils.e(error);
    }
  }

  // 弹窗提示
  void showAletCoverTips(String platformName, String sourceAccount) {
    showAlert(
      text: 'Toast_3rdPartyBundle_DoubleBundle'
          .tr(args: [platformName, sourceAccount, sourceAccount]),
      cancelString: 'cancel'.tr(),
      confirmString: 'bind'.tr(),
      confirmCallBack: () async {
        await bindAction(
            state.token!, state.platform, true, state.platformName);
      },
    );
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
}

@riverpod
class UserThirdAccountUiEvent extends _$UserThirdAccountUiEvent {
  @override
  CommonUIEvent build() {
    return const EmptyEvent();
  }

  void sendEvent(CommonUIEvent value) {
    state = value;
  }
}
