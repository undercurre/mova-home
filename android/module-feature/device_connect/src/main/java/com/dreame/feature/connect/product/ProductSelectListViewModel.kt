package com.dreame.feature.connect.product

import android.dreame.module.RoutPath
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.constant.ParameterConstants
import android.dreame.module.data.Result
import android.dreame.module.data.datasource.local.ProductLocalDataSource
import android.dreame.module.data.datasource.remote.ProductRemoteDataSource
import android.dreame.module.data.entry.ProductCategoryRes
import android.dreame.module.data.entry.ProductListBean
import android.dreame.module.data.repostitory.ProductRepository
import android.dreame.module.trace.EventCommonHelper
import android.dreame.module.trace.ModuleCode
import android.dreame.module.trace.PairNetEventCode
import android.dreame.module.util.LogUtil
import androidx.lifecycle.viewModelScope
import com.therouter.TheRouter
import com.blankj.utilcode.util.NetworkUtils
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.feature.connect.product.bean.Category
import com.dreame.feature.connect.product.bean.CategoryListBean
import com.dreame.feature.connect.trace.BuriedConnectHelper
import com.dreame.module.base.mvi.BaseViewModel
import com.dreame.module.base.mvi.UiAction
import com.dreame.smartlife.config.event.StepId
import com.dreame.smartlife.config.step.ScanType
import com.dreame.smartlife.config.step.StepData
import com.zj.mvi.core.setState
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onStart
import kotlinx.coroutines.launch

class ProductSelectListViewModel : BaseViewModel<ProductSelectListUiState, ProductSelectListUiEvent>() {

    private val repo by lazy { ProductRepository(ProductRemoteDataSource(), ProductLocalDataSource()) }

    override fun createInitialState(): ProductSelectListUiState {
        return ProductSelectListUiState(
            false, false, emptyList(), emptyList(), emptyList(), emptyList(), "", -1
        )
    }

    override fun dispatchAction(acton: UiAction) {
        when (acton) {
            is ProductSelectListUiAction.InitData -> {

            }

            is ProductSelectListUiAction.OnRefresh -> {
                queryProductCategory()
            }

            is ProductSelectListUiAction.ClickProduct -> {
                //
                viewModelScope.launch(Dispatchers.IO) {
                    gotoConnect(acton.position)
                }
            }

            is ProductSelectListUiAction.ClickCategory -> {
                clickCategoryScrollTo(acton.position)
            }

            is ProductSelectListUiAction.ClickNearby -> {
                // 附近设备
                gotoConnectNearby(acton.nearbyDevice)
            }

            is ProductSelectListUiAction.ScrollProduct -> {
                scrollProduct(acton.position)
            }

            is ProductSelectListUiAction.NearbyDevice -> {
                _uiStates.setState {
                    copy(nearbyDeviceList = acton.list)
                }
            }

        }


    }

    /**
     * 跳转手动配网
     */
    private fun gotoConnect(position: Int) {
        val timestamp = System.currentTimeMillis()
        val categoryListBean = uiStates.value.productList.get(position)
        if (categoryListBean.type == Category.MODEL) {
            val productBean = categoryListBean.productListBean!!
            EventCommonHelper.eventCommonPageInsert(
                ModuleCode.PairNetNew.code, PairNetEventCode.EnterSourceType.code, hashCode(),
                "", productBean.model,
                int1 = ParameterConstants.ORIGIN_ITEM, str1 = BuriedConnectHelper.currentSessionID()
            )
            val productInfo = StepData.ProductInfo(
                productBean.model, productBean.quickConnects,
                null, null, productBean.productId, productBean.feature, productBean.model,
                false, ParameterConstants.ORIGIN_ITEM,
                productBean.scType, productBean.extendScType, null, null, productBean.mainImage?.imageUrl, timestamp = timestamp
            )
            var int1 = -1
            val path = if (productInfo.productModel?.contains(".mower.") == true) {
                RoutPath.PRODUCT_CONNECT_PREPARE_BLE
            } else if (productInfo.productModel?.contains(".toothbrush.") == true || productInfo.extendScType?.contains(ScanType.MCU) == true) {
                RoutPath.DEVICE_BOOT_UP
            } else {
                if (NetworkUtils.isWifiConnected()) {
                    int1 = 1
                    RoutPath.DEVICE_ROUTER_PASSWORD
                } else {
                    int1 = 0
                    RoutPath.DEVICE_ROUTER_TIPS
                }
            }
            if (int1 > 0) {
                EventCommonHelper.eventCommonPageInsert(
                    ModuleCode.PairNetNew.code, PairNetEventCode.WifiIsConnect.code, hashCode(),
                    "", productBean.model,
                    int1 = int1, str1 = BuriedConnectHelper.currentSessionID()
                )
            }
            TheRouter.build(path)
                .withParcelable(ParameterConstants.EXTRA_PRODUCT_INFO, productInfo)
                .navigation()
        }
    }

