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
class MallHttpResult<T>(
    val iRet: Int,
    val sMsg: String,
    val data: T
)

fun <T> MallHttpResult<T>.toResult(): Result<T> =
    when (iRet) {
        1 -> {
            Result.Success(data)
        }
        -100 -> {
            Result.Error(
                DreameException(
                    -100, getString(R.string.operate_failed)
                )
            )
        }
        else -> Result.Error(
            DreameException(
                -1, getString(R.string.operate_failed)
            )
        )
    }