package com.dreame.smartlife.help

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.dreame.module.LocalApplication
import android.dreame.module.RouteServiceProvider
import android.dreame.module.bean.DeviceListBean
import android.dreame.module.data.entry.help.AfterSaleInfoRes
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.util.DarkThemeUtils
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.dreame.module.util.toast.ToastUtils
import android.net.Uri
import android.os.Build
import android.text.TextUtils
import android.util.Log
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.sobot.chat.ZCSobotApi
import com.sobot.chat.api.apiUtils.SobotBaseUrl
import com.sobot.chat.api.enumtype.SobotChatAvatarDisplayMode
import com.sobot.chat.api.enumtype.SobotChatTitleDisplayMode
import com.sobot.chat.api.model.Information
import com.sobot.chat.listener.NewHyperlinkListener
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import zendesk.android.Zendesk
import zendesk.android.events.ZendeskEvent
import zendesk.android.events.ZendeskEventListener
import zendesk.messaging.android.DefaultMessagingFactory


object CustomerServiceManager {
    private const val ZHI_CHI_APP_KEY = "11e30aac3d4047df84d7273ea6afbda4"
    private const val ZHI_CHI_API_HOST = "https://mova.sobot.com"
    private var zendeskSdkInit = false
    private var sobotSdkInit = false
    private var lastChannelKey: String? = null

    /**
     * 中国地区智齿，
     */
    fun openChat(activity: Activity, openZendesk: Boolean, paramsMap: HashMap<String, Any>?, zhiChiSourceId: String = "") {
        if (openZendesk) {
            val channelKey = paramsMap?.remove("apiKey")?.toString()
            initZendeskSdk(channelKey) {
                if (it) {
                    MainScope().launch {
                        Zendesk.instance.messaging.clearConversationFields()
                        val map = paramsMap ?: emptyMap()
                        Zendesk.instance.messaging.setConversationFields(map)
                        Zendesk.instance.messaging.showMessaging(activity)
                    }
                }
            }
        } else {
            val uid = AccountManager.getInstance().userInfo.uid
            val name = AccountManager.getInstance().userInfo.uid
            val email = AccountManager.getInstance().userInfo.email
            val phoneNumber = AccountManager.getInstance().userInfo.phone
            initSobotSdk(activity.applicationContext)
            MainScope().launch {
                goZhiChi(activity, uid, name, email, phoneNumber, sourceId = zhiChiSourceId)
            }
        }
    }

    fun openChat(
        activity: Activity,
        paramsMap: HashMap<String, Any>?,
        countryCode: String? = null,
        zhiChiSourceId: String = "",
    ) {
        val country = if (countryCode.isNullOrEmpty()) {
            AreaManager.getCountryCode()
        } else {
            countryCode
        }
        val uid = AccountManager.getInstance().userInfo.uid
        val name = AccountManager.getInstance().userInfo.uid
        val email = AccountManager.getInstance().userInfo.email
        val phoneNumber = AccountManager.getInstance().userInfo.phone
        if ("cn".equals(country, true)) {
            initSobotSdk(activity.applicationContext)
            MainScope().launch {
                goZhiChi(activity, uid, name, email, phoneNumber, zhiChiSourceId)
            }
        } else {
            val channelKey = paramsMap?.remove("apiKey")?.toString()
            initZendeskSdk(channelKey) {
                if (it) {
                    MainScope().launch {
                        Zendesk.instance.messaging.clearConversationFields()
                        val map = paramsMap ?: emptyMap()
                        Zendesk.instance.messaging.setConversationFields(map)
                        Zendesk.instance.messaging.showMessaging(activity)
                    }
                }
            }
        }
    }

