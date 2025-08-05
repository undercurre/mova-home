package com.dreame.smartlife.widget

import android.content.Context
import android.dreame.module.ext.dp
import android.dreame.module.util.GsonUtils
import android.dreame.module.util.SPUtil
import android.dreame.module.util.ScreenUtils
import android.dreame.module.view.SpaceItemDecoration
import android.util.Pair
import android.view.Gravity
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.feature.connect.constant.ExtraConstants
import com.dreame.smartlife.R
import com.google.gson.reflect.TypeToken
import razerdp.basepopup.BasePopupWindow

class ConnectWifiListBottomPopup(context: Context) : BasePopupWindow(context) {

    private lateinit var rv_wifi_list: RecyclerView
    private lateinit var tv_choose_wifi: TextView
    private lateinit var tv_commit: TextView
    private lateinit var adapter: BaseQuickAdapter<Pair<String, String>, BaseViewHolder>
    var onWifiItemClickListener: OnWifiItemClickListener? = null

    init {
        initView()
    }

    private fun initView() {
        popupGravity = Gravity.BOTTOM
        setOutSideDismiss(false)
        setBackPressEnable(false)
        setBackgroundColor(ContextCompat.getColor(context, R.color.common_color_bg_dialog))
        setContentView(R.layout.popup_wifi_list_bottom)
        rv_wifi_list = findViewById(R.id.rv_wifi_list)
        tv_choose_wifi = findViewById(R.id.tv_choose_wifi)
        tv_commit = findViewById(R.id.tv_commit)

        tv_commit.setOnClickListener {
            dismiss()
        }
        tv_choose_wifi.setOnClickListener {
            onWifiItemClickListener?.onItemClick(null, -100)
        }

        val wifiInfoList = mutableListOf<Pair<String, String>>()
        val wifiListStr = SPUtil.get(context, ExtraConstants.SP_KEY_WIFI_LIST, "") as String
        val map =
            GsonUtils.fromJson<LinkedHashMap<String, String>>(wifiListStr, object : TypeToken<LinkedHashMap<String?, String?>?>() {}.type)
        if (map != null) {
            for ((key, value) in map) {
                wifiInfoList.add(Pair<String, String>(key, value))
            }
        }
        wifiInfoList.reverse()
        val layoutParams = rv_wifi_list.getLayoutParams()
        if (wifiInfoList.size > 6) {
            layoutParams.height = ScreenUtils.dp2px(context, 233f)
        } else {
            layoutParams.height = LinearLayout.LayoutParams.WRAP_CONTENT
        }
        adapter = object : BaseQuickAdapter<Pair<String, String>, BaseViewHolder>(R.layout.item_save_wifi, wifiInfoList) {
            override fun convert(holder: BaseViewHolder, item: Pair<String, String>) {
                holder.setText(R.id.tv_wifi_name, item.first)
                holder.setVisible(R.id.iv_wifi, true)
            }

        }
        adapter.setOnItemClickListener { _, _, position: Int ->
            onWifiItemClickListener?.onItemClick(wifiInfoList[position], position)
        }
        rv_wifi_list.addItemDecoration(
            SpaceItemDecoration(
                16.dp(),
                RecyclerView.VERTICAL
            )
        )
        rv_wifi_list.layoutManager = LinearLayoutManager(context)
        rv_wifi_list.adapter = adapter
    }


    interface OnWifiItemClickListener {
        fun onItemClick(data: Pair<String, String>?, position: Int)
    }


}