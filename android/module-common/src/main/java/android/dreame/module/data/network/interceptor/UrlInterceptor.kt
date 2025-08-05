package android.dreame.module.data.network.interceptor

import android.dreame.module.task.RetrofitInitTask
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.Interceptor
import okhttp3.Response

class UrlInterceptor : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val originalUrl = request.url
        val baseUrl = RetrofitInitTask.getBaseUrl()

        val urlBuilder = if (baseUrl != null) {
            val newBaseUrl = baseUrl.toHttpUrl()
            val newBuilder = newBaseUrl.newBuilder()

            for (pathSegment in originalUrl.pathSegments) {
                newBuilder.addPathSegment(pathSegment)
            }

            for (i in 0 until originalUrl.querySize) {
                val name = originalUrl.queryParameterName(i)
                val value = originalUrl.queryParameterValue(i)
                newBuilder.addQueryParameter(name, value)
            }

            newBuilder
        } else {
            // 如果没有设置基础URL，则使用原始URL
            originalUrl.newBuilder()
        }.also { it.build() }

        val newRequest = request.newBuilder()
            .url(urlBuilder.build())
            .build()
        return chain.proceed(newRequest)
    }
}