package com.dreame.smartlife.service

import android.content.Context
import android.dreame.module.manager.AreaManager
import android.dreame.module.task.RetrofitInitTask
import com.dreame.module.service.IAppConfigureService
import com.dreame.module.service.app.IAppWidgetClickHandleService
import com.dreame.smartlife.BuildConfig

class AppConfigureService : IAppConfigureService {
    override fun versionCode(): Int = BuildConfig.VERSION_CODE

    override fun versionName(): String = BuildConfig.VERSION_NAME

    override fun isCnFlavor(): Boolean = BuildConfig.FLAVOR == "cn"

    override fun isCnDomain(): Boolean {
        val areaManager = AreaManager.getRegion()
        return "cn".equals(areaManager, true)
    }

    override fun isDebug(): Boolean = BuildConfig.DEBUG
    override fun serviceDoamin(): String {
        return RetrofitInitTask.getBaseUrl()
    }

    override fun serviceAppPrivacyDoamin(): String {
        return RetrofitInitTask.getAppPrivacyBaseUrl()
    }


}

@com.therouter.inject.ServiceProvider
fun appConfigureServiceProvider(): IAppConfigureService = AppConfigureService()