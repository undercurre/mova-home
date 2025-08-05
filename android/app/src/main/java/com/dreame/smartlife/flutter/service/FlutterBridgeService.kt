package com.dreame.smartlife.flutter.service

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.data.entry.Device
import android.dreame.module.data.entry.DeviceCatagory
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.os.Handler
import android.os.Looper
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_NAME
import com.dreame.movahome.flutter.FlutterPluginActivity
import com.dreame.movahome.flutter.FlutterPluginSubActivity
import com.dreame.movahome.ui.activity.SplashActivity
import com.dreame.smartlife.flutter.FlutterMessageChannelHelper
import com.dreame.smartlife.flutter.engine.FlutterEngineGroupLauncher
import com.therouter.router.Route
import io.flutter.embedding.android.FlutterActivity
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

@Route(path = RoutPath.APP_FLUTTER_BRIDGE_SERVICE)
class FlutterBridgeService : IFlutterBridgeService {
    private val TAG = this.javaClass.simpleName

    override fun sendSchemeEvent(type: String, extra: String, category: String) {
        FlutterMessageChannelHelper.sendMessageMain(
            "handleSchemeEvent",
            mapOf("type" to type, "extra" to extra, "category" to category)
        )
    }

    override fun sendSchemeEvent(type: String, extra: String) {
        FlutterMessageChannelHelper.sendMessageMain(
            "handleSchemeEvent",
            mapOf("type" to type, "extra" to extra)
        )
    }

    override fun sendMessage(
        messageName: String,
        ext: Map<String, Any?>?,
        callBack: ((String) -> Unit)?,
    ) {
        FlutterMessageChannelHelper.sendMessage(messageName, ext)
    }

    override fun sendMessageMain(
        messageName: String,
        ext: Map<String, Any?>?,
        replayCallback: ((Any?) -> Unit)?,
    ) {
        FlutterMessageChannelHelper.sendMessageMain(messageName, ext, replayCallback)
    }

    override suspend fun <T> getAllDeviceList(clazz: Class<T>): List<T> {
        return suspendCancellableCoroutine { coroutine ->
            try {
                if (ActivityUtil.getInstance()
                        .getActivity(FlutterPluginActivity::class.java) == null
                ) {
                    coroutine.resume(emptyList())
                } else {
                    FlutterMessageChannelHelper.sendMessageMain("getDeviceList", null) { ret ->
                        ret?.let {
                            if (it is String) {
                                val parseLists = GsonUtils.parseLists(ret as String, clazz)
                                coroutine.resume(parseLists)
                            } else {
                                LogUtil.e("TAG", "----- getAllDeviceList ----- $ret")
                                coroutine.resume(emptyList())
                            }
                        } ?: coroutine.resume(emptyList())
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                coroutine.resumeWithException(e)
            }
        }
    }

    override suspend fun checkMqttConnect(): Boolean {
        return suspendCancellableCoroutine { coroutine ->
            try {
                //
                if (ActivityUtil.getInstance()
                        .getActivity(FlutterPluginActivity::class.java) == null
                ) {
                    coroutine.resume(false)
                } else {
                    FlutterMessageChannelHelper.sendMessageMain("checkMqttConnect", null) {
                        if (it is Boolean) {
                            coroutine.resume(it)
                        } else {
                            coroutine.resume(false)
                        }
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                coroutine.resumeWithException(e)
            }

        }
    }

    override fun checkAndConnectMqtt() {
        FlutterMessageChannelHelper.sendMessageMain("checkAndConnectMqtt", null)
    }

    override fun refreshPushToken(params: Map<String, String>): Boolean {
        FlutterMessageChannelHelper.sendMessageMain("refreshPushToken", params)
        return true
    }

    override fun updateDeviceName(did: String, deviceName: String) {
        FlutterMessageChannelHelper.sendMessageMain(
            "updateDeviceName",
            mapOf("did" to did, "deviceName" to deviceName)
        )

        RouteServiceProvider.getService<IAppWidgetDeviceService>()
            ?.updateWidget(
                LocalApplication.getInstance(),
                did,
                mapOf(STATUS_APPWIDGET_DEVICE_NAME to deviceName)
            )

    }

    override fun updateDeviceStatus(did: String, status: List<String>) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain(
                "updateDeviceStatus",
                mapOf("did" to did, "status" to status)
            )
        }
    }

    override fun refreshDeviceList() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain("refreshDeviceList", emptyMap())
        }
    }


    override fun getCommonPlugin(pluginType: String, callBack: (String) -> Unit) {
        FlutterMessageChannelHelper.sendMessageMain(
            "getCommonPlugin",
            mapOf("pluginType" to pluginType)
        ) {
            callBack.invoke(it.toString())
        }
    }

    override fun openMainFlutter(
        context: Context,
        routhPath: String,
        args: MutableMap<String, Any>,
    ): Intent {
        return FlutterActivity.NewEngineIntentBuilder(FlutterPluginActivity::class.java)
            .initialRoute(routhPath)
            .dartEntrypointArgs(listOf(GsonUtils.toJson(args)))
            .build(context)

    }

    override fun openSubFlutter(
        context: Context,
        routhPath: String,
        args: MutableMap<String, Any>,
    ): Intent {
        return FlutterActivity.NewEngineIntentBuilder(FlutterPluginSubActivity::class.java)
            .initialRoute(routhPath)
            .dartEntrypointArgs(listOf(GsonUtils.toJson(args)))
            .build(context)
    }

