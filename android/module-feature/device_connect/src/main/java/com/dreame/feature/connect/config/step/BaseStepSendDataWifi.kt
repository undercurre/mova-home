package com.dreame.smartlife.config.step

import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.LogUtil
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.os.Build
import android.os.Message
import android.os.SystemClock
import android.util.Log
import androidx.core.text.isDigitsOnly
import com.dreame.android.netlibrary.externs.connectivityManager
import com.dreame.feature.connect.config.step.udp.UdpClientConfig
import com.dreame.feature.connect.config.step.udp.UdpMsg
import com.dreame.feature.connect.config.step.udp.XUdp
import com.dreame.feature.connect.config.step.udp.listener.UdpClientListener
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.feature.connect.trace.EventConnectPageHelper
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.udp.TargetInfo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import org.json.JSONException
import org.json.JSONObject

/**
 * # 通过wifi发数据到设备
 * udp数据传输,轮询15次,2s一次,bindSocket并发request_connection,
 *  1)发送成功,设备响应,停止轮询,发下一条消息
 *  2)如果自动切换到其他网络,手动连接 [StepManualConnect]
 * 成功:检查设备pair状态 [StepCheckDevicePairState]
 * 失败:
 *  1)可以重试:wifi扫描 [StepWifiScan]
 *  2)重试失败:手动连接 [StepManualConnect]
 *
 *  需求：https://jira.dreame.tech/browse/VERR2338-59
 *  enum PAIR_FAIL_CODE {
 *     CODE_NONE      = 0,    // 未记录原因
 *     CODE_PAIRED    = 1,    // 已配网成功
 *     CODE_UNBURN    = 2,    // 未烧号
 *     CODE_WHITELIST = 3,    // 未加白名单
 *     CODE_NETWORK   = 4,    // 外网不通而访问不到服务器
 *     CODE_EMQ_LINE  = 5,    // 外网通但访问不到服务器
 *     CODE_MQTT_404  = 404,  // 其他MQTT原因
 *
 *     CODE_WRONG_PASSWD = 101,  // 密码错误
 *     CODE_SSID_UNFOUND = 102,  // 未扫描到SSID
 *     CODE_NO_IP        = 103,  // 未分配到IP
 *     CODE_WIFI_404     = 120,  // 其他无法连接路由器情况
 * };
 *
 */
abstract class BaseStepSendDataWifi : SmartStepConfig() {
    companion object {
        const val REQUEST_NET_FAIL = 14001
        const val REQUEST_NET_SUCCESS = 14002
        const val REQUEST_NET_FINISH = 14003
        const val AP_PORT = 44321
        const val AP_IP = "192.168.5.1"

        private const val ERROR_SOCKET_MAX = 10

        const val STEP_SEND_DEFAULT = 0
        const val STEP_SEND_LAST_FAIL_CODE = 1
        const val STEP_SEND_LAST_FAIL_CODE_FINISH = 2
        const val STEP_SEND_LAST_FAIL_LOG = 3
        const val STEP_SEND_LAST_FAIL_LOG__FINISH = 4

        const val STEP_SEND_CONNECT_START = 10
        const val STEP_SEND_QUERY_SUCCESS = 98
        const val STEP_SEND_SETTING_SUCCESS = 99
        const val STEP_SEND_FINISH = 100
    }

    protected var connectionReqJob: Job? = null
    var udpMsgStep: UdpMsg? = null

    // 记录socket 错误次数，
    private var errorCount = 0

    // 保存服务端的密钥
    private var serverKeyValue: String? = null

    /**
     * 配网参数组装
     */
    private val sendDataParam by lazy { SendDataParam() }

    private var networkCallback: ConnectivityManager.NetworkCallback? = null

    /**
     * 发送数据
     */
    private var sendStep: Int = STEP_SEND_DEFAULT

    /**
     * 机器
     */
    private var lost_model = ""
    private var lost_fail_code = ""

    private val udpClient by lazy {
        XUdp.getUdpClient().apply {
            config(
                UdpClientConfig.Builder()
                    .setReceiveTimeout(5000L)
                    .create()
            )
        }
    }

