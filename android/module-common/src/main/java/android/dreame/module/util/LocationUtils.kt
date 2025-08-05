package android.dreame.module.util

import android.Manifest.permission
import android.annotation.SuppressLint
import android.content.Context
import android.dreame.module.LocalApplication
import android.dreame.module.R
import android.dreame.module.data.Result
import android.dreame.module.data.getString
import android.dreame.module.data.network.service.DreameService
import android.dreame.module.data.network.service.OtherOriginService
import android.dreame.module.exception.DreameException
import android.dreame.module.manager.AreaManager
import android.location.Address
import android.location.Criteria
import android.location.Geocoder
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.HandlerThread
import android.text.TextUtils
import androidx.annotation.RequiresPermission
import androidx.core.location.LocationManagerCompat
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import java.util.Locale
import kotlin.coroutines.resume


/**
 * 需求：https://dreametech.feishu.cn/wiki/GyMAwfwsZi7fsJkToBPcUSkgn8f
 * UI图：https://mastergo.com/file/121607998798133?fileOpenFrom=project&page_id=15158%3A38416&shareId=121607998798133
 * 定位工具类
 */

enum class Accuracy(val value: String) {
    LOW("low"),
    MEDIUM("medium"),
    HIGH("high");
}

object LocationUtils {
    var lastAreaCode: String? = null
    var lastAddress: Address? = null
    var lastLocation: Location? = null

    /**
     *  在子线程中使用
     */
    suspend fun isGpsLockSuspend(): Boolean {
        val region = AreaManager.getRegion()
        val isCnDomain = "cn".contentEquals(region, true)
        if (!"cn".contentEquals(region, true)) {
            /// 海外地区不管
            return false
        }
        val areaCode = getCurrentLocationAreaCode()
        val isSkipLocation =
            "CN".contentEquals(areaCode.second, true) || "MO".contentEquals(areaCode.second, true)
                    || TextUtils.isEmpty(areaCode.second)
        if (isCnDomain && !isSkipLocation) {
            return true
        }
        return false
    }

    fun isGpsLock(countryCode: String): Boolean {
        val region = AreaManager.getRegion()
        val isCnDomain = "cn".contentEquals(region, true)
        if (!"cn".contentEquals(region, true)) {
            /// 海外地区不管
            return false
        }
        val isSkipLocation = "CN".contentEquals(countryCode, true) || "MO".contentEquals(countryCode, true) || countryCode.isBlank()
        if (isCnDomain && !isSkipLocation) {
            return true
        }
        return false
    }

    suspend fun gpsLockConfigEnableSuspend(): Boolean? {
        val region = AreaManager.getRegion()
        val isCnDomain = "cn".contentEquals(region, true)
        if (!isCnDomain) {
            /// 海外地区不管
            return false
        }
        val urlRedirect = "https://oss.iot.dreame.tech/public/app/app_config.json?${System.currentTimeMillis()}"
        try {
            val res = DreameService.getUrlRedirect2(urlRedirect)
            LogUtil.i("app_config.json: $res")
            return res.gps_lock == 1
        } catch (e: Exception) {
            e.printStackTrace()
            Result.Error(DreameException(-1, getString(R.string.toast_server_error)))
        }
        return null
    }


    /// 仅使用cn域名时定位
    suspend fun getCurrentLocationAreaCode(
        context: Context = LocalApplication.getInstance(),
        lastKnownFirst: Boolean = false
    ): Pair<Boolean, String> {
        val region = AreaManager.getRegion()
        if (!"cn".contentEquals(region, true)) {
            /// 海外地区不管
            return false to region
        }
        val isGranted = isCanLocationYes(context);
        if (!isGranted) {
            return false to ""
        }
        return withContext(Dispatchers.IO) {
            val address = getLocation(context, lastKnownFirst = lastKnownFirst)
            lastAddress = address
            LogUtil.i("LocationUtils getCurrentLocationCountryCode getLocation: $address")
            val code = address?.countryCode ?: return@withContext false to ""
            lastAreaCode = code
            return@withContext true to code
        }
    }

