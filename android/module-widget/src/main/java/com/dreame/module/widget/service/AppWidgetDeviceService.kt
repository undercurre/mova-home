package com.dreame.module.widget.service

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.dreame.module.GlobalMainScope
import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.dreame.module.data.entry.DeviceCatagory
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.AppWidgetEventCode
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.graphics.Bitmap
import android.os.Bundle
import android.text.TextUtils
import android.util.Log
import android.widget.RemoteViews
import com.therouter.router.Route
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.constant.CODE_OPERATOR_ADD
import com.dreame.module.widget.constant.CODE_OPERATOR_ERROR
import com.dreame.module.widget.constant.CODE_OPERATOR_ERROR_TOKEN
import com.dreame.module.widget.constant.CODE_OPERATOR_UPDATE
import com.dreame.module.widget.constant.KEY_APPWIDGET_IMGURL
import com.dreame.module.widget.provider.large.DeviceAppWidgetLargeProvider
import com.dreame.module.widget.provider.large.DeviceAppWidgetUpdateHandleLarge
import com.dreame.module.widget.provider.medium.DeviceAppWidgetMediumProvider
import com.dreame.module.widget.provider.medium.DeviceAppWidgetUpdateHandleMedium
import com.dreame.module.widget.provider.small.DeviceAppWidgetSmallProvider
import com.dreame.module.widget.provider.small.DeviceAppWidgetUpdateHandleSmall
import com.dreame.module.widget.provider.small.single1.DeviceAppWidgetSmallSingle1Provider
import com.dreame.module.widget.provider.small.single1.DeviceAppWidgetUpdateHandleSmallSingle1
import com.dreame.module.widget.provider.small.single2.DeviceAppWidgetSmallSingle2Provider
import com.dreame.module.widget.provider.small.single2.DeviceAppWidgetUpdateHandleSmallSingle2
import com.dreame.module.widget.select.utils.PhotoUtils
import com.dreame.module.widget.service.utils.AppWidgetBundleHelper
import com.dreame.module.widget.service.utils.AppWidgetEnum
import com.dreame.smartlife.widget.R
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import kotlin.coroutines.resume

@Route(path = RoutPath.WIDGET_APPWIDGET_SERVICE)
class AppWidgetDeviceService : IAppWidgetDeviceService {
    private val appWidgetHanleMap = mutableMapOf<Int, IDeviceAppWidgetUpdateHandle>()
    private val appWidgetProviderMap = mutableMapOf<Int, String>()

    init {

        appWidgetHanleMap.put(AppWidgetEnum.WIDGET_SMALL_SINGLE.code, DeviceAppWidgetUpdateHandleSmall())
        appWidgetHanleMap.put(AppWidgetEnum.WIDGET_SMALL_SINGLE1.code, DeviceAppWidgetUpdateHandleSmallSingle1())
        appWidgetHanleMap.put(AppWidgetEnum.WIDGET_SMALL_SINGLE2.code, DeviceAppWidgetUpdateHandleSmallSingle2())

        appWidgetHanleMap.put(AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, DeviceAppWidgetUpdateHandleMedium())
        appWidgetHanleMap.put(AppWidgetEnum.WIDGET_LARGE_SINGLE.code, DeviceAppWidgetUpdateHandleLarge())

        appWidgetProviderMap.put(AppWidgetEnum.WIDGET_SMALL_SINGLE.code, DeviceAppWidgetSmallProvider::class.java.name)
        appWidgetProviderMap.put(AppWidgetEnum.WIDGET_SMALL_SINGLE1.code, DeviceAppWidgetSmallSingle1Provider::class.java.name)
        appWidgetProviderMap.put(AppWidgetEnum.WIDGET_SMALL_SINGLE2.code, DeviceAppWidgetSmallSingle2Provider::class.java.name)
        appWidgetProviderMap.put(AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, DeviceAppWidgetMediumProvider::class.java.name)
        appWidgetProviderMap.put(AppWidgetEnum.WIDGET_LARGE_SINGLE.code, DeviceAppWidgetLargeProvider::class.java.name)
    }

