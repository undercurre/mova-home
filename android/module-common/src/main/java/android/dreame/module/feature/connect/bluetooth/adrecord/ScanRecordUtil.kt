package android.dreame.module.feature.connect.bluetooth.adrecord

object ScanRecordUtil {
    /**
     * 解析蓝牙广播报文，获取数据单元
     */
    @JvmStatic
    fun parseFromBytes(scanRecord: ByteArray): String? {
        val parseScanRecordAsList = AdRecordUtil.parseScanRecordAsList(scanRecord)
        val uuidDataArray = parseScanRecordAsList.filter {
            it.type == AdRecord.BLE_GAP_AD_TYPE_16BIT_SERVICE_UUID_COMPLETE
        }.filter {
            val data = it.data // uuid
            val uuidL = data[0].toInt() and 0xFF
            val uuidH = data[1].toInt() and 0xFF
            uuidH == 0xFE && uuidL == 0x98
        }.map {
            it.data
        }
        if (uuidDataArray.isEmpty()) {
            return null
        }
        val uuidData = uuidDataArray[0]
        val data = parseScanRecordAsList.filter {
            it.type == AdRecord.BLE_GAP_AD_TYPE_SERVICE_DATA
        }.map {
            if (it.data[0] == uuidData[0] && it.data[1] == uuidData[1]) {
                String(it.data, 2, it.data.size - 2)
            } else {
                String(it.data)
            }
        }
        if (data.isEmpty()) {
            return null
        }
        return data[0]
    }
}