    private suspend fun goZhiChi(
        activity: Activity,
        uid: String?,
        name: String?,
        email: String?,
        phoneNumber: String?,
        sourceId: String,
    ) {
        val info = Information()
        info.setApp_key(ZHI_CHI_APP_KEY)
        if (!uid.isNullOrEmpty()) {
            info.partnerid = "${uid}_${sourceId}"
        }
        if (!TextUtils.isEmpty(name)) {
            info.setUser_nick(name)
        }
        if (!TextUtils.isEmpty(email)) {
            info.setUser_emails(email)
        }
        if (!TextUtils.isEmpty(phoneNumber)) {
            info.setUser_tels(phoneNumber)
        }
        val customInfo = mutableMapOf<String, String>()
        var currentDevice: OnlineCustomServiceDevice? = null
        val list = RouteServiceProvider.getService<IFlutterBridgeService>()?.getAllDeviceList(
            DeviceListBean.Device::class.java
        ) ?: emptyList()
        val firstDevice = if (list.isNotEmpty()) {
            list[0]
        } else {
            null
        }
        if (firstDevice != null) {
            currentDevice = OnlineCustomServiceDevice(
                firstDevice.model,
                firstDevice.ver,
                firstDevice.did,
                firstDevice.sn,
            )
        }

        withContext(Dispatchers.IO) {
            currentDevice?.let {
                customInfo["9fa9847187974314a120945f77a50b82"] = it.model ?: ""
                customInfo["4475337fdee1497cb8294a02c88afa81"] = it.did ?: ""
//                try {
//                    customInfo["da5773ea4c4f43d6abb0c33d64d899df"] = it.sn ?: ""
//                    if (it.sn.isNullOrBlank()) {
//                        val ret = DreameService.getDevicePropsByDid(it.did ?: "", "1.5")
//                        if (ret.success) {
//                            if (ret.data.isNotEmpty()) {
//                                val snProp = ret.data[0]
//                                customInfo["da5773ea4c4f43d6abb0c33d64d899df"] = snProp.value
//                            }
//                        }
//                    }
//                } catch (e: Exception) {
//                    LogUtil.e("getDevicePropsByDid error:${Log.getStackTraceString(e)}")
//                }
            }
            customInfo["7b058cd290df4e058b34f300e64dcbba"] = uid ?: ""
            customInfo["db91f5bda53a4a78b88661037a5ab9e6"] = getVersionName(activity)
//            customInfo["8ee45773bdb14c18b0c1e3018820447e"] = getVersionName(activity)
            customInfo["65f223f072934178b0aea79661d95a7e"] =
                "${Build.BRAND}:Android ${Build.VERSION.RELEASE}"
//            info.setParams(customInfo)
            info.setCustomer_fields(customInfo)
            withContext(Dispatchers.Main) {
                // 配置夜间模式
                val mode = DarkThemeUtils.getThemeSettingAppCompat(LocalApplication.getInstance())
                ZCSobotApi.setLocalNightMode(LocalApplication.getInstance(), mode)
                ZCSobotApi.openZCChat(activity, info)
            }
        }
    }

    fun initCustomerServiceSdk(context: Context, channelKey: String?) {
        if (AccountManager.getInstance().userInfo.uid.isNullOrEmpty()) {
            return
        }
        initSobotSdk(context)
        initZendeskSdk(channelKey)
    }

    /**
     * 切换地区, 重置客服
     */
    private fun resetCustomer() {
        // 判断是否需要切换zendesk 实例
        lastChannelKey = null
        Zendesk.instance.messaging.clearConversationFields()
        Zendesk.instance.removeEventListener(zendeskEventListener)
        Zendesk.invalidate()
    }