    override fun getAppWidgetIds(context: Context, appWidgetType: Int): List<Pair<Int, IntArray>> {
        return when (appWidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code,
            AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_LARGE_SINGLE.code,
            AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                listOf(appWidgetType to getAppWidgetIdsByType(context, appWidgetType))
            }

            else -> {
                appWidgetProviderMap.keys.map { key ->
                    key to getAppWidgetIdsByType(context, key)
                }
            }
        }

    }

    override fun buildWidgetUiAdd(context: Context, appWidgetId: Int, params: Map<String, Any>, appWidgetType: Int) {
        GlobalMainScope.launch {
            LogUtil.d("AppWidgetDevice", "buildWidgetUiAdd: ")
            EventCommonHelper.eventCommonPageInsert(ModuleCode.AppWidget.code, AppWidgetEventCode.Add.code, 0)
            try {
                updateWidget(context, CODE_OPERATOR_ADD, "", appWidgetId, "", params, appWidgetType)
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("addWidget:  ${Log.getStackTraceString(e)}")
            }
        }
    }

    override fun updateWidget(context: Context, deviceId: String, params: Map<String, Any>) {
        LogUtil.d("AppWidgetDevice", "updateWidget: deviceId $deviceId")
        // 遍历所有的小组件, 存在绑定了deviceId则更新小组件
        val uid = AccountManager.getInstance().account?.uid
        val domain = AreaManager.getRegion()
        GlobalMainScope.launch {
            try {
                val list = mutableListOf<AppWidgetInfoEntity>()
                if (!uid.isNullOrEmpty()) {
                    LogUtil.d("AppWidgetDevice", "updateWidget queryWidgetInfo ------------- : $uid  $deviceId $domain ")
                    AppWidgetCacheHelper.queryWidgetInfo(uid, deviceId, domain).onEach { entity ->
                        // uid 相同 并且 did 相同，则更新
                        val entityNew = AppWidgetBundleHelper.createNewEntity(entity, params)
                        LogUtil.d("AppWidgetDevice", "updateWidget queryWidgetInfo -------------entity : $entity")
                        LogUtil.d("AppWidgetDevice", "updateWidget queryWidgetInfo -------------entityNew : $entityNew")
                        LogUtil.d("AppWidgetDevice", "updateWidget queryWidgetInfo -------------params : $params")

                        if (checkDeviceStatusUpdateAppWidget(entity, entityNew)) {
                            list.add(entityNew)
                            updateWidget(context, CODE_OPERATOR_UPDATE, entity.appWidgetId, entity.did, entityNew)
                        }
                    }

                }
                AppWidgetCacheHelper.updateAppWidgetInfo(list)

            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("updateWidget: deviceId   ${Log.getStackTraceString(e)}")
            }
        }
    }


    override fun updateWidget(context: Context, deviceList: List<*>) {
        try {
            updateWidgetDevice(context, deviceList as List<DeviceListBean.Device>)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun updateWidgetDevice(context: Context, deviceLists: List<DeviceListBean.Device>) {
        LogUtil.i("AppWidgetDevice", "updateWidgetDevice: deviceList  ")
        val uid = AccountManager.getInstance().account?.uid
        val domain = AreaManager.getRegion()
        val deviceList = deviceLists.filter {
            it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath
                    || it.deviceInfo?.categoryPath == DeviceCatagory.DEVICE_CATEGORY_VACUUM1.categoryPath
        }
        GlobalMainScope.launch {
            try {
                if (!uid.isNullOrEmpty()) {
                    delay(100)
                    val manager = AppWidgetManager.getInstance(context)
                    // 更新所有的小组件
                    val listUpdate = mutableListOf<AppWidgetInfoEntity>()
                    val listWidgetCurrentUserInfoEmpty = mutableListOf<AppWidgetInfoEntity>()
                    val listDelete = mutableListOf<Int>()
                    val widgetInfoList = mutableListOf<AppWidgetInfoEntity>()
                    getAppWidgetIds(context, -1).apply {
                        val flatten = this.map {
                            it.second.toList()
                        }.flatten()
                        val appWidgetInfoList = AppWidgetCacheHelper.queryWidgetInfo(uid, domain).toMutableList()
                        val ids = appWidgetInfoList.filter { entity ->
                            entity.appWidgetId == -1
                                    || entity.appWidgetType == -1
                                    || !flatten.contains(entity.appWidgetId)
                                    || deviceList.find { it.did == entity.did } == null

                        }.apply {
                            listWidgetCurrentUserInfoEmpty.addAll(this)
                            appWidgetInfoList.removeAll(this)
                        }.map {
                            it.id
                        }
                        if (ids.isNotEmpty()) {
                            LogUtil.i("AppWidgetDevice", "removeCache deleteAppWidgetId: ${ids.joinToString()}")
                            AppWidgetCacheHelper.deleteAppWidgetId(ids)
                        }
                        widgetInfoList.addAll(appWidgetInfoList)
                        LogUtil.d(
                            "AppWidgetDevice",
                            "queryWidgetInfoList: ----------- $uid  ${flatten.joinToString()} $domain  ${widgetInfoList.size}"
                        )
                    }.onEach {
                        val appWidgetType = it.first
                        val appWidgetIds = it.second.toList()

                        for (appWidgetId in appWidgetIds) {
                            val entity = widgetInfoList.find { it.appWidgetId == appWidgetId }
                            if (entity == null) {
                                // feature: 2023.4.21 用户只有一个设备时，默认帮他绑定到所有未绑定设备的小组件
                                if (deviceList.size == 1) {
                                    val device = deviceList.get(0)
                                    LogUtil.i("AppWidgetDevice", "bind appwidget default: $appWidgetId  $appWidgetType")
                                    realBindDeviceAppwidget(context, manager, appWidgetId, appWidgetType, device)
                                } else {
                                    LogUtil.d("AppWidgetDevice", "queryWidgetInfoList: entity == null $appWidgetId  $appWidgetType")
                                    updateWidget(context, CODE_OPERATOR_ADD, uid, appWidgetId, "", emptyMap(), appWidgetType)
                                }
                                continue
                            }
                            val device = deviceList.find { it.did == entity.did }
                            if (device == null) {
                                LogUtil.d("AppWidgetDevice", "deleteAppWidgetId: entity == null $appWidgetId  ${entity.id}  ${entity.did}")
                                listDelete.add(entity.id)
                                updateWidget(context, CODE_OPERATOR_ADD, uid, appWidgetId, "", emptyMap(), appWidgetType)
                            } else {
                                realUpdateWidgetDevice(device, entity, listUpdate, context)
                            }
                        }
                    }
                    AppWidgetCacheHelper.deleteAppWidgetId(listDelete)
                    AppWidgetCacheHelper.updateAppWidgetInfo(listUpdate)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("updateWidget:  deviceList    ${Log.getStackTraceString(e)}")
            }
        }
    }

    private fun realBindDeviceAppwidget(
        context: Context,
        manager: AppWidgetManager,
        appWidgetId: Int,
        appWidgetType: Int,
        device: DeviceListBean.Device
    ) {
        GlobalMainScope.launch {
            val entityNew = AppWidgetBundleHelper.convertMap2Entity(appWidgetId, appWidgetType, device)
            AppWidgetCacheHelper.saveAppWidgetInfoAndClear(entityNew)
            val buildAppWidgetBundle = AppWidgetBundleHelper.convertEntitytoBundle(entityNew)
            manager.updateAppWidgetOptions(appWidgetId, buildAppWidgetBundle)
            val deviceImageUrl = buildAppWidgetBundle.getString(KEY_APPWIDGET_IMGURL) ?: ""
            val result = loadBitmap(deviceImageUrl, appWidgetType)
            updateAppWidget(context, appWidgetId, entityNew, result)
        }
    }

    private suspend fun loadBitmap(deviceImageUrl: String, appWidgetType: Int) = runCatching {
        withContext(Dispatchers.IO) {
            suspendCancellableCoroutine {
                PhotoUtils.loadBitmap(
                    LocalApplication.getInstance(),
                    deviceImageUrl,
                    appWidgetType
                ) { _, _, bitmap ->
                    if (isActive) {
                        it.resume(bitmap)
                    }
                }
            }
        }
    }.getOrNull()

    private suspend fun realUpdateWidgetDevice(
        device: DeviceListBean.Device,
        entity: AppWidgetInfoEntity,
        listUpdate: MutableList<AppWidgetInfoEntity>,
        context: Context
    ) {
        val deviceName = if (!TextUtils.isEmpty(device.customName)) {
            device.customName
        } else if (device.deviceInfo != null && !TextUtils.isEmpty(device.deviceInfo?.displayName)) {
            device.deviceInfo?.displayName
        } else {
            device.model
        } ?: ""
        val imageUrl = device.deviceInfo?.mainImage?.imageUrl ?: ""
        val host = if (!TextUtils.isEmpty(device.bindDomain)) {
            device?.bindDomain?.split("\\.".toRegex())?.dropLastWhile { it.isEmpty() }?.toTypedArray()?.get(0) ?: ""
        } else {
            ""
        }
        val deviceShare = if (device.isMaster) 0 else 1
        LogUtil.d(
            "AppWidgetDevice",
            "updateWidget queryWidgetInfo ------------- : ${device.isShowVideo()}  ${device.videoPermission} ${device.supportVideoMultitask()}  ${device.isSupportFastCommand}"
        )
        val entityNew = entity.copy(
            deviceName = deviceName,
            deviceShare = deviceShare,
            deviceOnline = device.isOnline,
            deviceImagUrl = imageUrl,
            host = host,
            deviceBattery = device.battery,
            deviceStatus = device.latestStatus,
            supportVideo = device.isShowVideo(),
            videoPermission = device.videoPermission,
            supportFastCommand = device.isSupportFastCommand,
            fastCommandListStr = GsonUtils.toJson(device.fastCommandList),
            cleanArea =  device.cleanArea,
            cleanTime = device.cleanTime,
            updateTime = System.currentTimeMillis()
        )
        // do something
        listUpdate.add(entityNew)
        updateWidget(context, CODE_OPERATOR_UPDATE, entity.appWidgetId, entity.did, entityNew)
    }

    override fun flushAllWidget(context: Context) {
        val accessToken = AccountManager.getInstance().account.access_token
        if (accessToken.isNullOrEmpty()) {
            flushAllWidget(context, CODE_OPERATOR_ERROR_TOKEN)
        } else {
            flushAllWidget(context, CODE_OPERATOR_UPDATE)
        }
    }

    override fun flushAllWidget(context: Context, code: Int) {
        val uid = AccountManager.getInstance().account.uid ?: ""
        val domain = AreaManager.getRegion()
        GlobalMainScope.launch {
            try {
                val widgetInfoList = AppWidgetCacheHelper.queryWidgetInfo(uid, domain)
                LogUtil.d("AppWidgetDevice", "flushAllWidget:  queryWidgetInfo $uid  $domain")
                val list = mutableListOf<AppWidgetInfoEntity>()
                getAppWidgetIds(context, -1).onEach {
                    val appWidgetType = it.first
                    val appWidgetIds = it.second.toList()
                    for (appWidgetId in appWidgetIds) {
                        val entity = widgetInfoList.find { it.appWidgetId == appWidgetId }
                        if (entity == null) {
                            LogUtil.i("AppWidgetDeviceService", "flushAllWidget --------- queryWidgetInfoType: $appWidgetId ")
                            updateWidget(context, CODE_OPERATOR_ADD, uid, appWidgetId, "", emptyMap(), appWidgetType)
                            continue
                        }
                        when (code) {
                            CODE_OPERATOR_ADD -> {
                                updateWidget(context, CODE_OPERATOR_ADD, uid, appWidgetId, "", emptyMap(), entity.appWidgetType)
                            }

                            CODE_OPERATOR_ERROR, CODE_OPERATOR_ERROR_TOKEN -> {
                                list.add(entity)
                                updateWidget(context, CODE_OPERATOR_ERROR_TOKEN, appWidgetId, entity.did, entity)
                            }

                            CODE_OPERATOR_UPDATE -> {
                                list.add(entity)
                                updateWidget(context, CODE_OPERATOR_UPDATE, entity.appWidgetId, entity.did, entity)
                            }
                        }
                    }
                }
                //
                AppWidgetCacheHelper.updateAppWidgetInfo(list)
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("AppWidgetDeviceService", "flushAllWidget updateWidget:  ${Log.getStackTraceString(e)}")
            }
        }
    }

    override suspend fun maybeUpdateAppwidgetOptions(
        context: Context,
        appWidgetId: Int,
        appWidgetType: Int,
        updateAppWidgetOptions: Boolean
    ): Bundle {
        val manager = AppWidgetManager.getInstance(context)
        val domain = AreaManager.getRegion()
        return AppWidgetBundleHelper.maybeUpdateAppwidgetOptions(manager, appWidgetId, appWidgetType, domain, updateAppWidgetOptions, null)
    }

    override suspend fun maybeUpdateAppwidgetOptions(
        manager: AppWidgetManager,
        appWidgetId: Int,
        appWidgetType: Int,
        updateAppWidgetOptions: Boolean
    ): Bundle {
        val domain = AreaManager.getRegion()
        return AppWidgetBundleHelper.maybeUpdateAppwidgetOptions(manager, appWidgetId, appWidgetType, domain, updateAppWidgetOptions, null)
    }

    override fun linkedWidget(
        context: Context,
        code: Int,
        appWidgetId: Int,
        appWidgetType: Int,
        did: String,
        bitmap: Bitmap,
        params: Map<String, Any>
    ) {
        GlobalMainScope.launch {
            val domain = AreaManager.getRegion()
            val uid = AccountManager.getInstance().account?.uid ?: ""
            val manager = AppWidgetManager.getInstance(context)
            AppWidgetCacheHelper.deleteAppWidgetInfo(uid, appWidgetId, domain)
            val entityNew = AppWidgetBundleHelper.createOrUpdateNewEntity(manager, appWidgetId, appWidgetType, null, params)
            LogUtil.i(
                "AppWidgetDeviceService",
                "linkedWidget saveAppWidgetInfo: appWidgetId: $appWidgetId ,appWidgetType: $appWidgetType  $entityNew "
            )
            AppWidgetCacheHelper.saveAppWidgetInfoAndClear(entityNew)
            val buildAppWidgetBundle = AppWidgetBundleHelper.convertEntitytoBundle(entityNew)
            manager?.updateAppWidgetOptions(appWidgetId, buildAppWidgetBundle)
            updateAppWidget(context, appWidgetId, entityNew, bitmap)
        }
    }

    override fun unlinkedWidget(context: Context, deviceId: String) {
        GlobalMainScope.launch {
            val domain = AreaManager.getRegion()
            val uid = AccountManager.getInstance().account.uid ?: ""
            val listAppWidgetIds = mutableListOf<Int>()
//            getAppWidgetIds(context, -1).onEach {
//                val appWidgetType = it.first
//                val appWidgetIds = it.second.toList()
//                for (appWidgetId in appWidgetIds) {
//                    listAppWidgetIds.add(appWidgetId)
//                    LogUtil.i("AppWidgetDeviceService", "unlinkedWidget queryWidgetInfoType: $appWidgetId ")
//                    updateWidget(context, CODE_OPERATOR_ADD, uid, appWidgetId, "", emptyMap(), appWidgetType)
//                }
//            }
            AppWidgetCacheHelper.queryWidgetInfo(uid, deviceId, domain).onEach {
                listAppWidgetIds.add(it.appWidgetId)
                LogUtil.i("AppWidgetDeviceService", "unlinkedWidget queryWidgetInfoType: ${it.appWidgetId} ")
                updateWidget(context, CODE_OPERATOR_ADD, uid, it.appWidgetId, "", emptyMap(), it.appWidgetType)
            }
            AppWidgetCacheHelper.removeInfo(uid, listAppWidgetIds, domain)
        }
    }

    override suspend fun updateWidget(
        context: Context,
        code: Int,
        currentUid: String,
        appWidgetId: Int,
        did: String,
        params: Map<String, Any>,
        appWidgetType: Int
    ) {
        LogUtil.i("AppWidgetDeviceService", "updateWidget: code $code ,uid $currentUid ,appWidgetId $appWidgetId  ,did: $did --------- ")
        // Build the widget update for today
        val manager = AppWidgetManager.getInstance(context)
        when (code) {
            CODE_OPERATOR_ADD -> {
                manager?.updateAppWidgetOptions(appWidgetId, AppWidgetBundleHelper.emptyBundle)
                val accessToken = AccountManager.getInstance().account?.access_token ?: ""
                if (accessToken.isBlank()) {
                    val remoteViews = when (appWidgetType) {
                        AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
                        AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code,
                        AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_LARGE_SINGLE.code,
                        AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> buildTokenError(
                            context,
                            appWidgetId,
                            currentUid,
                            did,
                            appWidgetType
                        )

                        else -> null
                    }
                    if (remoteViews != null) {
                        manager?.updateAppWidget(appWidgetId, remoteViews)
                    }
                } else {
                    val remoteViews = when (appWidgetType) {
                        AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
                        AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code,
                        AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_LARGE_SINGLE.code,
                        AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> buildLinkDevice(
                            context,
                            appWidgetId,
                            currentUid,
                            did,
                            appWidgetType
                        )

                        else -> null
                    }
                    if (remoteViews != null) {
                        manager?.updateAppWidget(appWidgetId, remoteViews)
                    }
                    val allDeviceList =
                        RouteServiceProvider.getService<IFlutterBridgeService>()
                            ?.getSupportWidgetCacheDeviceList(DeviceListBean.Device::class.java)
                    if (allDeviceList?.size == 1) {
                        val device = allDeviceList[0]
                        LogUtil.i("AppWidgetDevice", "bind appwidget default: $appWidgetId  $appWidgetType")
                        realBindDeviceAppwidget(context, manager, appWidgetId, appWidgetType, device)
                    }
                }
            }

            CODE_OPERATOR_ERROR, CODE_OPERATOR_ERROR_TOKEN -> {
                // 更新UI，
                Log.d("AppWidget", "buildAppWidgetBundle: CODE_OPERATOR_ERROR_TOKEN --------- $currentUid $appWidgetId")
                val entity = AppWidgetBundleHelper.buildAppWidgetBundleAndUpdateDb(manager, currentUid, appWidgetId, appWidgetType, params)
                val uid = entity.uid
                val updateViews = buildTokenError(context, appWidgetId, uid, did, appWidgetType)
                manager?.updateAppWidget(appWidgetId, updateViews)
            }

            CODE_OPERATOR_UPDATE -> {
                val domain = AreaManager.getRegion()
                Log.d("AppWidget", "buildAppWidgetBundle: CODE_OPERATOR_UPDATE --------- $currentUid $appWidgetId $domain")
                val entity = AppWidgetBundleHelper.buildAppWidgetBundleAndUpdateDb(manager, currentUid, appWidgetId, appWidgetType, params)
                val uid = entity.uid
                val accessToken = AccountManager.getInstance().account.access_token
                if (accessToken.isNullOrEmpty()) {
                    val updateViews = buildTokenError(context, appWidgetId, uid, did, appWidgetType)
                    manager?.updateAppWidget(appWidgetId, updateViews)
                } else {
                    val deviceImageUrl = entity.deviceImagUrl
                    val result = loadBitmap(deviceImageUrl, appWidgetType)
                    updateAppWidget(context, appWidgetId, entity, result)
                }
            }

            else -> {

            }
        }
    }

    override suspend fun updateWidget(context: Context, code: Int, appWidgetId: Int, did: String, appWidgetInfoEntity: Any) {
        val entity = appWidgetInfoEntity as AppWidgetInfoEntity
        LogUtil.i(
            "AppWidgetDeviceService",
            "updateWidget: code $code ,appWidgetId $appWidgetId  ,did: $did +++++++++++ ${entity.supportVideo}"
        )
        // Build the widget update for today
        val manager = AppWidgetManager.getInstance(context)
        val appWidgetType = entity.appWidgetType
        val uid = AccountManager.getInstance().account?.uid ?: ""

        when (code) {
            CODE_OPERATOR_ADD -> {
                manager?.updateAppWidgetOptions(appWidgetId, AppWidgetBundleHelper.emptyBundle)
                val accessToken = AccountManager.getInstance().account?.access_token ?: ""
                if (accessToken.isBlank()) {
                    val remoteViews = when (appWidgetType) {
                        AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
                        AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code,
                        AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_LARGE_SINGLE.code,
                        AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> buildTokenError(context, appWidgetId, "", did, appWidgetType)

                        else -> null
                    }
                    if (remoteViews != null) {
                        manager?.updateAppWidget(appWidgetId, remoteViews)
                    }
                } else {
                    val remoteViews = when (appWidgetType) {
                        AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
                        AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
                        AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code,
                        AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
                        AppWidgetEnum.WIDGET_LARGE_SINGLE.code,
                        AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> buildLinkDevice(context, appWidgetId, uid, did, appWidgetType)

                        else -> null
                    }
                    if (remoteViews != null) {
                        manager?.updateAppWidget(appWidgetId, remoteViews)
                    }
                }
            }

            CODE_OPERATOR_ERROR, CODE_OPERATOR_ERROR_TOKEN -> {
                // 更新UI，
//                AppWidgetCacheHelper.saveAppWidgetInfo(entity)
                val buildAppWidgetBundle = AppWidgetBundleHelper.convertEntitytoBundle(entity)
                manager?.updateAppWidgetOptions(appWidgetId, buildAppWidgetBundle)
                val updateViews = buildTokenError(context, appWidgetId, uid, did, appWidgetType)
                manager?.updateAppWidget(appWidgetId, updateViews)
            }

            CODE_OPERATOR_UPDATE -> {
//                AppWidgetCacheHelper.saveAppWidgetInfo(entity)
                val buildAppWidgetBundle = AppWidgetBundleHelper.convertEntitytoBundle(entity)
                manager?.updateAppWidgetOptions(appWidgetId, buildAppWidgetBundle)
                val accessToken = AccountManager.getInstance().account.access_token
                if (accessToken.isNullOrEmpty()) {
                    val updateViews = buildTokenError(context, appWidgetId, uid, did, appWidgetType)
                    manager?.updateAppWidget(appWidgetId, updateViews)
                } else {
                    val deviceImageUrl = buildAppWidgetBundle.getString(KEY_APPWIDGET_IMGURL) ?: ""
                    val result = loadBitmap(deviceImageUrl, appWidgetType)
                    updateAppWidget(context, appWidgetId, entity, result)
                }
            }

            else -> {

            }
        }
    }

    private suspend fun updateAppWidget(context: Context, appWidgetId: Int, entityNew: AppWidgetInfoEntity, bitmap: Bitmap?) {
        // Push update for this widget to the home screen
        val manager = AppWidgetManager.getInstance(context)
        val remoteViews = buildUpdateRemoteViews(context, appWidgetId, entityNew, bitmap)
        if (remoteViews != null) {
            manager?.updateAppWidget(appWidgetId, remoteViews)
            if (entityNew.appWidgetType == AppWidgetEnum.WIDGET_LARGE_SINGLE.code || entityNew.appWidgetType == AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code) {
                manager?.notifyAppWidgetViewDataChanged(appWidgetId, R.id.lv_fast_command)
            }
        }
    }

    /**
     * 根据不同类型小组件，创建不同的remoteView
     */
    private suspend fun buildUpdateRemoteViews(
        contextOld: Context,
        appWidgetId: Int,
        entity: AppWidgetInfoEntity,
        bitmap: Bitmap?
    ): RemoteViews? {
        val supportVideo = entity.supportVideo && (entity.deviceShare == 0 || entity.deviceShare == 1 && entity.videoPermission)
        val supportFastCmd = entity.supportFastCommand
        val appWidgetType = entity.appWidgetType
        return when (appWidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                val context = LanguageManager.getInstance().setLocal(contextOld)
                appWidgetHanleMap[appWidgetType]?.run {
                    val remoteView = buildUpdateRemoteView(
                        context,
                        appWidgetId,
                        entity.uid,
                        entity.did,
                        entity.model,
                        appWidgetType, supportVideo, supportFastCmd, entity.deviceOnline
                    )
                    settingRemoteView(context, remoteView, entity, bitmap, supportVideo, supportFastCmd)
                    remoteView
                }
            }

            else -> null
        }
    }

    private suspend fun buildTokenError(context: Context, appWidgetId: Int, uid: String, did: String, appWidgetType: Int): RemoteViews? {
        return when (appWidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                appWidgetHanleMap[appWidgetType]?.buildTokenError(context, appWidgetId, uid, did, appWidgetType, false)

            }

            else -> null
        }
    }

    private suspend fun buildLinkDevice(context: Context, appWidgetId: Int, uid: String, did: String, appWidgetType: Int): RemoteViews? {
        return when (appWidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                appWidgetHanleMap[appWidgetType]?.buildLinkDevice(context, appWidgetId, uid, did, appWidgetType, false)
            }

            else -> null
        }
    }

    private suspend fun checkDeviceStatusUpdateAppWidget(entityOld: AppWidgetInfoEntity, entityNew: AppWidgetInfoEntity): Boolean {
        val appWidgetType = entityOld.appWidgetType
        return when (appWidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                appWidgetHanleMap[appWidgetType]?.checkNeedUpdateAppWidget(entityOld, entityNew) == true
            }

            else -> false
        }
    }

    private fun getAppWidgetIdsByType(context: Context, appWidgetType: Int): IntArray {
        return when (appWidgetType) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code, AppWidgetEnum.WIDGET_SMALL_SINGLE2.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code,
            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                val clazzName = appWidgetProviderMap[appWidgetType] ?: ""
                val manager = AppWidgetManager.getInstance(context)
                return manager.getAppWidgetIds(ComponentName(context.packageName, clazzName))
            }

            else -> IntArray(0)
        }
    }


}

@com.therouter.inject.ServiceProvider
fun appWidgetDeviceServiceProvider(): com.dreame.module.service.appwidget.IAppWidgetDeviceService = AppWidgetDeviceService()