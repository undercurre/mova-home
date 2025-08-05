package android.dreame.module.rn.bridge.device

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.feature.connect.bluetooth.mower.BleOperatorRnCallback
import android.dreame.module.feature.connect.bluetoothv2.BleManagerImpl
import android.dreame.module.feature.connect.bluetoothv2.BleScannerMangerImpl
import android.dreame.module.feature.connect.bluetoothv2.BluetoothUUIDUtils
import android.dreame.module.feature.connect.bluetoothv2.MyBleConnectStateManager
import android.dreame.module.rn.RNDebugActivity
import android.dreame.module.rn.load.RnActivity
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import android.dreame.module.util.ThrottleUtils
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import kotlinx.coroutines.MainScope
import java.util.UUID

/**
 * 蓝牙模块
 */
open class BluetoothModuleV2(val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    override fun getName(): String = "DMBleManager"

    private val bleScanner by lazy { BleScannerMangerImpl(reactContext) }
    private val bleManagerImpl by lazy { BleManagerImpl(reactContext) }

    private val mHandler by lazy { Handler(Looper.getMainLooper()) }

    override fun initialize() {
        super.initialize()
        LogUtil.i("-----BluetoothModuleV2 initialize------")
    }

    override fun invalidate() {
        super.invalidate()
        LogUtil.i("-----BluetoothModuleV2 invalidate------")
    }

    override fun onCatalystInstanceDestroy() {
        LogUtil.i("----- onCatalystInstanceDestroy disconnectAndCloseAll start ------")
        bleScanner.stopScan(isDispose = true)
        MyBleConnectStateManager.disconnectAndCloseAll()
        LogUtil.i("----- onCatalystInstanceDestroy disconnectAndCloseAll end ------")
        super.onCatalystInstanceDestroy()
    }

    /**
     * 判断蓝牙是否开放,如果没打开
     */
    @ReactMethod
    fun checkBluetoothIsEnabled(callback: Callback) {
        LogUtil.d("checkBluetoothIsEnabled")
        mHandler.post {
            bleScanner.checkBluetoothIsEnabled(BleOperatorRnCallback(callback))
        }
    }

    @ReactMethod
    fun startScan(
        durationInMillis: Int,
        serviceUUIDs: ReadableArray,
        allowDuplicates: Boolean = false,
        options: ReadableMap
    ) {
        val serviceUUIDList = serviceUUIDs.toArrayList().map {
            it as String
        }.map {
            BluetoothUUIDUtils.uuid16To128Complete(it)
        }
        mHandler.post {
            bleScanner.startScan(durationInMillis, serviceUUIDList, allowDuplicates, options)
        }
    }

    @ReactMethod
    fun stopScan() {
        LogUtil.i("stopScan")
        mHandler.post {
            bleScanner.stopScan()
        }
    }

    @ReactMethod
    fun readRSSI(mac: String, callback: Callback) {
//        LogUtil.i("readRemoteRssi $mac")
        mHandler.post {
            bleManagerImpl.readRemoteRssi(BleOperatorRnCallback(callback))
        }
    }

    @ReactMethod
    fun readReliableMTU(mac: String, callback: Callback) {
        LogUtil.i("readReliableMTU $mac")
        mHandler.post {
            bleManagerImpl.readReliableMTU(BleOperatorRnCallback(callback))
        }
    }

    @ReactMethod
    fun connect(type: Int, pincode: Int, mac: String, options: ReadableMap, callback: Callback) {
        val timeout = if (options.hasKey("timeout")) {
            options.getInt("timeout")
        } else {
            20 * 1000
        }.toLong()

        LogUtil.d("connect $type $timeout $mac $options")
        if (mac.isNullOrBlank()) {
            callback.invoke(false, "connect device need mac")
        } else {
            val device = bleScanner.bluetoothDeviceMap[mac]
            if (device != null) {
                val bleManager = MyBleConnectStateManager.getBleManager(mac)
                if (bleManager == null) {
                    MyBleConnectStateManager.pushBleManager(mac, bleManagerImpl)
                }
                mHandler.post {
                    /// 如果此时RNActivity 已经销毁,则不再连接
                    val activity = ActivityUtil.getInstance().topActivity
                    val isRN = activity is RnActivity || activity is RNDebugActivity
                    if (activity == null || activity.isFinishing || activity.isDestroyed || !isRN) {
                        LogUtil.e("connect fail, activity is null, topActivity:$activity")
                        callback.invoke(false, "connect fail, activity is null")
                        return@post
                    }
                    bleManagerImpl.realConnectDevice(
                        device,
                        timeout,
                        pincode,
                        BleOperatorRnCallback(callback)
                    )
                }
            } else {
                callback.invoke(false, "connect fail, bluetooth is null")
            }
        }
    }


    @ReactMethod
    fun setMtu(mac: String, mtu: Int, callback: Callback) = with(BleOperatorRnCallback(callback)) {
        LogUtil.i("zzb setMtu mac = $mac  mtu=$mtu ")

        if (mtu !in 23..517) {
            failedWithArgs(-1, -1, "mac = $mac mtu must in 23-517")
            return@with
        }

        val bleManager = MyBleConnectStateManager.getBleManager(mac)
        if (bleManager == null)
            failedWithArgs(-1, -1, "mac = $mac bleManager is null")
        else
            bleManager.setMtu(mtu, this)
    }

    @ReactMethod
    fun disconnect(mac: String, delay: Int, force: Boolean) {
        LogUtil.i("disconnect $mac  $delay $force")
        realDisconnectDevice(mac);
    }

    val realDisconnectDevice =
        ThrottleUtils.throttleFirst<String>(intervalMs = 100, coroutineScope = MainScope()) { mac ->
            LogUtil.i("----- disconnect realDisconnectDevice start ------")
            bleManagerImpl.realDisconnectDevice(mac)
            LogUtil.i("----- disconnect realDisconnectDevice end ------")
            MyBleConnectStateManager.removeBleManager(mac)
        }

    @ReactMethod
    fun startDiscoverServices(mac: String, services: ReadableArray) {
        LogUtil.d("startDiscoverServices $mac $services")
        val serviceUUIDList = services.toArrayList().map {
            it as String
        }.map {
            BluetoothUUIDUtils.uuid16To128Complete(it)
        }.map {
            UUID.fromString(it)
        }
        mHandler.post {
            bleManagerImpl.startDiscoverServices(serviceUUIDList)
        }
    }

    @ReactMethod
    fun startDiscoverCharacteristics(
        mac: String,
        servicesUUID: String,
        charactersArray: ReadableArray
    ) {
        LogUtil.d(
            "startDiscoverCharacteristics $mac  $servicesUUID  ${
                charactersArray.toArrayList().joinToString()
            }"
        )
        val servicesUUIDs = BluetoothUUIDUtils.uuid16To128Complete(servicesUUID)
        val charactersList = charactersArray.toArrayList().map {
            it as String
        }.map {
            BluetoothUUIDUtils.uuid16To128Complete(it)
        }
        mHandler.post {
            bleManagerImpl.startDiscoverCharacteristics(servicesUUIDs, charactersList)
        }
    }

    @ReactMethod
    fun read(mac: String, serviceUUID: String, characteristicUUID: String, callback: Callback) {
        LogUtil.d("read $mac $serviceUUID  $characteristicUUID")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        mHandler.post {
            bleManagerImpl.readData(sUUID, cUUID, BleOperatorRnCallback(callback))
        }
    }

    @ReactMethod
    fun writeData(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        dataArray: ReadableArray,
        maxByteSize: Int,
        callback: Callback
    ) {
        LogUtil.d("writeData $mac $serviceUUID  $characteristicUUID $dataArray $maxByteSize")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        val toTypedArray = dataArray.toArrayList().map {
            if (it is Number) {
                it.toByte()
            } else if (it is String) {
                it.toInt(16).toByte()
            } else {
                0.toByte()
            }
        }.toByteArray()
        mHandler.post {
            bleManagerImpl.writeData(
                sUUID, cUUID, toTypedArray,
                BleOperatorRnCallback(callback)
            )
        }
    }

    @ReactMethod
    fun writeWithoutResponse(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        dataArray: ReadableArray,
        maxByteSize: Int,
        type: Int,
        callback: Callback
    ) {
        LogUtil.d("writeWithoutResponse $mac $serviceUUID  $characteristicUUID $dataArray $maxByteSize")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        val toTypedArray = dataArray.toArrayList().map {
            if (it is Number) {
                it.toByte()
            } else if (it is String) {
                it.toInt(16).toByte()
            } else {
                0.toByte()
            }
        }.toByteArray()
        mHandler.post {
            bleManagerImpl.writeWithoutResponse(
                sUUID, cUUID, toTypedArray,
                BleOperatorRnCallback(callback)
            )
        }
    }

    @ReactMethod
    fun startNotification(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        callback: Callback
    ) {
        LogUtil.d("startNotification $mac $serviceUUID  $characteristicUUID")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        mHandler.post {
            bleManagerImpl.startNotification(
                sUUID,
                cUUID,
                BleOperatorRnCallback(callback)
            )
        }
    }

    @ReactMethod
    fun stopNotification(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        callback: Callback
    ) {
        LogUtil.d("stopNotification $mac $serviceUUID  $characteristicUUID")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        mHandler.post {
            bleManagerImpl.stopNotification(
                sUUID,
                cUUID,
                BleOperatorRnCallback(callback)
            )
        }
    }

    @ReactMethod
    fun startIndication(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        callback: Callback
    ) {
        LogUtil.d("startNotification $mac $serviceUUID  $characteristicUUID")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        mHandler.post {
            bleManagerImpl.enableIndications(
                sUUID,
                cUUID,
                BleOperatorRnCallback(callback)
            )
        }
    }

    @ReactMethod
    fun stopIndication(
        mac: String,
        serviceUUID: String,
        characteristicUUID: String,
        callback: Callback
    ) {
        LogUtil.d("stopNotification $mac $serviceUUID  $characteristicUUID")
        val sUUID = BluetoothUUIDUtils.uuid16To128Complete(serviceUUID)
        val cUUID = BluetoothUUIDUtils.uuid16To128Complete(characteristicUUID)
        mHandler.post {
            bleManagerImpl.disableIndications(
                sUUID,
                cUUID,
                BleOperatorRnCallback(callback)
            )
        }
    }


    @ReactMethod
    fun enableBluetoothForAndroid(silence: Boolean) {
        LogUtil.d("enableBluetoothForAndroid $silence")

        val granted = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            ActivityCompat.checkSelfPermission(
                reactContext.applicationContext,
                Manifest.permission.BLUETOOTH
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            XXPermissions.isGranted(
                reactContext.applicationContext,
                Permission.BLUETOOTH_CONNECT
            )
        }
        if (granted) {
            try {
                val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
                reactContext.startActivityForResult(intent, 1000,  Bundle())
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("open_bluetooth_crash $e")
            }
        }
    }

}


