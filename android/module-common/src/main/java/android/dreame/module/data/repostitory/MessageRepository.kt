package android.dreame.module.data.repostitory

import android.dreame.module.data.datasource.remote.MessageRemoteDataSource
import android.dreame.module.data.entry.message.*
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class MessageRepository(
    private val remoteDataSource: MessageRemoteDataSource,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {

    suspend fun getMessageHomeRecord(version: String?) = flow {
        val result = remoteDataSource.getMessageHomeRecord(version)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun markAllMessageRead() = flow {
        val result = remoteDataSource.markAllMessageRead()
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun deleteDeviceMsgByDid(deviceId: String) = flow {
        val result = remoteDataSource.deleteDeviceMsgByDid(deviceId)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun deleteDeviceMsgByMsgIds(msgIds: List<String>) = flow {
        val result = remoteDataSource.deleteDeviceMsgByMsgIds(msgIds)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getSystemMessageRecord(
        currentTimeStamp: Long,
        page: Int = 1,
        size: Int = 20
    ) = flow {
        val result = remoteDataSource.getMessageRecord("system_msg", currentTimeStamp, page, size)
        if (result is android.dreame.module.data.Result.Success) {
            if (result.data?.records?.isNotEmpty() == true) {
                remoteDataSource.readMessageByCategory("system_msg")
            }
        }
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getOrderMessageRecord(
        currentTimeStamp: Long,
        page: Int = 1,
        size: Int = 20
    ) = flow {
        val result = remoteDataSource.getMessageRecord("order_msg", currentTimeStamp, page, size)
        if (result is android.dreame.module.data.Result.Success) {
            remoteDataSource.readMessageByCategory("service_msg")
        }
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getVipMessageRecord(
        currentTimeStamp: Long,
        page: Int = 1,
        size: Int = 20
    ) = flow {
        val result = remoteDataSource.getMessageRecord("member_msg", currentTimeStamp, page, size)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getActivityMessageRecord(
        currentTimeStamp: Long,
        page: Int = 1,
        size: Int = 20
    ) = flow {
        val result = remoteDataSource.getMessageRecord("activity_msg", currentTimeStamp, page, size)
        emit(result)
    }.flowOn(ioDispatcher)


    suspend fun deleteMessageRecord(msgIds: String) = flow {
        val result = remoteDataSource.deleteMessageRecord(msgIds)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun clearSystemMessageRecord() = flow {
        val result = remoteDataSource.clearMessageRecord("system_msg")
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun clearOrderMessageRecord() = flow {
        val result = remoteDataSource.clearMessageRecord("order_msg")
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun clearVipMessageRecord() = flow {
        val result = remoteDataSource.clearMessageRecord("member_msg")
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun clearActivityMessageRecord() = flow {
        val result = remoteDataSource.clearMessageRecord("activity_msg")
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getDeviceMessageList(did: String, language: String, offset: Int, limit: Int) =
        flow {
            val result = remoteDataSource.getDeviceMessageList(did, language, offset, limit)
            if (result is android.dreame.module.data.Result.Success) {
                if (result.data?.content?.isNotEmpty() == true) {
                    remoteDataSource.setMessagesReadByDid(did)
                }
            }
            emit(result)
        }.flowOn(ioDispatcher)

    suspend fun setMessagesRead(ids: String) = flow {
        val result = remoteDataSource.setMessagesRead(ids)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun setMessagesReadByDid(did: String) = flow {
        val result = remoteDataSource.setMessagesReadByDid(did)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun queryDeviceInfoByDid(req: DeviceInfoReq) = flow {
        val result = remoteDataSource.queryDeviceInfoByDid(req)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getSystemMessageSetting() = flow {
        val result = remoteDataSource.getSystemMessageSetting()
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun updateSystemMessageSetting(msgSwitch: Boolean) = flow {
        val req = SystemMessageSettingReq("system_msg_switch", msgSwitch)
        val result = remoteDataSource.updateSystemMessageSetting(req)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun updateServerMessageSetting(msgSwitch: Boolean) = flow {
        val req = SystemMessageSettingReq("service_msg_switch", msgSwitch)
        val result = remoteDataSource.updateSystemMessageSetting(req)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getMsgSetting() = flow {
        val result = remoteDataSource.getMsgSetting()
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun updateMsgSetting(req: MessageSetting) = flow {
        val result = remoteDataSource.updateMsgSetting(req)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getShareMessageList(limit: Int, offset: Int,version:String?) = flow {
        val result = remoteDataSource.getShareMessageList(limit, offset,version)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun deleteShareMessageByMsgId(msgIds: String) = flow {
        val result = remoteDataSource.deleteShareMessageByMsgId(msgIds)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun readAllShareMessage() = flow {
        val result = remoteDataSource.readAllShareMessage()
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun readShareMessageByIds(msgIds: String) = flow {
        val result = remoteDataSource.readShareMessageByIds(msgIds)
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun ackShareFromMessage(
        messageId: String,
        accept: Boolean
    ) = flow {
        val result = remoteDataSource.ackShareFromMessage(messageId, AckShareFromMessageReq(accept))
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun ackShareFromDevice(
        accept: Boolean,
        deviceId: String,
        model: String,
        ownUid: String
    ) = flow {
        val result = remoteDataSource.ackShareFromDevice(
            AckShareFromDeviceReq(
                accept,
                deviceId,
                model,
                ownUid
            )
        )
        emit(result)
    }.flowOn(ioDispatcher)
}