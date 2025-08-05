package android.dreame.module.util.download

import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.bean.UniappVersionBean
import android.dreame.module.data.Result
import android.dreame.module.data.db.PluginConfigEntity
import android.dreame.module.data.db.PluginConfigRepository
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.exception.DreameException
import android.dreame.module.ext.processApiResponse
import android.dreame.module.util.LogUtil
import android.dreame.module.util.MD5Util
import android.dreame.module.util.download.rn.RnDownloadProgressManager
import android.dreame.module.util.download.rn.RnLoadingType
import android.dreame.module.util.download.rn.RnPluginDownloadManager
import android.text.TextUtils
import com.blankj.utilcode.util.FileUtils
import com.blankj.utilcode.util.ZipUtils
import kotlinx.coroutines.*
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

/**
 * 通用插件下载,更新,解压管理
 */
object CommonPluginManager : CoroutineScope by MainScope() {

    private val TAG = "CommonPluginHelper"
    private val configRepository by lazy { PluginConfigRepository() }
    private val context = LocalApplication.getInstance()

    private const val CODE_UPDATE_FAIL = 404
    private const val CODE_UNZIP_FAIL = 500
    private const val CODE_EXCEPTION = 501

    private fun getCachePath(): String? =
        if (BuildConfig.DEBUG) context.getExternalFilesDir("")?.absolutePath else context.filesDir.absolutePath

    private val pluginDirPath = getCachePath() + File.separator + "common-plugins"
    private val pluginTempPath = pluginDirPath + File.separator + "temp"


    fun getCommonPlugin2(
        pluginName: String,
        appVersion: String = "1",
        minVersion: Int = 0,
        force: Boolean = false,
        successCallback: ((path: String?) -> Unit)? = null,
        failCallback: ((error: String?) -> Unit)? = null){
        getCommonPlugin(pluginName,appVersion, minVersion, force, successCallback, failCallback)
    }

    /**
     * 获取通用插件
     * @param pluginName 插件名
     * @param appVersion app版本,默认“1”
     * @param minVersion 插件支持的最小版本
     * @param force 是否强制更新
     * @param successCallback 成功回调,返回解压后插件目录
     * @param failCallback 失败回调,返回错误信息
     */
    fun getCommonPlugin(
        pluginName: String,
        appVersion: String = "1",
        minVersion: Int = 0,
        force: Boolean = false,
        successCallback: ((path: String?) -> Unit)? = null,
        failCallback: ((error: String?) -> Unit)? = null,
        unzipHandler: suspend CoroutineScope.(File, File) -> File = { zipFile, zipDestFile ->
            RnDownloadProgressManager.onProgress(pluginName, RnDownloadProgressManager.PROGRESS_INIT, RnLoadingType.TYPE_SDK_UNZIP)
            val result = runCatching {
                unzipFile(zipFile, zipDestFile)
            }.onSuccess {
                zipFile.delete()
                RnDownloadProgressManager.onProgress(pluginName, RnDownloadProgressManager.PROGRESS_COMPLETE, RnLoadingType.TYPE_SDK_UNZIP)
            }.onFailure {
                LogUtil.e("getCommonPlugin unzipHandler: " + it.printStackTrace())
            }.getOrDefault(File(""))
            result
        }
    ) {
        launch {
            runCatching {
                val config = configRepository.queryPluginConfig(pluginName)
                if (config == null) {
                    LogUtil.i(TAG, "getCommonPlugin: config == null need download")
                    val result =
                        downloadAndUnzip(pluginName, appVersion, 0, null, force, unzipHandler)
                    if (result is Result.Success) {
                        result.data?.let {
                            updateConfig(result.data)
                        }
                        successCallback?.invoke(result.data?.pluginPath)
                    } else if (result is Result.Error) {
                        LogUtil.e(TAG, "getCommonPlugin: downloadAndUnzip error ${result.exception.code} ${result.exception.message}")
                        failCallback?.invoke(result.exception.message)
                    } else {
                        // donothing
                    }
                } else {
                    val (_, pluginVersion, pluginPath, pluginLength, _) = config
                    if (verifyPluginFile(pluginPath, pluginLength)) {
                        if (pluginVersion >= minVersion) {
                            successCallback?.invoke(pluginPath)
                            runCatching {
                                // 静默下载,忽略结果
                                val result =
                                    downloadAndUnzip(
                                        pluginName,
                                        appVersion,
                                        pluginVersion,
                                        pluginPath,
                                        force,
                                        unzipHandler
                                    )
                                LogUtil.i(
                                    TAG,
                                    "getCommonPlugin silent download success: $result, usingPath:$pluginPath"
                                )
                                if (result is Result.Success) {
                                    result.data?.let {
                                        updateConfig(result.data)
                                    }
                                }
                            }.onFailure {
                                LogUtil.e(TAG, "getCommonPlugin silent download fail: $it")
                            }
                        } else {
                            val result =
                                downloadAndUnzip(
                                    pluginName,
                                    appVersion,
                                    0,
                                    pluginPath,
                                    force,
                                    unzipHandler
                                )
                            LogUtil.i(TAG, "getCommonPlugin force update: $result")
                            if (result is Result.Success) {
                                result.data?.let {
                                    updateConfig(result.data)
                                }
                                successCallback?.invoke(result.data?.pluginPath)
                            } else {
                                failCallback?.invoke((result as Result.Error).exception.message)
                            }
                        }
                    } else {
                        val result =
                            downloadAndUnzip(
                                pluginName,
                                appVersion,
                                0,
                                pluginPath,
                                force,
                                unzipHandler
                            )
                        LogUtil.i(TAG, "getCommonPlugin file check fail, re-download: $result")
                        if (result is Result.Success) {
                            result.data?.let {
                                updateConfig(result.data)
                            }
                            successCallback?.invoke(result.data?.pluginPath)
                        } else {
                            failCallback?.invoke((result as Result.Error).exception.message)
                        }
                    }
                }
            }.onFailure {
                LogUtil.e(TAG, "getCommonPlugin onFailure: $it")
                failCallback?.invoke(it.toString())
            }
        }
    }

