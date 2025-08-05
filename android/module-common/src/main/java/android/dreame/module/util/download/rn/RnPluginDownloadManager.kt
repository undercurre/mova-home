package android.dreame.module.util.download.rn

import android.dreame.module.BuildConfig
import android.dreame.module.bean.VersionBean
import android.dreame.module.data.Result
import android.dreame.module.data.db.PluginInfoEntity
import android.dreame.module.data.db.STATUS_IN_USE
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.exception.DreameException
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.DebugManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ExceptionStatisticsEventCode
import android.dreame.module.trace.ModuleCode
import android.dreame.module.util.LogUtil
import android.dreame.module.util.MD5Util
import android.dreame.module.util.download.*
import android.dreame.module.util.download.rn.RnDownloadProgressManager.PROGRESS_COMPLETE
import android.dreame.module.util.download.rn.RnDownloadProgressManager.PROGRESS_INIT
import android.dreame.module.util.download.rn.RnPluginConstants.PLUGIN_PLUGIN_BUNDLE_NAME
import android.dreame.module.util.download.rn.RnPluginConstants.PLUGIN_SDK_BUNDLE_NAME
import android.dreame.module.util.download.rn.RnPluginInfoHelper.CODE_UNZIP_FAIL
import android.dreame.module.util.download.rn.RnPluginInfoHelper.CODE_UPDATE_FAIL
import android.dreame.module.util.download.rn.RnPluginInfoHelper.pluginDirPath
import android.dreame.module.util.download.rn.RnPluginInfoHelper.pluginTempPath
import android.text.TextUtils
import com.blankj.utilcode.util.FileUtils
import com.blankj.utilcode.util.ZipUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import java.io.File
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

/**
 * RN插件下载,更新,解压管理
 */
internal object RnPluginDownloadManager {
    private const val TAG = "RnPluginDownloadManager"

    /**
     * 检查更新
     */
    suspend fun checkoutPluginVersion(pluginName: String, force: Boolean = false) = runCatching {
        // 查询当前可用的插件
        val entity = if (pluginName.equals(RnPluginConstants.PLUGIN_SDK_NAME, true)) {
            RnPluginInfoHelper.getRnSDKPluginUse()
        } else {
            RnPluginInfoHelper.getRnPluginUse(pluginName)
        }
        // 不存在，则直接下载
        if (entity == null) {
            LogUtil.i(TAG, "checkoutPluginVersion: entity == null  $pluginName")
            val result = downloadAndUnzipPluginAndRes(pluginName, 0, 0, null, force)

            if (result is Result.Success) {
                // 插入数据库
                result.data?.let {
                    RnPluginInfoHelper.updateConfig(result.data)
                }
                RnDownloadProgressManager.onComplete(pluginName, RnLoadingType.TYPE_SDK_COMPLETE)
                return@runCatching true
            } else {
                if (result is Result.Error) {
                    RnDownloadProgressManager.onError(pluginName, result.exception, RnLoadingType.TYPE_SDK_ERROR)
                }
                LogUtil.i(TAG, "getCommonPlugin file check fail, $pluginName  download: $result")
                return@runCatching false
            }
        } else {
            // 存在，则比较有更新才下载
            val pluginLength = entity.pluginLength
            val pluginMd5 = entity.pluginMd5
            val pluginPath = entity.pluginPath
            val pluginVersion = entity.pluginVersion

            val resPackageZipMd5 = entity.pluginResMd5
            val resPackagePath = entity.pluginResPath
            val resPackageVersion = entity.pluginResVersion

            if (verifyPluginFile(pluginPath, pluginLength, pluginMd5) && verifyPluginFile(resPackagePath, 0, resPackageZipMd5)) {
                RnDownloadProgressManager.onComplete(pluginName, RnLoadingType.TYPE_SDK_COMPLETE)
                runCatching {
                    // 静默下载,忽略结果
                    LogUtil.i(TAG, "checkoutPluginVersion: $pluginName 静默下载,忽略结果 ")
                    val result = downloadAndUnzipPluginAndRes(pluginName, pluginVersion, resPackageVersion, pluginPath, force, entity)
                    if (result is Result.Success) {
                        // 插入数据库
                        result.data?.let {
                            RnPluginInfoHelper.updateConfig(result.data)
                        }
                    }
                    LogUtil.i(TAG, "checkoutPluginVersion silent download success $pluginName : $result, usingPath:$pluginPath")
                }.onFailure {
                    LogUtil.e(TAG, "checkoutPluginVersion silent download fail $pluginName : $it")
                }
                return@runCatching true
            } else {
                // 本地文件校验失败，则重新下载
                LogUtil.i(TAG, "checkoutPluginVersion: $pluginName 本地文件校验失败，则重新下载 ")
                RnPluginInfoHelper.deleteRnPluginUse(pluginName)
                val result = downloadAndUnzipPluginAndRes(pluginName, 0, 0, null, force)
                LogUtil.i(TAG, "getCommonPlugin file check fail, $pluginName  re-download: $result")
                if (result is Result.Success) {
                    // 插入数据库
                    result.data?.let {
                        RnPluginInfoHelper.updateConfig(result.data)
                    }
                    RnDownloadProgressManager.onComplete(pluginName, RnLoadingType.TYPE_SDK_COMPLETE)
                    return@runCatching true
                } else {
                    if (result is Result.Error) {
                        RnDownloadProgressManager.onError(pluginName, result.exception, RnLoadingType.TYPE_SDK_ERROR)
                    }
                    return@runCatching false
                }
            }

        }
    }.getOrDefault(false)

