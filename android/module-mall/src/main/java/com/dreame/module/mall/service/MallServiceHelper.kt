package com.dreame.module.mall.service

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.MallLocalDataSource
import android.dreame.module.data.datasource.remote.MallRemoteDataSource
import android.dreame.module.data.entry.mall.MallLoginReq
import android.dreame.module.data.entry.mall.MallLoginRes
import android.dreame.module.data.repostitory.MallRepository
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.util.LogUtil
import android.os.SystemClock
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.sync.Semaphore
import org.json.JSONObject

data class DreameMallUIBean(
    val sessionId: String,
    val userId: String,
    val timestamp: Long,
    val coupon: Int,
    val score: Int
)

class MallServiceHelper : CoroutineScope by MainScope() {

    private val mallRepository by lazy { MallRepository(MallLocalDataSource(), MallRemoteDataSource()) }
    private val semaphore = Semaphore(1)
    private val _liveData = MutableLiveData<DreameMallUIBean>()

    val liveData: LiveData<DreameMallUIBean> = _liveData

    suspend fun mallLoginSync(): String {
        LogUtil.i("UNIAPP", "mallLoginSync: ----1--- ${Thread.currentThread().name} ${android.os.Process.myPid()}")
        try {
            if (!semaphore.tryAcquire()) {
                semaphore.acquire()
                val composeJson = composeJson()
                Log.e("UNIAPP", "mallLoginSync: ----tryAcquire--- $composeJson")
                if (composeJson.isNotEmpty()) {
                    return composeJson
                }
            }

            if ("cn".equals(AreaManager.getCountryCode(), true)) {
                if (!AccountManager.getInstance().userInfo.phone.isNullOrEmpty()) {
                    val token = AccountManager.getInstance().account?.access_token ?: ""
                    val result = mallRepository.mallLoginSync(MallLoginReq(token))
                    LogUtil.i("UNIAPP", "mallLoginSync: ----2--- ${semaphore.availablePermits}  $result ")
                    handleMallLoginResultData(result)
                    LogUtil.i("UNIAPP", "mallLoginSync:----3--- ${semaphore.availablePermits} ${composeJson()}")
                    return composeJson()
                }
            }
            return "{}"
        } catch (e: Exception) {
            e.printStackTrace()
            return "{}"
        } finally {
            LogUtil.i("UNIAPP", "mallLoginSync: ----5--- ${Thread.currentThread().name} ${android.os.Process.myPid()}")
            if (semaphore.availablePermits == 0) {
                semaphore.release()
            }
            LogUtil.i("UNIAPP", "mallLoginSync: ----6--- ${Thread.currentThread().name} ${android.os.Process.myPid()}")
        }
    }

    fun composeJson(): String {
        return runCatching {
            val jsonObject = JSONObject()
            liveData.value?.let {
                jsonObject.put("sessid", it.sessionId)
                jsonObject.put("user_id", it.userId)
                jsonObject.toString()
            } ?: "{}"
        }.getOrDefault("{}")
    }


    fun mallPersonInfo() {

    }

    suspend fun queryMallPersonInfo(): Map<String, String> {
        var sessionId: String = liveData.value?.sessionId ?: ""
        var userId: String = liveData.value?.userId ?: ""
        if (sessionId.isEmpty() || userId.isEmpty()) {
            mallLoginSync()
            sessionId = liveData.value?.sessionId ?: ""
            userId = liveData.value?.userId ?: ""
        }
        LogUtil.d("UNIAPP", "queryMallPersonInfo: sessionId = $sessionId ,userId = $userId")
        if (sessionId.isEmpty() || userId.isEmpty()) {
            return emptyMap()
        }
        val result = mallRepository.mallPersonInfoSync(sessionId, userId)
        if (result is Result.Success) {
            result.data?.let {
                _liveData.postValue(
                    liveData.value?.copy(
                        coupon = it.coupon,
                        score = it.point
                    ) ?: DreameMallUIBean("", "", 0, it.coupon, it.point)
                )
                return mapOf("coupon" to it.coupon.toString(), "score" to it.point.toString())
            }
            return emptyMap()
        } else if (result is Result.Error) {
            if (result.exception.code == -100) {
                // session is  invalid or overdue
                return mapOf("code" to (-100).toString())
            }
        }
        return emptyMap()
    }


    private fun handleMallLoginResultData(result: Result<MallLoginRes>) {
        LogUtil.i("UNIAPP", "handleMallLoginResultData: ----0--- ${semaphore.availablePermits}")
        if (result is Result.Success) {
            result.data?.let {
                LogUtil.d("UNIAPP", "handleMallLoginResultData: ----1--- ${semaphore.availablePermits} ,sessid: ${it.sessid} ,user_id: ${it.user_id}")
                _liveData.value =
                    liveData.value?.copy(
                        sessionId = it.sessid,
                        userId = it.user_id,
                        timestamp = SystemClock.elapsedRealtime()
                    ) ?: DreameMallUIBean(sessionId = it.sessid, userId = it.user_id, timestamp = SystemClock.elapsedRealtime(), 0, 0)

            }
            LogUtil.d("UNIAPP", "handleMallLoginResultData: ----5--- ${semaphore.availablePermits}")
        } else if (result is Result.Error) {

        }
        LogUtil.d("UNIAPP", "handleMallLoginResultData: ----6--- ${semaphore.availablePermits}")
    }

    fun logoutClear() {
        _liveData.value = DreameMallUIBean(sessionId = "", userId = "", timestamp = 0, 0, 0)
    }


}