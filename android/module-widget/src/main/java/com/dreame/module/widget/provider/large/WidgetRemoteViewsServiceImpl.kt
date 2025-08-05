package com.dreame.module.widget.provider.large

import android.content.Context
import android.content.Intent
import android.dreame.module.data.entry.FastCommand
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.os.Build
import android.util.Base64
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.widget.RemoteViewsService.RemoteViewsFactory
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.constant.ACTION_APPWIDGET_CLICK_LIST
import com.dreame.module.widget.constant.ACTION_APPWIDGET_OPEN_APP
import com.dreame.module.widget.constant.FASTCMD_ID
import com.dreame.module.widget.constant.FASTCMD_POSITION
import com.dreame.module.widget.constant.FASTCMD_STATE
import com.dreame.module.widget.constant.KEY_APPWIDGET_ACTION
import com.dreame.module.widget.constant.KEY_APPWIDGET_CLICK
import com.dreame.module.widget.constant.KEY_APPWIDGET_DID
import com.dreame.module.widget.constant.KEY_APPWIDGET_DOMAIN
import com.dreame.module.widget.constant.KEY_APPWIDGET_ID
import com.dreame.module.widget.constant.KEY_APPWIDGET_TYPE
import com.dreame.module.widget.constant.KEY_APPWIDGET_UID
import com.dreame.module.widget.constant.KEY_CLICK_TYPE_FASTCMD
import com.dreame.module.widget.service.utils.AppWidgetClickHelper
import com.dreame.smartlife.widget.R

class WidgetRemoteViewsServiceImpl : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        val extras = intent.extras
        if (extras != null) {
            extras.keySet().forEach { key ->
                val value = extras.get(key)
                Log.d("WidgetRemoteViewsServiceImpl", "onReceive: $key  $value")
            }
        }
        val appWidgetId = intent.getIntExtra(KEY_APPWIDGET_ID, -1)
        val did = intent.getStringExtra(KEY_APPWIDGET_DID) ?: ""
        val uid = intent.getStringExtra(KEY_APPWIDGET_UID) ?: ""
        val domain = intent.getStringExtra(KEY_APPWIDGET_DOMAIN) ?: ""
        val appWidgetType = intent.getIntExtra(KEY_APPWIDGET_TYPE, -1)
        LogUtil.i("sunzhibin", "onGetViewFactory: $appWidgetId  $appWidgetType  $uid  $did  $domain ")
        return WidgetRemoteViewsFactory(applicationContext, appWidgetId, appWidgetType, uid, did, domain)
    }

}

class WidgetRemoteViewsFactory(
    val context: Context,
    val appWidgetId: Int,
    val appWidgetType: Int,
    val uid: String,
    val did: String,
    val domain: String,
    val fastCmdList: MutableList<FastCommand> = mutableListOf()
) :
    RemoteViewsFactory {
    override fun onCreate() {

    }

    override fun onDataSetChanged() {
        Log.d("sunzhibin", "onDataSetChanged: ")
        val newList = mutableListOf<FastCommand>()
        try {
            val entity = AppWidgetCacheHelper.readAppWidgetInfoSync(uid, appWidgetId, domain)
            entity?.let {
                val supportFastCommand = entity.supportFastCommand
                if (supportFastCommand) {
                    val fastCommandListStr = entity.fastCommandListStr ?: ""
                    if (fastCommandListStr.isNotBlank()) {
                        val parseLists = GsonUtils.parseLists(fastCommandListStr, FastCommand::class.java) ?: emptyList()
                        newList.addAll(parseLists)
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        val find = newList.filter { it.id < 0 }
        if (find.isNotEmpty()) {
            if (newList.size > 1) {
                newList.removeAll(find)
            }
        }
        if (newList.isEmpty()) {
            newList.add(FastCommand(-1, null, null))
        }
        fastCmdList.clear()
        fastCmdList.addAll(newList)
        Log.d("sunzhibin", "onDataSetChanged: ${fastCmdList.size}")
    }

    override fun onDestroy() {

    }

    override fun getCount(): Int {
        return fastCmdList.size
    }

    override fun getViewAt(position: Int): RemoteViews {
        // 设置每个item的数据
        val item = if (position >= count) FastCommand(-1, null, null) else fastCmdList.get(position)
        val itemRemoteViews = if (item.id < 0) {
            RemoteViews(context.packageName, R.layout.widget_item_fast_command).apply {
                val context = LanguageManager.getInstance().setLocal(context)
                setTextViewText(R.id.tv_fast_command, context.getString(R.string.text_home_fast_command_setting))
                setImageViewResource(R.id.iv_fast_command, R.drawable.icon_widget_right)
                val fillInIntent = Intent().apply {
                    putExtra(KEY_APPWIDGET_UID, uid)
                    putExtra(KEY_APPWIDGET_ACTION, ACTION_APPWIDGET_OPEN_APP)
                    putExtra(KEY_APPWIDGET_DID, did)
                    putExtra(KEY_APPWIDGET_CLICK, KEY_CLICK_TYPE_FASTCMD)
                    putExtra(KEY_APPWIDGET_ID, appWidgetId)
                    putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
                }
                //设置占位填充的Intent
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    setOnClickResponse(R.id.ll_item_fast_command, RemoteViews.RemoteResponse.fromFillInIntent(fillInIntent))
                } else {
                    setOnClickFillInIntent(R.id.ll_item_fast_command, fillInIntent)
                }
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
                val fillInIntent = Intent().apply {
                    putExtra(FASTCMD_ID, item.id)
                    putExtra(FASTCMD_STATE, item.state)
                    putExtra(FASTCMD_POSITION, position)
                    putExtra(KEY_APPWIDGET_UID, uid)
                    putExtra(KEY_APPWIDGET_DID, did)
                    putExtra(KEY_APPWIDGET_ID, appWidgetId)
                    putExtra(KEY_APPWIDGET_TYPE, appWidgetType)
                    putExtra(KEY_APPWIDGET_ACTION, ACTION_APPWIDGET_CLICK_LIST)
                }
                setOnClickFillInIntent(R.id.ll_item_fast_command, fillInIntent) //设置占位填充的Intent
            }
        }
        return itemRemoteViews
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int = 2

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return false
    }

}