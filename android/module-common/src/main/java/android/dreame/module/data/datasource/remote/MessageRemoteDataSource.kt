package android.dreame.module.data.datasource.remote

import android.dreame.module.data.entry.message.*
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse

class MessageRemoteDataSource {

    suspend fun getMessageHomeRecord(version: String?) = processApiResponse {
        DreameService.getMessageHomeRecord(version)
    }

    suspend fun markAllMessageRead() = processApiResponse {
        DreameService.markAllMessageRead()
    }

    suspend fun deleteDeviceMsgByDid(deviceId: String) = processApiResponse {
        DreameService.deleteMessages(mapOf("deviceId" to deviceId))
    }

    suspend fun deleteDeviceMsgByMsgIds(ids: List<String>) = processApiResponse {
        DreameService.deleteMessages(mapOf("msgIds" to ids.joinToString(",")))
    }

    /**
     * 查询消息
     * @param msgCategory
     */
    suspend fun getMessageRecord(
        msgCategory: String,
        currentTimeStamp: Long,
        page: Int,
        size: Int
    ) = processApiResponse {
        DreameService.getMessageRecord(msgCategory, currentTimeStamp, page, size)
    }

    /**
     * 删除消息
     * @param msgIds
     */
    suspend fun deleteMessageRecord(msgIds: String) = processApiResponse {
        DreameService.deleteMessageRecord(msgIds)
    }

    /**
     * 清空消息
     * @param msgCategory
     */
    suspend fun clearMessageRecord(msgCategory: String) = processApiResponse {
        DreameService.clearMessageRecord(msgCategory)
    }

    /**
     * 设备消息列表
     *
     * @param did
     * @param language
     * @param limit
     * @param offset
     * @return
     */
    suspend fun getDeviceMessageList(did: String, language: String, offset: Int, limit: Int) =
        processApiResponse {
            DreameService.getDeviceMessageList(did, language, offset, limit)
        }

    /**
     * 更新消息已读
     *
     * @param ids  111,222,333
     * @return
     */
    suspend fun setMessagesRead(ids: String) = processApiResponse {
        DreameService.setMessagesRead(ids)
    }

    /**
     * 根据did设置设备消息已读
     *
     * @param did  111,222,333
     * @return
     */
    suspend fun setMessagesReadByDid(did: String) = processApiResponse {
        DreameService.setMessagesReadByDid(did)
    }

    /**
     * 根绝did查询设备信息
     *
     * @param req
     * @return
     */
    suspend fun queryDeviceInfoByDid(req: DeviceInfoReq) = processApiResponse {
        DreameService.queryDeviceInfoByDid(req)
    }

    /**
     * 获取服务 和 系统消息
     */
    suspend fun getSystemMessageSetting() = processApiResponse {
        DreameService.getSystemMessageSetting()
    }

    /**
     * 更新 服务 和 系统消息
     * @param msgType service_msg_switch、system_msg_switch
     * @param msgSwitch
     */
    suspend fun updateSystemMessageSetting(req: SystemMessageSettingReq) = processApiResponse {
        DreameService.updateSystemMessageSetting(req)
    }

    /**
     * 获取共享和设备消息设置
     * @param msgType service_msg_switch、system_msg_switch
     * @param msgSwitch
     */
    suspend fun getMsgSetting() = processApiResponse {
        DreameService.getMsgSetting()
    }

    /**
     * 更新共享和设备消息设置
     * @param msgType service_msg_switch、system_msg_switch
     * @param msgSwitch
     */
    suspend fun updateMsgSetting(req: MessageSetting) = processApiResponse {
        DreameService.updateMsgSetting(req)
    }

    suspend fun getShareMessageList(limit: Int, offset: Int, version: String?) = processApiResponse {
        DreameService.getShareMessageList(limit, offset, version)
    }

    suspend fun deleteShareMessageByMsgId(msgIds: String) = processApiResponse {
        DreameService.deleteShareMessage(msgIds)
    }

    suspend fun readAllShareMessage() = processApiResponse {
        DreameService.readAllShareMessage()
    }

    suspend fun readShareMessageByIds(msgIds: String) = processApiResponse {
        DreameService.readShareMessageByIds(msgIds)
    }

    suspend fun ackShareFromMessage(
        messageId: String,
        ackShareFromMessageReq: AckShareFromMessageReq
    ) = processApiResponse {
        DreameService.ackShareFromMessage(messageId, ackShareFromMessageReq)
    }

    suspend fun ackShareFromDevice(ackShareFromDeviceReq: AckShareFromDeviceReq) =
        processApiResponse {
            DreameService.ackShareFromDevice(ackShareFromDeviceReq)
        }

    suspend fun readMessageByCategory(msgCategory: String?, msgIds: String? = null) =
        processApiResponse {
            DreameService.readMessageByCategory(msgCategory, msgIds)
        }

}