package com.dreame.smartlife.device.share.manage


import android.dreame.module.RoutPath
import android.dreame.module.data.entry.Device
import android.dreame.module.data.entry.DeviceInfo
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.dp
import android.dreame.module.view.SpaceDecoration
import android.dreame.module.view.SpaceItemDecoration
import android.os.Bundle
import android.text.TextUtils
import android.view.LayoutInflater
import android.widget.TextView
import androidx.fragment.app.viewModels
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.therouter.TheRouter
import com.chad.library.adapter.base.BaseQuickAdapter
import com.chad.library.adapter.base.viewholder.BaseViewHolder
import com.dreame.module.base.mvvm.fragment.BaseVbFragment
import com.dreame.module.service.share.IDeviceShareService
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.databinding.FragmentShareDeviceListBinding
import android.dreame.module.util.toast.ToastUtils
import com.scwang.smartrefresh.layout.api.RefreshLayout
import com.scwang.smartrefresh.layout.listener.OnRefreshLoadMoreListener
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class ShareDeviceListFragment() :
    BaseVbFragment<FragmentShareDeviceListBinding>() {
    private val viewModel by viewModels<ShareDeviceListViewModel>()
    private var adapter: BaseQuickAdapter<Device, BaseViewHolder>? = null


    companion object {
        const val DEVICE_TYPE_SELF = 1 //自己的设备
        const val DEVICE_TYPE_FROM_OTHER = 2 //别人分享的
        private const val DEVICE_TYP = "device_type"

        fun newInstance(type: Int): ShareDeviceListFragment {
            val args = Bundle()
            args.putInt(DEVICE_TYP, type)
            val fragment = ShareDeviceListFragment()
            fragment.arguments = args
            return fragment
        }
    }

    override fun initView() {
        val type = arguments?.getInt(DEVICE_TYP)
        binding.rvDevice.layoutManager = LinearLayoutManager(requireContext())
        binding.rvDevice.addItemDecoration(SpaceItemDecoration(12.dp(), SpaceItemDecoration.LINEARLAYOUT))
        adapter = if (type == DEVICE_TYPE_SELF) {
            SelfDeviceAdapter { did, deviceName, pid, showShareFeature ->
                TheRouter
                    .build(RoutPath.SHARE_DEVICE_USER_LIST)
                    .withString("did", did)
                    .withString("deviceName", deviceName)
                    .withString("pid", pid)
                    .withBoolean("showShareFeature", showShareFeature)
                    .navigation()
            }
        } else {
            FromOtherDeviceAdapter({ did, pid, deviceName, devicePic ->
                TheRouter
                    .build(RoutPath.SHARE_DEVICE_FEATURE_DETAIL)
                    .withString("did", did)
                    .withString("pid", pid)
                    .withString("deviceName", deviceName)
                    .withString("devicePic", devicePic)
                    .navigation()
            }, { device ->
                val masterName: String = device.masterName ?: ""
                val masterUid: String = device.masterUid ?: ""
                val deviceInfo: DeviceInfo? = device.deviceInfo
                if (deviceInfo != null) {
                    val deviceName: String = deviceInfo.displayName ?: ""
                    val user: String = if (TextUtils.isEmpty(masterName)) masterUid else masterName
                    val title =
                        String.format(getString(R.string.device_share_from), user, deviceName)
                    TheRouter.navigation(IDeviceShareService::class.java)
                        .showShareDialog(
                            false,
                            title,
                            deviceInfo.displayName,
                            deviceInfo.remark,
                            deviceInfo.mainImage?.imageUrl,
                            null,
                            -1,
                            device.did,
                            deviceInfo.model,
                            device.masterUid
                        )
                }
            }, {
                viewModel.dispatchAction(ShareDeviceListUiAction.DeleteDeviceAction(it ?: ""))
            })
        }
        val emptyView =
            LayoutInflater.from(requireContext()).inflate(R.layout.layout_share_empty_device, null)
        val tvEmptyMessage = emptyView.findViewById<TextView>(R.id.tv_empty_message)
        tvEmptyMessage.setText(
            if (type == DEVICE_TYPE_SELF) R.string.text_no_device_to_share
            else R.string.text_no_device_from_others
        )
        adapter?.setEmptyView(emptyView)
        binding.rvDevice.adapter = adapter
        binding.refreshLayout.setOnRefreshLoadMoreListener(object : OnRefreshLoadMoreListener {
            override fun onRefresh(refreshLayout: RefreshLayout) {
                viewModel.dispatchAction(ShareDeviceListUiAction.RefreshDeviceListAction(type == DEVICE_TYPE_SELF))
            }

            override fun onLoadMore(refreshLayout: RefreshLayout) {
                viewModel.dispatchAction(ShareDeviceListUiAction.LoadMoreDeviceListAction(type == DEVICE_TYPE_SELF))
            }

        })
    }

    override fun initData(savedInstanceState: Bundle?) {
        val type = arguments?.getInt(DEVICE_TYP)
        viewModel.dispatchAction(
            ShareDeviceListUiAction.RefreshDeviceListAction(
                type == DEVICE_TYPE_SELF
            )
        )

        viewModel.uiStates.observeState(this, ShareDeviceListUiState::deviceList) {
            adapter?.setList(it ?: emptyList())
        }
        viewModel.uiStates.observeState(this, ShareDeviceListUiState::isRefresh) {
            if (!it) {
                binding.refreshLayout.finishRefresh()
            }
        }
        viewModel.uiStates.observeState(this, ShareDeviceListUiState::isLoadingMore) {
            if (!it) {
                binding.refreshLayout.finishLoadMore()
            }
        }
        viewModel.uiStates.observeState(this, ShareDeviceListUiState::enableLoadMore) {
            binding.refreshLayout.setEnableLoadMore(it == true)
        }

        viewModel.uiEvents.observeEvent(this) {
            if (it is ShareDeviceListUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is ShareDeviceListUiEvent.DeleteDeviceSuccess) {
                EventBus.getDefault().post(EventMessage<Any?>(EventCode.DELETE_DEVICE_SUCCESS))
                viewModel.dispatchAction(ShareDeviceListUiAction.RefreshDeviceListAction(type == DEVICE_TYPE_SELF))
            }
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: EventMessage<*>) {
        val type = arguments?.getInt(DEVICE_TYP)
        when (event.code) {
            EventCode.REFRESH_SHARE_MSG,
            EventCode.ACCEPT_OR_REJECT_DEVICE ->
                if (type == DEVICE_TYPE_FROM_OTHER) {
                    viewModel.dispatchAction(ShareDeviceListUiAction.RefreshDeviceListAction(false))
                }

            EventCode.REFRESH_SHARE_MSG,
            EventCode.SHARE_OR_DELETE_DEVICE_SUCCESS ->
                if (type == DEVICE_TYPE_SELF) {
                    viewModel.dispatchAction(ShareDeviceListUiAction.RefreshDeviceListAction(true))
                }
        }
    }

    override fun isRegisteredEventBus(): Boolean {
        return true
    }
}