    suspend fun getLocationIO(
        context: Context = LocalApplication.getInstance(),
        lastKnownFirst: Boolean = true,
        accuracy: String = Accuracy.LOW.value,
        geocoderLocationChina: Boolean = true
    ): Address? = withContext(Dispatchers.IO) {
        return@withContext getLocation(context, lastKnownFirst, accuracy, geocoderLocationChina)
    }

    @SuppressLint("MissingPermission")
    private suspend fun getLocation(
        context: Context = LocalApplication.getInstance(),
        lastKnownFirst: Boolean = true,
        accuracy: String = Accuracy.LOW.value,
        geocoderLocationChina: Boolean = true
    ): Address? {
        var location: Location? = null
        if (lastKnownFirst) {
            location = lastKnownLocation(context)
            if (location == null) {
                location = realLocation(context, accuracy)
            }
        } else {
            location = realLocation(context, accuracy)
            if (location == null) {
                location = lastKnownLocation(context)
            }
        }

        if (location != null) {
            try {
                val locale = if (geocoderLocationChina) Locale.CHINA else Locale.getDefault()
                val geocoder = Geocoder(context, locale)
                val addresses = geocoder.getFromLocation(location.latitude, location.longitude, 1)
                LogUtil.e("LocationUtils getLocation getFromLocation $addresses")
                if (addresses?.isNotEmpty() == true) {
                    val address = addresses[0]
                    if (address.countryCode == "CN") {
                        // 判断地区code是否为中国大陆或者澳门，如果是则返回
                        if (address.adminArea.contains("香港特别行政区")
                            || address.adminArea.contains(
                                "Hong Kong SAR",
                                true
                            )
                            || address.adminArea.contains("香港") || address.adminArea.contains(
                                "Hong Kong",
                                true
                            )
                        ) {
                            address.countryCode = "HK"
                        } else if (address.adminArea.contains("澳门特别行政区")
                            || address.adminArea.contains(
                                "Macau SAR",
                                true
                            )
                            || address.adminArea.contains("澳门") || address.adminArea.contains(
                                "Macau",
                                true
                            )
                        ) {
                            address.countryCode = "MO"
                        } else if (address.adminArea.contains("台湾") || address.adminArea.contains("Taiwan", true)) {
                            address.countryCode = "TW"
                        }
                    } else if (TextUtils.isEmpty(address.countryCode)) {
                        /// 国内版手机会返回 admin：港澳台 country：中国， 国际版手机直接返回 country 为港澳台,所以此处无需调用腾讯地图逆地理编码
                        ///TODO： 能判断到当前是中国大陆，但是无法判断是哪个省份，不使用腾讯地图逆地理编码，
                        ///TODO： 如果能判5d z断到 港澳台，就使用腾讯地图逆地理编码
                        val addressNew = geocoderByTencentMap(location.latitude, location.longitude)
                        if (address != null) {
                            address.countryCode = addressNew?.countryCode
                            address.countryName = addressNew?.countryName
                            address.adminArea = addressNew?.adminArea
                        }
                    }
                    return address
                }
            } catch (e: Exception) {
                e.printStackTrace()
                LogUtil.e("LocationUtils requestLocation getFromLocation $e")
            }
            /// 地理反解析失败，使用Http请求
            return geocoderByTencentMap(location.latitude, location.longitude)
        }
        return null
    }

    @SuppressLint("MissingPermission")
    suspend fun realLocation(context: Context = LocalApplication.getInstance(), accuracy: String = Accuracy.LOW.value): Location? {
        if (!isCanLocationYes(context)) return null
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return suspendCancellableCoroutine { continuation ->
            requestLocation(locationManager, accuracy) { location ->
                lastLocation = location
                LogUtil.i("LocationUtils getLocation requestLocation $location")
                if (continuation.isActive) {
                    continuation.resume(location)
                }
            }
        }
    }

