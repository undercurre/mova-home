package com.dreame.smartlife.config.step.udp

import android.dreame.module.LocalApplication
import android.dreame.module.util.LogUtil
import android.os.Handler
import android.os.HandlerThread
import android.os.SystemClock
import android.util.Log
import com.blankj.utilcode.util.EncryptUtils
import android.dreame.module.feature.connect.bluetooth.byteArrayToInt
import android.dreame.module.feature.connect.bluetooth.formatHexString
import org.json.JSONObject
import java.io.File
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.InetSocketAddress
import java.util.Arrays
import kotlin.math.log

/**
 * 取到的日志，会通过[android.dreame.module.util.log.LogUploadServer]上传
 */
class TestSocketCanConnect(private val mainHandler: Handler) {
    private var workHandler: Handler
    val logFileParent = File(LocalApplication.getInstance().cacheDir.path, "log/device")

    init {
        val mHandlerThread = HandlerThread("testSocket")
        mHandlerThread.start()
        workHandler = Handler(mHandlerThread.looper) {

            return@Handler true;
        }
        try {
            if (!logFileParent.exists()) {
                logFileParent.mkdirs()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    fun runTest(block: () -> Unit) {
        workHandler.post {
            block();
        }
    }

    fun runTest(runnable: Runnable) {
        workHandler.post(runnable)
    }

    /**
     * 发socket 测试一下
     */
    fun testSocketConnect(ip: String, port: Int, isMain: Boolean = false, block: (result: Boolean, msg: String?) -> Unit) {
        workHandler.post {
            try {
                val datagramSocket = DatagramSocket()
                datagramSocket.soTimeout = 2 * 1000
                datagramSocket.broadcast = true
                datagramSocket.reuseAddress = true

                val jsonObject = JSONObject()
                jsonObject.put("method", "request_connection")
                val toByteArray = jsonObject.toString().toByteArray()

                val inetAddress = InetSocketAddress(ip, port)
                datagramSocket.send(DatagramPacket(toByteArray, toByteArray.size, inetAddress))
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("runTestSocket: ${Log.getStackTraceString(e)}")
                //  ENETUNREACH (Network is unreachable) 网络切换时候，等一下重试
                callback(false, e.message ?: "", isMain, block)
                return@post
            }
            callback(true, null, isMain, block)
        }
    }

    /**
     *  获取 last_fail_code
     *
     *   0 未记录错误
     *   1 前次配网成功, 适用于机器报配网成功，但app提示失败
     *   2 未烧号
     *   3 did 未加入白名单
     *   4 本机已有IP，但无法访问服务器
     *   5 外网通但访问不到服务器
     *   404_xx 其它连接服务器异常，xx为MQTT定义错误码
     *   101 密码错误，用户输入错误
     *   102 Wi-Fi名称不存在
     *   103 连上路由器，但未分配到IP地址
     *   120_xx 其它连接路由器失败 xx 为wpa 返回的status_code
     */
    fun socketReadRobotLastFailCode(ip: String, port: Int, isMain: Boolean = false, block: (result: Boolean, msg: String?) -> Unit) {
        val jsonObject = JSONObject()
        jsonObject.put("method", "last_fail_code")
        val toByteArray = jsonObject.toString().toByteArray()
        sendSocket(ip, port, toByteArray, isMain, block) { res ->
            val resultStr = String(res)
            LogUtil.i("runTestSocket: $resultStr   \n ${res.joinToString()}")
            try {
                val resultObject = JSONObject(resultStr)
                val method = resultObject.optString("method")
                val code = resultObject.optString("code")
                if (method == "last_fail_code") {
                    callback(true, code, isMain, block)
                    return@sendSocket true
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            callback(false, null, isMain, block)
            return@sendSocket true
        }
    }

    /**
     * 获取配网的日志内容
     * HEAD: 8Byte， 固定"DREAMEEE"
     * MD5SUM: 32Byte，日志文件md5值
     * PAYLOAD_LEN: 4Byte，int32，日志文件长度
     * PAYLOAD: 日志文件主体内容 压缩包
     */
    private var logFile: File? = null
    fun socketReadRobotLastFailLog(ip: String, port: Int, isMain: Boolean = false, block: (result: Boolean, msg: String?) -> Unit) {
        val jsonObject = JSONObject()
        jsonObject.put("method", "last_fail_log")
        val toByteArray = jsonObject.toString().toByteArray()
        val byteList = mutableListOf<Byte>()
//        val header = "DREAMEEE"
        var payloadLen = 0
        var payloadMd5 = ""
        var timestamp = SystemClock.elapsedRealtime()
        sendSocket(ip, port, toByteArray, isMain, block) { res ->
            LogUtil.d("socketReadRobotLastFailLog: ${res.formatHexString()}")
            if (res.size == 44 &&
                res[0].toInt().toChar() == 'D'
                && res[1].toInt().toChar() == 'R'
                && res[2].toInt().toChar() == 'E'
                && res[3].toInt().toChar() == 'A'
                && res[4].toInt().toChar() == 'M'
                && res[5].toInt().toChar() == 'E'
                && res[6].toInt().toChar() == 'E'
                && res[7].toInt().toChar() == 'E'
            ) {
                timestamp = SystemClock.elapsedRealtime()
                byteList.clear()
                payloadMd5 = String(res.copyOfRange(8, 40)).uppercase()
                payloadLen = res.copyOfRange(40, 44).byteArrayToInt()
                LogUtil.d("socketReadRobotLastFailLog: payloadMd5: $payloadMd5} ,payloadLen: ${payloadLen}")
                if (payloadLen != 0) {
                    logFile = File(logFileParent, "last_fail_log.tar.gz")
                    if (logFile?.exists() == true) {
                        logFile?.delete()
                    } else {
                        logFile?.createNewFile()
                    }
                }
                return@sendSocket false

            } else {
                logFile?.appendBytes(res)
                byteList.addAll(res.toList())
            }
            if (byteList.size == payloadLen) {
                timestamp = 0
                // 校验md5
                val bytes = byteList.toByteArray()
                val encryptMD5 = EncryptUtils.encryptMD5ToString(bytes)
                if (encryptMD5 == payloadMd5) {
                    callback(true, logFile?.path, true, block)
                    // success
                } else {
                    callback(false, null, true, block)
                }
                return@sendSocket true
            } else if (res.size < buff.size) {
                // 结束
                callback(false, null, true, block)
                return@sendSocket true
            } else {
                // wait

            }
            return@sendSocket false
        }
    }

    private var datagramSocket: DatagramSocket? = null
    val buff by lazy { ByteArray(64 * 1024) }
    private fun testDatagramSocket() {
        if (datagramSocket == null
            || !(datagramSocket?.isConnected == true)
            || !(datagramSocket?.isClosed == true)
        ) {
            val socket = DatagramSocket()
            socket.soTimeout = 2 * 1000
            socket.broadcast = true
            socket.reuseAddress = true
            datagramSocket = socket
        }
    }

    /**
     * @param ip
     * @param port
     * @param contents
     * @param isMain
     * @param block
     * @param handleReceiveMsg
     */
    private fun sendSocket(
        ip: String, port: Int, contents: ByteArray, isMain: Boolean = false,
        block: (result: Boolean, msg: String?) -> Unit,
        handleReceiveMsg: (res: ByteArray) -> Boolean,
    ) {
        workHandler.post {
            try {
                testDatagramSocket()
                val inetAddress = InetSocketAddress(ip, port)
                datagramSocket?.send(DatagramPacket(contents, contents.size, inetAddress))
                val pack = DatagramPacket(buff, buff.size)
                while (true) {
                    datagramSocket?.receive(pack)
                    val res = Arrays.copyOf(buff, pack.length)
                    LogUtil.i(TestSocketCanConnect::class.simpleName, "onReceive:  ${res.joinToString()}")
                    val receiveMsg = handleReceiveMsg(res)
                    if (receiveMsg) {
                        break
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("runTestSocket: ${Log.getStackTraceString(e)}")
                //  ENETUNREACH (Network is unreachable) 网络切换时候，等一下重试
                callback(false, e.message ?: "", isMain, block)
                return@post
            }
        }
    }


    fun callback(result: Boolean, msg: String?, isMain: Boolean = false, block: (result: Boolean, msg: String?) -> Unit) {
        if (isMain) {
            mainHandler.post {
                block(result, msg)
            }
        } else {
            block(result, msg)
        }
    }
}