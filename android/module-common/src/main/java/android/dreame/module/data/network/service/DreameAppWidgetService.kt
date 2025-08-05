package android.dreame.module.data.network.service

import android.dreame.module.data.entry.DeleteDeviceReq
import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.DeviceLogPackageReq
import android.dreame.module.data.entry.device.DevicePairCodeReq
import android.dreame.module.data.entry.device.DevicePairReq
import android.dreame.module.data.entry.device.UserFeatureReq
import android.dreame.module.data.entry.monitor.CloudDevBindReq
import android.dreame.module.data.network.HttpResult
import android.dreame.module.data.network.api.DreameApi
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import android.dreame.module.manager.AreaManager
import android.dreame.module.task.RetrofitInitTask
import com.google.gson.JsonObject
import org.json.JSONObject

/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/08/02
 *     desc   :
 *     version: 1.0
 * </pre>
 */
object DreameAppWidgetService {

    private var service =
        ServiceCreator.create(DreameApi::class.java, RetrofitInitTask.getBaseUrl(), 3 * 1000, 3 * 1000, 3 * 1000)

    fun createService(baseUrl: String) {
        service = ServiceCreator.create(DreameApi::class.java, baseUrl, 3 * 1000, 3 * 1000, 3 * 1000)
    }

    suspend fun getDevicePair(req: DevicePairReq) =
        service.getDevicePair(req)

    suspend fun getDevicePairCode(req: DevicePairCodeReq) =
        service.getDevicePairWithPairCode(req)

    suspend fun trySendCommand(host: String, req: IoTBaseReq<IoTPropertyReq>) =
        service.trySendCommand(host, req)

    suspend fun trySendActionCommand(host: String, req: IoTBaseReq<IoTActionReq>) =
        service.trySendActionCommand(host, req)

    suspend fun sendAction(host: String, req: IoTBaseReq<IoTActionReq>) =
        service.sendAction(host, req)

    suspend fun getDomain(region: String = AreaManager.getRegion()) = service.getDomain(region)

    suspend fun getDeviceList(deviceListReq: DeviceListReq) =
        service.getDeviceList(deviceListReq)

    suspend fun getDeviceListByMap(map: HashMap<String, Any>) =
        service.getDeviceListByMap(map)

    suspend fun deleteDeviceByDid(deleteDeviceReq: DeleteDeviceReq) =
        service.deleteDeviceByDid(deleteDeviceReq)

    suspend fun aliFyAuth(): HttpResult<String> {
        return service.aliFyAuth(JSONObject())
    }

    suspend fun updateAliIotId(did: String, iotId: String): HttpResult<Nothing> {
        val jsonObject = JsonObject().apply {
            addProperty("did", did)
            addProperty("key", "iotId")
            addProperty("value", iotId)
        }
        return service.updateAliItoId(jsonObject)
    }

    /**
     * ali设备云云绑定
     */
    suspend fun cloudDevBind(did: String, uids: List<String>) =
        service.cloudDevBind(CloudDevBindReq(did, uids))


    suspend fun deviceLogPackage(did: String, model: String): HttpResult<Nothing> {
        return service.deviceLogPackage(DeviceLogPackageReq(did, model))
    }

    suspend fun getUserFeatures(req: UserFeatureReq) = service.getUserFeatures(req)

}