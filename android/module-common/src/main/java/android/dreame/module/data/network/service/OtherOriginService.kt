package android.dreame.module.data.network.service

import android.dreame.module.data.entry.UserInfo
import android.dreame.module.data.network.HttpResult
import android.dreame.module.data.network.api.DreameApi
import android.dreame.module.task.RetrofitInitTask


// 其他请求，区别于IOT的接口，不需要加Header,处理拦截器请求的接口
object OtherOriginService {
    private var service =
        ServiceCreator.create(DreameApi::class.java, RetrofitInitTask.getBaseUrl())

    fun createService(baseUrl: String) {
        service = ServiceCreator.create(DreameApi::class.java, baseUrl)
    }

    suspend fun geocoderByTencentMap(
        latitudeLongitude: String,
        api_key: String,
        get_poi: Int = 1,
    ) = service.geocoderByTencentMap(
        latitudeLongitude,
        api_key,
        get_poi,
    )

    suspend fun getProductInfo(productModel: String) = service.getProductInfo(productModel)

}