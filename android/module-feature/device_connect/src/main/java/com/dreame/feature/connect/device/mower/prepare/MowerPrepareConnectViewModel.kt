package com.dreame.feature.connect.device.mower.prepare

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.manager.AreaManager
import androidx.lifecycle.viewModelScope
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.zj.mvi.core.setState
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch
import org.json.JSONObject

class MowerPrepareConnectViewModel : BaseViewModel<MowerPrepareConnectUiState, MowerPrepareConnectUiEvent>() {
    private val repository = ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource())
    private val productPrepareVideoUrl = "https://oss.iot.dreame.tech/pub/pic/000000/ali_dreame/dreame.mower.p2255/mowper.mp4"
    override fun createInitialState(): MowerPrepareConnectUiState {
        return MowerPrepareConnectUiState(false, null, null, null, true, "")
    }

    override fun dispatchAction(action: UiAction) {
        when (action) {
            is MowerPrepareConnectUiAction.InitData -> {
                _uiStates.setState {
                    copy(
                        productInfo = action.productInfo,
                        isShowBtn = action.isShowBtn,
                        video = productPrepareVideoUrl,
                    )
                }
                getMqttDomainV2()
                // loadPrepareInfo(action.productInfo?.productModel ?: "")
            }

            is MowerPrepareConnectUiAction.RequestBindDomain -> {
                getMqttDomainV2(true)
            }


        }
    }

    private fun loadPrepareInfo(productModel: String) {
        viewModelScope.launch {
            val url = "https://cnbj2.fds.api.xiaomi.com/dreame-product/app/${productModel}/confignet.json?${System.currentTimeMillis()}"
            repository.getUrlRedirect(url).onStart {
                _uiStates.setState { copy(isLoading = true) }
            }.onCompletion {
                _uiStates.setState { copy(isLoading = false) }
            }.collect {
                if (it is Result.Success) {
                    it.data?.let { str ->
                        val jsonObject = JSONObject(str)
                        val image: String = jsonObject.optString("image", "")
                        val video: String = jsonObject.optString("video", "")
                        _uiStates.setState { copy(image = image, video = video) }
                    }
                }
            }
        }

    }

    private fun getMqttDomainV2(showLoading: Boolean = false) {
        viewModelScope.launch {
            repository.getMqttDomainV2(AreaManager.getRegion(), false)
                .onStart {
                    if (showLoading) {
                        _uiStates.setState { copy(isLoading = true) }
                    }
                }
                .onCompletion {
                    if (showLoading) {
                        _uiStates.setState { copy(isLoading = false) }
                    }
                }
                .collect {
                    if (it is Result.Success) {
                        val bind_domain = it.data?.regionUrl ?: ""
                        _uiStates.setState {
                            copy(bind_domain = bind_domain, productInfo = productInfo?.copy(targetDomain = bind_domain))
                        }
                        if (showLoading) {
                            _uiEvents.send(MowerPrepareConnectUiEvent.GotoNext)
                        }
                    } else {
                    }

                }
        }
    }


}