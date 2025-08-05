package com.dreame.smartlife.flutter.bridge

import android.app.Activity
import android.content.Intent
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.constant.Constants
import android.dreame.module.data.entry.Device
import android.dreame.module.data.entry.DeviceCatagory
import android.dreame.module.manager.AreaManager
import android.dreame.module.rn.bridge.host.FileModule
import android.dreame.module.rn.bridge.host.StorageModule
import android.dreame.module.rn.data.PluginDataInfo
import android.dreame.module.rn.load.RnCacheManager
import android.dreame.module.rn.load.RnDownloadHelper
import android.dreame.module.rn.utils.FileUtils
import android.dreame.module.ui.EnviSwitchDialog
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.AppUtils
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.MarketTools
import android.dreame.module.util.SPUtil
import android.dreame.module.util.download.rn.RnPluginConstants
import android.dreame.module.util.download.rn.RnPluginInfoHelper
import android.dreame.module.util.toast.ToastUtils
import android.net.Uri
import android.os.Build
import android.text.TextUtils
import com.therouter.TheRouter
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.movahome.flutter.FlutterPluginActivity
import com.dreame.movahome.flutter.FlutterPluginSubActivity
import com.dreame.smartlife.flutter.utils.ShareHandler
import com.dreame.smartlife.help.CustomerServiceManager
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * 相关文档：https://wiki.dreame.tech/pages/viewpage.action?pageId=131991397
 */
class UIModulePlugin(val activity: FlutterActivity) : MethodChannel.MethodCallHandler {

