package com.dreame.feature.connect.device.mower.trigger

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.toast.ToastUtils
import android.dreame.module.view.CommonTitleView
import android.os.Bundle
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.utils.permission.CheckBlePermissionDelegate
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityBleDevcieTriggerBinding
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState


/**
 * 触发机器热点
 */
@Route(path = RoutPath.DEVICE_TRIGGER_BLE)
class BleDeviceTriggerActivity : BaseActivity<ActivityBleDevcieTriggerBinding>() {
    val viewModel by viewModels<BleDeviceTriggerViewModel>()
    private val checkBlePermissionDelegate by lazy { CheckBlePermissionDelegate(this) }
    override fun onCreate(savedInstanceState: Bundle?) {
        checkBlePermissionDelegate.init()
        super.onCreate(savedInstanceState)
    }

    override fun initData() {
        val language = LanguageManager.getInstance().getLangTag(this)
        val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        viewModel.dispatchAction(BleDeviceTriggerUiAction.InitData(language, productInfo))
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.TriggerWifiApPage.code
        )
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.TriggerWifiApPage.code
        )
    }

    override fun onRestart() {
        super.onRestart()
        viewModel.dispatchAction(BleDeviceTriggerUiAction.NewIntent)
    }

    override fun initView() {
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                TheRouter.build(RoutPath.PRODUCT_CONNECT_PREPARE_BLE)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                    .withFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP  or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    .navigation()
                finish()
            }

            override fun onRightIconClick() {
                TheRouter.build(RoutPath.PRODUCT_CONNECT_PREPARE_BLE)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                    .withBoolean(ExtraConstants.EXTRA_FEATURE, false)
                    .navigation()
            }
        })
        binding.ctvStatus.setOnCheckedChangeListener { buttonView, isChecked ->
            viewModel.dispatchAction(BleDeviceTriggerUiAction.ClickReset(isChecked, false))
        }
        binding.tvConfirm.setOnShakeProofClickListener {
            if (!checkBlePermissionDelegate.showBleOpenDialog()) {
                return@setOnShakeProofClickListener
            }
            if (!checkBlePermissionDelegate.isHasBlePermission()) {
                checkBlePermissionDelegate.requestPermission {
                    if (it) {
                        checkBleGspLocation()
                    }
                }
            } else {
                checkBleGspLocation()
            }
        }
    }

    private fun checkBleGspLocation() {
        if (!checkBlePermissionDelegate.bleGspLocationOpen()) {
            checkBlePermissionDelegate.openGspLocationOpen {
                if (it) {
                    viewModel.dispatchAction(BleDeviceTriggerUiAction.ClickGotoNext)
                }
            }
        } else {
            viewModel.dispatchAction(BleDeviceTriggerUiAction.ClickGotoNext)
        }
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, BleDeviceTriggerUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(
            this,
            BleDeviceTriggerUiState::isReset,
            BleDeviceTriggerUiState::isSettingView
        ) { isReset, isSettingView ->
            binding.tvConfirm.isEnabled = isReset
            if (isSettingView) {
                binding.ctvStatus.isChecked = isReset
            }
        }
        viewModel.uiStates.observeState(this, BleDeviceTriggerUiState::productImageUrl) {
            ImageLoaderProxy.getInstance()
                .displayImage(this, it, R.drawable.ic_mower_power_on, R.drawable.ic_mower_power_on, binding.ivDevice)
        }
        viewModel.uiStates.observeState(
            this,
            BleDeviceTriggerUiState::productTitle,
            BleDeviceTriggerUiState::productIntro
        ) { title, intro ->
            if (intro?.isNotBlank() == true) {
                binding.tvContent.text = intro
            }
        }

        viewModel.uiEvents.observeEvent(this) { action ->
            when (action) {
                is BleDeviceTriggerUiEvent.ShowToast -> {
                    ToastUtils.show(action.message)
                }

                is BleDeviceTriggerUiEvent.GotoNext -> {
                    // 扫码配网
                    val isQrScan = viewModel.uiStates.value.productInfo?.enterOrigin == ParameterConstants.ORIGIN_QR
                    val isScan = viewModel.uiStates.value.productInfo?.enterOrigin == ParameterConstants.ORIGIN_SCAN
                    // 二维码配网
                    val isQrCode = viewModel.uiStates.value.productInfo?.extendScType?.contains(ScanType.QR_CODE_V2) ?: false
                    // mcu 配网
                    val isMcu = viewModel.uiStates.value.productInfo?.extendScType?.contains(ScanType.MCU) ?: false
                    TheRouter.build(RoutPath.DEVICE_CONNECT_BLE)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .withInt(ExtraConstants.EXTRA_STEP, StepId.STEP_DEVICE_SCAN_BLE)
                        .navigation()
                }

                else -> {}
            }
        }
    }

}