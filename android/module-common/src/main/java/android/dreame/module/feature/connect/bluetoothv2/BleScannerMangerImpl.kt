package android.dreame.module.feature.connect.bluetoothv2

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.BuildConfig
import android.dreame.module.LocalApplication
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.BleGattAttributes
import android.dreame.module.feature.connect.bluetooth.mower.BleOperatorRnCallback
import android.dreame.module.feature.connect.bluetooth.mower.event.BluetoothEvent
import android.dreame.module.util.LogUtil
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.ParcelUuid
import android.os.SystemClock
import android.provider.Settings
import androidx.core.app.ActivityCompat
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import no.nordicsemi.android.support.v18.scanner.BluetoothLeScannerCompat
import no.nordicsemi.android.support.v18.scanner.ScanCallback
import no.nordicsemi.android.support.v18.scanner.ScanFilter
import no.nordicsemi.android.support.v18.scanner.ScanResult
import no.nordicsemi.android.support.v18.scanner.ScanSettings
import okhttp3.internal.EMPTY_BYTE_ARRAY
import java.util.UUID

class BleScannerMangerImpl(val reactContext: ReactApplicationContext) {

    private val SCAN_PERIOD_DELAY = 10_000L
    private val SCAN_FIRST_DELAY = 2_000L
    private val SCAN_PERIOD_COUNT = 4

    private val MSG_WHAT_SCAN = 0x10
    private val MSG_WHAT_STOP = 0x11
    private val MSG_WHAT_FINISH = 0x12

