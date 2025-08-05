package android.dreame.module.data.network.service

import android.dreame.module.LocalApplication
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
object MallServiceCreator {
    const val BASE_URL = "https://ugrow.dreame.tech/"
    private val client = OkHttpClient.Builder()
        .addInterceptor(HttpLoggingInterceptor { message ->
            LogUtil.i(
                "MOVAhome okhttp",
                message
            )
        }.setLevel(if (LocalApplication.isLogHttpBODY) HttpLoggingInterceptor.Level.BODY else HttpLoggingInterceptor.Level.BASIC))
        .hostnameVerifier(DreameHostVerify)
        .connectionSpecs(HttpClientUtils.connectionSpecs)
        .readTimeout(10000, TimeUnit.MILLISECONDS)
        .writeTimeout(10000, TimeUnit.MILLISECONDS)
        .connectTimeout(10000, TimeUnit.MILLISECONDS)
        .proxy(Proxy.NO_PROXY)
        .build()


    @JvmStatic
    fun <T> create(
        serviceClass: Class<T>,
        baseUrl: String = BASE_URL,
        okhttpClient: OkHttpClient = client
    ): T = Retrofit.Builder()
        .baseUrl(baseUrl)
        .client(okhttpClient)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(serviceClass)
}