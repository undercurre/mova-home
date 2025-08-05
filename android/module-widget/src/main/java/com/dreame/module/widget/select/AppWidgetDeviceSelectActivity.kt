package com.dreame.module.widget.select

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.dp
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.dreame.module.view.GridSpaceItemDecoration
import android.os.Bundle
import android.os.PersistableBundle
import android.view.View
import androidx.activity.viewModels
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.res.CenterConfirmDialog
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.module.service.appwidget.IAppWidgetDeviceService
import com.dreame.module.widget.AppWidgetCacheHelper
import com.dreame.module.widget.constant.ACTION_APPWIDGET_CHANGE_DEVICE
import com.dreame.module.widget.constant.CODE_OPERATOR_UPDATE
import com.dreame.module.widget.constant.KEY_APPWIDGET_ACTION
import com.dreame.module.widget.constant.KEY_APPWIDGET_ID
import com.dreame.module.widget.constant.KEY_APPWIDGET_TYPE
import com.dreame.module.widget.select.widget.AppWidgetSelectActivity
import com.dreame.smartlife.widget.R
import com.dreame.smartlife.widget.databinding.ActivityAppwidgetDeviceSelectBinding
import com.hjq.permissions.XXPermissions
import com.scwang.smartrefresh.layout.constant.RefreshState
import com.therouter.router.Route
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import de.greenrobot.event.EventBus
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.greenrobot.eventbus.Subscribe

@Route(path = RoutPath.WIDGET_APPWIDGET_SELECT)
class AppWidgetDeviceSelectActivity : BaseActivity<ActivityAppwidgetDeviceSelectBinding>() {

