package com.dreame.feature.connect.product

import android.dreame.module.loader.ImageLoaderProxy
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.feature.connect.product.bean.Category
import com.dreame.feature.connect.product.bean.CategoryListBean
import com.dreame.smartlife.connect.R


class ProductListAdapter : BaseQuickAdapter<CategoryListBean, BaseViewHolder>(R.layout.layout_item_device) {

    override fun convert(holder: BaseViewHolder, item: CategoryListBean) {
        if (item.productListBean != null) {
            //
            val view = holder.getView<ImageView>(R.id.iv_device)
            val imageUrl = item.productListBean?.mainImage?.imageUrl ?: ""
            ImageLoaderProxy.getInstance().displayImage(context, imageUrl, R.drawable.icon_robot_placeholder, view)
            holder.setText(R.id.tv_device_name, item.productListBean.displayName)
        } else {
            if (item.type == Category.MODEL_EMPTY) {

            } else {
                holder.setText(R.id.tv_title, item.categoryName)
            }
        }
    }


    override fun onCreateDefViewHolder(parent: ViewGroup, viewType: Int): BaseViewHolder {
        if (viewType == 0) {
            return super.onCreateDefViewHolder(parent, viewType)
        } else if (viewType == 1) {
            val createBaseViewHolder = createBaseViewHolder(parent, R.layout.layout_item_device_header)
            val params = StaggeredGridLayoutManager.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
            params.isFullSpan = true
            createBaseViewHolder.itemView.layoutParams = params
            return createBaseViewHolder

        } else {
            return createBaseViewHolder(parent, R.layout.layout_item_device_empty)
        }

    }

    override fun getDefItemViewType(position: Int): Int {
        val item = getItem(position)
        return when (item.type) {
            Category.MODEL_EMPTY -> 2
            Category.SERIES -> 1
            Category.MODEL -> 0
            else -> 0
        }
    }

}