package com.dreame.module.widget.service

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.db.AppWidgetInfoEntity
import android.dreame.module.data.entry.DeviceCatagory
import android.dreame.module.data.entry.FastCommand
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.net.Uri
import android.os.Build
import android.text.TextUtils
import android.util.Base64
import android.widget.RemoteViews
import androidx.annotation.IntRange
import androidx.core.content.ContextCompat
import com.dreame.module.service.app.IHomeInteractionService
import com.dreame.module.widget.constant.*
import com.dreame.module.widget.provider.large.WidgetRemoteViewsServiceImpl
import com.dreame.module.widget.service.utils.AppWidgetClickHelper
import com.dreame.module.widget.service.utils.AppWidgetEnum
import com.dreame.smartlife.widget.R
import com.google.gson.reflect.TypeToken

internal abstract class AbstractDeviceAppWidgetUpdateHandle : IDeviceAppWidgetUpdateHandle {
    open fun buildDefaultLayoutId(): Int = R.layout.layout_appwidget_default_small
    override suspend fun buildLinkDevice(
        context: Context,
        appWidgetId: Int,
        uid: String,
        did: String,
        appWidgetType: Int,
        isSingleFunc: Boolean
    ): RemoteViews {
        // 选择设备
        val pendingIntentSelect: PendingIntent =
            AppWidgetClickHelper.buildSelectActivityPendingIntent(context, appWidgetId, uid, did, appWidgetType)
        val pendingIntentSelect2: PendingIntent =
            AppWidgetClickHelper.buildSelectActivityPendingIntent(context, appWidgetId, uid, did, appWidgetType)
        return RemoteViews(context.packageName, buildDefaultLayoutId()).apply {
            setOnClickPendingIntent(R.id.tv_desc, pendingIntentSelect)
            setOnClickPendingIntent(R.id.iv_goto, pendingIntentSelect2)
            val contextNew = LanguageManager.getInstance().setLocal(context)
            setTextViewText(R.id.tv_desc, contextNew.getString(R.string.widget_linked_desc))
        }
    }

    override suspend fun buildTokenError(
        context: Context,
        appWidgetId: Int,
        uid: String,
        did: String,
        appWidgetType: Int,
        isSingleFunc: Boolean
    ): RemoteViews {
        // 跳转登录界面，实际先跳转splash
        val pendingIntentSplash: PendingIntent =
            AppWidgetClickHelper.buildSplashActivityPendingIntent(context, appWidgetId, uid, did, appWidgetType)
        val pendingIntentSplash2: PendingIntent =
            AppWidgetClickHelper.buildSplashActivityPendingIntent(context, appWidgetId, uid, did, appWidgetType)
        return RemoteViews(context.packageName, buildDefaultLayoutId()).apply {
            setOnClickPendingIntent(R.id.tv_desc, pendingIntentSplash)
            setOnClickPendingIntent(R.id.iv_goto, pendingIntentSplash2)
            val contextNew = LanguageManager.getInstance().setLocal(context)
            setTextViewText(R.id.tv_desc, contextNew.getString(R.string.text_widget_notLogin))
        }
    }

    override suspend fun checkNeedUpdateAppWidget(mapCache: Map<String, Any>, mapNew: Map<String, Any>): Boolean {
        if (mapCache[STATUS_APPWIDGET_DEVICE_NAME] != mapNew[STATUS_APPWIDGET_DEVICE_NAME]
            || mapCache[STATUS_APPWIDGET_DEVICE_STATUS] != mapNew[STATUS_APPWIDGET_DEVICE_STATUS]
            || mapCache[STATUS_APPWIDGET_DEVICE_ONLINE] != mapNew[STATUS_APPWIDGET_DEVICE_ONLINE]
            || mapCache[STATUS_APPWIDGET_DEVICE_POWER] != mapNew[STATUS_APPWIDGET_DEVICE_POWER]
            || mapCache[STATUS_APPWIDGET_DEVICE_SHARE] != mapNew[STATUS_APPWIDGET_DEVICE_SHARE]
            || mapCache[STATUS_APPWIDGET_DEVICE_CLEAN_AREA] != mapNew[STATUS_APPWIDGET_DEVICE_CLEAN_AREA]
            || mapCache[STATUS_APPWIDGET_DEVICE_CLEAN_TIME] != mapNew[STATUS_APPWIDGET_DEVICE_CLEAN_TIME]) {
            return true
        }
        return false
    }

