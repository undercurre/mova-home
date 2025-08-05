package com.dreame.feature.connect.device.scan

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.dreame.module.RoutPath
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.constant.Constants
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.LogUtil
import android.dreame.module.view.CommonTitleView
import android.net.ConnectivityManager
import android.net.LinkProperties
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.android.netlibrary.externs.connectivityManager
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.scan.uiconfig.DeviceUiConfig
import com.dreame.feature.connect.device.scan.uiconfig.MultiNearByDeviceUiConfig
import com.dreame.feature.connect.device.scan.uiconfig.OneNearByDeviceUiConfig
import com.dreame.feature.connect.device.scan.uiconfig.ScanNearByDeviceUiConfig
import com.dreame.feature.connect.router.password.RouterConnectPasswordUiAction
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.databinding.ActivityDevcieScanNearbyBinding
import com.dreame.smartlife.ui.activity.main.DeviceSannerDelegateImpl
import com.hjq.permissions.XXPermissions

/**
 * 扫描附近设备
 */
@Route(path = RoutPath.DEVICE_SCAN_NEARYBY)
class DevcieScanNearbyActivity : BaseActivity<ActivityDevcieScanNearbyBinding>() {
    val viewModel by viewModels<DevcieScanNearbyViewModel>()

    private val connectManager by lazy { application.connectivityManager() }
    private val wifiManager by lazy { applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager }

    private val scanUiConfig: DeviceUiConfig by lazy { ScanNearByDeviceUiConfig(this, binding) }
    private val scanOneUiConfig: DeviceUiConfig by lazy { OneNearByDeviceUiConfig(this, binding) }
    private val scanMultiUiConfig: DeviceUiConfig by lazy {
        MultiNearByDeviceUiConfig(this, binding)
    }

    private val deviceSannerDelegateImpl by lazy {
        DeviceSannerDelegateImpl(this).apply {
            forceShowType = DeviceScanCache.TYPE_WIFI
        }
    }
    private val scanDeviceList: MutableList<DreameWifiDeviceBean> = mutableListOf()

    private val mainHandler by lazy { Handler(Looper.getMainLooper()) }

    override fun onCreate(savedInstanceState: Bundle?) {
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(
                ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java
            )
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        deviceSannerDelegateImpl.addSkipNeverNecessarilyPermission(
            productInfo?.scType, productInfo?.extendScType
        )
        deviceSannerDelegateImpl.initScanner()
        super.onCreate(savedInstanceState)
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object :
            CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
    }

    override fun initData() {
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(
                ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java
            )
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        val productModel = productInfo?.productModel
        val realProductModel = productInfo?.realProductModel
        val models = productInfo?.productModels?.values?.toMutableList() ?: mutableListOf<String>()
        if (productModel?.isNotBlank() == true) {
            models.add(productModel)
        }
        if (realProductModel?.isNotBlank() == true) {
            models.add(realProductModel)
        }
        viewModel.dispatchAction(DevcieScanNearbyUiAction.InitData(productInfo))
    }

    private fun startScanDevice() {
        deviceSannerDelegateImpl.block2 = { show, list ->
            scanDeviceList.clear()
            scanDeviceList.addAll(list)
            if (list.size == 1) {
                viewModel.dispatchAction(
                    DevcieScanNearbyUiAction.ChangeScanUiConfig(scanOneUiConfig, list)
                )
            } else if (list.size > 0) {
                viewModel.dispatchAction(
                    DevcieScanNearbyUiAction.ChangeScanUiConfig(scanMultiUiConfig, list)
                )
            } else {
                viewModel.dispatchAction(
                    DevcieScanNearbyUiAction.ChangeScanUiConfig(scanUiConfig, list)
                )
            }
        }

        deviceSannerDelegateImpl.scanBlock = { stop ->
            val uiConfig = viewModel.uiStates.value.uiConfig
            if (stop) {
                uiConfig?.onScanStop(scanDeviceList.isEmpty())
            } else {
                uiConfig?.onScanStart()
            }
        }
        val scType = when (viewModel.uiStates.value.productInfo?.scType) {
            ScanType.WIFI -> DeviceScanCache.TYPE_WIFI
            ScanType.WIFI_BLE -> DeviceScanCache.TYPE_BOTH
            ScanType.BLE -> DeviceScanCache.TYPE_BLE
            else -> {
                DeviceScanCache.TYPE_WIFI
            }
        }
        deviceSannerDelegateImpl.startScanDevice(clear = true, scanType = scType)
    }

    override fun initView() {
        viewModel.dispatchAction(DevcieScanNearbyUiAction.InitScanUiConfig(scanUiConfig))
        startScanDevice()
    }

    override fun observe() {

    }

    fun gotoMaunalConnect() {
        viewModel.dispatchAction(DevcieScanNearbyUiAction.SelectDevice(null))
        val productInfo = viewModel.uiStates.value.productInfo
        TheRouter.build(RoutPath.DEVICE_CONNECT)
            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
            .withInt(ExtraConstants.EXTRA_STEP, StepId.STEP_MANUAL_CONNECT).navigation()
        finish()
    }

