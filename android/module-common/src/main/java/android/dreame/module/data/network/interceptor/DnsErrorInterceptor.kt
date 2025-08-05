package android.dreame.module.data.network.interceptor

import android.dreame.module.data.network.service.ServiceCreator
import android.dreame.module.trace.EventCommonHelper
import okhttp3.Interceptor
import okhttp3.Response
import java.net.UnknownHostException

/**
 * DNS解析错误拦截器
 */
object DnsErrorInterceptor : Interceptor {
    private var isNeedReport = false

    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        try {
            if (isNeedReport) {
                isNeedReport = false
                EventCommonHelper.eventCommonPageInsert(100, 14, 0, 4)
            }
            return chain.proceed(request)
        } catch (e: Exception) {
            if (e is UnknownHostException) {
                // dns解析失败
                ServiceCreator.dnsErrorCount = ServiceCreator.DNS_MAX_COUNT
                isNeedReport = true
                EventCommonHelper.eventCommonPageInsert(100, 14, 0, 1)
            } else {
                ServiceCreator.dnsErrorCount++
                if (ServiceCreator.useProxy) {
                    isNeedReport = true
                    EventCommonHelper.eventCommonPageInsert(100, 14, 0, 0)
                }
            }
            throw e
        }
    }

}