    override suspend fun checkNeedUpdateAppWidget(entityOld: AppWidgetInfoEntity, entityNew: AppWidgetInfoEntity): Boolean {
        return true
    }

    protected suspend fun updateButtonStatusRemoteView(
        context: Context,
        remoteViews: RemoteViews,
        typeCode: Int,
        deviceName: String,
        deviceStatus: Int,
        supportVideo: Boolean,
        supportFastCmd: Boolean,
        isOnline: Boolean,
        entity: AppWidgetInfoEntity
    ) {
        remoteViews.setTextViewText(R.id.tv_device_name, deviceName)
        if (!isOnline) {
            remoteViews.setTextViewText(R.id.tv_device_status, "-")
            setButtonIcon(typeCode, remoteViews, false, false, supportVideo, supportFastCmd)
            return
        }
        val language = LanguageManager.getInstance().getLangTag(context)
        val deviceStatusByProtocol = RouteServiceProvider.getService<IHomeInteractionService>()?.getDeviceStatusByProtocol(
            entity.model,
            languageTag = language,
            statusKey = deviceStatus.toString()
        )
        remoteViews.setTextViewText(R.id.tv_device_status, deviceStatusByProtocol ?: "")
        if (entity.category == DeviceCatagory.DEVICE_CATEGORY_VACUUM.categoryPath || entity.category.isEmpty()) {
            when (entity.deviceStatus) {
                1, 7, 9, 10, 11, 12, 15, 16, 17, 18, 20, 22, 23, 25, 26, 27, 97, 98 -> {
                    setButtonIcon(typeCode, remoteViews, true, false, supportVideo, supportFastCmd)
                }

                5 -> {
                    setButtonIcon(typeCode, remoteViews, false, true, supportVideo, supportFastCmd)
                }

                else -> {
                    setButtonIcon(typeCode, remoteViews, false, false, supportVideo, supportFastCmd)
                }
            }
        } else {
            setButtonIcon(typeCode, remoteViews, false, false, false, false)
        }

    }

    /**
     * 设置按钮显示状态
     * @param 小组件类型 small middle large
     * @param remoteViews
     * @param cleaning 清扫中
     * @param charging  回充中
     * @param supportVideo 支持实时视频
     * @param supportFastCmd 支持快捷指令
     */
    private fun setButtonIcon(
        @IntRange(from = 1, to = 8) typeCode: Int,
        remoteViews: RemoteViews,
        cleaning: Boolean,
        charging: Boolean,
        supportVideo: Boolean,
        supportFastCmd: Boolean
    ) {
        when (typeCode) {
            AppWidgetEnum.WIDGET_SMALL_SINGLE.code,
            AppWidgetEnum.WIDGET_SMALL_MULTIFUNCTION.code -> {
                smallMultiWidgetWorkStatus(supportFastCmd, supportVideo, cleaning, charging, remoteViews)
            }

            AppWidgetEnum.WIDGET_SMALL_SINGLE1.code, AppWidgetEnum.WIDGET_SMALL_SINGLE2.code -> {
                smallWidgetWorkStatus(supportFastCmd, supportVideo, cleaning, charging, remoteViews)
            }

            AppWidgetEnum.WIDGET_MIDDLE_SINGLE.code, AppWidgetEnum.WIDGET_MIDDLE_MULTIFUNCTION.code -> {
                mediumWidgetWorkStatus(supportFastCmd, supportVideo, cleaning, charging, remoteViews)
            }

            AppWidgetEnum.WIDGET_LARGE_SINGLE.code, AppWidgetEnum.WIDGET_LARGE_MULTIFUNCTION.code -> {
                largeWidgetWorkStatus(supportFastCmd, supportVideo, cleaning, charging, remoteViews)
            }

        }
    }

