package android.dreame.module.rn.bridge.system

import android.annotation.SuppressLint
import android.content.Context
import android.dreame.module.GlobalMainScope
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LocationUtils
import android.location.LocationManager
import androidx.core.location.LocationManagerCompat
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions

class LocationModule(val context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    override fun getName() = "Location"


    override fun onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy()
    }

    /**
     * @since sdk 135
     * 获取手机地理位置信息
     * 建议调用之前先通过System.permission.request(Permissions.LOCATION)或
     * System.permission.requestInfo(Permissions.LOCATION)进行权限检查,两者主要区别在于返回值类型不同
     * @param {string} accuracy 获取定位的精度，可选high, middle, low, since 10043
     * 在Android系统下，默认为high,设置为middle可能会导致在室内获取结果为0。其中，high为高精度定位模式：会同时使用网络定位和GPS定位，优先返回最高精度的定位结果。
     * middle为仅用设备定位模式：不需要连接网络，只使用GPS进行定位，这种模式下不支持室内环境的定位，需要在室外环境下才可以成功定位。
     * low为低功耗定位模式：不会使用GPS和其他传感器，只会使用网络定位（Wi-Fi和基站定位）。
     * 在iOS系统下，默认为middle,设置为high时可能会耗时较长。其中，high为导航精度，middle为十米精度，low为千米精度。
     * @returns {Promise<object>}{
     * country
     * province
     * city
     * district(区域)
     * street
     * address
     * latitude(纬度)
     * longitude(经度)
     * citycode(城市编码)
     * adcode(区域编码)
     * }
     * @example
     * import {System} from 'miot'
     * ...
     * System.location.getLocation().then(res => {
     *  console.log('get location: ', res)
     * })
     */
    @SuppressLint("MissingPermission")
    @ReactMethod
    fun getLocation(accuracy: String, promise: Promise) {
        GlobalMainScope.launch {
            val isGranted = XXPermissions.isGranted(context, arrayOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION));
            if (!isGranted) {
                promise.reject("error", "MissingPermission")
                return@launch
            }
            val gspLocationOpen = isGspLocationOpen()
            if (!gspLocationOpen) {
                promise.reject("error", "location server is closed")
                return@launch
            }
            val address = LocationUtils.getLocationIO(context, false, accuracy, false)
            if (address != null) {
                val addressMap = mutableMapOf(
                    "country" to address.countryName,
                    "countryCode" to address.countryCode,
                    "province" to address.adminArea,
                    "city" to address.locality,
                    "district" to address.subLocality,
                    "street" to address.thoroughfare,
                    "address" to address.getAddressLine(0),
                    "latitude" to address.latitude,
                    "longitude" to address.longitude,
                    "citycode" to address.locality,
                    "adcode" to address.postalCode,
                )
                promise.resolve(GsonUtils.toJson(addressMap))
            } else {
                promise.reject("error", "获取位置失败")
            }
        }
    }

    private fun isGspLocationOpen(): Boolean {
        val locationManager =
            currentActivity?.applicationContext?.getSystemService(Context.LOCATION_SERVICE) as LocationManager? ?: return false
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            return true
        }
        return LocationManagerCompat.isLocationEnabled(locationManager)
    }

}