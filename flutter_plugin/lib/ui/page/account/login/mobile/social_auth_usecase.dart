import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/account/event_action/action_account_bind.dart';
import 'package:flutter_plugin/ui/widget/account/social/model/social_userinfo_model.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class SocialAuthUsecase {
  AccountRepository repository;

  SocialAuthUsecase(this.repository);

  Future<CommonUIEvent> socialSignIn({
    required String authType,
    required dynamic token,
    required int emailCheck,
  }) async {
    SocialLoginReq socialLoginReq;
    if (token is SocialTruck) {
      if (token.userInfo != null) {
        socialLoginReq = SocialLoginReq.createFaceBookLimit(
          thirdPartCode: token.token ?? '',
          authType: authType,
          facebookUserId: token.userInfo?.id ?? '',
          facebookUserName: token.userInfo?.name ?? '',
          facebookUserAEmail: token.userInfo?.email ?? '',
          emailCheck: emailCheck,
        );
      } else {
        socialLoginReq = SocialLoginReq.create(
          authType: authType,
          thirdPartCode: token.token ?? '',
          emailCheck: emailCheck,
        );
      }
    } else {
      socialLoginReq = SocialLoginReq.create(
        authType: authType,
        thirdPartCode: token,
        emailCheck: emailCheck,
      );
    }
    try {
      var data = await repository.socialSignIn(socialLoginReq);
      LogUtils.d('----- socialSignIn ------++++++ $data');
      return SuccessEvent(data: data);
    } on DreameAuthException catch (e) {
      var code = e.code;
      switch (code) {
        case 10017:
          // 绑定账号
          return ActionEvent(
              action: ActionSocialAccountBind(
                  source: e.oauthSource ?? '', uuid: e.uuid ?? ''));

        case 20104:
          return ToastEvent(text: 'operate_failed'.tr());
        case 20106:
          return ActionEvent(
              action: ActionSocialAccountBindT(source: authType, token: token));
        case 20107:
          return ActionEvent(
              action: ActionSocialAccountBindRepeat(
                  source: authType, token: token));
        case 10015:
          return ToastEvent(
              text: 'Toast_3rdPartyBundle_BundleProcess_TimeOut_Tip'.tr());
        case BadResultCode.NET_ERROR:
          return ToastEvent(text: 'toast_net_error'.tr());
        case BadResultCode.CANCEL:
          return const EmptyEvent();
        case -1:
          return ToastEvent(text: e.message ?? '');
        default:
          return ToastEvent(text: 'operate_failed'.tr());
      }
    } catch (e) {
      LogUtils.e('----------- socialSignIn -------- $e');
      return ToastEvent(text: 'operate_failed'.tr());
    }
  }
}
