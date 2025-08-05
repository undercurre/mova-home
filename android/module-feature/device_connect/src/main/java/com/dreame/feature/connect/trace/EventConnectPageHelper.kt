package com.dreame.feature.connect.trace

import android.dreame.module.LocalApplication
import android.dreame.module.data.db.EventConnectPageRepository
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.AppUtils
import android.os.SystemClock
import com.dreame.smartlife.config.step.SmartStepHelper
import com.dreame.smartlife.config.step.StepData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch


/**
 * 配网埋点
 */
object EventConnectPageHelper : CoroutineScope by MainScope() {
    private const val TAG = "EventConnectPageHelper"
    private val repository by lazy { EventConnectPageRepository() }
    private var time = 0L

    fun updateTime() {
        time = SystemClock.elapsedRealtime()
    }

    fun insertStepEntity(
        eventId: String, did: String, model: String, scType: StepData.StepMode, success: Int, manualConnect: Int = 0, stepId: Int = 0,
        enterOrigin: Int,
        reason: String = "", remark: String = "", rawInfo: String = ""
    ) {
        val consumeTime = ((SystemClock.elapsedRealtime() - time) / 1000).toInt()
        launch(Dispatchers.IO) {
            try {
                val uid = AccountManager.getInstance().account.uid ?: ""
                val lang = LanguageManager.getInstance().getLangTag(LocalApplication.getInstance())
                val region = AreaManager.getRegion()
                val appVer = AppUtils.appLocalVersion(LocalApplication.getInstance())

                val type = when (scType) {
                    StepData.StepMode.MODE_WIFI -> 0
                    StepData.StepMode.MODE_BLE -> 1
                    StepData.StepMode.MODE_BOTH -> 2
                    else -> 0
                }
                repository.insertStepEntity(
                    eventId, stepId, uid, lang, appVer.toString(), region, did, model, type, enterOrigin, success, manualConnect,
                    stepId, consumeTime, reason, desc = "", remark, rawInfo
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }


    /**
     * 配网失败分析
     * @param stepId stepId
     * @param scType 配网类型
     * @param errorCode 错误类型编码
     * @param dataTraffic 数据流量开启
     * @param errorMsg 错误原因描述
     * @param rawStr 错误堆栈
     */
    fun insertStepErrorEntity(
        errorCode: Int, dataTraffic: Int, errorMsg: String, rawStr: String
    ) {
        val stepId: Int = SmartStepHelper.instance.getCurrentStepId()
        val did = StepData.deviceId
        val model = StepData.productModel
        val enterOrigin = StepData.enterOrigin
        val scType = StepData.stepModeDefault
        launch(Dispatchers.IO)
        {
            try {
                val uid = AccountManager.getInstance().account.uid ?: ""
                val lang = LanguageManager.getInstance().getLangTag(LocalApplication.getInstance())
                val region = AreaManager.getRegion()
                val appVer = AppUtils.appLocalVersion(LocalApplication.getInstance())

                val type = when (scType) {
                    StepData.StepMode.MODE_WIFI -> 0
                    StepData.StepMode.MODE_BLE -> 1
                    StepData.StepMode.MODE_BOTH -> 2
                    else -> 0
                }
                repository.insertStepErrorEntity(
                    stepId, uid, lang, appVer.toString(), region, did, model, type, enterOrigin, errorCode, dataTraffic, errorMsg, rawStr
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }
}