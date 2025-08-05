package android.dreame.module.data.repostitory

import android.dreame.module.data.Result
import android.dreame.module.data.datasource.remote.DeviceShareRemoteDataSource
import android.dreame.module.data.entry.DeleteDeviceReq
import android.dreame.module.data.entry.DeviceListReq
import android.dreame.module.data.entry.device.*
import android.dreame.module.exception.DreameException
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class DeviceShareRepository(
        private val remoteDataSource: DeviceShareRemoteDataSource,
        private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {

    suspend fun queryDeviceList(
            currentPage: Int,
            pageSize: Int,
            language: String,
            isMaster: Boolean?
    ) = flow {
        val result = remoteDataSource.queryDeviceList(
                DeviceListReq(
                        currentPage,
                        pageSize,
                        language,
                        master = isMaster
                )
        )
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun deleteDeviceByDid(
            did: String
    ) = flow {
        val result = remoteDataSource.deleteDeviceByDid(
                DeleteDeviceReq(did)
        )
        emit(result)
    }.flowOn(ioDispatcher)

    suspend fun getShareUserListByDid(did: String) = flow {
        emit(remoteDataSource.getShareUserListByDid(ShareUserListReq(did)))
    }.flowOn(ioDispatcher)

    suspend fun deleteShareUser(did: String, shareUid: String) = flow {
        emit(remoteDataSource.deleteShareUser(DeleteShareUserReq(did, shareUid)))
    }.flowOn(ioDispatcher)

    suspend fun getAllDeviceShareFeatures(productId: String) = flow {
        emit(remoteDataSource.getAllDeviceShareFeatures(productId))
    }.flowOn(ioDispatcher)

    suspend fun getUserDeviceShareFeatures(productId: String, did: String, shareUid: String?) =
            flow {
                val deviceAllFeaturesRet = remoteDataSource.getAllDeviceShareFeatures(productId)
                if (deviceAllFeaturesRet is android.dreame.module.data.Result.Error) {
                    emit(deviceAllFeaturesRet)
                    return@flow
                }
                val userFeatures = remoteDataSource.getUserFeatures(UserFeatureReq(did, shareUid))
                if (userFeatures is android.dreame.module.data.Result.Error) {
                    emit(userFeatures)
                    return@flow
                }
                deviceAllFeaturesRet as android.dreame.module.data.Result.Success
                userFeatures as android.dreame.module.data.Result.Success
                val userFeatureList = userFeatures.data?.split(",")
                deviceAllFeaturesRet.data?.forEach { feature ->
                    if (userFeatureList != null && userFeatureList.contains(feature.permitKey)) {
                        feature.open = true
                    }
                }
                emit(deviceAllFeaturesRet)
            }
                    .flowOn(ioDispatcher)

    suspend fun getUserFeatures(did: String, shareUid: String) = flow {
        emit(remoteDataSource.getUserFeatures(UserFeatureReq(did, shareUid)))
    }.flowOn(ioDispatcher)

    suspend fun queryUserInfoByKeyword(keyword: String, did: String) = flow<Result<ShareUserRes>> {
        val userListRet = remoteDataSource.queryUserInfoByKeyword(keyword)
        if (userListRet is Result.Success) {
            if (userListRet.data != null && userListRet.data.isNotEmpty()) {
                val user = userListRet.data[0]
                val checkUserResult =
                        remoteDataSource.checkShareStatus(ShareFeatureReq(did, user.uid))
                if (checkUserResult is Result.Success) {
                    if (checkUserResult.data == true) {
                        emit(
                                Result.Success(
                                        ShareUserRes(
                                                user.avatar,
                                                user.name,
                                                user.uid,
                                                0
                                        )
                                )
                        )
                    } else {
                        emit(Result.Error(DreameException(-3, null)))
                    }
                } else {
                    val error = checkUserResult as Result.Error
                    emit(error)
                }
            } else {
                emit(Result.Error(DreameException(-2, null)))
            }
        } else {
            if (userListRet is Result.Error) {
                emit(Result.Error(userListRet.exception))
            } else {
                emit(Result.Error(DreameException(-1, null)))
            }
        }
    }.flowOn(ioDispatcher)

    suspend fun addShareContactList(contactUid: String) = flow {
        emit(remoteDataSource.addShareContactList(contactUid))
    }.flowOn(ioDispatcher)

    suspend fun checkUser(did: String, shareUid: String) = flow {
        emit(remoteDataSource.checkShareStatus(ShareFeatureReq(did, shareUid)))
    }.flowOn(ioDispatcher)

    suspend fun getShareContactList(size: Int) = flow {
        emit(remoteDataSource.getShareContactList(size))
    }.flowOn(ioDispatcher)

    suspend fun shareWithFeatures(did: String, shareUid: String, features: String?) = flow {
        val shareResult =
                remoteDataSource.shareWithFeatures(ShareFeatureReq(did, shareUid, features))
        if (shareResult is Result.Success) {
            remoteDataSource.addShareContactList(shareUid)
        }
        emit(shareResult)
    }.flowOn(ioDispatcher)

    suspend fun updateUserFeatures(did: String, shareUid: String, features: String?) = flow {
        emit(remoteDataSource.updateUserFeatures(ShareFeatureReq(did, shareUid, features)))
    }.flowOn(ioDispatcher)
}