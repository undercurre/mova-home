package android.dreame.module.feature.connect.bluetooth.mower.scan

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Intent
import android.content.pm.PackageManager
import android.dreame.module.LocalApplication
import android.dreame.module.feature.connect.bluetooth.mower.BleOperatorRnCallback
import android.dreame.module.feature.connect.bluetooth.mower.MowerBleOperator
import android.dreame.module.feature.connect.bluetooth.mower.event.BluetoothEvent
import android.dreame.module.util.LogUtil
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.ParcelUuid
import android.provider.Settings
import androidx.core.app.ActivityCompat
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import java.util.UUID

class MowerBleScanner(val mowerBleOperator: MowerBleOperator) {
    private val SCAN_PERIOD_DELAY = 10_000L
    private val SCAN_FIRST_DELAY = 2_000L
    private val SCAN_PERIOD_COUNT = 4

    private val MSG_WHAT_SCAN = 0x10
    private val MSG_WHAT_STOP = 0x11
    private val MSG_WHAT_FINISH = 0x12

    private val bluetoothLeScanner by lazy { mowerBleOperator.bluetoothAdapter?.bluetoothLeScanner }
    private val locPermission = mutableListOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION)
    private val blePermission = mutableListOf(Permission.BLUETOOTH_SCAN, Permission.BLUETOOTH_CONNECT)
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
        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            mowerBleOperator.onScanFailed(errorCode, "onScanFailed")
        }

        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            super.onScanResult(callbackType, result)
            LogUtil.v("onScanResult $callbackType  $result")
            // 解析
            try {
                // fix: maybe  ScanRecord.mServiceData = null
                val serviceUuids = result?.scanRecord?.serviceUuids ?: emptyList()
                val parcelUuidTmp = if (serviceUuids.isNotEmpty()) {
                    ParcelUuid(serviceUuids[0].uuid)
                } else {
                    parcelUuid
                }
                val ret = result?.scanRecord?.getServiceData(parcelUuidTmp)?.run {
                    String(this)
                }
                if (!ret.isNullOrEmpty() && (ret.startsWith("dreame", false) || ret.startsWith("mova", false))) {
                    mScanHandler.post {
                        // 添加到机器列表页
                        val address = result.device.address
                        mowerBleOperator.onScanResult(callbackType, result, ret, address)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                mowerBleOperator.onScanFailed(-1, e.message ?: "")
            }

        }

    }

    fun checkBluetoothIsEnabled(callback: BleOperatorRnCallback) {
        callback.onSuccess(isEnabled())
    }

    fun isEnabled(): Boolean {
        val isEnable = mowerBleOperator.bluetoothAdapter != null && mowerBleOperator.bluetoothAdapter.isEnabled
        return isEnable
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
                mowerBleOperator.bluetoothAdapter.enable()
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("ble enable error $e")
            }
        }
    }

    fun startScan(durationInMillis: Int, serviceUUIDs: List<String>, allowDuplicates: Boolean = false, options: ReadableMap) {
        LogUtil.i("startScan $durationInMillis ${serviceUUIDs.joinToString()}  $options")
        if (mowerBleOperator.bluetoothAdapter != null && mowerBleOperator.bluetoothAdapter.isEnabled) {
            mScanHandler.removeMessages(MSG_WHAT_STOP)
            mScanHandler.sendEmptyMessageDelayed(
                MSG_WHAT_STOP,
                if (durationInMillis.toLong() < 5 * 1000) 5 * 1000 else durationInMillis.toLong()
            )
            if (isBluetoothPermissionGranted()) {
                // 如果 isScanning停止扫描
//            bluetoothLeScanner?.flushPendingScanResults(mScanCallback)
                bluetoothLeScanner?.stopScan(mScanCallback)
                val scanFilterList = serviceUUIDs.map {
                    parcelUuid = ParcelUuid(UUID.fromString(it/*"0000$it-0000-1000-8000-00805f9b34fb"*/))
                    ScanFilter.Builder()
                        .setServiceUuid(parcelUuid)
                        .build()
                }
                val scanSettings = ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_BALANCED)
                    .build()
                bluetoothLeScanner?.startScan(scanFilterList, scanSettings, mScanCallback)
//            mowerBleOperator.onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVERED, Arguments.createMap())
            } else {
                mowerBleOperator.onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED, "need bluetooth permission")
            }
        } else {
            mowerBleOperator.onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_DEVICE_DISCOVER_FAILED, "bluetooth is not enabled")
        }


    }

    fun stopScan() {
        LogUtil.i("real stopScan")
        if (mowerBleOperator.bluetoothAdapter != null && mowerBleOperator.bluetoothAdapter.isEnabled) {
            if (isBluetoothPermissionGranted()) {
                // 如果 isScanning停止扫描
                bluetoothLeScanner?.stopScan(mScanCallback)
            }
        }
        mowerBleOperator.onReceiveNativeEvent(BluetoothEvent.BLUETOOTH_CONNECTION_STOP_SCAN, Arguments.createMap().apply {
            putInt("status", 0)
        })
    }
}