    fun initSobotSdk(context: Context) {
        if (sobotSdkInit) {
            return
        }
        // FIXME: 反射修复智齿SDK 适配魅族手机问题
        // FIXME: 反射修复智齿SDK 适配魅族手机问题
        // FIXME: 反射修复智齿SDK 适配魅族手机问题
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val clazz = Class.forName("android.os.Build")
                val newInstance = clazz.newInstance()
                val field = clazz.getDeclaredField("DISPLAY")
                field.isAccessible = true
                val display = field.get(newInstance)
                if (display != null) {
                    if ((display as String).startsWith("Flyme")) {
                        field.set(null, "flyme")
                    }
                }
                field.isAccessible = false
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        SobotBaseUrl.setApi_Host(ZHI_CHI_API_HOST)
        ZCSobotApi.initSobotSDK(
            context.applicationContext,
            ZHI_CHI_APP_KEY,
            AccountManager.getInstance().userInfo.uid
        )
        // ZCSobotApi.setChatAvatarDisplayMode(
        //     context.applicationContext,
        //     SobotChatAvatarDisplayMode.Default,
        //     "",
        //     false
        // )
        // ZCSobotApi.setChatTitleDisplayMode(
        //     context.applicationContext,
        //     SobotChatTitleDisplayMode.ShowFixedText, null, true
        // )

        //[https://developer.zhichi.com/pages/e2eeda/#_6-%E8%87%AA%E5%AE%9A%E4%B9%89%E8%B6%85%E9%93%BE%E6%8E%A5%E7%9A%84%E7%82%B9%E5%87%BB%E4%BA%8B%E4%BB%B6-%E6%8B%A6%E6%88%AA%E8%8C%83%E5%9B%B4-%E5%B8%AE%E5%8A%A9%E4%B8%AD%E5%BF%83%E3%80%81%E7%95%99%E8%A8%80%E3%80%81%E8%81%8A%E5%A4%A9%E3%80%81%E7%95%99%E8%A8%80%E8%AE%B0%E5%BD%95%E3%80%81%E5%95%86%E5%93%81%E5%8D%A1%E7%89%87-%E8%AE%A2%E5%8D%95%E5%8D%A1%E7%89%87-%E4%BD%8D%E7%BD%AE%E5%8D%A1%E7%89%87]
        // 链接的点击事件, 根据返回结果判断是否拦截 如果返回true,拦截;false 不拦截
        // 可为订单号,商品详情地址等等;客户可自定义规则拦截,返回true时会把自定义的信息返回
        // 拦截范围  （帮助中心、留言、聊天、留言记录、商品卡片，订单卡片）
        val ALIPAY_URL_PREFIX = "alipays://"
        val WECHAT_URL_PREFIX = "weixin://"
        ZCSobotApi.setNewHyperlinkListener(object : NewHyperlinkListener {
            override fun onUrlClick(context: Context, url: String): Boolean {
                if (context == null || url.isNullOrEmpty()) {
                    return false
                }
                val url = url.replace("https://https://", "https://")
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                intent.addCategory(Intent.CATEGORY_BROWSABLE)
                if (intent.resolveActivity(context.packageManager) != null) {
                    if (context !is Activity) {
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    try {
                        context.startActivity(intent)
                        return true
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                    return false
                } else {
                    return false
                }
            }

            override fun onEmailClick(context: Context?, email: String?): Boolean {
                return false
            }

            override fun onPhoneClick(context: Context?, phone: String?): Boolean {
                return false
            }
        })

        sobotSdkInit = true
    }

    private fun initZendeskSdk(channelKey: String? = null, initCallback: ((success: Boolean) -> Unit)? = null) {
        if (channelKey.isNullOrEmpty()) return
        if (lastChannelKey != channelKey) {
            resetCustomer()
        }
        lastChannelKey = channelKey
        Zendesk.instance.addEventListener(zendeskEventListener)
        Zendesk.initialize(
            LocalApplication.getInstance(),
            channelKey,
            successCallback = {
                Log.d("CustomerServiceManager", "init success")
                initCallback?.invoke(true)
                zendeskSdkInit = true
            },
            failureCallback = {
                Log.d("CustomerServiceManager", "init fail: $it")
            },
            messagingFactory = DefaultMessagingFactory()
        )
    }

    // To create and use the event listener:
    val zendeskEventListener: ZendeskEventListener = ZendeskEventListener { zendeskEvent ->
        LogUtil.d("sunzhibin zendeskEventListener : $zendeskEvent")
        when (zendeskEvent) {
            is ZendeskEvent.UnreadMessageCountChanged -> {
                // Your custom action...
            }

            is ZendeskEvent.AuthenticationFailed -> {
                // Your custom action...
            }

            is ZendeskEvent.FieldValidationFailed -> {
                // Your custom action...
            }

            else -> {
                // Default branch for forward compatibility with Zendesk SDK and its `ZendeskEvent` expansion
            }
        }
    }


    private fun getVersionName(context: Context): String {
        try {
            val packageManager = context.packageManager
            val packageInfo = packageManager.getPackageInfo(
                context.packageName, 0
            )
            return packageInfo.versionName
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ""
    }

    fun getAfterSaleInfo(context: Context): AfterSaleInfoRes? {
        val sp = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val saleInfoStr = sp.getString("flutter.after_sale_info", "")
        if (saleInfoStr.isNullOrEmpty()) {
            return null
        }
        try {
            return GsonUtils.fromJson(saleInfoStr, AfterSaleInfoRes::class.java)
        } catch (e: Exception) {
            LogUtil.e("getAfterSaleInfo error: ${Log.getStackTraceString(e)},$saleInfoStr")
        }
        return null
    }

    fun openEmail(
        activity: Activity,
        email: String
    ) {
        EventCommonHelper.eventCommonPageInsert(7, 28, this.hashCode())
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("mailto:$email"))
        val chooseEmailClient =
            Intent.createChooser(intent, activity.getString(R.string.title_chooose_email))
        if (chooseEmailClient.resolveActivity(activity.packageManager) != null) {
            activity.startActivity(chooseEmailClient)
        } else {
            ToastUtils.show(activity.getString(R.string.Help_CustomerCare_NoEmailClient_Toast))
        }
    }
}

data class OnlineCustomServiceDevice(
    val model: String?,
    val ver: String?,
    val did: String?,
    val sn: String?,
)