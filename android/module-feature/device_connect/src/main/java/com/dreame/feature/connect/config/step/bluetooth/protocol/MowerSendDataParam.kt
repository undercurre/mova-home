package com.dreame.smartlife.config.step

import android.dreame.module.manager.AccountManager
import android.dreame.module.manager.AreaManager
import br.eti.balena.security.ecdh.curve25519.Curve25519KeyAgreement
import br.eti.balena.security.ecdh.curve25519.Curve25519KeyPairGenerator
import br.eti.balena.security.ecdh.curve25519.Curve25519PublicKey
import com.blankj.utilcode.util.EncodeUtils
import com.blankj.utilcode.util.EncryptUtils
import com.google.gson.JsonNull
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import java.util.*

/**
 * 割草机配网参数组装
 * [https://dreametech.feishu.cn/docx/DwTmdsTSKoUirQxqePoc2NnenBe]
 *
 */
class MowerSendDataParam {

    private val keyPair by lazy {
        Curve25519KeyPairGenerator().generateKeyPair()
    }

    // 保存服务端的密钥
    private var serverKeyValue: String? = null

    private var sharedSecretKeyArr: ByteArray = byteArrayOf()
    private var ivArr: ByteArray = byteArrayOf()
    private var transformation: String = "AES/CBC/PKCS7Padding"
    var bindCode = 0
        private set

    /**
     * step1
     * 检查机器是否设置pin code
     */
    fun requestCheckParam(): String {
        val connectReq = JsonObject().apply {
            addProperty("method", "request_check")
        }
        return connectReq.toString()
    }

    /**
     * 解析 response_check
     * @param result
     * @return map method,code,value
     */
    fun parseRequestCheckResult(result: String): Map<String, Any> {
        return parseResult(result, "response_check")
    }

    /**
     * step2
     */
    fun requestConnectionParam(uid: String, pCode: String): String {
        val publicKey = keyPair.public.encoded
        val connectReq = JsonObject().apply {
            addProperty("method", "request_connection")
            addProperty("value", String(EncodeUtils.base64Encode(publicKey)))
            addProperty("length", publicKey.size)
            addProperty("uid", uid)
            addProperty("pcode", pCode)
        }
        return connectReq.toString()
    }

