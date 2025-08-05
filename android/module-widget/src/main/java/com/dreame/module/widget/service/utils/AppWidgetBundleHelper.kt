package com.dreame.module.widget.service.utils

import android.appwidget.AppWidgetManager
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.os.Bundle
import android.text.TextUtils
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.constant.*

object AppWidgetBundleHelper {

    suspend fun buildAppWidgetBundleAndUpdateDb(
        manager: AppWidgetManager,
        uid: String,
        appWidgetId: Int,
        appWidgetType: Int,
        params: Map<String, Any>
    ): AppWidgetInfoEntity {
        val domain = AreaManager.getRegion()
        val entity = AppWidgetCacheHelper.readAppWidgetInfo(uid, appWidgetId, domain)
        val newEntity = createOrUpdateNewEntity(manager, appWidgetId, appWidgetType, entity, params)
        AppWidgetCacheHelper.updateAppWidgetInfo(newEntity)
        val convertEntitytoBundle = convertEntitytoBundle(newEntity)
        manager.updateAppWidgetOptions(appWidgetId, convertEntitytoBundle)
        return newEntity;
    }

    /**
     * 检查更新AppwidgetOptions
     * @param manager
     * @param appWidgetId
     * @param domain
     * @param updateAppWidgetOptions
     * @param deviceIdRemove
     * @return did host uid
     */
    suspend fun maybeUpdateAppwidgetOptions(
        manager: AppWidgetManager,
        appWidgetId: Int, appWidgetType: Int,
        domain: String,
        updateAppWidgetOptions: Boolean = true,
        deviceIdRemove: String? = null
    ): Bundle {
        val appWidgetOptions = manager.getAppWidgetOptions(appWidgetId)
        val uid = appWidgetOptions.getString(KEY_APPWIDGET_UID, "")
        val did = appWidgetOptions.getString(KEY_APPWIDGET_DID, "")
        val host = appWidgetOptions.getString(KEY_APPWIDGET_HOST, "")
        appWidgetOptions.putInt(KEY_APPWIDGET_TYPE, appWidgetType)
        val currentUid = AccountManager.getInstance().account.uid ?: ""
        if (did.isNullOrBlank() || uid != currentUid) {
            val entity = AppWidgetCacheHelper.readAppWidgetInfo(currentUid, appWidgetId, domain)
            if (entity != null && !TextUtils.isEmpty(entity.did)) {
                LogUtil.i("sunzhibin", "onUpdate appWidgetOptions: $host   $entity ")
                if (did != deviceIdRemove) {
                    val entitytoBundle = convertEntitytoBundle(entity)
                    appWidgetOptions.putAll(entitytoBundle)
                    if (updateAppWidgetOptions) {
                        manager.updateAppWidgetOptions(appWidgetId, appWidgetOptions)
                    }
                }
            } else {
                appWidgetOptions.putAll(emptyBundle)
            }
        }
        return appWidgetOptions
    }

