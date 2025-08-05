package com.dreame.feature.connect.qr

import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.constant.Constants
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.HostFixUtils
import android.dreame.module.util.LogUtil
import android.net.Uri
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import androidx.lifecycle.viewModelScope
import com.therouter.TheRouter
import com.blankj.utilcode.util.NetworkUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.service.IAppConfigureService
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.tools.step.qrcodecore.ui.cameraX.QrScanConfig
import com.google.gson.JsonParser
import com.zj.mvi.core.setState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull

class QRDeviceScanViewModel : BaseViewModel<QRDeviceScanUiState, QRDeviceScanUiEvent>() {

    private val repo by lazy { ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource()) }

    override fun createInitialState(): QRDeviceScanUiState {
        return QRDeviceScanUiState(
            "", false, false,
            false, false, true, false, 0, null, null, null, 0
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is QrDeviceScanUiAction.InitData -> {
                viewModelScope.launch {
                    _uiStates.setState {
                        copy(language = acton.language, scanType = acton.scanType)
                    }
                }
                QrScanConfig.initScanConfig(
                    acton.filterQrCode,
                    filterWebEnable = true,
                    qrHost = arrayOf(
                        "app.mova-tech.com",
                        "app.mova-tech.com/",
                        "app.dreame.tech",
                        "app.dreame.tech/",
                        "app.trouver-tech.com",
                        "app.trouver-tech.com/",
                    )
                )
                QrScanConfig.configScanConfig(true, acton.scanType == 2, acton.scanType == 0)
                initSomeNecessaryCondition()
            }

            is QrDeviceScanUiAction.FlashlightOpen -> {
                viewModelScope.launch {
                    _uiStates.setState {
                        copy(isFlashlightOpen = acton.open)
                    }
                }
            }

            is QrDeviceScanUiAction.SettingIsCheckFirst -> {
                viewModelScope.launch {
                    _uiStates.setState {
                        copy(isCheckFirst = acton.isCheckFirst)
                    }
                }
            }

            is QrDeviceScanUiAction.FromSettingPage -> {
                viewModelScope.launch {
                    _uiStates.setState {
                        copy(fromSettingPage = true)
                    }
                }
            }

            is QrDeviceScanUiAction.ViewQRPoistion -> {
                gotoWhereIsQrPosition()
            }

            is QrDeviceScanUiAction.OnQRScanTouchSuccess -> {
                if (uiStates.value.scanType == 2) {
                    // 商城扫描SN码
                    onScanBarcodeSuccess(acton.result)
                } else {
                    onScanTouchSuccess(acton.result)
                }
            }

            is QrDeviceScanUiAction.NearbyDevice -> {
                _uiStates.setState {
                    copy(nearbyDevice = acton.device)
                }
            }

            is QrDeviceScanUiAction.NearbyDeviceClick -> {
                gotoConnectNearby()
            }

        }
    }

    private fun gotoWhereIsQrPosition() {
        viewModelScope.launch {
            val qrPositionUrl = uiStates.value.qrPositionUrl
            if (qrPositionUrl == null) {
                val serviceDoamin = RouteServiceProvider.getService<IAppConfigureService>()?.serviceAppPrivacyDoamin() ?: ""
                val url = serviceDoamin.toHttpUrlOrNull()?.let {
                    it.newBuilder()
                        .scheme(it.scheme) // 更换网络协议
                        .addPathSegment("ercode.html")
                        .addQueryParameter("lang", LanguageManager.getInstance().getLangTag(LocalApplication.getInstance()))
                        .addQueryParameter("tenantId", LocalApplication.getInstance().tenantId)
                        .build().toString()
                }
                _uiStates.value = _uiStates.value.copy(qrPositionUrl = url)
            }
            TheRouter.build(RoutPath.MAIN_WEBVIEW)
                .withString(Constants.KEY_WEB_TITLE, getString(R.string.position_of_qr))
                .withString(Constants.KEY_WEB_URL, _uiStates.value.qrPositionUrl)
                .navigation()
        }
    }

    /**
     * 初始化必要条件
     */
    private fun initSomeNecessaryCondition() {
        viewModelScope.launch(Dispatchers.IO) {
            try {
//                WeChatQRCodeDetector.init(LocalApplication.getInstance())
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e(Log.getStackTraceString(e))
                _uiEvents.send(QRDeviceScanUiEvent.ManualConnect)
            }
        }
    }

    private fun onScanBarcodeSuccess(result: String?) {
        viewModelScope.launch {
            _uiEvents.send(QRDeviceScanUiEvent.BarcodeSuccess(result ?: ""))
        }
    }

    private fun onScanTouchSuccess(result: String?) {
        viewModelScope.launch {
            val elapsedRealtime = SystemClock.elapsedRealtime()
            if (elapsedRealtime - uiStates.value.time < 100) {
                return@launch
            }
            _uiStates.setState { copy(time = elapsedRealtime) }
            result?.run {
                val resultStr = result.trim()
                // 解析 结果拦截
                val parseQrCodeADDResult = parseQrCodeADDResult(resultStr)
                if (parseQrCodeADDResult) {
                    _uiEvents.send(QRDeviceScanUiEvent.QrCodeAddPluginList(resultStr))
                    return@run
                }
                //
                val parseQrCodeResult = parseQrCodeResult(resultStr)
                if (parseQrCodeResult) {
                    uiStates.value.productInfo?.productModel?.let {
                        queryDeviceModelInfo(it)
                    }
                } else {
                    _uiEvents.send(QRDeviceScanUiEvent.ShowToast(getString(R.string.current_device_nuInfo)))
                    delay(1500)
                    _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)
                }
            } ?: kotlin.run {
                _uiEvents.send(QRDeviceScanUiEvent.ShowToast(getString(R.string.current_device_nuInfo)))
                delay(1500)
                _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)

            }
        }
    }

    /**
     * 解析添加插件二维码
     */
    private fun parseQrCodeADDResult(result: String): Boolean {
        runCatching {
            if (result.startsWith("[") || result.startsWith("{")) {
                val parseString = JsonParser.parseString(result).asJsonObject
                if ((parseString.has("ip") && parseString.has("projects"))) {
                    return true
                }
            }
        }
        return false
    }

    private suspend fun queryDeviceModelInfo(model: String) {
        repo.checkModel(model)
            .onStart {
                _uiStates.setState {
                    copy(isLoading = true)
                }
            }.onCompletion {
                _uiStates.setState {
                    copy(isLoading = false)
                }
            }.flowOn(Dispatchers.IO)
            .collect { result ->
                when (result) {
                    is Result.Success -> {
                        // 处理数据
                        val data = result.data
                        if (data != null) {
                            gotoConnectQR(data)
                        } else {
                            _uiEvents.send(QRDeviceScanUiEvent.ShowFailedDialog)
                        }
                    }

                    is Result.Error -> {
                        when (result.exception.code) {
                            -1 -> {
                                _uiEvents.send(QRDeviceScanUiEvent.ShowToast(getString(R.string.no_net_check_state)))
                                delay(1500)
                                _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)
                            }

                            50501 -> { // 设备未上线
                                _uiEvents.send(QRDeviceScanUiEvent.ShowToast(getString(R.string.product_not_online)))
                                delay(1500)
                                _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)
                            }

                            50502 -> { // 所在地区不支持该设备
                                _uiEvents.send(QRDeviceScanUiEvent.ShowToast(getString(R.string.product_not_support)))
                                delay(1500)
                                _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)
                            }

                            50503 -> { // 该设备未分类配置
                                _uiEvents.send(QRDeviceScanUiEvent.ShowToast(getString(R.string.product_not_classified)))
                                delay(1500)
                                _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)
                            }

                            else -> {
                                _uiEvents.send(QRDeviceScanUiEvent.ShowToast(result.exception.message))
                                delay(1500)
                                _uiEvents.send(QRDeviceScanUiEvent.RestQrScan)
                            }
                        }
                    }

                    else -> {

                    }
                }
            }
    }

    private fun gotoConnectQR(data: ProductListBean) {
        val timestamp = System.currentTimeMillis()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterSourceType.code, hashCode(),
            "", data.model,
            int1 = ParameterConstants.ORIGIN_QR, str1 = BuriedConnectHelper.currentSessionID()
        )
        val productInfo = uiStates.value.productInfo
        val productInfoCopy = productInfo?.copy(
            productModel = data.model,
            productModels = data.quickConnects,
            productId = data.productId,
            feature = data.feature,
            scType = data.scType,
            extendScType = data.extendScType,
            productPicUrl = data.mainImage?.imageUrl,
            timestamp = timestamp
        )
        _uiStates.setState {
            copy(productInfo = productInfoCopy)
        }
        viewModelScope.launch(Dispatchers.IO) {
            val wifiConnected = NetworkUtils.isWifiConnected()
            val int1 = if (wifiConnected) 1 else 0
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code, PairNetEventCode.WifiIsConnect.code, hashCode(),
                "", data.model,
                int1 = int1, str1 = BuriedConnectHelper.currentSessionID()
            )
            val path =
                if (productInfoCopy?.productModel?.contains(".mower.") == true) {
                    RoutPath.PRODUCT_CONNECT_PREPARE_BLE
                } else if (productInfoCopy?.productModel?.contains(".toothbrush.") == true
                    || productInfoCopy?.extendScType?.contains(
                        ScanType.MCU
                    ) == true
                ) {
                    RoutPath.DEVICE_CONNECT
                } else {
                    if (wifiConnected) RoutPath.DEVICE_ROUTER_PASSWORD else RoutPath.DEVICE_ROUTER_TIPS
                }
            TheRouter.build(path)
                .withParcelable(ParameterConstants.EXTRA_PRODUCT_INFO, productInfoCopy)
                .navigation()
        }
    }


    private fun gotoConnectNearby() {
        val timestamp = System.currentTimeMillis()
        uiStates.value.nearbyDevice?.let { bean ->
            bean.deviceProduct?.let { product ->
                val productInfo = StepData.ProductInfo(
                    product.model, product.quickConnects, bean.wifiName, null, product.productId, product.feature, bean.product_model,
                    true, ParameterConstants.ORIGIN_SCAN,
                    product.scType, product.extendScType,
                    null, null, bean.product_pic_url, timestamp = timestamp
                )
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code, PairNetEventCode.EnterSourceType.code, hashCode(),
                    "", bean.product_model,
                    int1 = ParameterConstants.ORIGIN_SCAN, str1 = BuriedConnectHelper.currentSessionID()
                )
                var int1 = -1
                var stepId = -1
                val path =
                    if (productInfo.productModel?.contains(".mower.") == true) {
                        RoutPath.PRODUCT_CONNECT_PREPARE_BLE
                    } else if (productInfo.productModel?.contains(".toothbrush.") == true || productInfo.extendScType?.contains(
                            ScanType.MCU
                        ) == true
                    ) {
                        stepId = StepId.STEP_DEVICE_SCAN_BLE
                        RoutPath.DEVICE_BOOT_UP
                    } else {
                        if (NetworkUtils.isWifiConnected()) {
                            int1 = 1
                            RoutPath.DEVICE_ROUTER_PASSWORD
                        } else {
                            int1 = 0
                            RoutPath.DEVICE_ROUTER_TIPS
                        }
                    }
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code, PairNetEventCode.WifiIsConnect.code, hashCode(),
                    "", bean.product_model,
                    int1 = int1, str1 = BuriedConnectHelper.currentSessionID()
                )
                TheRouter.build(path)
                    .withParcelable(ParameterConstants.EXTRA_PRODUCT_INFO, productInfo)?.apply {
                        if (stepId != -1) {
                            withInt(ExtraConstants.EXTRA_STEP, stepId)
                        }
                    }?.navigation()
            }
        }
    }


    private fun parseQrCodeResult(result: String): Boolean {
        val uri = Uri.parse(result)
        val host = uri.host

        var parseModel = ""
        var parseWifiName = ""
        when {
            TextUtils.equals("app.dreame.tech", host)
                    || TextUtils.equals("app.mova-tech.com", host)
                    || TextUtils.equals("app.trouver-tech.com", host) -> {
                val mac = uri.getQueryParameter("m") ?: uri.getQueryParameter("mac")
                var model = uri.getQueryParameter("model") ?: ""
                val wifiName = if (model.isNotEmpty() && mac?.isNotEmpty() == true) {
                    model.replace(".", "-") + "_miap" + mac.replace(":", "").let { it.substring(it.length - 4) }
                } else {
                    ""
                }
                // 兼容垃圾二维码
                model = if (model.endsWith("2257")) {
                    model.replace("2257", "2257o")
                } else {
                    model
                }
                parseWifiName = wifiName
                parseModel = model
            }

            else -> {

            }

        }
        val productInfo = StepData.ProductInfo(
            parseModel, null, parseWifiName, null, null, null,
            parseModel, true, enterOrigin = ParameterConstants.ORIGIN_QR, null, null, null, null, null
        )
        _uiStates.setState {
            copy(productInfo = productInfo)
        }

        return parseModel.isNotEmpty()

    }

}