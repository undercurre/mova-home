package com.dreame.smartlife.service

import android.dreame.module.RoutPath
import com.therouter.router.Route
import com.dreame.module.service.app.IHomeInteractionService

@Route(path = RoutPath.APP_HOME_INTERACTION_SERVICE)
class HomeInteractionService : IHomeInteractionService {

    override suspend fun getDeviceStatusByProtocol(
        model: String?,
        property: String,
        languageTag: String,
        statusKey: String,
    ): String? {
        return HomeDeviceStatusManager.getDeviceStatusByProtocol(
            model, languageTag, statusKey
        )

    }

}
@com.therouter.inject.ServiceProvider
fun homeInteractionServiceProvider(): IHomeInteractionService=HomeInteractionService()
