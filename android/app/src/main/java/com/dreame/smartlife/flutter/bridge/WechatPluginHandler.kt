package com.dreame.smartlife.flutter.bridge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.dreame.module.event.WechatAuthStatus
import android.dreame.module.util.LogUtil
import android.os.Build
import android.util.Log
import com.tencent.mm.opensdk.constants.ConstantsAPI
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.greenrobot.eventbus.EventBus

const val CODE_AUTH_SUCCESS = 0
const val CODE_CANCEL = 1
const val CODE_ERROR = 2
const val CODE_UNINSTALLED = 3
const val CODE_OTHER = 4

class WechatPluginHandler(val context: Context) : MethodCallHandler {
    private var api: IWXAPI? = null // IWXAPI 是第三方app和微信通信的openApi接口
    private val APP_ID = "wx59efb945de8565a0"
    private var receiver: BroadcastReceiver? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        LogUtil.d("----------${call.method}  ${call.arguments}-------------------")
        when (call.method) {
            "initWechat" -> {
                initWechat()
                result.success(true)
            }

            "authWechat" -> {
                wechatLogin()
                result.success(true)
            }

            "dipose" -> {
                if (receiver != null) {
                    context.unregisterReceiver(receiver)
                    receiver = null
                }
                result.success(true)
            }

            else -> {
                result.success(true)
            }
        }
    }

    private fun initWechat() {
        if (api != null) {
            return
        }
        // 通过WXAPIFactory工厂，获取IWXAPI的实例
        api = WXAPIFactory.createWXAPI(context, APP_ID, true)
        // 将应用的appId注册到微信
        api?.registerApp(APP_ID)
        //建议动态监听微信启动广播进行注册到微信
        receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                api?.registerApp(APP_ID)
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(receiver, IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP), Context.RECEIVER_EXPORTED)
        } else {
            context.registerReceiver(receiver, IntentFilter(ConstantsAPI.ACTION_REFRESH_WXAPP))
        }
    }

    protected fun wechatLogin() {
        if (api?.isWXAppInstalled == true) {
            val req = SendAuth.Req()
            req.scope = "snsapi_userinfo"
            req.state = "MOVAhomeAuth:flutter"
            LogUtil.d("sunzhibin", "wechatLogin req $req")
            val result = api?.sendReq(req)
            if (result != true) {
                EventBus.getDefault().post(WechatAuthStatus("Wechat start failed", CODE_ERROR));
            }
        } else {
            EventBus.getDefault().post(WechatAuthStatus("Wechat is not installed", CODE_UNINSTALLED));
        }
    }

    fun onDestroy() {
        if (receiver != null) {
            context.unregisterReceiver(receiver)
            receiver = null
        }
        api = null
    }

}

class WechatPluginEventHandler : StreamHandler {
    private var events: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.events = events
        Log.d("sunzhibin", "onListen: $arguments   -----  $events")
    }

    override fun onCancel(arguments: Any?) {
        Log.d("sunzhibin", "onCancel: $arguments")
    }

    fun onWechatEvent(event: WechatAuthStatus) {
        events?.success(mapOf("errorCode" to event.errorCode, "authCode" to event.authCode))
    }

}

