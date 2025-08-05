package com.dreame.feature.connect.device.qrnet

import android.dreame.module.LocalApplication
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.entry.device.DeviceQRNetPairReq
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ExceptionStatisticsEventCode
import android.dreame.module.trace.ModuleCode
import android.dreame.module.util.LocationUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.mqtt.MqttUtil
import android.util.Log
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.config.step.ExtendScType
import com.dreame.smartlife.config.step.StepData
import com.zj.mvi.core.setState
import io.reactivex.Flowable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.internal.disposables.ListCompositeDisposable
import io.reactivex.schedulers.Schedulers
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.util.TimeZone
import java.util.concurrent.TimeUnit
import com.dreame.tools.step.qrcodecore.ui.cameraX.utils.QRCodeGenerator

class DeviceQrNetViewModel : BaseViewModel<DeviceQrNetUiState, DeviceQrNetUiEvent>() {
    private val repository = ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource())
    private val disposableContainer by lazy { ListCompositeDisposable() }

    override fun createInitialState(): DeviceQrNetUiState {
        return DeviceQrNetUiState(
            false, null,
            "", "", "", "", "", null, 0, false, 0
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is DeviceQrNetUiAction.InitData -> {
                _uiStates.setState {
                    copy(
                        productInfo = acton.productInfo,
                        langTag = acton.langTag,
                        targetWifiName = acton.targetWifiName,
                        targetWifiPwd = acton.targetWifiPwd,
                        timestamp = 0,
                        qrcodeBitmap = null

                    )
                }
            }

            is DeviceQrNetUiAction.QueryDomainRetry -> {

                getMqttDomainV2()
            }

            is DeviceQrNetUiAction.QueryQRNetResult -> {
                loopQueryQrNetResult()
            }

            is DeviceQrNetUiAction.GotoNext -> {
                viewModelScope.launch {
                    _uiEvents.send(DeviceQrNetUiEvent.GotoNext(acton.bindSuccess, "", clickTime = acton.clickTime))
                }
            }

            is DeviceQrNetUiAction.CreateQRCodeRetry -> {
                viewModelScope.launch {
                    creatQRNetBitmap()
                }
            }

            is DeviceQrNetUiAction.OnStart -> {
                val currentTimeMillis = System.currentTimeMillis()
                val timestamp = uiStates.value.timestamp
                val l = currentTimeMillis - timestamp
                if (l >= 8 * 60 * 60 * 1000) {
                    cancelDisposable()
                    getMqttDomainV2()
                } else {
                    startQueryQrCodeResultCountdown(9 * 60 * 60 - l / 1000)
                }
            }

            is DeviceQrNetUiAction.OnStop -> {
                cancelDisposable()
            }
        }
    }


    private fun getMqttDomainV2() {
        viewModelScope.launch(context = Dispatchers.IO) {
            _uiStates.setState { copy(isGenerating = true) }
            val isCnLimit =
                if (uiStates.value.productInfo?.extendScType?.contains(ExtendScType.GPS_LOCK) == true) {
                    LocationUtils.isGpsLockSuspend()
                } else {
                    false
                }
            val int3 = if (LocationUtils.lastLocation == null && LocationUtils.lastAddress == null) {
                0
            } else if (LocationUtils.lastLocation != null && LocationUtils.lastAddress != null) {
                1
            } else {
                2
            }
            if (isCnLimit) {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.ExceptionStatistics.code,
                    ExceptionStatisticsEventCode.GPS_LOCK.code,
                    0,
                    StepData.deviceId,
                    model = uiStates.value.productInfo?.productModel ?: "",
                    int1 = if (LocationUtils.lastAreaCode.isNullOrBlank()) 2 else 1,
                    int2 = if (LocationUtils.lastAddress == null) 0 else if (isCnLimit) 1 else 2,
                    int3 = int3,
                    str1 = LocationUtils.lastAddress?.countryName ?: LocationUtils.lastAddress?.countryCode ?: "",
                    str2 = LocationUtils.lastAddress?.locality ?: LocationUtils.lastAddress?.adminArea ?: "",
                    str3 = "",
                    rawStr = LocationUtils.lastAddress?.toString() ?: ""
                )
            } else {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.ExceptionStatistics.code,
                    ExceptionStatisticsEventCode.GPS_LOCK.code,
                    0,
                    StepData.deviceId,
                    model = uiStates.value.productInfo?.productModel ?: "",
                    int1 = if (LocationUtils.lastAreaCode.isNullOrBlank()) 2 else 1,
                    int2 = 0,
                    int3 = int3,
                    str1 = LocationUtils.lastAddress?.countryName ?: LocationUtils.lastAddress?.countryCode ?: "",
                    str2 = LocationUtils.lastAddress?.locality ?: LocationUtils.lastAddress?.adminArea ?: "",
                    str3 = "",
                    rawStr = LocationUtils.lastAddress?.toString() ?: ""
                )
            }
            repository.getMqttDomainV2(AreaManager.getRegion(), !isCnLimit)
                .onStart {
                    _uiStates.setState { copy(isLoading = true) }
                }.onCompletion {
                    _uiStates.setState { copy(isLoading = false) }
                }
                .collect {
                    if (it is Result.Success) {
                        _uiStates.setState {
                            copy(
                                domain = it.data?.regionUrl ?: "",
                                pairQRKey = it.data?.pairQRKey ?: "",
                                timestamp = System.currentTimeMillis()
                            )
                        }
                        ///
                        creatQRNetBitmap()
                    } else if (it is Result.Error) {
                        // need retry
                        _uiEvents.send(DeviceQrNetUiEvent.QueryDomainError(it.exception.message ?: ""))
                        _uiStates.setState { copy(isGenerating = false) }
                    }
                }
        }
    }

    private suspend fun creatQRNetBitmap() {
        // 截取domain 10000.xxx.xxx
        val domain = uiStates.value.domain
        val indexOf1 = domain.indexOf(".")
        val envDomain = if (indexOf1 > 0) {
            domain.substring(0, indexOf1)
        } else {
            ""
        }
        val port = MqttUtil.getServerPort()
        val index = uiStates.value.domain.indexOf(port)
        val domain1 = if (index != -1) {
            uiStates.value.domain.substring(0, index - 1)
        } else {
            uiStates.value.domain
        }
        val params = StringBuffer().append(AccountManager.getInstance().account?.uid ?: "").append("#")
            .append(AreaManager.getRegion()).append("#")
            .append(envDomain).append("#")
            .append(port).append("#")
            .append(TimeZone.getDefault().id).append("#")
            .append(uiStates.value.pairQRKey).append("#")
            .append(LanguageManager.getInstance().getLangTag(LocalApplication.getInstance()))
            .append("#").append(domain1)
        val jsonObject = JSONObject()
        jsonObject.put("s", uiStates.value.targetWifiName)
        jsonObject.put("p", uiStates.value.targetWifiPwd)
        jsonObject.put("d", params)
        try {
            val toString = jsonObject.toString()
            LogUtil.i("DeviceQrNetViewModel", toString)
            val buildQrCodeBitmap = QRCodeGenerator.buildQrCodeBitmap(toString, 400)
            _uiStates.setState { copy(qrcodeBitmap = buildQrCodeBitmap, isGenerating = false, timestamp = System.currentTimeMillis()) }
            dispatchAction(DeviceQrNetUiAction.QueryQRNetResult)
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.d("sunzhibin", Log.getStackTraceString(e))
            // retry
            _uiStates.setState { copy(isGenerating = false) }
            _uiEvents.send(DeviceQrNetUiEvent.CreateQRCodeError(e.message ?: ""))
        }
    }

    /**
     * 轮询查询配网结果 保证用户没有点下一步，也能配网成功
     *
     */
    private fun loopQueryQrNetResult() {
        // 8分钟倒计时
        startQueryQrCodeResultCountdown()
    }

    private fun startQueryQrCodeResultCountdown(time: Long = 9 * 60 * 60) {
        val period: Long = 3
        val count = time * (period)
        cancelDisposable()
        disposableContainer.add(
            Flowable.intervalRange(1, count, 0, period, TimeUnit.SECONDS)
            .onBackpressureLatest()
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
            .doOnSubscribe {
                _uiStates.setState { copy(timestamp = System.currentTimeMillis()) }
            }
            .doOnNext {
                LogUtil.d("------- startQueryQrCodeResultCountdown --------- $it")
                if (uiStates.value.pairQRKey.isNotBlank()) {
                    geQRNetPaiResult()
                }
                val isGenerating = uiStates.value.isGenerating
                if (it >= 8 * 60 * 60 && !isGenerating) {
                    // 重新生成二维码
                    dispatchAction(DeviceQrNetUiAction.QueryDomainRetry)
                }
            }
            .doOnComplete {

            }
            .subscribe())
    }

    private fun cancelDisposable() {
        disposableContainer.clear()
    }

    /**
     * 查询配网码，配网结果
     */
    private fun geQRNetPaiResult() {
        viewModelScope.launch {
            val result = processApiResponse {
                DreameService.getDeviceQRNetPairResult(DeviceQRNetPairReq(uiStates.value.pairQRKey))
            }
            if (result is Result.Success && result.data?.success == true) {
                LogUtil.i("sunzhibin", "geQRNetPaiQR: response json is: $result")
                cancelDisposable()
                val did = result.data?.did ?: ""
                _uiEvents.send(DeviceQrNetUiEvent.GotoNext(true, did, 0))
            } else {

            }
        }
    }

}