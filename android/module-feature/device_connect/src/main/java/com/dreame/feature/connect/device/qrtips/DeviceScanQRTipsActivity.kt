package com.dreame.feature.connect.device.qrtips

import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.manager.LanguageManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.view.CommonTitleView
import android.os.Build
import androidx.activity.viewModels
import com.therouter.router.Route
import com.therouter.TheRouter
import com.blankj.utilcode.util.RomUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityDeviceScanQrTipsBinding

/**
 * 扫二维码配网 操作引导
 *
 */
@Route(path = RoutPath.DEVICE_QR_CONNECT_TIPS)
class DeviceScanQRTipsActivity : BaseActivity<ActivityDeviceScanQrTipsBinding>() {
    private val viewModel by viewModels<DeviceScanQRTipsViewModel>()
    override fun initData() {
        val productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java)
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
        viewModel.dispatchAction(DeviceScanQRTipsUiAction.InitData(productInfo))
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
            str2 = PairNetPageId.QRConnectGuidePage.code
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
            str2 = PairNetPageId.QRConnectGuidePage.code
        )
    }

    override fun initView() {
        binding.indicator.setIndex(4)

        binding.tvConfirm.setOnShakeProofClickListener {
            TheRouter.build(RoutPath.DEVICE_CONNECT)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, viewModel.uiStates.value.productInfo)
                .navigation()
            finish()
        }
        val language = LanguageManager.getInstance().getLangTag(this)
        val model = viewModel.uiStates.value.productInfo?.productModel ?: ""
        val brand = Build.BRAND
        val manufacturer = Build.MANUFACTURER
        val isOppo = if (brand.contains("realme") || manufacturer.contains("realme")) {
            true
        } else {
            RomUtils.isOppo() || RomUtils.isOneplus()
        }
        if ("zh" == language) {
            if (isOppo) {
                if(model.startsWith("dreame")){
                    binding.ivDevice.setAnimation(R.raw.dreame_qr_connect_tips_oppo)
                }else{
                    binding.ivDevice.setAnimation(R.raw.qr_connect_tips_oppo)
                }
            } else {
                if(model.startsWith("dreame")){
                    binding.ivDevice.setAnimation(R.raw.dreame_qr_connect_tips)
                }else{
                    binding.ivDevice.setAnimation(R.raw.qr_connect_tips)
                }
            }
        } else {
            if (isOppo) {
                if(model.startsWith("dreame")){
                    binding.ivDevice.setAnimation(R.raw.dreame_qr_connect_tips_en_oppo)
                }else{
                    binding.ivDevice.setAnimation(R.raw.qr_connect_tips_en_oppo)
                }
            } else {
                if(model.startsWith("dreame")){
                    binding.ivDevice.setAnimation(R.raw.dreame_qr_connect_tips_en)
                }else{
                    binding.ivDevice.setAnimation(R.raw.qr_connect_tips_en)
                }
            }
        }
        binding.ivDevice.playAnimation()
    }

    override fun initListener() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        binding.ivPlay.setOnShakeProofClickListener {
            if (!binding.ivDevice.isAnimating) {
                binding.ivDevice.playAnimation()
            }
        }


    }

    override fun observe() {

    }

}