package com.dreame.feature.connect.device.scan

import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.loader.ImageLoaderProxy
import android.widget.CheckBox
import android.widget.ImageView
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.connect.R

class ScanNearbyDeviceAdapter(layoutResId: Int = R.layout.item_device_nearby_scan) :
    BaseQuickAdapter<DreameWifiDeviceBean, BaseViewHolder>(layoutResId) {
    override fun convert(holder: BaseViewHolder, item: DreameWifiDeviceBean) {
        val ivDevice = holder.getView<ImageView>(R.id.iv_device)
        ImageLoaderProxy.getInstance().displayImage(context, item.product_pic_url, R.drawable.icon_robot_placeholder, ivDevice)
        val newName = item.product_model?.replace(".", "-")?.let {
            item.wifiName?.replace(it, "")
        }
        val showName = "${(item.name ?: "")}${newName}"

        holder.setText(R.id.tv_device_name, showName)
        holder.getView<CheckBox>(R.id.cb_switch).isChecked = item.isSelect
    }
}