package android.dreame.module.util

import android.content.Context
import android.database.Cursor
import android.media.MediaDrm
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.util.*

object DeviceIdUtil {

    private const val TAG = "DeviceIdUtil"
    private const val URI_GSF_CONTENT_PROVIDER = "content://com.google.android.gsf.gservices"
    private const val GSF_ID_KEY = "android_id"

    fun getDeviceId(context: Context): String {
        val deviceIdSp = context.getSharedPreferences("device_id_sp", Context.MODE_PRIVATE)
        val deviceId = deviceIdSp.getString(GSF_ID_KEY, "")
        if (!deviceId.isNullOrEmpty()) {
            LogUtil.d(TAG, "cache id:$deviceId")
            return deviceId
        }

        val deviceIdSb = StringBuilder()
        if (!getAndroidId(context).isNullOrBlank()) {
            deviceIdSb.append(getAndroidId(context))
            deviceIdSb.append("|")
        }
        if (!getDeviceSERIAL().isNullOrEmpty()) {
            deviceIdSb.append(getDeviceSERIAL())
            deviceIdSb.append("|")
        }
        if (!getDeviceUUID().isNullOrEmpty()) {
            deviceIdSb.append(getDeviceUUID())
            deviceIdSb.append("|")
        }
        if (!getMediaDrmId().isNullOrEmpty()) {
            deviceIdSb.append(getMediaDrmId())
//            deviceIdSb.append("|")
        }
//        if (!getGsfId(context).isNullOrEmpty()) {
//            deviceIdSb.append(getGsfId(context))
//        }
        LogUtil.d(TAG, "StringBuilder deviceId: ${deviceIdSb.toString()} ")
        if (deviceIdSb.isNotEmpty()) {
            val newId = hash("SHA1", deviceIdSb.toString()) ?: ""
            deviceIdSp.edit().putString(GSF_ID_KEY, newId).apply()
            return newId
        }
        return ""
    }

    fun getAndroidId(context: Context): String {
        var androidId = ""
        try {
            androidId =
                Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
        } catch (e: Exception) {
            Log.e(TAG, e.message ?: "getAndroidId error")
        }
        return androidId
    }

    fun getDeviceSERIAL(): String {
        try {
            return Build.SERIAL ?: ""
        } catch (ex: java.lang.Exception) {
            ex.printStackTrace()
        }
        return ""
    }

    /**
     * 获得设备硬件uuid
     * 使用硬件信息，计算出一个随机数
     *
     * @return 设备硬件uuid
     */
    fun getDeviceUUID(): String? {
        return try {
            val dev =
                "MOVAhomeAndroid"
            +Build.BOARD.length % 10
            +Build.BRAND.length % 10
            +Build.DEVICE.length % 10
            +Build.HARDWARE.length % 10
            +Build.ID.length % 10
            +Build.MODEL.length % 10
            +Build.PRODUCT.length % 10
            +getDeviceSERIAL().length % 10
            UUID(
                dev.hashCode().toLong(),
                getDeviceSERIAL().hashCode().toLong()
            ).toString()
        } catch (ex: java.lang.Exception) {
            ex.printStackTrace()
            ""
        }
    }

    fun getMediaDrmId(): String? {
        var mediaDrmId: String? = ""
        var drm: MediaDrm? = null
        try {
            val uuid = UUID(-0x121074568629b532L, -0x5c37d8232ae2de13L)
            drm = MediaDrm(uuid)
            val bytes = drm.getPropertyByteArray(MediaDrm.PROPERTY_DEVICE_UNIQUE_ID)
            mediaDrmId = hash("SHA1", bytes)
        } catch (ignored: Throwable) {
        } finally {
            if (drm != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    drm.close()
                } else {
                    drm.release()
                }
            }
        }
        return mediaDrmId
    }

    fun getGsfId(context: Context): String? {
        var gsfId = ""
        try {
            val uri = Uri.parse(URI_GSF_CONTENT_PROVIDER)
            val cursor: Cursor = context.contentResolver.query(
                uri,
                null,
                null,
                arrayOf(GSF_ID_KEY),
                null
            ) ?: return null
            if (!cursor.moveToFirst() || cursor.columnCount < 2) {
                cursor.close()
                return null
            }
            try {
                gsfId = cursor.getString(1)
                cursor.close()
            } catch (e: Throwable) {
                cursor.close()
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        }
        return gsfId
    }


    private fun hash(algorithm: String?, bytes: ByteArray?): String? {
        try {
            val md = MessageDigest.getInstance(algorithm)
            md.update(bytes)
            return byteToHexString(md.digest())
        } catch (ignored: Throwable) {
        }
        return ""
    }

    private fun hash(algorithm: String?, str: String): String? {
        try {
            val md = MessageDigest.getInstance(algorithm)
            md.update(str.toByteArray(StandardCharsets.UTF_8))
            return byteToHexString(md.digest())
        } catch (ignored: Throwable) {
        }
        return ""
    }

    private fun byteToHexString(data: ByteArray): String? {
        val hex = StringBuilder()
        // Iterating through each byte in the array
        for (i in data) {
            hex.append(String.format("%02X", i))
        }
        return hex.toString()
    }
}