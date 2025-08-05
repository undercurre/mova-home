package android.dreame.module.data.db

import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil

// do nothing
internal const val STATUS_INIT = 0
internal const val STATUS_DOWNLOADING = 1

//    候选
internal const val STATUS_IN_USE = 3

internal class PluginInfoRepository {
    private val dao by lazy {
        AppDatabase.getInstance(LocalApplication.getInstance()).pluginInfoDao()
    }

    /**
     * 根据pluginName查询当前可使用的插件
     */
    suspend fun queryPluginInUse(pluginName: String): PluginInfoEntity? {
        val entity = queryPluginInUse(pluginName, STATUS_IN_USE)
        return entity
    }

    suspend fun queryPluginInUse(pluginName: String, status: Int): PluginInfoEntity? {
        val entity = dao.queryPluginInfo(pluginName, status)
        return entity
    }

    /**
     *  同步根据pluginName查询当前可使用的插件
     */
    fun queryPluginInUseSync(pluginName: String): PluginInfoEntity? {
        val entity = dao.queryPluginInfoSync(pluginName, STATUS_IN_USE)
        return entity
    }

    /**
     * 根据pluginName查询当前移动到A/B分区，即可使用
     * candidate
     */
    suspend fun queryPluginStatus(pluginName: String, status: Int): PluginInfoEntity? {
        return dao.queryPluginInfo(pluginName, status)

    }

    /**
     * 同步根据pluginName查询当前移动到A/B分区，即可使用
     */
    fun queryPluginStatusSync(pluginName: String, status: Int): PluginInfoEntity? {
        return dao.queryPluginInfoSync(pluginName, status)

    }

    /**
     * 同步根据pluginName查询当前移动到A/B分区，即可使用
     */
    fun deletePluginSync(pluginName: String, status: Int): Int {
        return dao.deletePluginInfoSync(pluginName, status)

    }

    suspend fun deletePlugin(pluginName: String, status: Int): Int {
        return dao.deletePluginInfo(pluginName, status)

    }

    suspend fun deletePluginInfo(status: Int): Int {
        return dao.deletePluginInfo(status)
    }

    fun deletePluginInfoSync(status: Int): Int {
        return dao.deletePluginInfoSync(status)
    }

    /**
     * 更新插件配置文件
     */
    suspend fun updatePlugin(entity: PluginInfoEntity) {
        val queryPluginInfo = dao.queryPluginInfo(entity.pluginName, STATUS_IN_USE)
        if (queryPluginInfo != null) {
            entity.id = queryPluginInfo.id
            dao.updatePluginInfo(entity)
        } else {
            runCatching {
                dao.insert(entity)
            }
        }
        val info = dao.queryPluginInfo(entity.pluginName, STATUS_IN_USE)
        LogUtil.d("updatePlugin: $info")
    }


}