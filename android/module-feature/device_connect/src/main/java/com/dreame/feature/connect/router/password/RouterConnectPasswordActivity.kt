package com.dreame.feature.connect.router.password

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.ext.decodeQuotedSSID
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.dreame.module.view.CommonTitleView
import android.net.ConnectivityManager.NetworkCallback
import android.net.LinkProperties
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiManager
import android.os.Bundle
import android.provider.Settings
import android.view.View
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.android.netlibrary.externs.connectivityManager
import com.dreame.feature.connect.config.step.bluetooth.BleDeviceScanner
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.utils.permission.CheckLocationPermissionDelegate
import com.dreame.feature.connect.views.NetworkBandErrorPopupwindow
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.BottomConfirmDialog
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityRouterConnectPasswordBinding
import com.hjq.permissions.XXPermissions
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import kotlin.toString

/**
 * 输入路由密码页
 */
@Route(path = RoutPath.DEVICE_ROUTER_PASSWORD)
class RouterConnectPasswordActivity : BaseActivity<ActivityRouterConnectPasswordBinding>() {

    private val viewModel by viewModels<RouterConnectPasswordViewModel>()
    private val connectManager by lazy { application.connectivityManager() }
    private val wifiManager by lazy { getApplicationContext().getSystemService(Context.WIFI_SERVICE) as WifiManager }
    private lateinit var checkLocationPermissionDelegate: CheckLocationPermissionDelegate

    override fun onCreate(savedInstanceState: Bundle?) {

        checkLocationPermissionDelegate = CheckLocationPermissionDelegate(this).apply {
            val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
            val scType = productInfo?.scType ?: ""
            val extendScType = productInfo?.extendScType ?: emptyList()

            addSkipNeverNecessarilyPermission(scType, extendScType)

        }

        super.onCreate(savedInstanceState)
    }


    override fun initData() {
        val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        val configType = intent.getBooleanExtra("CONFIG_TYPE", false)
        viewModel.dispatchAction(RouterConnectPasswordUiAction.InitData(productInfo, configType))
    }

    override fun initView() {
        binding.indicator.setIndex(1)
    }

    override fun onResume() {
        super.onResume()
        wifiInfo()
    }

