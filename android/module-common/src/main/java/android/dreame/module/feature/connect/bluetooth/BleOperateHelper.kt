package android.dreame.module.feature.connect.bluetooth

import android.annotation.SuppressLint
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothStatusCodes
import android.dreame.module.BuildConfig
import android.dreame.module.feature.connect.bluetooth.BleRealConnectHelper.operateTimeout
import android.dreame.module.feature.connect.bluetooth.callback.BleIndicateCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleMtuChangedCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleNotifyCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleReadCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleRssiCallback
import android.dreame.module.feature.connect.bluetooth.callback.BleWriteCallback
import android.dreame.module.feature.connect.bluetooth.callback.bleIndicateCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.bleNotifyCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.bleReadCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.bleWriteCallbackHashMap
import android.dreame.module.feature.connect.bluetooth.callback.mtuChangedCallbackMap
import android.dreame.module.feature.connect.bluetooth.callback.rssiCallbackMap
import android.dreame.module.util.LogUtil
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.Message
import okhttp3.internal.toHexString
import java.util.UUID

/**
 * 蓝牙数据交互操作类
 */
class BleOperateHelper internal constructor(private val mBluetoothGatt: BluetoothGatt) {
    private lateinit var mGattService: BluetoothGattService
    private lateinit var mCharacteristic: BluetoothGattCharacteristic

    private val mHandler: Handler
    private fun withUUID(serviceUUID: UUID, characteristicUUID: UUID): BleOperateHelper {
        mGattService = mBluetoothGatt.getService(serviceUUID) ?: throw NullPointerException("mGattService is null")
        mCharacteristic = mGattService.getCharacteristic(characteristicUUID) ?: throw NullPointerException("mCharacteristic is null")
        return this
    }

    fun withUUIDString(serviceUUID: String, characteristicUUID: String): BleOperateHelper {
        return withUUID(formUUID(serviceUUID), formUUID(characteristicUUID))
    }

    fun getGattService(serviceUUID: String): BluetoothGattService? {
        val gattService = mBluetoothGatt.getService(formUUID(serviceUUID)) ?: null
        return gattService
    }

    fun getCharacteristic(serviceUUID: String, characteristicUUID: String): BluetoothGattCharacteristic? {
        val gattService = getGattService(serviceUUID)
        return gattService?.getCharacteristic(formUUID(characteristicUUID))
    }

    fun getCharacteristics(serviceUUID: String, vararg characteristicUUID: String): List<BluetoothGattCharacteristic> {
        val gattService = getGattService(serviceUUID)
        return gattService?.characteristics?.filter {
            characteristicUUID.contains(it.uuid.toString())
        } ?: emptyList()
    }

    private fun formUUID(uuid: String): UUID {
        return UUID.fromString(uuid)
    }
    /*------------------------------- main operation ----------------------------------- */
    /**
     * notify
     */
    fun enableCharacteristicNotify(
        bleNotifyCallback: BleNotifyCallback, uuid_service: String, uuid_notify: String,
        userCharacteristicDescriptor: Boolean
    ) {
        mCharacteristic.takeIf { it.properties or BluetoothGattCharacteristic.PROPERTY_NOTIFY > 0 }?.run {
            handleCharacteristicNotifyCallback(bleNotifyCallback, uuid_service, uuid_notify)
            setCharacteristicNotification(mBluetoothGatt, this, userCharacteristicDescriptor, true, bleNotifyCallback)
        } ?: bleNotifyCallback.onNotifyFailure(BleOtherException(description = "this characteristic not support notify!"))
    }

    /**
     * stop notify
     */
    fun disableCharacteristicNotify(useCharacteristicDescriptor: Boolean): Boolean {
        return mCharacteristic.takeIf {
            it.properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY > 0
        }?.run {
            setCharacteristicNotification(mBluetoothGatt, this, useCharacteristicDescriptor, false, null)
        } ?: false
    }

