
package com.dreame.feature.connect.config.step.bluetooth

import android.bluetooth.BluetoothDevice
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.StepBleConnectDevice
import android.dreame.module.util.LogUtil
import android.os.Message
import android.os.SystemClock
import android.text.TextUtils
import com.dreame.feature.connect.scan.DeviceScanCache
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.*
import com.dreame.smartlife.config.step.callback.IBleScanCallBack

/**
 * # 蓝牙扫描
 * 1.扫描设备热点并连接,10s一次,持续6次(共1min),找到后停止轮询
 * 成功:热点连接 [StepConnectDeviceAP]
 * 失败:手动连接 [StepManualConnect]
 * 2.监听网络变化,用户可能会手动连接wifi
 * 成功:连接状态二次确认 [StepConnectCheck]
 */
class StepBleScan : SmartStepConfig() {

    @Volatile
    private var isScanRunning = true

    override fun stepName(): Step = Step.STEP_DEVICE_SCAN_BLE

    override fun handleMessage(msg: Message) {
    }

    /**
     * 设备缓存超时时间
     */
    companion object {
        private const val DEVICE_CACHE_TIME = 1 * 1000 * 30
    }

    override fun stepCreate() {
        super.stepCreate()
        LogUtil.i("stepCreate: StepBleScan")
        // 尝试连接一次， 如果连接成功，则不开启扫描
        val elapsedRealtime = SystemClock.elapsedRealtime()
        val timestamp = StepData.bleDeviceWrapper?.timestamp ?: 0
        val overTime = elapsedRealtime - timestamp
        LogUtil.i("stepCreate: StepBleScan  cacheTime: ${timestamp} ,overdue: ${overTime / 1000}")
        if (StepData.bleDeviceWrapper != null) {
            if (overTime < DEVICE_CACHE_TIME) {
                connectDeviceDirectly()
                return
            }
        }
        startScan()
    }

    private val bleConnectStep by lazy { StepBleConnectDevice() }

    /**
     * 直接连接
     */
    private fun connectDeviceDirectly() {
        LogUtil.i("connectDeviceDirectly: ")
        StepData.connectStartTime = SystemClock.elapsedRealtime();
        StepData.pairNetMethod = 2
        bleConnectStep.connectDeviceDirectly(context) {
            if (it) {
                LogUtil.i("connectDeviceDirectly: success ")
                //
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_CONNECT, StepState.SUCCESS)
                })
                nextStep(Step.STEP_SETTING_CHECK_BLE)
            } else {
                LogUtil.i("connectDeviceDirectly: fail ")
                startScan()
            }
        }

    }

    private fun startScan() {
        // 开启扫描
        BleDeviceScanner.startScan(callback = bleCallback)
    }

    private fun filterDevice(
        device: BluetoothDevice,
        scanRecord: ByteArray,
        rssi: Int,
        result: String
    ) {
        val pair = DeviceScanCache.parseBleScanResult(result)
        if (pair == null) {
            return
        }
        val productId = pair.first
        val mac = pair.second
        LogUtil.i(
            TAG,
            "蓝牙设备: ${device.name} ,address: ${device.address}  ,result: $result    ,productMode: $productId ，StepData.productId=${StepData.productId} ,StepData.productModel=${StepData.productModel} ,scanRecord: ${scanRecord.contentToString()} "
        )
        // 蓝牙扫描到 productId, 可能存在调试的机器 productModel
        //
        if (TextUtils.equals(StepData.productId, productId)
            || TextUtils.equals(StepData.productModel, productId)
            || StepData.productIds.contains(productId)
        ) {

            if (!filterTargetDevice(result)) {
                return
            }

            isScanRunning = false
            // 如果扫描到设备， 下一步连接
            if (StepData.stepMode == StepData.StepMode.MODE_SCANNING) {
                StepData.stepMode = StepData.StepMode.MODE_BLE
                LogUtil.i("StepBleScan filterDevice change current mode is : ${StepData.stepMode}")
            }
            BleDeviceScanner.removeScanCallback(bleCallback)
            if (StepData.bleDeviceWrapper == null) {
                StepData.bleDeviceWrapper
            }
            StepData.bleDeviceWrapper?.deviceWrapper = BluetoothDeviceWrapper(
                result,
                device,
                scanRecord,
                rssi,
                SystemClock.elapsedRealtime()
            )
            if (StepData.productIdModelMap.isNotEmpty()) {
                StepData.productModel = StepData.productIdModelMap.get(productId) ?: StepData.productModel
            }
            nextStep(Step.STEP_CONNECT_DEVICE_BLE)
        }
    }

    private fun filterTargetDevice(result: String): Boolean {
        if (StepData.productWifiName.isNotEmpty() && StepData.isForceFilter) {
            // 判断是否是目标设备
            val index = StepData.productWifiName.indexOf("_miap")
            LogUtil.i(TAG, "filterTargetDevice: ${StepData.productWifiName}  $index   ${StepData.productWifiName.substring(index + 5)}")

            if (index != -1) {
                val macLast4 = StepData.productWifiName.substring(index + 5)
                return result.replace(":", "").endsWith(macLast4, true)
            }
            return false
        }
        return true
    }

    override fun stepDestroy() {
        BleDeviceScanner.stopScan()
    }

    private val bleCallback = object : IBleScanCallBack {
        override fun onScanResult(device: BluetoothDevice, scanRecord: ByteArray, rssi: Int, result: String) {
            LogUtil.i("bleCallback onScanResult: --------")
            getHandler().post {
                filterDevice(device, scanRecord, rssi, result)
            }
        }

        override fun onComplete() {
            LogUtil.i("bleCallback onComplete: --------")
            // nextStep, 切换成Wi-Fi扫描
            if (isScanRunning) {
                getHandler().sendMessage(Message.obtain().apply {
                    obj = StepResult(StepName.STEP_CONNECT, StepState.FAILED, stepId = StepId.STEP_DEVICE_SCAN_BLE, reason = "scan nothing")
                })
                if (StepData.stepModeDefault == StepData.StepMode.MODE_BOTH) {
                    nextStep(Step.STEP_MANUAL_CONNECT)
                } else if (StepData.stepModeDefault == StepData.StepMode.MODE_BLE){
                    // TODO: 蓝牙配网

                }
            }
        }
    }
}