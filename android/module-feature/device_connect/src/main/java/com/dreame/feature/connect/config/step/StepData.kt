package com.dreame.smartlife.config.step

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.os.Parcelable
import com.dreame.feature.connect.scan.DeviceScanCache
import kotlinx.parcelize.Parcelize

const val DELAY_WIFI_TIME = 20 * 1000
const val DELAY_BLE_TIME = 10 * 1000
const val DELAY_WIFI_ONLY_TIME = 5 * 1000

/**
 * 配网数据类
 */
object StepData {
    // 连接开始时间
    var connectStartTime: Long = 0
    fun calculateConnectCostTime(): Int {
        val costTime = (System.currentTimeMillis() - connectStartTime) / 1000
        return costTime.toInt()
    }

    //  配网方式，1：Wi-Fi 2: BLE
    var pairNetMethod = 1

    val CODE_CURRENT_WIFI = 12001

    fun clear() {
        this.productInfo = null
    }

    // 售后角色配网
    var isAfterSales: Boolean = false
    fun init(productInfo: ProductInfo?, did: String, stepId: Int, pairQRKey: String?) {
        // 二维码配网时，返回的did
        this.pairQRKey = pairQRKey
        this.isAfterSales = productInfo?.isAfterSales ?: false
        this.productInfo = productInfo
        this.deviceApName = productInfo?.deviceWifiName ?: ""
        this.deviceId = did
        this.nextStepId = stepId
        stepModeDefault = when (productInfo?.scType) {
            ScanType.WIFI -> StepMode.MODE_WIFI
            ScanType.BLE -> StepMode.MODE_BLE
            ScanType.WIFI_BLE -> StepMode.MODE_BOTH
            else -> StepMode.MODE_WIFI
        }
        bleDeviceWrapper = DeviceScanCache.getBleDeviceScan().value?.find {
            it.wifiName == productWifiName
        }
        wifiDeviceWrapper = DeviceScanCache.getWifiDeviceScan().value?.find {
            it.wifiName == productWifiName
        }
    }

    fun updateProductInfo(bindDoamin: String, wifiName: String, wifiPwd: String) {
        this.productInfo = this.productInfo?.copy(targetDomain = bindDoamin, targetWifiName = wifiName, targetWifiPwd = wifiPwd)
    }

    var bleDeviceWrapper: DreameWifiDeviceBean? = null
        private set
        get() {
            if (field == null) {
                field = DeviceScanCache.getBleDeviceScan().value?.find {
                    isTargetDevice(it)
                }
            }
            return field
        }

    private fun isTargetDevice(bleBean: DreameWifiDeviceBean): Boolean {
        if (productWifiName.isNullOrBlank()) {
            return bleBean.productId == productId || productIds.contains(bleBean.productId)
        } else {
            val ret = bleBean.wifiName == productWifiName
            if (ret) {
                return true
            } else {
                // dreame-10060-09:06
                val suffix = bleBean.result?.let { result ->
                    val index = result.indexOfLast { it == '-' }
                    result.substring(index + 1).replace(":", "")
                } ?: ""
                if (bleBean.productId == productId) {
                    bleBean.wifiName = productModel + "_miap" + suffix
                    return true
                } else {
                    val model = productInfo?.productModels?.get(bleBean.productId)
                    if (model.isNullOrBlank()) {
                        return false
                    }
                    bleBean.wifiName = model + "_miap" + suffix
                    return true
                }
            }
        }
    }

    var wifiDeviceWrapper: DreameWifiDeviceBean? = null
        private set
        get() {
            if (field == null) {
                DeviceScanCache.getWifiDeviceScan().value?.find {
                    it.wifiName == productWifiName
                }
            }
            return field
        }

    var eventId: String = ""

    var scanDeviceList: MutableList<DreameWifiDeviceBean> = mutableListOf()

    /**
     * 配网来源：0: 点击item 1：扫描到 2：扫码
     */
    val enterOrigin: Int
        get() {
            return productInfo?.enterOrigin ?: -1
        }

