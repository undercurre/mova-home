package android.dreame.module.data.datasource.remote

import android.dreame.module.data.entry.DeleteDeviceReq
import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.device.DeleteShareUserReq
import android.dreame.module.data.entry.device.ShareFeatureReq
import android.dreame.module.data.entry.device.ShareUserListReq
import android.dreame.module.data.entry.device.UserFeatureReq
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import android.dreame.module.ext.processApiResponse

/**
 * 设备相关查询
 */
class DeviceShareRemoteDataSource {

    suspend fun queryDeviceList(req: DeviceListReq) = processApiResponse {
        DreameService.getDeviceList(req)
    }

    suspend fun deleteDeviceByDid(req: DeleteDeviceReq) = processApiResponse {
        DreameService.deleteDeviceByDid(req)
    }

    suspend fun getShareUserListByDid(req: ShareUserListReq) = processApiResponse {
        DreameService.getShareUserListByDid(req)
    }

    suspend fun deleteShareUser(req: DeleteShareUserReq) = processApiResponse {
        DreameService.deleteShareUser(req)
    }

    suspend fun getAllDeviceShareFeatures(productId: String) = processApiResponse {
        DreameService.getAllDeviceShareFeatures(productId)
    }

    suspend fun getUserFeatures(req: UserFeatureReq) = processApiResponse {
        DreameService.getUserFeatures(req)
    }


    suspend fun getShareContactList(size: Int) = processApiResponse {
        DreameService.getShareContactList(size)
    }


    suspend fun addShareContactList(contactUid: String) = processApiResponse {
        DreameService.addShareContactList(contactUid)
    }


    suspend fun queryUserInfoByKeyword(keyword: String) = processApiResponse {
        DreameService.queryUserInfoByKeyword(keyword)
    }


    suspend fun checkShareStatus(req: ShareFeatureReq) = processApiResponse {
        DreameService.checkShareStatus(req)
    }

    suspend fun shareWithFeatures(req: ShareFeatureReq) = processApiResponse {
        DreameService.shareWithFeatures(req)
    }


    suspend fun updateUserFeatures(req: ShareFeatureReq) = processApiResponse {
        DreameService.updateUserFeatures(req)
    }

}