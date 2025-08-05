package com.dreame.feature.connect.scan

import android.bluetooth.BluetoothDevice
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.constant.Constants
import android.dreame.module.util.LogUtil
import android.net.wifi.ScanResult
import android.os.SystemClock
import androidx.annotation.UiThread
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.dreame.smartlife.connect.BuildConfig

object DeviceScanCache {
    private val TAG = this.javaClass.simpleName

    /**
     * 扫描到设备，缓存最长时间 过期的
     */
    private const val DEVICE_WIFI_OVERDUE = 5 * 1000 * 60
    private const val DEVICE_REMOVE_OVERDUE_DEFAULT = 2 * 1000 * 60
    private const val DEVICE_BLE_OVERDUE = DEVICE_REMOVE_OVERDUE_DEFAULT
    private const val DEVICE_BLE_OVERDUE_MOWER = 1000

    const val TYPE_WIFI = 0x11
    const val TYPE_BLE = 0x12
    const val TYPE_BOTH = 0x13
    const val TYPE_DEFAULT = 0x100

    /**
     * 缓存扫描到的设备列表
     */
    private val deviceScanWifiCacheList = MutableLiveData<MutableList<DreameWifiDeviceBean>>()
    private val deviceScanBleCacheList = MutableLiveData<MutableList<DreameWifiDeviceBean>>()

    @JvmStatic
    fun getWifiDeviceScan(): LiveData<MutableList<DreameWifiDeviceBean>> {
        return deviceScanWifiCacheList
    }

    /**
     * 清理缓存中 扫描到的设备
     * 注意清理时机， 当切换账号，切换地区，切换语言等，影响到产品列表变化的动作，都需要执行
     */
    fun clear() {
        deviceScanBleCacheList.value = mutableListOf()
        deviceScanWifiCacheList.value = mutableListOf()
    }

    @JvmStatic
    fun getBleDeviceScan(): LiveData<MutableList<DreameWifiDeviceBean>> {
        return deviceScanBleCacheList
    }

    private fun getWifiScanDevice(): MutableList<DreameWifiDeviceBean> {
        return deviceScanWifiCacheList.value ?: mutableListOf()
    }


    private fun getBleScanDevice(): MutableList<DreameWifiDeviceBean> {
        return deviceScanBleCacheList.value ?: mutableListOf()
    }


    /**
     * 解析蓝牙广播是否是有效的可配网设备
     * dreamebt-10060-09:06
     * @param result 蓝牙广播内容
     * @return Pair<String, String>  productId, mac
     */
    fun parseBleScanResult(result: String?): Pair<String, String>? {
        if (result == null) {
            return null
        }
        // dreamebt-10060-09:06
        val index = result.indexOf("-")
        val index2 = result.lastIndexOf("-")

        if (index != -1 && index2 != -1 && index != index2) {
            val productId = result.substring(index + 1, index2)
            val mac = result.substring(index2 + 1).uppercase()
            LogUtil.d(TAG, "parseBleScanResult: productId: $productId ,mac: $mac")
            val pair = productId to mac
            if (valiadBleScanResult(pair)) {
                return pair
            }
        }
        return null
    }

    /**
     * 判断蓝牙广播是否是有效的可配网设备
     * 有效的：dreamebt-10060-09:06
     * 无效的：dreamebt-110012116-3
     * @param Pair<String, String>  productId, mac
     * @return Boolean
     */
    fun valiadBleScanResult(result: Pair<String, String>?): Boolean {
        if (result == null) {
            return false
        }
        if (result.first.isEmpty() || result.second.isEmpty()) {
            return false
        }
        // 先用广播中的mac来判断吧, 暂时不管pid 5位，did 9位
        // dreamebt-110012116-3 false
        // dreamebt-10060-09:06 true
        if (result.second.length < 4) {
            return false
        }
//        if (result.second.contains(":") && result.first.length < 9) {
//            return true
//        }
        return true
    }

    /**
     * 更新或者添加设备
     * @param originList
     * @param device
     * @param isBle
     */
    @UiThread
    @Synchronized
    fun updateOrAddDevice(originList: MutableList<DreameWifiDeviceBean>, device: DreameWifiDeviceBean, isBle: Boolean = false): Boolean {
        return originList.firstOrNull { origin ->
            if (isBle) {
                device.result == origin.result
            } else {
                device.ssid == origin.ssid
            }
        }?.let {
            if (device.deviceWrapper != null) {
                it.deviceWrapper = device.deviceWrapper
            }
            it.timestamp = device.timestamp
            true
        } ?: kotlin.run {
            setValue(true, listOf(device))
            true
        }
    }

