package android.dreame.module.manager

import android.content.Context
import android.dreame.module.LocalApplication

/**
 * deviceToken 管理
 */
object PushDeviceTokenSpManager {
    private const val FILENAME = "PUSH_DATA"
    private const val KEY_DEVICE_TOKEN = "key_device_token"
    // 控制更新deviceToken
    private const val KEY_DEVICE_TOKEN_REGISTER = "key_device_token_register"

    //从alias推送改成deviceToken推送后，解决老版本key和deviceToken相同，推送两次的问题，
    // 先用deviceToken当成key，来删除一下老的key
    private const val KEY_DELETE_HISTORY = "key_delete_history"

    private val pushDeviceSp =
        LocalApplication.getInstance().getSharedPreferences(FILENAME, Context.MODE_PRIVATE)

//    /**
//     *  是否刷新deviceToken
//     */
//    @Synchronized
//    fun needRefreshPush(): Boolean {
//        val account = AccountManager.getInstance().getAccount()
//        if (account != null && account.uid != null) {
//            val deviceTokenTimestamp = pushDeviceSp.getLong("${account.uid}_${AreaManager.getRegion()}", 0L)
//            val key = "${account.uid}_${AreaManager.getRegion()}_${KEY_DEVICE_TOKEN_REGISTER}"
//            val keyDeviceTokenRegister = pushDeviceSp.getInt(key, -1)
//            if (keyDeviceTokenRegister <= 0) {
//                return true
//            }
//            val currentThreadTimeMillis = System.currentTimeMillis()
//            // 7天
//            return currentThreadTimeMillis - deviceTokenTimestamp > 7 * 24 * 60 * 1000
//        } else {
//            return false
//        }
//    }

//    /**
//     * push/devices 是否调用成功
//     */
//    @Synchronized
//    fun isNeedRegisterPush(): Boolean {
//        val account = AccountManager.getInstance().getAccount()
//        if (account != null && account.uid != null) {
//            var deviceTokenTimestamp =
//                pushDeviceSp.getLong("${account.uid}_${AreaManager.getRegion()}", 0L)
//            return deviceTokenTimestamp == 0L
//        } else {
//            return false
//        }
//    }
//
//    /**
//     *  刷新deviceToken 时间戳
//     */
//    @Synchronized
//    fun setPushTime() {
//        val account = AccountManager.getInstance().getAccount()
//        val key = "${account.uid}_${AreaManager.getRegion()}_${KEY_DEVICE_TOKEN_REGISTER}"
//        val deviceTokenTimestamp: Long = System.currentTimeMillis();
//        pushDeviceSp.edit()
//            .putLong(AccountManager.getInstance().getAccount().uid + "_" + AreaManager.getRegion(), deviceTokenTimestamp)
//            .putInt(key, 1)
//            .apply()
//    }

    /**
     *  清空数据
     */
    @Synchronized
    fun clearDefaultData() {
        pushDeviceSp.edit().clear().apply()
    }

    fun getDeviceToken(): String {
        return pushDeviceSp.getString(KEY_DEVICE_TOKEN, "") ?: ""
    }

    fun saveDeviceToken(deviceToken: String?) {
        pushDeviceSp.edit().putString(KEY_DEVICE_TOKEN, deviceToken).apply()
    }

    fun isDeleteHistoryKey() = pushDeviceSp.getBoolean(KEY_DELETE_HISTORY,false)

    fun saveDeleteHistoryKey() = pushDeviceSp.edit().putBoolean(KEY_DELETE_HISTORY,true).apply()

    fun deleteDeviceToken() {
        val account = AccountManager.getInstance().getAccount()
        val key = "${account.uid}_${AreaManager.getRegion()}_${KEY_DEVICE_TOKEN_REGISTER}"
        pushDeviceSp.edit()
            .remove(KEY_DEVICE_TOKEN)
            .remove(key)
            .apply()
    }
}