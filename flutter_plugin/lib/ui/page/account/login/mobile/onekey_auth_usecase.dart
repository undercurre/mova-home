import 'dart:async';
import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/data/account/account_repository.dart';
import 'package:flutter_plugin/model/account/login.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/utils/logutils.dart';

class OneKeyAuthUsecase {
  AccountRepository repository;

  OneKeyAuthUsecase(this.repository);

  Future<CommonUIEvent> oneKeySignIn(String token, String lang) async {
    var oneKeyLoginReq = OneKeyLoginReq.create(token: token, lang: lang);
    try {
      var data = await repository.oneKeySignIn(oneKeyLoginReq);
      LogUtils.d('----- sendVerifyCode ------++++++ $data');
      return SuccessEvent(data: data);
    } on DreameAuthException catch (e) {
      var code = e.code;
      switch (code) {
        case 10017:
        case 20104:
          return ToastEvent(text: 'operate_failed'.tr());
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
      return ToastEvent(text: 'operate_failed'.tr());
    }
  }
}
