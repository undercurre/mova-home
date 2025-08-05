package android.dreame.module.data.store

import android.dreame.module.LocalApplication
import android.dreame.module.data.entry.mall.MallLoginRes
import android.dreame.module.util.SPUtil

object MallLoginStore {
    private val mmkv = SPUtil.createPreference(LocalApplication.getInstance(), "mall_account")

    fun saveMallInfo(data: MallLoginRes) {
        mmkv.encode("sessionId", data.sessid)
        mmkv.encode("userId", data.user_id)
        mmkv.encode("timestamp", System.currentTimeMillis())
    }

    fun getMallSessionIdUserId(): Pair<String, String> {
        val sessionId = mmkv.decodeString("sessionId") ?: ""
        val userId = mmkv.decodeString("userId") ?: ""
        val timestamp = mmkv.decodeInt("timestamp")
        return sessionId to userId
    }

    fun clearMallInfo() {
        mmkv.clear()
    }

}