package com.dreame.feature.connect.scan

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.util.LogUtil
import android.text.TextUtils
import android.util.ArrayMap
import android.util.Log
import androidx.collection.ArraySet
import androidx.lifecycle.MutableLiveData
import com.dreame.smartlife.connect.BuildConfig
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Semaphore
import java.util.*
import java.util.concurrent.CancellationException

/**
 * 管理查询到的设备
 */
class DeviceScanModelCache : CoroutineScope by MainScope() {
    private val TAG = "DeviceModelCache"

    /**
     * 存储扫描到的设备, 未查到相关信息
     */
    private var mModelNameNoList = ArraySet<String>()

    /**
     * 存储所有的可见设备
     */
    private val mAllModelList = ArraySet<ProductListBean>()

    /**
     * 查询过model的list
     */
    private var mScanDeviceResultList: MutableList<DreameWifiDeviceBean> = mutableListOf()

    /**
     * 扫描到的modelname,记录当前的查询状态
     */
    private val mModelNameStatusMap = ArrayMap<String, Boolean>()

    /**
     * 扫描到的，正在查询的设备list
     */
    private var mScanningDeviceList: MutableList<DreameWifiDeviceBean> = mutableListOf()

    /**
     * 查询
     */
    private val queryScanDevice by lazy { DeviceScanQuery() }

    /**
     * 数据
     */
    val deviceScanBleCacheList = MutableLiveData(mScanDeviceResultList)

    private val semphone = Semaphore(1)

    private var queryJob: Job? = null

    fun clear(isForceClear: Boolean = false) {

        if (semphone.availablePermits == 0) {
            semphone.release()
        }

        if (queryJob?.isActive == true) {
            queryJob?.cancel(CancellationException("cancel by mySelf"))
            queryJob = null
        }
        DeviceScanCache.clear()
        mModelNameNoList.clear()
        if (isForceClear) {
            mAllModelList.clear()
        }
        mScanDeviceResultList.clear()
        mModelNameStatusMap.clear()
        mScanningDeviceList.clear()
        deviceScanBleCacheList.value = mScanDeviceResultList

    }

    /**
     * 获取设备信息
     * @param bean
     */
    fun queryNearbyDevivceInfo(list: List<DreameWifiDeviceBean>) {
        LogUtil.d(TAG, "+++++++++++++++++++++ queryNearbyDevivceInfo: +++++++++++++++++++++ ${Thread.currentThread().name} ${list.size} ")
        if (BuildConfig.DEBUG) {
            LogUtil.d(TAG, "+++++++++++++++++++++ queryNearbyDevivceInfo: dump start +++++++++++++++++++++ ")
            list.onEach {
                LogUtil.d(TAG, "+++++++++++++++++++++ $it")
            }
            LogUtil.d(TAG, "+++++++++++++++++++++ queryNearbyDevivceInfo: dump end +++++++++++++++++++++ ")
        }
        removeSannedDevice(list)
        for (bean in list) {
            // 遍历是否需要查询
            val isHit = isHitDevice(bean)
            if (isHit) {
                updateSannedDevice(bean)
            }
            if (!isHit && !checkDeviceNeedQuery(bean)) {
                continue
            }
            // 扫描到的设备列表
            addOrUpdateScanningDevice(bean)
        }

        // 添加到查询成功的列表里
        handleScanDeviceList()
        deviceScanBleCacheList.postValue(mScanDeviceResultList.toMutableList())
        if (mScanningDeviceList.isEmpty()) {
            return
        }
        // 开启查询
        queryDeviceModel()
    }

    private fun updateSannedDevice(device: DreameWifiDeviceBean) {
        val index = mScanDeviceResultList.hasSameDevice(device)
        if (index >= 0) {
            val item = mScanDeviceResultList.get(index)
            if (device.deviceWrapper != null) {
                item.deviceWrapper = device.deviceWrapper
            }
            item.timestamp = device.timestamp
        }
    }

