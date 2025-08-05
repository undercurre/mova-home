package com.dreame.smartlife.config.step

/**
 * 扫地机支持的配网方式
 */
object ScanType {
    const val WIFI = "WIFI"
    const val WIFI_BLE = "WIFI_BLE"
    const val BLE = "BLE"

    const val QR_CODE_V2 = "QR_CODE_V2"
    const val MCU = "MCU"

    const val COMBO = "COMBO";
    const val ZIG_BEE = "ZIG_BEE";
    const val AP = "AP";
    const val BLE_MESH = "BLE_MESH";
    const val CELLULAR = "CELLULAR";
    const val THIRD_PARTY_CLOUD = "THIRD_PARTY_CLOUD";
    const val WAVE = "WAVE";
    const val NOT_REQUIRED = "NOT_REQUIRED";

}

object ExtendScType {
    const val QR_CODE = "QR_CODE"
    const val QR_CODE_V2 = "QR_CODE_V2"
    const val GPS_LOCK = "GPS_LOCK"
    const val ENABLE_BC_PAIR = "ENABLE_BC_PAIR" /*蓝牙重新配*/
    const val DEVICE_SCAN_WIFI = "DEVICE_SCAN_WIFI" /*机器扫Wi-Fi*/
    const val PINCODE = "PINCODE" /*二进制*/
    const val NON_FORCE_WIFI = "NON_FORCE_WIFI" /*二进制*/
    const val BLOB = "BLOB" /*二进制*/

}

object DeviceFeature {
    const val FORCE_BIND_WIFI = "forceBindWifi"
    const val FAST_COMMAND = "fastCommand"
}