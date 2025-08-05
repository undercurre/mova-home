package com.dreame.smartlife.ui.activity

import android.dreame.module.RoutPath
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.trace.PairNetPageId
import com.therouter.router.Route
import com.dreame.feature.connect.trace.BuriedConnectHelper

@Route(path = RoutPath.WEBVIEW_CONNECT_GUIDE)
open class ConnectGuideWebViewActivity : WebViewActivity() {

    private var sessionID: String? = null
    override fun initData() {
        super.initData()
        sessionID = intent.getStringExtra("sessionID")
    }

    override fun onStart() {
        super.onStart()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterPage.code, hashCode(),
            "", "",
            int1 = 0, str1 = BuriedConnectHelper.currentSessionID(), str2 = PairNetPageId.QRScanPage.code
        )

    }

    override fun onStop() {
        super.onStop()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterPage.code, hashCode(),
            "", "",
            int1 = (aliveTime / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID(), str2 = PairNetPageId.QRScanPage.code
        )

    }

}