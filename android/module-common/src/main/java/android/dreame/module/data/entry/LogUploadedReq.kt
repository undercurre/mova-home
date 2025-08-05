package android.dreame.module.data.entry

import okhttp3.MultipartBody


data class LogUploadedReq(
    /**
     * 文件Md5
     */
    val md5: String,
    /**
     * 手机型号
     */
    val deviceType: String,
    /**
     * 日志类型
     */
    val type: String = "",
    /**
     * 固件版本
     */
    val firmwareVersion: String?,
    /**
     * APP版本
     */
    val appVersion: String = "",
    /**
     * 插件版本
     */
    val pluginVersion: String = "",
    /**
     * 平台：1：IOS 2：Android 3: web
     */
    val platform: Int = 2,
    /**
     * 备注
     */
    val remark: String? = "",

    )

fun LogUploadedReq.addFormDataPart(builder: MultipartBody.Builder) {
    builder.addFormDataPart("md5", md5)
    builder.addFormDataPart("deviceType", deviceType)
    builder.addFormDataPart("type", type)
    builder.addFormDataPart("firmwareVersion", firmwareVersion ?: "")
    builder.addFormDataPart("appVersion", appVersion)
    builder.addFormDataPart("pluginVersion", pluginVersion)
    builder.addFormDataPart("platform", platform.toString())
    builder.addFormDataPart("remark", remark ?: "")
}


