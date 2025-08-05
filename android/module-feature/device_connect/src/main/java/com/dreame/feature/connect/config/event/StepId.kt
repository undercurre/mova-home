package com.dreame.smartlife.config.event

object StepId {

    /**
     * 配网步骤相关
     */
    const val STEP_APP_ENTER = 0
    const val STEP_APP_WIFI_SCAN = 1
    const val STEP_DEVICE_SCAN_BLE = 2
    const val STEP_CONNECT_DEVICE_AP = 3
    const val STEP_CONNECT_DEVICE_BLE = 4
    const val STEP_CONNECT_CHECK = 5
    const val STEP_SETTING_CHECK_BLE = 6
    const val STEP_SEND_DATA_WIFI = 7
    const val STEP_SEND_DATA_BLE = 8
    const val STEP_MANUAL_CONNECT = 9
    const val STEP_CHECK_DEVICE_PAIR_STATE = 10
    const val STEP_CHECK_DEVICE_ONLINE_STATE = 11
    const val STEP_BIND_ALI_DEVICE = 13

    const val STEP_QR_NET_PAIR = 14
    const val STEP_QR_NET_ONLINE = 15

    const val STEP_APP_WIFI_PERMISSION = 12

    const val STEP_APP_EXIT = 29

    /**
     * 配网辅助相关事件
     *
     */
    const val STEP_HELPER = 30
    const val STEP_OPEN_WIFI = 31
    const val STEP_OPEN_BLE = 32
    const val STEP_OPEN_LOCATION_PEMISSION = 33
    const val STEP_OPEN_LOCATION_SERVER = 34

}

object EnterType {

    const val TYPE_ITEM = 1
    const val TYPE_SCAN = 2
    const val TYPE_QR = 3
}