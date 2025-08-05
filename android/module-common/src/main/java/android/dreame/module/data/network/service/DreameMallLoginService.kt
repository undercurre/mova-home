package android.dreame.module.data.network.service

import android.dreame.module.data.network.api.DreameMallApiService

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/02
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object DreameMallLoginService {
//
    private var service =
        MallServiceCreator.create(DreameMallApiService::class.java, "https://ugrow.dreame.tech/")

    fun createService(baseUrl: String) {
        service = ServiceCreator.create(DreameMallApiService::class.java, baseUrl)
    }

    suspend fun mallLogin(req: Map<String, String>) = service.mallLogin(req)


    suspend fun mallPersonInfo(req: Map<String, String>) = service.mallPersonInfo(req)


}