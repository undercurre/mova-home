package com.dreame.smartlife.ui2.voicecontrol

import android.dreame.module.bean.AiSoundBean
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.VoiceControlDataSource
import android.dreame.module.data.entry.AlexaApp2AppRes
import android.dreame.module.data.entry.AlexaBindAuthReq
import android.dreame.module.data.entry.AlexaBindAuthRes
import android.dreame.module.data.repostitory.VoiceControlRepository
import android.dreame.module.manager.LanguageManager
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kunminx.architecture.ui.callback.UnPeekLiveData
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2022/02/28
 *     desc   :
 *     version: 1.0
 * </pre>
 */
class VoiceControlViewModel : ViewModel() {
    private val voiceControlRepository = VoiceControlRepository(VoiceControlDataSource())

    private val _alexaApp2AppRes = UnPeekLiveData<Result<AlexaApp2AppRes>>()
    val alexaApp2AppRes = _alexaApp2AppRes

    private val _alexaSkillAccountLink = UnPeekLiveData<Result<Boolean>>()
    val alexaSkillAccountLink = _alexaSkillAccountLink

    private val _unbindAlexaResult = UnPeekLiveData<Result<Boolean>>()
    val unbindAlexaResult = _unbindAlexaResult

    private val _authAlexaResult = UnPeekLiveData<Result<AlexaBindAuthRes>>()
    val authAlexaResult = _authAlexaResult

    private val _getVoiceProductList = UnPeekLiveData<Result<List<AiSoundBean>>>()
    val getVoiceProductList = _getVoiceProductList

    fun getAlexaApp2AppUrl() {
        viewModelScope.launch {
            voiceControlRepository
                .getAlexaApp2AppUrl("android")
                .onStart {
                    _alexaApp2AppRes.value = Result.Loading
                }
                .collect {
                    _alexaApp2AppRes.value = it
                }
        }
    }

    fun alexaSkillAccountLink(
        awsCode: String,
        redirectUrl: String
    ) {
        viewModelScope.launch {
            voiceControlRepository
                .alexaSkillAccountLink(awsCode, redirectUrl)
                .onStart {
                    _alexaSkillAccountLink.value = Result.Loading
                }
                .collect {
                    _alexaSkillAccountLink.value = it
                }
        }
    }

    fun unbindAlexaAccountLink() {
        viewModelScope.launch {
            voiceControlRepository
                .unbindAlexaAccountLink()
                .onStart {
                    _unbindAlexaResult.value = Result.Loading
                }
                .collect {
                    _unbindAlexaResult.value = it
                }
        }
    }

    fun skillAuthorizeCode(req: AlexaBindAuthReq) {
        viewModelScope.launch {
            voiceControlRepository
                .skillAuthorizeCode(req)
                .onStart {
                    _authAlexaResult.value = Result.Loading
                }
                .collect {
                    _authAlexaResult.value = it
                }
        }
    }

    fun getVoiceProductList(lang: String) {
        viewModelScope.launch {
            voiceControlRepository
                .getVoiceProductList(lang, "v2", "android")
                .onStart {
                    _getVoiceProductList.value = Result.Loading
                }
                .collect {
                    _getVoiceProductList.value = it
                }
        }
    }
}