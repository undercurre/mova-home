package com.dreame.module.widget

import android.dreame.module.LocalApplication
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.dreame.module.data.db.AppWidgetInfoRepository
import android.dreame.module.util.LogUtil
import android.dreame.module.util.SPUtil
import android.text.TextUtils
import com.dreame.module.widget.constant.*
import com.dreame.module.widget.service.utils.AppWidgetEnum

object AppWidgetCacheHelper {
    private val repository by lazy { AppWidgetInfoRepository() }
    private val appWidgetSp = SPUtil.createAndroidSp(LocalApplication.getInstance(), "sp_appwidget")

    fun saveTipsShowFlag() {
        appWidgetSp.edit().putInt("tipsShowFlag", 1).apply()
    }

    fun needTipsShowFlag(): Boolean {
        return appWidgetSp.getInt("tipsShowFlag", -1) == 1
    }

    /**
     * 保存 小组件关联的设备信息
     * @param uid
     * @param appWidgetId
     * @param map
     */
    suspend fun saveAppWidgetInfo(entity: AppWidgetInfoEntity) {
        LogUtil.i("AppWidgetDeviceService", "AppWidgetCacheHelper saveAppWidgetInfo: $entity ")
        repository.insertEntity(entity)
    }

    suspend fun saveAppWidgetInfo(entitys: List<AppWidgetInfoEntity>) {
        LogUtil.i("AppWidgetDeviceService", "AppWidgetCacheHelper saveAppWidgetInfo:entitys  $entitys ")
        if (entitys.isNotEmpty()) {
            repository.insertEntity(entitys)
        }
    }

    suspend fun updateAppWidgetInfo(entity: AppWidgetInfoEntity) {
        LogUtil.i("AppWidgetDeviceService", "AppWidgetCacheHelper saveAppWidgetInfo: $entity ")
        repository.updateAppWidgetInfo(entity)
    }

    suspend fun updateAppWidgetInfo(entitys: List<AppWidgetInfoEntity>) {
        LogUtil.i("AppWidgetDeviceService", "AppWidgetCacheHelper saveAppWidgetInfo: entitys $entitys ")
        if (entitys.isNotEmpty()) {
            repository.updateAppWidgetInfo(entitys)
        }
    }

    suspend fun saveAppWidgetInfoAndClear(entity: AppWidgetInfoEntity) {
        LogUtil.i("AppWidgetDeviceService", "AppWidgetCacheHelper saveAppWidgetInfoAndClear: $entity ")
        saveAppWidgetInfo(entity)
        clearOtherUserInfo()
    }

    suspend fun clearUidAppWidgetId(uid: String) {
        LogUtil.i("AppWidgetDeviceService", "AppWidgetCacheHelper clearUidAppWidgetId: $uid ")
        repository.deleteAppWidget(uid)
    }

    /**
     * 清理已经被删除的小组件 缓存信息
     * @param appWidgetIds 活跃的小组件Ids
     *
     */
    suspend fun clearInvalidAppWidgetInfo(appWidgetIds: List<Int>) {
        val deleteList = repository.queryWidgetInfoList()
            .filter {
                !appWidgetIds.contains(it.appWidgetId)
            }.map {
                it.id
            }
        if (deleteList.isNotEmpty()) {
            repository.deleteAppWidget(deleteList)
        }
    }

    suspend fun readAppWidgetInfo(currentUid: String, appWidgetId: Int, domain: String): AppWidgetInfoEntity? {
        try {
            return repository.queryWidgetInfo(currentUid, appWidgetId, domain)
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    suspend fun deleteAppWidgetInfo(currentUid: String, appWidgetId: Int, domain: String) {
        try {
            repository.deleteAppWidget(currentUid, appWidgetId, domain)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun readAppWidgetInfoSync(currentUid: String, appWidgetId: Int, domain: String): AppWidgetInfoEntity? {
        try {
            return repository.queryWidgetInfoSync(currentUid, appWidgetId, domain)
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
    }

    suspend fun getAppWidgetBindDids(currentUid: String, domain: String): List<String> {
        try {
            val didList = mutableListOf<String>()
            val listCollection = repository.queryWidgetInfo(currentUid, domain).filter {
                !TextUtils.isEmpty(it.did)
            }.groupBy {
                it.did
            }.values
            listCollection.onEach { list ->
                if (list.size >= 3) {
                    val map = list.map {
                        it.appWidgetType
                    }.toSet()
                    if (map.contains(AppWidgetEnum.WIDGET_SMALL_SINGLE.code)
                        && map.contains(AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code)
                        && map.contains(AppWidgetEnum.WIDGET_LARGE_SINGLE.code)
                    ) {
                        didList.add(list[0].did)
                    }
                }
            }
            return didList
        } catch (e: Exception) {
            e.printStackTrace()
            return emptyList()
        }
    }

    suspend fun getAppWidgetBindDids(currentUid: String, appWidgetType: Int, domain: String): List<String> {
        try {
            return repository.queryWidgetInfoByType(currentUid, appWidgetType, domain).filter {
                !TextUtils.isEmpty(it.did)
            }.map {
                it.did
            }
        } catch (e: Exception) {
            e.printStackTrace()
            return emptyList()
        }
    }

    suspend fun removeInfo(uid: String, appWidgetId: Int, domain: String) {
        repository.deleteAppWidget(uid, appWidgetId, domain)
    }

    suspend fun removeInfo(uid: String, appWidgetIds: List<Int>, domain: String) {
        repository.deleteAppWidget(uid, appWidgetIds, domain)
    }

    suspend fun removeInvalidAppWidgetInfo(appWidgetId: Int) {
        repository.deleteAppWidget(appWidgetId)
    }

    suspend fun removeInvalidAppWidgetInfo(appWidgetIds: IntArray) {
        if (appWidgetIds.isNotEmpty()) {
            repository.deleteAppWidget(appWidgetIds.toList())
        }
    }

    private suspend fun clearOtherUserInfo() {
        val groupBy = repository.queryWidgetInfoList().groupBy {
            it.uid
        }.toList()
        if (groupBy.size <= 2) {
            return
        }
        val flattenIds = groupBy
            .take(groupBy.size - 2)
            .map {
                it.second
            }.flatten()
            .map {
                it.id
            }
        if (flattenIds.isNotEmpty()) {
            LogUtil.i("sunzhibin", "clearOtherUserInfo: $flattenIds")
            repository.deleteAppWidget(flattenIds)
        }
    }

    suspend fun queryWidgetInfo(uid: String, deviceId: String, domain: String) = repository.queryWidgetInfo(uid, deviceId, domain)
    suspend fun queryWidgetInfo(uid: String, domain: String) = repository.queryWidgetInfo(uid, domain)
    suspend fun queryWidgetInfoCount() = repository.queryWidgetInfoCount()
    suspend fun queryWidgetInfoType(appWidgetId: Int) = repository.queryWidgetInfoType(appWidgetId)
    suspend fun queryWidgetInfoList() = repository.queryWidgetInfoList()
    suspend fun deleteAppWidgetId(ids: List<Int>) = repository.deleteAppWidget(ids)
    suspend fun deleteAppWidgetId(id: Int) = repository.deleteAppWidget(id)
    suspend fun queryWidgetInfoList(uid: String, ids: List<Int>, domain: String) = repository.queryWidgetInfoList(uid, ids, domain)

    suspend fun queryWidgetInfo(uid: String, did: String, appWidgetType: Int, domain: String) =
        repository.queryWidgetInfo(uid, did, appWidgetType, domain)

}