    private suspend fun downloadAndUnzipPluginAndRes(
        pluginName: String,
        currentVersion: Int,
        currentResPackageVersion: Int,
        nowUsingPath: String?,
        force: Boolean = false,
        entity: PluginInfoEntity? = null,
        appVersion: Int = BuildConfig.PLUGIN_APP_VERSION
    ) = withContext(Dispatchers.IO) {

        // 查询接口
        RnDownloadProgressManager.onProgress(pluginName, PROGRESS_INIT, RnLoadingType.TYPE_SDK_QUERY)
        val updateBean = checkCommonPluginUpgrade(appVersion, pluginName, currentVersion)
        RnDownloadProgressManager.onProgress(pluginName, PROGRESS_COMPLETE, RnLoadingType.TYPE_SDK_QUERY)

        if (updateBean == null) {
            // fail
            LogUtil.i(TAG, "$pluginName  $currentVersion downloadAndUnzip:updateBean == null check update fail or no need update")
            Result.Error(DreameException(CODE_UPDATE_FAIL, "check update fail or no need update"))
        } else {
            if (entity == null || force || currentVersion != updateBean.version) {
                val result = downloadAndUnzip(pluginName, currentVersion, nowUsingPath, updateBean, currentResPackageVersion, entity?.pluginResPath)
                return@withContext result
            } else if (force || currentResPackageVersion != updateBean.resPackageVersion) {
                val result = downloadAndUnzipCommonRes(pluginName, updateBean, pluginTempPath, currentResPackageVersion, entity.pluginResPath)
                if (result.first > 0 && !result.second.isNullOrBlank()) {
                    Result.Success(
                        entity.copy(
                            pluginResId = updateBean.resPackageId ?: "",
                            pluginResLength = result.first,
                            pluginResVersion = updateBean.resPackageVersion,
                            pluginResUrl = "",
                            pluginResMd5 = updateBean.resPackageZipMd5 ?: "",
                            pluginResPath = result.second ?: "",
                            commonPluginVer = updateBean.sourceCommonPluginVer ?: 0,
                            updateTime = System.currentTimeMillis()
                        )
                    )
                } else {
                    Result.Error(DreameException(CODE_UPDATE_FAIL, "res update fail or no need update"))
                }
            } else {
                Result.Error(DreameException(CODE_UPDATE_FAIL, "check update fail or no need update"))
            }
        }

    }

