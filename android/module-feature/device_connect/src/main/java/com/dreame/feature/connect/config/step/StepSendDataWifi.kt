package com.dreame.smartlife.config.step

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
class StepSendDataWifi : BaseStepSendDataWifi() {
    override fun stepName(): Step = Step.STEP_SEND_DATA_WIFI

}