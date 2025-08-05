package com.dreame.smartlife.config.step

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.util.LogUtil
import android.location.LocationManager
import android.net.ConnectivityManager
import android.net.Network
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Handler
import android.os.Message
import android.os.SystemClock
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.location.LocationManagerCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import com.dreame.android.netlibrary.NetworkListener
import com.dreame.android.netlibrary.core.NetStatus
import com.dreame.android.netlibrary.core.NetType
import com.dreame.module.res.BottomConfirmDialog
import android.dreame.module.feature.connect.bluetooth.StepBleCheckSetting
import android.dreame.module.feature.connect.bluetooth.StepBleConnectDevice
import com.dreame.feature.connect.config.step.bluetooth.StepBleScan
import com.dreame.feature.connect.config.step.bluetooth.StepSendDataBle
import com.dreame.feature.connect.config.step.bluetooth.StepSendDataBleMcu
import android.dreame.module.feature.connect.bluetooth.StepSendDataBleMower
import com.dreame.feature.connect.config.step.StepBindAliDevice
import com.dreame.smartlife.connect.R
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.kunminx.architecture.ui.callback.UnPeekLiveData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.isActive
import java.util.concurrent.CancellationException

/**
 * 配网步骤基类
 */
abstract class SmartStepConfig : LifecycleObserver, CoroutineScope by MainScope() {
    protected val CODE_STEP_CREATE: Int = 0x9001
    protected val CODE_STEP_STOP: Int = 0x9002
    protected var time = SystemClock.elapsedRealtime()

    enum class Step {
        STEP_WIFI_PERMISSION_CHECK,
        STEP_MANUAL_CONNECT,
        STEP_MANUAL_CONNECT_QR,
        STEP_APP_WIFI_SCAN,
        STEP_CONNECT_DEVICE_AP,
        STEP_CONNECT_DEVICE_AP_QR,
        STEP_CONNECT_CHECK,
        STEP_SEND_DATA_WIFI,
        STEP_SEND_DATA_WIFI_QR,
        STEP_SEND_DATA_BLE,
        STEP_CHECK_DEVICE_PAIR_STATE,
        STEP_CHECK_DEVICE_ONLINE_STATE,
        STEP_APP_DOWNLOAD_PLUGIN,
        STEP_BIND_ALI_DEVICE,

        // 二维码配网
        STEP_QR_NET_PAIR,

        // 蓝牙
        STEP_DEVICE_SCAN_BLE,
        STEP_CONNECT_DEVICE_BLE,
        STEP_SETTING_CHECK_BLE,
        STEP_SEND_DATA_BLE_MOWER,
        STEP_SEND_DATA_BLE_MCU,
    }

    interface StepConfigCallback {
        fun bindHandler(): Handler
        fun nextStep(step: Step)
        fun finish(success: Boolean)
        fun updateRetryCount(step: Step)
        fun stepRetryCount(step: Step): Int
        fun resetRetryCount(step: Step)
    }

