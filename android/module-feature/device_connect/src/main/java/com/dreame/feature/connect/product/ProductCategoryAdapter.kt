package com.dreame.feature.connect.product

import android.view.View
import android.view.ViewGroup
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.feature.connect.product.bean.Category
import com.dreame.feature.connect.product.bean.CategoryListBean
import com.dreame.smartlife.connect.R

class ProductCategoryAdapter : BaseQuickAdapter<CategoryListBean, BaseViewHolder>(R.layout.layout_item_device_category) {

    override fun convert(holder: BaseViewHolder, item: CategoryListBean) {
        holder.setText(R.id.tv_title, item.categoryName)
        if (item.type == Category.SERIES) {
            //
            if (item.isSelected) {
                holder.getView<View>(R.id.ll_content).setBackgroundResource(R.color.common_bgWhite)
                holder.getView<View>(R.id.iv_indicator).visibility = View.VISIBLE
                holder.setTextColorRes(R.id.tv_title, R.color.common_textMain)
            } else {
                holder.getView<View>(R.id.iv_indicator).visibility = View.INVISIBLE
                holder.getView<View>(R.id.ll_content).setBackgroundResource(R.color.common_layoutBg)
                holder.setTextColorRes(R.id.tv_title, R.color.common_textSecond)
            }
        }
    }

    override fun onCreateDefViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder {
        if (viewType == 0) {
            return super.onCreateDefViewHolder(parent, viewType)
        } else {
            return createBaseViewHolder(parent, R.layout.layout_item_device_category_header)
        }

    }

    override fun getDefItemViewType(position: Int): Int {
        val item = getItem(position)
        return if (item.type == Category.CATEGORY) {
            1
        } else {
            0
        }


    }


}