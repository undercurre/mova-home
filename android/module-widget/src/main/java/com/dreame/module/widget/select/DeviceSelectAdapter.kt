package com.dreame.module.widget.select

import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.util.ScreenUtils
import android.widget.CheckedTextView
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.module.widget.select.bean.SelectDevice
import com.dreame.smartlife.widget.R

class DeviceSelectAdapter(layoutResId: Int = R.layout.item_appwidget_device_select) :
    BaseQuickAdapter<SelectDevice, BaseViewHolder>(layoutResId) {

    override fun convert(holder: BaseViewHolder, item: SelectDevice) {

        if (item.isUsed) {
            holder.setVisible(R.id.fl_bg, true)
            holder.setVisible(R.id.ctv_select, false)
        } else {
            holder.setVisible(R.id.fl_bg, false)
            holder.setVisible(R.id.ctv_select, true)
        }
        holder.setGone(R.id.tv_device_share, item.isMaster)
        ImageLoaderProxy.getInstance().displayImageWithCorners(
            context,
            item.imgUrl,
            R.drawable.icon_robot_placeholder,
            ScreenUtils.dp2px(context, 10f),
            holder.getView(R.id.iv_device_icon)
        )
        holder.setText(R.id.tv_device_name, item.deviceName)
        holder.getView<CheckedTextView>(R.id.ctv_select).isChecked = item.isSelect
    }
}