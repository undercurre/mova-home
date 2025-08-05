package android.dreame.module.rn

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.dreame.module.feature.connect.bluetooth.mower.event.BluetoothEvent
import android.dreame.module.rn.load.RnActivity
import android.dreame.module.util.ActivityUtil
import android.dreame.module.util.LogUtil
import com.facebook.react.bridge.Arguments
import com.facebook.react.modules.core.DeviceEventManagerModule

/**
 * 蓝牙状态变化广播接收器
 */
class RNBleStateEventReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        when (action) {
            BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED -> {
                LogUtil.i("RNBleStateEventReceiver", "蓝牙状态变化 ACTION_CONNECTION_STATE_CHANGED")
            }

            BluetoothAdapter.ACTION_STATE_CHANGED -> {
                LogUtil.i("RNBleStateEventReceiver", "蓝牙状态变化 ACTION_STATE_CHANGED")
                val bleState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0)
                val topActivity = ActivityUtil.getInstance().topActivity
                if (topActivity is RnActivity) {
                    val currentReactContext = topActivity.mDelegate.reactInstanceManager.currentReactContext
                    if (currentReactContext != null) {
                        val map = Arguments.createMap()
                        map.putBoolean("isEnabled", bleState == BluetoothAdapter.STATE_ON)
                        val isEnabled = bleState == BluetoothAdapter.STATE_ON
                        currentReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                            .emit(BluetoothEvent.BLUETOOTH_STATUS_CHANGED, isEnabled)
                    }

                }
                if (topActivity is RNDebugActivity) {
                    val currentReactContext = topActivity.getCurrentReactContext()
                    if (currentReactContext != null) {
                        val map = Arguments.createMap()
                        map.putBoolean("isEnabled", bleState == BluetoothAdapter.STATE_ON)
                        val isEnabled = bleState == BluetoothAdapter.STATE_ON
                        currentReactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
                            .emit(BluetoothEvent.BLUETOOTH_STATUS_CHANGED, isEnabled)
                    }

                }
            }

        }

    }
}