package android.dreame.module.data.network.interceptor

import android.dreame.module.data.network.isSign
import android.dreame.module.util.RequestParamsUtil
import android.util.Log
import okhttp3.*
import okio.Buffer
import org.json.JSONObject

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/12
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class ParamsSignInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        if ("POST" == request.method || "PUT" == request.method) {
            if (request.body?.contentType().toString().contains("application/json", true)) {
                request.body?.let {
                    val bodyStr = body2String(it)
                    val contains = isSign(request.url.encodedPath)
                    val signParam = RequestParamsUtil.signParams(bodyStr, contains)
                    val newBody = RequestBody.create(it.contentType(), signParam)
                    val newRequest = request.newBuilder().method(request.method, newBody).build()
                    return chain.proceed(newRequest)
                }
            }
        }
        return chain.proceed(request)
    }

    private fun body2String(requestBody: RequestBody?): String {
        val buffer = Buffer()
        var bodyString = ""
        requestBody?.let {
            requestBody.writeTo(buffer)
            bodyString = buffer.readUtf8()
        }
        return bodyString
    }
}