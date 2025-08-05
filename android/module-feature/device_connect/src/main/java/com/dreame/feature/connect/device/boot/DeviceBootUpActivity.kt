package com.dreame.feature.connect.device.boot

import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.view.CommonTitleView
import android.view.Gravity
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDevcieBootUpBinding
import com.zj.mvi.core.observeState

/**
 * 开启设备
 *
 */
@Route(path = RoutPath.DEVICE_BOOT_UP)
class DeviceBootUpActivity : BaseActivity<ActivityDevcieBootUpBinding>() {
    private val viewModel by viewModels<DeviceBootUpViewModel>()
    val WJ_BOT_LIST = arrayOf("dreame.vacuum.r2380r", "dreame.vacuum.r2380")

    override fun initData() {
        val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        viewModel.dispatchAction(DeviceBootUpUiAction.InitData(productInfo))
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterPage.code, hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = 0, str1 = BuriedConnectHelper.currentSessionID(), str2 = PairNetPageId.TurnOnDevicePage.code
        )
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.ExitPage.code, hashCode(),
            "", viewModel.uiStates.value.productInfo?.realProductModel ?: viewModel.uiStates.value.productInfo?.productModel ?: "",
            int1 = (aliveTime / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID(), str2 = PairNetPageId.TurnOnDevicePage.code
        )
    }

    override fun initView() {
        val productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        if (WJ_BOT_LIST.contains(productInfo?.realProductModel)) {
            binding.ivDevice.setImageResource(R.drawable.icon_wangjia_boot_up)
            binding.tvContent.gravity = Gravity.START
            binding.tvContent2.gravity = Gravity.START
            binding.tvContent.setText(R.string.text_turn_on_desc_wj_1)
            binding.tvContent2.setText(R.string.text_turn_on_desc_wj_2)
            binding.tvContent3.visibility = android.view.View.VISIBLE
            binding.tvContent4.visibility = android.view.View.VISIBLE
        } else {
            binding.tvContent.gravity = Gravity.CENTER
            binding.tvContent2.gravity = Gravity.CENTER
            binding.tvContent3.visibility = android.view.View.GONE
            binding.tvContent4.visibility = android.view.View.GONE
            binding.tvContent.setText(R.string.text_turn_on_desc_1)
            binding.tvContent2.setText(R.string.text_turn_on_desc_2)
            binding.ivDevice.setImageResource(R.drawable.ic_placeholder_device_boot)
        }
        binding.indicator.setIndex(2)

        binding.ctvStatus.setOnCheckedChangeListener { buttonView, isChecked ->
            binding.tvConfirm.isEnabled = isChecked
        }

        binding.tvConfirm.setOnShakeProofClickListener {
            val productInfo1 = viewModel.uiStates.value.productInfo
            val path = if (productInfo1?.productModel?.contains(".toothbrush.") == true
                || productInfo1?.extendScType?.contains(ScanType.MCU) == true
            ) {
                RoutPath.DEVICE_CONNECT
            } else {
                RoutPath.DEVICE_TRIGGER_AP
            }
            TheRouter.build(path)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo1)
                .navigation()
        }
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, DeviceBootUpUiState::filePath) {
            if (it.isNullOrEmpty()) return@observeState
            ImageLoaderProxy.getInstance().displayImage(this, it, binding.ivDevice)
        }
    }
}