    private suspend fun downloadAndUnzip(
        pluginName: String,
        currentVersion: Int,
        nowUsingPath: String?,
        updateBean: VersionBean,
        currentResPackageVersion: Int,
        nowResUsingPath: String?,
        unzipHandler: suspend CoroutineScope.(File, File) -> File = { zipFile, zipDestFile ->
            RnDownloadProgressManager.onProgress(pluginName, PROGRESS_INIT, RnLoadingType.TYPE_SDK_UNZIP)
            val result = runCatching {
                unzipFile(zipFile, zipDestFile, pluginName)
            }.onSuccess {
                zipFile.delete()
                RnDownloadProgressManager.onProgress(pluginName, PROGRESS_COMPLETE, RnLoadingType.TYPE_SDK_UNZIP)
            }.onFailure {
                eventCommonPageInsert(3, pluginName, currentVersion)
                LogUtil.e("unzipHandler: " + it.printStackTrace())
            }.getOrDefault(File(""))
            result
        }
    ) = withContext(Dispatchers.IO) {
        // 下载资源
        var resResult = downloadAndUnzipCommonRes(pluginName, updateBean, pluginTempPath, currentResPackageVersion, nowResUsingPath)

        val result = downloadRnPlugin(pluginName, updateBean.url, updateBean.md5, pluginTempPath, currentVersion)
        if (resResult.first < 0) {
            // 重新下载资源
            LogUtil.e("downloadAndUnzipCommonRes again ---------------- ")
            resResult = downloadAndUnzipCommonRes(pluginName, updateBean, pluginTempPath, currentResPackageVersion, nowResUsingPath)
        }
        if (resResult.first < 0) {
            return@withContext Result.Error(DreameException(CODE_UNZIP_FAIL, "downloadAndUnzip res download fail"))
        }
        if (result.first) {
            // 解压
            val zipFile = result.second as File
            val destPath = nextVersionPath(pluginName, nowUsingPath)
            val zipDestFile = File(destPath)
            val unzipResult = unzipHandler(zipFile, zipDestFile)
            // 校验bundle md5
            val bundlePair = checkBundleMd5(unzipResult, pluginName, updateBean.md5, currentVersion)
            LogUtil.i(
                TAG,
                "downloadAndUnzip: -------  pluginName: $pluginName ,version: ${updateBean.version} ,md5: ${updateBean.md5} ,length: ${bundlePair.first} ,path: ${bundlePair.second} ,bean: $updateBean"
            )
            if (bundlePair.first > 0) {
                val fileLength = bundlePair.first
                val filePath = bundlePair.second
                val entity = PluginInfoEntity(
                    pluginName, fileLength, updateBean.md5, updateBean.version,
                    updateBean.version, filePath, "", updateBean.resPackageId ?: "",
                    resResult.first,
                    updateBean.resPackageVersion,
                    "",
                    updateBean.resPackageZipMd5 ?: "",
                    resResult.second ?: "",
                    commonPluginVer = updateBean.sourceCommonPluginVer ?: 0,
                    STATUS_IN_USE
                )
                // success
                Result.Success(entity)
            } else {
                LogUtil.e(TAG, "downloadAndUnzip: deleteAllInDir-------  $pluginName $destPath")
                FileUtils.deleteAllInDir(destPath)
                Result.Error(DreameException(CODE_UNZIP_FAIL, "bundle md5 file error, file: $result"))
            }
        } else {
            // fail
            LogUtil.e(TAG, "downloadAndUnzip: unzip file error, file")
            Result.Error(DreameException(CODE_UNZIP_FAIL, "unzip file error, file: $result"))
        }
    }

