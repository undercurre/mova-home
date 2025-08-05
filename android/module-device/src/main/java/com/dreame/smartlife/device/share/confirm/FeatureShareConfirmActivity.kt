package com.dreame.smartlife.device.share.confirm

import android.content.Intent
import android.dreame.module.RoutPath
import android.dreame.module.data.entry.device.ShareUserRes
import android.dreame.module.event.EventCode
import android.dreame.module.event.EventMessage
import android.dreame.module.ext.setOnShakeProofClickListener
import android.dreame.module.loader.ImageLoaderProxy
import android.dreame.module.view.CommonTitleView
import android.view.View
import androidx.activity.viewModels
import androidx.recyclerview.widget.LinearLayoutManager
import com.therouter.router.Route
import com.dreame.module.base.mvi.BaseActivity
import com.dreame.smartlife.device.R
import com.dreame.smartlife.device.databinding.ActivityFeatureShareConfirmBinding
import com.dreame.smartlife.device.share.CommonSingleImageDialog
import android.dreame.module.util.toast.ToastUtils
import com.therouter.TheRouter
import com.zj.mvi.core.observeEvent
import com.zj.mvi.core.observeState
import org.greenrobot.eventbus.EventBus

@Route(path = RoutPath.SHARE_DEVICE_SHARE_CONFIRM)
class FeatureShareConfirmActivity : BaseActivity<ActivityFeatureShareConfirmBinding>() {

    private val viewModel by viewModels<FeatureShareConfirmViewModel>()
    private var adapter: FeatureShareConfirmAdapter? = null

    override fun initData() {
        val did = intent?.getStringExtra("did")
        val pid = intent?.getStringExtra("pid")
        val shareUser = intent?.getParcelableExtra<ShareUserRes>("shareUser")
        viewModel.dispatchAction(FeatureShareConfirmUiAction.InitAction(did, pid, shareUser))
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
        binding.btnShare.setOnShakeProofClickListener {
            viewModel.dispatchAction(FeatureShareConfirmUiAction.ShareFeatureAction)
        }
        binding.rvFeatureList.layoutManager = LinearLayoutManager(this)
        adapter = FeatureShareConfirmAdapter { imageUrl, content ->
            showFeatureDescription(imageUrl, content)
        }
        binding.rvFeatureList.adapter = adapter
        viewModel.dispatchAction(FeatureShareConfirmUiAction.RefreshFeatureAction)
    }

    override fun observe() {
        viewModel.uiStates.observeState(this, FeatureShareConfirmUiState::shareUser) {
            it?.let {
                binding.tvNickname.text = it.name
                binding.tvUserId.text = "MOVA ID: ${it.uid}"
                ImageLoaderProxy.getInstance().displayImage(
                    this@FeatureShareConfirmActivity,
                    it.avatar,
                    R.drawable.icon_avatar_default,
                    binding.civAvatar
                )
            }
        }
        viewModel.uiStates.observeState(this, FeatureShareConfirmUiState::featureList) {
            if (it.isNullOrEmpty()) {
                binding.tvFeature.visibility = View.INVISIBLE
                binding.tvFeatureShareTip.visibility = View.INVISIBLE
            } else {
                binding.tvFeature.visibility = View.VISIBLE
                binding.tvFeatureShareTip.visibility = View.VISIBLE
                adapter?.setList(it)
            }
        }
        viewModel.uiStates.observeState(this, FeatureShareConfirmUiState::isLoading) {
            if (it) {
                showLoading()
            } else {
                dismissLoading()
            }
        }

        viewModel.uiEvents.observeEvent(this) {
            if (it is FeatureShareConfirmUiEvent.ShowToast) {
                ToastUtils.show(it.message)
            } else if (it is FeatureShareConfirmUiEvent.SharedSuccess) {
                EventBus.getDefault()
                    .post(EventMessage<Any?>(EventCode.SHARE_OR_DELETE_DEVICE_SUCCESS))

                TheRouter.build(RoutPath.SHARE_DEVICE_USER_LIST)
                    .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    .navigation()
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
}