    /**
     * 设置缓存list
     * @param isBle
     * @param list
     * @param isRemove
     */
    private fun setValue(isBle: Boolean, list: List<DreameWifiDeviceBean>, isRemove: Boolean = false) {
        if (isBle) {
            val wifiScanDevice = getBleScanDevice()
            if (isRemove) {
                wifiScanDevice.removeAll(list)
            } else {
                wifiScanDevice.addAll(list)
            }
            removeOverdueDevice(wifiScanDevice)
            deviceScanBleCacheList.value = wifiScanDevice
        } else {
            val wifiScanDevice = getWifiScanDevice()
            if (isRemove) {
                wifiScanDevice.removeAll(list)
            } else {
                wifiScanDevice.addAll(list)
            }
            removeOverdueDevice(wifiScanDevice)
            deviceScanWifiCacheList.value = wifiScanDevice
        }
    }

    /**
     * 移除过期的设备
     * @param overTime
     */
    fun removeOverdueDevice(overTime: Int = DEVICE_REMOVE_OVERDUE_DEFAULT) {
        LogUtil.d(TAG, "--------- removeOverdueDevice --------")
        // 删除蓝牙
        val filterBle = getBleScanDevice().filter {
            SystemClock.elapsedRealtime() - it.timestamp >= overTime
        }
        setValue(true, filterBle, true)

        // 删除蓝牙
        val filterWifi = getWifiScanDevice().filter {
            SystemClock.elapsedRealtime() - it.timestamp >= overTime
        }
        setValue(false, filterWifi, true)

    }

    /**
     * 移除过期的设备
     * @param list
     * @param overTime
     */
    fun removeOverdueDevice(list: MutableList<DreameWifiDeviceBean>, overTime: Int = DEVICE_REMOVE_OVERDUE_DEFAULT) {
        // 删除蓝牙
        val filterBle = list.filter {
            SystemClock.elapsedRealtime() - it.timestamp >= overTime
        }
        LogUtil.d(TAG, "--------- removeOverdueDevice -------- filter: ${filterBle.joinToString()}")
        list.removeAll(filterBle)
    }

    /**
     * 更新缓存的蓝牙设备
     * @param result
     * @param device
     * @param scanRecord
     * @param rssi
     */
    @UiThread
    @Synchronized
    fun updateBleDevice(result: String, device: BluetoothDevice, scanRecord: ByteArray, rssi: Int): Boolean {
        val ret = getBleScanDevice().firstOrNull { origin ->
            result == origin.result
        }?.run {
            timestamp = SystemClock.elapsedRealtime()
            deviceWrapper?.device = device
            deviceWrapper?.rssi = rssi
            deviceWrapper?.scanRecord = scanRecord
            deviceWrapper?.timestamp = timestamp
            true
        } ?: false

        // 移除过期设备
        val iterator = getBleScanDevice().iterator()
        while (iterator.hasNext()) {
            val next = iterator.next()
            if (isOverDue(next)) {
                iterator.remove()
            }
        }
        return ret
    }

    /**
     * 判断缓存的设备是否缓存过期了
     * @param next
     */
    @JvmStatic
    fun isOverDue(next: DreameWifiDeviceBean) = isOverDue(next, TYPE_DEFAULT)

    /**
     * 判断缓存的设备是否缓存过期了
     * @param next
     * @param type
     */
    @JvmStatic
    fun isOverDue(next: DreameWifiDeviceBean, type: Int): Boolean {
        val l = SystemClock.elapsedRealtime() - next.timestamp
        when (type) {
            TYPE_WIFI -> {
                return l > DEVICE_WIFI_OVERDUE
            }

            TYPE_BLE -> {
                return if (next.product_model?.contains(".mower.") == true) {
                    l > DEVICE_BLE_OVERDUE_MOWER
                } else {
                    l > DEVICE_BLE_OVERDUE
                }
            }

            TYPE_BOTH -> {
                return l > DEVICE_WIFI_OVERDUE
            }

            TYPE_DEFAULT -> {
                return l > DEVICE_REMOVE_OVERDUE_DEFAULT
            }

            else -> {
                return l > DEVICE_REMOVE_OVERDUE_DEFAULT
            }
        }
    }

