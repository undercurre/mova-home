package com.dreame.smartlife.flutter.bridge

import android.dreame.module.LocalApplication
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.SPUtil
import android.provider.Settings
import android.util.Log
import com.therouter.TheRouter
import com.blankj.utilcode.util.NetworkUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.movahome.flutter.FlutterPluginSubActivity
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.google.gson.JsonNull
import com.google.gson.JsonParser
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PairNetModulePlugin : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "readBluetoothHalfState" -> {
                val state = Settings.Global.getInt(LocalApplication.getInstance().contentResolver, "bluetooth_restricte_state", 0)
                result.success(state == 1)
            }

            "pairNetSuccessGotoMainEngine" -> {
                val currentActivity = ActivityUtil.getInstance().currentActivity
                if (currentActivity is FlutterPluginSubActivity) {
                    currentActivity.finish()
                }
                RouteServiceProvider.getService<IFlutterBridgeService>()?.devicePairSuccess()
                result.success(true)
            }

            "startPairing" -> {
                try {
                    val json = call.argument<String>("info") ?: ""
                    val jsonObject = JsonParser.parseString(json).asJsonObject
                    val product = jsonObject.get("product").asJsonObject
                    val deviceSsid = if (jsonObject.get("deviceSsid") is JsonNull) {
                        null
                    } else {
                        jsonObject.get("deviceSsid").asString
                    }
                    val router = jsonObject.get("entrance").asInt
                    val sessionId = jsonObject.get("sessionId").asString

                    val selectIotDevice = if (jsonObject.has("selectIotDevice")) {
                        jsonObject.get("selectIotDevice")?.let { if (it.isJsonNull) null else it.asJsonObject }
                    } else null

                    val btScanResult = if (selectIotDevice?.has("btScanResult") == true) {
                        selectIotDevice.get("btScanResult")?.let { if (it.isJsonNull) null else it.asString }
                    } else null

                    val productBean = GsonUtils.parseObject(product.toString(), ProductListBean::class.java)
                    val productInfo = StepData.ProductInfo(
                        productBean.model,
                        productBean.quickConnects,
                        deviceSsid,
                        null,
                        productBean.productId,
                        productBean.feature,
                        productBean.model,
                        false,
                        router - 1,
                        productBean.scType,
                        productBean.extendScType,
                        null,
                        null,
                        productBean.mainImage?.imageUrl,
                        isBLE = btScanResult?.isNotBlank() == true,
                        timestamp = sessionId.toLong()
                    )
                    gotoConnect(productInfo, sessionId)
                } catch (e: Exception) {
                    LogUtil.e("PairNetModulePlugin ${Log.getStackTraceString(e)}")
                } finally {
                    result.success(true)
                }
            }

            "readPairNetWifiInfo" -> {
                val wifiListStr = SPUtil.get(LocalApplication.getInstance(), ExtraConstants.SP_KEY_WIFI_LIST, "") as String
                result.success(wifiListStr)
            }

            else -> {
                result.notImplemented();
            }
        }
    }


    /**
     * 跳转手动配网
     */
    private fun gotoConnect(productInfo: StepData.ProductInfo, sessionId: String) {
        BuriedConnectHelper.setEnterType(sessionId.toLong())
        val model = if (productInfo.deviceWifiName.isNullOrBlank()) {
            productInfo.realProductModel
        } else {
            productInfo.productModel
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterSourceType.code, hashCode(),
            "", model,
            int1 = productInfo.enterOrigin ?: 1, str1 = BuriedConnectHelper.currentSessionID()
        )
        var int1 = -1
        val path = if (productInfo.productModel?.contains("dreame.mower.") == true) {
            RoutPath.PRODUCT_CONNECT_PREPARE_BLE
        } else if (productInfo.productModel?.contains("dreame.toothbrush.") == true || productInfo.extendScType?.contains(ScanType.MCU) == true) {
            RoutPath.DEVICE_BOOT_UP
        } else {
            if (NetworkUtils.isWifiConnected()) {
                int1 = 1
                RoutPath.DEVICE_ROUTER_PASSWORD
            } else {
                int1 = 0
                RoutPath.DEVICE_ROUTER_TIPS
            }
        }
        if (int1 > 0) {
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code, PairNetEventCode.WifiIsConnect.code, hashCode(),
                "", model,
                int1 = int1, str1 = BuriedConnectHelper.currentSessionID()
            )
        }
        TheRouter.build(path)
            .withParcelable(ParameterConstants.EXTRA_PRODUCT_INFO, productInfo)
            .navigation()
    }

}