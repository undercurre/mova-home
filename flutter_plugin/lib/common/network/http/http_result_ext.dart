import 'dart:async';
import 'dart:io';

import 'package:dreame_flutter_base_model/dreame_flutter_base_model.dart';
import 'package:dreame_flutter_base_network/dreame_flutter_base_network.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_plugin/model/account/mall_my_info_res.dart';
import 'package:flutter_plugin/utils/logutils.dart';
import 'package:retrofit/retrofit.dart';

/// 返回值包装
class BadResultCode {
  static const int SUCCESS = 0;
  static const int NET_ERROR = -1;

  // static const int SEVER_ERROR = -2;
  // static const int BAD_CERTIFICATE = -3;
  static const int CANCEL = -4;
  static const int OTHER = -1000;
}

Future<R> processApiResponse<R>(Future<BaseResponse<R>> function) async {
  try {
    Future<R> ret = (await function).toResult();
    return ret;
  } on DioException catch (e) {
    LogUtils.e(
        '----- processApiResponse DioException ------ ${function.toString()} statusCode: ${e.response?.statusCode} ,message: ${e.message} ,error: ${e.error} ,type: ${e.type} ,stackTrace: ${e.stackTrace}');
    return handleDioError(e);
  } catch (e) {
    LogUtils.e('----- processApiResponse else ------${function.toString()} $e');
    return Future.error((DreameAuthException(
        code: BadResultCode.OTHER, message: e.toString())));
  }
}

Future<R> processMallApiResponse<R>(
    Future<BaseMallResponse<R>> function) async {
  try {
    Future<R> ret = (await function).toResult();
    return ret;
  } on DioException catch (e) {
    LogUtils.e(
        '----- processApiResponse DioException ------ ${function.toString()} statusCode: ${e.response?.statusCode} ,message: ${e.message} ,error: ${e.error} ,type: ${e.type} ,stackTrace: ${e.stackTrace}');
    return handleDioError(e);
  } catch (e) {
    LogUtils.e('----- processApiResponse else ------${function.toString()} $e');
    return Future.error((DreameAuthException(
        code: BadResultCode.OTHER, message: e.toString())));
  }
}

Future<R> processAuthResponse<R>(Future<HttpResponse<R>> function) async {
  try {
    Future<R> ret = (await function).toResult();
    return ret;
  } on DioException catch (e) {
    LogUtils.e(
        '----- processAuthResponse DioError ------${function.toString()} response: ${e.response?.data} ,message: ${e.message} ,error: ${e.error} ,type: ${e.type} ,stackTrace: ${e.stackTrace}');
    return handleDioError(e);
  } catch (e) {
    LogUtils.e(
        '----- processAuthResponse else ------${function.toString()} $e');
    return Future.error((DreameAuthException(
        code: BadResultCode.OTHER, message: e.toString())));
  }
}

Future<R> handleDioError<R>(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return Future.error(DreameAuthException(
          code: BadResultCode.NET_ERROR, message: 'toast_net_error'.tr()));
    case DioExceptionType.badCertificate:
      // 证书异常
      return Future.error(DreameAuthException(
          code: BadResultCode.NET_ERROR, message: 'toast_server_error'.tr()));
    case DioExceptionType.badResponse:
      return _handleBadResponse<R>(e);
    case DioExceptionType.cancel:
      return Future.error(DreameAuthException(
          code: BadResultCode.CANCEL, message: 'toast_net_error'.tr()));
    case DioExceptionType.unknown:
      return Future.error(DreameAuthException(
          code: BadResultCode.NET_ERROR, message: 'toast_net_error'.tr()));
    default:
      return Future.error(DreameAuthException(
          code: BadResultCode.NET_ERROR, message: 'toast_net_error'.tr()));
  }
}

