package android.dreame.module.util.download

interface OnDownloadListener {
    fun onStart(task: DownloadTask)
    fun onProcess(task: DownloadTask, process: Int)
    fun onError(task: DownloadTask, cause: EndCause, e: Exception)
    fun onSuccess(task: DownloadTask)
    fun onFinish(task: DownloadTask, cause: EndCause);
}

open class SimpleOnDownloadListener : OnDownloadListener {
    override fun onStart(task: DownloadTask) {
    }

    override fun onProcess(task: DownloadTask, process: Int) {
    }

    override fun onError(task: DownloadTask, cause: EndCause, e: Exception) {
        task.file?.delete()
    }

    override fun onSuccess(task: DownloadTask) {

    }

    override fun onFinish(task: DownloadTask, cause: EndCause) {

    }

}