    /**
     * 下载插件的通用资源
     */
    private suspend fun downloadAndUnzipCommonRes(
        pluginName: String,
        updateBean: VersionBean,
        pluginTempPath: String,
        currentResPackageVersion: Int,
        nowUsingPath: String?,
    ): Pair<Long, String?> {
        if (updateBean.resPackageUrl.isNullOrBlank()) {
            return 0L to null
        } else {
            val resResult: Pair<Boolean, Any> =
                downloadRnPlugin(pluginName, updateBean.resPackageUrl, updateBean.resPackageZipMd5 ?: "", pluginTempPath, currentResPackageVersion)
            LogUtil.i(TAG, "downloadAndUnzipCommonRes: -------  pluginName: $pluginName ,resResult: $resResult ,updateBean: $updateBean")
            if (resResult.first) {
                val destPath = nextVersionPath(pluginName + File.separator + "res", nowUsingPath)
                val zipDestFile = File(destPath)

                val zipFile = resResult.second as File
                // 校验md5
                val md5 = FileUtils.getFileMD5ToString(zipFile)
                if (updateBean.resPackageZipMd5.equals(md5, true)) {
                    // 解压 res
                    val ret = runCatching {
                        unzipFile(zipFile, zipDestFile, pluginName)
                    }.onSuccess {
                        zipFile.delete()
                    }.onFailure {
                        it.printStackTrace()
                        LogUtil.e(
                            TAG,
                            "downloadAndUnzipCommonRes: -------  pluginName: $pluginName ,resPackageVersion: ${updateBean.resPackageVersion} downloadAndUnzipCommonRes fail unzip error"
                        )
                    }.getOrNull()

                    ret?.let {
                        return it.length() to it.path
                    } ?: return -1L to "$pluginName downloadAndUnzipCommonRes fail unzip error"
                } else {
                    LogUtil.e(
                        TAG,
                        "downloadAndUnzipCommonRes: -------  pluginName: $pluginName ,resPackageVersion: ${updateBean.resPackageVersion} downloadAndUnzipCommonRes fail md5 error"
                    )
                    return -1L to "$pluginName downloadAndUnzipCommonRes fail md5 error"
                }
            } else {
                LogUtil.e(
                    TAG,
                    "downloadAndUnzipCommonRes: -------  pluginName: $pluginName ,resPackageVersion: ${updateBean.resPackageVersion} downloadAndUnzipCommonRes fail"
                )
                return -1L to "$pluginName downloadAndUnzipCommonRes fail"
            }
        }
    }

