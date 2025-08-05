package com.dreame.module.mall.uniapp

import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import android.dreame.module.util.SPUtil
import android.dreame.module.util.download.CommonPluginManager
import com.dreame.module.mall.uniapp.helper.UniAppEventConstants
import java.io.File

object UniAppInfoCacheManager {

    // 记录uniapp 信息
    private val androidSp = SPUtil.createAndroidSp(LocalApplication.getInstance(), "uniApp.plugin")

    private val ASSET_URL = "/android_asset/apps/index.html"

    // webview 使用URL
    private var currentLoadUrl: String = "file:///android_asset/apps/index.html"
    private var loadUrlVerson = -1

    /**
     * 查询当前可用的loadUrl, 目前仅使用在MallFragment
     */
    suspend fun getH5Path(): String {
        var path = ASSET_URL
        val config = CommonPluginManager.queryPluginConfig(UniAppEventConstants.PLUGIN_NAME)
        if (config != null) {
            val pluginPath = config.pluginPath
            path = pluginPath + File.separator + "index.html"
            loadUrlVerson = config.pluginVersion
        } else {
            loadUrlVerson = 1
        }
        currentLoadUrl = "file://$path"
        LogUtil.i("UniAppInfoManager", "getH5Path: $config, h5Path: $path")
        return path
    }

    /**
     * 获取当前正在使用的loadUrl, 确保 mallFragment 和 其它入口使用的版本一致
     */
    suspend fun getCurrentLoadUrl(foreLoad: Boolean = false): String {
        if (!foreLoad && loadUrlVerson > 0 && currentLoadUrl.isNotBlank()) {
            return currentLoadUrl
        } else {
            getH5Path()
            return currentLoadUrl
        }
    }

    suspend fun updateCommonPluginInfo(version: Int, path: String, length: Long, md5: String = "") {
        CommonPluginManager.updateConfig(UniAppEventConstants.PLUGIN_NAME, version, path, length, md5)
    }

    fun clearAll() {
        try {
            androidSp.edit().clear().apply()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun clearMallInfo() {
        try {
            CommonPluginManager.removePluginConfigSync(UniAppEventConstants.PLUGIN_NAME)
            UniAppUpgradeManager.releaseAssetsPlugin()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}