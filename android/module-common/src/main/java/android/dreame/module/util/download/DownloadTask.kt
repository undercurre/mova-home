package android.dreame.module.util.download

import java.io.File

open class DownloadTask constructor(var url: String, var path: String, var fileName: String?) {

    constructor(url: String, newUrl: String? = null) : this(url, "", null) {
        this.newUrl = newUrl
    }

    /**
     * 下载任务id
     */
    var taskId: String? = null

    /**
     * bundle md5
     */
    var bundleMd5: String? = null

    /**
     * 用来更换Url
     */
    var newUrl: String? = null

    /**
     * 存在相同任务，是否重新下载
     */
    var sameCancel: Boolean = false

    /**
     * 是否支持断点续传
     */
    var isBeakContinue = false

    /**
     * outputFile
     */
    var file: File? = null

    /**
     * 接口返回body
     */
    var body: String? = null

    fun updateUrl() {
        newUrl?.let {
            this.url = it
            this.newUrl = null
        }
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as DownloadTask

        if (url != other.url) return false

        return true
    }

    override fun hashCode(): Int {
        return url.hashCode()
    }


}