package com.dreame.smartlife.device.share

import android.dreame.module.data.entry.device.ShareUserRes
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.widget.ImageView
import androidx.constraintlayout.widget.ConstraintLayout
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.smartlife.device.R

class RecentContactAdapter(
    val onItemClick: ((shareUser: ShareUserRes) -> Unit)? = null
) :
    BaseQuickAdapter<ShareUserRes, BaseViewHolder>(R.layout.item_recent_contact){

    override fun convert(holder: BaseViewHolder, item: ShareUserRes) {
        val civAvatar = holder.getView<ImageView>(R.id.civ_avatar)
        ImageLoaderProxy.getInstance().displayImage(
            holder.itemView.context,
            item.avatar ?: "",
            R.drawable.icon_avatar_default,
            civAvatar
        )
        holder.setText(R.id.tv_nickname, item.name)
        holder.setText(R.id.tv_user_id, "ID: ${item.uid}")
        holder.setVisible(R.id.view_divider,holder.layoutPosition != data.size - 1)
        holder.getView<ConstraintLayout>(R.id.cl_item).setOnShakeProofClickListener{
            onItemClick?.invoke(item)
        }
    }
}