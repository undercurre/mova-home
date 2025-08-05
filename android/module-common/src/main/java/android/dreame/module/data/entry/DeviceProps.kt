package android.dreame.module.data.entry

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/04/11
 *     desc   :
 *     version: 1.0
 * </pre>
 */

data class DevicePropsReq(
    val did: String,
    val keys: String
)

data class DevicePropsRes(
    val key: String,
    val updateDate: String,
    val value: String
)