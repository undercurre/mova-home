package android.dreame.module.rn.load

import android.dreame.module.rn.bridge.rawdata.DiskLruCachePic
import android.dreame.module.util.LogUtil
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch

object RnCacheManager {
    const val TAG = "RnCacheManager"

    fun clearAllCache() {
        LogUtil.i(TAG, "clearAllCache: ")
        MainScope().launch {
            flow<Boolean> {
                try {
                    DiskLruCachePic.clear()
                    emit(true)
                } catch (e: Exception) {
                    LogUtil.e(TAG, "clearAllCache error: ${Log.getStackTraceString(e)}")
                    e.printStackTrace()
                }
            }.flowOn(Dispatchers.IO).collect {
            }
        }
        RnLoaderCache.clearCache()
    }

    fun clearCacheByDid(deviceId: String?) {
        LogUtil.i(TAG, "clearCacheByDid: $deviceId")
        deviceId?.let {
            RnLoaderCache.removeRnHost(deviceId)
        }
    }

    fun loadTimesIncrement() {
        LogUtil.i(TAG, "loadTimesIncrement:")
        RnLoaderCache.loadTimesIncrement(40)
    }
}