    /**
     * 解析 response_connection
     * @param result
     * @return map  method,code,value,did,pubCer,remain
     */
    fun parseRequestConnectionResult(result: String): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        try {
            val responseObj = JsonParser.parseString(result) as JsonObject
            val method = if (responseObj.has("method")) {
                responseObj.get("method").asString
            } else ""
            val code = if (responseObj.has("code")) {
                responseObj.get("code").asInt
            } else -100
            val did = if (responseObj.has("did")) {
                responseObj.get("did").asString
            } else ""
            val pubCer = if (responseObj.has("pubCer")) {
                responseObj.get("pubCer").asString
            } else ""
            val length = if (responseObj.has("length")) {
                responseObj.get("length").asInt
            } else 0
            val value = if (responseObj.has("value")) {
                responseObj.get("value").asString
            } else ""
            val remain = if (responseObj.has("remain")) {
                responseObj.get("remain").asInt
            } else 0
            map["code"] = -100
            if ("response_connection".equals(method)) {
                // code 0: success, -1: pcode 错误 -2: 机器被锁定
                if (code == 0) {
                    map["method"] = method
                    map["code"] = code
                    map["did"] = did
                    map["pubCer"] = pubCer
                    map["length"] = length
                    // 解析value
                    serverKeyValue = pubCer
                    val jsonStr = decodeECDHContent(value, did, pubCer, true)
                    if (jsonStr.isNotEmpty()) {
                        val valueObj = JsonParser.parseString(jsonStr) as JsonObject
//                val did = parseString.get("did").asString
                        val session = if (valueObj.has("session")) {
                            valueObj.get("session").asString
                        } else ""
                        val secret = if (valueObj.has("secret")) {
                            valueObj.get("secret").asString
                        } else ""
                        val mac = if (valueObj.has("mac")) {
                            valueObj.get("mac").asString
                        } else ""
                        val ver = if (valueObj.has("ver")) {
                            valueObj.get("ver").asString
                        } else ""
                        // app 上传did,uid,session,secret,mac,ver 到服务器
                        map["session"] = session
                        map["secret"] = secret
                        map["mac"] = mac
                        map["ver"] = ver
                    } else {
                        // 解析错误
                        map["code"] = -100
                    }
                } else {
                    map["method"] = method
                    map["code"] = code
                    // code：-2 时,剩余锁定时间
                    //code：-1 时,剩余输入次数
                    map["remain"] = remain
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return map
    }

    /**
     * step3 app 下发通知机器，机器重置session 和 pwd
     * @param code 0:sucess -1:已绑定其他用户 -2：用户没有权限绑定机器 -3：验证password失败
     */
    fun requestBindParam(code: Int): String {
        bindCode = code
        val connectReq = JsonObject().apply {
            addProperty("method", "request_binding")
            addProperty("code", code)
        }
        return connectReq.toString()
    }

    fun parseRequestBindResult(result: String): Map<String, Any> {
        return parseResult(result, "response_binding")
    }

    /**
     * step4 app下发wifi账号密码
     */
    fun configureRouterParam(isSkip: Boolean): String {
        if (isSkip) {
            // 跳过密码设置
            val routerReq = JsonObject().apply {
                addProperty("method", "config_router")
                addProperty("code", 0)
            }
            return routerReq.toString()
        }

        var routerReq = JsonObject().apply {
            addProperty("ssid", StepData.targetWifiName)
            addProperty("passwd", StepData.targetWifiPwd)
            addProperty("domain", StepData.targetDomain)
            addProperty("uid", AccountManager.getInstance().getAccount().uid)
            addProperty("timestamp", (Date().time / 1000).toString())
            addProperty("region", AreaManager.getRegion())
            addProperty("timezone", TimeZone.getDefault().id)
            if (StepData.isAfterSales) {
                addProperty("notClearLogFile", 1)
            }
        }

        // 配网加密
        val encryptAES = EncryptUtils.encryptAES(
            routerReq.toString().toByteArray(),
            sharedSecretKeyArr,
            transformation,
            ivArr
        )
        routerReq = JsonObject().apply {
            addProperty("method", "config_router")
            addProperty("value", String(EncodeUtils.base64Encode(encryptAES)))
            addProperty("length", encryptAES.size)
            addProperty("code", 1)
        }
        return routerReq.toString()
    }

    fun parseConfigureRouterResult(result: String): Map<String, Any> {
        return parseResult(result, "response_router")
    }

    fun parseResult(result: String, methodName: String): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        map["code"] = -100
        try {
            val parseString = JsonParser.parseString(result) as JsonObject
            val method = if (parseString.has("method")) {
                parseString.get("method").asString
            } else ""
            val code = if (parseString.has("code")) {
                parseString.get("code").asInt
            } else -100
            if (methodName == method) {
                map["method"] = method
                map["code"] = code
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return map
    }

    /**
     * 计算ECDH密钥
     * @param encryptContent 加密的内容
     * @param encryptContent 加密的内容
     * @param deviceId did
     * @param devicePubKey 机器公钥
     * @param isReset 重新生成机器公钥
     * @return decryptContent 解密后的内容
     */
    private fun decodeECDHContent(encryptContent: String, deviceId: String, devicePubKey: String, isReset: Boolean = false): String {
        val serverPublicKey = EncodeUtils.base64Decode(devicePubKey)
        val data = EncodeUtils.base64Decode(encryptContent)
        if (isReset || sharedSecretKeyArr.isEmpty()) {
            val sharedSecret = Curve25519KeyAgreement(keyPair.private)
                .apply { doFinal(Curve25519PublicKey(serverPublicKey)) }
                .generateSecret()
            sharedSecretKeyArr = sharedSecret
            val iv = deviceId.plus("1111111111111111").substring(0, 16)
            ivArr = iv.toByteArray()
        }
        val content = EncryptUtils.decryptAES(
            data,
            sharedSecretKeyArr,
            transformation,
            ivArr
        )
        return String(content)
    }
}