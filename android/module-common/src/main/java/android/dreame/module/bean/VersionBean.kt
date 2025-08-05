package android.dreame.module.bean

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: 作用描述
 * @Date: 2021/5/8 13:37
 * @Version: 1.0
 */
data class VersionBean(
    val url: String,
    val version: Int,
    val extensionId: String?,
    val md5: String = "",
    // 通用资源
    val resPackageId: String?,
    val resPackageVersion: Int,
    val resPackageUrl: String?,
    val resPackageZipMd5: String?,
    // 复制于公共扩展程序的ID
    val sourceCommonExtensionId: String?,
    // 复制于公共插件的ID
    val sourceCommonPluginId: String?,
    // 复制于公共插件的版本
    val sourceCommonPluginVer: Int?,

)

data class UniappVersionBean(val url: String, val version: Int, val md5: String)