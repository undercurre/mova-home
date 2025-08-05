package com.dreame.feature.connect.device.mower.solution

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.RouteServiceProvider
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.view.CommonTitleView
import android.view.View
import com.therouter.router.Route
import com.therouter.TheRouter
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.module.service.app.flutter.IFlutterBridgeService
import com.dreame.smartlife.connect.R
import com.dreame.smartlife.connect.databinding.ActivityBleConnectFailSolutionBinding

@Route(path = RoutPath.DEVICE_CONNECT_BLE_SOLUTION)
class BleSolutionActivity : BaseActivity<ActivityBleConnectFailSolutionBinding>() {
    companion object {
        const val STEP_PARAM = "step_param"
        const val STEP_CONNECT_FAIL = 1
        const val STEP_NO_PIN_CODE_FAIL = 2
        const val STEP_ROBOT_CONNECT_NET_FAIL = 3
        const val STEP_PAIR_NET_FAIL = 4
        const val STEP_HAS_OWN_FAIL = 5

    }

    private val adapter by lazy {
        object : BaseQuickAdapter<String, BaseViewHolder>(R.layout.item_step_fail_info) {
            override fun convert(holder: BaseViewHolder, item: String) {
                holder.setText(R.id.tv_info, item)
            }
        }
    }

    override fun initData() {

    }

    override fun initView() {
        val step = intent.getIntExtra(STEP_PARAM, 0)
        if (step == STEP_CONNECT_FAIL || step == STEP_NO_PIN_CODE_FAIL) {
            binding.layoutConnect.llRoot.visibility = View.VISIBLE
            binding.layoutBind.llRoot.visibility = View.GONE
        } else {
            binding.layoutConnect.llRoot.visibility = View.GONE
            binding.layoutBind.llRoot.visibility = View.VISIBLE
            binding.layoutBind.recyclerView.adapter = adapter
            val header = View.inflate(this, R.layout.layout_step_fail_info_header, null)
            adapter.addHeaderView(header)

            if (step == STEP_ROBOT_CONNECT_NET_FAIL) {
                val arr3 = resources.getStringArray(R.array.network_config_error_step_mower)
                adapter.setNewInstance(arr3.toMutableList())
            } else if (step == STEP_PAIR_NET_FAIL || step == STEP_HAS_OWN_FAIL) {
                val arr3 = resources.getStringArray(R.array.ble_bind_error_has_own)
                adapter.setNewInstance(arr3.toMutableList())
            }
        }

        binding.titleView.setOnButtonClickListener(object : CommonTitleView.SimpleButtonClickListener() {
            override fun onLeftIconClick() {
                finish()
            }
        })
        binding.tvFeedback.setOnShakeProofClickListener {
            // 问题反馈
            RouteServiceProvider.getService<IFlutterBridgeService>()?.let { flutterBridgeService ->
                val intent = flutterBridgeService.openSubFlutter(this, "/help_center", mutableMapOf())
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
            }
        }
    }

    override fun observe() {
    }


}