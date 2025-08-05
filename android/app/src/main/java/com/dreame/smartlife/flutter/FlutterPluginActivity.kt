package com.dreame.movahome.flutter

import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.dreame.module.event.WechatAuthStatus
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.LogUtil
import android.os.Bundle
import com.dreame.module.res.event.EventUiMode
import com.dreame.module.widget.select.AppWidgetDeviceSelectActivity
import com.dreame.smartlife.flutter.FlutterMessageChannelHelper
import com.dreame.smartlife.flutter.bridge.AccountModulePlugin
import com.dreame.smartlife.flutter.bridge.AlifyModulePlugin
import com.dreame.smartlife.flutter.bridge.FeatureModulePlugin
import com.dreame.smartlife.flutter.bridge.InfoModulePlugin
import com.dreame.smartlife.flutter.bridge.LocalModulePlugin
import com.dreame.smartlife.flutter.bridge.LocalStoragePlugin
import com.dreame.smartlife.flutter.bridge.LogModulePlugin
import com.dreame.smartlife.flutter.bridge.MessageChannelPlugin
import com.dreame.smartlife.flutter.bridge.PairNetModulePlugin
import com.dreame.smartlife.flutter.bridge.UIModulePlugin
import com.dreame.smartlife.flutter.bridge.WechatPluginEventHandler
import com.dreame.smartlife.flutter.bridge.WechatPluginHandler
import com.dreame.smartlife.flutter.engine.FlutterEngineGroupLauncher
import com.dreame.smartlife.flutter.engine.FlutterEngineId
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode


open class FlutterPluginActivity : FlutterActivity() {

    private val wechatPluginEventHandler by lazy { WechatPluginEventHandler() }
    private val wechatPluginHandler by lazy { WechatPluginHandler(this) }
    private val uiModulePlugin by lazy { UIModulePlugin(this) }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        uiModulePlugin.onActivityResult(requestCode, resultCode, data)
    }

    fun currentFlutterEngineId(): String {
        if (this is FlutterPluginSubActivity) {
            return "${FlutterEngineId.SUB.id}_${+this.hashCode()}"
        } else {
            return "${FlutterEngineId.MAIN.id}_${+this.hashCode()}"
        }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        val initialRoute = getInitialRoute() ?: "/root"
        val dartEntrypointArgs = dartEntrypointArgs ?: emptyList()
        val engine =
            FlutterEngineGroupLauncher.createFlutterEngine(this, initialRoute, dartEntrypointArgs)
        LogUtil.i("sunzhibin", "provideFlutterEngine: $engine")
        return engine
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val initialRoute = getInitialRoute() ?: "/root"
        flutterEngine.navigationChannel.setInitialRoute(initialRoute)
        LogUtil.i("sunzhibin", "configureFlutterEngine: $flutterEngine")
        flutterEngine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())

        MessageChannelPlugin(this, flutterEngine.dartExecutor.binaryMessenger)

        MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/wechatChannel")
            .setMethodCallHandler(wechatPluginHandler)

        EventChannel(flutterEngine.dartExecutor, "com.dreame.flutter/wechatEvent")
            .setStreamHandler(wechatPluginEventHandler)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/info")
        methodChannel.setMethodCallHandler(InfoModulePlugin(this))

        val accountChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_account")
        accountChannel.setMethodCallHandler(AccountModulePlugin(this))

        val localChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_local")
        localChannel.setMethodCallHandler(LocalModulePlugin(this))

        val uiChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_ui")
        uiChannel.setMethodCallHandler(uiModulePlugin)

        val featureChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_feature")
        featureChannel.setMethodCallHandler(FeatureModulePlugin(this))

        val alifyChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_alify")
        alifyChannel.setMethodCallHandler(AlifyModulePlugin(this))

        val spChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_local_storage")
        spChannel.setMethodCallHandler(LocalStoragePlugin(this))

        val logChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_log")
        logChannel.setMethodCallHandler(LogModulePlugin(this))

        val pairNetChannel =
            MethodChannel(flutterEngine.dartExecutor, "com.dreame.flutter/module_pair_net")
        pairNetChannel.setMethodCallHandler(PairNetModulePlugin())

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        EventBus.getDefault().register(this)
        ActivityUtil.getInstance().addActivity(this)
        dispatchRoute()
        LogUtil.i("sunzhibin", "onCreate: $flutterEngine, currentFlutterEngineId: ${currentFlutterEngineId()}")
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        dispatchRoute()
        LogUtil.i("sunzhibin", "onNewIntent: $flutterEngine, currentFlutterEngineId: ${currentFlutterEngineId()}")
    }

    /**
     * 分发路由
     */
    private fun dispatchRoute() {
        val extras = intent.extras ?: Bundle()
        val event = extras.getString("event")
        if (event != null && event.equals("handleAppWidgetClickEvent")) {
            val newIntent = Intent(this, AppWidgetDeviceSelectActivity::class.java)
            newIntent.putExtras(extras)
            startActivity(newIntent)
        }
    }

    override fun onPause() {
        super.onPause()
        if (isFinishing) {
            LogUtil.i(
                "sunzhibin",
                "onPause: $flutterEngine, currentFlutterEngineId: ${currentFlutterEngineId()}"
            )
            FlutterMessageChannelHelper.setMessageChannel(currentFlutterEngineId(), null)
        }
    }

    override fun onDestroy() {
        LogUtil.i(
            "sunzhibin",
            "onDestroy: $flutterEngine, currentFlutterEngineId: ${currentFlutterEngineId()}"
        )
        FlutterMessageChannelHelper.setMessageChannel(currentFlutterEngineId(), null)
        super.onDestroy()
        ActivityUtil.getInstance().removeActivity(this)
        EventBus.getDefault().unregister(this)
        uiModulePlugin.onDestroy()
        wechatPluginHandler.onDestroy()
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: WechatAuthStatus) {
        wechatPluginEventHandler.onWechatEvent(event)
    }

    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(LanguageManager.getInstance().setLocal(newBase))
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        LogUtil.i("FlutterPluginActivity", "onConfigurationChanged newConfig:$newConfig")
        super.onConfigurationChanged(newConfig)
        ActivityUtil.getInstance().currentActivity = activity
        // 通知Flutter 刷新changeAppTheme
        // 暗黑适配参考文档:[https://www.cnblogs.com/baiqiantao/p/14495880.html#%E7%9B%91%E5%90%AC%E6%B7%B1%E8%89%B2%E6%A8%A1%E5%BC%8F%E7%8A%B6%E6%80%81%E6%94%B9%E5%8F%98]
        DarkThemeUtils.changeThemeMode(this)
        val isDark = DarkThemeUtils.isDarkTheme(context.applicationContext)
        EventBus.getDefault().post(EventUiMode(isDark))
    }
}