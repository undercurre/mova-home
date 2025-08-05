package android.dreame.module.data.db

import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import java.io.File

internal class PluginConfigRepository {

    private val dao by lazy {
        AppDatabase.getInstance(LocalApplication.getInstance()).pluginConfigDao()
    }

    /**
     * 根据pluginName查询当前使用的插件信息
     */
    suspend fun queryPluginConfig(pluginName: String): PluginConfigEntity? {
        return dao.queryConfig(pluginName)
    }

    /**
     * 根据pluginName删除当前使用的插件信息
     */
    suspend fun removePluginConfig(pluginName: String): Int {
        return dao.removePluginConfig(pluginName)
    }

    /**
     * 根据pluginName同步查询当前使用的插件信息
     */
    fun removePluginConfigSync(pluginName: String): Int {
        return dao.removePluginConfigSync(pluginName)
    }

    /**
     * 更新插件配置文件
     */
    suspend fun updateConfig(
        pluginName: String,
        pluginVersion: Int,
        pluginPath: String,
        pluginLength: Long,
        md5: String
    ) {
        LogUtil.i("$pluginName $pluginVersion  $pluginPath  $pluginLength  $md5  ${File(pluginPath).exists()}")
        return dao.replaceConfig(
            PluginConfigEntity(
                pluginName,
                pluginVersion,
                pluginPath,
                pluginLength,
                md5
            )
        )
    }

    suspend fun updateConfig(entity: PluginConfigEntity) {
        return dao.replaceConfig(entity)
    }

    /**
     * 同步更新插件配置文件
     */
    fun updateConfigSync(
        pluginName: String,
        pluginVersion: Int,
        pluginPath: String,
        pluginLength: Long,
        md5: String
    ) {
        return dao.replaceConfigSync(
            PluginConfigEntity(
                pluginName,
                pluginVersion,
                pluginPath,
                pluginLength,
                md5
            )
        )
    }

}