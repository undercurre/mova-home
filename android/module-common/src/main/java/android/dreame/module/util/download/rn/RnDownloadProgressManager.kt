package android.dreame.module.util.download.rn

import android.dreame.module.util.download.rn.RnPluginConstants.PLUGIN_SDK_NAME
import java.util.concurrent.ConcurrentHashMap

internal object RnDownloadProgressManager {
    /**
     * 插件下载中状态 map
     */
    private val progressCallbackMap = ConcurrentHashMap<String, IProgressCallback>()

    const val PROGRESS_INIT = 0
    const val PROGRESS_COMPLETE = 100

    fun setProgressCallback(moduleName: String, callback: IProgressCallback) {
        progressCallbackMap[moduleName] = callback
        progressCallbackMap[PLUGIN_SDK_NAME] = callback
    }

    fun removeProgressCallback(moduleName: String) {
        progressCallbackMap.remove(PLUGIN_SDK_NAME)
        progressCallbackMap.remove(moduleName)
    }

    fun clearProgressCallback() {
        progressCallbackMap.clear()
    }

    /**
     * 下载中
     * @param name  moduleName
     * @param progress 进度
     * @param type 类型
     */
    fun onProgress(name: String, progress: Int, type: Int) {
        val callback = progressCallbackMap[name]
        if (name != PLUGIN_SDK_NAME) {
            callback?.onProgress(name, progress, type + 10)
        } else {
            callback?.onProgress(name, progress, type)
        }
    }

    /**
     * 成功
     * @param name  moduleName
     * @param type 类型
     */
    fun onComplete(name: String, type: Int) {
        val callback = progressCallbackMap[name]
        if (name != PLUGIN_SDK_NAME) {
            callback?.onComplete(name, type + 10)
        } else {
            callback?.onComplete(name, type)
        }
        onFinish(name, type)
    }

    /**
     * 异常
     * @param name  moduleName
     * @param t 异常
     * @param type 类型
     */
    fun onError(name: String, t: Throwable?, type: Int) {
        val callback = progressCallbackMap[name]
        if (name != PLUGIN_SDK_NAME) {
            callback?.onError(name, t, type + 10)
        } else {
            callback?.onError(name, t, type)
        }
        onFinish(name, type)
    }

    /**
     * 解压，拷贝完成
     * @param name  moduleName
     * @param t 异常
     * @param type 类型
     */
    fun onFinish(name: String, type: Int) {
        val callback = progressCallbackMap[name]
        if (name != PLUGIN_SDK_NAME) {
            callback?.onFinish(name, type + 10)
        } else {
            callback?.onFinish(name, type)
        }
    }


}