    /**
     * 查询插件配置信息
     */
    suspend fun queryPluginConfig(pluginName: String) =
        configRepository.queryPluginConfig(pluginName)

    /**
     * 删除插件信息
     */
    suspend fun removePluginConfig(pluginName: String) =
        configRepository.removePluginConfig(pluginName)

    /**
     * 删除插件信息
     */
    fun removePluginConfigSync(pluginName: String) =
        configRepository.removePluginConfigSync(pluginName)

    /**
     * 更新插件配置信息
     */
    suspend fun updateConfig(
        pluginName: String,
        pluginVersion: Int,
        pluginPath: String,
        pluginLength: Long,
        md5: String
    ) = configRepository.updateConfig(pluginName, pluginVersion, pluginPath, pluginLength, md5)

    private suspend fun updateConfig(entity: PluginConfigEntity) = configRepository.updateConfig(entity)

    /**
     * 校验插件文件
     */
    private fun verifyPluginFile(pluginPath: String, pluginLength: Long): Boolean {
        val pluginFile = File(pluginPath)
        LogUtil.i(TAG, "verifyPluginFile: entity == null length: ${pluginFile.length()} ,exists: ${pluginFile.exists()} ,pluginFile: $pluginFile ")
        return pluginPath.contains("android_asset")
                || (pluginFile.exists() && FileUtils.getLength(pluginFile) == pluginLength)
    }

    /**
     * 下载并解压
     */
    private suspend fun downloadAndUnzip(
        pluginName: String,
        appVersion: String,
        currentVersion: Int,
        nowUsingPath: String?,
        force: Boolean = false,
        unzipHandler: suspend CoroutineScope.(File, File) -> File
    ) = withContext(Dispatchers.IO) {
        val updateBean = checkCommonPluginUpgrade(appVersion, pluginName, currentVersion, force)
        if (updateBean == null) {
            // fail
            LogUtil.i(TAG, "downloadAndUnzip: updateBean == null check update fail or no need update")
            Result.Error(DreameException(CODE_UPDATE_FAIL, "check update fail or no need update"))
        } else {
            val result =
                downloadCommonPlugin(updateBean.url, updateBean.md5, pluginTempPath)
            if (result.first) {
                // 解压
                val zipFile = result.second as File
                val destPath = nextVersionPath(pluginName, nowUsingPath)
                val zipDestFile = File(destPath)
                val unzipResult = unzipHandler(zipFile, zipDestFile)
                val fileLength = FileUtils.getLength(unzipResult)
                LogUtil.i(TAG, "downloadAndUnzip: updateConfig $pluginName  $updateBean")

                val entity = PluginConfigEntity(
                    pluginName,
                    updateBean.version,
                    unzipResult.absolutePath,
                    fileLength,
                    ""
                )
                // success
                Result.Success(entity)
            } else {
                // fail
                LogUtil.i(TAG, "downloadAndUnzip: updateBean == null check update fail or no need update")
                Result.Error(
                    DreameException(CODE_UNZIP_FAIL, "unzip file error, file: $result")
                )
            }
        }
    }

