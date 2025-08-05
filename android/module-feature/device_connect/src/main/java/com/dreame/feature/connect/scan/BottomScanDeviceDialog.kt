package com.dreame.feature.connect.scan

import android.content.Context
import android.dreame.module.bean.device.DreameWifiDeviceBean
import android.dreame.module.loader.ImageLoaderProxy
import android.graphics.Color
import android.os.SystemClock
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.view.animation.Animation
import android.widget.ImageView
import android.widget.TextView
import androidx.viewpager2.widget.ViewPager2
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import android.dreame.module.ext.setOnShakeProofClickListener
import com.dreame.smartlife.connect.R
import razerdp.basepopup.BasePopupWindow
import razerdp.util.animation.AnimationHelper
import razerdp.util.animation.TranslationConfig

class BottomScanDeviceDialog(context: Context) : BasePopupWindow(context) {

    private val tvNegative: TextView
    private val tvPositive: TextView
    private val tvContent: TextView
    private val viewpager2: ViewPager2
    private val iv_right: ImageView
    private val iv_left: ImageView

    private val adapter by lazy { DeviceSelectAdapter() }

    // wifiName: time
    private val deviceHideMap = mutableMapOf<String, Long>()

    init {
        popupGravity = Gravity.BOTTOM
        setOutSideDismiss(false)
        setBackPressEnable(false)
        setBackgroundColor(Color.parseColor("#1A000000"))
        setContentView(R.layout.dialog_bottom_scan_device)
        tvNegative = findViewById(R.id.tv_negative)
        iv_right = findViewById(R.id.iv_right)
        iv_left = findViewById(R.id.iv_left)
        viewpager2 = findViewById(R.id.viewpager2)
        tvPositive = findViewById(R.id.tv_positive)
        tvContent = findViewById(R.id.tv_title)

        initView()

    }

    private fun initView() {
        viewpager2.adapter = adapter
        iv_left.setOnClickListener {
            val currentItem = viewpager2.currentItem
            val index = currentItem - 1
            if (currentItem > 0) {
                viewpager2.currentItem = index
            }
            hideOrShowArrow(index, adapter.data.size)
        }
        iv_right.setOnClickListener {
            val currentItem = viewpager2.currentItem
            val index = currentItem + 1
            if (adapter.data.size > index) {
                viewpager2.currentItem = index
            }
            hideOrShowArrow(index, adapter.data.size)
        }
    }

    val callback by lazy {
        object : ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                super.onPageSelected(position)
                hideOrShowArrow(position, adapter.data.size)
            }
        }
    }

    override fun showPopupWindow() {
        super.showPopupWindow()
        viewpager2.registerOnPageChangeCallback(callback)
    }

    override fun dismiss() {
        super.dismiss()
        viewpager2.unregisterOnPageChangeCallback(callback)

    }

    private fun hideOrShowArrow(currentItem: Int, size: Int) {
        if (currentItem <= 0) {
            iv_left.visibility = View.INVISIBLE
            if (size > 1) {
                iv_right.visibility = View.VISIBLE
            } else {
                iv_right.visibility = View.INVISIBLE
            }
        } else {
            iv_left.visibility = View.VISIBLE
            if (currentItem >= size - 1) {
                iv_right.visibility = View.INVISIBLE
            } else {
                iv_right.visibility = View.VISIBLE
            }
        }
        val title = if (size > 1) context.getString(R.string.text_find_more_device) else context.getString(R.string.home_find_device)
        tvContent.text = title
    }

    override fun onCreateShowAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withTranslation(TranslationConfig.FROM_BOTTOM.apply { duration(300) })
            .toShow()
    }

    override fun onCreateDismissAnimation(): Animation {
        return AnimationHelper.asAnimation()
            .withTranslation(TranslationConfig.TO_BOTTOM.apply { duration(300) })
            .toDismiss()
    }

    fun currentDevice(): DreameWifiDeviceBean? {
        if (adapter.data.isEmpty()) {
            return null
        }
        val currentItem = viewpager2.currentItem
        return adapter.getItem(currentItem)
    }

    /**
     * 显示提示对话框
     * @param content 提示内容
     * @param positive 确认按钮文案
     * @param negative 拒绝按钮文案,为空时，隐藏此按钮
     * @param positiveCallback 确认按钮点击回调
     * @param negativeCallback 拒绝按钮点击回调
     */
    fun show(
        content: String,
        positive: String,
        negative: String? = "",
        positiveCallback: (dialog: BottomScanDeviceDialog) -> Unit,
        negativeCallback: ((dialog: BottomScanDeviceDialog) -> Unit)? = null
    ) {
        tvContent.text = content
        tvNegative.text = negative
        tvPositive.text = positive
        tvNegative.visibility = if (TextUtils.isEmpty(negative)) View.GONE else View.VISIBLE
        tvNegative.setOnShakeProofClickListener {
            if (adapter.data.isNotEmpty()) {
                val currentItem = viewpager2.currentItem
                val wifiName = adapter.getItem(currentItem).wifiName
                deviceHideMap.put(wifiName ?: "", SystemClock.elapsedRealtime())
                adapter.removeAt(currentItem)
                // 更新按钮状态
                var currentItem2 = viewpager2.currentItem
                if (currentItem2 == adapter.data.size) {
                    currentItem2 = adapter.data.size - 1
                }
                hideOrShowArrow(currentItem2, adapter.data.size)
            }
            if (adapter.data.isEmpty()) {
                dismiss()
            }
            negativeCallback?.invoke(this)
        }
        tvPositive.setOnShakeProofClickListener {
            positiveCallback.invoke(this)
        }

        showPopupWindow()
    }

    fun setList(list: MutableList<DreameWifiDeviceBean>): Boolean {
        val iterator = list.iterator()
        while (iterator.hasNext()) {
            val bean = iterator.next()
            if (deviceHideMap.contains(bean.wifiName)) {
                iterator.remove()
            }
        }
        if (list.isEmpty()) {
            return false
        }
        val currentItem = viewpager2.currentItem
        hideOrShowArrow(currentItem, list.size)
        adapter.setList(list)
        return true
    }

    fun updateHideDevice(wifiName: String) {
        deviceHideMap.put(wifiName, SystemClock.elapsedRealtime())
    }


    class DeviceSelectAdapter : BaseQuickAdapter<DreameWifiDeviceBean, BaseViewHolder>(R.layout.item_dialog_bottom_scan_device) {
        override fun convert(baseViewHolder: BaseViewHolder, bean: DreameWifiDeviceBean) {
            val ivDevice = baseViewHolder.getView<ImageView>(R.id.iv_device_icon)
            ImageLoaderProxy.getInstance().displayImage(
                context,
                bean.product_pic_url,
                R.drawable.icon_robot_placeholder,
                ivDevice
            )
            baseViewHolder.setText(R.id.tv_device_name, bean.name)
        }
    }
}