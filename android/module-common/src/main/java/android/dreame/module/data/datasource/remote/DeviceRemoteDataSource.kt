package android.dreame.module.data.datasource.remote

import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.device.UserFeatureReq
import android.dreame.module.data.network.service.DreameAppWidgetService
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import android.dreame.module.ext.processApiResponse

/**
 * 设备相关查询
 */
class DeviceRemoteDataSource {

    suspend fun queryDeviceList(req: DeviceListReq) = processApiResponse {
        DreameAppWidgetService.getDeviceList(req)
    }
  suspend fun getDeviceListByMap(map: HashMap<String, Any>) = processApiResponse {
        DreameAppWidgetService.getDeviceListByMap(map)
    }

    suspend fun queryDeviceList(req: HashMap<String, Any>) = processApiResponse {
        DreameAppWidgetService.getDeviceListByMap(req)
    }

    suspend fun trySendCommand(host: String, req: IoTBaseReq<IoTPropertyReq>) = processApiResponse {
        DreameAppWidgetService.trySendCommand(host, req)
    }

    suspend fun trySendActionCommand(host: String, req: IoTBaseReq<IoTActionReq>) = processApiResponse {
        DreameAppWidgetService.trySendActionCommand(host, req)
    }

    suspend fun sendAction(host: String, req: IoTBaseReq<IoTActionReq>) = processApiResponse {
        DreameAppWidgetService.sendAction(host, req)
    }

    suspend fun getUserFeatures(req: UserFeatureReq) = processApiResponse {
        DreameAppWidgetService.getUserFeatures(req)
    }

}