    private val targetInfo by lazy { TargetInfo(AP_IP, AP_PORT) }
    private val udpClientListener by lazy {
        object : UdpClientListener {
            override fun onStarted(xUdp: XUdp) {
                LogUtil.i(TAG, "onStarted: ")
            }

            override fun onStoped(xUdp: XUdp) {
                LogUtil.i(TAG, "onStoped: ")
            }

            override fun onSended(xUdp: XUdp, udpMsg: UdpMsg) {
                LogUtil.i(TAG, "onSended: ${udpMsg}")
//                if (udpMsg.sourceDataString == null) {
//                    udpClient.closeSocket()
//                }
            }

            override fun onReceive(xUdp: XUdp, udpMsg: UdpMsg) {
                LogUtil.i(TAG, "onReceive: response json is: ${udpMsg.sourceDataString}")
                try {
                    val resultJson = JSONObject(udpMsg.sourceDataString)
                    val method = resultJson.getString("method")
                    if ("response_connection" == method) {
                        sendStep = STEP_SEND_QUERY_SUCCESS
                        connectionReqJob?.cancel("connect success").also { connectionReqJob = null }
                        val deviceId = resultJson.optString("did")
                        val value = resultJson.optString("value")
                        // step 1 success
                        StepData.deviceId = deviceId
                        serverKeyValue = value

                        val routerReq = sendDataParam.configureRouterParam(deviceId, value)
                        LogUtil.i(
                            TAG,
                            "onReceive: router request: StepData.deviceId: ${StepData.deviceId}  ,serverKeyValue: $serverKeyValue  ,routerReq: $routerReq  -----  ${routerReq.toByteArray().size}"
                        )
                        val udpMsgStep = UdpMsg(routerReq.toByteArray(), targetInfo, UdpMsg.MsgType.Send)
                        udpClient.sendMsg(udpMsgStep, true)
                    } else if ("response_router" == method) {
                        sendStep = STEP_SEND_SETTING_SUCCESS
                        udpClient.stopUdpServer()
                        udpClient.closeSocket()
                        LogUtil.i(TAG, "onReceive: router request success, to next step")
                        // step 2 成功
                        sendDataSuccess()
                    }
                } catch (e: JSONException) {
                    EventConnectPageHelper.insertStepErrorEntity(3, 0, "JSONException", Log.getStackTraceString(e))
                    e.printStackTrace()
                    LogUtil.e(TAG, "onReceive parse json error, json: ${udpMsg.sourceDataString}")
                    sendDataError()
                }
            }

            override fun onError(xUdp: XUdp, s: String, e: Exception?) {
                // Network is unreachable
                EventConnectPageHelper.insertStepErrorEntity(2, 0, "UdpException", Log.getStackTraceString(e));
                LogUtil.e(TAG, "udpClientListener onError: stepRunning: $stepRunning  $s  -----  ${e?.localizedMessage} ")
                if (!stepRunning) {
                    return
                }
                e?.localizedMessage?.run {
                    if (contains("ENETUNREACH") || contains("ENONET") || contains("ECONNABORTED")) {
                        errorCount++
                    }
                    if (errorCount >= ERROR_SOCKET_MAX) {
                        retryFail()
                    }
                }
            }
        }
    }

    open fun isCheckDeviceWifi(): Boolean = true

    override fun handleMessage(msg: Message) {
        if (!stepRunning) {
            return
        }
        LogUtil.d(TAG, "handleMessage ${msg.what}")
        when (msg.what) {
            CODE_STEP_CREATE -> {
                createStep()
            }

            REQUEST_NET_SUCCESS -> {
                runSendConnectionJob()
            }

            REQUEST_NET_FAIL -> {
                sendDataError()
            }

            REQUEST_NET_FINISH -> {
                retryFail()
            }
        }
    }

