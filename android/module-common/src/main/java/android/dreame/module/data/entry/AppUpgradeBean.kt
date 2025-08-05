package android.dreame.module.data.entry

import com.google.gson.JsonObject

data class AppUpgradeBean(
    var version: Long? = 0,
    val versionName: String?,
    val fileSize: Long? = 0,
    val downloadUrl: String?,
    val downFirst: Boolean,
    val hash: String?,
    val minVersion: Long? = 0,
    private val isForce: Int? = 0,
    val localizationDisplayNames: JsonObject?
) {
    fun isForce() = isForce == 1
}

data class VersionTipBean(var hasNewVersion: Boolean, var versionName: String?)