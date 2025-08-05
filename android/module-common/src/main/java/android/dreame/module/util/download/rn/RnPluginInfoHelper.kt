package android.dreame.module.util.download.rn

import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.data.db.PluginInfoEntity
import android.dreame.module.data.db.PluginInfoRepository
import android.dreame.module.data.db.STATUS_IN_USE
import android.dreame.module.rn.utils.FileUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.download.rn.RnPluginConstants.PLUGIN_SDK_NAME
import java.io.File

/**
 * Rn 插件信息管理类
 */
object RnPluginInfoHelper {
    private const val TAG = "RnPluginInfoHelper"

    const val CODE_UPDATE_FAIL = 404
    const val CODE_UNZIP_FAIL = 500
    const val CODE_EXCEPTION = 501

    private val repository by lazy { PluginInfoRepository() }
    private val context = LocalApplication.getInstance()

    private fun getCachePath(): String? =
        if (BuildConfig.LOG_ENABLE) context.getExternalFilesDir("")?.absolutePath else context.filesDir.absolutePath

    val pluginDirPath by lazy { getCachePath() + File.separator + "rn-plugins" }

    val pluginTempPath by lazy { pluginDirPath + File.separator + "temp" }

    /**
     * 获取当前可用插件
     * @return Triple： first path second version third md5
     */
    suspend fun getRnSDKPluginUse(): PluginInfoEntity? {
        val pluginInfo = repository.queryPluginInUse(PLUGIN_SDK_NAME)
        LogUtil.i(TAG, "getRnSDKPluginUse: queryPluginInUse -------- ${pluginInfo}")
        return pluginInfo?.let {
            if (it.pluginVersion >= 86) {
                if (RnPluginDownloadManager.verifyPluginFile(pluginInfo.pluginPath, pluginInfo.pluginLength, pluginInfo.pluginMd5)) {
                    pluginInfo
                } else {
                    LogUtil.i(TAG, "getRnSDKPluginUse: verifyPluginFile fail -------- ${pluginInfo.pluginMd5} ${pluginInfo.pluginPath}")
                    repository.deletePlugin(PLUGIN_SDK_NAME, STATUS_IN_USE)
                    null
                }
            } else {
                LogUtil.i(TAG, "getRnSDKPluginUse: deletePlugin -------- ${pluginInfo.pluginMd5} ${pluginInfo.pluginPath}")
                repository.deletePlugin(PLUGIN_SDK_NAME, STATUS_IN_USE)
                null
            }
        }
    }

    /**
     * 在子线程使用
     */
    @JvmStatic
    fun getRnSDKPluginUseSync(): PluginInfoEntity? {
        val pluginInfo = repository.queryPluginInUseSync(PLUGIN_SDK_NAME)
        LogUtil.i(TAG, "getRnSDKPluginUse: getRnSDKPluginUseSync -------- ${pluginInfo}")
        return pluginInfo?.let {
            if (it.pluginVersion >= 86) {
                if (RnPluginDownloadManager.verifyPluginFile(pluginInfo.pluginPath, pluginInfo.pluginLength, pluginInfo.pluginMd5)) {
                    pluginInfo
                } else {
                    LogUtil.i(TAG, "getRnSDKPluginUse: deletePluginSync -------- ${pluginInfo}")
                    repository.deletePluginSync(PLUGIN_SDK_NAME, STATUS_IN_USE)
                    null
                }
            } else {
                LogUtil.i(TAG, "getRnSDKPluginUse: deletePluginSync -------- ${pluginInfo}")
                repository.deletePluginSync(PLUGIN_SDK_NAME, STATUS_IN_USE)
                null
            }
        }
    }

    @JvmStatic
    fun deleteRnSDKPluginUseSync() {
        val ret = repository.deletePluginSync(PLUGIN_SDK_NAME, STATUS_IN_USE)

    }

    @JvmStatic
    suspend fun deleteRnSDKPluginUse() {
        val pluginInfo = repository.deletePlugin(PLUGIN_SDK_NAME, STATUS_IN_USE)
    }

