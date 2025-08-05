package android.dreame.module.util.download.rn

import android.dreame.module.GlobalMainScope
import android.dreame.module.util.LogUtil
import android.dreame.module.util.download.rn.RnPluginConstants.PLUGIN_SDK_NAME
import kotlinx.coroutines.Job
import java.util.concurrent.ConcurrentHashMap

/**
 * Rn 插件信息管理类
 */
internal object RnPluginUpgradeManager {
    private const val TAG = "RnPluginUpgradeManager"

    /**
     * 当前插件的更新状态
     */
    private val statusMap = ConcurrentHashMap<String, Int>()
    private val taskMap = ConcurrentHashMap<String, Job>()

    fun checkoutSDKUpgrade(force: Boolean = false) {
        if (taskMap.contains(PLUGIN_SDK_NAME)) {
            return
        }
        LogUtil.d(TAG, "checkoutSDKUpgrade: --------0-------")
        statusMap.put(PLUGIN_SDK_NAME, RnLoadingType.TYPE_QUERY_INIT)
        val job = GlobalMainScope.launch {
            LogUtil.d(TAG, "checkoutSDKUpgrade: --------1-------")
            RnPluginDownloadManager.checkoutPluginVersion(PLUGIN_SDK_NAME, force)
            LogUtil.d(TAG, "checkoutSDKUpgrade: --------2-------")
            statusMap.remove(PLUGIN_SDK_NAME)
            taskMap.remove(PLUGIN_SDK_NAME)
            LogUtil.d(TAG, "checkoutSDKUpgrade: --------3-------")
        }
        taskMap.put(PLUGIN_SDK_NAME, job)
    }

    fun checkoutPluginUpgrade(moduleName: String, force: Boolean = false) {
        if (statusMap.contains(moduleName)) {
            return
        }
        statusMap.put(moduleName, RnLoadingType.TYPE_QUERY_INIT)
        GlobalMainScope.launch {
            LogUtil.d(TAG, "checkoutPluginUpgrade: $moduleName ------0-----")
            val jobPre = taskMap[PLUGIN_SDK_NAME]
            LogUtil.d(TAG, "checkoutPluginUpgrade: jobPre: $moduleName  ${jobPre == null}  ${jobPre?.isActive}  ${jobPre?.isCompleted} ${Thread.currentThread().name}")
            if (jobPre != null && jobPre.isActive) {
                LogUtil.d(TAG, "checkoutPluginUpgrade: $moduleName jobPre.join start ")
                jobPre.join()
                taskMap.remove(PLUGIN_SDK_NAME)
                LogUtil.d(TAG, "checkoutPluginUpgrade: $moduleName jobPre.join end ")
            } else {
                val job = GlobalMainScope.launch {
                    statusMap.put(PLUGIN_SDK_NAME, RnLoadingType.TYPE_QUERY_INIT)
                    LogUtil.d(TAG, "checkoutPluginUpgrade: ------------ checkoutPluginVersion ------------ $moduleName  ${Thread.currentThread().name}")
                    val result = RnPluginDownloadManager.checkoutPluginVersion(PLUGIN_SDK_NAME, force)
                    statusMap.put(PLUGIN_SDK_NAME, if (result) RnLoadingType.TYPE_SDK_COMPLETE else RnLoadingType.TYPE_SDK_ERROR)
                    statusMap.remove(PLUGIN_SDK_NAME)
                    taskMap.remove(PLUGIN_SDK_NAME)
                    LogUtil.d(TAG, "checkoutPluginUpgrade: job $moduleName -------- $result")
                }
                taskMap.put(PLUGIN_SDK_NAME, job)
                job.join()
                LogUtil.d(TAG, "checkoutPluginUpgrade: job $moduleName ++++++ ${job.isCompleted}")
            }
            val job2Pre = taskMap[moduleName]
            if (job2Pre != null && job2Pre.isActive) {
                LogUtil.d(TAG, "checkoutPluginUpgrade: $moduleName job2Pre.join start")
                job2Pre.join()
                taskMap.remove(moduleName)
                LogUtil.d(TAG, "checkoutPluginUpgrade: $moduleName job2Pre.join end ")
            } else {
                val job2 = GlobalMainScope.launch {
                    statusMap.put(moduleName, RnLoadingType.TYPE_PLUGIN_QUERY)
                    LogUtil.d(TAG, "checkoutPluginUpgrade: ----------- checkoutPluginVersion start ------------ $moduleName")
                    val pluginResult = RnPluginDownloadManager.checkoutPluginVersion(moduleName, force)
                    statusMap.put(moduleName, if (pluginResult) RnLoadingType.TYPE_SDK_COMPLETE else RnLoadingType.TYPE_SDK_ERROR)
                    statusMap.remove(moduleName)
                    taskMap.remove(moduleName)
                    LogUtil.d(TAG, "checkoutPluginUpgrade: job2 end $moduleName --------- $pluginResult")
                }
                taskMap.put(moduleName, job2)
                LogUtil.d(TAG, "checkoutPluginUpgrade: job2 start $moduleName +++++++ ${job2.isCompleted}")
            }
        }
    }

    fun cancelAllDownload() {
        taskMap.values.onEach {
            if (it.isActive) {
                it.cancel()
            }
        }
        statusMap.clear()
        taskMap.clear()

    }

    fun cancelDownload(moduleName: String) {
        taskMap[moduleName]?.let {
            if (it.isActive) {
                it.cancel()
            }
        }
    }

}