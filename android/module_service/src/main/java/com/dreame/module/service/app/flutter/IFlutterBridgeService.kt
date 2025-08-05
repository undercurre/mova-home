package com.dreame.module.service.app.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent


interface IFlutterBridgeService {
    fun sendSchemeEvent(type: String, extra: String, category: String)
    fun sendSchemeEvent(type: String, extra: String)
    fun sendMessage(
        messageName: String,
        ext: Map<String, Any?>? = null,
        callBack: ((String) -> Unit)? = null,
    )

    fun sendMessageMain(
        messageName: String,
        ext: Map<String, Any?>? = null,
        replayCallback: ((Any?) -> Unit)? = null,
    )

    suspend fun <T> getAllDeviceList(clazz: Class<T>): List<T>

    suspend fun checkMqttConnect(): Boolean
    fun checkAndConnectMqtt()
    fun refreshPushToken(params: Map<String, String>): Boolean
    fun updateDeviceName(did: String, deviceName: String)
    fun updateDeviceStatus(did: String, status: List<String>)
    fun refreshDeviceList()
    fun gotoFlutterHomeActivity(context: Context)
    fun getCommonPlugin(pluginType: String, callBack: (String) -> Unit)

    /**
     * 打开主引擎页面
     */
    fun openMainFlutter(
        context: Context,
        routhPath: String,
        args: MutableMap<String, Any> = mutableMapOf()
    ): Intent

    /**
     * 打开其他引擎页面
     */
    fun openSubFlutter(
        context: Context,
        routhPath: String,
        args: MutableMap<String, Any> = mutableMapOf()
    ): Intent

    suspend fun <T> getSupportWidgetCacheDeviceList(clazz: Class<T>): List<T>
    fun logoff(block: () -> Unit)
    fun gotoFlutterPluginActivity()

    fun devicePairSuccess()

    fun deleteDevice(did: String)

    fun readShareMessage()

    fun tokenExpired()

    fun refreshTokenSuccess()

    fun dnsRequest(host: String, block: (String) -> Unit)

    fun getCachedDns(host: String, block: (String) -> Unit)

    fun cleanCachedDns(host: String)

    fun onAppResume(oldActivity: Activity?, newActivity: Activity)

    fun onAppEnterForeground()
    fun onAppEnterBackground()
    // 主动断开网络
    fun proactivelyDisconnect()

    // 恢复网络连接
    fun restoreNetworkConnectivity()

    fun getCachedProtocolData(did: String, block: (String) -> Unit)


    fun openRnPluginPage(params: Map<String, String>, block: (Any?) -> Unit)

    fun preLoadDartVM(context: Context)

    /**
     * 获取主引擎是否在运行
     */
    fun isMainEngineRunning(): Boolean

    fun isSubEngineRunning(): Boolean

    suspend fun getZendeskKey(): HashMap<String, *>


    // 调用flutter发起请求
    fun callRequest(
        ext: Map<String, Any?>? = null,
        replayCallback: ((Any?) -> Unit)? = null,
    )

    fun hasMainMessageChannel(): Boolean

}
