package com.dreame.smartlife.config.step

import android.dreame.module.LocalApplication
import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import android.dreame.module.manager.LanguageManager
import android.dreame.module.util.LogUtil
import android.text.TextUtils
import br.eti.balena.security.ecdh.curve25519.Curve25519KeyAgreement
import br.eti.balena.security.ecdh.curve25519.Curve25519KeyPairGenerator
import br.eti.balena.security.ecdh.curve25519.Curve25519PublicKey
import com.blankj.utilcode.util.EncodeUtils
import com.blankj.utilcode.util.EncryptUtils
import com.google.gson.JsonObject
import java.util.*

/**
 * 配网参数组装
 */
class SendDataParam {

    private val keyPair by lazy {
        Curve25519KeyPairGenerator().generateKeyPair()
    }

    fun requestConnectionParam(): String {
        val publicKey = keyPair.public.encoded
        val connectReq = JsonObject().apply {
            addProperty("method", "request_connection")
            addProperty("value", String(EncodeUtils.base64Encode(publicKey)))
            addProperty("length", publicKey.size)
        }
        return connectReq.toString()
    }

    fun configureRouterParam(deviceId: String, value: String?): String {
        var routerReq = JsonObject().apply {
            addProperty("ssid", StepData.targetWifiName)
            addProperty("passwd", StepData.targetWifiPwd)
            addProperty("uid", AccountManager.getInstance().getAccount().uid)
            addProperty("timestamp", (Date().time / 1000).toString())
            addProperty("domain", StepData.targetDomain)
            val region = AreaManager.getRegion()
            addProperty("region", region)
            addProperty("timezone", TimeZone.getDefault().id)
            if (StepData.isAfterSales) {
                addProperty("notClearLogFile", 1)
            }

        }
        if (TextUtils.isEmpty(value)) {
            routerReq.addProperty("method", "config_router")
        } else {
            // 配网加密
            val serverPublicKey = EncodeUtils.base64Decode(value)
            val sharedSecret = Curve25519KeyAgreement(keyPair.private)
                .apply { doFinal(Curve25519PublicKey(serverPublicKey)) }
                .generateSecret()
            /// 记录sharekey，用于后续的数据解密
            LogUtil.i("sharedSecret: ${EncodeUtils.base64Encode(sharedSecret)} ,pairData: $routerReq")
            val iv = deviceId.plus("1111111111111111").substring(0, 16)
            val encryptAES = EncryptUtils.encryptAES(
                routerReq.toString().toByteArray(),
                sharedSecret,
                "AES/CBC/PKCS7Padding",
                iv.toByteArray()
            )
            routerReq = JsonObject().apply {
                addProperty("method", "config_router")
                addProperty("value", String(EncodeUtils.base64Encode(encryptAES)))
                addProperty("length", encryptAES.size)
            }
        }
        return routerReq.toString()
    }

    fun configureLogParam(): String {
        val routerReq = JsonObject().apply {
            addProperty("method", "last_fail_log")
        }
        return routerReq.toString()
    }

}