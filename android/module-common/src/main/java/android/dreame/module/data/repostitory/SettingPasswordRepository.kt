package android.dreame.module.data.repostitory

import android.dreame.module.data.datasource.remote.PasswordRemoteDataSource
import android.dreame.module.data.entry.ModifyPassword
import android.dreame.module.data.entry.SettingPassword
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class SettingPasswordRepository(
    private val remoteDataSource: PasswordRemoteDataSource,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) {

    fun settingPassword(newPassword: String, confirmPassword: String) =
        flow {
            val result = remoteDataSource.settingPassword(SettingPassword(newPassword, confirmPassword))
            emit(result)
        }.flowOn(ioDispatcher)


    fun modifyPassword(password: String, newPassword: String, confirmPassword: String) =
        flow {
            val result = remoteDataSource.modifyPassword(ModifyPassword(password,newPassword, confirmPassword))
            emit(result)
        }.flowOn(ioDispatcher)


}