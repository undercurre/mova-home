package com.dreame.smartlife.service

//import com.dreame.module.widget.constant.CODE_OPERATOR_ERROR_TOKEN
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider.getService
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.PushDeviceTokenSpManager
import android.dreame.module.rn.load.RnCacheManager
import android.dreame.module.util.LogUtil
import android.util.Log
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.module.service.app.ILogoutClearService
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.constant.CODE_OPERATOR_ERROR_TOKEN
import com.dreame.sdk.alify.AliFySdk
import com.dreame.smartlife.service.push.PushManager
import com.therouter.router.Route
import kotlinx.coroutines.delay

@Route(path = RoutPath.APP_LOGOUT_CLEAR_SERVICE)
class LogoutClearService : ILogoutClearService {

    override suspend fun prepareLogout() {
        // 清理插件信息
        RnCacheManager.clearAllCache()
        // 推送登出 flutter中处理
        // 清理个人信息
        AccountManager.getInstance().clear()
        DeviceScanCache.clear()
        // 刷新小组件
        val service = getService<IAppWidgetDeviceService>()
        service?.flushAllWidget(LocalApplication.getInstance(), CODE_OPERATOR_ERROR_TOKEN)
//        // 商城的session 清理 flutter中处理
        // 登出三方账号
        AliFySdk.getInstance().logout(null)
        delay(1000)
    }

    override fun logoutClear() {
        try {
            DeviceScanCache.clear()
            AliFySdk.getInstance().logout(null)
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.e(Log.getStackTraceString(e))
        }
    }

    override fun deletePushAlias() {
        val deviceToken = PushDeviceTokenSpManager.getDeviceToken()
        if (deviceToken != null && deviceToken.isNotEmpty()) {
            LogUtil.i("deletePushAlias: $deviceToken")
            PushManager.deletePushAlias(deviceToken)
        }
        PushDeviceTokenSpManager.clearDefaultData()

    }


}

@com.therouter.inject.ServiceProvider
fun logoutClearServiceProvider(): ILogoutClearService = LogoutClearService()