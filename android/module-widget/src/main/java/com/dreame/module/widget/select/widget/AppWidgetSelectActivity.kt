package com.dreame.module.widget.select.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.Context
import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.data.entry.Device
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.util.ClickableSpanWrapper
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.os.Build
import android.text.SpannableString
import android.text.Spanned
import android.text.TextPaint
import android.text.TextUtils
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.util.Base64
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.therouter.router.Route
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.CenterConfirmDialog
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.AppWidgetPinnedReceiver
import com.dreame.module.widget.constant.ACTION_APPWIDGET_PIN
import com.dreame.module.widget.constant.CODE_OPERATOR_UPDATE
import com.dreame.smartlife.widget.R
import com.dreame.smartlife.widget.databinding.ActivityAppwidgetSelectBinding
import com.hjq.permissions.XXPermissions
import com.zhpan.indicator.enums.IndicatorOrientation
import com.zhpan.indicator.enums.IndicatorSlideMode
import com.zhpan.indicator.enums.IndicatorStyle
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import de.greenrobot.event.EventBus
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Locale

@RequiresApi(Build.VERSION_CODES.O)
private fun AppWidgetProviderInfo.pin(context: Context): Boolean {
    val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
    } else {
        PendingIntent.FLAG_UPDATE_CURRENT
    }
    val successCallback = PendingIntent.getBroadcast(
        context, 0, Intent(context, AppWidgetPinnedReceiver::class.java).setAction(ACTION_APPWIDGET_PIN), flag
    )
    val widgetManager = AppWidgetManager.getInstance(context)
    if (widgetManager.isRequestPinAppWidgetSupported) {
        return widgetManager.requestPinAppWidget(provider, null, successCallback)
    }
    return false
}

@Route(path = RoutPath.WIDGET_APPWIDGET_ADD_BIND)
class AppWidgetSelectActivity : BaseActivity<ActivityAppwidgetSelectBinding>() {

    private val viewModel by lazy { AppWidgetSelectViewModel() }
    private val widgetManager by lazy { AppWidgetManager.getInstance(this) }
    private val centerConfirmDialog by lazy { CenterConfirmDialog(this) }
    private val clickableSpanList = mutableListOf<ClickableSpanWrapper>()

    companion object {
        const val APPWIDGET_TYPE_SMALL = 0
        const val APPWIDGET_TYPE_SMALL1 = 1
        const val APPWIDGET_TYPE_SMALL2 = 2
        const val APPWIDGET_TYPE_MEDIUM = 3
        const val APPWIDGET_TYPE_LARGE = 4
    }

    var isActivityVisiable: Boolean = false

    override fun initData() {
        intent?.let {
            val currentDevice = intent.getParcelableExtra<Device>("data")

            val did = intent.getStringExtra("did") ?: ""
            val deviceName = intent.getStringExtra("deviceName") ?: ""
            val deviceImageUrl = intent.getStringExtra("deviceImageUrl") ?: ""
            LogUtil.i("AppWidgetDeviceProvider", "initData: did:${did} ,deviceName:${deviceName} ,currentDevice: $currentDevice ")
            currentDevice?.let {
                viewModel.dispatchAction(AppWidgetSelectUiAction.InitData(deviceName, deviceImageUrl, did, currentDevice))
            } ?: finish()
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val extras = intent.extras
        LogUtil.i("AppWidgetDeviceProvider", "onNewIntent: $extras")
        val appWidgetId = extras?.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID, -1) ?: -1
        if (appWidgetId != -1) {
            Log.d("sunzhibin", "onNewIntent: -------------- $appWidgetId")
            viewModel.dispatchAction(AppWidgetSelectUiAction.LinkAppWidget(appWidgetId))
        }

    }

