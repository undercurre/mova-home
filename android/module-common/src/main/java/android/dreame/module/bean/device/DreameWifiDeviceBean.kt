package android.dreame.module.bean.device

import android.dreame.module.data.entry.ProductListBean
import android.os.SystemClock
import java.util.*
import kotlin.collections.List

/**
 * @Author: sunzhibin
 * @E-mail: sunzhibin@dreame.tech
 * @Desc: wifi扫描到的附近设备
 * @Date: 2021/4/26 13:20
 * @Version: 1.0
 */
class DreameWifiDeviceBean {
    // dreame 设备 wifiname  model + "xxxx"
    // model = "dreame.vacuum.pxxxx"
    var name: String? = null
    var wifiName: String? = null
    var productId: String? = null
    var product_model: String? = null
    var product_pic_url: String? = null

    // 大图
    var imageUrl: String? = null
    var level = 0
    var ssid: String? = null
    var frequency = 0

    // 蓝牙设备扫描的广播内容
    var result: String? = null

    // 1 :wifi 设备 2：蓝牙设备 3: WiFi_BLE混合
    var type = 1

    // 支持配网类型
    var scType: String? = null

    // 支持的扩展配网类型
    var extendScType: List<String>? = null

    // 设备特性
    var feature: String? = null
    var timestamp = SystemClock.elapsedRealtime()
    var deviceWrapper: BluetoothDeviceWrapper? = null
    var deviceProduct: ProductListBean? = null

    @Transient
    var isSelect: Boolean = false

    override fun equals(o: Any?): Boolean {
        if (this === o) {
            return true
        }
        if (o == null || javaClass != o.javaClass) {
            return false
        }
        val that = o as DreameWifiDeviceBean
        val b = type == that.type
        return b && ssid == that.ssid && result == that.result
    }

    override fun hashCode(): Int {
        return Objects.hash(ssid, result)
    }

    override fun toString(): String {
        return "DreameWifiDeviceBean(name=$name ,wifiName=$wifiName ,result=$result ,productId=$productId ,product_model=$product_model ,product_pic_url=${product_pic_url.isNullOrBlank()} ,level=$level ,ssid=$ssid ,frequency=$frequency ,type=$type ,scType=$scType ,feature=$feature ,timestamp=$timestamp ,isUpdate=$isUpdate ,deviceWrapper=$deviceWrapper ,deviceProduct=$deviceProduct)"
    }

    // 是否更新过
    var isUpdate = false


}