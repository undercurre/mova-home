package android.dreame.module.ext

import android.dreame.module.data.getString
import android.dreame.module.exception.DreameException
import android.dreame.module.data.Result
import android.dreame.module.data.network.MallHttpResult
import android.dreame.module.data.network.toResult
import retrofit2.HttpException
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
inline fun <R> processMallApiResponse(request: () -> MallHttpResult<R>): Result<R> {
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
