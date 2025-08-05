package android.dreame.module.feature.connect.bluetooth

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothManager
import android.content.Context
import android.dreame.module.LocalApplication
import android.dreame.module.bean.device.BluetoothDeviceWrapper
import android.dreame.module.feature.connect.bluetooth.callback.BleConnectGattCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleIndicateCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleMtuChangedCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleNotifyCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleReadCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleRssiCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleWriteCallback
import android.dreame.module.util.LogUtil
import android.os.Looper
import android.util.Log
import android.dreame.module.feature.connect.bluetooth.callback.*
import kotlinx.coroutines.flow.*

/**
 * 蓝牙对外接口类
 */
object BluetoothLeManager {
    const val TAG = "BluetoothLEManager"

    private val bluetoothManager by lazy { LocalApplication.getInstance().getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager }
    private val bluetoothAdapter by lazy { BluetoothAdapter.getDefaultAdapter() }


    fun isDeviceConnect(deviceWrapper: BluetoothDeviceWrapper?): Boolean {
        return isDeviceConnect(deviceWrapper?.device)
    }

    @SuppressLint("MissingPermission")
    fun isDeviceConnect(device: BluetoothDevice?): Boolean {
        if (device == null) return false;
        val state = bluetoothManager.getConnectionState(device, BluetoothGatt.GATT)
        return state == BluetoothGatt.STATE_CONNECTED
    }

    @SuppressLint("MissingPermission")
    fun getConnectBluetoothDevice(mac: String): BluetoothDevice? {
        val filter = bluetoothManager.getConnectedDevices(BluetoothGatt.GATT)?.filter {
            it.address == mac
        }
        return if (filter.isNullOrEmpty()) {
            null
        } else {
            filter[0]
        }
    }

    /**
     * 连接设备
     */
    fun connectDevice(
        context: Context,
        deviceWrapper: BluetoothDeviceWrapper,
        autoConnect: Boolean = false,
        callback: BleConnectGattCallback,
        timeout: Long = DEFAULT_CONNECT_OVER_TIME.toLong()
    ) {
        LogUtil.i("connectDevice ------1----- ${deviceWrapper.device.address} ")
        if (Looper.myLooper() == null || Looper.myLooper() != Looper.getMainLooper()) {
            LogUtil.w(TAG, "Be careful: currentThread is not MainThread!")
        }
        BleRealConnectHelper.connect(context, autoConnect, deviceWrapper, timeout, callback)
    }

    fun connectDevice(
        context: Context,
        mac: String,
        autoConnect: Boolean = false,
        callback: BleConnectGattCallback,
        timeout: Long = DEFAULT_CONNECT_OVER_TIME.toLong()
    ) {
        LogUtil.i("connectDevice ------2----- $mac ")
        if (Looper.myLooper() == null || Looper.myLooper() != Looper.getMainLooper()) {
            LogUtil.w(TAG, "Be careful: currentThread is not MainThread!")
        }
        val remoteDevice = bluetoothAdapter.getRemoteDevice(mac)
        val deviceWrapper = BluetoothDeviceWrapper("", remoteDevice, byteArrayOf(0), 0, 0)
        BleRealConnectHelper.connect(context, autoConnect, deviceWrapper, timeout, callback)
    }

    fun connectDevice(
        context: Context,
        device: BluetoothDevice,
        autoConnect: Boolean = false,
        callback: BleConnectGattCallback,
        timeout: Long = DEFAULT_CONNECT_OVER_TIME.toLong()
    ) {
        if (Looper.myLooper() == null || Looper.myLooper() != Looper.getMainLooper()) {
            LogUtil.w(TAG, "Be careful: currentThread is not MainThread!")
        }
        val deviceWrapper = BluetoothDeviceWrapper("", device, byteArrayOf(0), 0, 0)
        BleRealConnectHelper.connect(context, autoConnect, deviceWrapper, timeout, callback)
    }

    /**
     * 断开连接设备
     */
    fun disConnectDevice(deviceWrapper: BluetoothDeviceWrapper) {
        LogUtil.i("disConnectDevice  ${deviceWrapper.device.address} ")
        BleRealConnectHelper.disconnect(deviceWrapper.device.address)
    }

    fun disConnectDevice(device: BluetoothDevice) {
        BleRealConnectHelper.disconnect(device.address)
    }

    fun disConnectDevice(mac: String) {
        BleRealConnectHelper.disconnect(mac)
    }

