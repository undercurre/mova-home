package com.dreame.module.mall.protocol

import android.app.Activity
import android.content.Context
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import android.util.Log
import android.webkit.WebView
import com.therouter.TheRouter
import com.dreame.module.mall.R
import com.dreame.module.res.BottomMapNavigationDialog
import com.dreame.module.service.mall.IMallService
import com.dreame.module.service.mall.MallServiceExport
import com.dreame.sdk.share.ShareMedia
import com.dreame.sdk.share.ShareSdk
import android.dreame.module.util.toast.ToastUtils
import org.json.JSONObject

class MallWebViewProtocolHelper(val context: Activity, val webview: WebView) {
    fun openNewPage(context: Context, event: String, routerPath: String) {
        // 打开插件
        RouteServiceProvider.getService<IMallService>()?.openShopPage(routerPath, null, event)
    }

    suspend fun refreshSession(event: String) {
        // 打开插件
        val composeJson = RouteServiceProvider.getService<IMallService>()?.mallLoginSync() ?: ""
        doCallback(event, 0, composeJson)
    }

    fun doNavigation(event: String, data: String) {
        val jsonObject = JSONObject(data)
        val type = jsonObject.optString("type")
        val path = jsonObject.optString("path")
        val params = jsonObject.optJSONObject("params")
        when (path) {
            MallServiceExport.UNIAPP_EVENT_NAVIGATION_HOME_H5 -> {
                TheRouter.build(RoutPath.MAIN_HOME)
                    .withString("selectedIndex", "1")
                    .navigation()
                doCallback(event, 0, "")
            }

            MallServiceExport.UNIAPP_EVENT_NAVIGATION_HOME_DEVICE -> {
                TheRouter.build(RoutPath.MAIN_HOME)
                    .withString("selectedIndex", "0")
                    .navigation()
                doCallback(event, 0, "")
            }

            MallServiceExport.UNIAPP_EVENT_NAVIGATION_HOME_MINE -> {
                TheRouter.build(RoutPath.MAIN_HOME)
                    .withString("selectedIndex", "2")
                    .navigation()
                doCallback(event, 0, "")
            }

            MallServiceExport.UNIAPP_EVENT_NAVIGATION_MINE_ACCOUNTSETTING -> {
                // 如果当前页面在h5 则不处理，否则跳转到h5
                TheRouter.build(RoutPath.ACCOUNT_SETTING).navigation()
                doCallback(event, 0, "")
            }

            MallServiceExport.UNIAPP_EVENT_NAVIGATION_DEVICE_ADDDEVICE -> {
                // 如果当前页面在h5 则不处理，否则跳转到h5
                TheRouter.build(RoutPath.DEVICE_PRODUCT_QR).navigation()
                doCallback(event, 0, "")
            }

            MallServiceExport.UNIAPP_EVENT_NAVIGATION_DEVICE_SCAN -> {
                // 如果当前页面在h5 则不处理，否则跳转到h5
                TheRouter.build(RoutPath.DEVICE_PRODUCT_QR)
                    .withBoolean("onlyScan", true)
                    .withInt("scanType", 2)
                    .navigation(context, 10002)
            }
            //  命令不支持
            else -> doCallback(event, -1, "Command not supported")

        }
    }

    fun doShare(event: String, data: String) {
        try {
            val jsonObject = JSONObject(data)
            val type = jsonObject.optString("type")
            val target = jsonObject.optString("target")
            val content = jsonObject.optJSONObject("content")
            val url = content.optString("url") ?: "https://www.dreame.tech/"
            val share_title = content.optString("share_title") ?: "MOVAhome"
            val share_image = content.optString("share_image") ?: ""
            val extra = jsonObject.optString("extra") ?: ""
            val shareMedia = when (target) {
                "wechat", "wexin" -> {
                    ShareMedia.WEIXIN
                }

                "weixin_circle" -> {
                    ShareMedia.WEIXIN_CIRCLE
                }

                "qq" -> {
                    ShareMedia.QQ
                }

                "sina", "weibo" -> {
                    ShareMedia.SINA
                }

                else -> ShareMedia.WEIXIN
            }
            when (type) {
                MallServiceExport.UNIAPP_EVENT_SHARE_IMAGE -> {
                    ShareSdk.shareImage(
                        ActivityUtil.getInstance().topActivity!!,
                        url,
                        share_title,
                        shareMedia,
                        {
                            doCallback(event, 0, "")
                        },
                        { media, cancel, uninstalled, message ->
                            doCallback(event, if (cancel) 1 else -1, message)
                        })
                }

                MallServiceExport.UNIAPP_EVENT_SHARE_WEB -> {
                    ShareSdk.shareWeb(ActivityUtil.getInstance().topActivity!!, share_title, "",
                        url, share_image,
                        shareMedia,
                        {
                            doCallback(event, 0, "")
                        },
                        { media, cancel, uninstalled, message ->
                            if (uninstalled) {
                                showShareAppUninstall(media)
                            }
                            doCallback(event, if (cancel) 1 else -1, message)
                        })
                }

                else -> doCallback(event, -1, "Command not supported")
            }
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.e("share error : " + Log.getStackTraceString(e))
        }
    }

    private fun doCallback(event: String, code: Int, message: String?) {
        val jsonObject = JSONObject()
        jsonObject.put("type", event)
        jsonObject.put("code", code)
        jsonObject.put("msg", message)
        webview.evaluateMallOnAppMessage(jsonObject.toString())
    }

    fun onBarCodeScan(event: String, code: Int, message: String?) {
        val jsonObject = JSONObject()
        jsonObject.put("type", event)
        jsonObject.put("code", code)
        jsonObject.put("result", message)
        webview.evaluateMallOnBarCodeScan(jsonObject)
    }

    private fun showShareAppUninstall(shareMedia: ShareMedia) {
        val act = ActivityUtil.getInstance().topActivity
        if (act != null) {
            var app = ""
            when (shareMedia) {
                ShareMedia.QQ -> {
                    app = "QQ"
                }

                ShareMedia.SINA -> {
                    app =
                        act.getString(R.string.share_weibo)
                }

                ShareMedia.WEIXIN, ShareMedia.WEIXIN_CIRCLE, ShareMedia.WEIXIN_FAVORITE -> {
                    app = act.getString(R.string.share_weixin)
                }

                else -> {
                }
            }
            ToastUtils.show(
                String.format(
                    act.getString(R.string.text_share_platform_uninstall),
                    app
                )
            )
        }

    }

    fun showMapNavigation(type: String, data: String) {
        val act = ActivityUtil.getInstance().topActivity
        if (act != null) {
            try {
                val jsonObject = JSONObject(data)
                val title = jsonObject.optString("title")
                val locationObj = jsonObject.optJSONObject("location")
                val lat = locationObj.optString("lat")
                val lon = locationObj.optString("lon")
                BottomMapNavigationDialog(act).show(
                    title,
                    act.getString(R.string.cancel),
                    lat,
                    lon,
                    null
                ) { msg ->
                    ToastUtils.show(msg)
                }

            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("showMapNavigation error ${Log.getStackTraceString(e)}")
            }
        }
    }
}

