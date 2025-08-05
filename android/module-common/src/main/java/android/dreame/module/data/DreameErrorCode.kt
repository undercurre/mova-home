package android.dreame.module.data

import android.dreame.module.LocalApplication
import android.dreame.module.R
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.okhttp3.convert.ErrorCode

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/04
 *     desc   :
 *     version: 1.0
 * </pre>
 */

val authErrorCode = mapOf(
    //token invalid
//    "invalid_token" to 31001,
    // 账号或密码错误，未授权
    "invalid_user" to 20100,
    "limit_attempts_unauthorized" to 20101,
    // 验证码错误或过期
    "invalid_verification" to 11000,
    // 手机号未注册
    "invalid_phone" to 20100,
    // 错误次数过多
    "exceed_max_attempts" to 20102,
    "invalid_social_user" to 20103,
    "invalid_social_grant" to 20104,
    "invalid_social_email" to 20105,
    "invalid_request" to 10015

)

fun getString(id :Int):String?{
    return ActivityUtil.getInstance().currentActivity?.getString(id) ?: LocalApplication.getInstance().getString(id)
}

fun getIdentifier(name :String,defType: String): Int{
    return ActivityUtil.getInstance().currentActivity?.resources?.getIdentifier(name,defType,LocalApplication.getInstance().packageName)
        ?: LocalApplication.getInstance().resources.getIdentifier(name,defType,LocalApplication.getInstance().packageName)
}

val apiErrorCode = mapOf(
    ErrorCode.CODE_BUSINESS to getString(R.string.toast_server_error),
    ErrorCode.CODE_HTTP_BODY_ERROR to getString(R.string.toast_server_error),
    ErrorCode.CODE_HTTP_METHOD_ERROR to getString(R.string.toast_server_error),
    ErrorCode.CODE_HTTP_CONTENT_TYPE_ERROR to getString(R.string.toast_server_error),
    ErrorCode.CODE_HTTP_OTHER_ERROR to getString(R.string.toast_server_error),
    ErrorCode.CODE_SERVER_ERROR to getString(R.string.toast_server_error),
)