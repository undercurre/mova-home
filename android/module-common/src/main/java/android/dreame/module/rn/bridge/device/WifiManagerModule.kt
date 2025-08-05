package android.dreame.module.rn.bridge.device

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.dreame.module.util.CommonUtil
import android.net.wifi.WifiInfo
import android.net.wifi.WifiManager
import android.os.Build
import androidx.core.app.ActivityCompat
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap

class WifiManagerModule(val reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {
    private val wifiManager by lazy {
        reactContext.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
    }
    private val permissions by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            arrayOf(Manifest.permission.NEARBY_WIFI_DEVICES)
        } else {
            arrayOf(
                Manifest.permission.INTERNET,
                Manifest.permission.ACCESS_NETWORK_STATE,
                Manifest.permission.ACCESS_WIFI_STATE,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
            )
        }
    }

    override fun getName() = "WifiManager"

    private fun checkPermissions(): Boolean {
        for (s in permissions) {
            if (ActivityCompat.checkSelfPermission(
                    reactContext,
                    s
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return false
            }
        }
        return true
    }

    private fun connectionInfo(promise: Promise) {
        val wifiInfo: WifiInfo? = wifiManager.connectionInfo
        if (wifiInfo != null && wifiInfo.networkId != -1) {
            val map: WritableMap = WritableNativeMap()
            map.putString("ssid", wifiInfo.ssid.replace("\"", "")) // 去掉SSID首尾的引号
            map.putInt("networkId", wifiInfo.networkId)
            map.putString("bssid", wifiInfo.bssid)
            map.putInt("ipAddress", wifiInfo.ipAddress)
            promise.resolve(map)
        } else {
            // 位置服务未开:-1002，开了位置服务无权限: -1001
            if (CommonUtil.isLocServiceEnable(reactContext)) {
                promise.reject("-1001", "Location permission is not enabled.")
            } else {
                promise.reject("-1002", "Location Service is not enabled.")
            }
        }
    }

    /**
     * 获取当前连接wifi信息（ssid、networkId、bssid、ipAddress）
     * @return promise 1：未连接wifi返回null，2：异常reject("Error", e.message)，3：连接wifi返回 WritableMap
     */
    @ReactMethod
    fun getConnectionInfo(promise: Promise) {
        if (checkPermissions()) {
            connectionInfo(promise)
        } else {
            promise.reject("-1001", "Location permission is not enabled.")
        }
    }
}