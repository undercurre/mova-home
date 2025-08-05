package com.dreame.smartlife.config.step

import android.dreame.module.util.LogUtil
import android.os.Message
import com.dreame.smartlife.config.event.StepId

/**
 * # 通过wifi发数据到设备
 * udp数据传输,轮询15次,2s一次,bindSocket并发request_connection,
 *  1)发送成功,设备响应,停止轮询,发下一条消息
 *  2)如果自动切换到其他网络,手动连接 [StepManualConnect]
 * 成功:检查设备pair状态 [StepCheckDevicePairState]
 * 失败:
 *  1)可以重试:wifi扫描 [StepWifiScan]
 *  2)重试失败:手动连接 [StepManualConnect]
 */
class StepSendDataWifiQR : BaseStepSendDataWifi() {
    override fun maxRetryCount() = 0

    override fun stepName() = Step.STEP_SEND_DATA_WIFI_QR

    override fun registerNetChange() = false
    override fun isCheckDeviceWifi() = false
    override fun stepCreate() {
        LogUtil.i(TAG, " stepCreate")
        super.stepCreate()
    }

    override fun sendDataError() {
        LogUtil.i(TAG, " sendDataError")
        super.sendDataError();
    }

    override fun gotoNextManualStep(reason: String) {
        LogUtil.i(TAG, "gotoNextManualStep: $reason")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.FAILED, stepId = StepId.STEP_SEND_DATA_WIFI, reason = reason)
        })
        connectivityManager.bindProcessToNetwork(null)
        getHandler().post {
            nextStep(Step.STEP_MANUAL_CONNECT_QR)
        }
    }

}