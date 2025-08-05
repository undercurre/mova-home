package com.dreame.feature.connect.router.password

import android.dreame.module.LocalApplication
import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.getString
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LocationUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.SPUtil
import android.dreame.module.util.SocketSSL
import android.dreame.module.util.mqtt.MqttUtil
import android.text.TextUtils
import androidx.core.net.toUri
import androidx.lifecycle.viewModelScope
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.connect.R
import com.zj.mvi.core.setState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import org.eclipse.paho.client.mqttv3.MqttClient
import org.eclipse.paho.client.mqttv3.MqttConnectOptions
import org.eclipse.paho.client.mqttv3.MqttException
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence
import java.net.InetAddress
import java.net.UnknownHostException
import kotlin.coroutines.resume


class RouterConnectPasswordViewModel : BaseViewModel<RouterConnectPasswordUiState, RouterConnectPasswordUiEvent>() {

    private val repository = ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource())

    private var loadWifiListSpJob: Job? = null
    override fun createInitialState(): RouterConnectPasswordUiState {
        return RouterConnectPasswordUiState(
            false, false, linkedMapOf(), null, "", "",
            8, false, -1, "",true, "", "", false
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is RouterConnectPasswordUiAction.InitData -> {
                _uiStates.setState { copy(productInfo = acton.productInfo, configType = acton.configType) }
                loadWifiListFrmSp()
                isShowAfterSale()

            }

            is RouterConnectPasswordUiAction.WifiChange -> {
                viewModelScope.launch(Dispatchers.IO) {
                    if (loadWifiListSpJob?.isActive == true) {
                        loadWifiListSpJob?.join()
                    } else {
                        loadWifiListSpJob = null
                    }
                    val wifiName = acton.wifiName ?: ""
                    val password = uiStates.value.wifiCacheMap[wifiName]
                    _uiStates.setState {
                        copy(
                            currentWifiName = wifiName,
                            wifiPassword = password,
                            isWifiConnect = acton.isConnect,
                            frequency = acton.frequency
                        )
                    }
                    //
                    buttonEnable()
                }
            }

            is RouterConnectPasswordUiAction.WifiPassword -> {
                viewModelScope.launch(Dispatchers.IO) {
                    if (loadWifiListSpJob?.isActive == true) {
                        loadWifiListSpJob?.join()
                    } else {
                        loadWifiListSpJob = null
                    }
                    val wifiName = uiStates.value.currentWifiName
                    uiStates.value.wifiCacheMap[wifiName] = acton.password ?: ""
                    _uiStates.setState { copy(wifiPassword = acton.password) }
                    buttonEnable()
                }
                startLocation()

            }

            is RouterConnectPasswordUiAction.WifiPassword2 -> {
                _uiStates.setState {
                    copy(
                        currentWifiName = acton.wifiName,
                        wifiPassword = acton.password
                    )
                }
            }

            is RouterConnectPasswordUiAction.CheckNetworkCondition -> {
                // 检查是否满足网络条件
                checkNetworkCondition()
            }

            is RouterConnectPasswordUiAction.CheckNetworkFrequencyBandSkip -> {
                // 检查是否满足网络条件
                checkNetworkCondition(true)
            }

            is RouterConnectPasswordUiAction.ConfirmNoPasswordSkip -> {
                // 检查是否满足网络条件
                checkNetworkCondition(true, true)
            }

        }

    }

    var locationJob: Job? = null
    private fun startLocation() {
        if (locationJob != null && locationJob?.isActive == true) {
            return
        }
        locationJob = viewModelScope.launch {
            val pair = LocationUtils.getCurrentLocationAreaCode()
            val countryCode = pair.second
            LogUtil.i("sunzhibin", "requestLocation: ${pair.first}  countryCode: $countryCode")
            val isGpsLock = LocationUtils.isGpsLock(countryCode = countryCode)
            LogUtil.i("sunzhibin", "isGpsLock: $isGpsLock")
        }
    }

    private fun isShowAfterSale() {
        try {
            val roleName = AccountManager.getInstance().account.role_name
            if (roleName != null) {
                val split = roleName.split(",".toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
                for (role in split) {
                    if ("a_sale" == role) {
                        _uiStates.setState { copy(isAfterSale = true) }
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun loadWifiListFrmSp() {
        loadWifiListSpJob = viewModelScope.launch(Dispatchers.IO) {
            val wifiListStr = SPUtil.get(LocalApplication.getInstance(), ExtraConstants.SP_KEY_WIFI_LIST, "") as String
            var map = emptyMap<String, String>()
            if (!TextUtils.isEmpty(wifiListStr)) {
                map = GsonUtils.parseMaps(wifiListStr) ?: emptyMap()
            }
            val wifiCacheMap = map.toMap(LinkedHashMap())
            _uiStates.setState { copy(wifiCacheMap = wifiCacheMap) }
        }
    }

    /**
     * 校验条件
     * @param frequencySkip
     * @param passwordSkip
     */
    private fun checkNetworkCondition(frequencySkip: Boolean = false, passwordSkip: Boolean = false) {
        viewModelScope.launch(Dispatchers.IO) {
            _uiStates.setState { copy(isLoading = true) }
            //1、 是否连接的设备热点
            var frequencyBand = checkNetworkConnectAP()

            if (frequencyBand && !frequencySkip) {
                //2、 是否连接的正确的频率
                frequencyBand = checkNetworkFrequencyBand()
            }
            if (frequencyBand && !passwordSkip) {
                //5、 是否无密码
                frequencyBand = confirmNoPassword()
            }
            if (frequencyBand) {
                //3、 是否可连接外网
                LogUtil.i("sunzhibin", "------------ checkNetworkConnectInternet start --------")
                frequencyBand = checkNetworkConnectInternet()
                LogUtil.i("sunzhibin", "------------ checkNetworkConnectInternet end --------")
            }
            if (frequencyBand) {
                //4、 是否可连接ENQ
                LogUtil.i("sunzhibin", "------------ checkNetworkConnectEMQ start --------")
                /// 优先检查一下当前mqtt连接状态，未连接时，尝试自己连一下
                frequencyBand = withContext(Dispatchers.Main) {
                    RouteServiceProvider.getService<IFlutterBridgeService>()?.checkMqttConnect() ?: false
                }
                if (!frequencyBand) {
                    frequencyBand = checkNetworkConnectEMQ()
                    frequencyBand = true
                } else {
                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code,
                        PairNetEventCode.UnReachableToEMQ.code,
                        hashCode(),
                        "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                        int1 = 1,
                        int2 = 1,
                        str1 = BuriedConnectHelper.currentSessionID(),
                    )
                }
                LogUtil.i("sunzhibin", "------------ checkNetworkConnectEMQ end --------")
            }
            if (frequencyBand) {
                // 5、保存Wi-Fi List
//                    saveWifiList()
                /// 定位
                if (locationJob?.isActive == true) {
                    locationJob?.join()
                }
                //6、 success
                _uiStates.setState { copy(isLoading = false) }
                _uiEvents.send(RouterConnectPasswordUiEvent.Success)
            }
            _uiStates.setState { copy(isLoading = false) }
        }
    }

    private suspend fun checkNetworkConnectAP(): Boolean {
        val currentWifiName = uiStates.value.currentWifiName
        if (currentWifiName.startsWith("dreame_dock_")
            || currentWifiName.startsWith("dreame-vacuum-")
            || currentWifiName.startsWith("dreame-hold-")
            || currentWifiName.startsWith("dreame_hold_")

            || currentWifiName.startsWith("mova_dock_")
            || currentWifiName.startsWith("mova-vacuum-")
            || currentWifiName.startsWith("mova-hold-")
            || currentWifiName.startsWith("mova_hold_")

            || currentWifiName.startsWith("trouver_dock_")
            || currentWifiName.startsWith("trouver-vacuum-")
            || currentWifiName.startsWith("trouver-hold-")
            || currentWifiName.startsWith("trouver_hold_")

        ) {
            _uiStates.setState { copy(isLoading = false) }

            _uiEvents.send(RouterConnectPasswordUiEvent.ShowToast(getString(R.string.text_device_hotspot_tip)))
            return false
        }
        if (currentWifiName.startsWith("mova_") || currentWifiName.startsWith("dreame_")) {
            if (currentWifiName.contains("_miap")) {
                _uiStates.setState { copy(isLoading = false) }

                _uiEvents.send(RouterConnectPasswordUiEvent.ShowToast(getString(R.string.text_device_hotspot_tip)))
                return false
            }
        }
        return true
    }

    private suspend fun checkNetworkConnectInternet(): Boolean {
        return suspendCancellableCoroutine { coroutine ->
            getMqttDomainV2 { ret ->
                coroutine.resume(ret)
            }
        }

    }

    private fun getMqttDomainV2(block: (result: Boolean) -> Unit) {
        viewModelScope.launch {
            repository.getMqttDomainV2(AreaManager.getRegion(), false).collect {
                if (it is Result.Success) {
                    _uiStates.setState { copy(domain = it.data?.regionUrl ?: "", pairQRKey = it.data?.pairQRKey ?: "") }
                    block(true)
                } else {
                    _uiStates.setState { copy(isLoading = false) }
                    _uiEvents.send(RouterConnectPasswordUiEvent.ShowToast(getString(R.string.text_wifi_is_unreachable)))
                    block(false)
                }
            }
        }
    }


    /**
     * 判断连接EMQ服务器正常
     */
    private suspend fun checkNetworkConnectEMQ(): Boolean {
        val mqttClient = MqttClient(MqttUtil.getServerUrl(), MqttUtil.mqttClientId(), MemoryPersistence())
        val account = AccountManager.getInstance().account
        val connectOptions = MqttConnectOptions().apply {
            isAutomaticReconnect = false
            isCleanSession = true
            connectionTimeout = 8
            keepAliveInterval = 15

            userName = account?.uid ?: ""
            password = (account?.access_token ?: "").toCharArray()
            socketFactory = SocketSSL.getSocketFactory()

        }
        try {
            LogUtil.i("sunzhibin", "------------ connectWithResult start -------- $connectOptions")
            mqttClient.connect(connectOptions)
            LogUtil.i("sunzhibin", "------------ connectWithResult end -------- ${mqttClient.isConnected}")
            if (mqttClient.isConnected) {
                LogUtil.i("sunzhibin", "------------ disconnectForcibly start --------")
                mqttClient.disconnectForcibly(500, 1000)
                mqttClient.close(true)
                LogUtil.i("sunzhibin", "------------ disconnectForcibly end -------- ${mqttClient.isConnected}")
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code,
                    PairNetEventCode.UnReachableToEMQ.code,
                    hashCode(),
                    "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                    int1 = 1,
                    int2 = 1,
                    str1 = BuriedConnectHelper.currentSessionID(),
                )
                return true
            } else {
                LogUtil.e("sunzhibin", "------------ connectWithResult ")
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code,
                    PairNetEventCode.UnReachableToEMQ.code,
                    hashCode(),
                    "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                    int1 = 0,
                    int2 = 1,
                    str1 = BuriedConnectHelper.currentSessionID(),
                    str2 = "mqttClient.isConnected:${mqttClient.isConnected}",
                    rawStr = "mqttClient.isConnected:${mqttClient.isConnected} ,currentServerURI: ${mqttClient.currentServerURI} ,clientId: ${mqttClient.clientId} ,connectOptions: $connectOptions",
                )
            }
        } catch (e: MqttException) {
            e.printStackTrace()
            if (e.cause is UnknownHostException) {
                /// 未知域名
                withContext(Dispatchers.IO) {
                    val hostAddresss = runCatching {
                        val host = MqttUtil.getServerUrl().toUri().host
                        val addresses = InetAddress.getAllByName(host).map {
                            it.hostAddress
                        }.joinToString()
                        addresses
                    }.getOrNull()
                    LogUtil.i("sunzhibin", "------------ checkNetworkConnectEMQ start -------- $hostAddresss")
                    EventCommonHelper.eventCommonPageInsert(
                        ModuleCode.PairNetNew.code,
                        PairNetEventCode.UnReachableToEMQ.code,
                        hashCode(),
                        "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                        int1 = 0,
                        int2 = 0,
                        str1 = BuriedConnectHelper.currentSessionID(),
                        str2 = "UnknownHostException",
                        str3 = hostAddresss ?: "",
                        rawStr = "$e",
                    )
                }
            } else {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code,
                    PairNetEventCode.UnReachableToEMQ.code,
                    hashCode(),
                    "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                    int1 = 0,
                    int2 = 1,
                    str1 = BuriedConnectHelper.currentSessionID(),
                    str2 = e.javaClass.simpleName,
                    rawStr = "$e",
                )
            }
            LogUtil.e("MqttException: ${e.stackTraceToString()}")

        }
        val frequencyBand = withContext(Dispatchers.Main) {
            RouteServiceProvider.getService<IFlutterBridgeService>()?.checkMqttConnect() ?: false
        }
        if (frequencyBand) {
            return true
        } else {
            _uiStates.setState { copy(isLoading = false) }
//            _uiEvents.send(RouterConnectPasswordUiEvent.ShowToast(getString(R.string.text_failed_connect_emq)))
        }
        return false
    }

    private suspend fun checkNetworkFrequencyBand(): Boolean {
        val frequency = uiStates.value.frequency
        val is24G = frequency > 2400 && frequency < 2500
        if (is24G) {
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code, PairNetEventCode.Is5GHz.code, hashCode(),
                "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
                int1 = 0, str1 = BuriedConnectHelper.currentSessionID(), str2 = "${frequency}"
            )
            return true
        } else {
            _uiStates.setState { copy(isLoading = false) }

            _uiEvents.send(RouterConnectPasswordUiEvent.ShowNetworkFrequencyBandError)
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.Is5GHz.code, hashCode(),
            "", uiStates.value.productInfo?.realProductModel ?: uiStates.value.productInfo?.productModel ?: "",
            int1 = 1, str1 = BuriedConnectHelper.currentSessionID(), str2 = "${frequency}"
        )
        return false
    }

    private suspend fun confirmNoPassword(): Boolean {
        if (uiStates.value.wifiPassword.isNullOrBlank()) {
            _uiStates.setState { copy(isLoading = false) }

            _uiEvents.send(RouterConnectPasswordUiEvent.ShowConfirmNoPassword)
            return false
        }
        return true
    }

    /**
     * button enable
     */
    private fun buttonEnable() {
        if (uiStates.value.currentWifiName.isNotBlank()) {
            if (uiStates.value.wifiPassword.isNullOrBlank() || (uiStates.value.wifiPassword?.length ?: 0) >= 8) {
                _uiStates.setState { copy(buttonEnable = true) }
                return
            }
        }
        _uiStates.setState { copy(buttonEnable = false) }
    }
}