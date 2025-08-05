package com.dreame.feature.connect.product

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.loader.ImageLoaderProxy
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.connect.R

class ProductScanNearbyAdapter :
    BaseQuickAdapter<DreameWifiDeviceBean, BaseViewHolder>(R.layout.layout_item_device_nearby) {
    override fun convert(holder: BaseViewHolder, item: DreameWifiDeviceBean) {
        holder.setText(R.id.tv_device_name, item.name)
        ImageLoaderProxy.getInstance().displayImage(context, item.product_pic_url, R.drawable.icon_robot_placeholder, holder.getView(R.id.iv_device))
    }
}