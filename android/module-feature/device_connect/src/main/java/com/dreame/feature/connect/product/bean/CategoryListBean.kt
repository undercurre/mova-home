package com.dreame.feature.connect.product.bean

import android.dreame.module.data.entry.ProductListBean

enum class Category {
    // 产品类型
    CATEGORY,

    // 产品系列
    SERIES,

    // 产品型号
    MODEL,

    // 补空
    MODEL_EMPTY,
}

data class CategoryListBean(
    val categoryName: String,
    val type: Category,
    val groupCategoryId: String,
    val childCategoryId: String,
    val productListBean: ProductListBean?,
    var isSelected: Boolean = false,
)