    protected fun updateMultiFunction(
        @IntRange(from = 1, to = 6) typeCode: Int,
        remoteViews: RemoteViews,
        battery: Int,
        cleanArea: Float,
        cleanTime: Int,
        isOnline: Boolean
    ) {
        if (!isOnline) {
            remoteViews.setTextViewText(R.id.tv_battery_value, "-")
            remoteViews.setTextViewText(R.id.tv_clean_area, "-")
            remoteViews.setTextViewText(R.id.tv_clean_time, "-")

//            remoteViews.setViewVisibility(R.id.tv_percent, View.INVISIBLE)
//            remoteViews.setViewVisibility(R.id.tv_min, View.INVISIBLE)
//            remoteViews.setViewVisibility(R.id.tv_square_meter, View.INVISIBLE)
            return
        }
//        remoteViews.setViewVisibility(R.id.tv_percent, View.VISIBLE)
//        remoteViews.setViewVisibility(R.id.tv_min, View.VISIBLE)
//        remoteViews.setViewVisibility(R.id.tv_square_meter, View.VISIBLE)
        val batteryStr = if (battery <= -1) {
            "-"
        } else {
            battery.toString()
        }
        val cleanAreaStr = if (cleanArea <= -1f) {
            "-"
        } else if (cleanArea <= 0f) {
            "0"
        } else {
            cleanArea.toInt().toString()
        }
        val cleanTimeStr = if (cleanTime <= -1) {
            "-"
        } else {
            cleanTime.toString()
        }
        remoteViews.setTextViewText(R.id.tv_battery_value, batteryStr)
        remoteViews.setTextViewText(R.id.tv_clean_area, cleanAreaStr)
        remoteViews.setTextViewText(R.id.tv_clean_time, cleanTimeStr)

    }