    private suspend fun eventCommonPageInsert(int2: Int, pluginName: String, currentVersion: Int) {
        if (pluginName.equals(RnPluginConstants.PLUGIN_SDK_NAME, true)) {
            EventCommonHelper.eventCommonPageInsert(ModuleCode.ExceptionStatistics.code, ExceptionStatisticsEventCode.SdkDownloadFail.code, 0, 0, currentVersion, int2, 0, 0, BuildConfig.PLUGIN_APP_VERSION)
        } else {
            val rnSDKPluginUse = RnPluginInfoHelper.getRnSDKPluginUse()
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.ExceptionStatistics.code, ExceptionStatisticsEventCode.PluginDownloadFail.code,
                0,
                currentVersion,
                rnSDKPluginUse?.pluginVersion ?: 0,
                int2,
                0,
                0,
                BuildConfig.PLUGIN_APP_VERSION
            )
        }
    }

    private suspend fun checkBundleMd5(zipDestFile: File, moduleName: String, md5: String, currentVersion: Int): Pair<Long, String> {
        val bundleName = if (moduleName.equals(RnPluginConstants.PLUGIN_SDK_NAME, true)) {
            PLUGIN_SDK_BUNDLE_NAME
        } else {
            PLUGIN_PLUGIN_BUNDLE_NAME
        }
        val bundleFile = File(zipDestFile.absolutePath, moduleName + File.separator + bundleName)
        if (!bundleFile.exists()) {
            eventCommonPageInsert(4, moduleName, currentVersion)
            LogUtil.e(TAG, "checkBundleMd5: bundle is not exist $bundleFile")
            return 0L to ""
        }
        val fileMD5 = MD5Util.getFileMD5(bundleFile)
        if (md5.equals(fileMD5, true)) {
            return bundleFile.length() to bundleFile.path
        } else {
            eventCommonPageInsert(4, moduleName, currentVersion)
            LogUtil.e(TAG, "checkBundleMd5: bundle is not exist $bundleFile $fileMD5 $md5")
            return -1L to ""
        }
    }

    /**
     * 检查插件版本
     * @param appVersion
     * @param moduleName 插件类型
     * @param currentVersion 当前使用的版本
     * @param force 是否强更
     */
    private suspend fun checkCommonPluginUpgrade(
        appVersion: Int,
        moduleName: String,
        currentVersion: Int,
    ): VersionBean? = withContext(Dispatchers.IO) {
        var updateBean: VersionBean? = null
        val result = processApiResponse {
            if (moduleName.equals(RnPluginConstants.PLUGIN_SDK_NAME, true)) {
                DreameService.checkoutSDKPluginVersion(appVersion)
            } else {
                DreameService.checkoutPluginVersion(moduleName, appVersion)
            }
        }
        LogUtil.d(TAG, "checkCommonPluginUpgrade: $result")
        if (result is Result.Success) {
            result.data?.let {
                val version = it.version
                if (version <= 0) {
                    LogUtil.e(TAG, "checkCommonPluginUpgrade: onError version <= 0")
                    RnDownloadProgressManager.onError(moduleName, null, RnLoadingType.TYPE_SDK_QUERY_ERROR)
                } else {
                    updateBean = it
                }
            }
        } else if (result is Result.Error) {
            eventCommonPageInsert(1, moduleName, currentVersion)
        }
        updateBean
    }

    /**
     * 下载文件
     * @param url 下载路径
     * @param fileMd5 文件md5
     * @param tmpPath 文件缓存路径
     */
    private suspend fun downloadRnPlugin(
        moduleName: String,
        url: String,
        fileMd5: String,
        tmpPath: String,
        currentVersion: Int,
    ): Pair<Boolean, Any> {
        val f = File(tmpPath)
        if (!f.exists()) {
            f.mkdirs()
        }
        val mDownloadTask = DownloadTask(url, tmpPath, null)
        mDownloadTask.bundleMd5 = fileMd5
        try {
            RnDownloadProgressManager.onProgress(moduleName, PROGRESS_INIT, RnLoadingType.TYPE_SDK_DOWNLOAD)
            val task = mDownloadTask.await(moduleName)
            RnDownloadProgressManager.onProgress(moduleName, PROGRESS_COMPLETE, RnLoadingType.TYPE_SDK_DOWNLOAD)
            task.file?.let {
                return true to it
            }
        } catch (e: Exception) {
            LogUtil.e(TAG, "downloadCommonPlugin: $moduleName  $e")
            eventCommonPageInsert(2, moduleName, currentVersion)
            return false to e
        }
        return false to Exception("download fail, url:$url ,md5:$fileMd5 ,tmpPath:$tmpPath")
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
     * 解压文件
     * @param zipFile zip源文件
     * @param destDir 目标目录
     */
    private suspend fun unzipFile(zipFile: File, destDir: File, pluginName: String) =
        suspendCancellableCoroutine<File> {
            runCatching {
                if (destDir.exists()) {
                    destDir.delete()
                }
                val resultList = ZipUtils.unzipFile(zipFile, destDir)
                if (resultList.isNotEmpty()) {
                    val unzipDir = resultList.firstOrNull {
                        it.name.contains(PLUGIN_PLUGIN_BUNDLE_NAME)
                    }?.parentFile
                    // 如果解压后的插件与实际插件名不匹配,需要重命名为实际的插件名
                    if (pluginName != RnPluginConstants.PLUGIN_SDK_NAME && pluginName != unzipDir?.name) {
                        FileUtils.rename(unzipDir, pluginName)
                    }
                }
            }.onSuccess { _ ->
                it.resume(destDir)
            }.onFailure { error ->
                it.resumeWithException(error)
            }
        }

    /**
     * 校验插件文件
     * @param pluginPath
     * @param pluginLength <=0 跳过length检查，直接检查md5
     * @param md5
     */
    fun verifyPluginFile(pluginPath: String, pluginLength: Long, md5: String): Boolean {
        if (!DebugManager.enableCheckPluginMd5) {
            return true
        }
        val skipLength = pluginLength <= 0
        val pluginFile = File(pluginPath)
        val length = if (skipLength) 0L else FileUtils.getLength(pluginFile)
        if (skipLength || length == pluginLength) {
            val md5Plugin = FileUtils.getFileMD5ToString(pluginFile)
            return md5Plugin.equals(md5, true)
        }
        LogUtil.i(TAG, "verifyPluginFile: entity == null length: ${pluginFile.length()} ,exists: ${pluginFile.exists()} ,pluginFile: $pluginFile ")
        return false
    }

    private suspend fun DownloadTask.await(moduleName: String): DownloadTask {
        return suspendCancellableCoroutine {
            DownloadFileUtils.downloadFile(this, object : SimpleOnDownloadListener() {
                override fun onError(task: DownloadTask, cause: EndCause, e: Exception) {
                    it.resumeWithException(e)
                }

                override fun onProcess(task: DownloadTask, process: Int) {
                    super.onProcess(task, process)
                    RnDownloadProgressManager.onProgress(moduleName, process, RnLoadingType.TYPE_SDK_DOWNLOAD)
                }

                override fun onSuccess(task: DownloadTask) {
                    if (it.isCancelled) return
                    it.resume(task)
                }
            })
        }
    }

}