    private fun removeSannedDevice(list: List<DreameWifiDeviceBean>) {
        val iterator = mScanDeviceResultList.iterator()
        val filter = list.filter {
            it.type == DeviceScanCache.TYPE_BLE && it.productId.isNullOrBlank()
        }
        while (iterator.hasNext()) {
            val next = iterator.next()
            if (next.isUpdate) {
                if (next.type == DeviceScanCache.TYPE_BLE) {
                    if (filter.contains(next)) {
                        iterator.remove()
                        continue
                    }
                } else {
                    if (filter.contains(next)) {
                        next.deviceWrapper = null
                        continue
                    }
                }

            }
        }
    }

    /**
     * 网络接口，根据model/productId 查询设备信息
     */
    private fun queryDeviceModel() {
        if (!semphone.tryAcquire()) {
            return
        }
        queryJob = launch {
            val map = ArrayMap(mModelNameStatusMap)
            queryScanDevice.queryDeviceModel(map).collect { list ->
                Log.d(TAG, "queryDeviceModel: ${Thread.currentThread().name}")
                // 挑出未查找到信息的设备，更新model状态
                handleQueryResult(list, map)
                // 更新scanning device
                handleScanningDevice(list)
                deviceScanBleCacheList.value = mScanDeviceResultList.toMutableList()
                if (semphone.availablePermits == 0) {
                    semphone.release()
                }
                // 再来一次
                queryDeviceModelAgain()
            }
        }
    }

    private fun queryDeviceModelAgain() {
        if (mScanningDeviceList.isNotEmpty()) {
            Log.d(TAG, "queryDeviceModelAgain: retry ${mScanningDeviceList.size}")
            queryDeviceModel()
        }
    }

    /**
     * 处理查询结果数据，更新scanning 列表状态
     * @param
     */
    private fun handleScanningDevice(list: List<ProductListBean>) {
        for (product in list) {
            val productId = product.productId
            val model = product.model
            val quickConnects = product.quickConnects
            val entries = quickConnects?.entries
            for (bean in mScanningDeviceList) {
                val pair = if (bean.product_model == model || bean.productId == productId) {
                    productId to model
                } else {
                    val entity = entries?.firstOrNull { it.key == bean.productId || it.value == bean.product_model }
                    entity?.let {
                        entity.key to entity.value
                    }
                }
                if (pair != null) {
                    Log.d(TAG, "handleScanningDevice: model: ${product.model} ,productId: ${product.productId}")
                    bean.deviceProduct = product
                    bean.productId = pair.first
                    bean.product_model = pair.second
                    bean.name = product.displayName
                    bean.product_pic_url = product.mainImage?.imageUrl
                    bean.imageUrl = product.mainImage?.imageUrl
                    bean.feature = product.feature
                    bean.scType = product.scType
                    bean.extendScType = product.extendScType
                    bean.isUpdate = true
                    fixBleResult2WifiSSID(bean)
                }
            }
        }
        val removeList = mutableListOf<DreameWifiDeviceBean>()
        for (bean in mScanningDeviceList) {
            val index = mScanDeviceResultList.hasSameDevice(bean)
            if (bean.isUpdate && !mModelNameNoList.contains(bean.product_model)
                && index < 0
            ) {
                if (BuildConfig.DEBUG) {
                    LogUtil.d(TAG, "handleScanningDevice mScanDeviceResultList add : $bean ")
                }
                mScanDeviceResultList.add(bean)
            }
            if (index >= 0) {
                val item = mScanDeviceResultList.get(index)
                if (bean.deviceWrapper != null) {
                    item.deviceWrapper = bean.deviceWrapper
                }
            }
            if (mModelNameNoList.contains(bean.product_model) || mModelNameNoList.contains(bean.productId)) {
                Log.d(TAG, "handleScanningDevice: ----mScanningDeviceList------ model: ${bean.product_model} ,productId: ${bean.productId}")
                bean.isUpdate = true
            }
            if (bean.isUpdate) {
                removeList.add(bean)
            }
        }
        // remove
        if (removeList.isNotEmpty()) {
            mScanningDeviceList.removeAll(removeList)
        }
    }

