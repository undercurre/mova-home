package com.dreame.smartlife.flutter.bridge

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.constant.Constants
import android.dreame.module.data.Result
import android.dreame.module.data.entry.DeviceCatagory
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.ext.processApiResponse
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.DeviceIdUtil
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.mqtt.FlutterMqttManager
import android.dreame.module.view.dialog.CustomProgressDialog
import android.text.TextUtils
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.therouter.TheRouter
import com.dreame.module.res.AlertDialog
import com.dreame.module.service.app.ILogoutClearService
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.service.reactnative.RnPluginService
import com.dreame.module.service.share.IDeviceShareService
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_CLEAN_AREA
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_CLEAN_TIME
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_NAME
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_ONLINE
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_POWER
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_SHARE
import com.dreame.module.widget.constant.STATUS_APPWIDGET_DEVICE_STATUS
import com.dreame.module.widget.constant.STATUS_APPWIDGET_FAST_COMMAND_LIST
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_FAST_COMMAND
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK
import com.dreame.module.widget.constant.STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION
import com.dreame.movahome.flutter.FlutterPluginActivity
import com.dreame.movahome.flutter.FlutterPluginSubActivity
import com.dreame.smartlife.R
import com.dreame.smartlife.flutter.FlutterMessageChannelHelper
import com.dreame.smartlife.ui2.home.call.VideoCallActivity
import com.google.gson.reflect.TypeToken
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class MessageChannelPlugin(val context: FlutterPluginActivity, messenger: BinaryMessenger) :
    BasicMessageChannel.MessageHandler<Any> {

    private var channel: BasicMessageChannel<Any> = BasicMessageChannel(
        messenger, "com.dreame.flutter/message_channel", StandardMessageCodec.INSTANCE
    )

    init {
        channel.setMessageHandler(this)
        FlutterMessageChannelHelper.setMessageChannel(context.currentFlutterEngineId(), channel)
    }

    override fun onMessage(message: Any?, reply: BasicMessageChannel.Reply<Any>) {
        LogUtil.d("MessageChannelPlugin", "onMessage: $message")
        if (message is Map<*, *>) {
            when (message["eventName"] as String) {
                "mqttMsgArrived" -> {
                    val extMap = message["ext"] as Map<*, *>
                    val topic = extMap["topic"] as String
                    val payload = extMap["payload"] as String
                    FlutterMqttManager.invokeMqttMessageListener(topic, payload)
                }

                "mqttWillMsgArrived" -> {
                    val extMap = message["ext"] as Map<*, *>
                    val topic = extMap["topic"] as String
                    val payload = extMap["payload"] as String
                    FlutterMqttManager.invokeMqttWillMessageListener(topic, payload)
                }

                "showShareDialog" -> {
                    val extMap = message["ext"] as Map<*, *>
                    val deviceName = extMap["deviceName"] as String
                    val content = extMap["content"] as String
                    val imageUrl = extMap["imageUrl"] as String
                    val messageId = extMap["messageId"] as String
                    val ackResult = extMap["ackResult"] as Int
                    val deviceId = extMap["did"] as String
                    val model = extMap["model"] as String
                    val ownUid = extMap["ownUid"] as String
                    val currentActivity = ActivityUtil.getInstance().currentActivity
                    if (currentActivity != null && (currentActivity is FlutterPluginSubActivity || currentActivity !is FlutterPluginActivity)) {
                        /// show
                        RouteServiceProvider.getService(IDeviceShareService::class.java)?.showShareDialog(
                            true,
                            content,
                            deviceName,
                            null,
                            imageUrl,
                            messageId,
                            ackResult,
                            deviceId,
                            model,
                            ownUid
                        )
                    }
                }

                "showVideoCall" -> {
                    val ext = message["ext"] as String
                    val device = GsonUtils.fromJson<DeviceListBean.Device>(
                        ext,
                        DeviceListBean.Device::class.java
                    )
                    if (ActivityUtil.getInstance().topActivity is VideoCallActivity) {
                        return
                    }
                    context.startActivity(Intent(context, VideoCallActivity::class.java).apply {
                        putExtra(Constants.KEY_DEVICE, device)
                    })
                }

                "updateAllAppWidget" -> {
                    val ext = message["ext"] as String
                    val deviceList = GsonUtils.fromJson<List<DeviceListBean.Device>>(
                        ext, object : TypeToken<List<DeviceListBean.Device>>() {}.type
                    )
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()
                        ?.updateWidget(context, deviceList)
                }

                "updateAppWidget" -> {
                    val ext = message["ext"] as String
                    val device = GsonUtils.fromJson<DeviceListBean.Device>(
                        ext,
                        DeviceListBean.Device::class.java
                    )
                    val isVacuumDevice = device.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath
                            || device.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM1.categoryPath
                    if (!isVacuumDevice) {
                        return;
                    }
                    // 更新小组件
                    val deviceName = if (!TextUtils.isEmpty(device.customName)) {
                        device.customName
                    } else if (device.deviceInfo != null && !TextUtils.isEmpty(device.deviceInfo?.displayName)) {
                        device.deviceInfo?.displayName
                    } else {
                        device.model
                    } ?: ""
                    val share = if (!device.isMaster) {
                        1
                    } else {
                        0
                    }
                    val map = mapOf(
                        STATUS_APPWIDGET_DEVICE_NAME to deviceName,
                        STATUS_APPWIDGET_SUPPORT_VIDEO to device.isShowVideo,
                        STATUS_APPWIDGET_DEVICE_SHARE to share,
                        STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK to device.supportVideoMultitask(),
                        STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION to device.videoPermission,
                        STATUS_APPWIDGET_SUPPORT_FAST_COMMAND to device.isSupportFastCommand,
                        STATUS_APPWIDGET_DEVICE_STATUS to device.latestStatus,
                        STATUS_APPWIDGET_DEVICE_ONLINE to device.isOnline,
                        STATUS_APPWIDGET_DEVICE_POWER to device.battery,
                        STATUS_APPWIDGET_DEVICE_CLEAN_AREA to device.cleanArea,
                        STATUS_APPWIDGET_DEVICE_CLEAN_TIME to device.cleanTime,
                        STATUS_APPWIDGET_FAST_COMMAND_LIST to GsonUtils.toJson(device.fastCommandList),
                    )

                    Log.d(
                        "MessageChannelPlugin",
                        "updateAppwidget: ${GsonUtils.toJson(device.fastCommandList)}"
                    )
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()
                        ?.updateWidget(context, device.did, map)
                }

                "deleteDevice" -> {
                    val did = message["ext"] as String
                    RouteServiceProvider.getService<IAppWidgetDeviceService>()
                        ?.unlinkedWidget(context, did)
                    RouteServiceProvider.getService<RnPluginService>()
                        ?.clearRnCacheByDid(did)
                }

                "changeLanguage" -> {
                    val extMap = message["ext"] as Map<*, *>
                    val languageTag = extMap["languageTag"] as String?
                    RouteServiceProvider.getService<RnPluginService>()
                        ?.clearAllRnCache()
                    restartApp()
                }

                "changeCountry" -> {
                    val extMap = message["ext"] as Map<*, *>
                    val countryCode = extMap["countryCode"] as String?
                    RouteServiceProvider.getService<ILogoutClearService>()?.logoutClear()
                    RouteServiceProvider.getService<RnPluginService>()?.clearAllRnCache()
                    restartApp()
                }

                "checkAppLogin" -> {
                    val extMap = message["ext"] as Map<*, *>
                    val key = extMap["key"] as String?
                    LogUtil.i("checkAppLogin: $key")
                    if (!key.isNullOrEmpty() && !TextUtils.equals(
                            DeviceIdUtil.getDeviceId(context),
                            key
                        )
                    ) {
                        val activity = ActivityUtil.getInstance().currentActivity
                        if (activity != null) {
                            showOtherLoginDialog(activity)
                        }
                    }
                }

                else -> {

                }
            }
            reply.reply(true)
        }
    }

    private var loginDialog: AlertDialog? = null
    private fun showOtherLoginDialog(activity: Activity) {
        if (loginDialog?.isShowing == true) {
            return
        }
        loginDialog = AlertDialog(activity)
        loginDialog?.show(
            context.getString(R.string.text_login_another_device_title),
            context.getString(R.string.text_login_another_device_content),
            context.getString(R.string.text_retrieve_password),
            context.getString(R.string.cancel),
            null,
        ) {
            if (activity is AppCompatActivity) {
                activity.lifecycleScope.launch {
                    withContext(Dispatchers.Main) {
                        goPasswordReset(activity)
                        it.dismiss()
                    }
                }
            } else {
                GlobalScope.launch {
                    withContext(Dispatchers.Main) {
                        goPasswordReset(activity)
                        it.dismiss()
                    }
                }
            }

        }
    }

    private suspend fun goPasswordReset(activity: Activity) {
        val loading = CustomProgressDialog(activity)
        try {
            loading.show()
            val userResult = withContext(Dispatchers.IO) {
                processApiResponse { DreameService.getUserInfo() }
            }
            loading.dismiss()
            withContext(Dispatchers.Main) {
                if (userResult is Result.Success && userResult.data != null && userResult.data?.hasPass == true) {
                    TheRouter.build(RoutPath.PASSWORD_MODIFY).navigation()
                } else {
                    TheRouter.build(RoutPath.PASSWORD_SETTING).navigation()
                }
            }
        } catch (e: Exception) {
            LogUtil.e("goPasswordReset error")
        } finally {
            if (loading.isShowing) {
                loading.dismiss()
            }
        }
    }

    private fun restartApp() {
        val intent =
            context.packageManager.getLaunchIntentForPackage(context.packageName)
        intent?.let {
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            context.startActivity(intent)
            ActivityUtil.getInstance().finishAllActivity()
        }
    }
}

