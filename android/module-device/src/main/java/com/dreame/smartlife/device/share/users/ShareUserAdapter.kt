package com.dreame.smartlife.device.share.users

import android.dreame.module.data.entry.device.ShareUserRes
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.graphics.Color
import android.widget.ImageView
import android.widget.RelativeLayout
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.daimajia.swipe.SwipeLayout
import com.daimajia.swipe.implments.SwipeItemRecyclerMangerImpl
import com.daimajia.swipe.interfaces.SwipeAdapterInterface
import com.daimajia.swipe.interfaces.SwipeItemMangerInterface
import com.daimajia.swipe.util.Attributes
import com.dreame.smartlife.device.R

class ShareUserAdapter(
    private val showShareFeature: Boolean = false,
    val onItemClick: ((shareUser: ShareUserRes) -> Unit)? = null,
    val onDeleteClick: ((uid: String) -> Unit)? = null
) :
    BaseQuickAdapter<ShareUserRes, BaseViewHolder>(R.layout.item_share_user_new),
    SwipeAdapterInterface, SwipeItemMangerInterface {

    var mItemManger = SwipeItemRecyclerMangerImpl(this)

    override fun convert(holder: BaseViewHolder, item: ShareUserRes) {
        mItemManger.bindView(holder.itemView, holder.layoutPosition)
        val swipeLayout = holder.getView<SwipeLayout>(R.id.sl_container)
        swipeLayout.close(false)

        holder.setVisible(R.id.iv_more, showShareFeature)

        val civAvatar = holder.getView<ImageView>(R.id.civ_avatar)
        ImageLoaderProxy.getInstance().displayImage(
            holder.itemView.context,
            item.avatar ?: "",
            R.drawable.icon_avatar_default,
            civAvatar
        )
        holder.setText(R.id.tv_nickname, item.name)
        holder.setText(R.id.tv_user_id, "ID: ${item.uid}")
        holder.setVisible(R.id.view_divider, holder.layoutPosition != data.size - 1)
        if (item.sharedStatus == 0) {
            holder.setText(R.id.tv_share_state, R.string.waiting_receive)
//            holder.setTextColor(R.id.tv_share_state, Color.parseColor("#661D1E20"))
            holder.setTextColor(R.id.tv_share_state, ContextCompat.getColor(context, R.color.common_warn1))
        } else if (item.sharedStatus == 1) {
            holder.setText(R.id.tv_share_state, R.string.already_accept)
//            holder.setTextColor(R.id.tv_share_state, Color.parseColor("#55E53C"))
            holder.setTextColor(R.id.tv_share_state, ContextCompat.getColor(context, R.color.common_green1))
        }

        val rlCancelShare = holder.getView<RelativeLayout>(R.id.rl_cancel_share)
        if(data.size == 1){
            rlCancelShare.setBackgroundResource(R.drawable.common_shape_red_end_r12)
        }else {
            when (holder.layoutPosition) {
                0 -> {
                    rlCancelShare.setBackgroundResource(R.drawable.common_shape_red_top_end_r12)
                }
                (data.size - 1) -> {
                    rlCancelShare.setBackgroundResource(R.drawable.common_shape_red_bottom_end_r12)
                }
                else -> {
                    rlCancelShare.setBackgroundColor(context.getColor(R.color.common_red1))
                }
            }
        }

        holder.getView<ConstraintLayout>(R.id.cl_container).setOnShakeProofClickListener {
            onItemClick?.invoke(item)
        }
        holder.getView<RelativeLayout>(R.id.rl_cancel_share).setOnShakeProofClickListener {
            onDeleteClick?.invoke(item.uid ?: "")
        }
    }

    override fun getSwipeLayoutResourceId(position: Int): Int = R.id.sl_container
    override fun openItem(position: Int) {
        mItemManger.openItem(position)
    }

    override fun closeItem(position: Int) {
        mItemManger.closeItem(position)
    }

    override fun closeAllExcept(layout: SwipeLayout?) {
        mItemManger.closeAllExcept(layout)
    }

    override fun closeAllItems() {
        mItemManger.closeAllItems()
    }

    override fun getOpenItems(): MutableList<Int> {
        return mItemManger.getOpenItems()
    }

    override fun getOpenLayouts(): MutableList<SwipeLayout> {
        return mItemManger.getOpenLayouts()
    }

    override fun removeShownLayouts(layout: SwipeLayout?) {
        mItemManger.removeShownLayouts(layout)
    }

    override fun isOpen(position: Int): Boolean {
        return mItemManger.isOpen(position)
    }

    override fun getMode(): Attributes.Mode {
        return mItemManger.getMode()
    }

    override fun setMode(mode: Attributes.Mode?) {
        return mItemManger.setMode(mode)
    }
}