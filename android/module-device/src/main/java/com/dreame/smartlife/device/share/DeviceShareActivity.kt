package com.dreame.smartlife.device.share

import android.dreame.module.RoutPath
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.view.CommonTitleView
import android.view.View
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.alibaba.android.arouter.facade.annotation.Autowired
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.device.databinding.ActivityDeviceShareBinding
import android.dreame.module.util.toast.ToastUtils
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

@Route(path = RoutPath.SHARE_DEVICE_SHARE_CHECK)
class DeviceShareActivity : BaseActivity<ActivityDeviceShareBinding>() {

    private val viewModel by viewModels<DeviceShareViewModel>()
    private var adapter: RecentContactAdapter? = null

    @JvmField
    @Autowired(name = "did")
    var did: String? = ""

    @JvmField
    @Autowired(name = "pid")
    var pid: String? = ""

    override fun initData() {
        TheRouter.inject(this)
        EventBus.getDefault().register(this)
        viewModel.dispatchAction(DeviceShareUiAction.InitAction(did ?: "", pid ?: ""))
    }

    override fun initView() {
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.OnButtonClickListener {
            override fun onLeftIconClick() {
                finish()
            }

            override fun onRightIconClick() {

            }

            override fun onRightTextClick() {

            }

        })
        binding.inputId.addAfterTextChangedListener {
            viewModel.dispatchAction(
                DeviceShareUiAction.InputTextAction(
                    it?.toString() ?: ""
                )
            )
        }
        binding.btnNext.setOnShakeProofClickListener {
            viewModel.dispatchAction(
                DeviceShareUiAction.QueryKeywordAction
            )
        }
        binding.rvContact.layoutManager = LinearLayoutManager(this)
        adapter = RecentContactAdapter() {
            viewModel.dispatchAction(
                DeviceShareUiAction.CheckUserAction(it)
            )
        }
        binding.rvContact.adapter = adapter
        viewModel.dispatchAction(DeviceShareUiAction.QueryRecentContacts)
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, DeviceShareUiState::enableNext) {
            binding.btnNext.isEnabled = it
        }
        viewModel.uiStates.observeState(this, DeviceShareUiState::shareUserList) {
            if (it.isNullOrEmpty()) {
                binding.llContact.visibility = View.INVISIBLE
            } else {
                binding.llContact.visibility = View.VISIBLE
                adapter?.setList(it)
            }
        }
        viewModel.uiStates.observeState(this, DeviceShareUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }

        viewModel.uiEvents.observeEvent(this) {
            if (it is DeviceShareUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is DeviceShareUiEvent.CheckSuccess) {
                TheRouter
                    .build(RoutPath.SHARE_DEVICE_SHARE_CONFIRM)
                    .withString("did", viewModel.uiStates.value.did)
                    .withString("pid", viewModel.uiStates.value.pid)
                    .withParcelable("shareUser", it.shareUser)
                    .navigation()
            }
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: EventMessage<*>) {
        when (event.code) {
            EventCode.SHARE_OR_DELETE_DEVICE_SUCCESS ->
                viewModel.dispatchAction(
                    DeviceShareUiAction.QueryRecentContacts
                )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBus.getDefault().unregister(this)
    }
}