package android.dreame.module.util.log

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.dreame.module.LocalApplication
import android.dreame.module.data.entry.LogUploadedReq
import android.dreame.module.data.entry.addFormDataPart
import android.dreame.module.data.network.interceptor.HeaderIntercept
import android.dreame.module.data.network.interceptor.TokenInterceptor
import android.dreame.module.task.RetrofitInitTask
import android.dreame.module.util.LogUtil
import android.os.Build
import android.text.TextUtils
import android.util.Log
import androidx.core.text.isDigitsOnly
import com.blankj.utilcode.util.EncryptUtils
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.logging.HttpLoggingInterceptor
import java.io.File
import java.net.Proxy
import java.util.concurrent.TimeUnit

/**
 * debug xlog upload server
 */
object LogUploadServer {
    const val TAG = "LogUploadServer"
    private val mOkHttpClient: OkHttpClient by lazy { initOkhttp() }
    private val deviceType: String = Build.BRAND + " " + Build.MODEL
    private val appVersion = getAPPLocalVersion(LocalApplication.getInstance().applicationContext)

    // 上报日志
    fun uploadAppLocalLog(type: String, msgId: String = ""): Boolean {
        val uploadFiles = mutableListOf<Pair<LogUploadedReq, File>>()
        val lastPairFailedFileList = paramDeviceErrorUploadFile(
            type
        )
        if (lastPairFailedFileList.isNotEmpty()) {
            val lastPairFailed = lastPairFailedFileList[0]
            uploadFiles.add(lastPairFailed)
        }
        val appLogFileList =
            paramUploadFile(type)
        uploadFiles.addAll(appLogFileList)

        val txVideoLogFile = paramTxVideoLog(type)
        uploadFiles.addAll(txVideoLogFile)

        var ret = true
        for (param in uploadFiles) {
            val uploadRet = uploadFile(param.first, param.second, msgId)
            ret = ret.and(uploadRet)
        }
        return ret
    }

    private fun paramDeviceErrorUploadFile(
        type: String,
        firmwareVersion: String = "",
        remark: String = "",
    ): List<Pair<LogUploadedReq, File>> {
        val pluginVersion = ""
        val logFileParent = File(LocalApplication.getInstance().cacheDir.path, "log/device")
        return logFileParent.listFiles()?.map {
            val fileMD5 = EncryptUtils.encryptMD5File2String(it)
            val bean =
                LogUploadedReq(
                    fileMD5,
                    deviceType,
                    type,
                    firmwareVersion,
                    appVersion = appVersion,
                    pluginVersion = pluginVersion,
                    remark = remark
                )
            bean to it
        } ?: emptyList()
    }

    private fun paramUploadFile(type: String): List<Pair<LogUploadedReq, File>> {
        val pluginVersion = ""
        return findXLogFiles()?.map {
            val fileMD5 = EncryptUtils.encryptMD5File2String(it)
            val bean =
                LogUploadedReq(
                    fileMD5,
                    deviceType,
                    type,
                    null,
                    appVersion = appVersion,
                    pluginVersion = pluginVersion,
                    remark = null
                )
            bean to it
        } ?: emptyList()
    }

    /**
     * 查找所有符合条件的文件
     */
    private fun findXLogFiles() =
        runCatching {
            LogUtil.flush()
            File(LocalApplication.getInstance().getExternalFilesDir(""), "xlog/log")
                .listFiles()
                ?.filterNotNull()
                ?.filter {
                    it.name.endsWith(".xlog")
                }?.sortedWith { file1, file2 ->
                    val name1 = file1.name
                    val name2 = file2.name
                    if (name1.isDigitsOnly() && name2.isDigitsOnly()) {
                        (name1.toLong() - name2.toLong()).toInt()
                    } else {
                        val index1 = name1.indexOf("_")
                        val index2 = name2.indexOf("_")
                        val index11 = name1.indexOf(".")
                        val index21 = name2.indexOf(".")
                        name1.substring(index1 + 1, index11).toInt() - name2.substring(
                            index2 + 1,
                            index21
                        ).toInt()
                    }
                }

        }.onFailure {
            LogUtil.e("findXLogFiles:  ${Log.getStackTraceString(it)}")
        }.getOrNull()

    private fun paramTxVideoLog(type: String): List<Pair<LogUploadedReq, File>> {
        val pluginVersion = ""
        val logFileParent = File(LocalApplication.getInstance().filesDir.path, "p2p_logs")
        return logFileParent.listFiles()?.map {
            val fileMD5 = EncryptUtils.encryptMD5File2String(it)
            val bean = LogUploadedReq(
                fileMD5,
                deviceType,
                type,
                null,
                appVersion = appVersion,
                pluginVersion = pluginVersion,
            )
            bean to it
        } ?: emptyList()
    }

    private fun uploadFile(req: LogUploadedReq, file: File, msgId: String = ""): Boolean {
        Log.i(TAG, "uploadFile: ${file.absolutePath},${file.length()}")
        var ret = false
        val requestBody = MultipartBody.Builder().apply {
            setType(MultipartBody.FORM)
            req.addFormDataPart(this)
            addFormDataPart(
                "file",
                file.name,
                file.asRequestBody("application/octet-stream".toMediaType())
            )
            if (!TextUtils.isEmpty(msgId)) {
                addFormDataPart("logPackedRand", msgId)
            }
        }.build()
        val request =
            Request.Builder().url(RetrofitInitTask.getBaseUrl() + "/dreame-resource/file/upload")
                .post(requestBody)
                .build()
        val mRequestCall = mOkHttpClient.newCall(request)
        runCatching {
            val response = mRequestCall.execute()
            var success = false
            if (response.isSuccessful) {
                try {
                    file.delete()
                } catch (e: Exception) {
                    e.printStackTrace()
                }
                success = true
            }
            success
        }.onSuccess {
            ret = it
        }.onFailure {
            ret = false
            LogUtil.e(TAG, "uploadFile error: ${Log.getStackTraceString(it)}, $requestBody")
        }
        return ret
    }

    //获取apk的版本号 currentVersionCode
    private fun getAPPLocalVersion(context: Context): String {
        val manager: PackageManager = context.packageManager
        try {
            val packageInfo: PackageInfo = manager.getPackageInfo(context.packageName, 0)
            return packageInfo.versionName
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }
        return ""
    }

    private fun initOkhttp(): OkHttpClient {
        val logging = HttpLoggingInterceptor { message ->
            LogUtil.i("Dreamehome okhttp", message)
        }
        logging.setLevel(if (LocalApplication.isLogHttpBODY) HttpLoggingInterceptor.Level.HEADERS else HttpLoggingInterceptor.Level.BASIC)
        return OkHttpClient
            .Builder()
            .connectTimeout((10 * 1000).toLong(), TimeUnit.MILLISECONDS)
            .writeTimeout((10 * 1000).toLong(), TimeUnit.MILLISECONDS)
            .readTimeout((10 * 1000).toLong(), TimeUnit.MILLISECONDS)
            .addInterceptor(TokenInterceptor())
            .addInterceptor(HeaderIntercept())
            .addInterceptor(logging)
            .proxy(Proxy.NO_PROXY)
            .build()
    }

}