    fun gotoSelectConnect(bean: DreameWifiDeviceBean) {
        val productInfo = viewModel.uiStates.value.productInfo
        productInfo?.deviceWifiName = bean.wifiName
        productInfo?.realProductModel = bean.product_model
        LogUtil.i("sunzhibin", " ---------- select ap name : ${productInfo?.deviceWifiName}")

        LogUtil.i("sunzhibin", " ---------- select ap name : ${bean}")

        LogUtil.i("sunzhibin", " ---------- select ap name : ${productInfo}")

        // 如果扫到了蓝牙，则进入蓝牙配网步骤
        val isBleDevice = bean.result?.contains(productInfo?.productId ?: "-1") == true
        val stepId = if (bean.deviceWrapper != null && BleDeviceScanner.isOpen() && isBleDevice) {
            // 进蓝牙配网
            -1
        } else {
            // Wi-Fi配网
            StepId.STEP_CONNECT_DEVICE_AP
        }
        TheRouter.build(RoutPath.DEVICE_CONNECT)
            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
            .withInt(ExtraConstants.EXTRA_STEP, stepId).navigation()
        finish()
    }

    override fun onDestroy() {
        super.onDestroy()
        mainHandler.removeCallbacks(runnable)
        mainHandler.removeCallbacksAndMessages(null)
    }

    /**
     * 重新扫描
     */
    fun scanAgain(delayMillis: Long = 500) {
        if (delayMillis <= 0) {
            mainHandler.post(runnable)
        } else {
            mainHandler.postDelayed(runnable, delayMillis)
        }
    }

    val runnable = Runnable {
        deviceSannerDelegateImpl.startScanDeviceDirect()
    }

    fun finishScan() {
        deviceSannerDelegateImpl.finishScanDevice()
    }

    override fun onStart() {
        super.onStart()
        registerNetworkCallback()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "",
            viewModel.uiStates.value.productInfo?.realProductModel
                ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ScanDevicePage.code
        )
    }

    override fun onStop() {
        super.onStop()
        unregisterNetworkCallback()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "",
            viewModel.uiStates.value.productInfo?.realProductModel
                ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ScanDevicePage.code
        )
    }

    private fun registerNetworkCallback() {
        val request =
            NetworkRequest.Builder().addTransportType(NetworkCapabilities.TRANSPORT_WIFI).build()
        connectManager.registerNetworkCallback(request, callback)
    }

    private val callback = object : ConnectivityManager.NetworkCallback() {
        override fun onAvailable(network: Network) {
            super.onAvailable(network)
            LogUtil.i("sunzhibin", "onAvailable:  $network ")

            wifiInfo()
        }

        override fun onCapabilitiesChanged(
            network: Network, networkCapabilities: NetworkCapabilities
        ) {
            super.onCapabilitiesChanged(network, networkCapabilities)
            if (networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)) {
                if (networkCapabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                    // check 当前连接SSID
                    LogUtil.i("sunzhibin", "onCapabilitiesChanged:  $network  $networkCapabilities")
                    wifiInfo()
                }
            }
        }

        override fun onLinkPropertiesChanged(network: Network, linkProperties: LinkProperties) {
            super.onLinkPropertiesChanged(network, linkProperties)
            LogUtil.i("sunzhibin", "onLinkPropertiesChanged:  $network  $linkProperties")

        }

    }

    @SuppressLint("MissingPermission")
    private fun wifiInfo() {
        if (!XXPermissions.isGranted(this, Manifest.permission.ACCESS_FINE_LOCATION)) {
            return
        }
        var wifiName = wifiManager.connectionInfo?.ssid?.decodeQuotedSSID() ?: ""
        if ("<unknown ssid>" == wifiName) {
            wifiName = ""
        }// ipaddr 192.168.5.102 gateway 192.168.5.1 netmask 0.0.0.0 dns1 192.168.5.1 dns2 0.0.0.0 DHCP server 192.168.5.1 lease 3600 seconds
        val dhcpInfo = wifiManager.dhcpInfo.toString()
//        val ipaddr = "ipaddr 192.168.5.100"
//        val gateway = "gateway 192.168.5.1"
        val dns1 = "dns1 192.168.5.1"
        val server = "DHCP server 192.168.5.1"
        val isDeviceRouter = dhcpInfo.contains(dns1) || dhcpInfo.contains(server)
        val isDeviceWifiName =
            (wifiName.startsWith(Constants.MODEL_NAME_PREFIX_MOVA) || wifiName.startsWith(Constants.MODEL_NAME_PREFIX_DREAME) || wifiName.startsWith(
                Constants.MODEL_NAME_PREFIX_TROUVER
            )) && wifiName.contains(
                "_miap"
            )
        LogUtil.i("wifiInfo:  $wifiName  $dhcpInfo  $isDeviceRouter  $isDeviceWifiName")
        if (isDeviceRouter && isDeviceWifiName) {
            // 跳转到下一页
            val productInfo = viewModel.uiStates.value.productInfo
            productInfo?.deviceWifiName = wifiName
            TheRouter.build(RoutPath.DEVICE_CONNECT)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                .withInt(ExtraConstants.EXTRA_STEP, StepId.STEP_SEND_DATA_WIFI).navigation()
        }
    }

    private fun unregisterNetworkCallback() {
        runCatching {
            connectManager.unregisterNetworkCallback(callback)
        }
    }
}