    private fun gotoConnectNearby(nearbyDevice: DreameWifiDeviceBean) {
        LogUtil.d("gotoConnectNearby: $nearbyDevice")
        val timestamp = System.currentTimeMillis()
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.EnterSourceType.code, hashCode(),
            "", nearbyDevice.product_model,
            int1 = ParameterConstants.ORIGIN_SCAN, str1 = BuriedConnectHelper.currentSessionID()
        )
        val productInfo = StepData.ProductInfo(
            nearbyDevice.deviceProduct?.model,
            nearbyDevice.deviceProduct?.quickConnects,
            nearbyDevice.wifiName,
            null,
            nearbyDevice.deviceProduct?.productId,
            nearbyDevice.deviceProduct?.feature,
            nearbyDevice.product_model,
            false,
            ParameterConstants.ORIGIN_SCAN,
            nearbyDevice.deviceProduct?.scType,
            nearbyDevice.deviceProduct?.extendScType,
            null,
            null,
            nearbyDevice.product_pic_url,
            timestamp = timestamp
        )
        var int1 = -1
        var stepId = -1
        val path = if (productInfo.productModel?.contains(".mower.") == true) {
            RoutPath.PRODUCT_CONNECT_PREPARE_BLE
        } else if (productInfo.productModel?.contains(".toothbrush.") == true || productInfo.extendScType?.contains(ScanType.MCU) == true) {
            stepId = StepId.STEP_DEVICE_SCAN_BLE
            RoutPath.DEVICE_BOOT_UP
        } else {
            if (NetworkUtils.isWifiConnected()) {
                int1 = 1
                RoutPath.DEVICE_ROUTER_PASSWORD
            } else {
                int1 = 0
                RoutPath.DEVICE_ROUTER_TIPS
            }
        }
        EventCommonHelper.eventCommonPageInsert(
            ModuleCode.PairNetNew.code, PairNetEventCode.WifiIsConnect.code, hashCode(),
            "", nearbyDevice.product_model,
            int1 = int1, str1 = BuriedConnectHelper.currentSessionID()
        )
        TheRouter.build(path)
            .withParcelable(ParameterConstants.EXTRA_PRODUCT_INFO, productInfo)?.apply {
                if (stepId != -1) {
                    withInt(ExtraConstants.EXTRA_STEP, stepId)
                }
            }?.navigation()
    }


    /**
     * 点击分类
     * @param position
     */
    private fun clickCategoryScrollTo(position: Int) {
        viewModelScope.launch {
            val categoryList = uiStates.value.categoryList
            val productList = uiStates.value.productList
            val lastShowSeriesId = uiStates.value.lastShowSeriesId
            val lastClickSeriesPosition = uiStates.value.lastClickSeriesPosition
            val item = categoryList.get(position)
            if (item.type == Category.SERIES) {

                if (position != lastClickSeriesPosition) {
                    // 点击系列
                    val indexOfFirst = productList.indexOfFirst {
                        it.childCategoryId == item.childCategoryId
                    }
                    _uiStates.value.lastClickSeriesPosition = position
                    categoryList.get(lastClickSeriesPosition).isSelected = false
                    categoryList.get(position).isSelected = true
                    _uiEvents.send(ProductSelectListUiEvent.CategoryNotifyPosition(position, lastClickSeriesPosition))

                    if (indexOfFirst != -1 && lastShowSeriesId != item.childCategoryId) {
                        _uiStates.value.lastShowSeriesId = item.childCategoryId
                        _uiEvents.send(ProductSelectListUiEvent.ProductScrollTo(indexOfFirst))
                    }

                }
            }
        }
    }

    /**
     * 滚动产品
     * @param position
     */
    private fun scrollProduct(position: Int) {
        viewModelScope.launch {
            val categoryList = uiStates.value.categoryList
            val productList = uiStates.value.productList
            val lastShowSeriesId = uiStates.value.lastShowSeriesId
            val item = productList.get(position)
            val indexOfFirst = categoryList.indexOfFirst {
                item.childCategoryId == it.childCategoryId && it.type == Category.SERIES
            }
            if (indexOfFirst != -1 && lastShowSeriesId != item.childCategoryId) {

                val lastPosition = uiStates.value.lastClickSeriesPosition
                categoryList.get(lastPosition).isSelected = false
                categoryList.get(indexOfFirst).isSelected = true
                _uiEvents.send(ProductSelectListUiEvent.CategoryNotifyPosition(indexOfFirst, lastPosition))

                _uiStates.value.lastShowSeriesId = item.childCategoryId
                uiStates.value.lastClickSeriesPosition = indexOfFirst
                _uiEvents.send(ProductSelectListUiEvent.CategoryScrollTo(indexOfFirst))
            }
        }
    }


    /**
     * 查询产品分类
     */
    private fun queryProductCategory() {
        viewModelScope.launch {
            repo.queryProductCategoryList().onStart {
                _uiStates.setState { copy(isRefreshing = true) }
            }.onCompletion {
                _uiStates.setState { copy(isRefreshing = false) }
            }.collect {
                //
                when (it) {
                    is Result.Success -> {
                        it.data?.let {
                            handleResult(it)
                        }
                    }

                    is Result.Error -> {

                    }

                    else -> {}

                }
            }
        }
    }

    private fun handleResult(list: List<ProductCategoryRes>) {
        val categoryList = mutableListOf<CategoryListBean>()
        val productList = mutableListOf<CategoryListBean>()
        var lastShowSeriesId = ""
        var lastClickSeriesPosition = 0
        list.onEachIndexed { groupIndex, groupBean ->
            val groupCategoryId = groupBean.categoryId ?: groupIndex.toString()
            var isGroupAdded = false
            groupBean.childrenList?.onEachIndexed { childIndex, childBean ->
                val childCategoryId = childBean.categoryId ?: childIndex.toString()
                val listBeans = childBean.productList?.map {
                    CategoryListBean(
                        groupBean.name ?: "",
                        Category.MODEL,
                        groupCategoryId,
                        childCategoryId,
                        it
                    )
                } ?: emptyList()
                if (listBeans.isNotEmpty()) {
                    if (!isGroupAdded) {
                        isGroupAdded = true
                        // 扫地机产品、洗地机产品、高端产品
                        categoryList.add(CategoryListBean(groupBean.name ?: "", Category.CATEGORY, groupCategoryId, groupCategoryId, null))
                    }
                    //二合一系列
                    val element = CategoryListBean(childBean.name ?: "", Category.SERIES, groupCategoryId, childCategoryId, null)
                    if (lastShowSeriesId.isEmpty()) {
                        lastShowSeriesId = childCategoryId
                        lastClickSeriesPosition = categoryList.size
                        element.isSelected = true
                    }
                    categoryList.add(element)
                    productList.add(element)
                    productList.addAll(listBeans)
                }
            }
        }

        val productAllList = mutableListOf<ProductListBean>()
        list?.onEach {
            it.childrenList?.onEach {
                it.productList?.let {
                    productAllList.addAll(it)
                }
            }
        }
        _uiStates.setState {
            copy(
                productAllList = productAllList,
                categoryList = categoryList,
                productList = productList,
                lastShowSeriesId = lastShowSeriesId,
                lastClickSeriesPosition = lastClickSeriesPosition
            )
        }
    }


}