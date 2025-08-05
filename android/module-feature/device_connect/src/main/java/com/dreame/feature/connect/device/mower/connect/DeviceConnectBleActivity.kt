package com.dreame.feature.connect.device.mower.connect

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.LogUtil
import android.dreame.module.view.CommonTitleView
import android.os.Build
import android.os.Message
import android.util.Log
import androidx.activity.viewModels
import com.therouter.router.Route
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.device.mower.connect.uiconfig.BaseUiConfig
import com.dreame.feature.connect.device.mower.connect.uiconfig.BleStepConnectUiConfig
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.step.*
import com.dreame.smartlife.connect.databinding.ActivityDeviceConnectBleBinding
import com.zj.mvi.core.observeState

/**
 * 蓝牙设备配网页面
 *
 */
@Route(path = RoutPath.DEVICE_CONNECT_BLE)
class DeviceConnectBleActivity : BaseActivity<ActivityDeviceConnectBleBinding>(),
    WeakHandler.MessageHandleCallback {
    private val viewModel by viewModels<DeviceConnectBleViewModel>()
    val handler by lazy { WeakHandler(this) }
    private lateinit var uiConfig: BaseUiConfig

    override fun initData() {
        handleInitData(intent)
        uiConfig.initData()
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        uiConfig.handleBackPressed()
    }

    private fun handleInitData(intent: Intent) {
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java)
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        uiConfig = BleStepConnectUiConfig(this, viewModel, binding, handler)
        val stepId = intent.getIntExtra(ExtraConstants.EXTRA_STEP, -1)
        val stepResult = intent.getBooleanExtra(ExtraConstants.EXTRA_STEP_RESULT, false)
        val pairQRKey = intent.getStringExtra(ExtraConstants.EXTRA_QR_PAIR_KEY)
        val pairClickTime = intent.getLongExtra(ExtraConstants.EXTRA_QR_PAIR_DI, 0)
        val did = intent.getStringExtra(ExtraConstants.EXTRA_PARAM_DID) ?: ""
        viewModel.dispatchAction(DeviceConnectBleUiAction.InitData(productInfo, did, stepId, stepResult, pairQRKey))
        viewModel.dispatchAction(DeviceConnectBleUiAction.QrNetWaitCostTime(false, false, pairClickTime))
        StepData.init(productInfo, did, stepId, pairQRKey)
    }

    override fun initView() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                uiConfig.handleBackPressed()
            }

            override fun onRightIconClick() {
                uiConfig.onRightIconClick()
            }
        })
        uiConfig.initView()
        SmartStepHelper.instance.startFirstPage(this, handler)
    }

    override fun initListener() {
        uiConfig.initListener()

    }

    override fun observe() {
        viewModel.uiStates.observeState(this, DeviceConnectBleUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        uiConfig.observe()
    }

    override fun onStart() {
        super.onStart()
        Log.d("connectActivity", "onStart: $this")
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterPage.code, hashCode(),
            StepData.deviceId,StepData.deviceModel(),
            int1 = 0, str1 = BuriedConnectHelper.currentSessionID(), str2 = PairNetPageId.PairDeviceProcessPage.code
        )
    }

    override fun onStop() {
        super.onStop()
        LogUtil.d("connectActivity", "onStop: $isFinishing  $this")
        if (isFinishing) {
            onStepDestroy()
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.ExitPage.code, hashCode(),
            StepData.deviceId,StepData.deviceModel(),
            int1 = (aliveTime / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID(), str2 = PairNetPageId.PairDeviceProcessPage.code
        )
    }

    override fun onDestroy() {
        onStepDestroy()
        super.onDestroy()
        LogUtil.d("connectActivity", "onActivityDestroy: ${isFinishing}  $this")
    }

    /**
     * 在destroy的时候，需要调用SmartStepHelper.instance.onDestroy()
     */

    fun onStepDestroy() {
        SmartStepHelper.instance.onDestroy()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        SmartStepHelper.instance.onActivityResult(requestCode, resultCode, data)
        uiConfig.onActivityResult(requestCode, resultCode, data)
    }

    override fun handleMessage(message: Message) {
        //
        uiConfig.handleMessage(message)
    }

    fun nextUiConfig(newUiConfig: BaseUiConfig) {
        this.uiConfig = newUiConfig
    }


}