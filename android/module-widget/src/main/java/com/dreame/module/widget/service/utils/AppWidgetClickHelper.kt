package com.dreame.module.widget.service.utils

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.dreame.module.ui.AppWidgetHandleActivity
import android.dreame.module.util.EscapeUtil
import android.net.Uri
import android.os.Build
import android.os.Parcelable
import com.blankj.utilcode.util.EncodeUtils
import com.mova.module.widget.DeviceUpdateReceiver
import com.dreame.module.widget.constant.*
import org.json.JSONObject

object AppWidgetClickHelper {

    /**
     * 清扫按钮pendingIntent
     * @param context
     * @param appWidgetId
     * @param uid
     * @param did
     */
    fun buildCleanPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int,
    ): PendingIntent {
        return buildPendingBroadcastIntent(context, appWidgetId, uid, did, model, appWidgetType, ACTION_APPWIDGET_CLEAN, CODE_SERVICE_APPWIDGET_CLEAN)
    }

    /**
     * 回充按钮pendingIntent
     * @param context
     * @param appWidgetId
     * @param uid
     * @param did
     */
    fun buildChargingPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int,
    ): PendingIntent {
        return buildPendingBroadcastIntent(
            context,
            appWidgetId,
            uid,
            did,
            model,
            appWidgetType,
            ACTION_APPWIDGET_CHARGING,
            CODE_SERVICE_APPWIDGET_CHARGING
        )
    }

    /**
     * 首页pendingIntent
     * @param context
     * @param appWidgetId
     * @param did
     * @param uid
     */
    fun buildMainActivityPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int,
    ): PendingIntent {
        return buildPendingActivityIntent(
            context,
            appWidgetId,
            uid,
            did,
            model,
            appWidgetType,
            "",
            CODE_SERVICE_APPWIDGET_OPEN_APP
        )
    }

    fun buildMainActivityClickVideoPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int
    ): PendingIntent {
        return buildPendingActivityIntent(
            context,
            appWidgetId,
            uid,
            did,
            model,
            appWidgetType,
            "",
            CODE_SERVICE_APPWIDGET_CLICK_VIDEO,
            "video"
        )
    }

    fun buildMainActivityClickFastCommandPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int
    ): PendingIntent {
        return buildPendingActivityIntent(
            context,
            appWidgetId,
            uid,
            did,
            model,
            appWidgetType,
            "",
            CODE_SERVICE_APPWIDGET_CLICK_FASDT_COMMAND,
            "fastCommand",
        )
    }

    /**
     * Splash pendingIntent
     * @param context
     * @param appWidgetId
     * @param did
     * @param uid
     */
    fun buildSplashActivityPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String,
        appWidgetType: Int,
    ): PendingIntent {
        val clazz = Class.forName("com.dreame.movahome.ui.activity.SplashActivity")
        return buildPendingActivityIntent(
            context,
            appWidgetId,
            uid,
            did,
            "",
            appWidgetType,
            ACTION_APPWIDGET_FLUSH_TOKEN,
            CODE_SERVICE_APPWIDGET_FLUSH_TOKEN,
            "",
            clazz
        )
    }

    /**
     * 设备绑定 pendingIntent
     * @param context
     * @param appWidgetId
     * @param did
     * @param uid
     */
    fun buildSelectActivityPendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String,
        appWidgetType: Int,
    ): PendingIntent {
        val clazz = AppWidgetHandleActivity::class.java
        return buildPendingActivityIntent(
            context,
            appWidgetId,
            uid,
            did,
            "",
            appWidgetType,
            ACTION_APPWIDGET_ADD,
            CODE_ACTIVITY_APPWIDGET_ADD,
            "",
            clazz
        )
    }

    /**
     * 快捷指令列表 pendingIntent
     * @param context
     * @param appWidgetId
     * @param did
     * @param uid
     */
    fun buildFastCmdListIntent(
        context: Context, appWidgetId: Int
    ): PendingIntent {
        val clazz = DeviceUpdateReceiver::class.java
        val pendingIntent: PendingIntent = Intent(context, clazz).let { intent ->
            intent.`package` = context.packageName
            intent.action = ACTION_APPWIDGET_CLICK_LIST
            intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)))
            val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
            PendingIntent.getBroadcast(context, CODE_SERVICE_APPWIDGET_FAST_CMD_LIST + appWidgetId, intent, flag)
        }
        return pendingIntent
    }

    /**
     * 更换设备pendingIntent
     * @param context
     * @param appWidgetId
     * @param did
     * @param uid
     */
    fun buildChangeDevicePendingIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int,
    ): PendingIntent {
        val clazz = AppWidgetHandleActivity::class.java
        return buildPendingActivityIntent(
            context, appWidgetId, uid, did, model, appWidgetType,
            ACTION_APPWIDGET_CHANGE_DEVICE, CODE_SERVICE_APPWIDGET_CHANGE_DEVICE,
            "",
            clazz
        )
    }

    /**
     * 创建广播pendingIntent
     * @param context     Content
     * @param appWidgetId 小组件Id
     * @param uid  uid
     * @param did  设备Id
     * @param model  model
     * @param action  广播处理的action
     * @param requestCode requestCode
     * @param params bundle key value
     * @param clazz  广播类
     */
    fun buildPendingBroadcastIntent(
        context: Context, appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int,
        action: String, requestCode: Int,
        params: Map<String, Parcelable> = emptyMap(),
        clazz: Class<*> = DeviceUpdateReceiver::class.java,
        paramParcelableList: ArrayList<out Parcelable>? = null,
    ): PendingIntent {
        val pendingIntent: PendingIntent = Intent(context, clazz).apply {
            `package` = context.packageName
            this.action = action
            putExtra(KEY_APPWIDGET_ACTION, action)
            putExtra(KEY_APPWIDGET_ID, appWidgetId)
            putExtra(KEY_APPWIDGET_DID, did)
            putExtra(KEY_APPWIDGET_MODEL, model)
            putExtra(KEY_APPWIDGET_UID, uid)
            putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
            paramParcelableList?.let {
                putExtra("list_data", paramParcelableList)
            }
            params.forEach { entity ->
                val key = entity.key
                val value = entity.value
                putExtra(key, value)
            }
        }.let { intent ->
            PendingIntent.getBroadcast(
                context,
                requestCode + appWidgetId,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
        }
        return pendingIntent
    }

    /**
     * 创建Activity pendingIntent
     * @param context     Content
     * @param appWidgetId 小组件Id
     * @param uid  uid
     * @param did  设备Id
     * @param action  广播处理的action
     * @param requestCode requestCode
     * @param type type=plugin 打开插件，type=call视频监控打电话，type=tab切换到对应索引，type=video进入视频监控
     * @param clazz  activity类
     */
    fun buildPendingActivityIntent(
        context: Context,
        appWidgetId: Int, uid: String, did: String, model: String,
        appWidgetType: Int,
        action: String, requestCode: Int,
        type: String = "tab",
        clazz: Class<*> = Class.forName("android.mova.module.rn.load.RnShortcutActivity"),
    ): PendingIntent {
        val pendingIntent: PendingIntent = Intent(context, clazz).apply {
            `package` = context.packageName
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
            putExtra(KEY_APPWIDGET_UID, uid)
            putExtra(KEY_APPWIDGET_DID, did)
            putExtra(KEY_APPWIDGET_MODEL, model)
            putExtra(KEY_APPWIDGET_ID, appWidgetId)
            putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
            if (action.isNotEmpty()) {
                putExtra(KEY_APPWIDGET_ACTION, action)
            }
            buildSchemeParams(did, model, type)
        }.let { intent ->
            PendingIntent.getActivity(
                context,
                requestCode + appWidgetId,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
        }
        return pendingIntent
    }


    /**
     * 文档
     * https://wiki.dreame.tech/pages/viewpage.action?pageId=109432352
     */
    private fun Intent.buildSchemeParams(did: String, model: String, type: String = "tab") {
        try {
            val extJson = JSONObject()
            extJson.put("did", did)
            extJson.put("model", model)
            val extraJson = JSONObject()
            extraJson.put("type", type)
            extJson.put("extra", extraJson)
            val extJsonEscape = EscapeUtil.escape(EncodeUtils.base64Encode2String(extJson.toString().toByteArray()))
            val uri = "mova://smartlife/DEVICE?ext=$extJsonEscape"
            this.putExtra("schemeUri", uri)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


}