    override fun stepCreate() {
        super.stepCreate()
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.START)
        })
        getHandler().sendEmptyMessage(CODE_STEP_CREATE)
    }

    private fun createStep() {
        udpClient.addUdpClientListener(udpClientListener)
        // 防止在bindWifiSocket第一次获取的socket为null
        LogUtil.i(TAG, "createStep testSocketConnect ${StepData.productModel}")
        if (StepData.deviceApName.contains("mova-vacuum-") || StepData.productWifiName.contains("mova-vacuum-")
            || StepData.deviceApName.contains("dreame-vacuum-") || StepData.productWifiName.contains("dreame-vacuum-")
            || StepData.deviceApName.contains("trouver-vacuum-") || StepData.productWifiName.contains("trouver-vacuum-")
        ) {
            // 扫地机
            sendStep = STEP_SEND_LAST_FAIL_CODE
            socketReadRobotLastFailCode()
        } else {
            sendStep = STEP_SEND_CONNECT_START
            getHandler().sendEmptyMessage(REQUEST_NET_SUCCESS)
        }
        if (!WifiDeviceScanner.isOpen()) {
            gotoNextManualStep()
            return
        }
        // Android 6.0 华为R10上 报权限问题
        // <p> 错误：
        //    java.lang.SecurityException:xx was not granted either of these permissions: android.permission.CHANGE_NETWORK_STATE，android.permission.WRITE_SETTING
        //    原因： Android6.0上默认CHANGE_NETWORK_STATE未授权，需跳转权限页面授权。调用ConnectivityManager.requestNetwork,报错
        //    解决方案： 此处使用使用旧的，不可靠的配网方式
        // </p>
        // ，要么跳转页面
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M) {
            // 指定udp请求只在设备热点网络上传输
//            getHandler().sendEmptyMessage(REQUEST_NET_SUCCESS)
        } else {
            bindSocketBeforeM()
        }
    }

    protected open fun gotoNextManualStep(reason: String = "") {
        LogUtil.i(TAG, "gotoNextManualStep: $reason")
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.FAILED, stepId = StepId.STEP_SEND_DATA_WIFI, reason = reason)
        })
        connectivityManager.bindProcessToNetwork(null)
        nextStep(Step.STEP_MANUAL_CONNECT)
    }

    private fun bindSocketBeforeM() {
        // 尽快尝试发送数据,避免wifi被自动切换
        launch(Dispatchers.IO) {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                    val connectivityManager = context.connectivityManager()
                    val allNetworks = connectivityManager.allNetworks
                    allNetworks.filter { network ->
                        val networkInfo = connectivityManager.getNetworkInfo(network)
                        networkInfo?.state == NetworkInfo.State.CONNECTED && networkInfo.type == ConnectivityManager.TYPE_WIFI
                    }.takeIf {
                        it.isNotEmpty()
                    }?.first()
                        ?.run {
                            bindSocket(udpClient.datagramSocket)
                        }
                }
                // send request
                getHandler().sendEmptyMessage(REQUEST_NET_SUCCESS)
            } catch (e: Exception) {
                LogUtil.e(TAG, "connectivityManager.allNetworks: bind socket error cause fail, $e")
                // fix：DatagramSocket is null, 下次切换网络后，重新创建DatagramSocket
                if (e is NullPointerException && e.message?.contains("null cannot be cast to non-null type java.net.DatagramSocket") == true) {
                    // 防止在bindWifiSocket第一次获取的socket为null
                    Log.d(TAG, "reconnect socket ")
                }
                // 空指针可能是网络无效，无法建立连接，直接走手动配网
                getHandler().sendEmptyMessage(if (e is NullPointerException) REQUEST_NET_FINISH else REQUEST_NET_FAIL)
            }
        }
    }

    private fun runSendConnectionJob() {
        connectionReqJob = launch {
            // 尽快尝试发送数据,避免wifi被自动切换
            sendConnectionReq()
            (0 until 15).asFlow().onEach {
                delay(2000)
            }.flowOn(Dispatchers.IO).collect {
                sendConnectionReq()
            }
            // send connection request fail
            LogUtil.i(TAG, "connectionReqJob: send connection request max retry fail")
            testSocketConnect { success, msg ->
                EventConnectPageHelper.insertStepErrorEntity(
                    4,
                    if (success) 1 else 0,
                    "retryException",
                    "connectionReqJob: send connection request max retry fail"
                )
            }
            delay(2000)
            sendDataError()
        }
    }

    override fun stepDestroy() {
        // 配网
        disconnectWifi()

        networkCallback?.let {
            runCatching {
                // IllegalArgumentException: NetworkCallback was already unregistered
                connectivityManager.unregisterNetworkCallback(it)
                networkCallback = null
            }.onFailure {
                LogUtil.e(TAG, "stepDestroy: ${Log.getStackTraceString(it)}")
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            connectivityManager.bindProcessToNetwork(null)
        }

        connectionReqJob?.cancel("stepDestroy").also { connectionReqJob = null }
        udpClient.removeUdpClientListener(udpClientListener)
        udpClient.closeSocket()
        udpClient.stopUdpServer()
    }

    override fun registerNetChange() = true

    override fun handleNetChangeEvent(connectedSsid: String) {
        // 手机wifi助理会自动断开无网络的wifi,发udp时需要注意
        if (sendStep >= STEP_SEND_SETTING_SUCCESS) {
            //
            sendDataSuccess()
            return
        }
        if (!isDeviceWifi(connectedSsid, isSkipCheck = true)) {
            LogUtil.i(TAG, "handleNetChangeEvent: net change cause error")
            retryFail()
        }
    }

    private fun sendConnectionReq() {
        if (StepData.deviceId.isNotBlank() && serverKeyValue != null) {
            LogUtil.i(
                TAG,
                "sendData sendConnectionReq connection request json: deviceId: ${StepData.deviceId} ,serverKeyValue: $serverKeyValue "
            )
            val routerReq = sendDataParam.configureRouterParam(StepData.deviceId, serverKeyValue)
            val udpMsgStep = UdpMsg(routerReq.toByteArray(), targetInfo, UdpMsg.MsgType.Send)
            udpClient.sendMsg(udpMsgStep, true)
        } else {
            val requestConnectionParam = sendDataParam.requestConnectionParam()
            LogUtil.i(TAG, "sendData connection request json: $requestConnectionParam")
            udpClient.config(UdpClientConfig.Builder().setLocalPort(AP_PORT).create())
            udpMsgStep = UdpMsg(requestConnectionParam.toByteArray(), targetInfo, UdpMsg.MsgType.Send)
            udpClient.sendMsg(udpMsgStep, true)
            LogUtil.i(
                TAG,
                "sendData sendConnectionReq connection request json2: deviceId: ${StepData.deviceId}   ,serverKeyValue:  $serverKeyValue  ,data: ${udpMsgStep?.sourceDataString} "
            )
        }
    }

    private fun sendDataSuccess() {
        val costTime = SystemClock.elapsedRealtime() - time
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.UdpTransport.code, hashCode(),
            StepData.deviceId, StepData.deviceModel(),
            int1 = 1, int2 = (costTime / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID(),
            // 上次配网方式，上一次配网code
            str2 = lost_model, str3 = lost_fail_code
        )
        connectionReqJob?.cancel("stepDestroy").also { connectionReqJob = null }
        getHandler().removeMessages(REQUEST_NET_FAIL)
        getHandler().sendMessage(Message.obtain().apply {
            obj = StepResult(StepName.STEP_TRANSFORM, StepState.SUCCESS)
        })
        resetRetryCount(stepName())
        nextStep(Step.STEP_CHECK_DEVICE_PAIR_STATE)
        sendStep = STEP_SEND_FINISH
    }

    open fun sendDataError() {
        LogUtil.i("--------------- udp数据发送失败 ---------------")
        cancel("udp数据发送失败")
        udpClient.closeSocket()
        udpClient.stopUdpServer()
        if (canRetryStep(stepName())) {
            updateRetryCount(stepName())
            if (isGrantedPermission(permissionList)) {
                nextStep(Step.STEP_MANUAL_CONNECT)
            } else {
                retryFail()
            }
        } else {
            // 第二步失败
            retryFail()
        }
    }

    open fun retryFail() {
        val costTime = SystemClock.elapsedRealtime() - time
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.UdpTransport.code, hashCode(),
            StepData.deviceId, StepData.deviceModel(),
            int1 = 0, int2 = (costTime / 1000).toInt(), str1 = BuriedConnectHelper.currentSessionID(),
            // 上次配网方式，上一次配网code
            str2 = lost_model, str3 = lost_fail_code
        )
        LogUtil.d("--------------- retryFail ---------------")
        resetRetryCount(stepName())
        gotoNextManualStep("retry fail")
    }

    private fun testSocketConnect(block: (success: Boolean, msg: String?) -> Unit) {
        udpClient.testSocketConnect(targetInfo) { success, msg ->
            block(success, msg)
        }
    }

    private fun socketReadRobotLastFailCode() {
        sendStep = STEP_SEND_LAST_FAIL_CODE
        lost_model = ""
        lost_fail_code = ""
        udpClient.socketReadRobotLastFailCode(targetInfo) { success, msg ->
            sendStep = STEP_SEND_LAST_FAIL_CODE_FINISH
            LogUtil.i(TAG, "createStep socketReadRobotLastFailCode: $success ,smg: $msg")
            if (!success) {
                // 是否打开流量
                sendStep = STEP_SEND_CONNECT_START
                EventConnectPageHelper.insertStepErrorEntity(1, 0, "TEST", msg ?: "")
                getHandler().sendEmptyMessage(REQUEST_NET_SUCCESS)
            } else {
                // {"method":"last_fail_code","code":"120_xxx"}    code
                lost_model = ""
                lost_fail_code = msg
                handleLastFailCode(msg ?: "")
                //
                if ("0" == msg) {
                    sendStep = STEP_SEND_CONNECT_START
                    getHandler().sendEmptyMessage(REQUEST_NET_SUCCESS)
                } else {
                    sendStep = STEP_SEND_LAST_FAIL_LOG
                    udpClient.socketReadRobotLastFailLog(targetInfo) { success, msg ->
                        sendStep = STEP_SEND_CONNECT_START
                        getHandler().sendEmptyMessage(REQUEST_NET_SUCCESS)
                        //
                    }
                }
            }
        }
    }

    private fun handleLastFailCode(msg: String) {
        if (msg.contains("_")) {
            val split = msg.split("_")
            val int1 = if (split[0].isDigitsOnly()) {
                split[0].toInt()
            } else {
                -1
            }
            val int2 = if (split.size >= 2) {
                if (split[1].isDigitsOnly()) {
                    split[1].toInt()
                } else {
                    -1
                }
            } else {
                -1
            }
            EventCommonHelper.eventCommonPageInsert(8, 3, "", "", int1, int2, msg)
        } else {
            val int1 = if (msg.isDigitsOnly()) {
                msg.toInt()
            } else {
                -1
            }
            EventCommonHelper.eventCommonPageInsert(8, 3, "", "", int1, 0, msg)
        }
    }
}