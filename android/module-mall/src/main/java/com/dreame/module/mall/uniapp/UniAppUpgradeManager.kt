package com.dreame.module.mall.uniapp

import android.dreame.module.BuildConfig
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.util.AssetsUtil
import android.dreame.module.util.LogUtil
import android.dreame.module.util.download.CommonPluginManager
import android.text.TextUtils
import com.blankj.utilcode.util.FileUtils
import com.dreame.module.mall.uniapp.helper.UniAppEventConstants
import kotlinx.coroutines.Dispatchers
import org.json.JSONObject
import java.io.File

object UniAppUpgradeManager {
    private val TAG = "UniAppUpgradeManager"
    private val context = LocalApplication.getInstance()

    fun getUniPlugin(force: Boolean = false) {
        CommonPluginManager.getCommonPlugin(UniAppEventConstants.PLUGIN_NAME,
            BuildConfig.MALL_VERSION.toString(),
            force = force,
            successCallback = { path ->
                LogUtil.i(TAG, "getUniPlugin successCallback: $path")
            })
    }

    /**
     * 解析assets目录下插件信息
     */
    fun releaseAssetsPlugin() {
        GlobalMainScope.launch(Dispatchers.IO) {
            runCatching {
                val config = CommonPluginManager.queryPluginConfig(UniAppEventConstants.PLUGIN_NAME)
                val pluginVersion = readAssetUniPluginVersion()
                LogUtil.i(TAG, "releaseAssetsPlugin: $config , pluginVersion:$pluginVersion")
                if (pluginVersion != 0) {
                    val pluginFile = File("/android_asset/apps")
                    if (config == null || pluginVersion > config.pluginVersion) {
                        GlobalMainScope.runMain {
                            CommonPluginManager.updateConfig(
                                UniAppEventConstants.PLUGIN_NAME,
                                pluginVersion,
                                pluginFile.absolutePath,
                                0,
                                ""
                            )
                        }
                    }
                    // add by sunzhibin 2/14 2023
                    if (config != null && !config.pluginPath.startsWith("/android_asset/apps")) {
                        val file = File(config.pluginPath)
                        val fileH5 = File(config.pluginPath, "index.html")
                        if (!file.exists() || !fileH5.exists()) {
                            // 如果数据库中存储的文件丢失了，则 release asset目录下的资源，防止商城无法加载
                            GlobalMainScope.runMain {
                                CommonPluginManager.updateConfig(
                                    UniAppEventConstants.PLUGIN_NAME,
                                    pluginVersion,
                                    pluginFile.absolutePath,
                                    FileUtils.getLength(pluginFile),
                                    ""
                                )
                            }
                        }
                    }

                }
            }.onFailure {
                LogUtil.e(TAG, "releaseAssetsPlugin error: $it")
            }
        }
    }

    private fun readAssetUniPluginVersion(): Int {
        val json = AssetsUtil.getStrFromAssets(context, UniAppEventConstants.UNI_PROJECT_JSON)
        if (TextUtils.isEmpty(json)) {
            return 0
        }
        val jsonObject = JSONObject(json)
        return jsonObject.optInt("versionCode")
    }

    suspend fun mallVersionCode(): Int {
        val queryPluginConfig = CommonPluginManager.queryPluginConfig(UniAppEventConstants.PLUGIN_NAME)
        return queryPluginConfig?.pluginVersion ?: -1
    }
}

