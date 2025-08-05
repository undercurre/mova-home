package android.dreame.module.feature.connect.bluetooth.adrecord

import android.util.SparseArray
import java.util.Arrays
import java.util.Collections

/**
 * @Description: 广播包解析工具类
 * @author: [DAWI](https://github.com/xiaoyaoyou1212/BLE)
 * @date: 16/8/7 21:56.
 */
object AdRecordUtil {
    fun getRecordDataAsString(nameRecord: AdRecord?): String {
        return if (nameRecord == null) {
            ""
        } else String(nameRecord.data)
    }

    fun getServiceData(serviceData: AdRecord?): ByteArray? {
        if (serviceData == null) {
            return null
        }
        if (serviceData.type != AdRecord.BLE_GAP_AD_TYPE_SERVICE_DATA) return null
        val raw = serviceData.data
        //Chop out the uuid
        return Arrays.copyOfRange(raw, 2, raw.size)
    }

    fun getServiceDataUuid(serviceData: AdRecord?): Int {
        if (serviceData == null) {
            return -1
        }
        if (serviceData.type != AdRecord.BLE_GAP_AD_TYPE_SERVICE_DATA) return -1
        val raw = serviceData.data
        //Find UUID data in byte array
        var uuid = raw[1].toInt() and 0xFF shl 8
        uuid += raw[0].toInt() and 0xFF
        return uuid
    }

    /*
     * Read out all the AD structures from the raw scan record
     */
    fun parseScanRecordAsList(scanRecord: ByteArray): List<AdRecord> {
        val records: MutableList<AdRecord> = ArrayList()
        var index = 0
        while (index < scanRecord.size) {
            val length = scanRecord[index++].toInt()
            //Done once we run out of records
            if (length == 0) break
            val type = scanRecord[index].toInt() and 0xFF

            //Done if our record isn't a valid type
            if (type == 0) break
            val data = Arrays.copyOfRange(scanRecord, index + 1, index + length)
            records.add(AdRecord(length, type, data))

            //Advance
            index += length
        }
        return Collections.unmodifiableList(records)
    }

    fun parseScanRecordAsMap(scanRecord: ByteArray): Map<Int, AdRecord> {
        val records: MutableMap<Int, AdRecord> = HashMap()
        var index = 0
        while (index < scanRecord.size) {
            val length = scanRecord[index++].toInt()
            //Done once we run out of records
            if (length == 0) break
            val type = scanRecord[index].toInt() and 0xFF

            //Done if our record isn't a valid type
            if (type == 0) break
            val data = Arrays.copyOfRange(scanRecord, index + 1, index + length)
            records[type] = AdRecord(length, type, data)

            //Advance
            index += length
        }
        return Collections.unmodifiableMap(records)
    }

    fun parseScanRecordAsSparseArray(scanRecord: ByteArray): SparseArray<AdRecord> {
        val records = SparseArray<AdRecord>()
        var index = 0
        while (index < scanRecord.size) {
            val length = scanRecord[index++].toInt()
            //Done once we run out of records
            if (length == 0) break
            val type = scanRecord[index].toInt() and 0xFF

            //Done if our record isn't a valid type
            if (type == 0) break
            val data = Arrays.copyOfRange(scanRecord, index + 1, index + length)
            records.put(type, AdRecord(length, type, data))

            //Advance
            index += length
        }
        return records
    }
}