    override fun initView() {
        showTipsPrompt()
        binding.ivBack.setOnShakeProofClickListener {
            finish()
        }
        binding.indicatorView
            .setSliderColor(
                getColor(R.color.common_textGray),
                getColor(R.color.common_brandPrimary)
            )
            .setSliderWidth(resources.getDimension(R.dimen.dp_6))
            .setSliderHeight(resources.getDimension(R.dimen.dp_6))
            .setSlideMode(IndicatorSlideMode.WORM)
            .setIndicatorStyle(IndicatorStyle.ROUND_RECT)
            .setupWithViewPager(binding.viewpager2)
        binding.indicatorView.apply {
            val isRtl = TextUtils.getLayoutDirectionFromLocale(Locale.getDefault()) == View.LAYOUT_DIRECTION_RTL
            if (isRtl) {
                setOrientation(IndicatorOrientation.INDICATOR_RTL)
            } else {
                setOrientation(IndicatorOrientation.INDICATOR_HORIZONTAL)
            }
        }
        binding.indicatorView.showIndicatorWhenOneItem(true)

        val currentDevice = viewModel.uiStates.value.currentDevice

        val listOf = currentDevice?.let {
            listOf(currentDevice, currentDevice, currentDevice, currentDevice, currentDevice)
        } ?: emptyList()

        val showVideo = currentDevice?.isShowVideo() ?: false && currentDevice?.hasVideoPermission() ?: false
        val supportFastCommand = currentDevice?.isSupportFastCommand() ?: false

        val adapter = object : BaseQuickAdapter<Device, BaseViewHolder>(R.layout.layout_select_appwidget_small) {
            override fun convert(holder: BaseViewHolder, item: Device) {
                if (holder.layoutPosition == APPWIDGET_TYPE_SMALL) {
                    if (showVideo || supportFastCommand) {
                        if (showVideo && supportFastCommand) {
                            holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = View.VISIBLE
                            holder.getViewOrNull<View>(R.id.fl_device_fast_command)?.visibility = View.VISIBLE
                        } else if (showVideo) {
                            holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = View.VISIBLE
                            holder.getViewOrNull<View>(R.id.fl_device_fast_command)?.visibility = View.GONE
                            holder.getViewOrNull<View>(R.id.fl_device_empty)?.visibility = View.INVISIBLE
                        } else if (supportFastCommand) {
                            holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = View.GONE
                            holder.getViewOrNull<View>(R.id.fl_device_fast_command)?.visibility = View.VISIBLE
                            holder.getViewOrNull<View>(R.id.fl_device_empty)?.visibility = View.INVISIBLE
                        }
                    } else {
                        holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = View.GONE
                    }
                } else if (holder.layoutPosition == APPWIDGET_TYPE_SMALL2) {
                    if (showVideo) {
                        holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = View.VISIBLE
                        holder.getViewOrNull<View>(R.id.fl_device_empty)?.visibility = View.GONE
                    } else {
                        holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = View.GONE
                        holder.getViewOrNull<View>(R.id.fl_device_empty)?.visibility = View.INVISIBLE
                    }
                } else {
                    holder.getViewOrNull<View>(R.id.fl_device_monitor)?.visibility = if (showVideo) View.VISIBLE else View.GONE
                    holder.getViewOrNull<View>(R.id.fl_device_fast_command)?.visibility = if (supportFastCommand) View.VISIBLE else View.GONE
                }
                val deviceName = if (!TextUtils.isEmpty(item.customName)) {
                    item.customName
                } else if (item.deviceInfo != null && !TextUtils.isEmpty(item.deviceInfo?.displayName)) {
                    item.deviceInfo?.displayName
                } else {
                    item.model
                }
                holder.setText(R.id.tv_device_name, deviceName)
                val imageUrl = item.deviceInfo?.mainImage?.imageUrl ?: ""
                holder.getViewOrNull<ImageView>(R.id.iv_device)?.let {
                    ImageLoaderProxy.getInstance().displayImage(context, imageUrl, R.drawable.icon_robot_placeholder, it)
                }
                if (item.online == true) {
                    holder.getViewOrNull<TextView>(R.id.tv_device_status)?.text = getString(R.string.standby)
                    holder.getViewOrNull<TextView>(R.id.tv_battery_value)?.text = (item.battery ?: 0).toString()
                    holder.getViewOrNull<TextView>(R.id.tv_clean_time)?.text = "0"
                    holder.getViewOrNull<TextView>(R.id.tv_clean_area)?.text = "0"
                } else {
                    holder.getViewOrNull<TextView>(R.id.tv_device_status)?.text = "-"
                    holder.getViewOrNull<TextView>(R.id.tv_battery_value)?.text = "-"
                    holder.getViewOrNull<TextView>(R.id.tv_clean_time)?.text = "-"
                    holder.getViewOrNull<TextView>(R.id.tv_clean_area)?.text = "-"
                }
                val listItem = item.fastCommandList?.map {
                    if (it.id < 0) {
                        mapOf("name" to getString(R.string.text_home_fast_command_setting), "img" to R.drawable.icon_widget_right)
                    } else {
                        mapOf("name" to String(Base64.decode(it.name, Base64.DEFAULT)), "img" to R.drawable.icon_start_clean_fast)
                    }
                } ?: listOf(mapOf("name" to getString(R.string.text_home_fast_command_setting), "img" to R.drawable.icon_widget_right))

                holder.getViewOrNull<ListView>(R.id.lv_fast_command)?.apply {
                    adapter = object :
                        SimpleAdapter(
                            context, listItem, R.layout.widget_item_fast_command,
                            arrayOf("name", "img"), intArrayOf(R.id.tv_fast_command, R.id.iv_fast_command)
                        ) {

                    }
                }
            }

            override fun onCreateDefViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder {
                when (viewType) {
                    APPWIDGET_TYPE_SMALL -> {
                        val layoutId = if (showVideo || supportFastCommand) {
                            R.layout.layout_select_appwidget_small_multi
                        } else {
                            R.layout.layout_select_appwidget_small
                        }
                        val view = View.inflate(context, layoutId, null)
                        view.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
                        return createBaseViewHolder(view)
                    }

                    APPWIDGET_TYPE_SMALL1 -> {
                        val layoutId = R.layout.layout_select_appwidget_small_single1
                        val view = View.inflate(context, layoutId, null)
                        view.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
                        return createBaseViewHolder(view)
                    }

                    APPWIDGET_TYPE_SMALL2 -> {
                        val layoutId = R.layout.layout_select_appwidget_small_single2
                        val view = View.inflate(context, layoutId, null)
                        view.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
                        return createBaseViewHolder(view)
                    }

                    APPWIDGET_TYPE_MEDIUM -> {
                        val layoutId = if (showVideo || supportFastCommand) {
                            R.layout.layout_select_appwidget_medium_multi
                        } else {
                            R.layout.layout_select_appwidget_medium
                        }
                        val view = View.inflate(context, layoutId, null)
                        view.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
                        return createBaseViewHolder(view)
                    }

                    APPWIDGET_TYPE_LARGE -> {
                        val layoutId = if (supportFastCommand) {
                            R.layout.layout_select_appwidget_large_multi
                        } else {
                            R.layout.layout_select_appwidget_large
                        }
                        val view = View.inflate(context, layoutId, null)
                        view.layoutParams = ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
                        return createBaseViewHolder(view)
                    }
                }
                return super.onCreateDefViewHolder(parent, viewType)
            }

            override fun getDefItemViewType(position: Int): Int {
                return position
            }

        }
        adapter.setList(listOf)
        binding.viewpager2.adapter = adapter
        binding.indicatorView.notifyDataChanged()

        adapter.setOnItemClickListener { _, _, position ->
            // 添加小组件
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                LogUtil.i("sunzhibin", "pin:  ---------- $position")
                val pinned = findInstalledProvider(position)?.pin(this@AppWidgetSelectActivity) ?: false
                if (pinned) {
                    viewModel.dispatchAction(AppWidgetSelectUiAction.AddAppWidget(position))
                } else {
                    ToastUtils.show(getString(R.string.operate_failed))
                }
            } else {
                ToastUtils.show(getString(R.string.operate_failed))
            }
        }
    }

    private fun showTipsPrompt() {
        val appwidgetAddTips = getString(R.string.text_appwidget_add_tips)
        val indexStr = getString(R.string.text_appwidget_add_tips_open_index)
        val promptSpan = SpannableString(appwidgetAddTips)
        val appwidgetAddTipsCLS = ClickableSpanWrapper(object : ClickableSpan() {
            override fun onClick(view: View) {
                //
                XXPermissions.startPermissionActivity(this@AppWidgetSelectActivity)
            }

            override fun updateDrawState(ds: TextPaint) {
                ds.color =
                    ContextCompat.getColor(this@AppWidgetSelectActivity, R.color.common_warn1)
                ds.isFakeBoldText = true
                ds.isUnderlineText = false
            }
        })
        clickableSpanList.add(appwidgetAddTipsCLS)

        val start = appwidgetAddTips.indexOf(indexStr)
        if (start != -1) {
            promptSpan.setSpan(appwidgetAddTipsCLS, start, start + indexStr.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        }

        binding.tvTips.movementMethod = LinkMovementMethod.getInstance()
        binding.tvTips.highlightColor = ContextCompat.getColor(this@AppWidgetSelectActivity, R.color.colorTransparent)
        binding.tvTips.text = promptSpan
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, AppWidgetSelectUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }

        viewModel.uiEvents.observeEvent(this) { event ->
            when (event) {
                is AppWidgetSelectUiEvent.ShowToast -> ToastUtils.show(event.message)
                is AppWidgetSelectUiEvent.ShowTips -> showTipPop()
                is AppWidgetSelectUiEvent.DismissTips -> dismissTips()
                is AppWidgetSelectUiEvent.DeviceLinked -> {
                    viewModel.uiStates.value.run {
                        if (deviceBitmap != null) {
                            LogUtil.i("sunzhibin", "linkedWidget: $appWidgetId   $did")
                            RouteServiceProvider.getService<IAppWidgetDeviceService>()?.linkedWidget(
                                this@AppWidgetSelectActivity, CODE_OPERATOR_UPDATE, appWidgetId, appWidgetType, did, deviceBitmap, params
                            )
                            LogUtil.i("sunzhibin", "linkedWidget post EventCode.APP_WIDGET_ADD_SUCCESS : $appWidgetId   $did")
                            EventBus.getDefault().post(EventMessage<Int>(EventCode.APP_WIDGET_ADD_SUCCESS))
                            lifecycleScope.launch {
                                ToastUtils.show(getString(R.string.operate_success))
                                delay(1500)
                                finish()
                            }
                        } else ToastUtils.show(getString(R.string.operate_failed))
                    }
                }

                else -> {}
            }
        }
    }

    /**
     * 提示是否有快捷方式权限
     */
    private fun showTipPop() {
        if (centerConfirmDialog.isShowing) {
            centerConfirmDialog.dismiss()
        }
        centerConfirmDialog.show(getString(R.string.desktop_shortcut_tip), getString(R.string.text_goto_open), getString(R.string.cancel), {
            it.dismiss()
            XXPermissions.startPermissionActivity(this)
        }) {
            it.dismiss()
        }
    }

    private fun dismissTips() {
        if (centerConfirmDialog.isShowing) {
            centerConfirmDialog.dismiss()
            return
        }

    }

    override fun onStart() {
        super.onStart()
        isActivityVisiable = true
    }

    override fun onStop() {
        super.onStop()
        isActivityVisiable = false
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun findInstalledProvider(position: Int) = widgetManager.getInstalledProvidersForPackage(packageName, null).find { appWidgetProviderInfo ->
        val minWidth = appWidgetProviderInfo.minWidth
        val minHeight = appWidgetProviderInfo.minHeight
        if (position == APPWIDGET_TYPE_SMALL) {
            minWidth == resources.getDimensionPixelSize(R.dimen.smallMaxWidth) && minHeight == resources.getDimensionPixelSize(R.dimen.smallMaxHeight) && appWidgetProviderInfo.previewImage == R.drawable.ic_widget_small_preview
        } else if (position == APPWIDGET_TYPE_SMALL1) {
            minWidth == resources.getDimensionPixelSize(R.dimen.smallMaxWidth) && minHeight == resources.getDimensionPixelSize(R.dimen.smallMaxHeight) && appWidgetProviderInfo.previewImage == R.drawable.ic_widget_small_preview_single1
        } else if (position == APPWIDGET_TYPE_SMALL2) {
            minWidth == resources.getDimensionPixelSize(R.dimen.smallMaxWidth) && minHeight == resources.getDimensionPixelSize(R.dimen.smallMaxHeight) && appWidgetProviderInfo.previewImage == R.drawable.ic_widget_small_preview_single2

        } else if (position == APPWIDGET_TYPE_MEDIUM) {
            minWidth == resources.getDimensionPixelSize(R.dimen.mediumMaxWidth) && minHeight == resources.getDimensionPixelSize(R.dimen.mediumMaxHeight)

        } else if (position == APPWIDGET_TYPE_LARGE) {
            minWidth == resources.getDimensionPixelSize(R.dimen.largeMaxWidth) && minHeight == resources.getDimensionPixelSize(R.dimen.largeMaxHeight)
        } else {
            false
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        clickableSpanList.forEach {
            it.removeReference()
        }
    }

    private fun Int.dp2px(): Int {
        val density = resources.displayMetrics.density
        return (this * density + 0.5f).toInt()
    }

}