    fun nextVersionPath(pluginName: String, currentPath: String?): String {
        val useVersionA = if (TextUtils.isEmpty(currentPath)) {
            true
        } else {
            val file = File(currentPath!!)
            file.exists() && file.name == "version_b"
        }
        return pluginDirPath + File.separator + pluginName + File.separator + if (useVersionA) "version_a" else "version_b"
    }

    /**
     * 检查插件版本
     * @param appVersion
     * @param pluginType 插件类型
     * @param currentVersion 当前使用的版本
     * @param force 是否强更
     */
    private suspend fun checkCommonPluginUpgrade(
        appVersion: String,
        pluginType: String,
        currentVersion: Int,
        force: Boolean = false
    ): UniappVersionBean? = withContext(Dispatchers.IO) {
        var updateBean: UniappVersionBean? = null
        val result = processApiResponse {
            DreameService.queryCommonPluginUpgrade(appVersion, pluginType)
        }
        if (result is Result.Success) {
            result.data?.let {
                val version = it.version
                // 判断是否需要升级,本地版本与服务端不匹配,即升级
                if (version != currentVersion) {
                    // 更新
                    updateBean = it
                } else {
                    if (force) {
                        updateBean = it
                    } else {
                        // 无需更新
                    }
                }
            }
        }
        updateBean
    }

    /**
     * 下载文件
     * @param url 下载路径
     * @param fileMd5 文件md5
     * @param tmpPath 文件缓存路径
     */
    private suspend fun downloadCommonPlugin(
        url: String,
        fileMd5: String,
        tmpPath: String
    ): Pair<Boolean, Any> {
        val f = File(tmpPath)
        if (!f.exists()) {
            f.mkdirs()
        }
        val mDownloadTask = DownloadTask(url, tmpPath, null)
        mDownloadTask.bundleMd5 = fileMd5
        try {
            val task = mDownloadTask.await()
            LogUtil.d(TAG, "downloadCommonPlugin: $task")
            task.file?.let {
                // 下载成功 比较Md5
                val checkPass = calculateFileMd5(it, fileMd5)
                if (!checkPass) {
                    LogUtil.e(TAG, "downloadCommonPlugin: calculateFileMd5 $checkPass")
                    it.delete()
                } else {
                    return true to it
                }
            }
        } catch (e: Exception) {
            LogUtil.e(TAG, "downloadCommonPlugin: $e")
            return false to e
        }
        return false to Exception("download fail, url:$url ,md5:$fileMd5 ,tmpPath:$tmpPath")
    }

    /**
     * 解压文件
     * @param zipFile zip源文件
     * @param destDir 目标目录
     */
    private suspend fun unzipFile(zipFile: File, destDir: File) =
        suspendCancellableCoroutine<File> {
            runCatching {
                if (destDir.exists()) {
                    destDir.delete()
                }
                ZipUtils.unzipFile(zipFile, destDir)
            }.onSuccess { _ ->
                it.resume(destDir)
            }.onFailure { error ->
                it.resumeWithException(error)
            }
        }

    suspend fun DownloadTask.await(): DownloadTask {
        return suspendCancellableCoroutine {
            DownloadFileUtils.downloadFile(this, object : SimpleOnDownloadListener() {
                override fun onError(task: DownloadTask, cause: EndCause, e: Exception) {
                    it.resumeWithException(e)
                }

                override fun onSuccess(task: DownloadTask) {
                    if (it.isCancelled) return
                    it.resume(task)
                }
            })
        }
    }

    private fun calculateFileMd5(file: File, bundleMd5: String): Boolean {
        val fileMD5 = MD5Util.getFileMD5(file)
        return bundleMd5 == fileMD5
    }

}