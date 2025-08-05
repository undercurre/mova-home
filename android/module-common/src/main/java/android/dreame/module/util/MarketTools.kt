package android.dreame.module.util

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.dreame.module.LocalApplication
import android.net.Uri
import android.os.Build
import android.text.TextUtils
import android.util.Log

/**
 * 应该商店工具类
 */
object MarketTools {
    private const val schemaUrl = "market://details?id="
    private const val googleSchemaUrl = "https://play.google.com/store/apps/details?id="

    /**
     * 国内默认打开本机市场,其次应用宝,异常则跳浏览器
     * 国外默认google play,异常跳浏览器
     */
    fun startMarket(mContext: Context, packageName: String = mContext.packageName) {
        if (isForeignVersion()) {
            if (!openGooglePlay(mContext)) {
                openBrowserMarket(mContext, packageName, false)
            }
            return
        }
        // 获得手机厂商
        val deviceBrand = deviceBrand
        // 根据厂商获取对应市场的包名
        val brandName = deviceBrand.uppercase()
        var marketPackageName = getBrandMarketPackage(brandName)
        if (TextUtils.isEmpty(marketPackageName)) {
            marketPackageName = PACKAGE_NAME.TENCENT_PACKAGE_NAME
        }
        if (!openMarket(mContext, packageName, marketPackageName)) {
            openBrowserMarket(mContext, packageName, true)
        }
    }

    private fun openGooglePlay(context: Context): Boolean {
        try {
            val uri =
                Uri.parse(googleSchemaUrl + context.packageName)
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = uri
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            return true
        } catch (anf: ActivityNotFoundException) {
            Log.e("MarketTools", "要跳转的应用市场不存在!")
        } catch (e: Exception) {
            Log.e("MarketTools", "其他错误：" + e.message)
        }
        return false
    }

    /***
     * 打开应用市场
     * @param mContext
     * @param packageName
     * @param marketPackageName
     */
    private fun openMarket(
        mContext: Context,
        packageName: String,
        marketPackageName: String
    ): Boolean {
        try {
            val uri =
                Uri.parse(schemaUrl + packageName)
            val intent = Intent(Intent.ACTION_VIEW)
            intent.`package` = marketPackageName
            intent.data = uri
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            mContext.startActivity(intent)
            return true
        } catch (anf: ActivityNotFoundException) {
            if(PACKAGE_NAME.OPPO_PACKAGE_NAME.equals(marketPackageName)){
                openMarket(mContext,packageName,PACKAGE_NAME.OPPO_HEYTAP_PACKAGE_NAME)
                return true
            }else{
                Log.e("MarketTools", "要跳转的应用市场不存在!")
            }
        } catch (e: Exception) {
            Log.e("MarketTools", "其他错误：" + e.message)
        }
        return false
    }

    /**
     * 跳转到浏览器的应用
     */
    fun openBrowserMarket(context: Context, packageName: String, isCn: Boolean): Boolean {
        val url = if (isCn) {
            "https://a.app.qq.com/o/simple.jsp?pkgname=$packageName"
        } else {
            "https://play.google.com/store/apps/details?id=$packageName"
        }
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        if (intent.resolveActivity(context.packageManager) != null) {
            context.startActivity(intent)
            return true
        }
        return false
    }

    private fun getBrandMarketPackage(brandName: String): String {
        when (brandName) {
            BRAND.HUAWEI_BRAND, BRAND.HONOR_BRAND -> {
                //华为
                return PACKAGE_NAME.HUAWEI_PACKAGE_NAME
            }
            BRAND.OPPO_BRAND, BRAND.ONEPLUS_BRAND, BRAND.REALME_BRAND -> {
                return PACKAGE_NAME.OPPO_PACKAGE_NAME
            }
            BRAND.VIVO_BRAND, BRAND.IQOO_BRAND -> {
                //vivo
                return PACKAGE_NAME.VIVO_PACKAGE_NAME
            }
            BRAND.XIAOMI_BRAND, BRAND.REDMI_BRAND -> {
                //小米
                return PACKAGE_NAME.XIAOMI_PACKAGE_NAME
            }
            else -> return ""
        }
    }

    private fun isForeignVersion(): Boolean {
        return LocalApplication.getInstance().isGpVersion
    }

    /**
     * 获取手机厂商
     */
    private val deviceBrand: String
        private get() = Build.BRAND

    object BRAND {
        const val HUAWEI_BRAND = "HUAWEI" //HUAWEI_PACKAGE_NAME
        const val HONOR_BRAND = "HONOR" //HUAWEI_PACKAGE_NAME
        const val OPPO_BRAND = "OPPO" //OPPO_PACKAGE_NAME
        const val VIVO_BRAND = "VIVO" //VIVO_PACKAGE_NAME
        const val XIAOMI_BRAND = "XIAOMI" //XIAOMI_PACKAGE_NAME
        const val ONEPLUS_BRAND = "ONEPLUS" //ONEPLUS_PACKAGE_NAME
        const val REALME_BRAND = "REALME" //REALME_PACKAGE_NAME
        const val REDMI_BRAND = "REDMI" //REDMI_PACKAGE_NAME
        const val IQOO_BRAND = "IQOO" //IQOO_PACKAGE_NAME
    }

    /**
     * 华为,oppo,vivo,小米,应用宝,google
     */
    object PACKAGE_NAME {
        const val OPPO_PACKAGE_NAME = "com.oppo.market" //oppo
        const val OPPO_HEYTAP_PACKAGE_NAME = "com.heytap.market" //oppo 老版本
        const val VIVO_PACKAGE_NAME = "com.bbk.appstore" //vivo
        const val HUAWEI_PACKAGE_NAME = "com.huawei.appmarket" //华为
        const val XIAOMI_PACKAGE_NAME = "com.xiaomi.market" //小米
        const val GOOGLE_PACKAGE_NAME = "com.android.vending" //google
        const val TENCENT_PACKAGE_NAME = "com.tencent.android.qqdownloader" //应用宝
        const val SAMSUNG_PACKAGE_NAME = "com.sec.android.app.samsungapps" //三星
    }


}