    /**
     * 将扫描到的蓝牙设备 专程 DreameDeviceWifiBean缓存起来流程
     * @param result
     * @param device
     * @param scanRecord
     */
    fun createOrUpdateBleDeviceBean(result: String, device: BluetoothDevice, scanRecord: ByteArray, rssi: Int) {
        //
        removeOverdueDevice()
        //
        // 查询存在，则更新
        if (updateBleDevice(result, device, scanRecord, rssi)) {
            // 更新列表
            deviceScanBleCacheList.value = getBleScanDevice()
            return
        }
        val bean = buildBleDevice(device, scanRecord, rssi, result)
        if (bean.productId.isNullOrEmpty()) {
            setValue(true, listOf(bean), true)
        } else {
            updateOrAddDevice(getBleScanDevice(), bean, true)
        }
    }

    private fun removeDevice() {

    }

    /**
     * 将蓝牙转成 DreameWifiDeviceBean
     * @param result
     * @param device
     * @param scanRecord
     */
    private fun buildBleDevice(
        device: BluetoothDevice,
        scanRecord: ByteArray,
        rssi: Int,
        result: String,
    ): DreameWifiDeviceBean {
        val pair = parseBleScanResult(result)
        val productId = pair?.first
        val bean = DreameWifiDeviceBean()
        bean.deviceWrapper = BluetoothDeviceWrapper(result, device, scanRecord, rssi, SystemClock.elapsedRealtime())
        bean.name = result
        bean.wifiName = result
        bean.product_model = productId
        bean.productId = productId
        bean.ssid = result
        bean.level = rssi
        bean.frequency = -1
        bean.type = TYPE_BLE
        bean.result = result
        bean.timestamp = SystemClock.elapsedRealtime()
        return bean
    }

    /**
     * 将扫描到的Wi-Fi设备 专程 DreameDeviceWifiBean缓存起来流程
     * @param scanResults
     */
    fun buildWifiDeviceBean(scanResults: List<ScanResult>) {
        if (BuildConfig.DEBUG) {
            LogUtil.d(TAG, "--------- buildWifiDeviceBean -------- ${scanResults.size}")
        }
        //
        removeOverdueDevice()
        //
        val deviceList = scanResults
            .filter {
                !it.SSID.isNullOrEmpty() && (it.SSID != "unknown ssid" || it.SSID != "<unknow>" || it.SSID != "< unknow >")
            }
            .filter {
                it.SSID.startsWith(Constants.MODEL_NAME_PREFIX_DREAME) || it.SSID.startsWith(Constants.MODEL_NAME_PREFIX_MOVA)
            }.filter {
                it.SSID.contains("_miap")
            }
            .distinctBy {
                it.SSID
            }.filter { result ->
                val wifiDeviceBean = getWifiScanDevice().firstOrNull {
                    it.ssid == result.SSID
                }?.apply {
                    // 更新
                    timestamp = SystemClock.elapsedRealtime()
                    level = result.level
                    frequency = result.frequency

                    val ble = getBleScanDevice().firstOrNull {
                        it.wifiName == wifiName
                    }
                    ble?.let {
                        this.deviceWrapper = it.deviceWrapper
                        this.result = it.result

                    }
                }
                wifiDeviceBean == null
            }.map { result ->
                LogUtil.d("DeviceScanCache", "buildWifiDevice: ${result.SSID}")
                buildWifiDevice(result)
            }

        if (deviceList.isNotEmpty()) {
            setValue(false, deviceList)
        }

    }

    /**
     * 将ScanResult 转 DreameWifiDeviceBean
     * @param result
     */
    private fun buildWifiDevice(result: ScanResult): DreameWifiDeviceBean {
        // add
        val ssid = result.SSID ?: ""
        val index = ssid.indexOf("_")
        var model = ssid.substring(0, if (index == -1) ssid.length else index)
        model = model.replace("-", ".")
        val bean = DreameWifiDeviceBean()
        bean.name = ssid
        bean.wifiName = ssid
        bean.product_model = model
        bean.ssid = result.SSID
        bean.level = result.level
        bean.frequency = result.frequency
        bean.timestamp = SystemClock.elapsedRealtime()
        bean.type = TYPE_WIFI

        val ble = getBleScanDevice().firstOrNull {
            it.wifiName == ssid
        }
        ble?.let {
            bean.deviceWrapper = it.deviceWrapper
            bean.result = it.result
        }

        return bean
    }


}

/**
 * 根据ssid 或者 result 判断是否是同一个设备
 * @param result
 */
fun List<DreameWifiDeviceBean>.hasSameDevice(device: DreameWifiDeviceBean): Int {
    return this.indexOfFirst {
        it.ssid == device.ssid ||
                (it.result != null && it.result!!.isNotEmpty() && it.result == device.result)
    }
}
