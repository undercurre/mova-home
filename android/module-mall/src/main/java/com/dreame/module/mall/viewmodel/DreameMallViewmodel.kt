package com.dreame.module.mall.viewmodel

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.MallLocalDataSource
import android.dreame.module.data.datasource.remote.MallRemoteDataSource
import android.dreame.module.data.entry.mall.MallLoginReq
import android.dreame.module.data.entry.mall.MallLoginRes
import android.dreame.module.data.repostitory.MallRepository
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.LogUtil
import android.os.SystemClock
import android.util.Log
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Semaphore
import org.json.JSONObject

class DreameMallViewModel : BaseViewModel<DreameMallUIState, DreameMallUiEvent>() {
    private val mallRepository by lazy { MallRepository(MallLocalDataSource(), MallRemoteDataSource()) }

    private val semaphore = Semaphore(1)

    override fun createInitialState(): DreameMallUIState {
        return DreameMallUIState(
            "", "", 0, 0, 0
        )
    }

    override fun dispatchAction(acton: UiAction) {
        if (acton is DreameMallUiAction.DreameMallLoginAction) {
            mallLogin()
        } else if (acton is DreameMallUiAction.DreameMallPersonInfoAction) {
            mallPersonInfo()
        }
    }

    fun needReloadNewMallUrl(url: String, newUrl: String): Boolean {
        return url.substring(0, url.indexOf("?")) != newUrl.substring(0, newUrl.indexOf("?"))
    }

    suspend fun mallLoginSync(): String {
        LogUtil.i("UNIAPP", "mallLoginSync: ----1--- ${Thread.currentThread().name} ${android.os.Process.myPid()}")
        try {
            if (!semaphore.tryAcquire()) {
                semaphore.acquire()
                Log.e("UNIAPP", "mallLoginSync: ----tryAcquire---")
                val composeJson = composeJson()
                if (composeJson.isNotEmpty()) {
                    return composeJson
                }
            }
            val token = AccountManager.getInstance().account?.access_token ?: ""
            val result = mallRepository.mallLoginSync(MallLoginReq(token))
            LogUtil.i("UNIAPP", "mallLoginSync: ----2--- ${semaphore.availablePermits}")
            handleMallLoginResultData(result)
            LogUtil.i("UNIAPP", "mallLoginSync:----3--- ${semaphore.availablePermits}")
            return composeJson()
        } catch (e: Exception) {
            e.printStackTrace()
            return ""
        } finally {
            LogUtil.i("UNIAPP", "mallLoginSync: ----5--- ${Thread.currentThread().name} ${android.os.Process.myPid()}")
            if (semaphore.availablePermits == 0) {
                semaphore.release()
            }
            LogUtil.i("UNIAPP", "mallLoginSync: ----6--- ${Thread.currentThread().name} ${android.os.Process.myPid()}")
        }
    }

    private fun mallLogin() {
        Log.d("UNIAPP", "mallLogin: ")
        viewModelScope.launch {
            if (!semaphore.tryAcquire()) {
                LogUtil.e("UNIAPP", "mallLogin: =============== start =============== ${semaphore.availablePermits}  ${Thread.currentThread().name}")
                return@launch
            }
            val token = AccountManager.getInstance().account?.access_token ?: ""
            mallRepository.mallLogin(MallLoginReq(token))
                .collect { result ->
                    try {
                        handleMallLoginResultData(result)
                    } finally {
                        LogUtil.d("UNIAPP", "release: semaphore -----0----- ${semaphore.availablePermits}")
                        if (semaphore.availablePermits == 0) {
                            semaphore.release()
                        }
                        LogUtil.d("UNIAPP", "release: semaphore -----1----- ${semaphore.availablePermits}")
                    }
                }
        }
    }

    private fun handleMallLoginResultData(result: Result<MallLoginRes>) {
        LogUtil.i("UNIAPP", "handleMallLoginResultData: ----0--- ${semaphore.availablePermits}")
        if (result is Result.Success) {
            result.data?.let {
                Log.d("UNIAPP", "handleMallLoginResultData: ----1--- ${semaphore.availablePermits}")
                _uiStates.setState {
                    copy(
                        sessionId = it.sessid,
                        userId = it.user_id,
                        timestamp = SystemClock.elapsedRealtime()
                    )
                }
            }
            LogUtil.d("UNIAPP", "handleMallLoginResultData: ----5--- ${semaphore.availablePermits}")
        } else if (result is Result.Error) {

        }
        LogUtil.d("UNIAPP", "handleMallLoginResultData: ----6--- ${semaphore.availablePermits}")
    }


    private fun mallPersonInfo() {
        LogUtil.d("UNIAPP", "mallPersonInfo: ------------- ")
        viewModelScope.launch {
            val result = queryMallPersonInfo()
            if (result == -100) {
                // 重试一次
                LogUtil.e("UNIAPP", "mallPersonInfo: --------$result----- ")
                val mallLoginSync = mallLoginSync()
                // 重试
                if (mallLoginSync.isNotEmpty()) {
                    queryMallPersonInfo()
                }
            }
        }
    }

    private suspend fun queryMallPersonInfo(): Int {
        val sessionId: String = uiStates.value.sessionId
        val userId: String = uiStates.value.userId
        LogUtil.d("UNIAPP", "queryMallPersonInfo: sessionId = $sessionId ,userId = $userId")
        val result = mallRepository.mallPersonInfoSync(sessionId, userId)
        if (result is Result.Success) {
            result.data?.let {
                _uiStates.setState {
                    copy(
                        coupon = it.coupon,
                        score = it.point
                    )
                }
                return 0
            }
        } else if (result is Result.Error) {
            if (result.exception.code == -100) {
                // session is  invalid or overdue
                return -100
            }
        }
        return -1
    }

    fun composeJson() = runCatching {
        val jsonObject = JSONObject()
        jsonObject.put("sessid", uiStates.value.sessionId)
        jsonObject.put("user_id", uiStates.value.userId)
        jsonObject.toString()
    }.getOrDefault("")
}