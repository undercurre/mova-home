package com.dreame.smartlife.device.share.detail

import android.dreame.module.RoutPath
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.view.CommonTitleView
import android.view.View
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.databinding.ActivityFeatureDetailBinding
import com.dreame.smartlife.device.share.CommonSingleImageDialog
import android.dreame.module.util.toast.ToastUtils
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

@Route(path = RoutPath.SHARE_DEVICE_FEATURE_DETAIL)
class FeatureDetailActivity : BaseActivity<ActivityFeatureDetailBinding>() {

    private val viewModel by viewModels<FeatureDetailViewModel>()
    private var adapter: FeatureDetailAdapter? = null

    override fun initData() {
        EventBus.getDefault().register(this)
        val did = intent?.getStringExtra("did")
        val pid = intent?.getStringExtra("pid")
        viewModel.dispatchAction(FeatureDetailUiAction.InitAction(did, pid))
    }

    override fun initView() {

        val deviceName = intent?.getStringExtra("deviceName")
        val devicePic = intent?.getStringExtra("devicePic")
        ImageLoaderProxy.getInstance().displayImage(
            this@FeatureDetailActivity,
            devicePic,
            R.drawable.icon_robot_placeholder,
            binding.civAvatar
        )
        binding.tvNickname.text = deviceName
        binding.titleView.setOnButtonClickListener(object : CommonTitleView.OnButtonClickListener {
            override fun onLeftIconClick() {
                finish()
            }

            override fun onRightIconClick() {

            }

            override fun onRightTextClick() {

            }
        })
        binding.rvFeatureList.layoutManager = LinearLayoutManager(this)
        adapter = FeatureDetailAdapter { imageUrl, content ->
            showFeatureDescription(imageUrl, content)
        }
        binding.rvFeatureList.adapter = adapter
        viewModel.dispatchAction(FeatureDetailUiAction.RefreshFeatureAction)
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, FeatureDetailUiState::featureList) {
            if (it.isNullOrEmpty()) {
                binding.tvFeature.visibility = View.INVISIBLE
                binding.tvFeatureShareTip.visibility = View.INVISIBLE
            } else {
                binding.tvFeature.visibility = View.VISIBLE
                binding.tvFeatureShareTip.visibility = View.VISIBLE
                adapter?.setList(it)
            }
        }

        viewModel.uiEvents.observeEvent(this) {
            if (it is FeatureDetailUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            }
        }
    }

    private fun showFeatureDescription(image: String?, content: String?) {
        val confirmDialog = CommonSingleImageDialog(this)
        confirmDialog.show(
            image,
            content,
            getString(R.string.know)
        ) {
            it.dismiss()
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onEvent(event: EventMessage<*>) {
        when (event.code) {
            EventCode.REFRESH_SHARE_MSG,
            EventCode.SHARE_OR_DELETE_DEVICE_SUCCESS ->
                viewModel.dispatchAction(
                    FeatureDetailUiAction.RefreshFeatureAction
                )
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        EventBus.getDefault().unregister(this)
    }
}