package android.dreame.module.data.network

import android.dreame.module.R
import android.dreame.module.data.Result
import android.dreame.module.data.getString
import android.dreame.module.exception.DreameException

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/29
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class HttpResult<T>(
    val code: Int,
    val success: Boolean,
    val msg: String,
    val data: T
)

fun <T> HttpResult<T>.toResult(): Result<T> =
    if (success) {
        Result.Success(data)
    } else {
        when (code) {
            ErrorCode.SERVER_ERROR -> Result.Error(
                DreameException(
                    -1,
                    getString(R.string.toast_server_error)
                )
            )
            ErrorCode.IP_BANNED -> Result.Error(
                DreameException(
                    -1,
                    getString(R.string.operate_failed)
                )
            )
            else -> Result.Error(DreameException(code, msg))
        }
    }