    fun disconnectAndCloseAll() {
        BleRealConnectHelper.disconnectAndCloseAll()
    }

    fun discoverServices(
        mac: String,
        timeout: Long = BleRealConnectHelper.discoverServicesOverTime,
        callback: BleConnectGattCallback? = null
    ) {
        BleRealConnectHelper.discoverServices(mac, timeout, callback)
    }

    fun notify(device: BluetoothDevice, uuid_service: String, uuid_notify: String, callback: BleNotifyCallback) {
        notify(device, uuid_service, uuid_notify, false, callback)
    }

    fun notify(
        device: BluetoothDevice,
        uuid_service: String,
        uuid_notify: String,
        useCharacteristicDescriptor: Boolean,
        callback: BleNotifyCallback
    ) {
        notify(device.address, uuid_service, uuid_notify, useCharacteristicDescriptor, callback)
    }

    fun notify(
        mac: String,
        uuid_service: String,
        uuid_notify: String,
        useCharacteristicDescriptor: Boolean,
        callback: BleNotifyCallback
    ) {
        deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .withUUIDString(uuid_service, uuid_notify)
                .enableCharacteristicNotify(callback, uuid_service, uuid_notify, useCharacteristicDescriptor)
        }?.onFailure {
            callback.onNotifyFailure(BleOtherException(description = "This device not connect!"))
        } ?: callback.onNotifyFailure(BleOtherException(description = "This device not connect!"))

    }

    fun indicate(
        device: BluetoothDevice,
        uuid_service: String,
        uuid_indicate: String,
        useCharacteristicDescriptor: Boolean,
        callback: BleIndicateCallback
    ) {
        indicate(device.address, uuid_service, uuid_indicate, useCharacteristicDescriptor, callback)
    }

    fun indicate(
        mac: String,
        uuid_service: String,
        uuid_indicate: String,
        useCharacteristicDescriptor: Boolean,
        callback: BleIndicateCallback
    ) {
        deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .withUUIDString(uuid_service, uuid_indicate)
                .enableCharacteristicIndicate(callback, uuid_service, uuid_indicate, useCharacteristicDescriptor)
        }?.onFailure {
            callback.onIndicateFailure(BleOtherException(description = "This device not connect!"))
        } ?: callback.onIndicateFailure(BleOtherException(description = "This device not connect!"))

    }

    fun stopNotify(
        device: BluetoothDevice,
        uuid_service: String,
        uuid_notify: String,
        useCharacteristicDescriptor: Boolean
    ): Boolean {
        return stopNotify(device.address, uuid_service, uuid_notify, useCharacteristicDescriptor)
    }

    fun stopNotify(
        mac: String,
        uuid_service: String,
        uuid_notify: String,
        useCharacteristicDescriptor: Boolean
    ): Boolean {
        val onSuccess = deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .withUUIDString(uuid_service, uuid_notify)
                .disableCharacteristicNotify(useCharacteristicDescriptor)
        }?.onFailure {
        }?.onSuccess {
            if (it) {
                bleNotifyCallbackHashMap.remove(mac)
            }
        }
        return onSuccess?.isSuccess == true

    }

    fun stopIndicate(
        device: BluetoothDevice,
        uuid_service: String,
        uuid_indicate: String,
        useCharacteristicDescriptor: Boolean
    ): Boolean {
        return stopIndicate(device.address, uuid_service, uuid_indicate, useCharacteristicDescriptor)
    }

    fun stopIndicate(
        mac: String,
        uuid_service: String,
        uuid_indicate: String,
        useCharacteristicDescriptor: Boolean
    ): Boolean {
        val onSuccess = deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .withUUIDString(uuid_service, uuid_indicate)
                .disableCharacteristicIndicate(useCharacteristicDescriptor)
        }?.onFailure {
        }?.onSuccess {
            if (it) {
                bleIndicateCallbackHashMap.remove(mac)
            }
        }
        return onSuccess?.isSuccess == true
    }

    /**
     * write
     *
     * @param deviceWrapper
     * @param uuid_service
     * @param uuid_write
     * @param data
     * @param timeout
     * @param callback
     */
    fun write(
        deviceWrapper: BluetoothDeviceWrapper,
        uuid_service: String,
        uuid_write: String,
        data: ByteArray,
        callback: BleWriteCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
        isNoResponse: Boolean = true
    ) {
        write(deviceWrapper.device.address, uuid_service, uuid_write, data, false, callback, timeout, isNoResponse)
    }

    fun write(
        device: BluetoothDevice,
        uuid_service: String,
        uuid_write: String,
        data: ByteArray,
        callback: BleWriteCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
        isNoResponse: Boolean = true
    ) {
        write(device.address, uuid_service, uuid_write, data, false, callback, timeout, isNoResponse)
    }

    /**
     * write
     *
     * @param deviceWrapper
     * @param uuid_service
     * @param uuid_write
     * @param data
     * @param split
     * @param callback
     */
    fun write(
        mac: String,
        uuid_service: String,
        uuid_write: String,
        data: ByteArray,
        split: Boolean,
        callback: BleWriteCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
        isNoResponse: Boolean = true
    ) {
        write(mac, uuid_service, uuid_write, data, split, true, 0, callback, timeout, isNoResponse)
    }

    /**
     * write
     *
     * @param deviceWrapper
     * @param uuid_service
     * @param uuid_write
     * @param data
     * @param split
     * @param sendNextWhenLastSuccess
     * @param intervalBetweenTwoPackage
     * @param callback
     */
    fun write(
        mac: String,
        uuid_service: String,
        uuid_write: String,
        data: ByteArray,
        split: Boolean,
        sendNextWhenLastSuccess: Boolean,
        intervalBetweenTwoPackage: Long,
        callback: BleWriteCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
        isNoResponse: Boolean = true
    ) {
        val mtu = deviceMTUMap[mac] ?: DEFAULT_MTU
        deviceGattMap[mac]?.runCatching {
            if (data.size > mtu) {
                // TODO 分包
                splitWrite(mtu, data, uuid_service, uuid_write, callback, isNoResponse)
            } else {
                BleOperateHelper(this)
                    .withUUIDString(uuid_service, uuid_write)
                    .writeCharacteristic(data, uuid_service, uuid_write, callback, timeout, isNoResponse)
            }
        } ?: callback.onWriteFailure(BleOtherException(description = "This device not connect!"))
    }

    private fun BluetoothGatt.splitWrite(
        mtu: Int,
        data: ByteArray,
        uuid_service: String,
        uuid_write: String,
        callback: BleWriteCallback,
        isNoResponse: Boolean = true
    ) {
        val chunked = data.asIterable().chunked(mtu - 3)
        var index = 0
        fun writeData(data: ByteArray) {
            Log.d(TAG, "splitWrite: -------$index  send ------- ")
            BleOperateHelper(this@splitWrite)
                .withUUIDString(uuid_service, uuid_write)
                .writeCharacteristic(data, uuid_service, uuid_write, object : BleWriteCallback() {
                    override fun onWriteSuccess(current: Int, total: Int, justWrite: ByteArray) {
                        super.onWriteSuccess(current, total, justWrite)
                        Log.d(TAG, "onWriteSuccess: -------$index------- ")
                        if (index == chunked.size - 1) {
                            callback.onWriteSuccess(current, total, justWrite)
                            return
                        }
                        index++
                        writeData(chunked[index].toByteArray())
                    }

                    override fun onWriteFailure(exception: BleException) {
                        super.onWriteFailure(exception)
                        callback.onWriteFailure(exception)
                    }
                }, isNoResponse = isNoResponse)
        }
        writeData(chunked[index].toByteArray())

    }

    /**
     * read
     *
     * @param deviceWrapper
     * @param uuid_service
     * @param uuid_read
     * @param callback
     */
    fun read(
        deviceWrapper: BluetoothDeviceWrapper,
        uuid_service: String,
        uuid_read: String,
        callback: BleReadCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout
    ) {
        read(deviceWrapper.device.address, uuid_service, uuid_read, callback, timeout)
    }

    fun read(
        device: BluetoothDevice,
        uuid_service: String,
        uuid_read: String,
        callback: BleReadCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout
    ) {
        read(device.address, uuid_service, uuid_read, callback, timeout)
    }

    fun read(
        mac: String,
        uuid_service: String,
        uuid_read: String,
        callback: BleReadCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout
    ) {
        deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .withUUIDString(uuid_service, uuid_read)
                .readCharacteristic(callback, uuid_service, uuid_read, timeout)
        } ?: callback.onReadFailure(BleOtherException(description = "This device not connect!"))
    }

    /**
     * read Rssi
     *
     * @param deviceWrapper
     * @param callback
     */
    fun readRssi(
        device: BluetoothDevice,
        callback: BleRssiCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout
    ) {
        readRssi(device.address, callback, timeout)
    }

    fun readRssi(
        mac: String,
        callback: BleRssiCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
    ) {
        deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .readRemoteRssi(callback, timeout)
        } ?: callback.onRssiFailure(BleOtherException(description = "This device not connect!"))
    }


    /**
     * set Mtu
     *
     * @param deviceWrapper
     * @param mtu
     * @param callback
     */
    fun setMtu(
        deviceWrapper: BluetoothDeviceWrapper,
        mtu: Int,
        callback: BleMtuChangedCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
    ) {
        setMtu(deviceWrapper.device.address, mtu, callback, timeout)
    }

    fun setMtu(
        device: BluetoothDevice,
        mtu: Int,
        callback: BleMtuChangedCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
    ) {
        setMtu(device.address, mtu, callback, timeout)
    }

    fun setMtu(
        mac: String,
        mtu: Int,
        callback: BleMtuChangedCallback,
        timeout: Int = BleRealConnectHelper.operateTimeout,
    ) {
        LogUtil.d("--------setmtu $mac  $mtu")
        if (mtu > DEFAULT_MAX_MTU) {
            LogUtil.e(TAG, "requiredMtu should lower than 512 !")
            callback.onSetMTUFailure(BleOtherException(description = "requiredMtu should lower than 512 !"))
            return
        }
        if (mtu < DEFAULT_MTU) {
            LogUtil.e(TAG, "requiredMtu should higher than 23 !")
            callback.onSetMTUFailure(BleOtherException(description = "requiredMtu should higher than 23 !"))
            return
        }
        deviceGattMap[mac]?.runCatching {
            BleOperateHelper(this)
                .setMtu(mtu, callback, timeout)
        } ?: callback.onSetMTUFailure(BleOtherException(description = "This device not connect!"))
    }

    /**
     * 删除connect回调
     */
    fun removeConnectCallback(deviceWrapper: BluetoothDeviceWrapper, callback: BleConnectGattCallback) {
        val address = deviceWrapper.device.address
        removeConnectCallback(address, callback)
    }

    fun removeConnectCallback(device: BluetoothDevice, callback: BleConnectGattCallback) {
        val address = device.address
        removeConnectCallback(address, callback)
    }

    fun removeConnectCallback(mac: String, callback: BleConnectGattCallback) {
        connectGattCallbackMap[mac]?.takeIf { it == callback }?.run {
            connectGattCallbackMap.remove(mac)
        }
    }

    fun setConnectCallback(device: BluetoothDevice, callback: BleConnectGattCallback) {
        setConnectCallback(device.address, callback)
    }

    fun setConnectCallback(mac: String, callback: BleConnectGattCallback) {
        connectGattCallbackMap[mac] = callback
    }

    /**
     * 删除connect回调
     */
    fun removeMtuChangeCallback(deviceWrapper: BluetoothDeviceWrapper, callback: BleMtuChangedCallback) {
        val address = deviceWrapper.device.address
        removeMtuChangeCallback(address, callback)
    }

    fun removeMtuChangeCallback(device: BluetoothDevice, callback: BleMtuChangedCallback) {
        val address = device.address
        removeMtuChangeCallback(address, callback)
    }

    fun removeMtuChangeCallback(mac: String, callback: BleMtuChangedCallback) {
        mtuChangedCallbackMap[mac]?.takeIf { it == callback }?.run {
            mtuChangedCallbackMap.remove(mac)
        }
    }

    fun onDestroy() {
        LogUtil.i("onDestroy")
        clearAllConnect();
    }

    private fun disAllConnect() {
        LogUtil.i("disAllConnect")
        BleRealConnectHelper.disconnectAndCloseAll()
        deviceGattMap.clear()
        deviceWrapperMap.clear()
        deviceStatusMap.clear()
    }

    private fun clearAllConnect() {
        disAllConnect()
        LogUtil.i("clearAllConnect")

        connectGattCallbackMap.clear()
        rssiCallbackMap.clear()
        mtuChangedCallbackMap.clear()
        characterCallbackMap.clear()

        bleNotifyCallbackHashMap.clear()
        bleIndicateCallbackHashMap.clear()
        bleWriteCallbackHashMap.clear()
        bleReadCallbackHashMap.clear()


    }

}