    val emptyBundle = Bundle().apply {
        putString(KEY_APPWIDGET_UID, "")
        putString(KEY_APPWIDGET_DID, "")
        putString(KEY_APPWIDGET_HOST, "")
        putString(KEY_APPWIDGET_MODEL, "")
        putString(KEY_APPWIDGET_CATEGORY, "")
        putString(KEY_APPWIDGET_DOMAIN, "")
        putString(KEY_APPWIDGET_IMGURL, "")
        putString(STATUS_APPWIDGET_DEVICE_NAME, "")
        putBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO, false)
        putBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION, false)
        putBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK, false)
        putBoolean(STATUS_APPWIDGET_SUPPORT_FAST_COMMAND, false)
        putInt(STATUS_APPWIDGET_DEVICE_STATUS, -1)
        putInt(STATUS_APPWIDGET_DEVICE_POWER, -1)
        putBoolean(STATUS_APPWIDGET_DEVICE_ONLINE, true)
        putBoolean(STATUS_APPWIDGET_DEVICE_SHARE, false)
        putFloat(STATUS_APPWIDGET_DEVICE_CLEAN_AREA, -1f)
        putInt(STATUS_APPWIDGET_DEVICE_CLEAN_TIME, -1)
    }


    fun convertEntitytoBundle(entity: AppWidgetInfoEntity?): Bundle {
        val bundle = Bundle()
        return entity?.let {
            bundle.apply {
                putString(KEY_APPWIDGET_UID, entity.uid)
                putString(KEY_APPWIDGET_DID, entity.did)
                putString(KEY_APPWIDGET_HOST, entity.host)
                putString(KEY_APPWIDGET_MODEL, entity.model)
                putString(KEY_APPWIDGET_CATEGORY, entity.category)
                putString(KEY_APPWIDGET_DOMAIN, entity.domain)
                putInt(KEY_APPWIDGET_TYPE, entity.appWidgetType)
                putString(KEY_APPWIDGET_IMGURL, entity.deviceImagUrl)
                putString(STATUS_APPWIDGET_DEVICE_NAME, entity.deviceName)
                putBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO, entity.supportVideo)
                putBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK, entity.videoTask)
                putBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION, entity.videoPermission)
                putBoolean(STATUS_APPWIDGET_SUPPORT_FAST_COMMAND, entity.supportFastCommand)
                putInt(STATUS_APPWIDGET_DEVICE_STATUS, entity.deviceStatus)
                putInt(STATUS_APPWIDGET_DEVICE_POWER, entity.deviceBattery)
                putBoolean(STATUS_APPWIDGET_DEVICE_ONLINE, entity.deviceOnline)
                putInt(STATUS_APPWIDGET_DEVICE_SHARE, entity.deviceShare)
                putFloat(STATUS_APPWIDGET_DEVICE_CLEAN_AREA, entity.cleanArea)
                putInt(STATUS_APPWIDGET_DEVICE_CLEAN_TIME, entity.cleanTime)
            }
        } ?: bundle

    }

    fun convertMap2Entity(appWidgetId: Int, appWidgetType: Int, appWidgetOptions: Bundle, params: Map<String, Any>): AppWidgetInfoEntity {
        val uid = if (params.containsKey(KEY_APPWIDGET_UID)) {
            params[KEY_APPWIDGET_UID]?.toString() ?: ""
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_UID, "")
        }
        val did = if (params.containsKey(KEY_APPWIDGET_DID)) {
            params[KEY_APPWIDGET_DID]?.toString() ?: ""
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_DID, "")
        }

        val host = if (params.containsKey(KEY_APPWIDGET_HOST)) {
            params[KEY_APPWIDGET_HOST]?.toString() ?: ""
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_HOST, "")
        }

        val model = if (params.containsKey(KEY_APPWIDGET_MODEL)) {
            params[KEY_APPWIDGET_MODEL]?.toString() ?: ""
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_MODEL, "")
        }
        val category = if (params.containsKey(KEY_APPWIDGET_CATEGORY)) {
            params[KEY_APPWIDGET_CATEGORY]?.toString() ?: ""
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_CATEGORY, "")
        }

        val deviceName = if (params.containsKey(STATUS_APPWIDGET_DEVICE_NAME)) {
            params[STATUS_APPWIDGET_DEVICE_NAME]?.toString() ?: did
        } else {
            appWidgetOptions.getString(STATUS_APPWIDGET_DEVICE_NAME, did)
        }

        val deviceStatus = if (params.containsKey(STATUS_APPWIDGET_DEVICE_STATUS)) {
            params[STATUS_APPWIDGET_DEVICE_STATUS]?.let { it as Int } ?: -1
        } else {
            appWidgetOptions.getInt(STATUS_APPWIDGET_DEVICE_STATUS, -1)
        }

        val power = if (params.containsKey(STATUS_APPWIDGET_DEVICE_POWER)) {
            params[STATUS_APPWIDGET_DEVICE_POWER]?.let { it as Int } ?: 100
        } else {
            appWidgetOptions.getInt(STATUS_APPWIDGET_DEVICE_POWER, 100)
        }
        val online = if (params.containsKey(STATUS_APPWIDGET_DEVICE_ONLINE)) {
            params[STATUS_APPWIDGET_DEVICE_ONLINE]?.let { it as Boolean } ?: true
        } else {
            appWidgetOptions.getBoolean(STATUS_APPWIDGET_DEVICE_ONLINE, true)
        }
        val imgUrl = if (params.containsKey(KEY_APPWIDGET_IMGURL)) {
            params[KEY_APPWIDGET_IMGURL]?.toString() ?: ""
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_IMGURL, "")
        }
        val appwidgetType = if (params.containsKey(KEY_APPWIDGET_TYPE)) {
            params[KEY_APPWIDGET_TYPE]?.let { it as Int } ?: appWidgetType
        } else {
            appWidgetOptions.getInt(KEY_APPWIDGET_TYPE, appWidgetType)
        }
        val domain = if (params.containsKey(KEY_APPWIDGET_DOMAIN)) {
            params[KEY_APPWIDGET_DOMAIN] as String
        } else {
            appWidgetOptions.getString(KEY_APPWIDGET_DOMAIN, "") ?: ""
        }
        val supportVideoTask = if (params.containsKey(STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK)) {
            params[STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK]?.let { it as Boolean } ?: false
        } else {
            appWidgetOptions.getBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK, false)
        }
        val supportVideoPermission = if (params.containsKey(STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION)) {
            params[STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION]?.let { it as Boolean } ?: false
        } else {
            appWidgetOptions.getBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION, false)
        }
        val supportVideo = if (params.containsKey(STATUS_APPWIDGET_SUPPORT_VIDEO)) {
            params[STATUS_APPWIDGET_SUPPORT_VIDEO]?.let { it as Boolean } ?: false
        } else {
            appWidgetOptions.getBoolean(STATUS_APPWIDGET_SUPPORT_VIDEO, false)
        }
        val supportFastCmd = if (params.containsKey(STATUS_APPWIDGET_SUPPORT_FAST_COMMAND)) {
            params[STATUS_APPWIDGET_SUPPORT_FAST_COMMAND]?.let { it as Boolean } ?: false
        } else {
            appWidgetOptions.getBoolean(STATUS_APPWIDGET_SUPPORT_FAST_COMMAND, false)
        }

        val fastCommandListStr = if (params.containsKey(STATUS_APPWIDGET_FAST_COMMAND_LIST)) {
            params[STATUS_APPWIDGET_FAST_COMMAND_LIST]?.let { it as String } ?: ""
        } else {
            appWidgetOptions.getString(STATUS_APPWIDGET_FAST_COMMAND_LIST, "")
        }

        val cleanArea = if (params.containsKey(STATUS_APPWIDGET_DEVICE_CLEAN_AREA)) {
            params[STATUS_APPWIDGET_DEVICE_CLEAN_AREA]?.let { it as Float } ?: -1f
        } else {
            appWidgetOptions.getFloat(STATUS_APPWIDGET_DEVICE_CLEAN_AREA, -1f)
        }
        val cleanTime = if (params.containsKey(STATUS_APPWIDGET_DEVICE_CLEAN_TIME)) {
            params[STATUS_APPWIDGET_DEVICE_CLEAN_TIME]?.let { it as Int } ?: -1
        } else {
            appWidgetOptions.getInt(STATUS_APPWIDGET_DEVICE_CLEAN_TIME, -1)
        }
        val deviceShare = if (params.containsKey(STATUS_APPWIDGET_DEVICE_SHARE)) {
            params[STATUS_APPWIDGET_DEVICE_SHARE]?.let { it as Int } ?: -1
        } else {
            appWidgetOptions.getInt(STATUS_APPWIDGET_DEVICE_SHARE, -1)
        }

        return AppWidgetInfoEntity(
            appWidgetId, appwidgetType, uid, did, domain, host, deviceName, deviceShare, online, imgUrl, power,
            deviceStatus, supportVideo, supportVideoTask, supportVideoPermission,
            supportFastCmd, fastCommandListStr, cleanArea, cleanTime, category, model
        )
    }

    fun createOrUpdateNewEntity(
        manager: AppWidgetManager,
        appWidgetId: Int,
        appWidgetType: Int,
        entity: AppWidgetInfoEntity?,
        params: Map<String, Any>
    ): AppWidgetInfoEntity {
        return if (entity == null) {
            val appWidgetOptions = manager.getAppWidgetOptions(appWidgetId)
            convertMap2Entity(appWidgetId, appWidgetType, appWidgetOptions, params)
        } else {
            createNewEntity(entity, params)
        }
    }

    /**
     * 更新entity
     */
    fun createNewEntity(entity: AppWidgetInfoEntity, params: Map<String, Any>): AppWidgetInfoEntity {
        val entityNew = entity.copy(updateTime = System.currentTimeMillis())
        if (params.containsKey(KEY_APPWIDGET_UID)) {
            val uid = params[KEY_APPWIDGET_UID]?.toString() ?: ""
            entityNew.uid = uid
        }
        if (params.containsKey(KEY_APPWIDGET_DID)) {
            val did = params[KEY_APPWIDGET_DID]?.toString() ?: ""
            entityNew.did = did
        }

        if (params.containsKey(KEY_APPWIDGET_HOST)) {
            val host = params[KEY_APPWIDGET_HOST]?.toString() ?: ""
            entityNew.host = host
        }
        if (params.containsKey(KEY_APPWIDGET_MODEL)) {
            val model = params[KEY_APPWIDGET_MODEL]?.toString() ?: ""
            entityNew.model = model
        }
        if (params.containsKey(KEY_APPWIDGET_CATEGORY)) {
            val category = params[KEY_APPWIDGET_CATEGORY]?.toString() ?: ""
            entityNew.category = category
        }
        if (params.containsKey(KEY_APPWIDGET_DOMAIN)) {
            val domain = params[KEY_APPWIDGET_DOMAIN]?.toString() ?: ""
            entityNew.domain = domain
        }
        if (params.containsKey(KEY_APPWIDGET_ID)) {
            val appWidgetId = params[KEY_APPWIDGET_ID]?.let { it as Int } ?: -1
            entityNew.appWidgetId = appWidgetId
        }
        if (params.containsKey(KEY_APPWIDGET_TYPE)) {
            val appWidgetType = params[KEY_APPWIDGET_TYPE]?.let { it as Int } ?: -1
            entityNew.appWidgetType = appWidgetType
        }

        if (params.containsKey(STATUS_APPWIDGET_DEVICE_NAME)) {
            val deviceName = params[STATUS_APPWIDGET_DEVICE_NAME]?.toString() ?: entity.did
            entityNew.deviceName = deviceName
        }

        if (params.containsKey(STATUS_APPWIDGET_DEVICE_NAME)) {
            val deviceName = params[STATUS_APPWIDGET_DEVICE_NAME]?.toString() ?: entity.did
            entityNew.deviceName = deviceName
        }
        if (params.containsKey(STATUS_APPWIDGET_DEVICE_STATUS)) {
            val deviceStatus = params[STATUS_APPWIDGET_DEVICE_STATUS]?.let { it as Int } ?: -1
            entityNew.deviceStatus = deviceStatus
        }

        if (params.containsKey(STATUS_APPWIDGET_DEVICE_POWER)) {
            val power = params[STATUS_APPWIDGET_DEVICE_POWER]?.let { it as Int } ?: -1
            entityNew.deviceBattery = power
        }
        if (params.containsKey(STATUS_APPWIDGET_DEVICE_ONLINE)) {
            val online = params[STATUS_APPWIDGET_DEVICE_ONLINE]?.let { it as Boolean } ?: true
            entityNew.deviceOnline = online
        }
        if (params.containsKey(KEY_APPWIDGET_IMGURL)) {
            val imgUrl = params[KEY_APPWIDGET_IMGURL]?.toString() ?: ""
            entityNew.deviceImagUrl = imgUrl
        }
        if (params.containsKey(KEY_APPWIDGET_TYPE)) {
            val appwidgetType = params[KEY_APPWIDGET_TYPE]?.let { it as Int } ?: -1
            entityNew.appWidgetType = appwidgetType
        }
        if (params.containsKey(KEY_APPWIDGET_DOMAIN)) {
            val domain = params[KEY_APPWIDGET_DOMAIN]?.toString() ?: ""
            entityNew.domain = domain
        }
        if (params.containsKey(STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION)) {
            val video_permission = params[STATUS_APPWIDGET_SUPPORT_VIDEO_PERMISSION]?.let { it as Boolean } ?: false
            entityNew.videoPermission = video_permission
        }
        if (params.containsKey(STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK)) {
            val videoTask = params[STATUS_APPWIDGET_SUPPORT_VIDEO_MULTITASK]?.let { it as Boolean } ?: false
            entityNew.videoTask = videoTask
        }

        if (params.containsKey(STATUS_APPWIDGET_SUPPORT_VIDEO)) {
            val supportVideo = params[STATUS_APPWIDGET_SUPPORT_VIDEO]?.let { it as Boolean } ?: false
            entityNew.supportVideo = supportVideo
        }

        if (params.containsKey(STATUS_APPWIDGET_SUPPORT_FAST_COMMAND)) {
            val supportFastCmd = params[STATUS_APPWIDGET_SUPPORT_FAST_COMMAND]?.let { it as Boolean } ?: false
            entityNew.supportFastCommand = supportFastCmd
        }
        if (params.containsKey(STATUS_APPWIDGET_FAST_COMMAND_LIST)) {
            val fastCommandList = params[STATUS_APPWIDGET_FAST_COMMAND_LIST]?.let { it as String } ?: ""
            entityNew.fastCommandListStr = fastCommandList
        }
        if (params.containsKey(STATUS_APPWIDGET_DEVICE_CLEAN_AREA)) {
            val cleanArea = params[STATUS_APPWIDGET_DEVICE_CLEAN_AREA]?.let { it as Float } ?: -1f
            entityNew.cleanArea = cleanArea
        }
        if (params.containsKey(STATUS_APPWIDGET_DEVICE_CLEAN_TIME)) {
            val cleanTime = params[STATUS_APPWIDGET_DEVICE_CLEAN_TIME]?.let { it as Int } ?: -1
            entityNew.cleanTime = cleanTime
        }
        if (params.containsKey(STATUS_APPWIDGET_DEVICE_SHARE)) {
            val deviceShare = params[STATUS_APPWIDGET_DEVICE_SHARE]?.let { it as Int } ?: -1
            entityNew.deviceShare = deviceShare
        }
        return entityNew
    }

    fun convertMap2Entity(appWidgetId: Int, appwidgetType: Int, device: DeviceListBean.Device): AppWidgetInfoEntity {
        val uid = AccountManager.getInstance().account?.uid ?: ""
        val did = device.did
        val host = if (!TextUtils.isEmpty(device.bindDomain)) {
            device.bindDomain?.split("\\.".toRegex())?.dropLastWhile { it.isEmpty() }?.toTypedArray()?.get(0) ?: ""
        } else {
            ""
        }
        val model = device.model ?: ""
        val category = device.deviceInfo?.categoryPath ?: ""
        val deviceName = if (!TextUtils.isEmpty(device.customName)) {
            device.customName
        } else if (device.deviceInfo != null && !TextUtils.isEmpty(device.deviceInfo?.displayName)) {
            device.deviceInfo?.displayName
        } else {
            device.model
        } ?: ""
        val deviceStatus = device.latestStatus
        val power = device.battery
        val online = device.isOnline
        val imgUrl = device.deviceInfo?.mainImage?.imageUrl ?: ""
        val domain = AreaManager.getRegion()

        val supportVideoTask = device.supportVideoMultitask()
        val supportVideoPermission = device.videoPermission
        val supportVideo = device.isShowVideo
        val supportFastCmd = device.isSupportFastCommand
        val fastCommandListStr = GsonUtils.toJson(device.fastCommandList)

        val cleanArea = device.cleanArea
        val cleanTime = device.cleanTime
        val deviceShare = if (device.isMaster) 0 else 1

        return AppWidgetInfoEntity(
            appWidgetId, appwidgetType, uid, did, domain, host, deviceName, deviceShare, online, imgUrl, power,
            deviceStatus, supportVideo, supportVideoTask, supportVideoPermission,
            supportFastCmd, fastCommandListStr, cleanArea, cleanTime, category, model
        )
    }

}