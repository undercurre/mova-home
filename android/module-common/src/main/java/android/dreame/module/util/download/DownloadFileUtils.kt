package android.dreame.module.util.download

import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import android.util.Log
import okhttp3.*
import okhttp3.logging.HttpLoggingInterceptor
import java.io.File
import java.io.IOException
import java.net.Proxy
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.TimeUnit

/**
 * 文件下载
 */
object DownloadFileUtils {
    private const val TAG = "DownloadFileUtils"
    private var mOkHttpClient: OkHttpClient
    private var mCallsMap = ConcurrentHashMap<String, Call>()
    private val taskMap = ConcurrentHashMap<String, DownloadTask>()

    init {
        this.mOkHttpClient = OkHttpClient.Builder()
            .connectTimeout((20 * 1000).toLong(), TimeUnit.MILLISECONDS)
            .writeTimeout((20 * 1000).toLong(), TimeUnit.MILLISECONDS)
            .readTimeout((20 * 1000).toLong(), TimeUnit.MILLISECONDS)
            .addInterceptor(HttpLoggingInterceptor { message ->
                LogUtil.i("MOVAhome okhttp", message)
            }.setLevel(HttpLoggingInterceptor.Level.BASIC))
            .proxy(Proxy.NO_PROXY)
            .build()
    }

    @JvmStatic
    fun downloadFile(task: DownloadTask, listener: OnDownloadListener) {
        remove()
        if (checkIsSameFile(task, listener)) {
            return
        }
        if (!checkFilePath(task, listener)) {
            return
        }
        downloadFileTask(task, listener)
    }

    @JvmStatic
    fun cancelDownloadFile(task: DownloadTask) {
        mCallsMap.filterValues { !it.isCanceled() }[task.url]?.cancel()
        task.taskId?.let { taskMap.remove(it) }
        remove()
    }

    @JvmStatic
    fun cancelDownloadFile(url: String) {
        mCallsMap.filterValues { !it.isCanceled() }[url]?.cancel()
        remove()
    }

    @JvmStatic
    fun cancelDownloadFile(urls: Collection<String>) {
        cancelDownloadFile(urls.toList())
    }

    @JvmStatic
    fun cancelDownloadFile(urls: List<String>) {
        if (urls.isNotEmpty()) {
            mCallsMap.filterKeys { url -> urls.indexOf(url) != -1 }
                .filterValues { !it.isCanceled() }
                .values
                .forEach { if (!it.isCanceled()) it.cancel() }
        }
        remove()
    }

    @JvmStatic
    fun cancelDownloadFileAll() {
        mCallsMap.filterValues { !it.isCanceled() }.values.forEach { call ->
            if (!call.isCanceled()) call.cancel()
        }
        removeAll()
    }

    @JvmStatic
    fun getDownloadTask(taskId: String) = taskMap[taskId]

    fun remove() {
        mCallsMap.filterValues { it.isCanceled() }.keys.forEach { mCallsMap.remove(it) }
    }

    fun removeAll() {
        mCallsMap.clear()
    }

    fun cancelDownload(task: DownloadTask): Boolean {
        return mCallsMap[task.url]?.apply { cancel() } != null
    }

    private fun checkIsSameFile(task: DownloadTask, listener: OnDownloadListener): Boolean {
        val call = mCallsMap.filterValues { !it.isCanceled() }[task.url]
        if (task.sameCancel) {
            listener.onError(task, EndCause.SAME_TASK, Exception())
        }
        return call != null
    }

    private fun checkFilePath(task: DownloadTask, listener: OnDownloadListener): Boolean {
        if (task is DownloadStreamTask) {
            return true
        }
        // 储存下载文件的目录
        val savePath: String = task.path
        val url = task.url
        if (savePath == "") {
            mCallsMap.remove(url)
            listener.onError(task, EndCause.ERROR, Exception("download file parent path is null"))
            listener.onFinish(task, EndCause.ERROR)
            return false
        }
        File(savePath).takeIf { !it.exists() }?.mkdirs()
        val outputFile = File(savePath, task.fileName ?: url.substring(url.lastIndexOf("/") + 1))
        outputFile.createNewFile()
        task.file = outputFile
        return true
    }

