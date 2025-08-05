package android.dreame.module.data.network.service

import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.data.network.interceptor.AlexaInterceptor
import android.dreame.module.data.network.interceptor.DnsErrorInterceptor
import android.dreame.module.data.network.interceptor.HeaderIntercept
import android.dreame.module.data.network.interceptor.ParamsSignInterceptor
import android.dreame.module.data.network.interceptor.TokenInterceptor
import android.dreame.module.data.network.interceptor.UrlInterceptor
import android.dreame.module.data.network.interceptor.UrlLogInterceptor
import android.dreame.module.data.network.utils.DreameHostVerify
import android.dreame.module.data.network.utils.HttpClientUtils
import android.dreame.module.util.LogUtil
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.net.Proxy
import java.util.concurrent.TimeUnit

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/02
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object ServiceCreator {
    const val DNS_MAX_COUNT = 5
    const val BASE_URL = "http://cn-dev.iot.mova-tech.com:30080"
    private val logInterceptor = HttpLoggingInterceptor { message ->
        LogUtil.i("MOVAhome okhttp", message)
    }.setLevel(if (LocalApplication.isLogHttpBODY) HttpLoggingInterceptor.Level.BODY else HttpLoggingInterceptor.Level.BASIC)
    private val urlLogInterceptor = UrlLogInterceptor().apply {
        level =
            if (BuildConfig.DEBUG) UrlLogInterceptor.Level.NONE else UrlLogInterceptor.Level.BODY
    }
    private val _client = OkHttpClient.Builder()
        .addInterceptor(DnsErrorInterceptor)
        .addInterceptor(UrlInterceptor())
        .addInterceptor(AlexaInterceptor())
        .addInterceptor(HeaderIntercept())
        .addInterceptor(TokenInterceptor())
        .addInterceptor(ParamsSignInterceptor())
        .addInterceptor(logInterceptor)
        .addInterceptor(urlLogInterceptor)
        .hostnameVerifier(DreameHostVerify)
        .connectionSpecs(HttpClientUtils.connectionSpecs)
        .readTimeout(10000, TimeUnit.MILLISECONDS)
        .writeTimeout(10000, TimeUnit.MILLISECONDS)
        .connectTimeout(10000, TimeUnit.MILLISECONDS)
        .proxy(Proxy.NO_PROXY)
        .build()

    /**
     * OkHttpClient
     */
    val httpClient: OkHttpClient
        get() = _client

    /**
     * DNS解析错误次数
     */
    var dnsErrorCount = 0

    /**
     * 是否使用代理
     */
    val useProxy: Boolean
        get() = dnsErrorCount >= DNS_MAX_COUNT

    @JvmStatic
    fun <T> create(
        serviceClass: Class<T>,
        baseUrl: String = BASE_URL,
        okhttpClient: OkHttpClient = _client
    ): T = Retrofit.Builder()
        .baseUrl(baseUrl)
        .client(okhttpClient)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(serviceClass)

    @JvmStatic
    fun <T> create(
        serviceClass: Class<T>,
        baseUrl: String = BASE_URL,
        readTimeout: Long = 10000,
        writeTimeout: Long = 10000,
        connectTimeout: Long = 10000,
    ): T {
        val okHttpClient = _client.newBuilder()
            .readTimeout(readTimeout, TimeUnit.MILLISECONDS)
            .writeTimeout(writeTimeout, TimeUnit.MILLISECONDS)
            .connectTimeout(connectTimeout, TimeUnit.MILLISECONDS)
            .build()

        return Retrofit.Builder()
            .baseUrl(baseUrl)
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(serviceClass)

    }
}