package android.dreame.module.data.entry

import android.dreame.module.BuildConfig

data class PluginCallbackReq(
    val model: String,
    val sdkVersion: Int,
    val pluginVersion: Int,
    val appVersion: Int = BuildConfig.PLUGIN_APP_VERSION,
    val type: Int = 0,/*0: 插件 1：固件*/
)