    override suspend fun <T> getSupportWidgetCacheDeviceList(clazz: Class<T>): List<T> {
        val allDeviceList =
            RouteServiceProvider.getService<IFlutterBridgeService>()?.getAllDeviceList(clazz)
                ?: emptyList()
        val deviceList = allDeviceList.filter {
            when (it) {
                is Device -> {
                    it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath
                            || it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM1.categoryPath
                }

                is DeviceListBean.Device -> {
                    it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath
                            || it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM1.categoryPath
                }

                else -> {
                    true
                }
            }
        }
        return deviceList
    }

    override fun logoff(block: () -> Unit) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain("logoff") { block() }
        } else {
            block()
        }
    }

    override fun gotoFlutterPluginActivity() {
        try {
            DeviceScanCache.clear()
        } finally {
        }
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) == null) {
            LocalApplication.getInstance().startActivity(
                openMainFlutter(LocalApplication.getInstance(), "/root")
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            )
        }
        ActivityUtil.getInstance().finishAllActivityExcept(FlutterPluginActivity::class.java)
    }

    override fun gotoFlutterHomeActivity(context: Context) {
        gotoFlutterPluginActivity()
    }

    override fun devicePairSuccess() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain("devicePairSuccess")
        }
    }

    override fun deleteDevice(did: String) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain("deleteDevice", mutableMapOf("did" to did))
        }
    }

    override fun readShareMessage() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain("readShareMessage")
        }
    }

    override fun tokenExpired() {
        GlobalMainScope.launch {
            if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
                FlutterMessageChannelHelper.sendMessage("tokenExpired")
            }
        }
    }

    override fun refreshTokenSuccess() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("refreshTokenSuccess")
        }
    }
    override fun preLoadDartVM(context: Context) {
        FlutterEngineGroupLauncher.preLoadDartVM(LocalApplication.getInstance())
    }

    override fun isMainEngineRunning(): Boolean {
        return ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null
    }

    override fun isSubEngineRunning(): Boolean {
        return ActivityUtil.getInstance().getActivity(FlutterPluginSubActivity::class.java) != null
    }

    override suspend fun getZendeskKey(): HashMap<String, *> {
        return suspendCancellableCoroutine { coroutine ->
            try {
                FlutterMessageChannelHelper.sendMessageMain("getZendeskKey") { apiKey ->
                    try {
                        val value = when (apiKey) {
                            is HashMap<*, *> -> {
                                @Suppress("UNCHECKED_CAST")
                                apiKey as HashMap<String, *>
                            }

                            else -> hashMapOf<String, Any>()
                        }
                        if (coroutine.isActive) {
                            coroutine.resume(value)
                        }
                    } catch (e: Exception) {
                        if (coroutine.isActive) {
                            coroutine.resumeWithException(e)
                        }
                    }
                }
            } catch (e: Exception) {
                if (coroutine.isActive) {
                    coroutine.resumeWithException(e)
                }
            }
        }
    }


    override fun dnsRequest(host: String, block: (String) -> Unit) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("dnsRequest", mutableMapOf("host" to host), {
                block.invoke(it.toString())
            })
        }
    }

    override fun getCachedDns(host: String, block: (String) -> Unit) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("getCachedDns", mutableMapOf("host" to host), {
                block.invoke(it.toString())
            })
        }
    }

    override fun cleanCachedDns(host: String) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("cleanCachedDns", mutableMapOf("host" to host))
        }
    }

    override fun onAppResume(oldActivity: Activity?, newActivity: Activity) {
        if (oldActivity != null && !oldActivity.javaClass.name.equals(newActivity.javaClass.name)
            && oldActivity.javaClass != SplashActivity::class.java
            && !oldActivity.javaClass.name.equals("com.mobile.auth.gatewayauth.LoginAuthActivity")
            && !oldActivity.javaClass.name.equals("com.fluttercandies.flutter_ali_auth.mask.DecoyMaskActivity")
        ) {
            if (newActivity is FlutterPluginActivity) {
                FlutterMessageChannelHelper.sendMessage("onBackHome")
            }
        }
    }

    override fun onAppEnterForeground() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("onAppEnterForeground")
        }
    }

    override fun onAppEnterBackground() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("onAppEnterBackground")
        }
    }
    override fun proactivelyDisconnect() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("proactivelyDisconnect")
        }
    }

    override fun restoreNetworkConnectivity() {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessage("restoreNetworkConnectivity")
        }
    }

    override fun getCachedProtocolData(did: String, block: (String) -> Unit) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain(
                "getCachedProtocolData",
                mutableMapOf("did" to did)
            ) {
                block.invoke(it.toString())
            }
        }
    }

    override fun callRequest(ext: Map<String, Any?>?, replayCallback: ((Any?) -> Unit)?) {
        FlutterMessageChannelHelper.sendMessageMain("callRequest", ext, replayCallback)
    }

    override fun hasMainMessageChannel(): Boolean {
        return FlutterMessageChannelHelper.hasMainMessageChannel()
    }
    override fun openRnPluginPage(params: Map<String, String>, block: (Any?) -> Unit) {
        if (ActivityUtil.getInstance().getActivity(FlutterPluginActivity::class.java) != null) {
            FlutterMessageChannelHelper.sendMessageMain("openPlugin", params) {
                block.invoke(it?.toString())
            }
        }
    }

}

@com.therouter.inject.ServiceProvider
fun flutterBridgeServiceProvider(): IFlutterBridgeService = FlutterBridgeService()