package com.dreame.feature.connect.product

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.data.entry.ProductListBean
import com.dreame.feature.connect.product.bean.CategoryListBean
import com.dreame.module.base.mvi.UiAction
import com.dreame.module.base.mvi.UiEvent
import com.dreame.module.base.mvi.UiState


data class ProductSelectListUiState(
    val isLoading: Boolean,
    val isRefreshing: Boolean,
    val categoryList: List<CategoryListBean>,
    val productList: List<CategoryListBean>,
    val nearbyDeviceList: List<DreameWifiDeviceBean>,
    val productAllList: List<ProductListBean>,
    var lastShowSeriesId: String,
    var lastClickSeriesPosition: Int,
) : UiState


sealed class ProductSelectListUiEvent : UiEvent {
    data class ShowToast(val message: String?) : ProductSelectListUiEvent()
    data class CategoryScrollTo(val position: Int) : ProductSelectListUiEvent()
    data class CategoryNotifyPosition(val position: Int, val lastPosition: Int) : ProductSelectListUiEvent()
    data class ProductScrollTo(val position: Int) : ProductSelectListUiEvent()

}

sealed class ProductSelectListUiAction : UiAction {

    object InitData : ProductSelectListUiAction()
    object OnRefresh : ProductSelectListUiAction()

    data class ClickCategory(val position: Int) : ProductSelectListUiAction()
    data class ClickNearby(val nearbyDevice: DreameWifiDeviceBean) : ProductSelectListUiAction()
    data class ClickProduct(val position: Int) : ProductSelectListUiAction()
    data class ScrollProduct(val position: Int) : ProductSelectListUiAction()
    data class NearbyDevice(val list: MutableList<DreameWifiDeviceBean>) : ProductSelectListUiAction()

}