    override fun onBackPressed() {
        super.onBackPressed()
    }


    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        binding.tvWifiName.setOnShakeProofClickListener {
            // goto setting
            startActivity(Intent(Settings.ACTION_WIFI_SETTINGS))
        }
        binding.tvConfirm.setOnShakeProofClickListener {
            /// 分发当前的Wi-Fi 和密码
            val wifiName = binding.tvWifiName.text.toString()
            val wifiPassword = binding.etPassword.getText()
            LogUtil.i("SmartStep WifiPassword2 ,wifiName: $wifiName  wifiPassword: $wifiPassword")
            viewModel.dispatchAction(RouterConnectPasswordUiAction.WifiPassword2(wifiName, wifiPassword))
            viewModel.dispatchAction(RouterConnectPasswordUiAction.CheckNetworkCondition)
        }
        binding.etPassword.addBytesLengthTextChangedListener(63) {
            viewModel.dispatchAction(RouterConnectPasswordUiAction.WifiPassword(it?.toString()))
        }
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, RouterConnectPasswordUiState::isAfterSale) {
            binding.cbSwitch.visibility = if (it) View.VISIBLE else View.INVISIBLE
            binding.cbSwitch.isChecked = it
        }
        viewModel.uiStates.observeState(this, RouterConnectPasswordUiState::buttonEnable) {
            binding.tvConfirm.isEnabled = it
        }
        viewModel.uiStates.observeState(
            this, RouterConnectPasswordUiState::currentWifiName,
            RouterConnectPasswordUiState::wifiPassword
        ) { name, password ->
            if (binding.tvWifiName.text != name) {
                binding.etPassword.setContent(password ?: "")
            }
        }
        viewModel.uiStates.observeState(this, RouterConnectPasswordUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(this, RouterConnectPasswordUiState::currentWifiName) {
            binding.tvWifiName.text = it
        }
        viewModel.uiStates.observeState(this, RouterConnectPasswordUiState::configType) {
            if (it) {
                binding.indicator.visibility = View.GONE;
            }
        }

        viewModel.uiEvents.observeEvent(this) { event ->
            when (event) {
                is RouterConnectPasswordUiEvent.ShowToast -> {
                    ToastUtils.show(event.message)
                }

                is RouterConnectPasswordUiEvent.ShowNetworkFrequencyBandError -> {
                    showNetworkFrequencyBandError()
                }

                is RouterConnectPasswordUiEvent.ShowConfirmNoPassword -> {
                    showConfirmNoPassword()
                }

                is RouterConnectPasswordUiEvent.Success -> {
                    StepData.capabilities = viewModel.uiStates.value.capabilities
                    var productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
                    productInfo =
                        productInfo?.copy(
                            targetDomain = viewModel.uiStates.value.domain,
                            targetWifiName = viewModel.uiStates.value.currentWifiName,
                            targetWifiPwd = viewModel.uiStates.value.wifiPassword,
                            isAfterSales = binding.cbSwitch.isChecked
                        )

                    if (viewModel.uiStates.value.configType) {
                        setResult(
                            RESULT_OK, Intent().putExtra(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                                .putExtra(ExtraConstants.EXTRA_DOMAIN, viewModel.uiStates.value.domain)
                                .putExtra(ExtraConstants.EXTRA_INPUT_WIFI_NAME, viewModel.uiStates.value.currentWifiName)
                                .putExtra(ExtraConstants.EXTRA_INPUT_WIFI_PWD, viewModel.uiStates.value.wifiPassword)
                                .putExtra(ExtraConstants.EXTRA_ROLE_AFTER_SALES, binding.cbSwitch.isChecked)
                        )
                        finish()
                    } else {

                        val isScan = productInfo?.enterOrigin == ParameterConstants.ORIGIN_SCAN
                        val path = if (isScan) {
                            RoutPath.DEVICE_CONNECT
                        } else {
                            if (productInfo?.productModel?.contains("vacuum") == true) {
                                RoutPath.DEVICE_BOOT_UP
                            } else {
                                RoutPath.DEVICE_TRIGGER_AP
                            }
                        }

                        val isBle = productInfo?.isBLE == true || DeviceScanCache.getBleDeviceScan().value?.filter {
                            val isBleDevice = it.result?.contains(productInfo?.productId ?: "-1") == true
                            it.deviceWrapper != null && it.wifiName == productInfo?.deviceWifiName && isBleDevice
                        }?.isNotEmpty() ?: false
                        val stepId = if (isBle && BleDeviceScanner.isOpen()) {
                            -1
                        } else {
                            StepId.STEP_CONNECT_DEVICE_AP
                        }
                        TheRouter.build(path)
                            .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                            .withInt(ExtraConstants.EXTRA_STEP, stepId)
                            .navigation()

                    }
                }

                else -> {}
            }
        }
    }

    private fun showConfirmNoPassword() {
        BottomConfirmDialog(this).show(
            getString(R.string.text_no_need_pwd),
            getString(R.string.yes),
            getString(R.string.input_wifi_password), { dialog ->
                dialog.dismiss()
                viewModel.dispatchAction(RouterConnectPasswordUiAction.ConfirmNoPasswordSkip)
            }
        ) { dialog ->
            dialog.dismiss()
        }
    }

    private fun showNetworkFrequencyBandError() {
        NetworkBandErrorPopupwindow(this)
            .setCurrentWifi(viewModel.uiStates.value.currentWifiName)
            .sessionID(BuriedConnectHelper.currentSessionID())
            .onCancelClick {
                //
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code,
                    PairNetEventCode.ChangeBand.code,
                    hashCode(),
                    "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
                    int1 = 0,
                    str1 = BuriedConnectHelper.currentSessionID()
                )
                viewModel.dispatchAction(RouterConnectPasswordUiAction.CheckNetworkFrequencyBandSkip)
            }
            .onConfirmClick {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code,
                    PairNetEventCode.ChangeBand.code,
                    hashCode(),
                    "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
                    int1 = 1,
                    str1 = BuriedConnectHelper.currentSessionID()
                )
                binding.tvWifiName.performClick()
            }
            .showPopupWindow()
    }

    override fun onStart() {
        super.onStart()
        registerNetworkCallback()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ConnectRoutePage.code
        )
    }

    override fun onStop() {
        unregisterNetworkCallback()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ConnectRoutePage.code
        )
        super.onStop()

    }

    private fun registerNetworkCallback() {
//        val intentFilter = IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION).apply {
//            addAction(WifiManager.NETWORK_STATE_CHANGED_ACTION)
//            addAction(WifiManager.WIFI_STATE_CHANGED_ACTION)
//        }
//        registerReceiver(receiver, intentFilter)

        val request = NetworkRequest.Builder()
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
            .build()
        connectManager.registerNetworkCallback(request, callback)
    }

    private val callback = object : NetworkCallback() {
        override fun onAvailable(network: Network) {
            super.onAvailable(network)
            LogUtil.i("sunzhibin", "onAvailable:  $network ")

            wifiInfo()
        }

        override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) {
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
        }

    }

    @SuppressLint("MissingPermission")
    private fun wifiInfo() {
        // 判断权限
        if (!XXPermissions.isGranted(this, Manifest.permission.ACCESS_FINE_LOCATION)) {
            viewModel.dispatchAction(RouterConnectPasswordUiAction.WifiChange("", false, 0, ""))
            return
        }
        var wifiName = wifiManager.connectionInfo?.ssid?.decodeQuotedSSID() ?: ""
        if ("<unknown ssid>" == wifiName) {
            wifiName = ""
        }
        var frequency = wifiManager.connectionInfo?.frequency ?: -1
        var capabilities = ""
        // 获取缓存的Wi-Fi列表
        val scanResults = wifiManager.scanResults
        val filter = scanResults.filter {
            it.SSID.decodeQuotedSSID() == wifiName && (it.frequency >= 2412 && it.frequency <= 2484)
        }
        if (filter.isNotEmpty()) {
            frequency = filter.get(0).frequency
            capabilities = filter[0].capabilities
            LogUtil.i("RouterConnectPasswordActivity", "wifiInfo:  capabilities: $capabilities")
        }
        viewModel.dispatchAction(RouterConnectPasswordUiAction.WifiChange(wifiName, true, frequency, capabilities))
    }

    private fun unregisterNetworkCallback() {
        runCatching {
            connectManager.unregisterNetworkCallback(callback)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

}


