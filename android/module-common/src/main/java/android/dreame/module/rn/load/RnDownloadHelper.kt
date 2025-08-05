package android.dreame.module.rn.load

import android.app.Activity
import android.content.Intent
import android.dreame.module.R
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.constant.CommExtraConstant
import android.dreame.module.constant.Constants
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager.getCountryCode
import android.dreame.module.manager.AreaManager.getRegion
import android.dreame.module.manager.LanguageManager
import android.dreame.module.rn.RNDebugActivity
import android.dreame.module.rn.data.PluginDataInfo
import android.dreame.module.task.RetrofitInitTask
import android.dreame.module.trace.EventCommonHelper.eventPluginAliveInsert
import android.dreame.module.util.SPUtil

/**
 * <pre>
 * author : admin
 * e-mail : wufei1@dreame.tech
 * time   : 2022/05/16
 * desc   :
 * version: 1.0
</pre> *
 */
object RnDownloadHelper {
    private const val TAG = "RnDownloadHelper"

    private fun goPlugin(
        activity: Activity,
        device: DeviceListBean.Device,
        isVideo: Boolean,
        showWarn: Boolean,
        warnCode: String?,
        entranceType: String?,
        source: String? = "",
        extraData: String? = "",
        pluginDataInfo: PluginDataInfo
    ) {
        val intent = Intent(
            activity, RnActivity::class.java
        ).putExtra(Constants.DEVICE, device).putExtra(CommExtraConstant.IS_FROM_VIDEO, isVideo)
            .putExtra(CommExtraConstant.ENTRANCE_TYPE, entranceType).putExtra(CommExtraConstant.EXTRA_EXTRA_DATA, extraData)
            .putExtra(CommExtraConstant.EXTRA_SOURCE, source).putExtra("accessToken", AccountManager.getInstance().account.access_token)
            .putExtra("refreshToken", AccountManager.getInstance().account.refresh_token).putExtra("region", getRegion()).putExtra(
                "langTag", LanguageManager.getInstance().getLangTag(activity.applicationContext)
            ).putExtra("countryCode", getCountryCode()).putExtra("uid", AccountManager.getInstance().account.uid)
            .putExtra("baseUrl", RetrofitInitTask.getBaseUrl()).putExtra("pluginDataInfo", pluginDataInfo)
        if (showWarn) {
            intent.putExtra(CommExtraConstant.EXTRA_DEVICE_WARNING, true)
            intent.putExtra(CommExtraConstant.EXTRA_DEVICE_WARNING_CODE, warnCode)
        }
        activity.startActivity(intent)
        activity.overridePendingTransition(R.anim.left_in, R.anim.left_out)
        try {
            var pluginVersion: Long = 0
            try {
                pluginVersion = pluginDataInfo.pluginVersion?.toLong() ?: 0
            } catch (e: Exception) {
                e.printStackTrace()
            }
            eventPluginAliveInsert(
                device.model, device.did, pluginVersion, pluginDataInfo.sdkVersion?.toInt() ?: 0
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * flutter进入RN插件
     */
    fun goDevicePluginOrDebug(
        activity: Activity,
        device: DeviceListBean.Device,
        isVideo: Boolean,
        showWarn: Boolean,
        warnCode: String,
        entranceType: String,
        source: String,
        extraData: String,
        pluginDataInfo: PluginDataInfo,
        isDebug: Boolean = false,
        ip: String = "",
        debugUrl: String = ""
    ) {
        if (isDebug) {
            goDebug(
                activity, device, isVideo, showWarn, warnCode, entranceType, extraData, source, isDebug, ip, debugUrl
            )
        } else {
            goPlugin(
                activity,
                device,
                isVideo,
                showWarn,
                warnCode,
                entranceType,
                source = source,
                extraData = extraData,
                pluginDataInfo = pluginDataInfo
            )
        }

    }

    private fun goDebug(
        activity: Activity,
        device: DeviceListBean.Device,
        isVideo: Boolean,
        showWarn: Boolean,
        warnCode: String,
        entranceType: String,
        extraData: String = "",
        source: String = "",
        isDebug: Boolean = false,
        ip: String = "",
        debugUrl: String = ""
    ): Boolean {
        SPUtil.defaultPut(activity, Constants.RN_FILE, Constants.debug_http_host, ip);
        val intent = Intent(
            activity, RNDebugActivity::class.java
        )
        intent.putExtra(RNDebugActivity.PROJECTPATH, debugUrl)
        intent.putExtra(CommExtraConstant.IS_FROM_VIDEO, isVideo)
        intent.putExtra(Constants.DEVICE, device)
        intent.putExtra(CommExtraConstant.ENTRANCE_TYPE, entranceType)
        intent.putExtra(CommExtraConstant.EXTRA_EXTRA_DATA, extraData)
        intent.putExtra(CommExtraConstant.EXTRA_SOURCE, source)
        intent.putExtra("accessToken", AccountManager.getInstance().account.access_token)
        intent.putExtra("refreshToken", AccountManager.getInstance().account.refresh_token)
        intent.putExtra("region", getRegion())
        intent.putExtra(
            "langTag", LanguageManager.getInstance().getLangTag(activity.applicationContext)
        )
        intent.putExtra("countryCode", getCountryCode())
        intent.putExtra("uid", AccountManager.getInstance().account.uid)
        intent.putExtra("baseUrl", RetrofitInitTask.getBaseUrl())
        if (showWarn) {
            intent.putExtra(CommExtraConstant.EXTRA_DEVICE_WARNING, true)
            intent.putExtra(CommExtraConstant.EXTRA_DEVICE_WARNING_CODE, warnCode)
        }
        activity.startActivity(intent)
        return isDebug;
    }
}