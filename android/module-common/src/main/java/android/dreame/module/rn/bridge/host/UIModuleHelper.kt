package android.dreame.module.rn.bridge.host

import android.app.Activity
import android.content.Intent
import android.dreame.module.ext.isValidJson
import android.dreame.module.util.LogUtil
import com.alibaba.sdk.android.openaccount.util.ActivityHelper.getCurrentActivity
import com.blankj.utilcode.util.GsonUtils
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.facebook.react.bridge.Promise
import com.google.gson.JsonObject
import com.therouter.TheRouter.get
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

object UIModuleHelper {

    private val globalScope = CoroutineScope(Dispatchers.Main);

    fun openPage(params: String?, promise: Promise) {
        LogUtil.i("openPage params = $params")
        if (params == null) {
            LogUtil.e("openPage params is null")
            return
        }

        if (!params.isValidJson()) {
            LogUtil.e("openPage params is illegal")
            return
        }

        val jsonObject = GsonUtils.fromJson(
            params,
            JsonObject::class.java
        )

        val desType = jsonObject["desType"]?.asString
        val closeCurrentPage = jsonObject["closeCurrentPage"]?.asString
        val source = jsonObject["source"]?.asString
        val destination = jsonObject["destination"]?.asString
        val detailParams = jsonObject["detailParams"]?.asJsonObject

        val did = detailParams?.get("did")?.asString
        val entranceType = detailParams?.get("entranceType")?.asString
        val model = detailParams?.get("model")?.asString

        val activity = getCurrentActivity()

        when (desType) {
            "nativePage" -> {}
            "flutterPage" ->
                toFlutterPage(destination, activity, closeCurrentPage,promise)

            "rnPage" ->
                toRnPage(did, entranceType, model, promise, closeCurrentPage, activity)


        }
    }

    private fun toFlutterPage(
        destination: String?,
        activity: Activity,
        closeCurrentPage: String?,
        promise: Promise
    ) {
        // val routePath = "/qr_scan"
        val flutterBridgeService = get(IFlutterBridgeService::class.java)
        if (flutterBridgeService != null && destination?.isNotEmpty() == true) {
            val intent =
                flutterBridgeService.openSubFlutter(activity, destination, mutableMapOf())
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            activity.startActivity(intent)
            if (closeCurrentPage == "true")
                closeCurrentAct(closeCurrentPage, activity)
        } else
            promise.reject("-1", "openFlutterPage failed")
    }

    private fun toRnPage(
        did: String?,
        entranceType: String?,
        model: String?,
        promise: Promise,
        closeCurrentPage: String?,
        activity: Activity?
    ) {
        val flutterBridgeService = get(IFlutterBridgeService::class.java)
        if (flutterBridgeService != null
            && did?.isNotEmpty() == true
            && entranceType?.isNotEmpty() == true
            && model?.isNotEmpty() == true
        )
            flutterBridgeService.openRnPluginPage(
                mutableMapOf(
                    "did" to did,
                    "entranceType" to entranceType,
                    "model" to model,
                    "selectTargetItem" to "true",
                )
            ) { result: Any? ->
                promise.resolve(result)
                closeCurrentAct(closeCurrentPage, activity)
            }
        else
            promise.reject("-1", "openRnPluginPage failed")
    }

    private fun closeCurrentAct(closeCurrentPage: String?, activity: Activity?) {
        if (closeCurrentPage == "true" && activity != null)
            globalScope.launch {
                delay(2000)
                activity.finish()
            }
    }
}