    /**
     * notify setting
     */
    @SuppressLint("MissingPermission")
    private fun setCharacteristicNotification(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        useCharacteristicDescriptor: Boolean,
        enable: Boolean,
        bleNotifyCallback: BleNotifyCallback?
    ): Boolean {
        // configure local Android device to listen for characteristic changes
        val characteristicNotification = gatt.setCharacteristicNotification(characteristic, enable)
        if (!characteristicNotification) {
            notifyMsgInit()
            bleNotifyCallback?.onNotifyFailure(BleOtherException(description = "gatt setCharacteristicNotification fail"))
            return false
        }
        val descriptor = if (useCharacteristicDescriptor) {
            characteristic.getDescriptor(characteristic.uuid)
        } else {
            characteristic.getDescriptor(formUUID(BleGattAttributes.CLIENT_CHARACTERISTIC_CONFIG))
        }
        if (descriptor == null) {
            notifyMsgInit()
            bleNotifyCallback?.onNotifyFailure(BleOtherException(description = "descriptor equals null"))
            return false
        }
        val value =
            if (enable) BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // see[android.bluetooth.BluetoothStatusCodes.ERROR_GATT_WRITE_REQUEST_BUSY]
            val ret = gatt.writeDescriptor(descriptor, value)
            if (ret != BluetoothStatusCodes.SUCCESS) {
                notifyMsgInit()
                bleNotifyCallback?.onNotifyFailure(BleOtherException(status = ret, description = "gatt writeDescriptor fail"))
            }
            ret == BluetoothStatusCodes.SUCCESS
        } else {
            descriptor.value = value
            val writeDescriptor = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                gatt.writeDescriptor(descriptor)
            } else {
                val parentCharacteristic = descriptor.characteristic
                val originalWriteType = parentCharacteristic.writeType
                parentCharacteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                val result = gatt.writeDescriptor(descriptor)
                parentCharacteristic.writeType = originalWriteType
                result
            }
            if (BuildConfig.DEBUG) {
                LogUtil.d("setCharacteristicNotification writeDescriptor:$writeDescriptor ，uuid: ${characteristic.uuid}")
            }
            if (!writeDescriptor) {
                notifyMsgInit()
                bleNotifyCallback?.onNotifyFailure(BleOtherException(description = "gatt setCharacteristicNotification writeDescriptor fail"))
            }
            writeDescriptor
        }


    }

    /**
     * indicate
     */
    fun enableCharacteristicIndicate(
        bleIndicateCallback: BleIndicateCallback, uuid_service: String, uuid_indicate: String,
        useCharacteristicDescriptor: Boolean
    ) {
        mCharacteristic.takeIf { it.properties and BluetoothGattCharacteristic.PROPERTY_INDICATE > 0 }?.run {
            handleCharacteristicIndicateCallback(bleIndicateCallback, uuid_service, uuid_indicate)
            setCharacteristicIndication(mBluetoothGatt, mCharacteristic, useCharacteristicDescriptor, true, bleIndicateCallback)
        } ?: bleIndicateCallback.onIndicateFailure(BleOtherException(description = "this characteristic not support indicate!"))

    }

    /**
     * stop indicate
     */
    fun disableCharacteristicIndicate(userCharacteristicDescriptor: Boolean): Boolean {
        return mCharacteristic.takeIf { it.properties and BluetoothGattCharacteristic.PROPERTY_INDICATE > 0 }?.run {
            setCharacteristicIndication(mBluetoothGatt, this, userCharacteristicDescriptor, false, null)
        } ?: false

    }

    /**
     * indicate setting
     */
    @SuppressLint("MissingPermission")
    private fun setCharacteristicIndication(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        useCharacteristicDescriptor: Boolean,
        enable: Boolean,
        bleIndicateCallback: BleIndicateCallback?
    ): Boolean {
        gatt.setCharacteristicNotification(characteristic, enable).takeIf { !it }?.run {
            indicateMsgInit()
            bleIndicateCallback?.onIndicateFailure(BleOtherException(description = "gatt setCharacteristicNotification fail"))
            return false
        }
        val descriptor = if (useCharacteristicDescriptor) {
            characteristic.getDescriptor(characteristic.uuid)
        } else {
            characteristic.getDescriptor(formUUID(BleGattAttributes.CLIENT_CHARACTERISTIC_CONFIG))
        }
        return if (descriptor == null) {
            indicateMsgInit()
            bleIndicateCallback?.onIndicateFailure(BleOtherException(description = "descriptor equals null"))
            false
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val descriptorValue = if (enable) {
                    BluetoothGattDescriptor.ENABLE_INDICATION_VALUE
                } else {
                    BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                }
                val writeDescriptor = gatt.writeDescriptor(descriptor, descriptorValue)
                if (writeDescriptor != BluetoothGatt.GATT_SUCCESS) {
                    indicateMsgInit()
                    bleIndicateCallback?.onIndicateFailure(
                        BleOtherException(
                            status = writeDescriptor,
                            description = "gatt writeDescriptor fail"
                        )
                    )
                }
                writeDescriptor == BluetoothGatt.GATT_SUCCESS
            } else {
                descriptor.value =
                    if (enable) BluetoothGattDescriptor.ENABLE_INDICATION_VALUE else BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                val success2 = gatt.writeDescriptor(descriptor)
                if (!success2) {
                    indicateMsgInit()
                    bleIndicateCallback?.onIndicateFailure(BleOtherException(description = "gatt writeDescriptor fail"))
                }
                success2
            }
        }

    }

    /**
     * write
     */
    @SuppressLint("MissingPermission")
    fun writeCharacteristic(
        data: ByteArray,
        uuid_service: String,
        uuid_write: String,
        bleWriteCallback: BleWriteCallback,
        timeout: Int = operateTimeout,
        isNoResponse: Boolean = true
    ): Boolean {
        if (data.isEmpty()) {
            bleWriteCallback.onWriteFailure(BleOtherException(description = "the data to be written is empty"))
            return false
        }
        if (mCharacteristic.properties and (BluetoothGattCharacteristic.PROPERTY_WRITE or BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE) == 0) {
            bleWriteCallback.onWriteFailure(BleOtherException(description = "this characteristic not support write!"))
            return false
        }
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val writeType = if (isNoResponse) {
                BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
            } else {
                BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            }
            handleCharacteristicWriteCallback(bleWriteCallback, uuid_service, uuid_write, timeout)
            val writeCharacteristic = mBluetoothGatt.writeCharacteristic(mCharacteristic, data, writeType)
            if (writeCharacteristic != BluetoothStatusCodes.SUCCESS) {
                writeMsgInit()
                bleWriteCallback.onWriteFailure(
                    BleOtherException(
                        status = writeCharacteristic,
                        description = "writeCharacteristic: gatt writeCharacteristic fail"
                    )
                )
            }
            writeCharacteristic == BluetoothStatusCodes.SUCCESS
        } else {
            if (isNoResponse) {
                mCharacteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE
            } else {
                mCharacteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            }
            if (mCharacteristic.setValue(data)) {
                handleCharacteristicWriteCallback(bleWriteCallback, uuid_service, uuid_write, timeout)
                val writeCharacteristic = mBluetoothGatt.writeCharacteristic(mCharacteristic)
                if (!writeCharacteristic) {
                    writeMsgInit()
                    bleWriteCallback.onWriteFailure(BleOtherException(description = "writeCharacteristic: gatt writeCharacteristic fail"))
                }
                writeCharacteristic
            } else {
                bleWriteCallback.onWriteFailure(BleOtherException(description = "Updates the locally stored value of this characteristic fail"))
                false
            }
        }
    }

    /**
     * read
     */
    @SuppressLint("MissingPermission")
    fun readCharacteristic(bleReadCallback: BleReadCallback, uuid_service: String, uuid_read: String, timeout: Int = operateTimeout) {
        if (mCharacteristic.properties and BluetoothGattCharacteristic.PROPERTY_READ > 0) {
            handleCharacteristicReadCallback(bleReadCallback, uuid_service, uuid_read, timeout)
            val readCharacteristic = mBluetoothGatt.readCharacteristic(mCharacteristic)
            if (!readCharacteristic) {
                //
                LogUtil.i("readCharacteristic gatt readCharacteristic fail")
                readMsgInit()
                bleReadCallback.onReadFailure(BleOtherException(description = "gatt readCharacteristic fail"))
            }
        } else {
            bleReadCallback.onReadFailure(BleOtherException(description = "this characteristic not support read!"))
        }
    }

    /**
     * rssi
     */
    @SuppressLint("MissingPermission")
    fun readRemoteRssi(bleRssiCallback: BleRssiCallback, timeout: Int = operateTimeout) {
        handleRSSIReadCallback(bleRssiCallback, timeout)
        if (!mBluetoothGatt.readRemoteRssi()) {
            rssiMsgInit()
            bleRssiCallback.onRssiFailure(BleOtherException(description = "gatt readRemoteRssi fail"))
        }
    }

    /**
     * set mtu
     */
    @SuppressLint("MissingPermission")
    fun setMtu(requiredMtu: Int, bleMtuChangedCallback: BleMtuChangedCallback, timeout: Int = operateTimeout) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            handleSetMtuCallback(bleMtuChangedCallback, timeout)
            if (!mBluetoothGatt.requestMtu(requiredMtu)) {
                mtuChangedMsgInit()
                bleMtuChangedCallback.onSetMTUFailure(BleOtherException(description = "gatt requestMtu fail"))
            }
        } else {
            bleMtuChangedCallback.onSetMTUFailure(BleOtherException(description = "API level lower than 21"))
        }
    }

    /**
     * requestConnectionPriority
     *
     * @param connectionPriority Request a specific connection priority. Must be one of
     * [BluetoothGatt.CONNECTION_PRIORITY_BALANCED],
     * [BluetoothGatt.CONNECTION_PRIORITY_HIGH]
     * or [BluetoothGatt.CONNECTION_PRIORITY_LOW_POWER].
     * @throws IllegalArgumentException If the parameters are outside of their
     * specified range.
     */
    @SuppressLint("ObsoleteSdkInt", "MissingPermission")
    fun requestConnectionPriority(connectionPriority: Int): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mBluetoothGatt.requestConnectionPriority(connectionPriority)
        } else false
    }
    /**************************************** Handle call back  */
    /**
     * notify
     */
    private fun handleCharacteristicNotifyCallback(
        bleNotifyCallback: BleNotifyCallback,
        uuid_service: String,
        uuid_notify: String
    ) {
        notifyMsgInit()
        val key = "${mBluetoothGatt.device.address}_${uuid_service}_${uuid_notify}"
        bleNotifyCallback.uuid_service = uuid_service
        bleNotifyCallback.uuid = uuid_notify
        bleNotifyCallback.key = key
        bleNotifyCallback.handler = mHandler
        bleNotifyCallbackHashMap[key] = bleNotifyCallback
        mHandler.sendMessageDelayed(
            mHandler.obtainMessage(BleMsg.MSG_CHA_NOTIFY_START, bleNotifyCallback),
            operateTimeout.toLong()
        )
    }

    /**
     * indicate
     */
    private fun handleCharacteristicIndicateCallback(
        bleIndicateCallback: BleIndicateCallback,
        uuid_service: String,
        uuid_indicate: String,
        timeout: Int = operateTimeout
    ) {
        indicateMsgInit()
        bleIndicateCallback.uuid_service = uuid_service
        bleIndicateCallback.uuid = uuid_indicate
        bleIndicateCallback.handler = mHandler
        val key = "${mBluetoothGatt.device.address}_${uuid_service}_${uuid_indicate}"
        bleIndicateCallback.key = key
        bleIndicateCallbackHashMap[key] = bleIndicateCallback
        mHandler.sendMessageDelayed(
            mHandler.obtainMessage(BleMsg.MSG_CHA_INDICATE_START, bleIndicateCallback),
            timeout.toLong()
        )
    }

    /**
     * write
     */
    private fun handleCharacteristicWriteCallback(
        bleWriteCallback: BleWriteCallback,
        uuid_service: String,
        uuid_write: String,
        timeout: Int = operateTimeout
    ) {
        writeMsgInit()
        bleWriteCallback.uuid_service = uuid_service
        bleWriteCallback.uuid = uuid_write
        bleWriteCallback.handler = mHandler
        val key = "${mBluetoothGatt.device.address}_${uuid_service}_${uuid_write}"
        bleWriteCallback.key = key
        bleWriteCallbackHashMap[key] = bleWriteCallback
        mHandler.sendMessageDelayed(
            mHandler.obtainMessage(BleMsg.MSG_CHA_WRITE_START, bleWriteCallback),
            timeout.toLong()
        )
    }

    /**
     * read
     */
    private fun handleCharacteristicReadCallback(
        bleReadCallback: BleReadCallback,
        uuid_service: String,
        uuid_read: String,
        timeout: Int = operateTimeout
    ) {
        readMsgInit()
        bleReadCallback.uuid_service = uuid_service
        bleReadCallback.uuid = uuid_read
        bleReadCallback.handler = mHandler
        val key = "${mBluetoothGatt.device.address}_${uuid_service}_${uuid_read}"
        bleReadCallback.key = key
        bleReadCallbackHashMap[key] = bleReadCallback
        mHandler.sendMessageDelayed(
            mHandler.obtainMessage(BleMsg.MSG_CHA_READ_START, bleReadCallback),
            timeout.toLong()
        )
    }

    /**
     * rssi
     */
    private fun handleRSSIReadCallback(bleRssiCallback: BleRssiCallback, timeout: Int = operateTimeout) {
        rssiMsgInit()
        bleRssiCallback.handler = mHandler
        rssiCallbackMap[mBluetoothGatt.device.address] = bleRssiCallback
        mHandler.sendMessageDelayed(
            mHandler.obtainMessage(BleMsg.MSG_READ_RSSI_START, bleRssiCallback),
            timeout.toLong()
        )
    }

    /**
     * set mtu
     */
    private fun handleSetMtuCallback(bleMtuChangedCallback: BleMtuChangedCallback, timeout: Int = operateTimeout) {
        mtuChangedMsgInit()
        bleMtuChangedCallback.handler = mHandler
        mtuChangedCallbackMap[mBluetoothGatt.device.address] = bleMtuChangedCallback
        mHandler.sendMessageDelayed(
            mHandler.obtainMessage(BleMsg.MSG_SET_MTU_START, bleMtuChangedCallback),
            timeout.toLong()
        )
    }

    fun notifyMsgInit() {
        mHandler.removeMessages(BleMsg.MSG_CHA_NOTIFY_START)
    }

    fun indicateMsgInit() {
        mHandler.removeMessages(BleMsg.MSG_CHA_INDICATE_START)
    }

    fun writeMsgInit() {
        mHandler.removeMessages(BleMsg.MSG_CHA_WRITE_START)
    }

    fun readMsgInit() {
        mHandler.removeMessages(BleMsg.MSG_CHA_READ_START)
    }

    fun rssiMsgInit() {
        mHandler.removeMessages(BleMsg.MSG_READ_RSSI_START)
    }

    fun mtuChangedMsgInit() {
        mHandler.removeMessages(BleMsg.MSG_SET_MTU_START)
    }

    init {
        mHandler = object : Handler(Looper.getMainLooper()) {
            override fun handleMessage(msg: Message) {
                super.handleMessage(msg)
                when (msg.what) {
                    BleMsg.MSG_CHA_NOTIFY_START -> {
                        val notifyCallback = msg.obj as BleNotifyCallback
                        notifyCallback.onNotifyFailure(BleTimeoutException())
                    }

                    BleMsg.MSG_CHA_NOTIFY_RESULT -> {
                        notifyMsgInit()
                        val notifyCallback = msg.obj as BleNotifyCallback
                        val bundle = msg.data
                        val status = bundle.getInt(BleMsg.KEY_NOTIFY_BUNDLE_STATUS)
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            notifyCallback.onNotifySuccess()
                        } else {
                            notifyCallback.onNotifyFailure(BleGattException(status))
                        }
                    }

                    BleMsg.MSG_CHA_NOTIFY_DATA_CHANGE -> {
                        val notifyCallback = msg.obj as BleNotifyCallback
                        val bundle = msg.data
                        val value = bundle.getByteArray(BleMsg.KEY_NOTIFY_BUNDLE_VALUE) ?: ByteArray(0)
                        notifyCallback.onCharacteristicChanged(value)
                    }

                    BleMsg.MSG_CHA_INDICATE_START -> {
                        val indicateCallback = msg.obj as BleIndicateCallback
                        indicateCallback.onIndicateFailure(BleTimeoutException())
                    }

                    BleMsg.MSG_CHA_INDICATE_RESULT -> {
                        indicateMsgInit()
                        val indicateCallback = msg.obj as BleIndicateCallback
                        val bundle = msg.data
                        val status = bundle.getInt(BleMsg.KEY_INDICATE_BUNDLE_STATUS)
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            indicateCallback.onIndicateSuccess()
                        } else {
                            indicateCallback.onIndicateFailure(BleGattException(status))
                        }
                    }

                    BleMsg.MSG_CHA_INDICATE_DATA_CHANGE -> {
                        val indicateCallback = msg.obj as BleIndicateCallback
                        val bundle = msg.data
                        val value = bundle.getByteArray(BleMsg.KEY_INDICATE_BUNDLE_VALUE)
                        indicateCallback.onCharacteristicChanged(value)
                    }

                    BleMsg.MSG_CHA_WRITE_START -> {
                        val writeCallback = msg.obj as BleWriteCallback
                        writeCallback.onWriteFailure(BleTimeoutException())
                    }

                    BleMsg.MSG_CHA_WRITE_RESULT -> {
                        writeMsgInit()
                        val writeCallback = msg.obj as BleWriteCallback
                        val bundle = msg.data
                        val status = bundle.getInt(BleMsg.KEY_WRITE_BUNDLE_STATUS)
                        val value = bundle.getByteArray(BleMsg.KEY_WRITE_BUNDLE_VALUE)
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            writeCallback.onWriteSuccess(0, 0, value!!)
                        } else {
                            val exception = when (status) {
                                BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH -> {
                                    "A write operation exceeds the maximum length of the attribute"
                                }

                                BluetoothGatt.GATT_FAILURE -> {
                                    "A GATT operation failed, errors other than the above"
                                }

                                else -> {
                                    "write operation error ${status.toHexString()}"
                                }
                            }
                            writeCallback.onWriteFailure(BleGattException(status, exception))
                        }
                    }

                    BleMsg.MSG_CHA_READ_START -> {
                        val readCallback = msg.obj as BleReadCallback
                        readCallback.onReadFailure(BleTimeoutException())
                    }

                    BleMsg.MSG_CHA_READ_RESULT -> {
                        readMsgInit()
                        val readCallback = msg.obj as BleReadCallback
                        val bundle = msg.data
                        val status = bundle.getInt(BleMsg.KEY_READ_BUNDLE_STATUS)
                        val value = bundle.getByteArray(BleMsg.KEY_READ_BUNDLE_VALUE)
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            readCallback.onReadSuccess(value!!)
                        } else {
                            readCallback.onReadFailure(BleGattException(status))
                        }
                    }

                    BleMsg.MSG_READ_RSSI_START -> {
                        val rssiCallback = msg.obj as BleRssiCallback
                        rssiCallback.onRssiFailure(BleTimeoutException())
                    }

                    BleMsg.MSG_READ_RSSI_RESULT -> {
                        rssiMsgInit()
                        val rssiCallback = msg.obj as BleRssiCallback
                        val bundle = msg.data
                        val status = bundle.getInt(BleMsg.KEY_READ_RSSI_BUNDLE_STATUS)
                        val value = bundle.getInt(BleMsg.KEY_READ_RSSI_BUNDLE_VALUE)
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            rssiCallback.onRssiSuccess(value)
                        } else {
                            rssiCallback.onRssiFailure(BleGattException(status))
                        }
                    }

                    BleMsg.MSG_SET_MTU_START -> {
                        val mtuChangedCallback = msg.obj as BleMtuChangedCallback
                        mtuChangedCallback.onSetMTUFailure(BleTimeoutException())
                    }

                    BleMsg.MSG_SET_MTU_RESULT -> {
                        mtuChangedMsgInit()
                        val mtuChangedCallback = msg.obj as BleMtuChangedCallback
                        val bundle = msg.data
                        val status = bundle.getInt(BleMsg.KEY_SET_MTU_BUNDLE_STATUS)
                        val value = bundle.getInt(BleMsg.KEY_SET_MTU_BUNDLE_VALUE)
                        if (status == BluetoothGatt.GATT_SUCCESS) {
                            LogUtil.e("currentMtu  $value")
                            mtuChangedCallback.onMtuChanged(value)
                        } else {
                            mtuChangedCallback.onSetMTUFailure(BleGattException(status))
                        }
                    }
                }
            }
        }
    }
}