    suspend fun deleteRnPluginUse(moduleName: String) {
        repository.deletePlugin(moduleName, STATUS_IN_USE)
    }

    /**
     * 获取当前可用插件
     * @param pluginName 插件名
     * @param minVersion 插件支持的最小版本
     * @return Triple： first path second version third md5
     */
    suspend fun getRnPluginUse(
        pluginName: String,
        minVersion: Int = 0
    ): PluginInfoEntity? {
        val pluginInfo = repository.queryPluginInUse(pluginName)
        return pluginInfo?.let {
            if (it.pluginVersion >= minVersion) {
                if (RnPluginDownloadManager.verifyPluginFile(pluginInfo.pluginPath, pluginInfo.pluginLength, pluginInfo.pluginMd5)) {
                    pluginInfo
                } else {
                    repository.deletePlugin(PLUGIN_SDK_NAME, STATUS_IN_USE)
                    null
                }
            } else {
                repository.deletePlugin(PLUGIN_SDK_NAME, STATUS_IN_USE)
                null
            }
        }
    }

    @JvmStatic
    fun getRnPluginUseSync(
        pluginName: String,
        minVersion: Int = 0
    ): PluginInfoEntity? {
        val pluginInfo = repository.queryPluginInUseSync(pluginName)
        return pluginInfo?.let {
            if (it.pluginVersion >= minVersion) {
                if (RnPluginDownloadManager.verifyPluginFile(pluginInfo.pluginPath, pluginInfo.pluginLength, pluginInfo.pluginMd5)) {
                    pluginInfo
                } else {
                    repository.deletePluginSync(PLUGIN_SDK_NAME, STATUS_IN_USE)
                    null
                }
            } else {
                repository.deletePluginSync(PLUGIN_SDK_NAME, STATUS_IN_USE)
                null
            }
        }
    }


    /**
     * 查询插件配置信息
     */
    suspend fun queryPluginConfig(pluginName: String) = repository.queryPluginInUse(pluginName)

    /**
     * 更新插件配置信息
     */
    suspend fun updateConfig(entity: PluginInfoEntity) {
        LogUtil.i("$entity   ${File(entity.pluginPath).exists()}")
        return repository.updatePlugin(entity)
    }


    fun checkoutPluginUpgrade(moduleName: String, force: Boolean = false) {
        if (moduleName == PLUGIN_SDK_NAME) {
            RnPluginUpgradeManager.checkoutSDKUpgrade()
        } else {
            RnPluginUpgradeManager.checkoutPluginUpgrade(moduleName, force)
        }
    }

    /**
     * 清理插件下载，所有的缓存 everything
     */
    fun cancelAll() {
        LogUtil.i(TAG, "cancelAll: ---------- start ---------- ")
        RnDownloadProgressManager.clearProgressCallback()
        cancelAllDownload()
        clearAllCacheSync()
        LogUtil.i(TAG, "cancelAll: ---------- end ---------- ")
    }

    /**
     * 清理插件的下载任务
     */
    private fun cancelAllDownload() {
        RnPluginUpgradeManager.cancelAllDownload()
    }

    /**
     * 清理插件所有的缓存
     */
    private fun clearAllCacheSync() {
        LogUtil.i(TAG, "clearAllCacheSync: ---------- start ---------- ")
        FileUtils.deleteFileAtPathSilently(pluginDirPath)
        repository.deletePluginInfoSync(STATUS_IN_USE)
        LogUtil.i(TAG, "clearAllCacheSync: ---------- end ---------- ")
    }

    suspend fun clearAllCache() {
        FileUtils.deleteFileAtPathSilently(pluginDirPath)
        repository.deletePluginInfo(STATUS_IN_USE)
    }

    fun setProgressCallback(moduleName: String, callback: IProgressCallback) {
        RnDownloadProgressManager.setProgressCallback(moduleName, callback)
    }

    fun removeProgressCallback(moduleName: String) {
        RnDownloadProgressManager.removeProgressCallback(moduleName)
    }

    fun cancelDownload(moduleName: String) {
        RnPluginUpgradeManager.cancelDownload(moduleName)
    }

}