package com.dreame.feature.connect.router.tips

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import android.dreame.module.view.CommonTitleView
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import com.blankj.utilcode.util.LogUtils
import com.blankj.utilcode.util.NetworkUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.config.step.StepData
import com.dreame.smartlife.connect.databinding.ActivityRouterConnectTipsBinding
import com.therouter.TheRouter
import com.therouter.router.Route

/**
 * 连接路由器tips页面
 */
@Route(path = RoutPath.DEVICE_ROUTER_TIPS)
class RouterConnectTipsActivity : BaseActivity<ActivityRouterConnectTipsBinding>() {

    private var routePath = RoutPath.DEVICE_ROUTER_PASSWORD

    private var productInfo: StepData.ProductInfo? = null
    override fun initData() {
        productInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO, StepData.ProductInfo::class.java)
        } else {
            intent.getParcelableExtra(ExtraConstants.EXTRA_PRODUCT_INFO)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        NetworkUtils.registerNetworkStatusChangedListener(callback)
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.EnterPage.code,
            hashCode(),
            "","",
            int1 = 0,
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.UnConnectWifiPage.code
        )
    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code,
            PairNetEventCode.ExitPage.code,
            hashCode(),
            "","",
            int1 = (aliveTime / 1000).toInt(),
            str1 = BuriedConnectHelper.currentSessionID(),
            str2 = PairNetPageId.UnConnectWifiPage.code
        )
    }

    override fun initView() {
        // 是否传递了path
        routePath = intent.getStringExtra("routePath") ?: routePath

        binding.tvConfirm.setOnShakeProofClickListener {
            //  跳转设置Wi-Fi页
            startActivity(Intent(Settings.ACTION_WIFI_SETTINGS))
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
    }

    override fun onDestroy() {
        super.onDestroy()
        NetworkUtils.unregisterNetworkStatusChangedListener(callback);
    }

    val callback = object : NetworkUtils.OnNetworkStatusChangedListener {
        override fun onConnected(networkType: NetworkUtils.NetworkType) {
            if (networkType == NetworkUtils.NetworkType.NETWORK_WIFI) {
                TheRouter.build(routePath)
                    .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                    .navigation()
                finish()
            }
        }

        override fun onDisconnected() {

        }
    }

    private fun isConnectedWifi() {
        if (NetworkUtils.isWifiConnected()) {
            TheRouter.build(routePath)
                .withParcelable(ExtraConstants.EXTRA_PRODUCT_INFO, productInfo)
                .navigation()
            finish()
        } else {
            LogUtils.d("no connect wifi ")
        }
    }

    override fun onResume() {
        super.onResume()
        isConnectedWifi()
    }
}