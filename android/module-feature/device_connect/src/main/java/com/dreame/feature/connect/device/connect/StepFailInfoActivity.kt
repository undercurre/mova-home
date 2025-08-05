package com.dreame.feature.connect.device.connect

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.manager.AreaManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.util.okhttp3.convert.ErrorCode
import android.dreame.module.view.CommonTitleView
import android.os.Build
import android.os.SystemClock
import android.text.Spannable
import android.text.SpannableString
import android.text.SpannableStringBuilder
import android.text.style.ForegroundColorSpan
import android.text.style.ImageSpan
import android.text.style.UnderlineSpan
import android.view.View
import androidx.core.content.ContextCompat
import com.therouter.router.Route
import com.therouter.TheRouter
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.service.help.IHelpService
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityStepFailInfoBinding


@Route(path = RoutPath.DEVICE_STEP_FAIL_INFO)
class StepFailInfoActivity : BaseActivity<ActivityStepFailInfoBinding>() {
    private var time = 0L
    var productInfo: StepData.ProductInfo? = null

    private val adapter by lazy {
        object : BaseQuickAdapter<String, BaseViewHolder>(R.layout.item_step_fail_info) {
            override fun convert(holder: BaseViewHolder, item: String) {
                holder.setText(R.id.tv_info, item)
            }
        }
    }

    override fun initData() {
        val step = intent.getIntExtra("step", 2)
        productInfo = intent.getParcelableExtra<StepData.ProductInfo>(ExtraConstants.EXTRA_PRODUCT_INFO)
        binding.recyclerView.adapter = adapter
        if (step == 2) {
            val arr2 = resources.getStringArray(R.array.network_config_error_step2)
            adapter.setNewInstance(arr2.toMutableList())
        } else if (step == 3) {
            val arr3 = resources.getStringArray(R.array.network_config_error_step3)
            adapter.setNewInstance(arr3.toMutableList())
        } else if (step == 100) {
            val arr3 = resources.getStringArray(R.array.network_config_error_step_mower)
            adapter.setNewInstance(arr3.toMutableList())
        } else if (step == ErrorCode.CODE_PRODUCT_HAS_OWNER) {
            val arr3 = resources.getStringArray(R.array.ble_bind_error_has_own)
            adapter.setNewInstance(arr3.toMutableList())
        }
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            StepData.deviceId, StepData.deviceModel(),
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ViewPairDeviceFailedPage.code
        )
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            StepData.deviceId, StepData.deviceModel(),
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.ViewPairDeviceFailedPage.code
        )
    }

    override fun initView() {
        val header = View.inflate(this, R.layout.layout_step_fail_info_header, null)
        adapter.addHeaderView(header)
        val countryCode = AreaManager.getCountryCode()
        if ("de".equals(countryCode, true)
            || "cn".equals(countryCode, true)
        ) {
            binding.tvFailReason.visibility = View.VISIBLE
            val noDeviceContactCustomerService = getString(R.string.searching_no_devices_contact_customer_service) + " "
            val contactCustomerService = getString(R.string.text_contact_cs)

            val startIndex = noDeviceContactCustomerService.indexOf(contactCustomerService)
            val endIndex = startIndex + contactCustomerService.length

            val spannableString = SpannableStringBuilder(noDeviceContactCustomerService).apply {
                setSpan(UnderlineSpan(), startIndex, endIndex, SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE)
                setSpan(
                    ForegroundColorSpan(ContextCompat.getColor(this@StepFailInfoActivity, R.color.common_text_brand)),
                    startIndex,
                    endIndex,
                    SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                ContextCompat.getDrawable(this@StepFailInfoActivity, R.drawable.icon_small_arrow_gold)?.let {
                    it.setBounds(0, 0, it.intrinsicWidth, it.intrinsicHeight)
                    val imageSpan = ImageSpan(it, ImageSpan.ALIGN_BASELINE);
                    setSpan(imageSpan, this.length - 1, this.length, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                }

            }
            binding.tvFailReason.text = spannableString
        } else {
            binding.tvFailReason.visibility = View.GONE
        }

        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        binding.btnRetry.setOnShakeProofClickListener {
            val step = intent.getIntExtra("step", 0)
            if (step == 100) {
                TheRouter.build(RoutPath.DEVICE_TRIGGER_BLE)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                    .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP  or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    .navigation()
            } else {
                TheRouter.build(RoutPath.DEVICE_ROUTER_PASSWORD)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                    .withFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    .navigation()
            }

            finish()
        }
        binding.tvFailReason.setOnShakeProofClickListener {
            RouteServiceProvider.getService<IHelpService>()?.openCustomerServiceChat(this, countryCode)
        }
        time = SystemClock.elapsedRealtime();
    }

    override fun observe() {
    }
}