Future<R> _handleBadResponse<R>(DioException e) {
  if (e.response?.statusCode == HttpStatus.badRequest ||
      e.response?.statusCode == HttpStatus.unauthorized) {
    //
    Map<String, dynamic> errorBody = e.response?.data as Map<String, dynamic>;
    LogUtils.d('----------------------$errorBody');
    String? error = errorBody['error'];
    String? errorDescription = errorBody['error_description'];
    String? maxAttempts = errorBody['maxAttempts'];
    String? remains = errorBody['remains'];
    if (authErrorCode.containsKey(error)) {
      var authException = DreameAuthException(
          code: authErrorCode[error]!,
          message: errorDescription,
          maximum: maxAttempts,
          remains: remains);
      return Future.error(authException);
    } else {
      int? code = errorBody['code'];
      if (code != null) {
        Map<String, dynamic>? data = errorBody['data'];
        String? oauthSource = data?['oauthSource'];
        String? uuid = data?['uuid'];
        var authException = DreameAuthException(
            code: code, message: '', oauthSource: oauthSource, uuid: uuid);
        return Future.error(authException);
      } else {
        var authException = DreameAuthException(
            code: e.response?.statusCode ?? BadResultCode.OTHER,
            message: e.response?.statusMessage);
        return Future.error(authException);
      }
    }
  } else {
    LogUtils.d('----------------------${e.response}');
    return Future.error(
        DreameAuthException(code: 10013, message: 'toast_param_error'.tr()));
  }
}

extension BaseMallRespExt<R> on BaseMallResponse<R> {
  Future<R> toResult() {
    var _message = sMsg ?? msg ?? '';
    var _code = code ?? iRet;
    var _success = code == 0 || iRet == 1;
    return _handleToResult<R>(
        data: data, success: _success, code: _code, msg: _message);
  }
}

extension BaseRespExt<R> on BaseResponse<R> {
  Future<R> toResult() {
    return _handleToResult<R>(
        data: data, success: success, code: code, msg: msg);
  }
}

Future<R> _handleToResult<R>(
    {required R? data,
    required bool success,
    required int? code,
    required String? msg}) {
  if (success || code == BadResultCode.SUCCESS) {
    if (data != null) {
      return Future.value(data as R);
    } else {
      return Future.value(null);
    }
  } else {
    LogUtils.e('---------------------- \n $code  $msg');
    switch (code) {
      case -1:

        /// 商城错误码
        return Future.error(DreameAuthException(code: -1, message: msg));
      case -100:

        /// 商城错误码
        return Future.error(DreameAuthException(code: -100, message: msg));
        break;
      // 服务器错误
      case 10500:
        return Future.error(DreameAuthException(
            code: BadResultCode.NET_ERROR, message: 'toast_server_error'.tr()));
      // ip banned
      case 10013:
        return Future.error((DreameAuthException(
            code: BadResultCode.OTHER, message: 'operate_failed'.tr())));
      default:
        return Future.error((DreameAuthException(
            code: code ?? BadResultCode.OTHER,
            message: msg ?? 'operate_failed'.tr())));
    }
  }
}

extension HttpResponseExt<R> on HttpResponse<R> {
  Future<R> toResult() {
    if (response.statusCode == HttpStatus.ok) {
      if (data is OAuthModel) {
        return Future.value(data);
      }
      LogUtils.e('----------------------$response');
      return Future.error(
          DreameAuthException(code: 10013, message: 'toast_param_error'.tr()));
    } else {
      LogUtils.e('----------------------$response');
      return Future.error(
          DreameAuthException(code: 10013, message: 'toast_param_error'.tr()));
    }
  }
}

final Map<String, int> authErrorCode = {
  //token invalid
//    "invalid_token" to 31001,
  // 账号或密码错误，未授权
  'invalid_user': 20100,
  'limit_attempts_unauthorized': 20101,
  // 验证码错误或过期
  'invalid_verification': 11000,
  // 手机号未注册
  'invalid_phone': 20100,
  // 错误次数过多
  'exceed_max_attempts': 20102,
  'invalid_social_user': 20103,
  'invalid_social_grant': 20104,
  'invalid_request': 10015,
  'invalid_social_email': 20105,
  'social user no email': 20106, //第三方登录未获取到邮箱
  'email has bind other account': 20107 // 第三方登录邮箱冲突
};
