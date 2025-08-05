package android.dreame.module.data.repostitory

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.DeviceLocalDataSource
import android.dreame.module.data.datasource.remote.DeviceRemoteDataSource
import android.dreame.module.data.entry.device.UserFeatureReq
import android.dreame.module.dto.IoTActionReq
import android.dreame.module.dto.IoTBaseReq
import android.dreame.module.dto.IoTPropertyReq
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class DeviceRepository(
    private val remoteDataSource: DeviceRemoteDataSource,
    private val localDataSource: DeviceLocalDataSource,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {

    suspend fun queryDeviceList(req: HashMap<String, Any>) = flow {
        // 读取本地设备
        localDataSource.readDeviceList()
        val result = remoteDataSource.getDeviceListByMap(req)
        when (result) {
            is Result.Success -> {
                result.data?.let {
                    it.page?.records?.let {
                        localDataSource.saveDeviceList(it)
                    }
                }
            }

            else -> {}
        }
        emit(result)
    }.flowOn(ioDispatcher)


    suspend fun trySendCommand(host: String, req: IoTBaseReq<IoTPropertyReq>) = flow {
        val result = remoteDataSource.trySendCommand(host, req)
        emit(result)
    }

    suspend fun trySendActionCommand(host: String, req: IoTBaseReq<IoTActionReq>) = flow {
        val result = remoteDataSource.trySendActionCommand(host, req)
        emit(result)
    }

    suspend fun sendAction(host: String, req: IoTBaseReq<IoTActionReq>) = flow {
        val result = remoteDataSource.sendAction(host, req)
        emit(result)
    }

    suspend fun getUserFeatures(did: String, shareUid: String) = flow {
        val req = UserFeatureReq(did, shareUid)
        val result = remoteDataSource.getUserFeatures(req)
        emit(result)
    }

}