    protected val TAG = this::class.simpleName
    protected lateinit var context: Activity
    private var _context: Context? = null
    protected val locationDialog by lazy { BottomConfirmDialog(context) }
    protected val wifiManager by lazy { context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager }
    protected val connectivityManager by lazy {
        context.applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    }
    private val locationManager by lazy { context.applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager }
    protected val permissionList =
        arrayOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION, Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT)

    var stepConfigCallback: StepConfigCallback? = null
    protected var stepRunning = false

    protected val unPeekLiveData = UnPeekLiveData<String>()

    /**
     * 查看当前步骤是否运行中
     */
    fun isStepRunning() = stepRunning

    /**
     * 初始化,当前step与Activity绑定
     */
    fun bindActivity(context: Activity) {
        stepRunning = true
        time = SystemClock.elapsedRealtime()
        LogUtil.i("配网耗时:bindActivity: --------- start ---------- $this")
        this.context = context
        _context = context
        (context as? AppCompatActivity)?.lifecycle?.addObserver(this)
        if (registerNetChange()) {
            NetworkListener.getInstance().registerObserver(this)
        }
        getHandler().post {
            stepCreate()
        }
    }

    abstract fun stepName(): Step

    abstract fun handleMessage(msg: Message)

    /**
     * step开始
     */
    open fun stepCreate() {

    }

    /**
     * step销毁
     * 做一些释放操作
     */
    abstract fun stepDestroy()

    /**
     * 最大重试次数,默认不能重试
     */
    open fun maxRetryCount(): Int = 0

    /**
     * 注册网络变化监听,默认不监听
     */
    open fun registerNetChange() = false

    /**
     * 处理网络变化事件
     */
    open fun handleNetChangeEvent(connectedSsid: String) {}

    open fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {}

    /**
     * 获取handler对象
     */
    fun getHandler(): Handler {
        return stepConfigCallback?.bindHandler() ?: Handler(context.mainLooper)
    }

    /**
     * 下一步
     */
    fun nextStep(step: Step) {
        getHandler().post {
            if (stepRunning) {
                onStepDestroy()
                stepConfigCallback?.nextStep(step)
            }
        }
    }

    /**
     * 结束流程
     * @param success 流程是否成功
     */
    fun finish(success: Boolean) {
        if (stepRunning) {
            onStepDestroy()
            stepConfigCallback?.finish(success)
        }
    }

    /**
     * 当前步骤是否可以重试
     */
    fun canRetryStep(step: Step): Boolean {
        return (stepConfigCallback?.stepRetryCount(step) ?: 0) < maxRetryCount()
    }

    /**
     * 更新当前步骤重试次数
     */
    fun updateRetryCount(step: Step) {
        stepConfigCallback?.updateRetryCount(step)
    }

    /**
     * 重置当前步骤重试次数
     */
    fun resetRetryCount(step: Step) {
        stepConfigCallback?.resetRetryCount(step)
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    private fun onResume() {
        stepOnResume()
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    private fun onPause() {
        stepOnPause()
    }

    open fun stepOnResume() {

    }

    open fun stepOnPause() {

    }

    /**
     * 生命周期结束,移除所有监听
     */
    @OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onDestroy() {
        LogUtil.i(TAG, "onDestroy: Activity onDestroy")
        stepRunning = false
        if (isActive) {
            Log.d(TAG, "onDestroy: CoroutineScope cancel ")
            cancel(CancellationException("Activity onDestroy"))
        }
        getHandler().removeCallbacksAndMessages(null)
        if (registerNetChange()) {
            NetworkListener.getInstance().unRegisterObserver(this)
        }
        _context = null
        stepDestroy()
    }

    /**
     * 正常结束,到下一个步骤,移除生命监听,网络监听
     */
    private fun onStepDestroy() {
        stepRunning = false
        if (registerNetChange()) {
            NetworkListener.getInstance().unRegisterObserver(this)
        }
        (context as AppCompatActivity).lifecycle.removeObserver(this)
        stepDestroy()
        LogUtil.i("配网耗时: onStepDestroy: ${SystemClock.elapsedRealtime() - time}  $this")
    }

    @NetStatus(netType = NetType.WIFI)
    fun onNetChange(netType: NetType, network: Network) {
        LogUtil.i(TAG, "onNetChange: netType: " + netType.name + ", network: " + network)
        val connectedSsid = currentConnectedSsid()
        if (netType == NetType.WIFI || netType == NetType.AUTO) {
            LogUtil.i(TAG, "onNetChange: current connected wifiName: $connectedSsid")
            if (registerNetChange()) {
                handleNetChangeEvent(connectedSsid)
            }
        }
        unPeekLiveData.postValue(currentConnectedSsid())
    }

    /**
     * wifiName是否是设备热点
     * @param wifiName Wi-Fi名
     * @param isManual 手动模式，不校验 model 、mac ,确定 dreame_ 开头就行
     * @param isSkipCheck 跳过校验模式，不校验 model 、mac ,确定 dreame_ 开头就行
     */
    fun isDeviceWifi(wifiName: String?, isManual: Boolean = false, isSkipCheck: Boolean = false): Boolean {

        return if (wifiName.isNullOrEmpty()) {
            false
        } else if (isManual || isSkipCheck) {
            // 不校验mac model, 只校验 设备类别 扫地机 洗地机 割草机 等大类 fix by sunzhibin 2023.6.20
            /*val lastIndex = StepData.productWifiPrefix.lastIndexOf('-')
            val prefix = if (lastIndex != -1) {
                StepData.productWifiPrefix.substring(0, lastIndex)
            } else {
                val lastIndex2 = StepData.productModel.lastIndexOf('.')
                if (lastIndex2 != -1) {
                    StepData.productModel.substring(0, lastIndex)
                } else {
                    StepData.productModel
                }
            }*/
            // 不校验mac model, 只校验热点名字startWith("dreame-") fix by sunzhibin 2023.8.9
            (wifiName.startsWith("mova-") || wifiName.startsWith("dreame-") || wifiName.startsWith("trouver-")) && wifiName.contains("_miap")
        } else if (StepData.productWifiName.isBlank()) {
            val indexOf = wifiName.indexOf("_miap")
            if (indexOf != -1) {
                val name = wifiName.substring(0, indexOf)
                val element = name.replace("-", ".")
                if (StepData.productModels.contains(element)) {
                    StepData.productModel = element
                    true
                } else {
                    wifiName.startsWith(StepData.productWifiPrefix + "_")
                }
            } else {
                false
            }
        } else {
            wifiName == StepData.productWifiName || wifiName == StepData.deviceApName
        }
    }

    /**
     * 当前连接wifi的ssid
     */
    fun currentConnectedSsid(): String {
        val connectionInfo: WifiInfo = wifiManager.connectionInfo ?: return ""
        if (connectionInfo.networkId == -1) {
            return ""
        }
        var ssid = connectionInfo.ssid
        if (!TextUtils.isEmpty(ssid)) {
            ssid = ssid.decodeQuotedSSID()
        }
        if (!TextUtils.isEmpty(ssid)) {
            if (ssid.contains("unknown ssid")) {
                return ""
            }
        }
        return ssid
    }

    /**
     * 是否具有权限
     * @param permission 权限列表
     */
    fun isGrantedPermission(permission: Array<String>): Boolean {
        return XXPermissions.isGranted(context, *permission)
    }

    /**
     * 定位服务是否打开
     */
    fun locServiceEnable() = LocationManagerCompat.isLocationEnabled(locationManager)

    /**
     * Gps位置信息提示弹窗
     */
    fun showGpsLocationDialog(
        confirmCallback: (() -> Unit)? = null,
        cancelCallback: (() -> Unit)? = null,
    ) {
        if (locationDialog.isShowing) return
        context.let {
            locationDialog.show(
                it.getString(R.string.text_open_wifi_tips),
                it.getString(R.string.text_goto_open),
                it.getString(R.string.cancel), { dialog ->
                    confirmCallback?.invoke()
                    val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
                    it.startActivity(intent)
                    dialog.dismiss()
                }, { dialog ->
                    cancelCallback?.invoke()
                    dialog.dismiss()
                }
            )
        }
    }

    companion object {
        private val stepMap = mutableMapOf(
            Pair(Step.STEP_WIFI_PERMISSION_CHECK, StepWifiPermissionCheck::class.java),
            Pair(Step.STEP_MANUAL_CONNECT, StepManualConnect::class.java),
            Pair(Step.STEP_MANUAL_CONNECT_QR, StepManualConnectQR::class.java),
            Pair(Step.STEP_APP_WIFI_SCAN, StepWifiScan::class.java),
            Pair(Step.STEP_CONNECT_DEVICE_AP, StepConnectDeviceAP::class.java),
            Pair(Step.STEP_CONNECT_DEVICE_AP_QR, StepConnectDeviceAPQR::class.java),
            Pair(Step.STEP_CONNECT_CHECK, StepConnectCheck::class.java),
            Pair(Step.STEP_SEND_DATA_WIFI, StepSendDataWifi::class.java),
            Pair(Step.STEP_SEND_DATA_WIFI_QR, StepSendDataWifiQR::class.java),
            Pair(Step.STEP_SEND_DATA_BLE, StepSendDataBle::class.java),
            Pair(Step.STEP_SEND_DATA_BLE_MOWER, StepSendDataBleMower::class.java),
            Pair(Step.STEP_SEND_DATA_BLE_MCU, StepSendDataBleMcu::class.java),
            Pair(Step.STEP_CHECK_DEVICE_PAIR_STATE, StepCheckDevicePairState::class.java),
            Pair(Step.STEP_CHECK_DEVICE_ONLINE_STATE, StepCheckDeviceOnLineState::class.java),
            Pair(Step.STEP_APP_DOWNLOAD_PLUGIN, StepDownloadPlugin::class.java),
            Pair(Step.STEP_BIND_ALI_DEVICE, StepBindAliDevice::class.java),
            Pair(Step.STEP_QR_NET_PAIR, StepCheckDeviceQRNetPairState::class.java),

            // 蓝牙
            Pair(Step.STEP_DEVICE_SCAN_BLE, StepBleScan::class.java),
            Pair(Step.STEP_CONNECT_DEVICE_BLE, StepBleConnectDevice::class.java),
            Pair(Step.STEP_SETTING_CHECK_BLE, StepBleCheckSetting::class.java),


            )

        fun findStep(step: Step): SmartStepConfig? {
            val clazz = stepMap[step]
            if (clazz != null) {
                try {
                    return clazz.newInstance() as SmartStepConfig
                } catch (e: Exception) {
                    LogUtil.e("TAG", "findStep error: $e")
                }
            }
            return null
        }
    }


    fun disconnectWifi() {
        connectivityManager.bindProcessToNetwork(null)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            LogUtil.i(
                TAG,
                "disconnectWifi up Android Q, networkCallback ${SmartStepHelper.instance.networkCallback}"
            )
            try {
                SmartStepHelper.instance.networkCallback?.let {
                    connectivityManager.unregisterNetworkCallback(it)
                    SmartStepHelper.instance.networkCallback = null
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            val configuredNetworks =
                if (ActivityCompat.checkSelfPermission(
                        context,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    wifiManager.configuredNetworks ?: emptyList()
                } else {
                    emptyList()
                }
            LogUtil.i(
                TAG, "disconnectWifi before Q, productWifiPrefix=${StepData.productWifiPrefix}, "
                        + "productWifiName=${StepData.productWifiName}"
            )
            LogUtil.i(
                TAG, "disconnectWifi before Q, productWifiPrefix=${StepData.productWifiPrefix}, "
                        + "productWifiName=${StepData.productWifiName}"
            )
            for (configuration in configuredNetworks) {
                if (isDeviceWifi(configuration.SSID)) {
                    LogUtil.i(TAG, "disconnectWifi before Q disconnect wifi: ${configuration.SSID}")
//                    wifiManager.disableNetwork(configuration.networkId)
//                    wifiManager.disconnect()
                    wifiManager.removeNetwork(configuration.networkId)
                    break
                }
            }
        }
    }
}