    private val locPermission = mutableListOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION)
    private val blePermission = mutableListOf(Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT)

    private val bluetoothManager by lazy { LocalApplication.getInstance().getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager }
    private val bluetoothAdapter by lazy { bluetoothManager.adapter }
    private val bluetoothLeScanner by lazy { BluetoothLeScannerCompat.getScanner() }

    // key:mac,value:
    val bluetoothDeviceMap = mutableMapOf<String, BluetoothDeviceWrapper>()

    // key:mac,value:
    val bleDeviceMap = mutableMapOf<String, Bundle>()

    fun isBluetoothPermissionGranted(): Boolean {
        val requestPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            blePermission
        } else {
            locPermission
        }
        return XXPermissions.isGranted(LocalApplication.getInstance(), requestPermission)
    }

    private var parcelUuid: ParcelUuid? = null
    private val mScanHandler = Handler(Looper.getMainLooper()) {
        when (it.what) {
            MSG_WHAT_STOP -> {
                stopScan()
            }
        }
        return@Handler true
    }

    private val mScanCallback = object : ScanCallback() {
        private fun scanFailedString(value: Int): String {
            return when (value) {
                SCAN_FAILED_ALREADY_STARTED -> "SCAN_FAILED_ALREADY_STARTED"
                SCAN_FAILED_APPLICATION_REGISTRATION_FAILED -> "SCAN_FAILED_APPLICATION_REGISTRATION_FAILED"
                SCAN_FAILED_FEATURE_UNSUPPORTED -> "SCAN_FAILED_FEATURE_UNSUPPORTED"
                SCAN_FAILED_INTERNAL_ERROR -> "SCAN_FAILED_INTERNAL_ERROR"
                SCAN_FAILED_OUT_OF_HARDWARE_RESOURCES -> "SCAN_FAILED_OUT_OF_HARDWARE_RESOURCES"
                SCAN_FAILED_SCANNING_TOO_FREQUENTLY -> "SCAN_FAILED_SCANNING_TOO_FREQUENTLY"
                else -> "UNKNOWN_SCAN_ERROR ($value)"
            }
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            onReceiveNativeEvent(
                BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED, "errorCode:$errorCode,message:${scanFailedString(errorCode)}"
            )
        }

        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            LogUtil.v("BleScannerMangerImpl", "onScanResult $callbackType  $result")
            // 解析
            try {
                // fix: maybe  ScanRecord.mServiceData = null
                val serviceUuids = result.scanRecord?.serviceUuids ?: emptyList()
                val parcelUuidTmp = if (serviceUuids.isNotEmpty()) {
                    ParcelUuid(serviceUuids[0].uuid)
                } else {
                    parcelUuid
                }
                if (parcelUuid == null) {
                    parcelUuid = ParcelUuid(UUID.fromString(BleGattAttributes.CLIENT_CHARACTERISTIC_SERVICE))
                }
                val ret = result.scanRecord?.getServiceData(parcelUuidTmp!!)?.run {
                    String(this)
                }
                if (!ret.isNullOrEmpty() && (ret.startsWith("dreame", false) || ret.startsWith("mova", false))) {
                    mScanHandler.post {
                        // 添加到机器列表页
                        val address = result.device.address
                        onScanResult(callbackType, result, ret, address)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                onReceiveNativeEvent(
                    BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED,
                    "errorCode:-1,message:${e.message}"
                )
            }

        }

    }

    @SuppressLint("MissingPermission")
    private fun onScanResult(callbackType: Int, result: ScanResult, ret: String, mac: String) {
        try {
            val device = result.device
            bluetoothDeviceMap[mac] =
                BluetoothDeviceWrapper(
                    ret,
                    device,
                    result.scanRecord?.bytes ?: EMPTY_BYTE_ARRAY,
                    result.rssi,
                    SystemClock.elapsedRealtime(),
                    true
                )

            // 回调
            val bleDevice = Bundle().apply {
                putString("mac", mac)
                putInt("rssi", result.rssi)
                putBoolean("isConnected", false)
                putString("address", mac)
                putString("name", device.name ?: "")
                putString("serviceData", ret)
                putString("id", mac)
            }
            bleDeviceMap.put(mac, bleDevice)
            val makeNativeMap = Arguments.makeNativeMap(bleDevice)
            onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVERED, makeNativeMap)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    fun checkBluetoothIsEnabled(callback: BleOperatorRnCallback) {
        callback.onSuccess(isEnabled())
    }

    fun isEnabled(): Boolean {
        val isEnable = bluetoothAdapter != null && bluetoothAdapter.isEnabled
        return isEnable && !isHalfOpen()
    }

    /**
     * 蓝牙半开状态
     */
    private fun isHalfOpen(): Boolean {
        val state = Settings.Global.getInt(reactContext.contentResolver, "bluetooth_restricte_state", 0)
        return state == 1
    }

    fun enableBluetoothSilence() {
        val granted = if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            ActivityCompat.checkSelfPermission(
                LocalApplication.getInstance(),
                Manifest.permission.BLUETOOTH
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            XXPermissions.isGranted(LocalApplication.getInstance(), Permission.BLUETOOTH_CONNECT)
        }
        if (granted) {
            val state: Int = Settings.Global.getInt(LocalApplication.getInstance().contentResolver, "bluetooth_restricte_state", 0)
            if (state == 1) {
                val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
                LocalApplication.getInstance().startActivity(intent)
                return
            }
            try {
                bluetoothAdapter.enable()
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("ble enable error $e")
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun startScan(durationInMillis: Int, serviceUUIDs: List<String>, allowDuplicates: Boolean = false, options: ReadableMap) {
        LogUtil.i("startScan $durationInMillis ${serviceUUIDs.joinToString()}  $options")
        bleDeviceMap.clear()
        bluetoothDeviceMap.clear()

        if (bluetoothAdapter != null && bluetoothAdapter.isEnabled) {
            mScanHandler.removeMessages(MSG_WHAT_STOP)
            mScanHandler.sendEmptyMessageDelayed(
                MSG_WHAT_STOP,
                if (durationInMillis.toLong() < 5 * 1000) 5 * 1000 else durationInMillis.toLong()
            )
            if (isBluetoothPermissionGranted()) {
                // 如果 isScanning停止扫描
//                bluetoothLeScanner.flushPendingScanResults(mScanCallback)
                bluetoothLeScanner.stopScan(mScanCallback)

                bluetoothManager.getConnectedDevices(BluetoothProfile.GATT)
                val scanFilterList = serviceUUIDs.map {
                    parcelUuid = ParcelUuid(UUID.fromString(it/*"0000$it-0000-1000-8000-00805f9b34fb"*/))
                    ScanFilter.Builder()
                        .setServiceUuid(parcelUuid)
                        .build()
                }
                val scanSettings = ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_BALANCED)
                    .build()
                bluetoothLeScanner.startScan(scanFilterList, scanSettings, mScanCallback)
            } else {
                onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED, "need bluetooth permission")
            }
        } else {
            onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED, "bluetooth is not enabled")
        }


    }

    fun stopScan(isDispose: Boolean = true) {
        LogUtil.i("real stopScan")
        if (bluetoothAdapter != null && bluetoothAdapter.isEnabled) {
            if (isBluetoothPermissionGranted()) {
                // 如果 isScanning停止扫描
                bluetoothLeScanner.stopScan(mScanCallback)
            }
        }
        onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CONNECTION_STOP_SCAN, Arguments.createMap().apply {
            putInt("status", 0)
        })
    }

    fun onReceiveNativeEvent(eventName: String, event: WritableMap) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("onReceiveNativeEvent: $eventName, map:$event")
        }
        reactContext.getJSModule(RCTDeviceEventEmitter::class.java)
            .emit(eventName, event)
    }

    fun onReceiveNativeEvent(eventName: String, event: String) {
        if (BuildConfig.DEBUG) {
            LogUtil.d("onReceiveNativeEvent: $eventName, map:$event")
        }
        reactContext.getJSModule(RCTDeviceEventEmitter::class.java).emit(eventName, event)
    }

}