package com.dreame.smartlife.flutter.utils

import android.app.Activity
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import android.util.Log
import com.dreame.module.service.mall.MallServiceExport
import com.dreame.sdk.share.ShareMedia
import com.dreame.sdk.share.ShareSdk
import android.dreame.module.util.toast.ToastUtils
import com.dreame.smartlife.R
import org.json.JSONObject

class ShareHandler {

    fun doShare(shareContent: String, callBack: (String) -> Unit) {
        try {
            val jsonObject = JSONObject(shareContent)
            val event = jsonObject.optString("type");
            val data = jsonObject.optJSONObject("data");
            val type = data.optString("type")
            val target = data.optString("target")
            val content = data.optJSONObject("content")
            val url = content.optString("url") ?: "https://www.mova-tech.com/"
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
                        LanguageManager.getInstance()
                            .setLocal(ActivityUtil.getInstance().topActivity!!) as Activity,
                        url,
                        share_title,
                        shareMedia,
                        {

                            callBack(buildResult(event, 0, ""))
                        },
                        { media, cancel, uninstalled, message ->
                            callBack(buildResult(event, if (cancel) 1 else -1, message))
                        })
                }

                MallServiceExport.UNIAPP_EVENT_SHARE_WEB -> {
                    ShareSdk.shareWeb(
                        ActivityUtil.getInstance().topActivity!!, share_title, "",
                        url, share_image,
                        shareMedia,
                        {
                            callBack(buildResult(event, 0, ""))
                        },
                        { media, cancel, uninstalled, message ->
                            if (uninstalled) {
                                showShareAppUninstall(media)
                            }
                            callBack(buildResult(event, if (cancel) 1 else -1, message))
                        })
                }

                else -> callBack(buildResult(event, -1, "Command not supported"))
            }
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.e("share error : " + Log.getStackTraceString(e))
        }
    }

    private fun buildResult(event: String, code: Int, message: String?): String {
        val jsonObject = JSONObject()
        jsonObject.put("type", event)
        jsonObject.put("code", code)
        jsonObject.put("msg", message)
        return jsonObject.toString();
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
}