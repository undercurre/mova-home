package android.dreame.module.util.download


class DownloadStreamTask(url: String, path: String = "null", fileName: String? = null, var isStream: Boolean = true, val params: Map<String, Any>?) :
    DownloadTask(url, path, fileName) {
    lateinit var bodyStream: ByteArray
    var success: Boolean = false
}