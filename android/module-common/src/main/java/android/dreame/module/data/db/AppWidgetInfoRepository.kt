package android.dreame.module.data.db

import android.dreame.module.LocalApplication

class AppWidgetInfoRepository {
    private val dao by lazy { AppDatabase.getInstance(LocalApplication.getInstance()).appWidgetInfoDao() }

    suspend fun insertEntity(entity: AppWidgetInfoEntity) = runCatching { dao.insertWidgetInfo(entity) }.isSuccess
    suspend fun insertEntity(entitys: List<AppWidgetInfoEntity>) = runCatching { dao.insertWidgetInfo(entitys) }.isSuccess

    suspend fun deleteAppWidget(uid: String) = dao.deleteAppWidget(uid)

    suspend fun deleteAppWidget(widgetId: Int) = dao.deleteAppWidget(widgetId)

    suspend fun deleteAppWidget(ids: List<Int>) = dao.deleteAppWidget(ids)

    suspend fun deleteAppWidget(uid: String, widgetId: Int, domain: String) = dao.deleteAppWidget(uid, widgetId, domain)
    suspend fun deleteAppWidget(uid: String, widgetIds: List<Int>, domain: String) = dao.deleteAppWidget(uid, widgetIds, domain)

    suspend fun updateAppWidgetInfo(entity: AppWidgetInfoEntity) = dao.updateAppWidgetInfo(entity)
    suspend fun updateAppWidgetInfo(entitys: List<AppWidgetInfoEntity>) = dao.updateAppWidgetInfo(entitys)

    suspend fun queryWidgetInfo(uid: String, did: String, domain: String) = dao.queryWidgetInfo(uid, did, domain)
    suspend fun queryWidgetInfo(uid: String, did: String, appWidgetType: Int, domain: String) = dao.queryWidgetInfo(uid, did, appWidgetType, domain)

    suspend fun queryWidgetInfo(uid: String, appWidgetId: Int, domain: String) = dao.queryWidgetInfo(uid, appWidgetId, domain)
    fun queryWidgetInfoSync(uid: String, appWidgetId: Int, domain: String) = dao.queryWidgetInfoSync(uid, appWidgetId, domain)
    suspend fun queryWidgetInfoByType(uid: String, appWidgetType: Int, domain: String) = dao.queryWidgetInfoByType(uid, appWidgetType, domain)

    suspend fun queryWidgetInfo(uid: String, domain: String) = dao.queryWidgetInfo(uid, domain)

    suspend fun queryWidgetInfoType(appWidgetId: Int) = dao.queryWidgetInfoType(appWidgetId)


    suspend fun queryWidgetInfoList() = dao.queryWidgetInfoList()

    suspend fun queryWidgetInfoCount() = dao.queryWidgetInfoCount()

    suspend fun queryWidgetInfoList(uid: String, ids: List<Int>, domain: String) = dao.queryWidgetInfoList(uid, ids, domain)

}