    /**
     * 是否强制过滤
     */
    val isForceFilter: Boolean
        get() {
            return productInfo?.isForceFilter ?: false
        }

    // 设备要连接到的wifi信息
    val targetWifiName: String?
        get() {
            return productInfo?.targetWifiName
        }
    val targetWifiPwd: String?
        get() {
            return productInfo?.targetWifiPwd
        }

    var stepModeDefault = StepMode.MODE_WIFI

    // Wi-Fi延迟等待时间
    var stepModeDelay = if (stepModeDefault == StepMode.MODE_WIFI) 0 else DELAY_WIFI_TIME

    /**
     * 配网模式， 默认/Wi-Fi/蓝牙。可设置为Wi-Fi 和 蓝牙 先扫描到先设置
     */
    @Volatile
    var stepMode = StepMode.MODE_SCANNING


    // 扫描到的设备热点名称
    var deviceApName: String = ""

    /**
     * 设备did,通过udp返回
     */
    var deviceId = ""

    var capabilities: String? = null

    // 进页面后下一个页面
    var nextStepId = -1

    /**
     * 设备相关信息
     */
    private var productInfo: ProductInfo? = null
        set(value) {
            field = value
            _productWifiPrefix = field?.productModel?.let { name ->
                if (name.contains("."))
                    name.replace(".", "-")
                else
                    name
            } ?: ""
        }

    fun deviceModel(): String {
        return if (deviceApName.isBlank()) {
            productModel
        } else {
            val index = deviceApName.indexOf("_")
            if (index > 0) {
                return deviceApName.substring(0, index).replace("-", ".")
            } else {
                productModel
            }
        }
    }

    // 机器型号
    var productModel: String = productInfo?.realProductModel ?: productInfo?.productModel ?: ""
        get() {
            return if (field.isBlank()) {
                productInfo?.realProductModel ?: productInfo?.productModel ?: ""
            } else {
                field
            }
        }

    val productModels: List<String>
        get() {
            return productInfo?.productModels?.values?.toList() ?: emptyList()
        }

    val productIdModelMap: Map<String, String>
        get() {
            return productInfo?.productModels ?: emptyMap()
        }

    // 产品Id
    val productId: String
        get() {
            return productInfo?.productId ?: ""
        }

    // 二维码配网 key
    var pairQRKey: String? = null

    val productIds: Set<String>
        get() {
            return productInfo?.productModels?.keys ?: emptySet()
        }

    // 产品特性
    val feature: String
        get() {
            return productInfo?.feature ?: ""
        }
    val extendScType: List<String>
        get() {
            return productInfo?.extendScType ?: emptyList()
        }

    // 机器ap名称前缀
    private var _productWifiPrefix: String = ""
    val productWifiPrefix: String
        get() {
            return _productWifiPrefix
        }

    // 从扫描到设备列表进入时，使用此参数
    val productWifiName: String
        get() {
            return productInfo?.deviceWifiName ?: ""
        }

    // 设备配网host
    val targetDomain: String
        get() {
            return productInfo?.targetDomain ?: ""
        }

    @Parcelize
    data class ProductInfo(
        // 父model
        var productModel: String?,
        var productModels: Map<String, String>?,
        var deviceWifiName: String?,
        var targetDomain: String?,
        var productId: String?,
        var feature: String?,
        // 自己真实的model
        var realProductModel: String?,
        var isForceFilter: Boolean?,
        var enterOrigin: Int?,
        var scType: String?,
        var extendScType: List<String>?,
        var targetWifiName: String?,
        var targetWifiPwd: String?,
        var productPicUrl: String?,
        var isAfterSales: Boolean = false,
        var isBLE: Boolean = false,
        var timestamp: Long = System.currentTimeMillis()
    ) : Parcelable

    /**
     * ali三元组信息
     */
    data class LicenseInfo(var productKey: String?, var deviceName: String?)

    /**
     * 配网模式：Wi-Fi/蓝牙/默认
     */
    enum class StepMode {
        MODE_BOTH,
        MODE_WIFI,
        MODE_BLE,
        MODE_SCANNING
    }
}