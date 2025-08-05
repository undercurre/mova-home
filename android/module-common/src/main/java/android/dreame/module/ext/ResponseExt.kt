package android.dreame.module.ext

import android.dreame.module.data.authErrorCode
import android.dreame.module.data.getString
import android.dreame.module.data.network.HttpResult
import android.dreame.module.data.network.toResult
import android.dreame.module.exception.DreameAuthException
import android.dreame.module.exception.DreameException
import android.dreame.module.data.Result
import android.dreame.module.data.entry.OAuthRes
import org.json.JSONObject
import retrofit2.HttpException
import retrofit2.Response
import java.io.IOException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import android.dreame.module.R as Res


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/07/31
 *     desc   :
 *     version: 1.0
 * </pre>
 */
inline fun <R> processApiResponse(request: () -> HttpResult<R>): Result<R> {
    return try {
        request().toResult()
    } catch (e: UnknownHostException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_net_error)))
    } catch (e: SocketTimeoutException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_net_error)))
    } catch (e: IOException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_net_error)))
    } catch (e: HttpException) {
        e.printStackTrace()
        Result.Error(DreameException(e.code(), getString(Res.string.toast_server_error)))
    } catch (e: Exception) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_server_error)))
    }
}

inline fun <R> processAuthResponse(request: () -> Response<R>): Result<R> {
    return try {
        request().toResult()
    } catch (e: UnknownHostException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_net_error)))
    } catch (e: SocketTimeoutException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_net_error)))
    } catch (e: IOException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_net_error)))
    } catch (e: HttpException) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_server_error)))
    } catch (e: Exception) {
        e.printStackTrace()
        Result.Error(DreameException(-1, getString(Res.string.toast_server_error)))
    }
}

fun <T> Response<T>.toResult(): Result<T> =
    if (isSuccessful) {
        val body = body()
        if(body is OAuthRes && body.code == 0){
            Result.Success(body)
        }else{
            Result.Error(DreameAuthException(10013, getString(Res.string.toast_param_error)))
        }
    } else {
        val errorBodyStr = errorBody()?.string()
        if (errorBodyStr != null) {
            val errorJson = JSONObject(errorBodyStr)
            val error = errorJson.optString("error")
            val errorDescription = errorJson.optString("error_description")
            val maxAttempts = errorJson.optString("maxAttempts")
            val remains = errorJson.optString("remains")
            if (error in authErrorCode) {
                val authException = DreameAuthException(authErrorCode[error]!!, errorDescription)
                authException.maximum = maxAttempts
                authException.remains = remains
                Result.Error(authException)
            } else {
                if(errorJson.has("code")){
                    val errorData = errorJson.optJSONObject("data")
                    val authException = DreameAuthException(errorJson.optInt("code"),"")
                    authException.oauthSource = errorData.optString("oauthSource")
                    authException.uuid = errorData.optString("uuid")
                    Result.Error(authException)
                }else{
                    Result.Error(DreameAuthException(code(), message()))
                }
            }
        } else {
            Result.Error(DreameException(-1, getString(Res.string.toast_server_error)))
        }
    }

