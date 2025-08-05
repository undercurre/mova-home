import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/app_routers.dart';
import 'package:flutter_plugin/common/bridge/ui_module.dart';
import 'package:flutter_plugin/common/network/http/http_result_ext.dart';
import 'package:flutter_plugin/common/providers/api_client_provider.dart';
import 'package:flutter_plugin/model/voice/alexa/alexa_auth_req.dart';
import 'package:flutter_plugin/ui/common/common_ui_event/common_ui_event.dart';
import 'package:flutter_plugin/ui/page/voice/alexa/alexa_auth_ui_state.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alexa_auth_state_notifier.g.dart';

const JSON_FILE_FOLDER = 'dreame_resource';

@riverpod
class AlexaAuthStateNotifier extends _$AlexaAuthStateNotifier {
  @override
  AlexaAuthUiState build() {
    return AlexaAuthUiState();
  }

  // Constants
  String _QUERY_PARAMETER_KEY_CLIENT_ID = "client_id";
  String _QUERY_PARAMETER_KEY_RESPONSE_TYPE = "response_type";
  String _QUERY_PARAMETER_KEY_STATE = "state";
  String _QUERY_PARAMETER_KEY_SCOPE = "scope";
  String _QUERY_PARAMETER_KEY_REDIRECT_URI = "redirect_uri";

  // Incoming Query Parameters

  void initData(Map<String, dynamic> arguments) {
    final client_id = arguments[_QUERY_PARAMETER_KEY_CLIENT_ID];
    final response_type = arguments[_QUERY_PARAMETER_KEY_RESPONSE_TYPE];
    final aleaxState = arguments[_QUERY_PARAMETER_KEY_STATE];
    final scope = arguments[_QUERY_PARAMETER_KEY_SCOPE];
    final redirect_uri = arguments[_QUERY_PARAMETER_KEY_REDIRECT_URI];

    state = state.copyWith(
      clientId: client_id,
      responseType: response_type,
      state: aleaxState,
      scope: scope,
      redirectUri: redirect_uri,
    );
  }

  /// 授权
  Future<void> alexaAuth() async {
    final req = AlexaBindAuthReq(
        client_id: state.clientId,
        redirect_uri: state.redirectUri,
        scope: state.scope,
        response_type: state.responseType,
        state: state.state);
    try {
      final ret = await processApiResponse(
          ref.read(apiClientProvider).skillAuthorizeCode(req));
      SmartDialog.dismiss(tag: 'loading_dialog');
      // 跳转到alexa app
      final url =
          '${state.redirectUri}?code=${ret.code}&state=${state.state}&source=app';
      openAlexaAppToAppUrl(url);
    } on DreameAuthException catch (e) {
      SmartDialog.dismiss(tag: 'loading_dialog');
      if (e.code == BadResultCode.NET_ERROR) {
        state = state.copyWith(
            uiEvent: ToastEvent(text: e.message ?? 'opeation_failed'.tr()));
      } else {
        await alexaCancel();
      }
    } catch (e) {
      SmartDialog.dismiss(tag: 'loading_dialog');
      LogUtils.e(e);
      await alexaCancel();
    }
  }

  Future<void> alexaCancel() async {
    final url =
        '${state.redirectUri}#error=access_cancel&state=${state.state}&error_description=cancel by user';
    openAlexaAppToAppUrl(url);
  }

  void openAlexaAppToAppUrl(String url) {
    UIModule().openAppByUrl(url);
    AppRoutes().pop();
  }
}
