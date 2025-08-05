package android.dreame.module.manager

import android.content.Context
import android.dreame.module.LocalApplication
import android.dreame.module.bean.CountryBean
import android.dreame.module.task.RetrofitInitTask
import android.dreame.module.util.AssetsUtil
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.LogUtil
import android.os.SystemClock
import android.text.TextUtils
import android.util.Log
import androidx.lifecycle.LiveData
import com.dreame.hacklibrary.HackJniHelper
import com.kunminx.architecture.ui.callback.UnPeekLiveData
import com.tencent.mmkv.MMKV
import androidx.core.content.edit

object AreaManager {
    private const val TAG = "AreaManager"

    private const val AREAINFO = "AREAINFO"
    private const val FILENAME = "AREA"
    private const val COUNTRY_FILE_NAME = "country.json"
    private val areaKv =
        MMKV.mmkvWithID(FILENAME, MMKV.SINGLE_PROCESS_MODE, HackJniHelper.getCryptKey())

    private val areaSp =
        LocalApplication.getInstance().getSharedPreferences(FILENAME, Context.MODE_PRIVATE)

    // 默认国家地区，跟随手机当前国家地区变, 此处是兜底 中国
    private val defaultCountry = CountryBean().apply {
        code = "86"
        countryCode = "cn"
        en = "Chinese mainland"
        pinyin = "zg"
        name = "中国大陆"
        domain = "cn.iot.mova-tech.com"
        domainAliFy = "CN"
    }

    @Volatile
    private var currentCountry: CountryBean = defaultCountry

    private var countryFileList: List<CountryBean> = mutableListOf()

    init {
        val countryFileJsonStr =
            AssetsUtil.getStrFromAssets(LocalApplication.getInstance(), COUNTRY_FILE_NAME)
        countryFileList = GsonUtils.parseLists(countryFileJsonStr, CountryBean::class.java)
    }

    /**
     * 当前region
     */
    @JvmStatic
    fun getRegion(): String {
        val country = getCurrentCountry()
        return country.domain.let {
            it.substring(0, it.indexOf("."))
        }
    }

    /**
     * 当前region
     */
    @JvmStatic
    fun getCountryCode(): String {
        val country = getCurrentCountry()
        return country.countryCode;
    }

    @Synchronized
    fun getCurrentCountry(): CountryBean {
        if (currentCountry != defaultCountry) {
            return currentCountry
        }
        Log.d(
            TAG,
            "accountManager : ------getCurrentCountry------ ${LocalApplication.getCurrentProcessName()}"
        )
        return runCatching {
            var areaStr = areaSp.getString(AREAINFO, "")
            if (areaStr.isNullOrEmpty()) {
                areaStr =
                    areaKv.decodeString(AREAINFO, "")
                if (areaStr?.isNotEmpty() == true) {
                    areaSp.edit {
                        areaStr.replace("dreame.tech", "mova-tech.com")
                        putString(AREAINFO, areaStr)
                    }
                }
            }
            return if (TextUtils.isEmpty(areaStr)) {
                // 此处 应该读取 asstes/country.json  耗时约 75ms
                // 读取存储的国家， 如果是默认，则读取系统当前设置的地区，保存，否则，直接用存储的
                val startTime = SystemClock.elapsedRealtime()
                Log.d(TAG, "read country.json : ------start------")

                val find =
                    countryFileList.find {
                        LanguageManager.getInstance()
                            .getSystemLocale().country.equals(it.countryCode, true)
                    }

                Log.d(
                    TAG,
                    "read country.json : --------end------ ${SystemClock.elapsedRealtime() - startTime}"
                )
                (find ?: defaultCountry).also {
                    setCurrentCountry(it)
                }
            } else {
                val parseObject = GsonUtils.parseObject(areaStr, CountryBean::class.java)
                if (parseObject.name.equals("中国")) {
                    parseObject.name = "中国大陆"
                    parseObject.en = "Chinese mainland"
                }
                fixAliFyDomain(parseObject)
                currentCountry = parseObject
                Log.d(
                    TAG,
                    "getCurrentCountry areaStr not empty, countryCode:${currentCountry.countryCode}, domainAliFy:${currentCountry.domainAliFy}"
                )
                parseObject
            }
        }.onFailure {
            LogUtil.e("AreaManager", Log.getStackTraceString(it))
        }.getOrDefault(defaultCountry)

    }

    /**
     * 修老版本阿里domain缺失、错误问题
     */
    private fun fixAliFyDomain(parseObject: CountryBean) {
        Log.d(TAG, "fixAliFyDomain start: $parseObject")
        // domainAliFy修复老版本映射关系错误
        val element = countryFileList.firstOrNull {
            it.en == parseObject.en && it.name == parseObject.name
        }
        parseObject.domainAliFy = element?.domainAliFy
        parseObject.domain.replace("dreame.tech","mova-tech.com")
        areaSp.edit { putString(AREAINFO, GsonUtils.toJson(parseObject)) }
    }

    @Synchronized
    fun setCurrentCountry(countryBean: CountryBean?) {
        LogUtil.d(
            TAG,
            "setCurrentCountry: domain: ${countryBean?.domainAliFy} ,countryCode:  ${countryBean?.countryCode} ,name:  ${countryBean?.name}"
        )
        if (countryBean != null && currentCountry != countryBean) {
            currentCountry = countryBean
            areaSp.edit {
                putString(AREAINFO, GsonUtils.toJson(countryBean))
            }
        }
    }

    fun clear() {
        currentCountry = defaultCountry
        areaSp.edit(commit = true) { clear() }
        areaKv.remove(AREAINFO)
        areaKv.async()
    }
}