    @RequiresPermission(anyOf = [permission.ACCESS_COARSE_LOCATION, permission.ACCESS_FINE_LOCATION])
    private fun lastKnownLocation(context: Context): Location? {
        if (!isCanLocationYes(context)) return null

        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            val gpsLocation = if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
                locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            } else null

            val networkLocation = if (locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
                locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)
            } else null

            val passiveLocation = if (locationManager.isProviderEnabled(LocationManager.PASSIVE_PROVIDER)) {
                locationManager.getLastKnownLocation(LocationManager.PASSIVE_PROVIDER)
            } else null

            val fusedLocation = if (locationManager.isProviderEnabled(LocationManager.FUSED_PROVIDER)) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    locationManager.getLastKnownLocation(LocationManager.FUSED_PROVIDER)
                } else {
                    null
                }
            } else null

            LogUtil.i(
                "LocationUtils lastKnownLocation gpsLocation: $gpsLocation ,isFromMockProvider: ${gpsLocation?.isFromMockProvider} " +
                        ",networkLocation: $networkLocation ,isFromMockProvider: ${networkLocation?.isFromMockProvider} " +
                        ",passiveLocation: $passiveLocation ,isFromMockProvider: ${passiveLocation?.isFromMockProvider}" +
                        ",fusedLocation: $fusedLocation ,isFromMockProvider: ${fusedLocation?.isFromMockProvider}"
            )
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                gpsLocation?.isMock
                LogUtil.i(
                    "LocationUtils lastKnownLocation gpsLocation isMock: ${gpsLocation?.isMock} ,networkLocation: ${networkLocation?.isMock} ,passiveLocation: ${passiveLocation?.isMock} ,fusedLocation: ${fusedLocation?.isMock}"
                )
            }
            if (gpsLocation == null && networkLocation == null) {
                LogUtil.e("LocationUtils lastKnownLocation 用户可能使用了模拟定位软件")
//                return null
            }
            if (
                gpsLocation?.isFromMockProvider == true || networkLocation?.isFromMockProvider == true
                || passiveLocation?.isFromMockProvider == true || fusedLocation?.isFromMockProvider == true
            ) {
                LogUtil.e("LocationUtils lastKnownLocation 用户可能使用了模拟定位软件2")
//                return null
            }

            return gpsLocation ?: networkLocation ?: passiveLocation ?: fusedLocation
        }
        return null

    }

    @RequiresPermission(anyOf = [permission.ACCESS_COARSE_LOCATION, permission.ACCESS_FINE_LOCATION])
    private fun requestLocation(
        locationManager: LocationManager,
        accuracy: String = Accuracy.LOW.value,
        block: (location: Location?) -> Unit
    ) {
        var blockInner: ((location: Location?) -> Unit)? = block
        val horizontalAccuracy = when (accuracy) {
            Accuracy.HIGH.value -> Criteria.ACCURACY_HIGH
            Accuracy.MEDIUM.value -> Criteria.ACCURACY_MEDIUM
            Accuracy.LOW.value -> Criteria.ACCURACY_LOW
            else -> Criteria.ACCURACY_MEDIUM
        }
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            val criteria = Criteria()
            criteria.horizontalAccuracy = horizontalAccuracy // 高精度
            criteria.isAltitudeRequired = false // 不要求海拔
            criteria.isBearingRequired = false // 不要求方位
            criteria.isCostAllowed = true // 允许有花费
            criteria.powerRequirement = Criteria.POWER_HIGH // 低功耗
            val provider = locationManager.getBestProvider(criteria, true) ?: LocationManager.NETWORK_PROVIDER
            LogUtil.i("LocationUtils requestLocation provider: $provider")
            val threadLooper = HandlerThread("LocationUtils")
            threadLooper.start()
            val listener = object : LocationListener {
                override fun onLocationChanged(location: Location) {
                    locationManager.removeUpdates(this)
                    LogUtil.i("LocationUtils requestLocation onLocationChanged 1 : $location")
                    blockInner?.invoke(location)
                    blockInner = null
                    threadLooper.quit()
                }
            }
            locationManager.requestLocationUpdates(provider, 2000, 100f, listener, threadLooper.looper)
            threadLooper.join(8 * 1000)
            locationManager.removeUpdates(listener)
            threadLooper.quit()
            LogUtil.i("LocationUtils requestLocation provider timeout: $provider")
            blockInner?.invoke(null)
            blockInner = null
        }else{
            blockInner?.invoke(null)
            blockInner = null
        }
    }

    /** 仅使用中国域名时定位
     *   val api_key = "5CTBZ-K2OCW-BTXRG-3XSPF-4R33Z-KUBJU"
     *   val url = "https://apis.map.qq.com/ws/geocoder/v1?location=$latitude,$longitude&key=$api_key&get_poi=1"
     *   https://lbs.qq.com/service/webService/webServiceGuide/address/Gcoder
     **/

    private suspend fun geocoderByTencentMap(latitude: Double, longitude: Double): Address? {
        // 腾讯地图逆地理编码
        val api_key = "5CTBZ-K2OCW-BTXRG-3XSPF-4R33Z-KUBJU"
        val url = "https://apis.map.qq.com/ws/geocoder/v1?location=$latitude,$longitude&key=$api_key&get_poi=1"
        try {
            val geocoderRes = OtherOriginService.geocoderByTencentMap("$latitude,$longitude", api_key)
            if (geocoderRes.status == 0) {
                val nationCode = geocoderRes.result?.ad_info?.nation_code
                val cityCode = geocoderRes.result?.ad_info?.city_code
                val fixCountryCode =
                    if (nationCode == "156" && cityCode?.startsWith("15682") == true) {
                        "CN"/*MO*/
                    } else if (nationCode == "156" && cityCode?.startsWith("15681") == true) {
                        "HK"/*香港*/
                    } else if (nationCode == "156" && cityCode?.startsWith("15671") == true) {
                        "TW"/*台湾*/
                    } else if (nationCode == "156") {
                        "CN"
                    } else {
                        nationCode
                    }
                return Address(Locale.CHINA).apply {
                    countryCode = fixCountryCode
                    countryName =
                        geocoderRes.result?.address_component?.nation ?: nationCode ?: ""
                    locality =
                        geocoderRes.result?.address_component?.locality ?: geocoderRes.result?.address_component?.city ?: countryName
                    adminArea = geocoderRes.result?.address_component?.province
                    locality = geocoderRes.result?.address_component?.city
                    subLocality = geocoderRes.result?.address_component?.district
                    thoroughfare = geocoderRes.result?.address_component?.district
                    this.latitude = latitude
                    this.longitude = longitude
                    postalCode = geocoderRes.result?.ad_info?.adcode
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            LogUtil.e("LocationUtils geocoderByTencentMap error: $e")
        }
        return null
    }

    private fun isCanLocationYes(context: Context): Boolean {
        return isLocationGranted(context) && isGspLocationOpen()
    }

    private fun isGspLocationOpen(): Boolean {
        val locationManager =
            LocalApplication.getInstance().getSystemService(Context.LOCATION_SERVICE) as LocationManager? ?: return false
        if (LocationManagerCompat.isLocationEnabled(locationManager)) {
            return true
        }
        return LocationManagerCompat.isLocationEnabled(locationManager)
    }

    private fun isLocationGranted(context: Context): Boolean {
        return XXPermissions.isGranted(context, arrayOf(Permission.ACCESS_COARSE_LOCATION, Permission.ACCESS_FINE_LOCATION));
    }

}