package android.dreame.module.util.alify

import android.dreame.module.bean.DeviceListBean
import android.dreame.module.data.Result
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.AccountManager
import android.dreame.module.util.LogUtil
import android.util.Log
import com.dreame.sdk.alify.AliFySdk
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

object BindAliHelper : CoroutineScope by MainScope() {

    const val TAG = "BindAliHelper"

    /**
     * iotId为空,绑定设备
     */
    fun bindDevice(
        device: DeviceListBean.Device,
        bindSuccess: (iotId: String) -> Unit,
        bindFail: (error: String) -> Unit,
        loadingCallback: ((show: Boolean) -> Unit)? = null
    ) {
        if (device.isMaster) {
            cloudBindDevice(
                device.did,
                device.masterUid,
                "",
                bindSuccess,
                bindFail,
                loadingCallback
            )
        } else {
            cloudBindDevice(
                device.did,
                device.masterUid,
                AccountManager.getInstance().account.uid ?: "",
                bindSuccess,
                bindFail,
                loadingCallback
            )
        }
    }

    /**
     * 云云绑定设备
     * @param masterId 设备主人uid
     * @param receiverId 设备被分享者uid
     */
    private fun cloudBindDevice(
        did: String,
        masterId: String,
        receiverId: String = "",
        successBlock: (iotId: String) -> Unit,
        failBlock: (error: String) -> Unit,
        loadingCallback: ((show: Boolean) -> Unit)? = null
    ) {
        launch {
            loadingCallback?.invoke(true)
            runCatching {
                val result = transferAliFyPDD(did)
                LogUtil.d(TAG, "transferAliFyPDD result: $result")
                // cloud bind
                val uidList = mutableListOf(masterId)
                if (receiverId.isNotEmpty()) {
                    uidList.add(receiverId)
                }
                processApiResponse { DreameService.cloudDevBind(did, uidList) }
            }.onSuccess { result ->
                loadingCallback?.invoke(false)
                if (result is Result.Success) {
                    result.data?.let { data ->
                        Log.d(TAG, "receiverBindDevice: ${data.bindCode}")
                        if (data.success) {
                            successBlock.invoke(data.iotId ?: "")
                        } else {
                            failBlock.invoke("cloudBindDevice response fail, data: $data")
                        }
                    }
                } else {
                    failBlock.invoke("cloudBindDevice result is not Success, result: $result")
                }
            }.onFailure {
                loadingCallback?.invoke(false)
                failBlock.invoke("cloudBindDevice error: ${it.message}")
            }
        }
    }

    /**
     * 检验用户与ali设备绑定关系
     */
    fun checkAliDeviceInfo(
        device: DeviceListBean.Device,
        successBlock: (iotId: String) -> Unit,
        failBlock: (error: String?) -> Unit,
        loadingCallback: ((show: Boolean) -> Unit)? = null
    ) {
        launch {
            loadingCallback?.invoke(true)
            runCatching {
                if (!AccountManager.getInstance().haveAliAuth()) {
                    aliFyAuth(device.did, device.model).collect()
                }
                checkBindInfo(device)
            }.onSuccess { deviceInfo ->
                LogUtil.i(TAG, "checkAliDevice: deviceInfo=$deviceInfo")
                if (deviceInfo != null) {
                    if (deviceInfo.bind) {
                        loadingCallback?.invoke(false)
                        successBlock.invoke(deviceInfo.iotId ?: "")
                    } else {
                        bindDevice(device, successBlock, failBlock, loadingCallback)
                    }
                }
            }.onFailure {
                LogUtil.e(TAG, "checkAliDevice error: $it")
                loadingCallback?.invoke(false)
                failBlock.invoke(it.message)
            }
        }
    }

    private suspend fun aliFyAuth(deviceId: String, deviceModel: String) = flow {
        emit(AliAuthHelper.aliFyAuth())
    }

    /**
     * 校验阿里绑定关系
     */
    private suspend fun checkBindInfo(device: DeviceListBean.Device) = withContext(Dispatchers.IO) {
        val openId = AliFySdk.getInstance().userOpenId ?: ""
        val result = processApiResponse {
            DreameService.checkAliFyDevice(device.did, openId)
        }
        LogUtil.i(TAG, "checkAliFyDevice: result: $result")
        if (result is Result.Success) {
            result.data
        } else {
            throw IllegalStateException("checkAliFyDevice error: result is $result")
        }
    }

    /**
     * 迁移阿里三元组
     */
    private suspend fun transferAliFyPDD(did: String) = withContext(Dispatchers.IO) {
        val result = processApiResponse {
            DreameService.transferAliFyPDD(did)
        }
        LogUtil.i(TAG, "transferAliFyPDD: result: $result")
        if (result is Result.Success) {
            val success = result.data ?: false
            if (!success) {
                throw IllegalStateException("transferAliFyPDD false: result is $result")
            }
            true
        } else {
            throw IllegalStateException("transferAliFyPDD error: result is $result")
        }
    }

}