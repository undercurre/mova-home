package android.dreame.module.data.network.interceptor

import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response
import java.util.concurrent.TimeUnit

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/11/24
 *     desc   :
 *     version: 1.0
 * </pre>
 */
const val CONNECT_TIMEOUT = "CONNECT_TIMEOUT"
const val READ_TIMEOUT = "CONNECT_TIMEOUT"
const val WRITE_TIMEOUT = "CONNECT_TIMEOUT"

// @Headers("CONNECT_TIMEOUT:600000", "READ_TIMEOUT:600000", "WRITE_TIMEOUT:600000")
class TimeoutInterceptor : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        var connectTimeout = chain.connectTimeoutMillis()
        var readTimeout = chain.readTimeoutMillis()
        var writeTimeout = chain.writeTimeoutMillis()

        val request: Request = chain.request()
        val connectNew: String? = request.header(CONNECT_TIMEOUT)
        val readNew: String? = request.header(READ_TIMEOUT)
        val writeNew: String? = request.header(WRITE_TIMEOUT)

        if (!connectNew.isNullOrEmpty()) {
            connectTimeout = connectNew.toInt()
        }
        if (!readNew.isNullOrEmpty()) {
            readTimeout = readNew.toInt()
        }
        if (!writeNew.isNullOrEmpty()) {
            writeTimeout = writeNew.toInt()
        }

        return chain.withConnectTimeout(connectTimeout, TimeUnit.MILLISECONDS)
            .withReadTimeout(readTimeout, TimeUnit.MILLISECONDS)
            .withWriteTimeout(writeTimeout, TimeUnit.MILLISECONDS)
            .proceed(request)
    }
}