package com.dreame.feature.connect.trace

object BuriedConnectHelper {
    /**
     * 埋点sessionID
     */
    private var sessionID: Long = 0

    /**
     * 选择配网方式
     */
    private var enterType: Int = 0

    fun generateSessionID() {
        sessionID = System.currentTimeMillis()
    }

    fun resetSessionID() {
        sessionID = 0
    }

    fun currentSessionID() = sessionID.toString()
    fun calculateCostTime(): Int {
        val costTime = (System.currentTimeMillis() - sessionID) / 1000
        return costTime.toInt()
    }

    /**
     * 选择配网方式
     * @param type 0:扫码配网 1:手动选择设备配网
     */
    fun updateEnterType(type: Int) {
        this.enterType = type
        if (sessionID == 0L) {
            generateSessionID()
        }
    }

    // 此方法只用于flutter进来，其他不应调用
    fun setEnterType(sessionID: Long, isQR: Boolean = true) {
        this.enterType = if (isQR) 0 else 1
        this.sessionID = sessionID
    }

    fun currentEnterType() = enterType

}