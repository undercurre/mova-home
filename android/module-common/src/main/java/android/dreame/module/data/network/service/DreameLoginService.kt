package android.dreame.module.data.network.service

import android.dreame.module.data.entry.UserInfo
import android.dreame.module.data.network.HttpResult
import android.dreame.module.data.network.api.DreameApi
import android.dreame.module.task.RetrofitInitTask

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/02
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object DreameLoginService {

    private var service =
        ServiceCreator.create(DreameApi::class.java, RetrofitInitTask.getBaseUrl())

    fun createService(baseUrl: String) {
        service = ServiceCreator.create(DreameApi::class.java, baseUrl)
    }

    suspend fun getUserInfo(): HttpResult<UserInfo> {
        return service.getUserInfo()
    }

    suspend fun getCountryCode() = service.getCountryCode()
}