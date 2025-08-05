package com.dreame.smartlife.wxapi

import android.content.Intent
import android.dreame.module.event.EventCode.WECHAT_LOGIN_AUTH_RESULT
import android.dreame.module.event.EventMessage
import android.dreame.module.event.WechatAuthStatus
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import com.dreame.movahome.flutter.FlutterPluginActivity
import com.dreame.sdk.share.WXShareActivity
import com.tencent.mm.opensdk.constants.ConstantsAPI
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler
import io.github.v7lin.wechat_kit.WechatCallbackActivity
import org.greenrobot.eventbus.EventBus


/**
 * <pre>
 *     author : admin
 *     e-mail : wufei1@dreame.tech
 *     time   : 2021/11/19
 *     desc   : 继承自分享sdk,需自己拦截处理回调事件
 *     version: 1.0
 * </pre>
 */
class WXEntryActivity : WXShareActivity(), IWXAPIEventHandler {
    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        if (!gotoFlutterHandle(intent)) {

        }
    }

    private fun gotoFlutterHandle(intent: Intent?): Boolean {
        val preActivity = ActivityUtil.getInstance().preActivity()
        if (preActivity != null && preActivity is FlutterPluginActivity) {
            /**
             * [WechatCallbackActivity]
             */
            startActivity(
                Intent(this, preActivity::class.java)
                    .apply {
                        putExtra("wechat_callback", true)
                        putExtra("wechat_extra", intent)
                            .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    })
            return true
        }
        return false
    }

    override fun onResp(resp: BaseResp) {
        LogUtil.d(
            "WXEntryActivity",
            "onResp type：${resp?.type},errorCode:${resp?.errCode},errorMsg:${resp?.errStr}"
        )
        when (resp.type) {
            ConstantsAPI.COMMAND_PAY_BY_WX,
            ConstantsAPI.COMMAND_JOINT_PAY,
            ConstantsAPI.COMMAND_PAY_INSURANCE,
            ConstantsAPI.COMMAND_NON_TAX_PAY,
            ConstantsAPI.COMMAND_OPEN_QRCODE_PAY,
            ConstantsAPI.COMMAND_JUMP_TO_OFFLINE_PAY -> {
                // 微信支付
                val preActivity = ActivityUtil.getInstance().preActivity()
                startActivity(
                    Intent(this, preActivity::class.java)
                        .apply {
                            putExtra("wechat_callback", true)
                            putExtra("wechat_extra", intent)
                                .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        })
            }

            ConstantsAPI.COMMAND_SENDAUTH -> {
                val authResp = resp as SendAuth.Resp
                if (authResp.state == "MOVAhomeAuth:flutter") {
                    EventBus.getDefault().post(WechatAuthStatus(authResp.code, authResp.errCode))
                } else {
                    EventBus.getDefault().post(
                        EventMessage(
                            WECHAT_LOGIN_AUTH_RESULT,
                            WechatAuthStatus(authResp.code, authResp.errCode)
                        )
                    )
                }
            }

            ConstantsAPI.COMMAND_LAUNCH_WX_MINIPROGRAM -> {
                val authResp = resp as WXLaunchMiniProgram.Resp
                if (authResp.errCode == BaseResp.ErrCode.ERR_OK) {
                } else {

                }
            }

            ConstantsAPI.COMMAND_SENDMESSAGE_TO_WX -> {
                super.onResp(resp)
            }

            else -> {

            }
        }
        finish()
    }
}