    /**
     * 处理查询结果数据，更新scanning map状态, 未查到设备信息list
     * @param  list
     * @param  map
     */
    private fun handleQueryResult(list: List<ProductListBean>, map: ArrayMap<String, Boolean>) {
        for (product in list) {
            val quickConnects = product.quickConnects
            quickConnects?.values?.onEach { model ->
                if (mModelNameStatusMap.contains(model)) {
                    mModelNameStatusMap[model] = true
                    map.remove(model)
                }
            }
            quickConnects?.keys?.onEach { productId ->
                if (mModelNameStatusMap.contains(productId)) {
                    mModelNameStatusMap[productId] = true
                    map.remove(productId)
                }
            }

        }
        if (map.isNotEmpty()) {
            // 未查询到信息
            val filter = map.filter {
                !it.value
            }.map {
                mModelNameStatusMap[it.key] = true
                it.key
            }
            mModelNameNoList.addAll(filter)
        }
    }

    /**
     * 处理将查询过的，设备更新到 mScanDeviceResultList中
     */
    private fun handleScanDeviceList() {
        for (device in mScanningDeviceList) {
            val index = mScanDeviceResultList.hasSameDevice(device)
            val b = index < 0 && device.isUpdate && (!mModelNameNoList.contains(device.product_model) && !mModelNameNoList.contains(device.productId))
            if (b) {
                if (BuildConfig.DEBUG) {
                    LogUtil.d(TAG, "handleScanDeviceList mScanDeviceResultList add ++++++++++++++++ : $device ")
                }
                mScanDeviceResultList.add(device)
                LogUtil.i(TAG, "onWifiDeviceResult: add device ----------- : " + device.ssid)
            }
        }
        // remove
        if (mScanningDeviceList.size > 0) {
            val iterator = mScanningDeviceList.iterator()
            while (iterator.hasNext()) {
                val next = iterator.next()
                if (next.isUpdate) {
                    iterator.remove()
                }
            }
        }
    }

    /**
     * 添加或者更新查询列表 mScanningDeviceList
     * @param bean
     */
    private fun addOrUpdateScanningDevice(bean: DreameWifiDeviceBean) {
        val index = mScanningDeviceList.hasSameDevice(bean)
        if (index < 0) {
            mScanningDeviceList.add(bean)
        } else {
            LogUtil.i("onWifiDeviceResult setDeviceWrapper " + bean.product_model + "   " + bean.deviceWrapper)
            if (index >= mScanDeviceResultList.size) {
                return
            }
            val deviceBean = mScanDeviceResultList[index]
            if (isBleDevice(bean)) {
                deviceBean.deviceWrapper = bean.deviceWrapper
            }
            deviceBean.timestamp = bean.timestamp
            deviceScanBleCacheList.value = mScanDeviceResultList
        }
    }

    /**
     * 检查并标记设备是否还需要调用接口查询
     */
    private fun checkDeviceNeedQuery(bean: DreameWifiDeviceBean): Boolean {
        val model = bean.product_model
        val productId = bean.productId

        /// 跳过蓝牙广播中的did设备 add by sunzhibin 2024/01/11
        if (productId == null && model == null) {
            mModelNameNoList.add(bean.result)
            return false
        }

        // 查询 model/productId
        if (mModelNameNoList.contains(model) || mModelNameNoList.contains(productId)) {
            // 根据 model 未查询到设备信息，则不再查询
            LogUtil.i("mModelNameNoList is contains $model")
            return false
        }
        // 需要查询的model, 标记结果
        if (null != model && !mModelNameStatusMap.containsKey(model)) {
            mModelNameStatusMap[model] = false
        }
        if (null != productId && !mModelNameStatusMap.containsKey(productId)) {
            mModelNameStatusMap[productId] = false
        }
        return true
    }

