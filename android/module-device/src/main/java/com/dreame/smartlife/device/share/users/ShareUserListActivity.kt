package com.dreame.smartlife.device.share.users

import android.dreame.module.RoutPath
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.view.CommonTitleView
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.therouter.router.Route
import com.therouter.TheRouter
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.databinding.ActivityShareUserListBinding
import android.dreame.module.util.toast.ToastUtils
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

@Route(path = RoutPath.SHARE_DEVICE_USER_LIST)
class ShareUserListActivity : BaseActivity<ActivityShareUserListBinding>() {

    private val viewModel by viewModels<ShareUserListViewModel>()
    private var adapter: ShareUserAdapter? = null

    override fun initData() {
        EventBus.getDefault().register(this)

        val did = intent?.getStringExtra("did")
        val deviceName = intent?.getStringExtra("deviceName")
        val pid = intent?.getStringExtra("pid")
        val showShareFeature = intent?.getBooleanExtra("showShareFeature", false)
        viewModel.dispatchAction(
            ShareUserListUiAction.InitAction(
                did = did,
                deviceName = deviceName,
                pid = pid,
                showShareFeature = showShareFeature
            )
        )
    }

    override fun initView() {
        binding.btnShare.setOnShakeProofClickListener {
            TheRouter
                .build(RoutPath.SHARE_DEVICE_SHARE_CHECK)
                .withString("did", viewModel.uiStates.value.did)
                .withString("pid", viewModel.uiStates.value.pid)
                .navigation()
        }
        val deviceName = intent?.getStringExtra("deviceName")
        binding.titleView.setTitle(deviceName)
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.OnButtonClickListener {
            override fun onLeftIconClick() {
                finish()
            }

            override fun onRightIconClick() {

            }

            override fun onRightTextClick() {

            }

        })
        binding.rvUserList.layoutManager = LinearLayoutManager(this)
        adapter = ShareUserAdapter(viewModel.uiStates.value.showShareFeature, {
            if (viewModel.uiStates.value.showShareFeature) {
                TheRouter
                    .build(RoutPath.SHARE_DEVICE_FEATURE_UPDATE)
                    .withString("did", viewModel.uiStates.value.did)
                    .withString("pid", viewModel.uiStates.value.pid)
                    .withParcelable("shareUser", it)
                    .navigation()
            }
        }, { uid ->
            viewModel.dispatchAction(ShareUserListUiAction.DeleteShareUserAction(uid))
        })
//        val emptyView =
//            LayoutInflater.from(this).inflate(R.layout.layout_share_empty_device, null)
//        val tvEmptyMessage = emptyView.findViewById<TextView>(R.id.tv_empty_message)
//        tvEmptyMessage.setText(R.string.device_share_user_list)
//        adapter?.setEmptyView(emptyView)
        binding.rvUserList.adapter = adapter
        binding.refreshLayout.setOnRefreshListener {
            viewModel.dispatchAction(ShareUserListUiAction.RefreshUserListAction)
        }
        viewModel.dispatchAction(ShareUserListUiAction.RefreshUserListAction)
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, ShareUserListUiState::shareUserList) {
            if (it?.isNotEmpty() == true) {
                binding.refreshLayout.visibility = View.VISIBLE
                binding.tvEmptyMessage.visibility = View.GONE
            } else {
                binding.refreshLayout.visibility = View.GONE
                binding.tvEmptyMessage.visibility = View.VISIBLE
            }
            adapter?.setList(it ?: emptyList())
            adapter?.closeAllItems()
        }
        viewModel.uiStates.observeState(this, ShareUserListUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }
        viewModel.uiStates.observeState(this, ShareUserListUiState::isRefresh) {
            if (!it) {
                binding.refreshLayout.finishRefresh()
            }
        }
        viewModel.uiEvents.observeEvent(this) {
            if (it is ShareUserListUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            }
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: EventMessage<*>) {
        when (event.code) {
            EventCode.REFRESH_SHARE_MSG,
            EventCode.SHARE_OR_DELETE_DEVICE_SUCCESS ->
                viewModel.dispatchAction(
                    ShareUserListUiAction.RefreshUserListAction
                )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBus.getDefault().unregister(this)
    }
}