    private val selectAdapter by lazy { DeviceSelectAdapter() }
    private val viewModel by viewModels<AppWidgetDeviceSelectViewModel>()
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        val content = intent.extras?.keySet()?.joinToString { key ->
            val value = intent.extras?.get(key)
            "$key : $value"
        }
        LogUtil.i("sunzhibin AppWidgetDeviceSelectActivity onCreate: $content")
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        val appWidgetId = intent?.getIntExtra(KEY_APPWIDGET_ID, -1) ?: -1
        val appWidgetType = intent?.getIntExtra(KEY_APPWIDGET_TYPE, -1) ?: -1
        val action = intent?.getStringExtra(KEY_APPWIDGET_ACTION)
        val isSelectOrBind = intent?.getBooleanExtra("isSelectOrBind", false) ?: false
        val appWidgetIds = getAppWidgetIds()
        viewModel.dispatchAction(
            AppWidgetDeviceSelectUiAction.InitData(
                appWidgetId,
                appWidgetType,
                appWidgetIds,
                isSelectOrBind,
                ACTION_APPWIDGET_CHANGE_DEVICE.equals(action)
            )
        )
        viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.RefreshDevice)
        LogUtil.i("sunzhibin", "AppWidgetDeviceSelectActivity onNewIntent: appWidgetId: $appWidgetId ,appWidgetType: $appWidgetType")
    }

    override fun initView() {
        val appWidgetId = intent.getIntExtra(KEY_APPWIDGET_ID, -1)
        val appWidgetType = intent?.getIntExtra(KEY_APPWIDGET_TYPE, -1) ?: -1
        val isSelectOrBind = intent?.getBooleanExtra("isSelectOrBind", false) ?: false
        val appWidgetIds = getAppWidgetIds()
        LogUtil.i("sunzhibin", "AppWidgetDeviceSelectActivity initView appWidgetId:$appWidgetId ,appWidgetType:$appWidgetType ,isSelectOrBind:$isSelectOrBind ")
        viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.InitData(appWidgetId, appWidgetType, appWidgetIds, isSelectOrBind))
        viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.RefreshDevice)
        if (appWidgetId == -1 && appWidgetType == -1) {
            if (!AppWidgetCacheHelper.needTipsShowFlag()) {
                showTipPop()
            }
        }
        binding.rvDeviceList.layoutManager = GridLayoutManager(this, 2)
        binding.rvDeviceList.setHasFixedSize(true)
        binding.rvDeviceList.adapter = selectAdapter
        binding.rvDeviceList.addItemDecoration(GridSpaceItemDecoration(2, 16.dp(), 16.dp(), false, 0))
        binding.ivBack.setOnShakeProofClickListener {
            finish()
        }
        binding.btnBind.setOnShakeProofClickListener {
            // 绑定
            if (viewModel.uiStates.value.isSelectOrBind) {
                viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.DeviceSelect)
            } else {
                viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.DeviceLinked)
            }
        }

        binding.srlRefresh.setOnRefreshListener {
            viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.RefreshDevice)
        }
        selectAdapter.setOnItemClickListener { adapter, view, position ->
            val item = selectAdapter.getItem(position)
            if (!item.isUsed) {
                viewModel.dispatchAction(AppWidgetDeviceSelectUiAction.DeviceSelected(item.did))
            }
        }
    }

    override fun observe() {
        viewModel.uiStates.observeState(
            this,
            AppWidgetDeviceSelectUiState::deviceList,
            AppWidgetDeviceSelectUiState::enable
        ) { list, enable ->
            list?.let {
                selectAdapter.setNewInstance(it.toMutableList())
            }
            if (list == null || list.isEmpty()) {
                binding.btnBind.text = getString(R.string.select_device)
                binding.tvLinkTips.visibility = View.VISIBLE
                binding.srlRefresh.visibility = View.GONE
                binding.btnBind.isEnabled = true
            } else {
                binding.btnBind.text = getString(R.string.widget_linked_confirm)
                binding.tvLinkTips.visibility = View.GONE
                binding.srlRefresh.visibility = View.VISIBLE
                binding.btnBind.isEnabled = enable
            }
        }

        viewModel.uiStates.observeState(this, AppWidgetDeviceSelectUiState::did) {
            viewModel.uiStates.value.deviceList?.let {
                selectAdapter.setNewInstance(it.toMutableList())
            }
        }
        viewModel.uiStates.observeState(this, AppWidgetDeviceSelectUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(this, AppWidgetDeviceSelectUiState::isRefresh) {
            if (!it && binding.srlRefresh.state == RefreshState.Refreshing) {
                binding.srlRefresh.finishRefresh()
            }
        }

        viewModel.uiEvents.observeEvent(this) { action ->
            when (action) {
                is AppWidgetDeviceSelectUiEvent.ShowToast -> ToastUtils.show(action.message)
                is AppWidgetDeviceSelectUiEvent.DeviceAdd -> {
                    /// 跳转到二维码扫描页面
                    val intent = RouteServiceProvider.getService<IFlutterBridgeService>()
                        ?.openSubFlutter(this, "/qr_scan")
                    intent?.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    finish()
                }

                is AppWidgetDeviceSelectUiEvent.SignIn -> {
                    RouteServiceProvider.getService<IFlutterBridgeService>()?.gotoFlutterPluginActivity()
                }

                is AppWidgetDeviceSelectUiEvent.DeviceLinkedSuccess -> {
                    viewModel.uiStates.value.run {
                        if (deviceBitmap != null) {
                            LogUtil.i("sunzhibin", "linkedWidget: $appWidgetId   $did  $appWidgetType")
                            RouteServiceProvider.getService<IAppWidgetDeviceService>()?.linkedWidget(
                                this@AppWidgetDeviceSelectActivity,
                                CODE_OPERATOR_UPDATE,
                                appWidgetId,
                                appWidgetType,
                                did,
                                deviceBitmap,
                                params
                            )
                            lifecycleScope.launch {
                                ToastUtils.show(getString(R.string.operate_success))
                                delay(1500)
                                finish()
                            }
                        } else ToastUtils.show(getString(R.string.operate_failed))
                    }
                }

                is AppWidgetDeviceSelectUiEvent.DeviceSelectSuccess -> {
                    viewModel.uiStates.value.run {
                        currentDevice?.let {
                            startActivity(
                                Intent(this@AppWidgetDeviceSelectActivity, AppWidgetSelectActivity::class.java)
                                    .putExtra("data", currentDevice)
                                    .putExtra("deviceName", deviceName)
                                    .putExtra("deviceImageUrl", deviceImageUrl)
                                    .putExtra("did", did)
                            )
                        }
                    }
                }
            }
        }
    }

    override fun initData() {

    }

    private fun getAppWidgetIds(): List<Int> {
        return RouteServiceProvider.getService<IAppWidgetDeviceService>()?.getAppWidgetIds(this)?.map {
            it.second.toList()
        }?.flatten() ?: emptyList()
    }

    private fun showTipPop() {
        CenterConfirmDialog(this).show(
            getString(R.string.text_appwidget_add_tips),
            getString(R.string.text_goto_open), getString(R.string.cancel), {
                it.dismiss()
                XXPermissions.startPermissionActivity(this)
            }) {
            it.dismiss()
        }
        AppWidgetCacheHelper.saveTipsShowFlag()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        EventBus.getDefault().register(this)
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBus.getDefault().unregister(this)
    }

    @Subscribe
    fun onEvent(event: EventMessage<Int>) {
        if (event.code == EventCode.APP_WIDGET_ADD_SUCCESS) {
            LogUtil.i("sunzhibin", "onEvent: APP_WIDGET_ADD_SUCCESS")
            finish()
        }
    }
}