    /**
     * 命中并更新查询bean的信息
     * @param bean
     * @return 是否命中
     */
    private fun isHitDevice(bean: DreameWifiDeviceBean): Boolean {
        var isHit = false
        // 缓存中已存在mode，直接取出来赋值，无需查询
        for (product in mAllModelList) {
            val model = product.model
            val productId = product.productId
            val pair = if (model == bean.product_model || bean.productId == productId) {
                productId to model
            } else {
                val quickConnects = product.quickConnects
                val entries = quickConnects?.entries
                val entity = entries?.firstOrNull { it.key == bean.productId || it.value == bean.product_model }
                if (entity != null) {
                    entity.key to entity.value
                } else {
                    null
                }
            }
            if (pair != null) {
                Log.d(TAG, "isHitDevice: ----mAllModelList------ model: ${bean.product_model} ,productId: ${bean.productId}")
                bean.deviceProduct = product
                bean.productId = pair.first
                bean.product_model = pair.second
                bean.imageUrl = product.mainImage?.imageUrl
                bean.name = product.displayName
                bean.product_pic_url = product.mainImage?.imageUrl
                bean.feature = product.feature
                bean.scType = product.scType
                bean.extendScType = product.extendScType
                bean.isUpdate = true
                fixBleResult2WifiSSID(bean)

                if (!mModelNameStatusMap.containsKey(product.model)) {
                    mModelNameStatusMap.put(product.model, true)
                }
                if (bean.productId != null && !mModelNameStatusMap.containsKey(product.productId)) {
                    mModelNameStatusMap.put(product.productId, true)
                }
                isHit = true
                break
            }
        }

        if (!isHit) {
            mScanDeviceResultList.find { product ->
                product.isUpdate && product.deviceProduct != null && (TextUtils.equals(
                    product.product_model,
                    bean.product_model
                ) || TextUtils.equals(product.productId, bean.productId))
            }?.also { product ->
                LogUtil.d(TAG, "isHitDevice: ----mScanDeviceResultList------ model: ${bean.product_model} ,productId: ${bean.productId}")
                bean.deviceProduct = product.deviceProduct
                bean.product_model = product.product_model
                bean.imageUrl = product.imageUrl
                bean.productId = product.productId
                bean.name = product.name
                bean.productId = product.productId
                bean.product_pic_url = product.product_pic_url
                bean.feature = product.feature
                bean.scType = product.scType
                bean.extendScType = product.extendScType
                bean.isUpdate = true
                fixBleResult2WifiSSID(bean)
                if (!mModelNameStatusMap.containsKey(product.product_model)) {
                    mModelNameStatusMap.put(product.product_model, true)
                }
                if (bean.productId != null && !mModelNameStatusMap.containsKey(product.productId)) {
                    mModelNameStatusMap.put(product.productId, true)
                }
                isHit = true
            }
        }
        return isHit
    }

    /**
     * 将查询到的蓝牙设备 转换成Wi-Fi设备的样子
     * @param device 蓝牙设备
     */
    private fun fixBleResult2WifiSSID(device: DreameWifiDeviceBean) {
        if (isBleDevice(device)) {
            // 更新成Wi-Fi类型
            var wifiName = device.wifiName
            if (wifiName?.contains("_miap") == true) {
                return
            }
            val index = wifiName?.lastIndexOf("-") ?: -1
            if (index != -1) {
                wifiName = device.product_model?.replace(".", "-") + "_miap" + wifiName?.substring(index + 1)?.replace(":", "")?.uppercase(Locale.getDefault())
            }
            device.ssid = wifiName
            device.wifiName = wifiName
        }
    }


    private fun isBleDevice(device: DreameWifiDeviceBean): Boolean {
        return device.type == DeviceScanCache.TYPE_BLE
    }

    fun addQueryModel(list: List<ProductListBean>) {
        mAllModelList.clear()
        mAllModelList.addAll(list)
    }

}