    /**
     * 设置快捷指令
     */
    protected fun settingFastCommandList(
        context: Context,
        remoteViews: RemoteViews,
        uid: String,
        did: String,
        domain: String,
        model: String,
        appWidgetId: Int,
        appWidgetType: Int,
        deviceFastCmd: String,
    ) {
        val fastCmdList = updateFastCommandStatus(did, deviceFastCmd)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val items = RemoteViews.RemoteCollectionItems.Builder().apply {
                fastCmdList.onEachIndexed { index, item ->
                    val itemRemoteViews = if (item.id < 0) {
                        RemoteViews(context.packageName, R.layout.widget_item_fast_command).apply {
                            val context = LanguageManager.getInstance().setLocal(context)
                            setTextViewText(R.id.tv_fast_command, context.getString(R.string.text_home_fast_command_setting))
                            setImageViewResource(R.id.iv_fast_command, R.drawable.icon_widget_right)
                            val fillInIntent = Intent().apply {
                                putExtra(KEY_APPWIDGET_UID, uid)
                                putExtra(KEY_APPWIDGET_DID, did)
                                putExtra(KEY_APPWIDGET_ID, appWidgetId)
                                putExtra(KEY_APPWIDGET_CLICK, KEY_CLICK_TYPE_FASTCMD)
                                putExtra(KEY_APPWIDGET_ACTION, ACTION_APPWIDGET_OPEN_APP)
                                putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
                            }
                            setOnClickFillInIntent(R.id.ll_item_fast_command, fillInIntent) //设置占位填充的Intent
                        }
                    } else {
                        RemoteViews(context.packageName, R.layout.widget_item_fast_command).apply {
                            setTextViewText(R.id.tv_fast_command, String(Base64.decode(item.name, Base64.DEFAULT)))
                            val drawableId = if (item.state.isNullOrEmpty()) {
                                // 非任务
                                R.drawable.icon_start_clean_fast
                            } else {
                                if (item.state == "1") {
                                    R.drawable.icon_stop_clean_fast
                                } else {
                                    R.drawable.icon_start_clean_fast
                                }
                            }
                            setImageViewResource(R.id.iv_fast_command, drawableId)
                            val intent2 = Intent().apply {
                                putExtra(FASTCMD_ID, item.id)
                                putExtra(FASTCMD_STATE, item.state)
                                putExtra(KEY_APPWIDGET_UID, uid)
                                putExtra(KEY_APPWIDGET_DID, did)
                                putExtra(KEY_APPWIDGET_ID, appWidgetId)
                                putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
                                putExtra(KEY_APPWIDGET_ACTION, ACTION_APPWIDGET_CLICK_LIST)
                            }
                            setOnClickFillInIntent(R.id.ll_item_fast_command, intent2) //设置占位填充的Intent
                        }
                    }
                    LogUtil.d("sunzhibin", "settingFastCommandList: ${item.id}  ${item.name}  ${item.state}")
                    addItem(item.id, itemRemoteViews)
                }
            }.setHasStableIds(true)
                .build()
            remoteViews.setRemoteAdapter(R.id.lv_fast_command, items)
        } else {
            //设置绑定List数据的Service
            val intent = Intent(context, WidgetRemoteViewsServiceImpl::class.java).apply {
                putExtra(KEY_APPWIDGET_ID, appWidgetId)
                putExtra(KEY_APPWIDGET_DID, did)
                putExtra(KEY_APPWIDGET_UID, uid)
                putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
                putExtra(KEY_APPWIDGET_DOMAIN, domain)
                data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
            }
            remoteViews.setRemoteAdapter(R.id.lv_fast_command, intent)  //为RemoteView的List设置适配服务
        }
        val fastCmdListIntent2 =
            if (fastCmdList.size == 1 && fastCmdList.get(0).id < 0) {
                AppWidgetClickHelper.buildMainActivityPendingIntent(context, appWidgetId, uid, did, model, appWidgetType)
            } else {
                AppWidgetClickHelper.buildFastCmdListIntent(context, appWidgetId)
            }
        remoteViews.setPendingIntentTemplate( //设置ListView中Item临时占位Intent
            R.id.lv_fast_command, fastCmdListIntent2
        )
    }

    private fun largeWidgetWorkStatus(
        supportFastCmd: Boolean, supportVideo: Boolean, cleaning: Boolean, charging: Boolean, remoteViews: RemoteViews
    ) {
        if (supportFastCmd || supportVideo) {
            remoteViews.setImageViewResource(
                R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_line else R.drawable.icon_start_clean_line
            )
            remoteViews.setInt(
                R.id.fl_device_clean,
                "setBackgroundResource",
                if (cleaning) R.drawable.shape_background_blue_clean else R.drawable.common_shape_white_r10
            )

            remoteViews.setImageViewResource(
                R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_line else R.drawable.icon_start_charge_line
            )
            remoteViews.setInt(
                R.id.fl_device_charging,
                "setBackgroundResource",
                if (charging) R.drawable.shape_background_green_charge else R.drawable.common_shape_white_r10
            )
            if (supportVideo) {
                remoteViews.setImageViewResource(R.id.iv_device_monitor, R.drawable.icon_video_line)
            }
        } else {
            remoteViews.setImageViewResource(
                R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_line else R.drawable.icon_start_clean_line
            )
            remoteViews.setInt(
                R.id.fl_device_clean,
                "setBackgroundResource",
                if (cleaning) R.drawable.shape_background_blue_clean else R.drawable.common_shape_white_r10
            )
            remoteViews.setImageViewResource(
                R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_line else R.drawable.icon_start_charge_line
            )
            remoteViews.setInt(
                R.id.fl_device_charging,
                "setBackgroundResource",
                if (charging) R.drawable.shape_background_green_charge else R.drawable.common_shape_white_r10
            )
        }
    }

    private fun mediumWidgetWorkStatus(
        supportFastCmd: Boolean, supportVideo: Boolean, cleaning: Boolean, charging: Boolean, remoteViews: RemoteViews
    ) {
        if (supportFastCmd || supportVideo) {
            remoteViews.setImageViewResource(
                R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_line else R.drawable.icon_start_clean_line
            )
            remoteViews.setInt(
                R.id.fl_device_clean,
                "setBackgroundResource",
                if (cleaning) R.drawable.shape_background_blue_clean else R.drawable.common_shape_white_r10
            )
            remoteViews.setImageViewResource(
                R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_line else R.drawable.icon_start_charge_line
            )
            remoteViews.setInt(
                R.id.fl_device_charging,
                "setBackgroundResource",
                if (charging) R.drawable.shape_background_green_charge else R.drawable.common_shape_white_r10
            )
            if (supportVideo) {
                remoteViews.setImageViewResource(R.id.iv_device_monitor, R.drawable.icon_video_line)
            }
            if (supportFastCmd) {
                remoteViews.setImageViewResource(R.id.iv_device_fast_command, R.drawable.icon_fast_command_line)
            }
        } else {
            remoteViews.setImageViewResource(
                R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_line else R.drawable.icon_start_clean_line
            )
            remoteViews.setInt(
                R.id.fl_device_clean,
                "setBackgroundResource",
                if (cleaning) R.drawable.shape_background_blue_clean else R.drawable.common_shape_white_r10
            )
            remoteViews.setImageViewResource(
                R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_line else R.drawable.icon_start_charge_line
            )
            remoteViews.setInt(
                R.id.fl_device_charging,
                "setBackgroundResource",
                if (charging) R.drawable.shape_background_green_charge else R.drawable.common_shape_white_r10
            )

        }
    }

    private fun smallWidgetWorkStatus(
        supportFastCmd: Boolean, supportVideo: Boolean, cleaning: Boolean, charging: Boolean, remoteViews: RemoteViews
    ) {
        if (supportFastCmd || supportVideo) {
            if (cleaning || charging) {
                remoteViews.setImageViewResource(
                    R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_40 else R.drawable.icon_start_clean_40
                )
                remoteViews.setImageViewResource(
                    R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_40 else R.drawable.icon_start_charge_40
                )
            } else {
                remoteViews.setImageViewResource(R.id.iv_device_clean, R.drawable.icon_start_clean_40)
                remoteViews.setImageViewResource(R.id.iv_device_charging, R.drawable.icon_start_charge_40)
            }
            if (supportVideo) {
                remoteViews.setImageViewResource(R.id.iv_device_monitor, R.drawable.icon_video_40)
            }
            if (supportFastCmd) {
                remoteViews.setImageViewResource(R.id.iv_device_fast_command, R.drawable.icon_fast_command_40)
            }
        } else {
            if (cleaning || charging) {
                remoteViews.setImageViewResource(
                    R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_40 else R.drawable.icon_start_clean_40
                )
                remoteViews.setImageViewResource(
                    R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_40 else R.drawable.icon_start_charge_40
                )
            } else {
                remoteViews.setImageViewResource(R.id.iv_device_clean, R.drawable.icon_start_clean_40)
                remoteViews.setImageViewResource(R.id.iv_device_charging, R.drawable.icon_start_charge_40)
            }
        }
    }

    private fun smallMultiWidgetWorkStatus(
        supportFastCmd: Boolean, supportVideo: Boolean, cleaning: Boolean, charging: Boolean, remoteViews: RemoteViews
    ) {
        if (supportFastCmd || supportVideo) {
            remoteViews.setImageViewResource(
                R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_line else R.drawable.icon_start_clean_line
            )
            remoteViews.setInt(
                R.id.fl_device_clean,
                "setBackgroundResource",
                if (cleaning) R.drawable.shape_background_blue_clean else R.drawable.common_shape_white_r10
            )
            remoteViews.setImageViewResource(
                R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_line else R.drawable.icon_start_charge_line
            )

            remoteViews.setInt(
                R.id.fl_device_charging,
                "setBackgroundResource",
                if (charging) R.drawable.shape_background_green_charge else R.drawable.common_shape_white_r10
            )
            if (supportVideo) {
                remoteViews.setImageViewResource(R.id.iv_device_monitor, R.drawable.icon_video_line)
            }
            if (supportFastCmd) {
                remoteViews.setImageViewResource(R.id.iv_device_fast_command, R.drawable.icon_fast_command_line)
            }
        } else {
            remoteViews.setImageViewResource(
                R.id.iv_device_clean, if (cleaning) R.drawable.icon_stop_clean_40 else R.drawable.icon_start_clean_40
            )
            remoteViews.setImageViewResource(
                R.id.iv_device_charging, if (charging) R.drawable.icon_stop_charge_40 else R.drawable.icon_start_charge_40
            )
        }
    }

    private fun updateFastCommandStatus(did: String, value: String): ArrayList<FastCommand> {
        LogUtil.i("updateFastCommandStatus: --------------- did $did, value $value")
        val commandList = ArrayList<FastCommand>()
        if (!TextUtils.isEmpty(value)) {
            try {
                val fastCommandList =
                    GsonUtils.fromJson<List<FastCommand>>(value, object : TypeToken<List<FastCommand?>?>() {}.type) ?: emptyList()
                commandList.addAll(fastCommandList)
                val find = commandList.filter { it.id < 0 }
                if (find.isNotEmpty()) {
                    if (commandList.size > 1) {
                        commandList.removeAll(find)
                    }
                }
//                if (commandList.isEmpty()) {
                    commandList.add(FastCommand(-1, null, null))
//                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        } else {
            commandList.add(FastCommand(-1000, null, null))
        }
        return commandList
    }

}