    private val resultMap = HashMap<Int, MethodChannel.Result>()
//    private val manager = ReviewManagerFactory.create(activity)
//    private var reviewInfo: ReviewInfo? = null
//
//    init {
//        val request = manager.requestReviewFlow()
//        request.addOnCompleteListener { task ->
//            if (task.isSuccessful) {
//                reviewInfo = task.result
//            }
//        }
//    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "openPage" -> {
                try {
                    handleGotoPage(call)
                } finally {
                    result.success(true)
                }
            }

            "pushToQRScanInfo" -> {
                // 10002 {@link com.dreame.module.mall.MallWebViewActivity.CODE_SCAN_BAR}
                resultMap.put(10002, result)
                TheRouter.build(RoutPath.DEVICE_PRODUCT_QR)
                    .withBoolean("onlyScan", true)
                    .withInt("scanType", 2)
                    .navigation(activity, 10002)
            }

            "pushToQRScanRN" -> {
                resultMap.put(102, result)
                TheRouter.build(RoutPath.DEVICE_PRODUCT_QR)
                    .withString("operation", "ADD_PLUGIN").navigation(activity, 102)
            }

            "getLocation" -> {
                result.success(true)
            }

            "goToNavigate" -> {
                val args = call.arguments<HashMap<String, Any>>()
                val type = args?.get("type")
                val nav: HashMap<String, Any> = args?.get("nav") as HashMap<String, Any>
                val title = nav["title"]
                val location: HashMap<String, Any> = nav["location"] as HashMap<String, Any>
                val lat = location["lat"]
                val lon = location["lon"]
                val intent = Intent()
                intent.action = Intent.ACTION_VIEW
                intent.addCategory(Intent.CATEGORY_DEFAULT)
                val uri = if (type == "amap") {
                    Uri.parse("androidamap://navi?sourceApplication=Dreamehome&poiname=$title&lat=$lat&lon=$lon&dev=0&style=2")
                } else if (type == "baidu") {
                    Uri.parse("baidumap://map/navi?location=$lat,$lon&coord_type=gcj02&query=$title&src=andr.dreame.Dreamehome")
                } else {
                    null
                }
                intent.data = uri
                if (intent.resolveActivity(activity.packageManager) != null) {
                    activity.activity.startActivity(intent)
                } else {
                    val toast = if (type == "amap") {
                        "请先下载高德地图"
                    } else if (type == "baidu") {
                        "请先下载百度地图"
                    } else {
                        null
                    }
                    toast?.let {
                        ToastUtils.show(it)
                    }
                }
                result.success(true)
            }

            "openShare" -> {
                val args = call.arguments<String>()
                ShareHandler().doShare(args as String) {
                    result.success(null);
                }
            }

            "openPlugin" -> {
                call.arguments<HashMap<String, Any>>()?.let {
                    openPlugin(activity, it)
                }
                result.success(true)
            }

            "inFlutterPage" -> {
                val currentActivity = ActivityUtil.getInstance().currentActivity
                result.success(currentActivity is FlutterPluginActivity && currentActivity !is FlutterPluginSubActivity)
            }

            "openAppStore" -> {
                MarketTools.startMarket(activity)
                result.success(null)
            }

            "clearCache" -> {
                cleanAppCache()
                result.success(true)
            }

            "openMiniProgram" -> {
                val args = call.arguments<HashMap<String, Any>>()
                args?.let {
                    val appletId = it["appletId"] as String
                    val path = it["path"] as String?
                    val api: IWXAPI = WXAPIFactory.createWXAPI(activity, Constants.WECHAT_APP_ID)
                    if (api.isWXAppInstalled) {
                        val req = WXLaunchMiniProgram.Req()
                        if (TextUtils.isEmpty(appletId)) {
                            result.success(102)
                        } else {
                            req.userName = appletId// 填小程序原始
                            ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
                            if (!path.isNullOrEmpty()) {
                                req.path = path
                            }
                            req.miniprogramType =
                                WXLaunchMiniProgram.Req.MINIPTOGRAM_TYPE_RELEASE // 可选打开 开发版，体验版和正式版
                            api.sendReq(req)
                            result.success(100)
                        }
                    } else {
                        result.success(101)
                    }
                }
            }

            "openZhiChiCustomerService" -> {
                CustomerServiceManager.openChat(activity, false, null)
                result.success(true)
            }

            "openZendeskCustomerService" -> {
                val paramsMap = call.arguments<HashMap<String, Any>?>()
                if (paramsMap != null) {
                    CustomerServiceManager.openChat(activity, true, paramsMap)
                }
                result.success(true)
            }

            "switchAppEnv" -> {
                EnviSwitchDialog(activity).showPopupWindow()
                result.success(null)
            }

            "exitEnginer" -> {
                // 上层的引擎退出
                val currentActivity = ActivityUtil.getInstance().currentActivity
                if (currentActivity is FlutterPluginSubActivity) {
                    currentActivity.finish()
                }
                result.success(null)
            }

            "inAppRating" -> {
                if (LocalApplication.getInstance().isGpVersion) {
//                    reviewInfo?.let {
//                        val flow = manager.launchReviewFlow(activity, it)
//                        flow.addOnCompleteListener {
//                            LogUtil.i("UIModulePlugin", "inAppRating finish")
//                        }
//                    }
                    result.success(true)
                } else {
                    result.success(true)
                }
            }

            "openAiSoundApp" -> {
                val args = call.arguments<HashMap<String, String>>()
                val packageName = args?.get("packageName") ?: ""
                val downloadUrl = args?.get("downloadUrl") ?: ""
                openAiSoundApp(packageName, downloadUrl)
                result.success(true)
            }

            "generatePairNetEngine" -> {
                val routePath = call.arguments<String>() ?: ""
                val flutterBridgeService = RouteServiceProvider.getService<IFlutterBridgeService>()
                val arguments: MutableMap<String, Any> = java.util.HashMap()
                arguments["initialExtra"] = routePath
                val intent = flutterBridgeService?.openSubFlutter(activity, routePath, arguments)
                intent?.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                activity.startActivity(intent)
                result.success(true)
            }

            "exitPairNetEngine" -> {
                val isPairDone = call.arguments<Boolean>() ?: false
                val currentActivity = ActivityUtil.getInstance().currentActivity
                if (currentActivity is FlutterPluginSubActivity) {
                    // 子引擎配网
                    if (isPairDone) {
                        RouteServiceProvider.getService<IFlutterBridgeService>()
                            ?.devicePairSuccess()
                    }
                    currentActivity.finish()
                }
                result.success(true)
            }

            "openAppByUrl" -> {
                val url = call.arguments<String>()
                try {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    activity.startActivity(intent)
                } catch (e: Exception) {
                    LogUtil.e("openAppByUrl error, url:$url ,error:$e")
                }
                result.success(true)
            }

            else -> {
                result.success(null)
            }
        }

    }

    private fun openAiSoundApp(packageName: String, downloadUrl: String) {
        val packageArray = packageName.split(",")
        var installApp = false
        packageArray.forEach { name ->
            if (AppUtils.isInstallApp(activity, name)) {
                installApp = true
                val intent = activity.packageManager.getLaunchIntentForPackage(name)
                intent?.flags =
                    Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED
                activity.activity.startActivity(intent)
                return@forEach
            }
        }
        if (!installApp) {
            try {
                if (Build.BRAND.equals("XIAOMI", ignoreCase = true) ||
                    Build.BRAND.equals("REDMI", ignoreCase = true)
                ) {
                    if (downloadUrl.isNotEmpty() == true) {
                        activity.activity.startActivity(
                            Intent(
                                Intent.ACTION_VIEW,
                                Uri.parse(downloadUrl)
                            )
                        )
                    }
                } else {
                    if (packageArray.size > 1) {
                        if (AppUtils.isForeignVersion()) {
                            activity.startActivity(
                                Intent(
                                    Intent.ACTION_VIEW,
                                    Uri.parse("market://details?id=${packageArray[1]}")
                                )
                            )
                        } else {
                            activity.startActivity(
                                Intent(
                                    Intent.ACTION_VIEW,
                                    Uri.parse("market://details?id=${packageArray[0]}")
                                )
                            )
                        }
                    } else {
                        activity.startActivity(
                            Intent(
                                Intent.ACTION_VIEW,
                                Uri.parse("market://details?id=${packageName}")
                            )
                        )
                    }
                }
            } catch (e: Exception) {
                if (downloadUrl.isNotEmpty()) {
                    activity.startActivity(
                        Intent(Intent.ACTION_VIEW, Uri.parse(downloadUrl))
                    )
                }
            }
        }
    }

    private fun handleGotoPage(call: MethodCall) {
        val path = call.argument<String>("path")
        val uri = Uri.parse(path)
        if (path == RoutPath.WIDGET_APPWIDGET_SELECT) {
            handelAppWidgetPage()
        } else {
            // 配网生成sessionID
            if (path == RoutPath.DEVICE_PRODUCT_SELECT || path == RoutPath.DEVICE_PRODUCT_QR) {
                BuriedConnectHelper.generateSessionID()
            }
            TheRouter.build(uri.path).apply {
                uri.queryParameterNames.forEach {
                    val param = uri.getQueryParameter(it)
                    if ("true" == param || "false" == param) {
                        withBoolean(it, "true" == param)
                    } else {
                        withString(it, param)
                    }
                }
            }.navigation()
        }

    }

    /**
     * 小组件页面的跳转
     */
    private fun handelAppWidgetPage() {
        GlobalMainScope.launch {
            val allDeviceList =
                RouteServiceProvider.getService<IFlutterBridgeService>()
                    ?.getAllDeviceList(Device::class.java) ?: emptyList()
            val filter =
                allDeviceList.filter { it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath }
            if (filter.size == 1) {
                val device = filter.get(0)
                val deviceName = if (!TextUtils.isEmpty(device.customName)) {
                    device.customName
                } else if (device.deviceInfo != null && !TextUtils.isEmpty(device.deviceInfo?.displayName)) {
                    device.deviceInfo?.displayName
                } else {
                    device.model
                }
                TheRouter.build(RoutPath.WIDGET_APPWIDGET_ADD_BIND)
                    .withParcelable("data", device)
                    .withString("did", device.did)
                    .withString("deviceImageUrl", device.deviceInfo?.mainImage?.imageUrl)
                    .withString("deviceName", deviceName)
                    .navigation()
            } else {
                TheRouter.build(RoutPath.WIDGET_APPWIDGET_SELECT)
                    .withBoolean("isSelectOrBind", true)
                    .navigation()
            }
        }
    }

    private fun cleanAppCache() {
        // 清理插件
        RnPluginInfoHelper.cancelAll()
        // 清理插件sp文件
        SPUtil.clear(activity, StorageModule.SPNAME)
        LogUtil.i("clearCache: deleteFileAtPathSilently rnfs cacheDir ")
        FileUtils.deleteFileAtPathSilently(LocalApplication.getInstance().cacheDir.path + "/RNFS")
        LogUtil.i("clearCache: deleteFileAtPathSilently rnfs filesDir ")
        FileUtils.deleteFileAtPathSilently(LocalApplication.getInstance().filesDir.path + "/RNFS")
        LogUtil.i("clearCache: deleteFileAtPathSilently externalCacheDir ")
        FileUtils.deleteFileAtPathSilently(LocalApplication.getInstance().externalCacheDir!!.path)
        LogUtil.i("clearCache: deleteFileAtPathSilently cacheDir ")
        FileUtils.deleteFileAtPathSilently(LocalApplication.getInstance().cacheDir.path)
        LogUtil.i("clearCache: deleteFileAtPathSilently externalFilesDir  start ")
        // 删除外部files, 排除 xlog 文件夹
        val externalFilesDir = LocalApplication.getInstance().getExternalFilesDir("")
        val list = externalFilesDir?.listFiles { pathname: File ->
            !TextUtils.equals(
                pathname.name,
                "xlog"
            )
        }
        if (!list.isNullOrEmpty()) {
            for (f in list) {
                FileUtils.deleteFileAtPathSilently(f.path)
            }
        }
        LogUtil.i("clearCache: deleteFileAtPathSilently $externalFilesDir  end ")
        LogUtil.i("clearCache: deleteFileOrFolderSilently ${FileModule.getPluginCachePath()}  start ")
        FileUtils.deleteFileOrFolderSilently(File(FileModule.getPluginCachePath()), false)
        LogUtil.i("clearCache: deleteFileOrFolderSilently ${FileModule.getPluginCachePath()}  end ")
        // 发送通知，清除缓存
        RnCacheManager.clearAllCache()
//        RouteServiceProvider.getService<IMallService>()?.clearUniappCache()
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when (requestCode) {
            10002, 102 -> {
                if (resultCode == Activity.RESULT_OK) {
                    val result = data?.getStringExtra(Constants.EXTRA_RESULT) ?: ""
                    val map = mapOf("code" to 0, "result" to result)
                    resultMap.remove(requestCode)?.success(map)
                } else {
                    val map = mapOf("code" to -1, "result" to "")
                    resultMap.remove(requestCode)?.success(map)
                }
            }
        }
    }

    fun onDestroy() {
        resultMap.clear()
    }


    companion object {
        fun openPlugin(activity: Activity, params: HashMap<String, Any>) {
            params.let {
                val isVideo = it["isVideo"] as Boolean
                val entranceType = it["entranceType"] as String
                val showWarn = it["showWarn"] as Boolean
                val warnCode = it["warnCode"] as String
                val source = it["source"] as String
                val extraData = it["extraData"] as String
                val deviceJson = it["device"] as String
                val device = GsonUtils.fromJson<DeviceListBean.Device>(
                    deviceJson,
                    DeviceListBean.Device::class.java
                )

                val pluginInfo = it["pluginInfo"] as HashMap<String, Any>
                val pluginDataInfo = PluginDataInfo().apply {
                    pluginVersion = pluginInfo["pluginVersion"] as String
                    pluginPath =
                        pluginInfo["pluginPath"] as String + File.separator + RnPluginConstants.PLUGIN_PLUGIN_BUNDLE_NAME
                    pluginMd5 = pluginInfo["pluginMd5"] as String
                    sdkVersion = pluginInfo["sdkVersion"] as String
                    realSdkVersion = pluginInfo["realSdkVersion"] as String
                    sdkPath =
                        pluginInfo["sdkPath"] as String + File.separator + RnPluginConstants.PLUGIN_SDK_BUNDLE_NAME
                    sdkMd5 = pluginInfo["sdkMd5"] as String
                    pluginResPath = pluginInfo["pluginResPath"] as String
                    pluginResVersion = (pluginInfo["pluginResVersion"] as String).toInt()
                    commonPluginVer = (pluginInfo["commonPluginVer"] as String).toInt()
                }
                RnDownloadHelper.goDevicePluginOrDebug(
                    activity,
                    device,
                    isVideo,
                    showWarn,
                    warnCode,
                    entranceType,
                    source,
                    extraData,
                    pluginDataInfo,
                    pluginInfo["isDebug"] as Boolean,
                    pluginInfo["ip"] as String,
                    pluginInfo["debugUrl"] as String
                )
            }
        }
    }

}