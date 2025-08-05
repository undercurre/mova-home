package com.dreame.feature.connect.device.qrnet

import android.content.Intent
import android.database.ContentObserver
import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.LogUtil
import android.dreame.module.view.CommonTitleView
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.provider.Settings
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.blankj.utilcode.util.BrightnessUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.views.ScaleQrCodeDialog
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.databinding.ActivityDeviceQrNetBinding
import android.dreame.module.util.toast.ToastUtils
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState


/**
 * 二维码配网页面
 */
@Route(path = RoutPath.DEVICE_QR_NET)
class DeviceQrNetActivity : BaseActivity<ActivityDeviceQrNetBinding>() {

    private val viewModel by viewModels<DeviceQrNetViewModel>()
    private val scaleQrCodeDialog by lazy { ScaleQrCodeDialog(this) }

    override fun initData() {
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java)
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        val targetWifiName = productInfo?.targetWifiName
        val targetWifiPwd = productInfo?.targetWifiPwd
        val langTag = LanguageManager.getInstance().getLangTag(this)
        viewModel.dispatchAction(
            DeviceQrNetUiAction.InitData(
                productInfo, langTag,
                targetWifiName ?: "", targetWifiPwd ?: ""
            )
        )

    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java)
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        val targetWifiName = productInfo?.targetWifiName
        val targetWifiPwd = productInfo?.targetWifiPwd
        val langTag = LanguageManager.getInstance().getLangTag(this)
        viewModel.dispatchAction(
            DeviceQrNetUiAction.InitData(
                productInfo, langTag,
                targetWifiName ?: "", targetWifiPwd ?: ""
            )
        )
    }

    override fun initView() {
        // 调整页面的亮度
//        BrightnessUtils.setWindowBrightness(window, (255 * 0.4f).toInt())
        binding.indicator.setIndex(4)
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        binding.ctvStatus.setOnCheckedChangeListener { buttonView, isChecked ->
            binding.tvConfirm.isEnabled = isChecked
        }

        binding.ivDevice.setOnShakeProofClickListener {
            // 放大二维码
            showScaleQRDialog()
        }
        binding.tvChangeAp.setOnShakeProofClickListener {
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code,
                PairNetEventCode.TogglePairType.code,
                hashCode(),
                "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
                int1 = 0,
                str1 = BuriedConnectHelper.currentSessionID()
            )
            TheRouter.build(RoutPath.DEVICE_SCAN_NEARYBY)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                .navigation()
        }
        binding.tvConfirm.setOnShakeProofClickListener {
            viewModel.dispatchAction(DeviceQrNetUiAction.GotoNext(false, clickTime = SystemClock.elapsedRealtime()))
        }
    }

    private fun showScaleQRDialog() {
        viewModel.uiStates.value.qrcodeBitmap?.let {
            scaleQrCodeDialog.setImageView(it)
                .showPopupWindow()
        }
    }

    override fun observe() {

        viewModel.uiStates.observeState(this, DeviceQrNetUiState::qrcodeBitmap) { bitmap ->
            if (bitmap != null) {
                binding.ivDevice.setImageBitmap(bitmap)

                if (scaleQrCodeDialog.isShowing) {
                    scaleQrCodeDialog.setImageView(bitmap)
                }
            } else {
                // error
            }
        }
        viewModel.uiStates.observeState(this, DeviceQrNetUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiEvents.observeEvent(this) { event ->
            when (event) {
                is DeviceQrNetUiEvent.ShowToast -> {
                    ToastUtils.show(event.message)
                }

                is DeviceQrNetUiEvent.QueryDomainError -> {

                }

                is DeviceQrNetUiEvent.CreateQRCodeError -> {

                }

                is DeviceQrNetUiEvent.GotoNext -> {
                    LogUtil.d("配网码配网耗时：--------- start --------- ")
                    TheRouter.build(RoutPath.DEVICE_CONNECT)
                        .withInt(ExtraConstants.EXTRA_STEP, StepId.STEP_QR_NET_PAIR)
                        .withBoolean(ExtraConstants.EXTRA_STEP_RESULT, event.bindSuccess)
                        .withString(ExtraConstants.EXTRA_PARAM_DID, event.did)
                        .withString(ExtraConstants.EXTRA_QR_PAIR_KEY, viewModel.uiStates.value.pairQRKey)
                        .withLong(ExtraConstants.EXTRA_QR_PAIR_DI, event.clickTime)
                        .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                        .navigation()
                    finish()
                }

                else -> {}
            }
        }
    }

    override fun onStart() {
        super.onStart()
        viewModel.dispatchAction(DeviceQrNetUiAction.OnStart)
        registerBrightnessObserer()

        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.GenerateQRPage.code
        )
    }

    override fun onStop() {
        super.onStop()
        viewModel.dispatchAction(DeviceQrNetUiAction.OnStop)
        unregisterBrightnessObserer()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.GenerateQRPage.code
        )
    }


    private val brightNessContentObserver = object : ContentObserver(Handler(Looper.getMainLooper())) {
        override fun onChange(selfChange: Boolean) {
            super.onChange(selfChange)
            val brightNess = Settings.System.getInt(contentResolver, Settings.System.SCREEN_BRIGHTNESS)
            BrightnessUtils.setWindowBrightness(window, brightNess)
        }
    }

    private fun registerBrightnessObserer() {
        contentResolver.registerContentObserver(Settings.System.getUriFor(Settings.System.SCREEN_BRIGHTNESS), true, brightNessContentObserver)
    }

    private fun unregisterBrightnessObserer() {
        contentResolver.unregisterContentObserver(brightNessContentObserver)
    }

}