package android.dreame.module.util.download.rn

object RnLoadingType {
    const val TYPE_DEFAULT = 0
    const val TYPE_QUERY_INIT = 1

    // sdk 下载/更新中
    const val TYPE_SDK_QUERY = 22
    const val TYPE_SDK_DOWNLOAD = 23
    const val TYPE_SDK_UNZIP = 24
    const val TYPE_SDK_COMPLETE = 25
    const val TYPE_SDK_QUERY_ERROR = 26
    const val TYPE_SDK_ERROR = 27

    const val TYPE_PLUGIN_QUERY = 32
    const val TYPE_PLUGIN_DOWNLOAD = 33
    const val TYPE_PLUGIN_UNZIP = 34
    const val TYPE_PLUGIN_COMPLETE = 35
    const val TYPE_PLUGIN_QUERY_ERROR = 36
    const val TYPE_PLUGIN_ERROR = 37

    // 插件加载中
    const val TYPE_LOADING_PLUGIN = 41

}

interface IProgressCallback {
    /**
     * 下载中
     */
    fun onProgress(name: String, progress: Int, type: Int) {}

    /**
     * 成功
     */
    fun onComplete(name: String, type: Int) {}

    /**
     * 异常
     *
     * @param t
     */
    fun onError(name: String, t: Throwable?, type: Int) {}

    /**
     * 解压，拷贝完成
     */
    fun onFinish(name: String, type: Int) {}
}