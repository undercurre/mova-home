package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/07
 *     desc   :
 *     version: 1.0
 * </pre>
 */

data class FileUploadRes(
    val encryptPassword: String,
    val expiresTime: Long,
    val method: String,
    val objectName: String,
    val url: String,
    val uploadUrl: String,
)