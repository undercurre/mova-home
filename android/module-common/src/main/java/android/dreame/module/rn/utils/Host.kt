package android.dreame.module.rn.utils

import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.constant.Constants
import android.dreame.module.util.SPUtil

object Host {
    /**
     * 获取环境
     */
    fun getEnv(): String {
        val forceUrl =
            SPUtil.getString(LocalApplication.getInstance(), Constants.NET_BASE_URL, "")
        return when {
            forceUrl.contains("uat") -> "uat"
            (forceUrl.contains("cn.iot.mova-tech") || forceUrl.contains("us.iot.mova-tech") ||
                    forceUrl.contains("sg.iot.mova-tech") || forceUrl.contains("eu.iot.mova-tech")) -> "release"

            else -> BuildConfig.BUILD_TYPE
        }
    }
}