    private fun downloadFileTask(task: DownloadTask, listener: OnDownloadListener) {
        val url = task.url
        val request = Request.Builder()
            .get()
            .url(url)
            .build()
        task.taskId?.let { taskMap.put(it, task) }
        val call: Call = mOkHttpClient.newCall(request)
        mCallsMap[url] = call
        listener.onStart(task)
        Log.d(TAG, "onStart: ")
        call.enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.d(TAG, "onFailure: ")
                e.printStackTrace()
                mCallsMap.remove(task.url)
                task.taskId?.let { taskMap.remove(it) }
                listener.onError(task, EndCause.ERROR, e)
                listener.onFinish(task, EndCause.ERROR)
            }

            override fun onResponse(call: Call, response: Response) {
                Log.d(TAG, "onResponse: ")
                if (!response.isSuccessful) {
                    mCallsMap.remove(task.url)
                    task.taskId?.let { taskMap.remove(it) }
                    listener.onError(
                        task,
                        EndCause.ERROR,
                        Exception("download file call isSuccessful")
                    )
                    listener.onFinish(task, EndCause.ERROR)
                    return
                }
                if (task is DownloadStreamTask) {
                    writeStream(task, call, response, listener, url)
                } else {
                    writeFile(task, call, response, listener, url)
                }
            }

        })
    }

    /**
     * 写文件
     * @param task
     * @param call
     * @param response
     * @param listener
     * @param url
     */
    private fun writeFile(
        task: DownloadTask, call: Call, response: Response,
        listener: OnDownloadListener,
        url: String
    ) {
        val buffer = ByteArray(8 * 1024)
        var sum = 0L
        var _process = 0;
        val outputFile: File = task.file!!
        response.body?.let {
            val total = it.contentLength()
            try {
                it.byteStream().use { input ->
                    outputFile.outputStream().use { output ->
                        var len = input.read(buffer)
                        while (len != -1) {
                            if (call.isCanceled()) {
                                mCallsMap.remove(task.url)
                                task.taskId?.let { taskMap.remove(it) }
                                listener.onError(
                                    task,
                                    EndCause.CANCELED,
                                    Exception("task is cancel")
                                )
                                listener.onFinish(task, EndCause.CANCELED)
                                return
                            }
                            output.write(buffer, 0, len)
                            len = input.read(buffer)

                            sum += len.toLong()
                            val progress = (sum * 1.0f / total * 100).toInt()
                            if (progress > _process) {
                                _process = progress + 5
                                LogUtil.v(TAG, "download progress : $progress  ${outputFile.name}")
                                listener.onProcess(task, progress)
                            }
                        }
                        output.flush()
                        listener.onSuccess(task)
                        listener.onFinish(task, EndCause.COMPLETED)
                    }
                }
            } catch (e: Exception) {
                LogUtil.e(TAG, "url: " + task.url + " " + Log.getStackTraceString(e))
                e.printStackTrace()
                listener.onError(task, EndCause.ERROR, e)
                listener.onFinish(task, EndCause.ERROR)
            } finally {
                mCallsMap.remove(url)
                task.taskId?.let { taskMap.remove(it) }
            }

        }
    }

    private fun writeStream(
        task: DownloadStreamTask, call: Call, response: Response,
        listener: OnDownloadListener,
        url: String
    ) {
        response.body?.let {
            try {
                it.byteStream().use { input ->
                    val readBytes = input.readBytes()
                    task.bodyStream = readBytes
                    task.success = true
                    listener.onSuccess(task)
                    listener.onFinish(task, EndCause.COMPLETED)
                }
            } catch (e: Exception) {
                LogUtil.e(TAG, "url: " + task.url + " " + Log.getStackTraceString(e))
                e.printStackTrace()
                listener.onError(task, EndCause.ERROR, e)
                listener.onFinish(task, EndCause.ERROR)
            } finally {
                mCallsMap.remove(url)
                task.taskId?.let { taskMap.remove(it) }
            }
        }
    }
}
